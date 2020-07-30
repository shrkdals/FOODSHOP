<%@ page import="com.chequer.axboot.core.utils.MessageUtils" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>

<ax:set key="title" value="사용자별 거래처등록"/>
<ax:set key="page_desc" value="${pageRemark}"/>
<ax:set key="page_auto_height" value="true"/>



<ax:layout name="base">
    <jsp:attribute name="script">
        <ax:script-lang key="ax.script"/>
        <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=316c9b07bf0cad06b4e37ab2f364f29f&libraries=services"></script>
        <style>
            .red {
                background: #ffe0cf !important;
            }
        </style>


        <script type="text/javascript">
            var afterIndex = 0;
            var selectRow2 = 0;
            var beforeIdx = 0;
            var PT_SP         = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'MA00002');
            var CLOSING_TP    = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'MA00010');
            var TAX_SP        = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'MA00004');
            var COMT_SP       = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'MA00003');
            var CONTRACT_SP   = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'MA00012');
            var CONTRACT_STAT = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'MA00013');
            var USER_SP       = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'MA00007');
            var USER_STAT     = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'MA00006');
            var CONTRACT_STAT = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'MA00013');
            var YN_OP = [{value:'' , text:''},{value:'Y' , text:'Y'},{value:'N' , text:'N'}];

            var S_1 = $.DATA_SEARCH("BrandContract", 'S_1',{}).list;
            $("#S_1").ax5select({ options: [{value:'' , text:''}].concat(S_1) });

            $("#CONTRACT_STAT").ax5select({
                options: CONTRACT_STAT
            });

            $("#S_PT_SP").ax5select({
                options: PT_SP
            });

            $("#S_CONTRACT").ax5select({
                options: CONTRACT_STAT
            });
            var UserCallBack
            var modal = new ax5.ui.modal();
            var selectRow2 = 0;

            var fnObj = {}, CODE = {};
            var ACTIONS = axboot.actionExtend(fnObj, {
                PAGE_SEARCH: function (caller, act, data) {
                    var param = {
                        SALES_PERSON_ID : $('#SALE_USER').getCodes()
                        , CONTRACT_YN : $('select[name="S_CONTRACT"]').val()
                        , PT_NM : $('#S_PT_NM').val()
                        , TEMP1 : $('select[name="S_PT_SP"]').val()
                        , TEMP2 : SCRIPT_SESSION.idUser
                        , TEMP3 : $('select[name="S_1"]').val()
                        , COMPANY_CD : SCRIPT_SESSION.cdCompany
                    };
                    var list = $.DATA_SEARCH('mapartnerm','SAVE_USERMAPPING_H_S',param).list;
                    fnObj.gridView01.target.setData(list);
                    if(list.length < afterIndex ){
                        afterIndex = 0
                    }
                    caller.gridView01.target.select(afterIndex);
                    caller.gridView01.target.focus(afterIndex);
                    ACTIONS.dispatch(ACTIONS.ITEM_CLICK,caller);
                    selectRow2 = 0;

                    return false;
                },
                PAGE_SAVE: function (caller, act, data) {

                    var itemH = [].concat(caller.gridView02.getData("modified"));
                    itemH = itemH.concat(caller.gridView02.getData("deleted"));

                    if(itemH.length == 0){
                        qray.alert('변경된 정보가 없습니다.');
                        return;
                    }
                    if(caller.gridView02.requirement()){
                        return false;
                    }
                    var data = {
                         delete : caller.gridView02.getData("deleted")
                        ,insert : caller.gridView02.getData("modified")
                    };

                    axboot.ajax({
                        type: "POST",
                        url: ["mapartnerm", "SAVE_USERMAPPING"],
                        data: JSON.stringify(data),
                        callback: function (res) {
                            qray.alert("저장 되었습니다.");
                            ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                            caller.gridView01.target.select(afterIndex);
                            caller.gridView01.target.focus(afterIndex);

                        }
                    });
                },
                ITEM_CLICK: function (caller, act, data) {
                    var selected = caller.gridView01.getData('selected')[0];
                    var list = $.DATA_SEARCH('mapartnerm','SAVE_USERMAPPING_S',nvl(selected,{}));
                    fnObj.gridView02.target.setData(list);

                }
                , ITEM_ADD2: function (caller, act, data) {

                    if (caller.gridView01.getData('selected').length == 0) {
                        qray.alert("선택된 거래처가 없습니다.");
                        return;
                    }


                    UserCallBack = function (e) {
                        var chkArr = [];
                        for (var i = 0; i < fnObj.gridView02.target.list.length; i++) {
                            chkArr.push(fnObj.gridView02.target.list[i].USER_ID);
                        }
                        chkArr = chkArr.join('|');

                        if (e.length > 0) {
                            for (var i = 0; i < e.length; i++) {
                                if (chkArr.indexOf(e[i].USER_ID) > -1) continue;
                                fnObj.gridView02.addRow();
                                var lastIdx = nvl(fnObj.gridView02.target.list.length, fnObj.gridView02.lastRow());
                                selectRow2 = lastIdx - 1;
                                var item = fnObj.gridView01.getData('selected')[0];
                                fnObj.gridView02.target.setValue(lastIdx - 1, "PT_CD", item.PT_CD);
                                fnObj.gridView02.target.setValue(lastIdx - 1, "CD_COMPANY", SCRIPT_SESSION.cdCompany);
                                fnObj.gridView02.target.setValue(lastIdx - 1, "USER_ID", e[i].USER_ID);
                                fnObj.gridView02.target.setValue(lastIdx - 1, "USER_NM", e[i].USER_NM);
                            }

                        }
                        modal.close();
                    };
                    $.openCommonPopup("multiUser", "UserCallBack", 'HELP_USER', '', null, 600, _pop_height, _pop_top);

                    /*
                    caller.gridView02.addRow();
                    var PT_CD = caller.gridView01.getData('selected')[0].PT_CD;
                    var lastIdx = nvl(caller.gridView02.target.list.length, caller.gridView02.lastRow());
                    caller.gridView02.target.select(lastIdx - 1);
                    caller.gridView02.target.focus(lastIdx - 1);
                    caller.gridView02.target.setValue(lastIdx - 1, "PT_CD", PT_CD);
                    */


                }
                , ITEM_DEL2: function (caller, act, data) {
                    caller.gridView02.delRow("selected");
                }
            });
            // fnObj 기본 함수 스타트와 리사이즈
            fnObj.pageStart = function () {
                this.pageButtonView.initView();
                this.searchView.initView();
                this.gridView01.initView();
                this.gridView02.initView();
                ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
            };

            fnObj.pageResize = function () {

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
                        "excel": function () {

                        }
                    });
                }
            });

            //== view 시작
            fnObj.searchView = axboot.viewExtend(axboot.searchView, {
                initView: function () {
                    this.target = $(document["searchView0"]);
                    this.target.attr("onsubmit", "return ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);");
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
                        target: $('[data-ax5grid="grid-view-01"]'),
                        // parentFlag:true,
                        // parentGrid: $(fnObj.gridView02),
                        // childrenGrid: [$(fnObj.gridView02),$(fnObj.gridView03)],
                        showRowSelector: true,
                        columns: [
                             {key: "COMPANY_CD", label: "회사코드", width: 150 , align: "left" , editor: {type: "text"},hidden:true}
                            ,{key: "PT_CD", label: "거래처코드", width: 150   , align: "center" , editor: false}
                            ,{key: "PT_SP", label: "거래처유형", width: 150   , align: "center" ,
                                formatter: function () {
                                    return $.changeTextValue(PT_SP, this.value)
                                }
                                , editor: {
                                    type: "select", config: {
                                        columnKeys: {
                                            optionValue: "value", optionText: "text"
                                        },
                                        options: PT_SP
                                    }, disabled: function () {
                                        return true;

                                    }
                                }
                            }
                            ,{key: "PT_NM", label: "거래처 명", width: 150, align: "center", editor: false}
                            ,{key: "BIZ_NO", label: "사업자번호", width: 150, align: "center", editor: false
                                ,formatter: function () {
                                    return $.changeDataFormat( this.value , 'company')
                                }
                            }
                            ,{key: "OWNER_NM", label: "대표자명", width: 150, align: "center", editor: false}
                            ,{key: "SIGN_NM", label: "간판명", width: 150, align: "center", editor: false ,hidden:true}
                            ,{key: "PT_TYPE", label: "거래처업종", width: 150, align: "center", editor: false ,hidden:true}
                            ,{key: "PT_COND", label: "거래처업태", width: 150, align: "center", editor: false ,hidden:true}
                            ,{key: "TEL_NO", label: "전화번호", width: 150, align: "center", editor: false ,hidden:true}
                            ,{key: "HP_NO", label: "휴대폰번호", width: 150, align: "center", editor: false ,hidden:true}
                            ,{key: "POST_NO", label: "우편번호", width: 150, align: "center", editor: false ,hidden:true}
                            ,{key: "PT_ADDR", label: "거래처 주소", width: 150, align: "center", editor: false ,hidden:true}
                            ,{key: "SYSDEF_ADDR", label: "상세주소", width: 150, align: "center", editor: false ,hidden:true}
                            ,{key: "FAX_NO", label: "팩스번호", width: 150, align: "center", editor: false ,hidden:true}
                            ,{key: "CLOSING_TP", label: "휴폐업구분", width: 150, align: "center", editor: false ,hidden:true}
                            ,{key: "USE_YN", label: "사용여부", width: 150, align: "center", editor: false ,hidden:true}
                            ,{key: "SALES_PERSON_ID", label: "영업담당자아이디", width: 150, align: "center", editor: false ,hidden:true}
                            ,{key: "SALES_PERSON_NM", label: "영업담당자명", width: 150, align: "center", editor: false ,hidden:true}
                            ,{key: "TAX_SP", label: "과세유형", width: 150, align: "center", editor: false ,hidden:true}
                            ,{key: "BRD_VERIFY_YN", label: "브랜드검증여부", width: 150, align: "center", editor: false ,hidden:true}
                            ,{key: "CONTRACT_YN", label: "계약여부", width: 150, align: "center", editor: false ,hidden:true}
                            ,{key: "LAT_CD", label: "위도코드", width: 150, align: "center", editor: false ,hidden:true}
                            ,{key: "LONG_CD", label: "경도코드", width: 150, align: "center", editor: false ,hidden:true}
                            ,{key: "DELI_AMT", label: "배송금액", width: 150, align: "center", editor: false ,hidden:true}
                            ,{key: "FREE_DELI_AMT", label: "무료배송금액", width: 150, align: "center", editor: false ,hidden:true}
                            ,{key: 'CONTRACT_NO'        , label: '계약 번호'          , width: 0 , align: "center" , editor: false  ,hidden:true}
                            ,{key: 'JOIN_PT_CD'         , label: '가맹 거래처 코드'   , width: 0 , align: "center" , editor: false  ,hidden:true}
                            ,{key: 'JOIN_PT_NM'         , label: '가맹 거래처명'      , width: 0 , align: "center" , editor: false  ,hidden:true}
                            ,{key: 'MAIN_PT_CD'         , label: '주체 거래처 코드'   , width: 0 , align: "center" , editor: false  ,hidden:true}
                            ,{key: 'MAIN_PT_NM'         , label: '주체 거래처명'      , width: 0 , align: "center" , editor: false  ,hidden:true}
                            ,{key: 'CONTRACT_SP'        , label: '계약 유형'          , width: 0 , align: "center" , editor: false  ,hidden:true}
                            ,{key: 'CONTRACT_ST_DTE'    , label: '계약 시작 일자'     , width: 0 , align: "center" , editor: false  ,hidden:true}
                            ,{key: 'CONTRACT_ED_DTE'    , label: '계약 종료 일자'     , width: 0 , align: "center" , editor: false  ,hidden:true}
                            ,{key: 'CONTRACT_STAT'      , label: '계약 상태'          , width: 0 , align: "center" , editor: false  ,hidden:true}
                            ,{key: 'PT_CONTRACT_PERSON' , label: '거래처 계약 담당자' , width: 0 , align: "center" , editor: false  ,hidden:true}
                            ,{key: 'PT_CONTRACT_PERSON_NM' , label: '거래처 계약 담당자' , width: 0 , align: "center" , editor: false  ,hidden:true}
                            ,{key: 'SALES_PERSON_ID2'    , label: '영업 담당자 아이디' , width: 0 , align: "center" , editor: false  ,hidden:true}
                            ,{key: 'SALES_PERSON_NM2'    , label: '영업 담당자 아이디' , width: 0 , align: "center" , editor: false  ,hidden:true}
                        ],

                        body: {
                            onDataChanged: function () {

                            },
                            //444
                            onClick: function () {
                                var index = this.dindex;
                                if(afterIndex == index){return false;}

                                var data = [].concat(fnObj.gridView02.getData("modified"));
                                data = data.concat(fnObj.gridView02.getData("deleted"));

                                if(data.length > 0){
                                    qray.confirm({
                                        msg: "작업중인 데이터를 먼저 저장해주십시오."
                                        ,btns: {
                                            cancel: {
                                                label:'확인', onClick: function(key){
                                                    qray.close();
                                                }
                                            }
                                        }
                                    })
                                }else{
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
                             {key: "COMPANY_CD", label: "", width: 150, align: "left", editor: {type: "text"} ,hidden:true}
                            ,{key: "PT_CD", label: "거래처코드", width: 150, align: "center", hidden:false}
                            ,{key: "USER_ID", label: "사용자아이디", width: 150, align: "center", hidden:false
                                // ,picker: {
                                //     top: _pop_top,
                                //     width: 600,
                                //     height: _pop_height,
                                //     url: "user",
                                //     action: ["commonHelp", "HELP_USER"],
                                //     param: function () {
                                //     },
                                //     callback: function (e) {
                                //         var index = fnObj.gridView02.getData('selected')[0].__index;
                                //         fnObj.gridView02.target.setValue(index, "USER_ID", e[0].USER_ID);
                                //         fnObj.gridView02.target.setValue(index, "USER_NM", e[0].USER_NM);
                                //         //fnObj.gridView02.target.setValue(index, "USER_SP", e[0].USER_SP);
                                //     },
                                //     disabled: function () {
                                //         if(!nvl(this.item.__created__,false)){
                                //             return true;
                                //         }
                                //     }
                                // }
                                // ,styleClass: function () {
                                //     return "red";
                                // }
                            }
                            ,{key: "USER_NM", label: "사용자명", width: 150, align: "center", hidden:false}
                            ,{
                                key: "USER_SP", label: "사용자유형", width: 150, align: "center",required:true,required:true
                                , formatter: function () {
                                    return $.changeTextValue(USER_SP, this.value)
                                }
                                , editor: {
                                    type: "select", config: {
                                        columnKeys: {
                                            optionValue: "value", optionText: "text"
                                        },
                                        options: USER_SP
                                    }, disabled: function () {
                                        }
                                }
                            }
                            ,{
                                key: "USER_STAT", label: "사용자상태", width: 150, align: "center",required:true
                                , formatter: function () {
                                    return $.changeTextValue(USER_STAT, this.value)
                                }
                                , editor: {
                                    type: "select", config: {
                                        columnKeys: {
                                            optionValue: "value", optionText: "text"
                                        },
                                        options: USER_STAT
                                    }, disabled: function () {
                                    }
                                }
                            }
                        ],
                        body: {
                            onClick: function () {
                                var data = this.item;           //  선택한 ROW의 ITEM들
                                var column = this.column.key;   //  컬럼 KEY명
                                var idx = this.dindex;          //  선택한 ROW의 INDEX

                                selectRow2 = idx;
                                this.self.select(selectRow2);
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
                            ACTIONS.dispatch(ACTIONS.ITEM_ADD2);
                        },
                        "delete": function () {

                            var beforeIdx = this.target.selectedDataIndexs[0];
                            var dataLen = this.target.getList().length;

                            if ((beforeIdx + 1) == dataLen) {
                                beforeIdx = beforeIdx - 1;
                            }

                            var item = fnObj.gridView02.getData('selected')[0]

                            ACTIONS.dispatch(ACTIONS.ITEM_DEL2);
                            if (beforeIdx > 0 || beforeIdx == 0) {
                                this.target.select(beforeIdx);
                                selectRow2 = beforeIdx;
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



            //////////////////////////////////////
            //크기자동조정
            var _pop_top = 0;
            var _pop_height = 0;
            $(document).ready(function () {
                changesize();

            });
            $(window).resize(function () {
                changesize();
            });


            function changesize() {
                //전체영역높이
                var totheight = $("#ax-base-root").height();
                if (totheight > 700) {
                    _pop_height = 600;
                    _pop_top = parseInt((totheight - _pop_height) / 2);
                } else {
                    _pop_height = totheight / 10 * 8;
                    _pop_top = parseInt((totheight - _pop_height) / 2);
                }

                //데이터가 들어갈 실제높이
                var datarealheight = $("#ax-base-root").height() - $(".ax-base-title").height() - $("#pageheader").height();
                //타이틀을 뺀 상하단 그리드 합친높이
                var tempgridheight = datarealheight - $("#left_title").height() - $("#bottom_left_title").height() - $("#bottom_left_amt").height();

                $("#left_grid").css("height" ,tempgridheight / 100 * 99);
                //$("#right_grid").css("height", tempgridheight / 100 * 99);
                $("#right_grid").css("height", (tempgridheight / 100 * 99) - $('#binder-form').height() - $('.ax-button-group').height());
                /*
                alert($("#ax-base-root").height()); // 컨텐츠영역높이
                ax-base-title //타이틀부분높이(class)
                ax-base-content //검색조건높이(class)
                 */
            }

        </script>
    </jsp:attribute>
    <jsp:body>
        <style>

            .form-control_02[readonly] {
                background-color: #eeeeee;
                opacity: 1
            }

            input[type="number"]::-webkit-outer-spin-button,
            input[type="number"]::-webkit-inner-spin-button {
                -webkit-appearance: none;
                margin: 0;
            }

            .form-control_02 {
                height: 25px;
                padding: 3px 6px;
                font-size: 12px;
                line-height: 1.42857;
                color: #555555;
                background-color: #fff;
                background-image: none;
                border: 1px solid #ccc;
                -webkit-transition: border-color ease-in-out 0.15s, box-shadow ease-in-out 0.15s;
                -o-transition: border-color ease-in-out 0.15s, box-shadow ease-in-out 0.15s;
                transition: border-color ease-in-out 0.15s, box-shadow ease-in-out 0.15s;
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

        <div role="page-header" id="pageheader">
            <ax:form name="searchView0">
                <ax:tbl clazz="ax-search-tb1" minWidth="500px">
                    <ax:tr>
                        <ax:td label='총판' width="300px">
                            <div id="S_1" name="S_1" data-ax5select="S_1"
                                 data-ax5select-config='{}' form-bind-type="selectBox"></div>
                        </ax:td>
                        <ax:td label='거래처유형' width="350px">
                            <div id="S_PT_SP" name="S_PT_SP" data-ax5select="S_PT_SP"
                                 data-ax5select-config='{}' form-bind-type="selectBox"></div>
                        </ax:td>
                        <ax:td label="거래처명 검색" width="350px">
                            <div class="input-group" style="width:100%">
                                <input type="text" class="form-control" name="s_cd_partner" id="S_PT_NM" style="width:100%"/>
                            </div>
                        </ax:td>
                        <ax:td label='영업사원' width="350px">
                            <multipicker id="SALE_USER" HELP_ACTION="HELP_USER" HELP_URL="multiUser"
                                         BIND-CODE="ID_USER"
                                         BIND-TEXT="NM_EMP"/>
                        </ax:td>

                        <ax:td label='계약상태' width="200px">
                            <div id="S_CONTRACT" name="S_CONTRACT" data-ax5select="S_CONTRACT"
                                 data-ax5select-config='{}' form-bind-type="selectBox"></div>
                        </ax:td>
                    </ax:tr>
                </ax:tbl>
            </ax:form>
        </div>

        <%-- 그리드 영역 시작 --%>
        <div style="width:100%;overflow:hidden">
            <div style="width:49%;float:left;overflow:hidden;">
                <div class="ax-button-group" data-fit-height-aside="grid-view-01" id="left_title" name="왼쪽그리드타이틀">
                    <div class="left">
                        <h2>
                            <i class="icon_list"></i> 거래처리스트
                        </h2>
                    </div>
                </div>

                <div data-ax5grid="grid-view-01"
                     data-ax5grid-config="{  showLineNumber: true,showRowSelector: false, multipleSelect: false,lineNumberColumnWidth: 40,rowSelectorColumnWidth: 27, }"
                     id = "left_grid"
                     name="왼쪽그리드"
                ></div>
            </div>
            <div style="width:50%;float:right;overflow:hidden;">
                <div class="ax-button-group" id="right_title" name="오른쪽부분타이틀">
                    <div class="left">
                        <h2>
                            <i class="icon_list"></i> 사용자정보
                        </h2>
                    </div>
                    <div class="right">
                        <button type="button" class="btn btn-small" data-grid-view-02-btn="add" style="width:80px;"><i
                                class="icon_add"></i>
                            <ax:lang id="ax.admin.add"/></button>
                        <button type="button" class="btn btn-small" data-grid-view-02-btn="delete" style="width:80px;">
                            <i
                                    class="icon_del"></i> <ax:lang id="ax.admin.delete"/></button>
                    </div>
                </div>
                <div id="right_content" style="overflow-y:auto;" name="오른쪽부분내용">

                        <div data-ax5grid="grid-view-02"
                             data-ax5grid-config="{  showLineNumber: true,showRowSelector: false, multipleSelect: false,lineNumberColumnWidth: 40,rowSelectorColumnWidth: 27, }"
                             id = "right_grid"
                             name="오른쪽그리드"
                        ></div>
                    </div>
                </div>
            </div>
        </div>


    </jsp:body>
</ax:layout>