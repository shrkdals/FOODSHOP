<%@ page import="com.chequer.axboot.core.utils.MessageUtils" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>

<ax:set key="title" value="브랜드계약관리"/>
<ax:set key="page_desc" value="${pageRemark}"/>
<ax:set key="page_auto_height" value="true"/>



<ax:layout name="base">
    <jsp:attribute name="script">
        <ax:script-lang key="ax.script"/>
        <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=316c9b07bf0cad06b4e37ab2f364f29f&libraries=services"></script>
		
    </script>
        
        
        <style>
            .red {
                background: #ffe0cf !important;
            }
        </style>


        <script type="text/javascript">
            var afterIndex = 0;
            var selectRow2 = 0;
            var selectRow3 = 0;
            var beforeIdx = 0;


            //분류코드
            var DATA_BRCODE     = getbrcode();
            //검증상태
            var DATA_VERIFY = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'MA00005');
            // YN
            var DATA_YN = [{value:'' , text:''},{value:'Y' , text:'Y'},{value:'N' , text:'N'}];
            // 순서
            var NUMBER_ORDER = [{value:'' , text:''},{value:'1' , text:'1'},{value:'2' , text:'2'},{value:'3' , text:'3'},{value:'4' , text:'4'}];

            var CONTRACT_STAT = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'MA00013');

            var S_1 = $.DATA_SEARCH("BrandContract", 'S_1',{}).list;

            $('#S_1').ax5select({
                options: [{value:'' , text:''}].concat(S_1),
                onStateChanged: function (e) {
                    if (e.state == "changeValue") {
                        $('#ALL_PT').attr('HELP_PARAM', JSON.stringify({PT_CD : $('select[name="S_1"]').val()}))
                        $('#FS_PT').attr('HELP_PARAM', JSON.stringify({PT_CD : $('select[name="S_1"]').val()}))
                        var S_2 = $.DATA_SEARCH("BrandContract", 'S_2',{PT_CD : $('select[name="S_1"]').val()}).list;
                        //관할구역
                        $("#S_2").ax5select("setOptions", [{value: '', text: ''}].concat(S_2), true);
                        $("#S_3").setClear()
                        $("#ALL_PT").attr({code : '' , text : ''})
                        $("#ALL_PT").val('')
                        $("#FS_PT").attr({code : '' , text : '', x: '', y: ''})
                        $("#FS_PT").val('')

                        $('#S_3').attr('HELP_PARAM', JSON.stringify({PT_CD : $('select[name="S_1"]').val() , AREA_CD : $('select[name="S_2"]').val()}))
                    }
                }
            });

            $('#S_2').ax5select({
                options: [{value:'' , text:''}],
                onStateChanged: function (e) {
                    if (e.state == "changeValue") {
                        $('#S_3').attr('HELP_PARAM', JSON.stringify({PT_CD : $('select[name="S_1"]').val() , AREA_CD : $('select[name="S_2"]').val()}))
                    }
                }
            });

            var UserCallBack
            var modal = new ax5.ui.modal();
            var selectRow2 = 0;

            var fnObj = {}, CODE = {};
            var ACTIONS = axboot.actionExtend(fnObj, {
                PAGE_SEARCH: function (caller, act, data) {
                    var param = {
                        COMPANY_CD : SCRIPT_SESSION.cdCompany //회사코드
                        ,S_1 :  $('select[name="S_1"]').val()
                        ,S_2 :  $('select[name="S_2"]').val()
                        ,S_3 :  $('#S_3').getCodes()
                    };
                    if(SCRIPT_SESSION.cdGroup != 'WEB01' && nvl(param.S_1) == ''){
                        qray.alert('조회조건의 총판항목은 필수항목입니다.')
                        return false;
                    }
                    if (nvl($("#DISTANCE").val()) != '' && nvl($("#FS_PT").val()) == ''){
                    	qray.alert('반경을 입력하셨으면,<br>기준가맹점을 입력해주십시오.');
                        return false;
                    }
                    var list = $.DATA_SEARCH('BrandContract','selectH',param).list;
                    fnObj.gridView01.target.setData(list);
                    if(list.length < afterIndex ){
                        afterIndex = 0
                    }
                    caller.gridView01.target.select(afterIndex);
                    caller.gridView01.target.focus(afterIndex);
                    ACTIONS.dispatch(ACTIONS.ITEM_CLICK, this.item);
                    return false;
                },
                PAGE_SAVE: function (caller, act, data) {

                    var list = isChecked(caller.gridView02.getData())

                    if(list.length == 0){
                        qray.alert('체크된 데이터가 없습니다.')
                        return false;
                    }


                    var Mcnt = 0
                    for(var i = 0 ; i < list.length; i++){
                        if(nvl(list[i].CONTRACT_ED_DTE,'') == ''){
                            qray.alert('계약종료일자는 필수 항목입니다.');
                            return false;
                        }else if(nvl(list[i].CONTRACT_ST_DTE,'') == ''){
                            qray.alert('계약시작일자는 필수 항목입니다.');
                            return false;
                        }else if(nvl(list[i].CONTRACT_STAT,'') == ''){
                            qray.alert('계약상태는 필수 항목입니다.');
                            return false;
                        }else if(nvl(list[i].SALES_PERSON_ID,'') == ''){
                            qray.alert('영업담당자는 필수 항목입니다.');
                            return false;
                        }
                        if(nvl(list[i].__modified__,false)){
                            Mcnt++
                        }
                        // list[i].ADM_PT_CD = $('select[name="S_1"]').val()
                    }

                    if(Mcnt == 0){
                        qray.alert('변경된 데이터가 없습니다.');
                        return false;
                    }

                    if(Mcnt != list.length){
                        qray.alert('체크목록중 수정하지 않은 데이터가 존재합니다.');
                        return false;
                    }

                    var data = {
                        list : list
                    };

                    axboot.ajax({
                        type: "POST",
                        url: ["BrandContract", "save"],
                        data: JSON.stringify(data),
                        callback: function (res) {
                            qray.alert("계약처리가 완료되었습니다.");
                            ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                        }
                    });
                },
                ITEM_CLICK: function (caller, act, data) {
                    var selected = caller.gridView01.getData('selected')[0];
                    selected.CONTROL_AREA_CD = $('select[name="S_2"]').val()
                    selected.ADM_PT_CD = $('select[name="S_1"]').val()
                    selected.S_3 = $('#S_3').getCodes()
                   	selected.X = $("#FS_PT").attr('x');
                    selected.Y = $("#FS_PT").attr('y');
                    selected.DISTANCE = $("#DISTANCE").val()
                     
                    var list2 = $.DATA_SEARCH('BrandContract','selectD2',nvl(selected,{}));
                    //var list2 = $.DATA_SEARCH('BrandContract','selectD',nvl(selected,{}));
                    fnObj.gridView02.target.setData(list2);

                },
                ALL_PT: function (caller, act, data) {
                    var code = $('#ALL_PT').attr('code')
                    var text = $('#ALL_PT').attr('text')
                    if(nvl(code) == ''){
                        qray.alert('거래처 선택이 선행되어야합니다.')
                        return false;
                    }
                    var list = isChecked(fnObj.gridView02.getData())
                    if(list.length == 0){
                        qray.alert('체크된 데이터가 없습니다.')
                        return false;
                    }
                    list.forEach(function(item, index){
                        fnObj.gridView02.target.setValue(item.__index, "BRD_CONTRACT_PT_CD", code);
                        fnObj.gridView02.target.setValue(item.__index, "BRD_CONTRACT_PT_NM", text);
                        fnObj.gridView02.target.setValue(item.__index, "CONTRACT_STAT", '01');
                        fnObj.gridView02.target.setValue(item.__index, "SALES_PERSON_ID", SCRIPT_SESSION.idUser);
                        fnObj.gridView02.target.setValue(item.__index, "SALES_PERSON_NM", SCRIPT_SESSION.nmUser);
                    })

                }
                , CONTRACT_CANCEL: function (caller, act, data) {
                    var list = isChecked(caller.gridView02.getData())

                    if(list.length == 0){
                        qray.alert('체크된 데이터가 없습니다.')
                        return false;
                    }

                    var data = {
                        list : list
                    };

                    axboot.ajax({
                        type: "POST",
                        url: ["BrandContract", "contract_cancel"],
                        data: JSON.stringify(data),
                        callback: function (res) {
                            qray.alert("계약취소 처리가 완료되었습니다.");
                            ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                        }
                    });
                }



            });
            // fnObj 기본 함수 스타트와 리사이즈
            fnObj.pageStart = function () {
                this.pageButtonView.initView();
                this.searchView.initView();
                this.gridView01.initView();
                this.gridView02.initView();
                // ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
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
                        "cancel": function () {
                            ACTIONS.dispatch(ACTIONS.CONTRACT_CANCEL);
                        },
                        "all_btn": function () {

                            ACTIONS.dispatch(ACTIONS.ALL_PT);

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
                        showRowSelector: true,
                        columns: [
                            {key: "COMPANY_CD", label: "회사코드", width: 150 , align: "left" , editor: {type: "text"},hidden:true}
                            ,{key: "CG_CD", label: "분류코드", width: 150   , align: "center" ,
                                formatter: function () {
                                    return $.changeTextValue(DATA_BRCODE, this.value)
                                }
                                , editor: {
                                    type: "select", config: {
                                        columnKeys: {
                                            optionValue: "value", optionText: "text"
                                        },
                                        options: DATA_BRCODE
                                    }, disabled: function () {
                                        return true;

                                    }
                                },hidden:true
                            }
                            ,{key: "BRD_CD", label: "브랜드코드", width: 150   , align: "center" , editor: false}
                            ,{key: "BRD_NM", label: "브랜드명", width: 150, align: "center", editor: false}
                            ,{key: "ADM_PT_CD", label: "관리거래처코드", width: 150, align: "center", editor: false,hidden:true}
                            ,{key: "ADM_PT_NM", label: "관리거래처명", width: 150, align: "center", editor: false,hidden:true}
                            ,{key: "CONT_CNT", label: "가맹점수", width: 90, align: "center", editor: false}
                            ,{key: "VERIFY_STAT", label: "검증상태", width: 150, align: "center",
                                formatter: function () {
                                    return $.changeTextValue(DATA_VERIFY, this.value)
                                }
                                , editor: {
                                    type: "select", config: {
                                        columnKeys: {
                                            optionValue: "value", optionText: "text"
                                        },
                                        options: DATA_VERIFY
                                    }, disabled: function () {
                                        return true;

                                    }
                                },hidden:true
                            }
                            ,{key: "USE_YN", label: "사용여부", width: 150, align: "center",
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
                                },hidden:true
                            }
                            ,{key: "RECOMM_YN", label: "추천여부", width: 150, align: "center",
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
                                },hidden:true
                            }
                            ,{key: "RECOMM_ORD", label: "추천순서", width: 150, align: "center",
                                formatter: function () {
                                    return $.changeTextValue(NUMBER_ORDER, this.value)
                                }
                                , editor: {
                                    type: "select", config: {
                                        columnKeys: {
                                            optionValue: "value", optionText: "text"
                                        },
                                        options: NUMBER_ORDER
                                    }, disabled: function () {
                                        return true;

                                    }
                                },hidden:true
                            }
                            ,{key: "NEW_YN", label: "신규여부", width: 150, align: "center",
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
                                },hidden:true
                            }
                            ,{key: "NEW_ORD", label: "신규순서", width: 150, align: "center",
                                formatter: function () {
                                    return $.changeTextValue(NUMBER_ORDER, this.value)
                                }
                                , editor: {
                                    type: "select", config: {
                                        columnKeys: {
                                            optionValue: "value", optionText: "text"
                                        },
                                        options: NUMBER_ORDER
                                    }, disabled: function () {
                                        return true;

                                    }
                                },hidden:true
                            }
                            ,{
                                key: "FILE1_COUNT",label: "",width: 150,align: "center",editor: {type: "text"},hidden: true
                            }
                            ,{
                                key: "FILE1",label: "",width: 150,align: "center",editor: {type: "text"},hidden: true
                            }
                            ,{
                                key: "FILE2_COUNT",label: "",width: 150,align: "center",editor: {type: "text"},hidden: true
                            }
                            ,{
                                key: "FILE2",label: "",width: 150,align: "center",editor: {type: "text"},hidden: true
                            }
                            ,{
                                key: "FILE3_COUNT",label: "",width: 150,align: "center",editor: {type: "text"},hidden: true
                            }
                            ,{
                                key: "FILE3",label: "",width: 150,align: "center",editor: {type: "text"},hidden: true
                            }
                        ],

                        body: {
                            onDataChanged: function () {

                            },
                            //444
                            onClick: function () {
                                var index = this.dindex;
                                if(afterIndex == index){return false;}

                                var data = [].concat(fnObj.gridView02.getData("modified"));
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
                            {
                                key: "CHKED", label: "", width: 30, align: "center",
                                label:
                                    '<div id="headerBox" data-ax5grid-editor="checkbox" data-ax5grid-checked="false" data-ax5grid-column-selected="true" style="height:17px;width:17px;margin-top:2px;  onclick="javascript:alert(1);"></div>',
                                editor: {
                                    type: "checkbox", config: {height: 17, trueValue: true, falseValue: false}
                                }, dirty : false
                            }
                            ,{key: "LV1_CD" , label: "" , width: 150     , align: "center"   , editor: false  ,sortable:true , hidden:true}
                            ,{key: "SIDO_NM" , label: "시도명" , width: 120     , align: "center"   , editor: false  ,sortable:true , hidden:false}
                            ,{key: "LV2_CD" , label: "", width: 150     , align: "center"   , editor: false  ,sortable:true , hidden:true}
                            ,{key: "SIGUNGU_NM" , label: "시군구명" , width: 120     , align: "center"   , editor: false  ,sortable:true , hidden:false}
                            ,{key: "LV3_CD" , label: "", width: 150     , align: "center"   , editor: false  ,sortable:true , hidden:true}
                            ,{key: "UMD_NM" , label: "구역명" , width: 120     , align: "center"   , editor: false  ,sortable:true , hidden:false}
                            ,{key: "BRD_CD", label: "브랜드코드" , width: 150     , align: "center"   , editor: false  ,sortable:true , hidden:true}
                            ,{key: "BRD_NM", label: "브랜드명" , width: 150     , align: "center"   , editor: false  ,sortable:true , hidden:false}
                            ,{key: "BRD_CONTRACT_PT_CD"  , label: "브랜드계약거래처", width: 150     , align: "center"   , editor: false  ,sortable:true , hidden:true}
                            ,{key: "BRD_CONTRACT_PT_NM", label: "브랜드계약거래처" , width: 150     , align: "center"   , editor: false  ,sortable:true , hidden:false
                                ,picker: {
                                    top: _pop_top,
                                    width: 600,
                                    height: _pop_height,
                                    url: "partner",
                                    action: ["commonHelp", "HELP_PARTNER_CONTRACT"],
                                    param: function () {
                                        return {PT_CD : $('select[name="S_1"]').val()}
                                    },
                                    callback: function (e) {
                                        var index = fnObj.gridView02.getData('selected')[0].__index;
                                        fnObj.gridView02.target.setValue(index, "BRD_CONTRACT_PT_CD", e[0].PT_CD);
                                        fnObj.gridView02.target.setValue(index, "BRD_CONTRACT_PT_NM", e[0].PT_NM);
                                        fnObj.gridView02.target.setValue(index, "CONTRACT_STAT", '01');
                                        fnObj.gridView02.target.setValue(index, "SALES_PERSON_ID", SCRIPT_SESSION.idUser);
                                        fnObj.gridView02.target.setValue(index, "SALES_PERSON_NM", SCRIPT_SESSION.nmUser);
                                    },
                                    disabled: function () {
                                        if( nvl(this.item.CONTRACT_STAT,'') == '01'){
                                            return true;
                                        }
                                    }
                                }
                            }
                            ,{key: "CONTRACT_STAT", label: "<span style=\"color:red;\"> * </span> 계약상태" , width: 150     , align: "center"
                                , formatter: function () {
                                    return $.changeTextValue(CONTRACT_STAT,this.value)
                                }
                                , editor: {
                                    type: "select", config: {
                                        columnKeys: {
                                            optionValue: "value", optionText: "text"
                                        },
                                        options: CONTRACT_STAT
                                    }, disabled: function () {
                                        if( nvl(this.item.CONTRACT_STAT,'') == '01'){
                                            return true;
                                        }
                                    }
                                }
                                ,sortable:true , hidden:false}
                            ,{key: "CONTRACT_ST_DTE", label: "<span style=\"color:red;\"> * </span>  계약시작일" , width: 150     , align: "center"
                                , editor: {type:"date"
                                    , disabled: function () {
                                        if( nvl(this.item.CONTRACT_STAT,'') == '01'){
                                            return true;
                                        }
                                    }
                                }
                                , sortable:true , hidden:false
                                , formatter: function(){
                                        return $.changeDataFormat(this.value, 'YYYYMMDD')
                                    }
                            }
                            , {
                                key: "CONTRACT_ED_DTE", label: "<span style=\"color:red;\"> * </span> 계약종료일", width: 150, align: "center"
                                , editor: {type: "date"
                                    , disabled: function () {
                                        if( nvl(this.item.CONTRACT_STAT,'') == '01'){
                                            return true;
                                        }
                                    }
                                }
                                , sortable: true, hidden: false
                                , formatter: function () {
                                    return $.changeDataFormat(this.value, 'YYYYMMDD')
                                }
                                , required:true
                            }
                            ,{key: "SALES_PERSON_ID", label: "영업담당" , width: 150     , align: "center"   , editor: false  ,sortable:true , hidden:true  }
                            ,{key: "SALES_PERSON_NM", label: "<span style=\"color:red;\"> * </span>  영업담당자명" , width: 150     , align: "center"   , editor: false  ,sortable:true , hidden:false
                                ,picker: {
                                    top: _pop_top,
                                    width: 600,
                                    height: _pop_height,
                                    url: "user",
                                    action: ["commonHelp", "HELP_USER"],
                                    param: function () {
                                    },
                                    callback: function (e) {
                                        fnObj.gridView02.target.setValue(this.dindex, "SALES_PERSON_ID", e[0].USER_ID);
                                        fnObj.gridView02.target.setValue(this.dindex, "SALES_PERSON_NM", e[0].USER_NM);
                                    },
                                    disabled: function () {
                                        if( nvl(this.item.CONTRACT_STAT,'') == '01'){
                                            return true;
                                        }
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

                $("#FS_PT").on('dataBind', function(e){
					console.log(e.detail);
					var x = '';
					var y = '';
					
					if (nvl(e.detail.PT_ADDR) != ''){
						var geocoder = new kakao.maps.services.Geocoder();

		                // 주소로 좌표를 검색합니다
		                geocoder.addressSearch(e.detail.PT_ADDR, function(result, status) {

		                    // 정상적으로 검색이 완료됐으면
		                    if (status === kakao.maps.services.Status.OK) {
		                    	y = result[0].y;
								x = result[0].x;
		                    }

		                    $("#FS_PT").attr('x', x);
		                    $("#FS_PT").attr('y', y);
		                });
		                
					}
                })

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

                $("#left_grid").css("height" ,tempgridheight / 100 * 99 - $('.ax-button-group').height()  );
                $("#right_grid").css("height", tempgridheight / 100 * 99 - $('.ax-button-group').height() );
                /*
                alert($("#ax-base-root").height()); // 컨텐츠영역높이
                ax-base-title //타이틀부분높이(class)
                ax-base-content //검색조건높이(class)
                 */
            }

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

            function isChecked(data) {
                var array = [];
                for (var i = 0; i < data.length; i++) {
                    if (data[i].CHKED == true) {
                        array.push(data[i])
                    }
                }
                return array;
            }

            var cnt = 0;
            $(document).on('click', '#headerBox', function(e) {
                if(cnt == 0){
                    $("div [data-ax5grid='grid-view-02']").find("div #headerBox").attr("data-ax5grid-checked",true);
                    cnt++;
                    var gridList = fnObj.gridView02.getData();
                    gridList.forEach(function(e, i){
                        fnObj.gridView02.target.setValue(i,"CHKED",true);
                    });
                    $("div [data-ax5grid-editor='checkbox']").attr("data-ax5grid-checked",true)
                }else{
                    $("div [data-ax5grid='grid-view-02']").find("div #headerBox").attr("data-ax5grid-checked",false);
                    cnt = 0;
                    var gridList = fnObj.gridView02.getData();
                    gridList.forEach(function(e, i){
                        fnObj.gridView02.target.setValue(i,"CHKED",false);
                    });
                    $("div [data-ax5grid-editor='checkbox']").attr("data-ax5grid-checked",false)
                }

            });

            
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
                        class="icon_save"></i>계약
                </button>
                <button type="button" class="btn btn-info" data-page-btn="cancel" id="cancel_btn" style="width: 80px;"><i
                        class="icon_save"></i>계약취소
                </button>
            </div>
        </div>

        <div role="page-header" id="pageheader">
            <ax:form name="searchView0">
                <ax:tbl clazz="ax-search-tb1" minWidth="500px">
                    <ax:tr>
                        <ax:td label='총판' width="350px">
                            <div id="S_1" name="S_1" data-ax5select="S_1"
                                 data-ax5select-config='{}' form-bind-type="selectBox"></div>
                        </ax:td>
                        <ax:td label='관할구역' width="350px">
                            <div id="S_2" name="S_2" data-ax5select="S_2"
                                 data-ax5select-config='{}' form-bind-type="selectBox"></div>
                        </ax:td>
                        <%-- <ax:td label='시군구' width="350px">
                            <multipicker id="S_3" HELP_ACTION="HELP_AREA2" HELP_URL="multiArea" BIND-CODE="AREA_CD"
                                         BIND-TEXT="AREA_NM"/>
                        </ax:td> --%>
                        <ax:td label='가맹점' width="350px">
                        	<codepicker id="FS_PT" HELP_ACTION="HELP_PARTNER_CONTRACT" HELP_URL="partner" BIND-CODE="PT_CD"
                                    BIND-TEXT="PT_NM" READONLY/>
                        </ax:td>
                        <ax:td label='반경(km)' width="350px">
                        	<input type="number" class="form-control" name="DISTANCE" id="DISTANCE"/>
                        </ax:td>
                    </ax:tr>
                </ax:tbl>
            </ax:form>
        </div>

        <%-- 그리드 영역 시작 --%>
        <div style="width:100%;overflow:hidden">
            <div style="width:27%;overflow:hidden;float:left;">
                <div class="ax-button-group" data-fit-height-aside="grid-view-01" id="left_title" name="왼쪽그리드타이틀">
                    <div class="left">
                        <h2>
                            <i class="icon_list"></i> 브랜드리스트
                        </h2>
                    </div>
                </div>

                <div data-ax5grid="grid-view-01"
                     data-ax5grid-config="{  showLineNumber: true,showRowSelector: false, multipleSelect: false,lineNumberColumnWidth: 40,rowSelectorColumnWidth: 27, }"
                     id = "left_grid"
                ></div>

            </div>

            <div style="width:72%;overflow:hidden;float:right;">
                <div class="ax-button-group" data-fit-height-aside="grid-view-02" id="left_title2" name="왼쪽그리드타이틀">
                    <div class="left">
                        <h2>
                            <i class="icon_list"></i> 계약상세
                        </h2>
                    </div>
                    <div class="right" style="width:350px">
                        <codepicker id="ALL_PT" HELP_ACTION="HELP_PARTNER_CONTRACT" HELP_URL="partner" BIND-CODE="PT_CD"
                                    BIND-TEXT="PT_NM" READONLY
                                    form-bind-type="codepicker" form-bind-text="PT_CONTRACT_PERSON_NM" form-bind-code="PT_CONTRACT_PERSON"/>
                        <button type="button" class="btn btn-info" data-page-btn="all_btn" id="all_btn" style="width: 120px; float:right"><i
                                class="icon_save"></i>거래처일괄등록
                        </button>
                    </div>

                </div>

                <div data-ax5grid="grid-view-02"
                     data-ax5grid-config="{  showLineNumber: true,showRowSelector: false, multipleSelect: false,lineNumberColumnWidth: 40,rowSelectorColumnWidth: 27, }"
                     id = "right_grid"
                ></div>
            </div>

            </div>
        </div>

    </jsp:body>
</ax:layout>