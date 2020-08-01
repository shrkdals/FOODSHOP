<%@ page import="com.chequer.axboot.core.utils.MessageUtils" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>

<ax:set key="title" value="주문관리"/>
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
            var selectRow3 = 0;
            var beforeIdx = 0;

            var dl_ITEM_UNIT   = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'MA00008');   // 출고단위
            var ITEM_SP     = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'MA00011');
            var DELI_STAT   = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'MA00017');
            var ORDER_STAT  = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'MA00023');
            var PAYM_METHOD = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'MA00024');

            var YN_OP = [{value:'' , text:''},{value:'Y' , text:'Y'},{value:'N' , text:'N'}];




            // $("#S_CONTRACT").ax5select({
            //     options: YN_OP
            // });
            var UserCallBack
            var modal = new ax5.ui.modal();
            var selectRow2 = 0;

            var fnObj = {}, CODE = {};
            var ACTIONS = axboot.actionExtend(fnObj, {
                PAGE_SEARCH: function (caller, act, data) {
                    var param = {
                        GROUP : SCRIPT_SESSION.cdGroup
                        ,DT_START : $('#S_DT').getStartDate()
                        ,DT_END : $('#S_DT').getEndDate()
                    };
                    var list = $.DATA_SEARCH('order','selectH',param).list;
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

                    var itemH = [].concat(caller.gridView01.getData("modified"));
                    itemH = itemH.concat(caller.gridView01.getData("deleted"));
                    itemH = itemH.concat(caller.gridView02.getData("modified"));
                    itemH = itemH.concat(caller.gridView02.getData("deleted"));
                    itemH = itemH.concat(caller.gridView03.getData("modified"));
                    itemH = itemH.concat(caller.gridView03.getData("deleted"));

                    if(itemH.length == 0){
                        qray.alert('변경된 정보가 없습니다.');
                        return;
                    }
                    if(caller.gridView02.requirement()){
                        return false;
                    }
                    if(caller.gridView03.requirement()){
                        return false;
                    }
                    var data = {
                         delete1 : caller.gridView01.getData("deleted")
                        ,insert1 : caller.gridView01.getData("modified")
                        ,delete2 : caller.gridView02.getData("deleted")
                        ,insert2 : caller.gridView02.getData("modified")
                        ,delete3 : caller.gridView03.getData("deleted")
                        ,insert3 : caller.gridView03.getData("modified")
                    };

                    axboot.ajax({
                        type: "POST",
                        url: ["area", "save"],
                        data: JSON.stringify(data),
                        callback: function (res) {
                            qray.alert("저장 되었습니다.");
                            ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                            caller.gridView01.target.select(afterIndex);
                            caller.gridView01.target.focus(afterIndex);

                        }
                    });
                },
                ITEM_CLICK : function (caller, act, data) {
                    var selected = caller.gridView01.getData('selected')[0];
                    var list2 = $.DATA_SEARCH('order','selectD',nvl(selected,{}));
                    fnObj.gridView02.target.setData(list2);
                }
                , SUCCESS : function (caller, act, data) {
                    var list = isChecked(fnObj.gridView01.getData())
                    if(list.length == 0){
                        qray.alert('체크된 데이터가 없습니다.')
                        return false;
                    }
                    for(var i = 0; i < list.length; i++) {
                        if (list[i].ORDER_STAT == '03') {
                            qray.alert('배송완료된 주문건이 존재합니다')
                            return;
                        }
                        if (list[i].ORDER_STAT == '04') {
                            qray.alert('주문취소된 주문건이 존재합니다')
                            return false;
                        }

                    }
                    axboot.ajax({
                        type: "POST",
                        url: ["order", "success"],
                        data: JSON.stringify({list : list , TYPE: '1'}),
                        callback: function (res) {
                            qray.alert("일괄입금완료처리가 되었습니다.");
                            ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                            caller.gridView01.target.select(afterIndex);
                            caller.gridView01.target.focus(afterIndex);

                        }
                    });
                }
                , SUCCESS2 : function (caller, act, data) {
                    var list = isChecked(fnObj.gridView02.getData())
                    if(list.length == 0){
                        qray.alert('체크된 데이터가 없습니다.')
                        return false;
                    }
                    for(var i = 0; i < list.length; i++) {
                        if (list[i].DELI_STAT  == '02') {
                            qray.alert('입금 완료되지 않은 주문건이 존재합니다')
                            return;
                        }else if (list[i].DELI_STAT  == '03') {
                            qray.alert('배송완료된 주문건이 존재합니다')
                            return;
                        }
                    }
                    axboot.ajax({
                        type: "POST",
                        url: ["order", "success"],
                        data: JSON.stringify({list : list , TYPE: '2'}),
                        callback: function (res) {
                            qray.alert("일괄배송완료처리가 되었습니다.");
                            ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                            caller.gridView01.target.select(afterIndex);
                            caller.gridView01.target.focus(afterIndex);

                        }
                    });
                }
                ,
                PDF_1 : function (caller, act, data) {
                    // var cklist = isChecked(fnObj.gridView01.getData())
                    // var ORDER_CD = []
                    // cklist.forEach(function(item, index){
                    //     ORDER_CD.push(item.ORDER_CD)
                    // })
                    var itemH = fnObj.gridView01.getData('selected')[0]
                    $.openCustomPopup("PDF_1",'UserCallBack', '', { ORDER_CD : itemH.ORDER_CD }, '', 1400, 700,50);
                }
                ,
                PDF_2 : function (caller, act, data) {
                    // var cklist = isChecked(fnObj.gridView01.getData())
                    // var ORDER_CD = []
                    // cklist.forEach(function(item, index){
                    //     ORDER_CD.push(item.ORDER_CD)
                    // })
                    var itemH = fnObj.gridView01.getData('selected')[0]
                    $.openCustomPopup("PDF_2",'UserCallBack', '', { ORDER_CD : itemH.ORDER_CD }, '', 1400, 700,50);
                }
            });
            // fnObj 기본 함수 스타트와 리사이즈
            fnObj.pageStart = function () {
                this.pageButtonView.initView();
                this.searchView.initView();
                this.gridView01.initView();
                this.gridView02.initView();
                this.gridView03.initView();
                if(SCRIPT_SESSION.cdGroup !='WEB01'){
                    $('#SUCCESS').css('display','none')
                }
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
                            var item = fnObj.gridView01.getData('selected')[0];
                        	var list = $.DATA_SEARCH("order", "excel",{TYPE:'01' , COMPANY_CD : SCRIPT_SESSION.cdCompany , ORDER_CD : item.ORDER_CD , TEMP1 : SCRIPT_SESSION.idUser })
                            fnObj.gridView03.setData(list)
                            fnObj.gridView03.target.exportExcel('[본사용]주문내역'+$('#S_DT').getStartDate()+'_'+$('#tradeDateT').getEndDate()+'.xls')
                        
                            /* var cklist = isChecked(fnObj.gridView01.getData())
                            if (cklist != null){
                                if (cklist.length == 0){
                                    qray.alert('체크된 데이터가 없습니다.');
                                    return;
                                }
                            
	                            cklist.forEach(function(item, index){
	                                var list = $.DATA_SEARCH("order", "excel",{TYPE:'01' , COMPANY_CD : SCRIPT_SESSION.cdCompany , ORDER_CD : item.ORDER_CD , TEMP1 : SCRIPT_SESSION.idUser })
	                                fnObj.gridView03.setData(list)
	                                fnObj.gridView03.target.exportExcel('[본사용]주문내역'+$('#S_DT').getStartDate()+'_'+$('#tradeDateT').getEndDate()+'.xls')
	                            })
                            } */
                        }
                        , "excel2": function () {
                            
                           var item = fnObj.gridView01.getData('selected')[0];
                           var list = $.DATA_SEARCH("order", "excel",{TYPE:'04' , COMPANY_CD : SCRIPT_SESSION.cdCompany , ORDER_CD : item.ORDER_CD , TEMP1 : SCRIPT_SESSION.idUser})
                           fnObj.gridView03.setData(list)
                           fnObj.gridView03.target.exportExcel('[물류샤용]주문내역'+$('#S_DT').getStartDate()+'_'+$('#tradeDateT').getEndDate()+'.xls')
	                         
                            
                        }
                        , "pdf1": function () {
                            ACTIONS.dispatch(ACTIONS.PDF_1);
                        }
                        , "pdf2": function () {
                            ACTIONS.dispatch(ACTIONS.PDF_2);
                        }
                        , "SUCCESS" : function(){
                            ACTIONS.dispatch(ACTIONS.SUCCESS);
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
                            ,{
                                key: "CHKED", label: "", width: 30, align: "center",
                                label:
                                    '<div id="headerBox" data-ax5grid-editor="checkbox" data-ax5grid-checked="false" data-ax5grid-column-selected="true" style="height:17px;width:17px;margin-top:2px;  onclick="javascript:alert(1);"></div>',
                                editor: {
                                    type: "checkbox", config: {height: 17, trueValue: true, falseValue: false}
                                }, dirty : false
                            }
                            ,{key: "JOIN_PT_CD"         , label: "가맹점거래처코드"           , width: 150     , align: "center"   , editor: false  ,sortable:true , hidden:true}
                            ,{key: "JOIN_PT_NM"         , label: "가맹점거래처명"             , width: 150     , align: "left"   , editor: false  ,sortable:true}
                            ,{key: "SIGN_NM"         , label: "간판명"             			  , width: 150     , align: "left"   , editor: false  ,sortable:true}
                            ,{key: "ORDER_CD"           , label: "주문코드"                   , width: 150     , align: "center"   , editor: false  ,sortable:true , hidden:true}
                            ,{key: "ORDER_STAT"         , label: "주문상태"                   , width: 100     , align: "center"    ,sortable:true
                                , editor: {
                                    type: "select", config: {
                                        columnKeys: {
                                            optionValue: "value", optionText: "text"
                                        },
                                        options: ORDER_STAT
                                    }, disabled: function () {
                                        if(SCRIPT_SESSION.cdGroup == 'WEB01' || SCRIPT_SESSION.cdGroup == 'WEB02'){
                                        return false;
                                        }else{
                                            return true;
                                        }
                                    }
                                }
                                , formatter: function () {
                                    return $.changeTextValue(ORDER_STAT, this.value)
                                }
                            }
                            ,{key: "ORDER_DTE"          , label: "주문일자"                   , width: 150     , align: "center"   , editor: false  ,sortable:true}
                            ,{key: "ORDER_AMT"          , label: "주문금액"                   , width: 120     , align: "right"   , editor: false  ,sortable:true
                                ,formatter: function () {
                                    return $.changeDataFormat(this.value, 'money')
                                }
                            }
                            ,{key: "DISC_AMT"           , label: "할인금액"                   , width: 120     , align: "right"   , editor: false  ,sortable:true
                                ,formatter: function () {
                                    return $.changeDataFormat(this.value, 'money')
                                }
                            }
                            ,{key: "DELI_AMT"           , label: "배송금액"                   , width: 120     , align: "right"   , editor: false  ,sortable:true
                                ,formatter: function () {
                                    return $.changeDataFormat(this.value, 'money')
                                }
                            }
                            ,{key: "PAYM_AMT"           , label: "결제금액"                   , width: 120     , align: "right"   , editor: false  ,sortable:true
                                ,formatter: function () {
                                    return $.changeDataFormat(this.value, 'money')
                                }
                            }
                            ,{key: "BUYER_NM"           , label: "구매자명"                   , width: 120     , align: "left"   , editor: false  ,sortable:true}
                            ,{key: "BUYER_HP"           , label: "구매자 휴대폰"              , width: 120     , align: "center"   , editor: false  ,sortable:true
                                ,formatter: function () {
                                    return $.changeDataFormat(this.value, 'tel')
                                }
                            }
                            ,{key: "BUYER_POST_NO"      , label: "구매자 우편번호"            , width: 100     , align: "center"   , editor: false  ,sortable:true}
                            ,{key: "BUYER_ADDR"         , label: "구매자 주소"                , width: 150     , align: "left"   , editor: false  ,sortable:true}
                            ,{key: "BUYER_SYSDEF_ADDR"  , label: "구매자 상세주소"            , width: 150     , align: "left"   , editor: false  ,sortable:true}
                            ,{key: "DELI_REQ"           , label: "배송요청"                   , width: 150     , align: "left"   , editor: false  ,sortable:true}
                            ,{key: "PAYM_METHOD"        , label: "결제방법"                   , width: 120     , align: "center"   , editor: false  ,sortable:true
                                ,formatter: function () {
                                    return $.changeTextValue(PAYM_METHOD, this.value)
                                }
                            }
                            ,{key: "TERMS_AGREE_YN"     , label: "약관동의여부"               , width: 80     , align: "center"   , editor: false  ,sortable:true}
                        ],

                        body: {
                            onDataChanged: function () {

                            },
                            //444
                            onClick: function () {
                                var index = this.dindex;
                                if(afterIndex == index){return false;}

                                var data = [].concat(fnObj.gridView02.getData("modified"));
                                data = data.concat(fnObj.gridView02.getData("deleted"))
                                data = data.concat(fnObj.gridView01.getData("modified"));
                                data = data.concat(fnObj.gridView01.getData("deleted"));

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
                             {key: "COMPANY_CD"       , label: "", width: 150, align: "left", editor: {type: "text"} ,hidden:true}
                            ,{
                                key: "CHKED", label: "", width: 30, align: "center",
                                label:
                                    '<div id="headerBox2" data-ax5grid-editor="checkbox" data-ax5grid-checked="false" data-ax5grid-column-selected="true" style="height:17px;width:17px;margin-top:2px;  onclick="javascript:alert(1);"></div>',
                                editor: {
                                    type: "checkbox", config: {height: 17, trueValue: true, falseValue: false}
                                }, dirty : false
                            }
                            , {key: "JOIN_PT_CD"         , label: "가맹점거래처코드"           , width: 150     , align: "center"   , sortable: true  , editor: false , hidden:true}
                            , {key: "JOIN_PT_NM"         , label: "가맹점거래처명"             , width: 150     , align: "center"   , sortable: true  , editor: false , hidden:true}
                            , {key: "ORDER_CD"           , label: "주문코드"                   , width: 150     , align: "center"   , sortable: true  , editor: false , hidden:true}
                            , {key: "ORDER_SEQ"          , label: "주문일자"                   , width: 150     , align: "center"   , sortable: true  , editor: false , hidden:true}
                            , {key: "ITEM_SP"            , label: "상품유형"                   , width: 150     , align: "center"   , sortable: true  , editor: false
                                ,formatter: function () {
                                    return $.changeTextValue(ITEM_SP, this.value)
                                }
                            }
                            , {key: "ITEM_CD"            , label: "상품코드"                   , width: 150     , align: "center"   , sortable: true  , editor: false , hidden:true}
                            , {key: "ITEM_NM"            , label: "상품명"                   , width: 150     , align: "left"   , sortable: true  , editor: false , hidden:false}
                            , {key: "ITEM_WT"         	 , label: "상품중량"                   , width: 100     , align: "right"   , sortable: true  , editor: false , hidden:false}
                            , {key: "BOX_NUM"         	 , label: "박스수량"                   , width: 100     , align: "right"   , sortable: true  , editor: false , hidden:false}
                            , {key: "ITEM_UNIT"          , label: "출고단위"                   , width: 100     , align: "right"   , sortable: true  , editor: false , hidden:false,
                            	formatter: function () {
                                    return $.changeTextValue(dl_ITEM_UNIT, this.value)
                                },
                              }
                            , {key: "ORIGIN_NM"          , label: "원산지"                   , width: 100     , align: "right"   , sortable: true  , editor: false , hidden:false}
                            , {key: "SELECT_NUM"         , label: "상품수량"                   , width: 100     , align: "right"   , sortable: true  , editor: false , hidden:false}
                            , {key: "DISC_AMT"           , label: "할인금액"                   , width: 150     , align: "right"   , sortable: true  , editor: false
                                ,formatter: function () {
                                    return $.changeDataFormat(this.value, 'money')
                                }
                            }
                            , {key: "PAYM_AMT"           , label: "결제금액"                   , width: 150     , align: "right"   , sortable: true  , editor: false
                                ,formatter: function () {
                                    return $.changeDataFormat(this.value, 'money')
                                }
                            }
                            , {key: "DELI_STAT"          , label: "배송상태"                   , width: 150     , align: "center"   , sortable: true
                                , editor: {
                                    type: "select", config: {
                                        columnKeys: {
                                            optionValue: "value", optionText: "text"
                                        },
                                        options: DELI_STAT
                                    }, disabled: function () {
                                        // if(SCRIPT_SESSION.cdGroup == 'WEB02' || SCRIPT_SESSION.cdGroup == 'WEB03'){
                                            return false;
                                        // }else{
                                        //     return true;
                                        // }
                                    }
                                }
                                , formatter: function () {
                                    return $.changeTextValue(DELI_STAT, this.value)
                                }
                            }
                            , {key: "AREA_NM"           , label: "관할구역"                   , width: 150     , align: "left"   , sortable: true  , editor: false}
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
                        ,"SUCCESS2":function(){
                            ACTIONS.dispatch(ACTIONS.SUCCESS2);
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
            fnObj.gridView03 = axboot.viewExtend(axboot.gridView, {
                page: {
                    pageNumber: 0,
                    pageSize: 10
                },
                initView: function () {
                    var _this = this;

                    this.target = axboot.gridBuilder({
                        showRowSelector: true,
                        frozenColumnIndex: 0,
                        target: $('[data-ax5grid="grid-view-03"]'),
                        columns: [
                            {key: "COMPANY_CD"       , label: "", width: 150, align: "left", editor: false ,hidden:true}
                            ,{key: "ORDER_CD"       , label: "주문번호", width: 150, align: "left", editor: false ,hidden:false}
                            ,{key: "ORDER_DT"       , label: "주문일자", width: 150, align: "left", editor: false ,hidden:false}
                            ,{key: "PT_NM"       , label: "공급자상호", width: 150, align: "left", editor: false ,hidden:false}
                            ,{key: "BIZ_NO"       , label: "사업자번호", width: 150, align: "left", editor: false ,hidden:false}
                            ,{key: "OWNER_NM"       , label: "공급자 대표자명", width: 150, align: "left", editor: false ,hidden:false}
                            ,{key: "TEL_NO"       , label: "공급자 전화", width: 150, align: "left", editor: false ,hidden:false}
                            ,{key: "FAX_NO"       , label: "공급자 팩스", width: 150, align: "left", editor: false ,hidden:false}
                            ,{key: "ADDR"       , label: "급자 주소", width: 150, align: "left", editor: false ,hidden:false}
                            ,{key: "PT_NM2"       , label: "공급받는자 상호", width: 150, align: "left", editor: false ,hidden:false}
                            ,{key: "BIZ_NO2"       , label: "공급받는자 사업자번호", width: 150, align: "left", editor: false ,hidden:false}
                            ,{key: "OWNER_NM2"       , label: "공급받는자 대표자명", width: 150, align: "left", editor: false ,hidden:false}
                            ,{key: "TEL_NO2"       , label: "공급받는자 전화", width: 150, align: "left", editor: false ,hidden:false}
                            ,{key: "FAX_NO2"       , label: "공급받는자 팩스", width: 150, align: "left", editor: false ,hidden:false}
                            ,{key: "ADDR2"       , label: "공급받는자 주소", width: 150, align: "left", editor: false ,hidden:false}
                            ,{key: "ORDER_ITEM"       , label: "품명 및 규격", width: 150, align: "left", editor: false ,hidden:false}
                            , {key: "ITEM_WT"         	 , label: "상품중량"                   , width: 100     , align: "right"   , sortable: true  , editor: false , hidden:false}
                            , {key: "BOX_NUM"         	 , label: "박스수량"                   , width: 100     , align: "right"   , sortable: true  , editor: false , hidden:false}
                            , {key: "ITEM_UNIT"          , label: "출고단위"                   , width: 100     , align: "right"   , sortable: true  , editor: false , hidden:false}
                            ,{key: "ORIGIN_NM"       , label: "원산지", width: 150, align: "left", editor: false ,hidden:false}
                            ,{key: "SELECT_NUM"       , label: "상품수량", width: 150, align: "left", editor: false ,hidden:false}
                            ,{key: "SALE_COST"       , label: "단가", width: 150, align: "left", editor: false ,hidden:false}
                            ,{key: "ORDER_AMT"       , label: "금액", width: 150, align: "left", editor: false ,hidden:false}
                            ,{key: "ORDER_VAT"       , label: "세액", width: 150, align: "left", editor: false ,hidden:false}
                            ,{key: "OREDER_SPPLUY"       , label: "공급가액", width: 150, align: "left", editor: false ,hidden:false}

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
                },
                getData: function (_type) {
                    var list = [];
                    var _list = this.target.getList(_type);
                    list = _list;

                    return list;
                }
            });

            function isChecked(data) {
                var array = [];
                for (var i = 0; i < data.length; i++) {
                    if (data[i].CHKED == true) {
                        array.push(data[i])
                    }
                }
                return array;
            }


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

                $("#left_grid").css("height" ,(tempgridheight / 100 * 99 - $('.ax-button-group').height() ) / 2 );
                $("#left_grid2").css("height", (tempgridheight / 100 * 99 - $('.ax-button-group').height()) / 2 );
                /*
                alert($("#ax-base-root").height()); // 컨텐츠영역높이
                ax-base-title //타이틀부분높이(class)
                ax-base-content //검색조건높이(class)
                 */
            }

            var cnt = 0;
            $(document).on('click', '#headerBox', function(e) {
                if(cnt == 0){
                    $("div [data-ax5grid='grid-view-01']").find("div #headerBox").attr("data-ax5grid-checked",true);
                    cnt++;
                    var gridList = fnObj.gridView01.getData();
                    gridList.forEach(function(e, i){
                        fnObj.gridView01.target.setValue(i,"CHKED",true);
                    });
                    // $("div [data-ax5grid-editor='checkbox']").attr("data-ax5grid-checked",true)
                }else{
                    $("div [data-ax5grid='grid-view-01']").find("div #headerBox").attr("data-ax5grid-checked",false);
                    cnt = 0;
                    var gridList = fnObj.gridView01.getData();
                    gridList.forEach(function(e, i){
                        fnObj.gridView01.target.setValue(i,"CHKED",false);
                    });
                    // $("div [data-ax5grid-editor='checkbox']").attr("data-ax5grid-checked",false)
                }

            });

            var cnt2 = 0;
            $(document).on('click', '#headerBox2', function(e) {
                if(cnt2 == 0){
                    $("div [data-ax5grid='grid-view-02']").find("div #headerBox2").attr("data-ax5grid-checked",true);
                    cnt2++;
                    var gridList = fnObj.gridView02.getData();
                    gridList.forEach(function(e, i){
                        fnObj.gridView02.target.setValue(i,"CHKED",true);
                    });
                    // $("div [data-ax5grid-editor='checkbox']").attr("data-ax5grid-checked",true)
                }else{
                    $("div [data-ax5grid='grid-view-02']").find("div #headerBox2").attr("data-ax5grid-checked",false);
                    cnt2 = 0;
                    var gridList = fnObj.gridView02.getData();
                    gridList.forEach(function(e, i){
                        fnObj.gridView02.target.setValue(i,"CHKED",false);
                    });
                    // $("div [data-ax5grid-editor='checkbox']").attr("data-ax5grid-checked",false)
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
                <button type="button" class="btn btn-info" data-page-btn="excel" id="excel" style="width: 130px;"><i
                        class="icon_save"></i>[본사용]엑셀다운로드
                </button>
                <button type="button" class="btn btn-info" data-page-btn="excel2" id="excel2" style="width: 150px;"><i
                        class="icon_save"></i>[물류사용]엑셀다운로드
                </button>
                <button type="button" class="btn btn-info" data-page-btn="pdf1" id="pdf1" style="width: 150px;"><i
                        class="icon_save"></i>[본사용]거래명세서
                </button>
                <button type="button" class="btn btn-info" data-page-btn="pdf2" id="pdf2" style="width: 150px;"><i
                        class="icon_save"></i>[물류사용]거래명세서
                </button>
                
            </div>
        </div>

        <div role="page-header" id="pageheader">
            <ax:form name="searchView0">
                <ax:tbl clazz="ax-search-tb1" minWidth="500px">
                    <ax:tr>
                        <ax:td label='주문일자' width="450px">
                            <datepicker id="S_DT"></datepicker>
                        </ax:td>
                    </ax:tr>
                </ax:tbl>
            </ax:form>
        </div>

        <%-- 그리드 영역 시작 --%>
        <div style="width:100%;overflow:hidden">
            <div style="width:99%;overflow:hidden;">
                <div class="ax-button-group" data-fit-height-aside="grid-view-01" id="left_title" name="왼쪽그리드타이틀">
                    <div class="left">
                        <h2>
                            <i class="icon_list"></i> 주문리스트
                        </h2>
                    </div>
                    <div class="right">
                        <button type="button" class="btn btn-info" data-page-btn="SUCCESS" id="SUCCESS" style="width: 130px;"><i
                                class="icon_save"></i>일괄입금완료처리
                        </button>
                    </div>

                </div>

                <div data-ax5grid="grid-view-01"
                     data-ax5grid-config="{  showLineNumber: true,showRowSelector: false, multipleSelect: false,lineNumberColumnWidth: 40,rowSelectorColumnWidth: 27, }"
                     id = "left_grid"
                     name="왼쪽그리드"
                ></div>

                <div class="ax-button-group" data-fit-height-aside="grid-view-02" id="left_title2" name="왼쪽그리드타이틀">
                    <div class="left">
                        <h2>
                            <i class="icon_list"></i> 주문상세
                        </h2>
                    </div>
                    <div class="right">
                        <button type="button" class="btn btn-info" data-grid-view-02-btn="SUCCESS2" id="SUCCESS2" style="width: 130px;"><i
                                class="icon_save"></i>일괄배송완료처리
                        </button>
                    </div>
                </div>

                <div data-ax5grid="grid-view-02"
                     data-ax5grid-config="{  showLineNumber: true,showRowSelector: false, multipleSelect: false,lineNumberColumnWidth: 40,rowSelectorColumnWidth: 27, }"
                     id = "left_grid2"
                     name="왼쪽그리드"
                ></div>

                <div data-ax5grid="grid-view-03" style="display: none"
                     data-ax5grid-config="{  showLineNumber: true,showRowSelector: false, multipleSelect: false,lineNumberColumnWidth: 40,rowSelectorColumnWidth: 27, }"
                     id = "left_grid3"
                     name="왼쪽그리드"
                ></div>
            </div>



            </div>
        </div>


    </jsp:body>
</ax:layout>