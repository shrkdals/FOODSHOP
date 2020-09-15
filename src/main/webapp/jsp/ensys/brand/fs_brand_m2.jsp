<%@ page import="com.chequer.axboot.core.utils.MessageUtils" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>

<ax:set key="title" value="브랜드마스터"/>
<ax:set key="page_desc" value="${pageRemark}"/>
<ax:set key="page_auto_height" value="true"/>


<ax:layout name="base">
    <jsp:attribute name="script">
        <ax:script-lang key="ax.script"/>
        <style>
            .red {
                background: #ffe0cf !important;
            }
        </style>


        <script type="text/javascript">
            var afterIndex = 0;
            var selectRow2 = 0;
            var selectRow3 = 0;
            var selectRow4 = 0;
            var beforeIdx = 0;

            var DATA_BRCODE = getbrcode(); //분류코드
            var DATA_VERIFY = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'MA00005'); //검증상태
            var DATA_YN = [{value: '', text: ''}, {value: 'Y', text: 'Y'}, {value: 'N', text: 'N'}]; // YN
            var PT_SP = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'MA00002');

            $("#S_BRCODE").ax5select({options: DATA_BRCODE}); //분류코드
            $("#S_RECOMMENDYN").ax5select({options: DATA_YN}); //추천여부
            $("#S_NEWYN").ax5select({options: DATA_YN}); //신규여부
            $("#S_VERIFY").ax5select({options: DATA_VERIFY}); //검증상태
            //$("#CG_CD").ax5select({options: DATA_BRCODE}); //분류코드
            $("#CG_CD").ax5select({options: [{value: 'CUMM00006', text:'본사별샵인샵브랜드'}]}); //분류코드
            $("#VERIFY_STAT").ax5select({options: DATA_VERIFY}); //검증상태
            $("#USE_YN").ax5select({options: DATA_YN}); //사용여부
            $("#RECOMM_YN").ax5select({options: DATA_YN}); //추천여부
            $("#NEW_YN").ax5select({options: DATA_YN}); //신규여부

            var CallBack1;
            var fnObj = {}, CODE = {};
            var ACTIONS = axboot.actionExtend(fnObj, {
                //조회버튼
                PAGE_SEARCH: function (caller, act, data) {
                    axboot.ajax({
                        type: "POST",
                        url: ["Brandm", "selectBrandM"],
                        data: JSON.stringify({
                            COMPANY_CD: SCRIPT_SESSION.cdCompany //회사코드
                            , CG_CD: $('select[name="S_BRCODE"]').val() //분류코드
                            , ADM_PT_CD: $('#S_PARTNER').getCodes() //관리거래처
                            , RECOMM_YN: $('select[name="S_RECOMMENDYN"]').val() //추천여부
                            , NEW_YN: $('select[name="S_NEWYN"]').val() //신규여부
                            , VERIFY_STAT: $('select[name="S_VERIFY"]').val() //검증상태
                            , BRD_NM: $('#S_BRANDNAME').val() //브랜드명
                        }),
                        callback: function (res) {
                            fnObj.gridView01.target.setData(res.list);
                            if (res.list.length <= afterIndex) {
                                afterIndex = 0
                            }
                            caller.gridView01.target.focus(afterIndex);
                            caller.gridView01.target.select(afterIndex);

                            ACTIONS.dispatch(ACTIONS.ITEM_CLICK);
                            selectRow2 = 0;
                            selectRow3 = 0;
                            selectRow4 = 0;
                        }
                    });
                },
                ITEM_CLICK: function (caller, act, data) {
                    //그리드,우측컨트롤 동기화(setFormData) 컨트롤ID, 그리드컬럼명일치시킬것
                    var selected = nvl(caller.gridView01.getData('selected')[0], {});
                    var list = $.DATA_SEARCH('commonHelp', 'COMMON_PRC' , {PRC_TYPE : 'PT_CATE_SEARCH' , PARAM_STRING_1 : selected.ADM_PT_CD }).list
                    $("#CATE_CD").ax5select({options: [{value:'' , text : ''}].concat(list)}); //분류코드
                    $('.QRAY_FORM').setFormData(selected);

                    $("#BRD_NOTICE").val(nvl(selected.BRD_NOTICE, '').replace(/(<br>|<br\/>|<br \/>)/g, '\r\n'));
                    $("#BRD_GOOD").val(nvl(selected.BRD_GOOD, '').replace(/(<br>|<br\/>|<br \/>)/g, '\r\n'));
                    fnObj.gridView02.target.setData($.DATA_SEARCH('Brandm', 'selectBrandMenu', nvl(selected, {})));
                    fnObj.gridView04.target.setData($.DATA_SEARCH('Brandm', 'selectBrandBeginItem', nvl(selected, {})));
                    fnObj.gridView05.target.setData($.DATA_SEARCH('Brandm', 'selectBrandItemCategory', nvl(selected, {})));


                    axboot.ajax({
                        type: "POST",
                        url: ["Brandm", "selectBrandPredicSaleM"],
                        data: JSON.stringify(nvl(selected, {})),
                        callback: function (res) {
                            fnObj.gridView03M.target.setData(res.list);
                            if (res.list.length < selectRow3) {
                                selectRow3 = 0
                            }
                            caller.gridView03M.target.focus(0);
                            caller.gridView03M.target.select(0);

                            ACTIONS.dispatch(ACTIONS.ITEM_CLICK2);
                        }
                    });

                },
                ITEM_CLICK2: function(caller, act, data){
                    var selected = nvl(caller.gridView01.getData('selected')[0], {});
                    var selected2 = nvl(caller.gridView03M.getData('selected')[0], {});

                    axboot.ajax({
                        type: "POST",
                        url: ["Brandm", "selectBrandPredicSaleD"],
                        data: JSON.stringify({
                            COMPANY_CD : SCRIPT_SESSION.cdCompany,
                            BRD_CD : nvl(selected.BRD_CD),
                            BRD_MENU_CD: nvl(selected2.BRD_MENU_CD)
                        }),
                        callback: function (res) {
                            fnObj.gridView03D.target.setData(res.list);
                            fnObj.gridView03D.target.select(0);
                        }
                    });
                },
                //저장버튼
                PAGE_SAVE: function (caller, act, data) {
                    var grid = caller.gridView01.getData("modified");

                    for (var i = 0; i < grid.length; i++) {

                        if (nvl(grid[i].BRD_CD) == '') {
                            qray.alert("브랜드코드는 필수입니다.");
                            return false;
                        }
                        /* if (nvl(grid[i].CG_CD) == '') {
                            qray.alert("분류코드는 필수입니다.");
                            return false;
                        } */
                        if (nvl(grid[i].BRD_NM) == '') {
                            qray.alert("브랜드명 필수입니다.");
                            return false;
                        }
                        if (nvl(grid[i].ADM_PT_CD) == '') {
                            qray.alert("관리거래처코드는 필수입니다.");
                            return false;
                        }
                        if (nvl(grid[i].VERIFY_STAT) == '') {
                            qray.alert("검증상태는 필수입니다.");
                            return false;
                        }
                        if (nvl(grid[i].USE_YN) == '') {
                            qray.alert("사용여부는 필수입니다.");
                            return false;
                        }
                    }

                    if (caller.gridView04.getData("modified").length > 0){
                    	for (var i = 0 ; i < caller.gridView04.target.list.length ; i++){
                        	for (var i2 = 0 ; i2 < caller.gridView04.target.list.length ; i2++){
    							if (i==i2) continue;
    							var grid = caller.gridView04.target.list;
    							if (grid[i].ITEM_CD == grid[i2].ITEM_CD){
    								qray.alert('초도물품 데이터 입력 중<br>중복되는 상품을 입력하셨습니다.<br> <' + grid[i].ITEM_NM + '>');
    								return;
    							}
                        	}
                        }
                    }
                    

                    if (caller.gridView05.getData("modified").length > 0){
	                    for (var i = 0 ; i < caller.gridView05.target.list.length ; i++){
	                    	for (var i2 = 0 ; i2 < caller.gridView05.target.list.length ; i2++){
								if (i==i2) continue;
								var grid = caller.gridView05.target.list;
								if (grid[i].ITEM_CD == grid[i2].ITEM_CD){
									qray.alert('브랜드상품 데이터 입력 중<br>중복되는 상품을 입력하셨습니다.<br> <' + grid[i].ITEM_NM + '>');
									return;
								}
	                    	}
	                    }
                    }

                    var itemH = [].concat(caller.gridView01.getData("modified"));
                    itemH = itemH.concat(caller.gridView01.getData("deleted"));
                    itemH = itemH.concat(caller.gridView02.getData("modified"));
                    itemH = itemH.concat(caller.gridView02.getData("deleted"));
                    itemH = itemH.concat(caller.gridView03M.getData("modified"));
                    itemH = itemH.concat(caller.gridView03M.getData("deleted"));
                    itemH = itemH.concat(caller.gridView03D.getData("modified"));
                    itemH = itemH.concat(caller.gridView03D.getData("deleted"));
                    itemH = itemH.concat(caller.gridView04.getData("modified"));
                    itemH = itemH.concat(caller.gridView04.getData("deleted"));
                    itemH = itemH.concat(caller.gridView05.getData("modified"));
                    itemH = itemH.concat(caller.gridView05.getData("deleted"));

                    if (itemH.length == 0) {
                        qray.alert('변경된 정보가 없습니다.');
                        return;
                    }

                    qray.confirm({
                        msg: "저장하시겠습니까?"
                    }, function () {
                        if (this.key == "ok") {
                            axboot.ajax({
                                type: "PUT",
                                url: ["Brandm", "save"],
                                data: JSON.stringify({
                                    brand_m: [].concat(caller.gridView01.getData("modified")).concat(caller.gridView01.getData("deleted")),
                                    brand_menu: [].concat(caller.gridView02.getData("modified")).concat(caller.gridView02.getData("deleted")),
                                    brand_predic_sale_m: [].concat(caller.gridView03M.getData("modified")).concat(caller.gridView03M.getData("deleted")),
                                    brand_predic_sale_d: [].concat(caller.gridView03D.getData("modified")).concat(caller.gridView03D.getData("deleted")),
                                    brand_begin_item: [].concat(caller.gridView04.getData("modified")).concat(caller.gridView04.getData("deleted")),
                                    brand_item_category: [].concat(caller.gridView05.getData("modified")).concat(caller.gridView05.getData("deleted")),
                                    file_main: caller.gridView01.target.list[caller.gridView01.getData("selected")[0].__index]['BIMG00001'],
                                    file_dtl: caller.gridView01.target.list[caller.gridView01.getData("selected")[0].__index]['BDTL00001'],
                                    file_logo: caller.gridView01.target.list[caller.gridView01.getData("selected")[0].__index]['BLOG00001']
                                }),
                                callback: function (res) {
                                    qray.alert("저장 되었습니다.").then(function () {
                                        ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                                        caller.gridView01.target.focus(afterIndex);
                                        caller.gridView01.target.select(afterIndex);

                                    });
                                }
                            });
                        }
                    });
                },
                //그리드로우클릭

                //상단추가버튼
                ITEM_ADD1: function (caller, act, data) {
                    caller.gridView01.addRow();
                    var lastIdx = nvl(caller.gridView01.target.list.length, caller.gridView01.lastRow());
                    caller.gridView01.target.focus(lastIdx - 1);
                    caller.gridView01.target.select(lastIdx - 1);


                    var pt = getLoginPartner();
                    afterIndex = lastIdx - 1;
                    caller.gridView01.target.setValue(lastIdx - 1, "BRD_CD", GET_NO('BRD', '01'));
                    caller.gridView01.target.setValue(lastIdx - 1, "CG_CD", 'CT00002');
                    caller.gridView01.target.setValue(lastIdx - 1, "ADM_PT_CD", pt[0].PT_CD);
                    caller.gridView01.target.setValue(lastIdx - 1, "ADM_PT_NM", pt[0].PT_NM);
                    caller.gridView01.target.setValue(lastIdx - 1, "CG_CD", 'CUMM00006');
                    caller.gridView01.target.setValue(lastIdx - 1, "CG_NM", '본사별샵인샵브랜드');
                    $('#ADM_PT_CD').attr('HELP_DISABLED' , 'true')

                    var list = $.DATA_SEARCH('commonHelp', 'COMMON_PRC' , {PRC_TYPE : 'PT_CATE_SEARCH' , PARAM_STRING_1 : pt[0].PT_CD }).list


                    $("#CATE_CD").ax5select({options: [{value:'' , text : ''}].concat(list)}); //분류코드
                    ACTIONS.dispatch(ACTIONS.ITEM_CLICK);
                },
                FILE_CLICK: function (caller, act, data) {

                    modal.open({
                        width: 1100,
                        height: _pop_height800,
                        top: _pop_top800,
                        iframe: {
                            method: "get",
                            url: "../../common/FileCanvas.jsp",
                            param: "callBack=userCallBack"
                        },
                        sendData: function () {
                            return {
                                initData: data
                            }
                        },
                        onStateChanged: function () {
                            if (this.state === "open") {
                                mask.open({
                                    content: '<h1><i class="fa fa-spinner fa-spin"></i> Loading</h1>'
                                });
                            } else if (this.state === "close") {
                                mask.close();
                            }
                        }
                    }, function () {

                    });
                },
                ITEM_DEL1: function (caller, act, data) {
                    fnObj.gridView01.delRow("selected");
                },
            });
            // fnObj 기본 함수 스타트와 리사이즈
            fnObj.pageStart = function () {
                this.pageButtonView.initView();
                this.gridView01.initView();
                this.gridView02.initView();
                this.gridView03M.initView();
                this.gridView03D.initView();
                this.gridView04.initView();
                this.gridView05.initView();

                ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                changesize();
            };

            fnObj.pageButtonView = axboot.viewExtend({
                initView: function () {
                    axboot.buttonClick(this, "data-page-btn", {
                        "search": function () {
                            ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                        },
                        "save": function () {
                            ACTIONS.dispatch(ACTIONS.PAGE_SAVE);
                        },
                        "delete": function () {
                            var beforeIdx = fnObj.gridView01.target.selectedDataIndexs[0];
                            var dataLen = fnObj.gridView01.target.getList().length;

                            if ((beforeIdx + 1) == dataLen) {
                                beforeIdx = beforeIdx - 1;
                            }
                            ACTIONS.dispatch(ACTIONS.ITEM_DEL1);
                            afterIndex = beforeIdx;
                            fnObj.gridView01.target.focus(beforeIdx);
                            fnObj.gridView01.target.select(beforeIdx);

                            ACTIONS.dispatch(ACTIONS.ITEM_CLICK);
                        },
                    });
                }
            });


            /**
             * gridView01
             */
            fnObj.gridView01 = axboot.viewExtend(axboot.gridView, {
                page: {
                    pageNumber: 0,
                    pageSize: 10
                },
                initView: function () {
                    var _this = this;

                    this.target = axboot.gridBuilder({
                        showRowSelector: true,
                        frozenColumnIndex: 2,
                        target: $('[data-ax5grid="grid-view-01"]'),
                        columns: [
                            {
                                key: "COMPANY_CD",
                                label: "회사코드",
                                width: 150,
                                align: "left",
                                editor: {type: "text"},
                                hidden: true
                            },
                            {key: "BRD_CD", label: "브랜드코드", width: 110, align: "center", editor: false, sortable:true},
                            {key: "BRD_NM", label: "브랜드명", width: 150, align: "left", editor: false, sortable:true},
                            {
                                key: "CG_CD", label: "분류코드", width: 100, align: "center", sortable:true,
                                formatter: function () {
                                    return $.changeTextValue(DATA_BRCODE, this.value)
                                }, editor: {
                                    type: "select", config: {
                                        columnKeys: {
                                            optionValue: "value", optionText: "text"
                                        },
                                        options: DATA_BRCODE
                                    }, disabled: function () {
                                        return true;
                                    }
                                }
                            },
                            {key: "ADM_PT_CD", label: "관리거래처코드", width: 110, align: "center", editor: false, sortable:true},
                            {key: "ADM_PT_NM", label: "관리거래처명", width: 150, align: "left", editor: false, sortable:true},
                            {
                                key: "VERIFY_STAT", label: "검증상태", width: 90, align: "center", sortable:true,
                                formatter: function () {
                                    return $.changeTextValue(DATA_VERIFY, this.value)
                                },
                                editor: {
                                    type: "select",
                                    config: {
                                        columnKeys: {optionValue: "value", optionText: "text"},
                                        options: DATA_VERIFY
                                    }, disabled: function () {
                                        return true;
                                    }
                                }
                            },
                            {
                                key: "USE_YN", label: "사용여부", width: 80, align: "center", sortable:true,
                                formatter: function () {
                                    return $.changeTextValue(DATA_YN, this.value)
                                }, editor: {
                                    type: "select", config: {
                                        columnKeys: {
                                            optionValue: "value", optionText: "text"
                                        },
                                        options: DATA_YN
                                    }, disabled: function () {
                                        return true;
                                    }
                                }
                            },
                            {
                                key: "RECOMM_YN", label: "추천여부", width: 80, align: "center", sortable:true,
                                formatter: function () {
                                    return $.changeTextValue(DATA_YN, this.value)
                                }
                                , editor: {
                                    type: "select", config: {
                                        columnKeys: {
                                            optionValue: "value", optionText: "text"
                                        },
                                        options: DATA_YN
                                    }, disabled: function () {
                                        return true;

                                    }
                                }
                            }
                            , {key: "RECOMM_ORD", label: "추천순서", width: 80, align: "center", sortable:true,}
                            , {
                                key: "NEW_YN", label: "신규여부", width: 80, align: "center", sortable:true,
                                formatter: function () {
                                    return $.changeTextValue(DATA_YN, this.value)
                                }
                                , editor: {
                                    type: "select", config: {
                                        columnKeys: {
                                            optionValue: "value", optionText: "text"
                                        },
                                        options: DATA_YN
                                    }, disabled: function () {
                                        return true;

                                    }
                                }
                            }
                            , {
                                key: "NEW_ORD", label: "신규순서", width: 80, align: "center", sortable:true,}
                            , {
                                key: "BLOG00001",
                                label: "브랜드로고",
                                width: 150,
                                align: "center",
                                editor: {type: "text"},
                                hidden: true
                            }
                            , {
                                key: "BIMG00001",
                                label: "브랜드메인",
                                width: 150,
                                align: "center",
                                editor: {type: "text"},
                                hidden: true
                            }
                            , {
                                key: "BDTL00001",
                                label: "브랜드상세",
                                width: 150,
                                align: "center",
                                editor: {type: "text"},
                                hidden: true
                            }
                            , {
                                key: "LOGO_FILE_NM",
                                label: "",
                                width: 150,
                                align: "center",
                                editor: {type: "text"},
                                hidden: true
                            }
                            , {
                                key: "MAIN_FILE_NM",
                                label: "",
                                width: 150,
                                align: "center",
                                editor: {type: "text"},
                                hidden: true
                            }
                            , {
                                key: "DTL_FILE_NM",
                                label: "",
                                width: 150,
                                align: "center",
                                editor: {type: "text"},
                                hidden: true
                            }
                            , {
                                key: "BRD_GOOD",
                                label: "브랜드장점",
                                width: 150,
                                align: "center",
                                editor: {type: "text"},
                                hidden: true
                            }
                            , {
                                key: "BRD_NOTICE",
                                label: "브랜드공지사항",
                                width: 150,
                                align: "center",
                                editor: {type: "text"},
                                hidden: true
                            }
                            , {
                                key: "PROMT_LINK",
                                label: "홍보영상링크",
                                width: 150,
                                align: "center",
                                editor: {type: "text"},
                                hidden: true
                            }
                            ,{key: "CATE_CD", label: "카테고리코드", width: 110, alig: "center", editor: false, sortable:true}
                        ],

                        body: {
                            onDataChanged: function () {

                            },
                            //444
                            onClick: function () {
                                var index = this.dindex;
                                if (afterIndex == index) {
                                    return false;
                                }

                                var data = [];
                                //data = [].concat(fnObj.gridView01.getData("modified"));
                                //data = data.concat(fnObj.gridView01.getData("deleted"));
                                data = data.concat(fnObj.gridView02.getData("modified"));
                                data = data.concat(fnObj.gridView02.getData("deleted"));
                                data = data.concat(fnObj.gridView03M.getData("modified"));
                                data = data.concat(fnObj.gridView03M.getData("deleted"));
                                data = data.concat(fnObj.gridView03D.getData("modified"));
                                data = data.concat(fnObj.gridView03D.getData("deleted"));
                                data = data.concat(fnObj.gridView04.getData("modified"));
                                data = data.concat(fnObj.gridView04.getData("deleted"));
                                data = data.concat(fnObj.gridView05.getData("modified"));
                                data = data.concat(fnObj.gridView05.getData("deleted"));

                                if (data.length > 0) {
                                    qray.confirm({
                                        msg: "작업중인 데이터를 먼저 저장해주십시오."
                                        , btns: {
                                            cancel: {
                                                label: '확인', onClick: function (key) {
                                                    qray.close();
                                                }
                                            }
                                        }
                                    })
                                } else {
                                    afterIndex = index;
                                    this.self.select(this.dindex);
                                    ACTIONS.dispatch(ACTIONS.ITEM_CLICK, this.item);
                                }

                            }
                        },
                        onPageChange: function (pageNumber) {
                            _this.setPageData({pageNumber: pageNumber});
                            ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                        },
                        page: {
                            display: false,
                            statusDisplay: false
                        }
                    });
                    axboot.buttonClick(this, "data-grid-view-01-btn", {
                        "delete": function () {
                            var beforeIdx = fnObj.gridView01.target.selectedDataIndexs[0];
                            var dataLen = fnObj.gridView01.target.getList().length;

                            if ((beforeIdx + 1) == dataLen) {
                                beforeIdx = beforeIdx - 1;
                            }
                            ACTIONS.dispatch(ACTIONS.ITEM_DEL1);
                            fnObj.gridView01.target.select(beforeIdx);
                            ACTIONS.dispatch(ACTIONS.ITEM_CLICK);
                        },
                        "add": function () {
                            var chekVal;
                            $(fnObj.gridView01.target.list).each(function (i, e) {
                                /*if (e.__modified__) {
                                    chekVal = true;
                                }*/
                                if (e.__created__) {
                                    chekVal = true;
                                }
                            });


                            if (chekVal) {
                                qray.alert("작업중인 데이터가 있습니다. 저장 후 진행하세요");
                                return;
                            }
                            ACTIONS.dispatch(ACTIONS.ITEM_ADD1);
                        }
                    });
                },
                getData: function (_type) {
                    var list = [];
                    var _list = this.target.getList(_type);
                    list = _list;
                    return list;
                },
                getCheckData: function () {
                    var list = [];
                    $(this.target.getList()).each(function () {
                        if (this.s == "Y") {
                            list.push(this);
                        }
                    });
                    return list;
                },
                addRow: function () {
                    this.target.addRow({__created__: true}, "last");
                },
                lastRow: function () {
                    return ($("div [data-ax5grid='grid-view-01']").find("div [data-ax5grid-panel='body'] table tr").length)
                }
                , sort: function () {
                }

            });

            /**
             * gridView02
             */
            fnObj.gridView02 = axboot.viewExtend(axboot.gridView, {
                page: {
                    pageNumber: 0,
                    pageSize: 10
                },
                initView: function () {
                    var _this = this;

                    this.target = axboot.gridBuilder({
                        showRowSelector: true,
                        frozenColumnIndex: 0,
                        target: $('[data-ax5grid="grid-view-02"]'),
                        columns: [
                            {
                                key: "COMPANY_CD",
                                label: "",
                                width: 150,
                                align: "left",
                                editor: {type: "text"},
                                hidden: true
                            }
                            , {key: "BRD_CD", label: "브랜드코드", width: 150, align: "center", editor: false, hidden: true}
                            , {key: "BRD_MENU_CD", label: "브랜드메뉴코드", width: 150, align: "center", hidden: false}
                            , {
                                key: "BRD_MENU_NM",
                                label: "브랜드메뉴명",
                                width: 150,
                                align: "center",
                                editor: {type: "text"},
                                hidden: false
                            }
                            , {
                                key: "SAMPLE_AMT",
                                label: "샘플금액",
                                width: 150,
                                align: "right",
                                editor: {type: "number"},
                                formatter: function () {
                                    if (nvl(this.item.SAMPLE_AMT) == '') {
                                        this.item.SAMPLE_AMT = 0;
                                    }
                                    this.item.SAMPLE_AMT = Number(this.item.SAMPLE_AMT);
                                    return comma(this.item.SAMPLE_AMT);
                                }
                            },
                            {key: "MENU_IMG", label: "메뉴이미지", width: 150 , align: "center" , editor: false, sortable: true,},
                            {key: "MENU_FILE", label: "메뉴이미지", width: 150, align: "center", hidden:true},
                            
                        ],
                        body: {
                            onClick: function () {
                                var data = this.item;           //  선택한 ROW의 ITEM들
                                var column = this.column.key;   //  컬럼 KEY명
                                var idx = this.dindex;          //  선택한 ROW의 INDEX

                                selectRow2 = idx;
                                this.self.select(selectRow2);
                            },
                            onDBLClick: function () {
                                var column = this.column.key;
                                if (column == 'MENU_IMG'){
                                    var selected = fnObj.gridView02.getData('selected')[0];

                                    userCallBack = function (e) {
                                        e['TB_ID'] = 'FS_BRAND_M';
                                        e['CG_CD'] = 'BMENU00001';
                                        e['TB_KEY'] = selected.BRD_MENU_CD;

                                        fnObj.gridView02.target.setValue(selected.__index, 'MENU_IMG', e.ORGN_FILE_NAME);
                                        fnObj.gridView02.target.list[selected.__index]['MENU_FILE'] = e;
                                    };

                                    var data = {
                                        TB_ID: 'FS_BRAND_M',
                                        CG_CD: 'BMENU00001',
                                        TB_KEY: selected['BRD_MENU_CD'],
                                        FILE_PATH: 'brand/MENU',
                                        CALL_BACK: selected['FILE']
                                    }

                                    modal.open({
                                        width: 1100,
                                        height: _pop_height800,
                                        top: _pop_top800,
                                        iframe: {
                                            method: "get",
                                            url: "../../common/FileCanvas.jsp",
                                            param: "callBack=userCallBack"
                                        },
                                        sendData: function () {
                                            return {
                                                initData: data
                                            }
                                        },
                                        onStateChanged: function () {
                                            if (this.state === "open") {
                                                mask.open({
                                                    content: '<h1><i class="fa fa-spinner fa-spin"></i> Loading</h1>'
                                                });
                                            } else if (this.state === "close") {
                                                mask.close();
                                            }
                                        }
                                    }, function () {

                                    });
                                }
                            }
                        },
                        onPageChange: function (pageNumber) {
                            _this.setPageData({pageNumber: pageNumber});
                            ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                        },
                        page: {
                            display: false,
                            statusDisplay: false
                        }
                    });

                    axboot.buttonClick(this, "data-grid-view-02-btn", {
                        "add": function () {
                            if (fnObj.gridView01.getData('selected').length == 0) {
                                qray.alert("선택된 브랜드가 없습니다.");
                                return;
                            }
                            fnObj.gridView02.addRow();
                            var BRD_CD = fnObj.gridView01.getData('selected')[0].BRD_CD;
                            var lastIdx = nvl(fnObj.gridView02.target.list.length, fnObj.gridView02.lastRow());
                            fnObj.gridView02.target.focus(lastIdx - 1);
                            fnObj.gridView02.target.select(lastIdx - 1);

                            fnObj.gridView02.target.setValue(lastIdx - 1, "BRD_CD", BRD_CD);
                            fnObj.gridView02.target.setValue(lastIdx - 1, "BRD_MENU_CD", GET_NO('BRD', '02'));
                        },
                        "delete": function () {

                            var beforeIdx = this.target.selectedDataIndexs[0];
                            var dataLen = this.target.getList().length;

                            if ((beforeIdx + 1) == dataLen) {
                                beforeIdx = beforeIdx - 1;
                            }

                            var item = fnObj.gridView02.getData('selected')[0]

                            fnObj.gridView02.delRow("selected");
                            if (beforeIdx > 0 || beforeIdx == 0) {
                                this.target.select(beforeIdx);
                            }

                        }

                    });
                },
                getData: function (_type) {
                    var list = [];
                    var _list = this.target.getList(_type);
                    list = _list;

                    return list;
                },
                addRow: function () {
                    this.target.addRow({__created__: true}, "last");
                },
                lastRow: function () {
                    return ($("div [data-ax5grid='grid-view-02']").find("div [data-ax5grid-panel='body'] table tr").length)
                }
            });

            /**
             * gridView03
             */
            fnObj.gridView03M = axboot.viewExtend(axboot.gridView, {
                page: {
                    pageNumber: 0,
                    pageSize: 10
                },
                initView: function () {
                    var _this = this;

                    this.target = axboot.gridBuilder({
                        showRowSelector: true,
                        frozenColumnIndex: 0,
                        target: $('[data-ax5grid="grid-view-03_M"]'),
                        columns: [
                            {key: "COMPANY_CD", label: "사업장코드", width: 150, align: "center", hidden: true},
                            {key: "BRD_CD", label: "브랜드코드", width: 150, align: "center", hidden: true},
                            {key: "BRD_MENU_CD", label: "브랜드메뉴코드", width: 150, align: "center", hidden: false},
                            {key: "BRD_MENU_NM", label: "브랜드메뉴명", width: 150, align: "left", editor: {type: "text"}, hidden: false},
                            {key: "SALE_SUM", label: "판매 합", width: 150, align: "right", hidden: false,
                                editor: {type: "number"},
                                formatter: function () {
                                    if (nvl(this.item.SALE_SUM) == '') {
                                        this.item.SALE_SUM = 0;
                                    }
                                    this.item.SALE_SUM = Number(this.item.SALE_SUM);
                                    return comma(this.item.SALE_SUM);
                                }
                            },
                            {key: "PRICE_SUM", label: "원가 합", width: 150, align: "right", hidden: false,
                                editor: {type: "number"},
                                formatter: function () {
                                    if (nvl(this.item.PRICE_SUM) == '') {
                                        this.item.PRICE_SUM = 0;
                                    }
                                    this.item.PRICE_SUM = Number(this.item.PRICE_SUM);
                                    return comma(this.item.PRICE_SUM);
                                }
                            },
                            {key: "INSERT_ID", label: "처리자아이디", width: 150, align: "center", hidden: true},
                            {key: "INSERT_DT", label: "처리일자", width: 150, align: "center", hidden: true},
                            {key: "UPDATE_ID", label: "수정자아이디", width: 150, align: "center", hidden: true},
                            {key: "UPDATE_DT", label: "수정일자", width: 150, align: "center", hidden: true}
                        ],
                        body: {
                            onClick: function () {
                                var data = this.item;           //  선택한 ROW의 ITEM들
                                var column = this.column.key;   //  컬럼 KEY명
                                var idx = this.dindex;          //  선택한 ROW의 INDEX
                                if (selectRow3 == idx) {
                                    return false;
                                }
                                var data = [].concat(fnObj.gridView03D.getData("modified"));
                                data = data.concat(fnObj.gridView03D.getData("deleted"));

                                if (data.length > 0) {
                                    qray.confirm({
                                        msg: "작업중인 데이터를 먼저 저장해주십시오."
                                        , btns: {
                                            cancel: {
                                                label: '확인', onClick: function (key) {
                                                    qray.close();
                                                }
                                            }
                                        }
                                    })
                                } else {
                                    selectRow3 = idx;
                                    this.self.select(selectRow3);
                                    ACTIONS.dispatch(ACTIONS.ITEM_CLICK2);
                                }
                            }
                        },
                        onPageChange: function (pageNumber) {
                            _this.setPageData({pageNumber: pageNumber});
                            ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                        },
                        page: {
                            display: false,
                            statusDisplay: false
                        }
                    });

                    axboot.buttonClick(this, "data-grid-view-03-m-btn", {
                        "add": function () {
                            if (fnObj.gridView01.getData('selected').length == 0) {
                                qray.alert("선택된 브랜드가 없습니다.");
                                return;
                            }
                            var chekVal;
                            $(fnObj.gridView03D.target.list).each(function (i, e) {
                                if (e.__modified__) {
                                    chekVal = true;
                                }
                                if (e.__created__) {
                                    chekVal = true;
                                }
                            });
                            if (fnObj.gridView03D.getData('deleted').length > 0){
                                chekVal = true;
                            }

                            if (chekVal) {
                                qray.alert("작업중인 데이터가 있습니다. 저장 후 진행하세요");
                                return;
                            }

                            fnObj.gridView03M.addRow();
                            fnObj.gridView03D.clear();
                            var BRD_CD = fnObj.gridView01.getData('selected')[0].BRD_CD;
                            var lastIdx = nvl(fnObj.gridView03M.target.list.length, fnObj.gridView03M.lastRow());
                            selectRow3 = lastIdx;
                            fnObj.gridView03M.target.focus(lastIdx - 1);
                            fnObj.gridView03M.target.select(lastIdx - 1);

                            fnObj.gridView03M.target.setValue(lastIdx - 1, "BRD_CD", BRD_CD);
                            fnObj.gridView03M.target.setValue(lastIdx - 1, "BRD_MENU_CD", GET_NO('BRD', '04'));

                        },
                        "delete": function () {

                            var beforeIdx = this.target.selectedDataIndexs[0];
                            var dataLen = this.target.getList().length;

                            if ((beforeIdx + 1) == dataLen) {
                                beforeIdx = beforeIdx - 1;
                            }

                            var item = fnObj.gridView03M.getData('selected')[0]

                            fnObj.gridView03M.delRow("selected");
                            if (beforeIdx > 0 || beforeIdx == 0) {
                                this.target.select(beforeIdx);
                                selectRow3 = beforeIdx;
                            }
                            ACTIONS.dispatch(ACTIONS.ITEM_CLICK2);
                        }

                    });
                },
                getData: function (_type) {
                    var list = [];
                    var _list = this.target.getList(_type);
                    list = _list;

                    return list;
                },
                addRow: function () {
                    this.target.addRow({__created__: true}, "last");
                },
                lastRow: function () {
                    return ($("div [data-ax5grid='grid-view-03']").find("div [data-ax5grid-panel='body'] table tr").length)
                }
            });

            /**
             * gridView03
             */
            fnObj.gridView03D = axboot.viewExtend(axboot.gridView, {
                page: {
                    pageNumber: 0,
                    pageSize: 10
                },
                initView: function () {
                    var _this = this;

                    this.target = axboot.gridBuilder({
                        showRowSelector: true,
                        frozenColumnIndex: 0,
                        target: $('[data-ax5grid="grid-view-03_D"]'),
                        columns: [
                            {key: "COMPANY_CD", label: "사업장코드", width: 150, align: "center", hidden: true},
                            {key: "BRD_CD", label: "브랜드코드", width: 150, align: "center", hidden: true},
                            {key: "BRD_MENU_CD", label: "브랜드메뉴코드", width: 150, align: "center", hidden: true},
                            {key: "ITEM_CD", label: "상품코드", width: 150, align: "center", hidden: false},
                            {key: "ITEM_NM", label: "상품명", width: 150, align: "center", editor: {type: "text"}, hidden: false},
                            {key: "SALE_COST", label: "판매가", width: 150, align: "right",  hidden: true,
                                editor: {type: "number"},
                                formatter: function () {
                                    if (nvl(this.item.SALE_COST) == '') {
                                        this.item.SALE_COST = 0;
                                    }
                                    this.item.SALE_COST = Number(this.item.SALE_COST);
                                    return comma(this.item.SALE_COST);
                                }
                            },
                            {key: "ITEM_COST", label: "원가", width: 150, align: "right",  hidden: false,
                                editor: {type: "number"},
                                formatter: function () {
                                    if (nvl(this.item.ITEM_COST) == '') {
                                        this.item.ITEM_COST = 0;
                                    }
                                    this.item.ITEM_COST = Number(this.item.ITEM_COST);
                                    return comma(this.item.ITEM_COST);
                                }
                            },

                            {key: "INSERT_ID", label: "처리자아이디", width: 150, align: "center", hidden: true},
                            {key: "INSERT_DT", label: "처리일자", width: 150, align: "center", hidden: true},
                            {key: "UPDATE_ID", label: "수정자아이디", width: 150, align: "center", hidden: true},
                            {key: "UPDATE_DT", label: "수정일자", width: 150, align: "center", hidden: true}
                        ],
                        body: {
                            onClick: function () {
                                var data = this.item;           //  선택한 ROW의 ITEM들
                                var column = this.column.key;   //  컬럼 KEY명
                                var idx = this.dindex;          //  선택한 ROW의 INDEX

                                selectRow3 = idx;
                                this.self.select(selectRow3);
                            },
                            onDataChanged: function(){
                                var data = this.item;
                                var idx = this.dindex;
                                var column = this.key;

                                if (column == 'ITEM_COST'){
                                    var SUM_ITEM_COST = 0;
                                    for (var i = 0 ; i < fnObj.gridView03D.target.list.length ; i ++){
                                        SUM_ITEM_COST += Number(fnObj.gridView03D.target.list[i].ITEM_COST);
                                    }
                                    var indexM = fnObj.gridView03M.getData('selected')[0].__index;
                                    fnObj.gridView03M.target.setValue(indexM, 'PRICE_SUM', SUM_ITEM_COST);
                                }
                                if (column == 'SALE_COST'){
                                    var SUM_SALE_COST = 0;
                                    for (var i = 0 ; i < fnObj.gridView03D.target.list.length ; i ++){
                                        SUM_SALE_COST += Number(fnObj.gridView03D.target.list[i].SALE_COST);
                                    }
                                    var indexM = fnObj.gridView03M.getData('selected')[0].__index;
                                    fnObj.gridView03M.target.setValue(indexM, 'SALE_SUM', SUM_SALE_COST);
                                }

                            }
                        },
                        onPageChange: function (pageNumber) {
                            _this.setPageData({pageNumber: pageNumber});
                            ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                        },
                        page: {
                            display: false,
                            statusDisplay: false
                        }
                    });
                    axboot.buttonClick(this, "data-grid-view-03-d-btn", {
                        "add": function () {
                            if (fnObj.gridView01.getData('selected').length == 0) {
                                qray.alert("선택된 브랜드가 없습니다.");
                                return;
                            }

                            fnObj.gridView03D.addRow();

                            var lastIdx = nvl(fnObj.gridView03D.target.list.length, fnObj.gridView03D.lastRow());
                            fnObj.gridView03D.target.focus(lastIdx - 1);
                            fnObj.gridView03D.target.select(lastIdx - 1);

                            fnObj.gridView03D.target.setValue(lastIdx - 1, "BRD_CD", fnObj.gridView01.getData('selected')[0].BRD_CD);
                            fnObj.gridView03D.target.setValue(lastIdx - 1, "BRD_MENU_CD", fnObj.gridView03M.getData('selected')[0].BRD_MENU_CD);
                            fnObj.gridView03D.target.setValue(lastIdx - 1, "ITEM_CD", GET_NO('BRD', '05'));

                        },
                        "delete": function () {

                            var beforeIdx = this.target.selectedDataIndexs[0];
                            var dataLen = this.target.getList().length;

                            if ((beforeIdx + 1) == dataLen) {
                                beforeIdx = beforeIdx - 1;
                            }

                            var item = fnObj.gridView03D.getData('selected')[0]

                            fnObj.gridView03D.delRow("selected");
                            if (beforeIdx > 0 || beforeIdx == 0) {
                                this.target.select(beforeIdx);
                                selectRow3 = beforeIdx;
                            }

                        }

                    });
                },
                getData: function (_type) {
                    var list = [];
                    var _list = this.target.getList(_type);
                    list = _list;

                    return list;
                },
                addRow: function () {
                    this.target.addRow({__created__: true}, "last");
                },
                lastRow: function () {
                    return ($("div [data-ax5grid='grid-view-03_D']").find("div [data-ax5grid-panel='body'] table tr").length)
                }
            });

            /**
             * gridView04
             */
            fnObj.gridView04 = axboot.viewExtend(axboot.gridView, {
                page: {
                    pageNumber: 0,
                    pageSize: 10
                },
                initView: function () {
                    var _this = this;

                    this.target = axboot.gridBuilder({
                        showRowSelector: true,
                        frozenColumnIndex: 0,
                        target: $('[data-ax5grid="grid-view-04"]'),
                        columns: [
                            {
                                key: "COMPANY_CD",
                                label: "",
                                width: 150,
                                sortable: true,
                                align: "center",
                                hidden: true,
                                editor: false
                            },
                            {
                                key: "BRD_CD",
                                label: "브랜드코드",
                                width: 150,
                                sortable: true,
                                align: "center",
                                hidden: true,
                                editor: false
                            },
                            {
                                key: "BRD_NM",
                                label: "브랜드명",
                                width: 150,
                                sortable: true,
                                align: "center",
                                hidden: true,
                                editor: false
                            }
                            , {
                                key: "ITEM_CD",
                                label: "상품코드",
                                width: 150,
                                sortable: true,
                                align: "center",
                                hidden: false,
                                editor: false,
                                picker: function () {
                                    return {
                                        top: _pop_top,
                                        width: 600,
                                        height: _pop_height,
                                        url: "brandItem",
                                        action: ["commonHelp", "HELP_BRAND_ITEM"],
                                        callback: function (e) {
                                            var itemH = fnObj.gridView04.getData('selected')[0];
                                            var index = itemH.__index;
                                            fnObj.gridView04.target.setValue(index, "ITEM_CD", e[0].ITEM_CD);
                                            fnObj.gridView04.target.setValue(index, "ITEM_NM", e[0].ITEM_NM);
                                            fnObj.gridView04.target.setValue(index, "SALE_COST", e[0].SALE_COST);
                                        },
                                    }
                                }
                            }
                            , {
                                key: "ITEM_NM",
                                label: "상품명",
                                width: 150,
                                sortable: true,
                                align: "center",
                                hidden: false,
                                editor: false
                            }
                            , {
                                key: "ITEM_NUM",
                                label: "상품수량",
                                width: 150,
                                sortable: true,
                                align: "right",
                                hidden: false,
                                editor: {type: "number"},
                                formatter: function () {
                                    if (nvl(this.item.ITEM_NUM) == '') {
                                        this.item.ITEM_NUM = 0;
                                    }
                                    var value = this.item.ITEM_NUM + "";
                                    if (value.indexOf('.') > -1){
                                    	value = value.split['.'][0];
                                    	this.item.ITEM_NUM = value.split['.'][0];
                                    }
                                    this.item.ITEM_NUM = Number(value);
                                    return value;
                                }
                            }
                            , {
                                key: "SALE_COST",
                                label: "판매가",
                                width: 150,
                                sortable: true,
                                align: "right",
                                hidden: false,
                                editor: false,
                                formatter: "money"
                            }
                            , {
                                key: "AMT_TOT",
                                label: "합계금액",
                                width: 150,
                                sortable: true,
                                align: "right",
                                hidden: false,
                                editor: false,
                                formatter: "money"
                            }
                        ],
                        footSum: [
                            [
                                {label: "", colspan: 2, align: "center"},
                                {key: "ITEM_NUM", collector: "sum", align: "right"},
                                {key: "SALE_COST", collector: "sum", formatter: "money", align: "right"},
                                {key: "AMT_TOT", collector: "sum", formatter: "money", align: "right"}
                            ]
                        ],
                        body: {
                            onClick: function () {
                                var data = this.item;           //  선택한 ROW의 ITEM들
                                var column = this.column.key;   //  컬럼 KEY명
                                var idx = this.dindex;          //  선택한 ROW의 INDEX

                                selectRow4 = idx;
                                this.self.select(selectRow4);
                            },
                            onDataChanged: function () {
                                var data = this.item;
                                var idx = this.dindex;
                                if (this.key == 'ITEM_NUM' || this.key == 'SALE_COST') {
									var amt_tot = nvl(data.ITEM_NUM, 0) * nvl(data.SALE_COST, 0);
									fnObj.gridView04.target.setValue(idx, 'AMT_TOT', amt_tot);
                                }
                            }
                        },
                        onPageChange: function (pageNumber) {
                            _this.setPageData({pageNumber: pageNumber});
                            ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                        },
                        page: {
                            display: false,
                            statusDisplay: false
                        }
                    });
                    axboot.buttonClick(this, "data-grid-view-04-btn", {
                        "add": function () {
                            if (fnObj.gridView01.getData('selected').length == 0) {
                                qray.alert("선택된 브랜드가 없습니다.");
                                return;
                            }

                            fnObj.gridView04.addRow();
                            var BRD_CD = fnObj.gridView01.getData('selected')[0].BRD_CD;
                            var lastIdx = nvl(fnObj.gridView04.target.list.length, fnObj.gridView04.lastRow());
                            fnObj.gridView04.target.focus(lastIdx - 1);
                            fnObj.gridView04.target.select(lastIdx - 1);

                            fnObj.gridView04.target.setValue(lastIdx - 1, "BRD_CD", BRD_CD);

                        },
                        "delete": function () {

                            var beforeIdx = this.target.selectedDataIndexs[0];
                            var dataLen = this.target.getList().length;

                            if ((beforeIdx + 1) == dataLen) {
                                beforeIdx = beforeIdx - 1;
                            }

                            var item = fnObj.gridView04.getData('selected')[0]

                            fnObj.gridView04.delRow("selected");
                            if (beforeIdx > 0 || beforeIdx == 0) {
                                this.target.select(beforeIdx);
                            }

                        }

                    });
                },
                getData: function (_type) {
                    var list = [];
                    var _list = this.target.getList(_type);
                    list = _list;

                    return list;
                },
                addRow: function () {
                    this.target.addRow({__created__: true}, "last");
                },
                lastRow: function () {
                    return ($("div [data-ax5grid='grid-view-03']").find("div [data-ax5grid-panel='body'] table tr").length)
                }
            });

            /**
             * gridView05
             */
            fnObj.gridView05 = axboot.viewExtend(axboot.gridView, {
                page: {
                    pageNumber: 0,
                    pageSize: 10
                },
                initView: function () {
                    var _this = this;

                    this.target = axboot.gridBuilder({
                        showRowSelector: true,
                        frozenColumnIndex: 0,
                        target: $('[data-ax5grid="grid-view-05"]'),
                        columns: [
                            {
                                key: "COMPANY_CD",
                                label: "사업장코드",
                                width: 150,
                                sortable: true,
                                align: "center",
                                hidden: true,
                                editor: false
                            },
                            {
                                key: "BRD_CD",
                                label: "브랜드코드",
                                width: 150,
                                sortable: true,
                                align: "center",
                                hidden: true,
                                editor: false
                            },
                            {
                                key: "ITEM_CD",
                                label: "상품코드",
                                width: 150,
                                sortable: true,
                                align: "center",
                                editor: false,
                                picker: function () {
                                    return {
                                        top: _pop_top,
                                        width: 600,
                                        height: _pop_height,
                                        url: "brandItem",
                                        action: ["commonHelp", "HELP_BRAND_ITEM"],
                                        callback: function (e) {
                                            var itemH = fnObj.gridView05.getData('selected')[0];
                                            var index = itemH.__index;
                                            fnObj.gridView05.target.setValue(index, "ITEM_CD", e[0].ITEM_CD);
                                            fnObj.gridView05.target.setValue(index, "ITEM_NM", e[0].ITEM_NM);
                                            fnObj.gridView05.target.setValue(index, "SALE_COST", e[0].SALE_COST);
                                            /* if (e[0].PT_SP == '05') {    //  협력사
                                                fnObj.gridView05.target.setValue(index, "DELI_AMT_YN", 'Y');
                                            } else {
                                                fnObj.gridView05.target.setValue(index, "DELI_AMT_YN", 'N');
                                            } */
                                        },
                                    }
                                }
                            },
                            {key: "ITEM_NM", label: "상품명", width: 150, sortable: true, align: "center", editor: false},
                            {key: "CG_CD", label: "분류코드", width: 150, sortable: true, align: "center", editor: false, hidden:true},
                            {
                                key: "DISC_RATE", label: "할인율", width: 150, sortable: true, align: "right",
                                editor: {type: "number"},
                                formatter: function () {
                                    if (nvl(this.item.DISC_RATE) == '') {
                                        this.item.DISC_RATE = 0;
                                    }
                                    this.item.DISC_RATE = Number(this.item.DISC_RATE);
                                    return this.item.DISC_RATE;
                                }
                            },
                            {
                                key: "DISC_AMT",
                                label: "할인금액",
                                width: 150,
                                sortable: true,
                                align: "right",
                                editor: false,
                                formatter: "money"
                            },
                            {
                                key: "SALE_COST",
                                label: "판매가",
                                width: 150,
                                sortable: true,
                                align: "right",
                                editor: false,
                                formatter: "money"
                            },
                            {
                                key: "FINAL_AMT",
                                label: "최종금액",
                                width: 150,
                                sortable: true,
                                align: "right",
                                editor: false,
                                formatter: "money"
                            },
                            {
                                key: "DELI_AMT_YN", label: "배송금액여부", width: 120, align: "center", sortable: true,
                                editor: {
                                    type: "checkbox", config: {height: 17, trueValue: 'Y', falseValue: 'N'}
                                }
                                /* formatter: function () {
                                    var CHK = this.item.DELI_AMT_YN;
                                    if (nvl(CHK, 'N') == 'N') {
                                        return '<div class="columnBox" id="columnBox' + this.dindex + '" data-ax5grid-editor="checkbox" data-ax5grid-checked="false" data-ax5grid-column-selected="true" style="height:17px;width:17px;margin-top:2px;  onclick="javascript:alert(1);"></div>';
                                    } else {
                                        return '<div class="columnBox" id="columnBox' + this.dindex + '" data-ax5grid-editor="checkbox" data-ax5grid-checked="true" data-ax5grid-column-selected="true" style="height:17px;width:17px;margin-top:2px;  onclick="javascript:alert(1);"></div>';
                                    }
                                } */
                            },
                            {
                                key: "INSERT_ID",
                                label: "",
                                width: 150,
                                sortable: true,
                                align: "center",
                                hidden: true,
                                editor: false
                            },
                            {
                                key: "INSERT_DT",
                                label: "",
                                width: 150,
                                sortable: true,
                                align: "center",
                                hidden: true,
                                editor: false
                            },
                            {
                                key: "UPDATE_ID",
                                label: "",
                                width: 150,
                                sortable: true,
                                align: "center",
                                hidden: true,
                                editor: false
                            },
                            {
                                key: "UPDATE_DT",
                                label: "",
                                width: 150,
                                sortable: true,
                                align: "center",
                                hidden: true,
                                editor: false
                            },
                        ],
                        body: {
                            onClick: function () {
                                var data = this.item;           //  선택한 ROW의 ITEM들
                                var column = this.column.key;   //  컬럼 KEY명
                                var idx = this.dindex;          //  선택한 ROW의 INDEX

                                this.self.select(idx);
                            },
                            onDataChanged: function () {
                                var data = this.item;
                                var idx = this.dindex;
                                if (this.key == 'DISC_RATE' || this.key == 'SALE_COST') {
                                    if (data.DISC_RATE != null && data.DISC_RATE != undefined && data.SALE_COST != null && data.SALE_COST != undefined) {
                                        fnObj.gridView05.target.setValue(idx, "DISC_AMT", Math.floor((data.SALE_COST * data.DISC_RATE / 100)));
                                        fnObj.gridView05.target.setValue(idx, "FINAL_AMT", Math.floor(data.SALE_COST - Math.floor((data.SALE_COST * data.DISC_RATE / 100))));
                                    }
                                }
                            }
                        },
                        onPageChange: function (pageNumber) {
                            _this.setPageData({pageNumber: pageNumber});
                            ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                        },
                        page: {
                            display: false,
                            statusDisplay: false
                        }
                    });
                    axboot.buttonClick(this, "data-grid-view-05-btn", {
                        "add": function () {
                            if (fnObj.gridView01.getData('selected').length == 0) {
                                qray.alert("선택된 브랜드가 없습니다.");
                                return;
                            }
                            fnObj.gridView05.addRow();
                            var BRD_CD = fnObj.gridView01.getData('selected')[0].BRD_CD;
                            var lastIdx = nvl(fnObj.gridView05.target.list.length, fnObj.gridView05.lastRow());
                            fnObj.gridView05.target.focus(lastIdx - 1);
                            fnObj.gridView05.target.select(lastIdx - 1);

                            fnObj.gridView05.target.setValue(lastIdx - 1, "BRD_CD", BRD_CD);
                            fnObj.gridView05.target.setValue(lastIdx - 1, "CG_CD", 'CT00004');
                            fnObj.gridView05.target.setValue(lastIdx - 1, "DISC_RATE", 0);
                            fnObj.gridView05.target.setValue(lastIdx - 1, "DISC_AMT", 0);

                        },
                        "delete": function () {

                            var beforeIdx = this.target.selectedDataIndexs[0];
                            var dataLen = this.target.getList().length;

                            if ((beforeIdx + 1) == dataLen) {
                                beforeIdx = beforeIdx - 1;
                            }

                            var item = fnObj.gridView05.getData('selected')[0]

                            fnObj.gridView05.delRow("selected");
                            if (beforeIdx > 0 || beforeIdx == 0) {
                                this.target.select(beforeIdx);
                            }

                        }

                    });
                },
                getData: function (_type) {
                    var list = [];
                    var _list = this.target.getList(_type);
                    list = _list;

                    return list;
                },
                addRow: function () {
                    this.target.addRow({__created__: true}, "last");
                },
                lastRow: function () {
                    return ($("div [data-ax5grid='grid-view-05']").find("div [data-ax5grid-panel='body'] table tr").length)
                }
            });


            $(document).ready(function () {

            	$("#S_BRANDNAME").focus();
                $("#S_BRANDNAME").keydown(function (e) {
                    if (e.keyCode == '13') {
                        ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                    }
                });

                $("#ADM_PT_CD").on('dataBind', function (e) {
                    var itemH = fnObj.gridView01.getData('selected')[0];
                    fnObj.gridView01.target.setValue(itemH.__index, 'ADM_PT_CD', e.detail.PT_CD);
                    fnObj.gridView01.target.setValue(itemH.__index, 'ADM_PT_NM', e.detail.PT_NM);
                });

                $(".QRAY_FORM").find("[data-ax5select]").change(function () {
                    console.log(this.id, " : ", this.value);
                    var itemH = fnObj.gridView01.getData('selected')[0];
                    fnObj.gridView01.target.setValue(itemH.__index, this.id, $('select[name="' + this.id + '"]').val())
                });

                $(".QRAY_FORM").find("input").change(function () {
                    console.log(this.id, " : ", this.value);
                    var itemH = fnObj.gridView01.getData('selected')[0];
                    fnObj.gridView01.target.setValue(itemH.__index, this.id, $('#' + this.id).val())
                });
            });

            //분류코드
            function getbrcode(CD_COMPANY, CD_FIELD, ALL, FLAG1, FLAG2, FLAG3, CD_SYSDEF_ARRAY) {
                var codeInfo = [];
                axboot.ajax({
                    type: "POST",
                    url: ["Brandm", "getBrCode"],
                    data: JSON.stringify({COMPANY_CD: SCRIPT_SESSION.cdCompany}),
                    async: false,
                    callback: function (res) {
                        if (nvl(ALL, '') == '' || ALL == false || ALL == 'false' || ALL == 'FALSE') {  //  ALL 파라메터가 없거나 false이면 전체가 추가된다.
                            codeInfo.push({
                                CODE: '', VALUE: '', code: '', value: '', text: '', TEXT: ''
                            });
                        }
                        // console.log(" [ SELECT_COMMON_CODE - DATA :  ", res, " ] ")
                        res.list.forEach(function (n) {
                                if (nvl(FLAG1, '') != '' || nvl(FLAG2, '') != '' || nvl(FLAG3, '') != '') {
                                    if ((nvl(n.CD_FLAG1) != '' && n.CD_FLAG1 == FLAG1) ||
                                        (nvl(n.CD_FLAG2) != '' && n.CD_FLAG2 == FLAG2) ||
                                        (nvl(n.CD_FLAG3) != '' && n.CD_FLAG3 == FLAG3)) {

                                        if (nvl(CD_SYSDEF_ARRAY) != '' && CD_SYSDEF_ARRAY.length != 0) {
                                            for (var k = 0; k < CD_SYSDEF_ARRAY.length; k++) {
                                                if (CD_SYSDEF_ARRAY[k] == n.CD_SYSDEF) {
                                                    codeInfo.push({
                                                        CODE: n.CD_SYSDEF,
                                                        code: n.CD_SYSDEF,
                                                        value: n.CD_SYSDEF,
                                                        VALUE: n.CD_SYSDEF,
                                                        text: n.NM_SYSDEF,
                                                        TEXT: n.NM_SYSDEF,
                                                        CD_FLAG1: n.CD_FLAG1,
                                                        CD_FLAG2: n.CD_FLAG2,
                                                        CD_FLAG3: n.CD_FLAG3
                                                    });
                                                }
                                            }
                                        } else {
                                            codeInfo.push({
                                                CODE: n.CD_SYSDEF,
                                                code: n.CD_SYSDEF,
                                                value: n.CD_SYSDEF,
                                                VALUE: n.CD_SYSDEF,
                                                text: n.NM_SYSDEF,
                                                TEXT: n.NM_SYSDEF,
                                                CD_FLAG1: n.CD_FLAG1,
                                                CD_FLAG2: n.CD_FLAG2,
                                                CD_FLAG3: n.CD_FLAG3
                                            });
                                        }
                                    }
                                } else {
                                    if (nvl(CD_SYSDEF_ARRAY) != '' && CD_SYSDEF_ARRAY.length != 0) {
                                        for (var k = 0; k < CD_SYSDEF_ARRAY.length; k++) {
                                            if (CD_SYSDEF_ARRAY[k] == n.CD_SYSDEF) {
                                                codeInfo.push({
                                                    CODE: n.CD_SYSDEF,
                                                    code: n.CD_SYSDEF,
                                                    value: n.CD_SYSDEF,
                                                    VALUE: n.CD_SYSDEF,
                                                    text: n.NM_SYSDEF,
                                                    TEXT: n.NM_SYSDEF,
                                                    CD_FLAG1: n.CD_FLAG1,
                                                    CD_FLAG2: n.CD_FLAG2,
                                                    CD_FLAG3: n.CD_FLAG3
                                                });
                                            }
                                        }
                                    } else {
                                        codeInfo.push({
                                            CODE: n.CD_SYSDEF,
                                            code: n.CD_SYSDEF,
                                            value: n.CD_SYSDEF,
                                            VALUE: n.CD_SYSDEF,
                                            text: n.NM_SYSDEF,
                                            TEXT: n.NM_SYSDEF,
                                            CD_FLAG1: n.CD_FLAG1,
                                            CD_FLAG2: n.CD_FLAG2,
                                            CD_FLAG3: n.CD_FLAG3
                                        });
                                    }
                                }
                            }
                        );
                        // console.log(" [ SELECT_COMMON_CODE - RETURN :  ", codeInfo, " ] ")
                    }

                });

                return codeInfo;
            }

            //////////////////////////////////////
            //크기자동조정
            var _pop_top = 0;
            var _pop_height = 0;
            var _pop_height800 = 0;
            var _pop_top800 = 0;
            $(window).resize(function () {
                changesize();
            });
            $(document).ready(function(){
            	
            	$("#BRD_NM").focus();
                $("#BRD_NM").keydown(function (e) {
                    if (e.keyCode == '13') {
                        ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                    }
                });
            })

            $("#BRD_NOTICE").change(function () {
                console.log(this.value.replace(/(\n|\r\n)/g, '<br>'));
                fnObj.gridView01.target.setValue(fnObj.gridView01.getData('selected')[0].__index, 'BRD_NOTICE', this.value.replace(/(\n|\r\n)/g, '<br>'));
            })

            $("#BRD_GOOD").change(function () {
                console.log(this.value.replace(/(\n|\r\n)/g, '<br>'));
                fnObj.gridView01.target.setValue(fnObj.gridView01.getData('selected')[0].__index, 'BRD_GOOD', this.value.replace(/(\n|\r\n)/g, '<br>'));
            })

            function onlyNumber(input){
                $(input).val($(input).val().replace(/[^0-9]/gi,""));
            }

            function numberWithCommas(x, id) {
                x = x.replace(/[^0-9]/g, '');   // 입력값이 숫자가 아니면 공백
                x = x.replace(/,/g, '');          // ,값 공백처리
                $('#' + id).val(x.replace(/\B(?=(\d{3})+(?!\d))/g, ",")); // 정규식을 이용해서 3자리 마다 , 추가
            }

            function changesize() {
                //전체영역높이
                var totheight = $("#ax-base-root").height();
                if (totheight > 700) {
                    _pop_height = 600;
                    _pop_top = parseInt((totheight - _pop_height) / 2);
                    _pop_height800 = 800;
                    _pop_top800 = parseInt((totheight - 800) / 2);
                }
                else{
                    _pop_height800 = totheight / 10 * 9;
                    _pop_top800 = parseInt((totheight - _pop_height800) / 2);
                    _pop_height = totheight / 10 * 8;
                    _pop_top = parseInt((totheight - _pop_height) / 2);
                }

                //데이터가 들어갈 실제높이
                var datarealheight = $("#ax-base-root").height() - $(".ax-base-title").height() - $("#pageheader").height() - $("#tab_area").height() - 20;
                //타이틀을 뺀 상하단 그리드 합친높이
                var tempgridheight = datarealheight - $("#left_title").height();

                $("#left_grid").css("height", (tempgridheight / 100 * 99));
                $("#tab1_grid").css("height", $("#tab_area").height() - $("#tab1_button").height() - 40);
                $("#tab2_grid_M").css("height", $("#tab_area").height() - $("#tab2_button_M").height() - 40);
                $("#tab2_grid_D").css("height", $("#tab_area").height() - $("#tab2_button_M").height() - 40);
                $("#tab3_grid").css("height", $("#tab_area").height() - $("#tab3_button").height() - 40);
                $("#tab4_grid").css("height", $("#tab_area").height() - $("#tab4_button").height() - 40);
                $("#tab5_area").css("height", $("#tab_area").height() - 40);
                $("#tab6_area").css("height", $("#tab_area").height() - 40);
                $("#right_content").css("height", (datarealheight / 100 * 99));
            }
            
            
            var userCallBack;
            $(".openFile").click(function () {
                var selected = fnObj.gridView01.getData('selected')[0];
                var target = $(this).prevAll('[data-file-input]');
                var cg_cd = target.attr('CG_CD');

                userCallBack = function (e) {
                    e['TB_ID'] = target.attr('TB_ID');
                    e['CG_CD'] = target.attr('CG_CD');
                    e['TB_KEY'] = selected.BRD_CD;

                    target.val(e.ORGN_FILE_NAME);
                    fnObj.gridView01.target.setValue(selected.__index, cg_cd, e);
                    fnObj.gridView01.target.list[selected.__index][cg_cd] = e;
                };


                var data = {
                    TB_ID: target.attr('TB_ID'),
                    CG_CD: target.attr('CG_CD'),
                    TB_KEY: selected.BRD_CD,
                    FILE_PATH: target.attr('FILE_PATH'),
                    SIZE_LIMIT: {
                        HEIGHT: 1500,
                        WIDTH : 1500
                    },
                    CALL_BACK: selected[target.attr('CG_CD')]
                }
                ACTIONS.dispatch(ACTIONS.FILE_CLICK, data);
            })

            var ParentModal = new ax5.ui.modal();

            function openModal(name, action, callBack, viewName, initData) {
                var map = new Map();
                map.set("modal", ParentModal);
                map.set("modalText", "ParentModal");
                map.set("action", action);
                map.set("keyword", "");
                map.set("viewName", viewName);
                map.set("initData", initData);

                $.openMuiltiPopup(name, callBack, map, 600, _pop_height, _pop_top - 50);
            }

        </script>
    </jsp:attribute>
    <jsp:body>
        <style>
            input[type="number"]::-webkit-outer-spin-button,
            input[type="number"]::-webkit-inner-spin-button {
                -webkit-appearance: none;
                margin: 0;
            }

            .BrandTextArea {
                width: 100%;
                resize: none;
                overflow-y: hidden; /* prevents scroll bar flash */
                padding: 1.1em; /* prevents text jump on Enter keypress */
                padding-bottom: 0.2em;
                line-height: 1.6;
                height: 100%;
                border: 1px solid #000000;
            }
        </style>
        <div data-page-buttons="">
            <div class="button-warp">
                <button type="button" class="btn btn-reload" data-page-btn="reload" style="width: 80px;"
                        onclick="window.location.reload();">
                    <i class="icon_reload"></i></button>
                <button type="button" class="btn btn-info" data-page-btn="search" style="width: 80px;"><i
                        class="icon_search"></i><ax:lang
                        id="ax.admin.sample.modal.button.search"/></button>
                <button type="button" class="btn btn-info" data-page-btn="save" id="save_btn" style="width: 80px;"><i
                        class="icon_save"></i>저장
                </button>

            </div>
        </div>
        <%-- 상단조회조건 --%>
        <div role="page-header" id="pageheader">
            <ax:form name="searchView0">
                <ax:tbl clazz="ax-search-tb1" minWidth="500px">
                    <ax:tr>
                        <ax:td label='분류코드' width="350px">
                            <div id="S_BRCODE" name="S_BRCODE" data-ax5select="S_BRCODE"
                                 data-ax5select-config='{}' form-bind-type="selectBox"></div>
                        </ax:td>
                        <ax:td label='관리거래처' width="350px">
                            <multipicker id="S_PARTNER" HELP_ACTION="HELP_PARTNER" HELP_URL="multiPartner"
                                         BIND-CODE="PT_CD"
                                         BIND-TEXT="PT_NM"/>
                        </ax:td>
                        <ax:td label="브랜드명" width="350px">
                            <div class="input-group" style="width:100%">
                                <input type="text" class="form-control" name="S_BRANDNAME" id="S_BRANDNAME"
                                       style="width:100%"/>
                            </div>
                        </ax:td>
                        <%--<ax:td label='추천여부' width="350px">
                            <div id="S_RECOMMENDYN" name="S_RECOMMENDYN" data-ax5select="S_RECOMMENDYN"
                                 data-ax5select-config='{}' form-bind-type="selectBox"></div>
                        </ax:td>--%>
                    </ax:tr>
                    <%--<ax:tr>--%>
                        <%--<ax:td label='신규여부' width="350px">
                            <div id="S_NEWYN" name="S_NEWYN" data-ax5select="S_NEWYN"
                                 data-ax5select-config='{}' form-bind-type="selectBox"></div>
                        </ax:td>
                        <ax:td label='검증상태' width="350px">
                            <div id="S_VERIFY" name="S_VERIFY" data-ax5select="S_VERIFY"
                                 data-ax5select-config='{}' form-bind-type="selectBox"></div>
                        </ax:td>--%>
                        <%--<ax:td label="브랜드명" width="350px">
                            <div class="input-group" style="width:100%">
                                <input type="text" class="form-control" name="S_BRANDNAME" id="S_BRANDNAME"
                                       style="width:100%"/>
                            </div>
                        </ax:td>--%>
                    <%--</ax:tr>--%>
                </ax:tbl>
            </ax:form>
        </div>
        <%-- 그리드 영역 시작 --%>
        <div style="width:100%;overflow:hidden;">
            <div style="width:59%;float:left;overflow:hidden;">
                <div class="ax-button-group" data-fit-height-aside="grid-view-01" id="left_title" name="왼쪽그리드타이틀">
                    <div class="left">
                        <h2>
                        </h2>
                            <%--
                            <h2>
                                <i class="icon_list"></i> 거래처리스트
                            </h2>
                            --%>
                    </div>
                    <div class="right">
                        <button type="button" class="btn btn-small" data-grid-view-01-btn="add" style="width:80px;"><i
                                class="icon_add"></i><ax:lang id="ax.admin.add"/></button>
                        <button type="button" class="btn btn-small" data-grid-view-01-btn="delete" style="width:80px;">
                            <i class="icon_del"></i> <ax:lang id="ax.admin.delete"/></button>
                    </div>
                </div>


                <div data-ax5grid="grid-view-01"
                     data-ax5grid-config="{  showLineNumber: true,showRowSelector: false, multipleSelect: false,lineNumberColumnWidth: 40,rowSelectorColumnWidth: 27, }"
                     id="left_grid"
                     style="height: 300px;"
                     name="왼쪽그리드"
                ></div>

            </div>
            <div style="width:40%;float:right;overflow:hidden;">
                <div id="right_content" style="overflow-y:auto;" name="오른쪽부분내용">
                    <div class="ax-button-group">
                        <div class="left">
                            <h2>
                                <i class="icon_list"></i> 상세정보
                            </h2>
                        </div>
                    </div>
                    <div class="QRAY_FORM">

                        <ax:form name="binder-form">
                            <ax:tbl clazz="ax-search-tb2" minWidth="600px" style="border-top:0px;border-bottom:0px">
                                <ax:tr>
                                    <ax:td label='브랜드코드' width="300px">
                                        <input type="text" class="form-control" data-ax-path="BRD_CD"
                                               style="background: #ffe0cf;"
                                               name="BRD_CD" id="BRD_CD" form-bind-text='BRD_CD' form-bind-type='text'
                                               readonly/>
                                    </ax:td>
                                    <ax:td label='브랜드명' width="300px">
                                        <input type="hidden" class="form-control" data-ax-path="BRD_CD"
                                               style="background: #ffe0cf;"
                                               name="BRD_CD" id="BRD_CD" form-bind-text='BRD_CD' form-bind-type='text'
                                               readonly/>
                                        <input type="text" class="form-control" data-ax-path="BRD_NM"
                                               style="background: #ffe0cf;"
                                               name="BRD_NM" id="BRD_NM" form-bind-text='BRD_NM' form-bind-type='text'/>
                                    </ax:td>
                                </ax:tr>
                                <ax:tr>
                                	<ax:td label='분류코드' width="300px">
                                        <div id="CG_CD" name="CG_CD" data-ax5select="CG_CD"
                                             data-ax5select-config='{}' form-bind-text='CG_CD'
                                             form-bind-type="selectBox"></div>
                                    </ax:td>
                                    <ax:td label='관리거래처' width="300px">
                                        <codepicker id="ADM_PT_CD" HELP_ACTION="HELP_PARTNER" HELP_URL="partner"
                                                    BIND-CODE="PT_CD" BIND-TEXT="PT_NM" READONLY
                                                    form-bind-type="codepicker" form-bind-text="ADM_PT_NM"
                                                    form-bind-code="ADM_PT_CD"/>
                                    </ax:td>
                                </ax:tr>
                                <ax:tr>
                                	<ax:td label='카테고리' width="300px">
                                        <div id="CATE_CD" name="CATE_CD" data-ax5select="CATE_CD"
                                             data-ax5select-config='{}' form-bind-text='CATE_CD'
                                             form-bind-type="selectBox"></div>
                                    </ax:td>
									<ax:td label='검증상태' width="300px">
                                        <div id="VERIFY_STAT" name="VERIFY_STAT" data-ax5select="VERIFY_STAT"
                                             data-ax5select-config='{}' form-bind-text="VERIFY_STAT"
                                             form-bind-type="selectBox"></div>
                                    </ax:td>\
                                </ax:tr>

                                <ax:tr>

                                    <ax:td label='추천여부' width="300px">
                                        <div id="RECOMM_YN" name="RECOMM_YN" data-ax5select="RECOMM_YN"
                                             data-ax5select-config='{}' form-bind-text="RECOMM_YN"
                                             form-bind-type="selectBox"></div>
                                    </ax:td>
                                    <ax:td label='신규여부' width="300px">
                                        <div id="NEW_YN" name="NEW_YN" data-ax5select="NEW_YN"
                                             data-ax5select-config='{}' form-bind-text="NEW_YN"
                                             form-bind-type="selectBox"></div>
                                    </ax:td>
                                </ax:tr>
                                <ax:tr>
                                	<ax:td label='추천순서' width="300px">
                                        <input type="number" class="form-control" data-ax-path="RECOMM_ORD" name="RECOMM_ORD" id="RECOMM_ORD" form-bind-text='RECOMM_ORD' form-bind-type='text' onkeyup="onlyNumber(this);"/>
                                    </ax:td>
                                    <ax:td label='신규순서' width="300px">
                                        <input type="number" class="form-control" data-ax-path="NEW_ORD" name="NEW_ORD" id="NEW_ORD" form-bind-text='NEW_ORD' form-bind-type='text' onkeyup="onlyNumber(this);"/>
                                    </ax:td>
                                </ax:tr>
                                
                                <ax:tr>
                                	 <ax:td label='사용여부' width="300px">
                                        <div id="USE_YN" name="USE_YN" data-ax5select="USE_YN"
                                             data-ax5select-config='{}' form-bind-text="USE_YN"
                                             form-bind-type="selectBox"></div>
                                    </ax:td>
                                    <ax:td label='로고이미지' width="300px">
                                        <div class="input-group" id="filemodal">
                                            <input type="text" class="form-control" id="LOGO_FILE_NM"
                                                   TB_ID="FS_BRAND_M"
                                                   CG_CD="BLOG00001"
                                                   FILE_PATH="brand/LOGO"
                                                   data-file-input readonly="readonly" form-bind-type="text">
                                            <span class="input-group-addon openFile" style="cursor: pointer"><i
                                                    class="cqc-magnifier"></i></span>
                                        </div>
                                    </ax:td>
                                </ax:tr>
                                <ax:tr>
                                    <ax:td label='브랜드메인' width="300px">
                                        <div class="input-group" id="filemodal">
                                            <input type="text" class="form-control" id="MAIN_FILE_NM"
                                                   TB_ID="FS_BRAND_M"
                                                   CG_CD="BIMG00001"
                                                   FILE_PATH="brand"
                                                   data-file-input readonly="readonly" form-bind-type="text">
                                            <span class="input-group-addon openFile" style="cursor: pointer"><i
                                                    class="cqc-magnifier"></i></span>
                                        </div>
                                    </ax:td>
                                    <ax:td label='브랜드상세' width="300px">
                                        <div class="input-group" id="filemodal">
                                            <input type="text" class="form-control" id="DTL_FILE_NM"
                                                   TB_ID="FS_BRAND_M"
                                                   CG_CD="BDTL00001"
                                                   FILE_PATH="brand/DTL"
                                                   data-file-input readonly="readonly" form-bind-type="text">
                                            <span class="input-group-addon openFile" style="cursor: pointer"><i
                                                    class="cqc-magnifier"></i></span>
                                        </div>
                                    </ax:td>
                                </ax:tr>
                                <ax:tr>
                                	<ax:td label='홍보영상링크' width="600px">
                                        <input type="text" class="form-control" data-ax-path="PROMT_LINK" name="PROMT_LINK" id="PROMT_LINK" form-bind-text='PROMT_LINK' form-bind-type='text'/>
                                    </ax:td>
                                </ax:tr>
                            </ax:tbl>
                        </ax:form>

                    </div>


                </div>
            </div>
        </div>

        <%-- 하단탭부분 --%>
        <%--<div id="tab_button_area" style="clear:both;width:100%;min-height:30px;margin-top:5px" name="하단탭버튼영역">
            <div style="float:right;">
                <button type="button" class="btn btn-small" data-grid-view-02-btn="add" style="width:80px;"><i
                        class="icon_add"></i><ax:lang id="ax.admin.add"/></button>
                <button type="button" class="btn btn-small" data-grid-view-02-btn="delete" style="width:80px;">
                    <i class="icon_del"></i> <ax:lang id="ax.admin.delete"/></button>
            </div>
        </div>--%>
        <div class="H10"></div>
        <div id="tab_area" data-ax5layout="ax1" data-config="{layout:'tab-panel'}" style="height:380px;" name="하단탭영역">
            <div data-tab-panel="{label: '브랜드메뉴', active: 'true'}" id="tabGrid1">
                <div class="ax-button-group" data-fit-height-aside="grid-view-03" id="tab1_button">
                    <div class="left">

                    </div>
                    <div class="right">
                        <button type="button" class="btn btn-small" data-grid-view-02-btn="add" style="width:80px;"><i
                                class="icon_add"></i><ax:lang id="ax.admin.add"/></button>
                        <button type="button" class="btn btn-small" data-grid-view-02-btn="delete"
                                style="width:80px;">
                            <i class="icon_del"></i> <ax:lang id="ax.admin.delete"/></button>
                    </div>
                </div>
                <div data-ax5grid="grid-view-02"
                     data-ax5grid-config="{  showLineNumber: true,showRowSelector: false, multipleSelect: false,lineNumberColumnWidth: 40,rowSelectorColumnWidth: 27, }"
                     id="tab1_grid"
                     name="탭1그리드"
                ></div>
            </div>
            <div data-tab-panel="{label: '수익률', active: 'false'}" id="tabGrid2">
                <div style="width:100%;overflow:hidden;">
                    <div style="width:49%;float:left;overflow:hidden;">
                        <div class="ax-button-group" style="height:40px;" data-fit-height-aside="grid-view-03_M" id="tab2_button_M"
                             name="왼쪽그리드타이틀">
                            <div class="left">
                                <h2>
                                    <i class="icon_list"></i> 메뉴정보
                                </h2>

                            </div>
                            <div class="right">
                                <button type="button" class="btn btn-small" data-grid-view-03-m-btn="add"
                                        style="width:80px;"><i
                                        class="icon_add"></i><ax:lang id="ax.admin.add"/></button>
                                <button type="button" class="btn btn-small" data-grid-view-03-m-btn="delete"
                                        style="width:80px;">
                                    <i class="icon_del"></i> <ax:lang id="ax.admin.delete"/></button>
                            </div>
                        </div>


                        <div data-ax5grid="grid-view-03_M"
                             data-ax5grid-config="{  showLineNumber: true,showRowSelector: false, multipleSelect: false,lineNumberColumnWidth: 40,rowSelectorColumnWidth: 27, }"
                             id="tab2_grid_M"
                             name="왼쪽그리드"
                        ></div>

                    </div>
                    <div style="width:50%;float:right;overflow:hidden;">
                        <div class="ax-button-group" style="height:40px;" data-fit-height-aside="grid-view-03_D" id="tab2_button_D"
                             name="오른쪽그리드타이틀">
                            <div class="ax-button-group">
                                <div class="left">
                                    <h2>
                                        <i class="icon_list"></i> 메뉴별 상품정보
                                    </h2>
                                </div>
                                <div class="right">
                                    <button type="button" class="btn btn-small" data-grid-view-03-d-btn="add"
                                            style="width:80px;"><i
                                            class="icon_add"></i><ax:lang id="ax.admin.add"/></button>
                                    <button type="button" class="btn btn-small" data-grid-view-03-d-btn="delete"
                                            style="width:80px;">
                                        <i class="icon_del"></i> <ax:lang id="ax.admin.delete"/></button>
                                </div>
                            </div>
                            <div data-ax5grid="grid-view-03_D"
                                 data-ax5grid-config="{  showLineNumber: true,showRowSelector: false, multipleSelect: false,lineNumberColumnWidth: 40,rowSelectorColumnWidth: 27, }"
                                 id="tab2_grid_D"
                                 name="탭2그리드"
                            ></div>
                        </div>
                    </div>
                </div>
            </div>
            <div data-tab-panel="{label: '초도물품', active: 'false'}" id="tabGrid3">
                <div class="ax-button-group" style="height:40px;" data-fit-height-aside="grid-view-04" id="tab3_button">
                    <div class="left">

                    </div>
                    <div class="right">
                        <button type="button" class="btn btn-small" data-grid-view-04-btn="add" style="width:80px;"><i
                                class="icon_add"></i><ax:lang id="ax.admin.add"/></button>
                        <button type="button" class="btn btn-small" data-grid-view-04-btn="delete" style="width:80px;">
                            <i class="icon_del"></i> <ax:lang id="ax.admin.delete"/></button>
                    </div>
                </div>
                <div data-ax5grid="grid-view-04"
                     data-ax5grid-config="{  showLineNumber: true,showRowSelector: false, multipleSelect: false,lineNumberColumnWidth: 40,rowSelectorColumnWidth: 27, }"
                     id="tab3_grid"
                     name="탭3그리드"
                ></div>
            </div>
            <div data-tab-panel="{label: '브랜드상품', active: 'false'}" id="tabGrid4">
                <div class="ax-button-group" style="height:40px;" data-fit-height-aside="grid-view-05" id="tab4_button">
                    <div class="left">

                    </div>
                    <div class="right">
                        <button type="button" class="btn btn-small" data-grid-view-05-btn="add" style="width:80px;"><i
                                class="icon_add"></i><ax:lang id="ax.admin.add"/></button>
                        <button type="button" class="btn btn-small" data-grid-view-05-btn="delete" style="width:80px;">
                            <i class="icon_del"></i> <ax:lang id="ax.admin.delete"/></button>
                    </div>
                </div>
                <div data-ax5grid="grid-view-05"
                     data-ax5grid-config="{  showLineNumber: true,showRowSelector: false, multipleSelect: false,lineNumberColumnWidth: 40,rowSelectorColumnWidth: 27, }"
                     id="tab4_grid"
                     name="탭4그리드"
                ></div>
            </div>
            <div data-tab-panel="{label: '공지사항', active: 'false'}" id="tabArea5">
                <div id="tab5_area">
                    <textarea class="BrandTextArea" id="BRD_NOTICE"></textarea>
                </div>
            </div>
            <div data-tab-panel="{label: '브랜드 장점', active: 'false'}" id="tabArea6">
                <div id="tab6_area">
                    <textarea class="BrandTextArea" id="BRD_GOOD"></textarea>
                </div>
            </div>
                <%--
                <div data-tab-panel="{label: 'Social Network', active: 'false'}" style="background: #82aecc;">
                    <div style="padding: 10px;">
                        Open Network
                    </div>
                </div>
                --%>
        </div>


    </jsp:body>
</ax:layout>