<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>

<ax:set key="title" value="입출고관리"/>
<ax:set key="page_desc" value="${pageRemark}"/>
<ax:set key="page_auto_height" value="true"/>


<ax:layout name="base">
    <jsp:attribute name="script">


        <ax:script-lang key="ax.script"/>
        <style>
            .red {
                background: #ffe0cf !important;
            }

            .readonly {
                background: #EEEEEE !important;
            }
        </style>
        <script type="text/javascript">

            var afterIndex = 0;
            var selectRow2 = 0;
            var ORDR_STAT = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'MA00020');
            var INOUT_TP = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'MA00019');
            var YN_OP = [{value:'' , text:''},{value:'Y' , text:'Y'},{value:'N' , text:'N'}];

            var CallBack1;
            var fnObj = {}, CODE = {};
            var ACTIONS = axboot.actionExtend(fnObj, {
                PAGE_SEARCH: function (caller, act, data) {
                    var list = $.DATA_SEARCH('DeliverPartner','selectH',{CD_COMPANY:SCRIPT_SESSION.cdCompany , KEYWORD : $('#KEYWORD').val()});
                    fnObj.gridView01.target.setData(list);
                    caller.gridView01.target.select(afterIndex);
                    caller.gridView01.target.focus(afterIndex);
                    ACTIONS.dispatch(ACTIONS.ITEM_CLICK,caller);
                    selectRow2 = 0;
                    var param = {}
                    if(SCRIPT_SESSION.cdGroup == 'WEB01'){
                        param = {INOUT_TP : '03'}
                    }
                    if(SCRIPT_SESSION.cdGroup == 'WEB04'){
                        param = {INOUT_TP : '04'}
                    }
                    var list3 = $.DATA_SEARCH('DeliverPartner','selectD',param);
                    fnObj.gridView04.target.setData(list3);

                    return false;
                },
                PAGE_SAVE: function (caller, act, data) {


                    var itemH = [].concat(caller.gridView01.getData("modified"));
                    itemH = itemH.concat(caller.gridView01.getData("deleted"));

                    var itemD = [].concat(caller.gridView02.getData("modified"));
                    itemD = itemD.concat(caller.gridView02.getData("deleted"));


                    if(itemH.length == 0 && itemD.length == 0){
                        qray.alert('변경된 정보가 없습니다.');
                        return;
                    }
                    var data = {
                         insertM: caller.gridView01.getData("modified")
                        ,deleteM: caller.gridView01.getData("deleted")
                        ,insertD: caller.gridView02.getData("modified")
                        ,deleteD: caller.gridView02.getData("deleted")
                    };

                    axboot.ajax({
                        type: "POST",
                        url: ["DeliverPartner", "save"],
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
                    if (nvl(selected) == '') {
                        return false;
                    }
                    selected.INOUT_TP = '01'
                    var list = $.DATA_SEARCH('DeliverPartner','selectD',selected);
                    fnObj.gridView02.target.setData(list);

                    selected.INOUT_TP = '02'
                    var list2 = $.DATA_SEARCH('DeliverPartner','selectD',selected);
                    fnObj.gridView03.target.setData(list2);



                    return false;
                },
                ITEM_ADD1: function (caller, act, data) {
                    fnObj.gridView01.addRow();
                    var lastIdx = nvl(fnObj.gridView01.target.list.length, fnObj.gridView01.lastRow());
                    afterIndex = lastIdx
                    fnObj.gridView01.target.select(lastIdx - 1);
                    fnObj.gridView01.target.focus(lastIdx - 1);
                    fnObj.gridView01.target.setValue(lastIdx - 1, "BEGINING_IN_NUM", 0);
                    fnObj.gridView01.target.setValue(lastIdx - 1, "SAFE_STOCK_NUM", 0);
                    fnObj.gridView01.target.setValue(lastIdx - 1, "STOCK_NUM", 0);
                    fnObj.gridView01.target.setValue(lastIdx - 1, "ORDR_STAT", '02');
                    /*
                    CallBack1 = function (e) {
                        var chkArr = [];
                        for (var i = 0; i < fnObj.gridView01.target.list.length; i++) {
                            chkArr.push(fnObj.gridView01.target.list[i].DISTRIB_PT_CD);
                        }
                        chkArr = chkArr.join('|');

                        if (e.length > 0) {
                            for (var i = 0; i < e.length; i++) {
                                if (chkArr.indexOf(e[i].PT_CD) > -1) continue;
                                fnObj.gridView01.addRow();

                                var lastIdx = nvl(fnObj.gridView01.target.list.length, fnObj.gridView01.lastRow());

                                fnObj.gridView01.target.setValue(lastIdx - 1, "DISTRIB_PT_CD", e[i].PT_CD);
                                fnObj.gridView01.target.setValue(lastIdx - 1, "DISTRIB_PT_NM", e[i].PT_NM);
                                fnObj.gridView01.target.select(lastIdx - 1);
                            }

                        }
                        modal.close();
                    };
                    $.openCommonPopup("multiPartner", "CallBack1", 'HELP_PARTNER', '', {PT_SP : '03'}, 600, _pop_height, _pop_top);
                    */
                },

                ITEM_ADD2: function (caller, act, data) {

                    if (caller.gridView01.getData('selected').length == 0) {
                        qray.alert("선택된 물류사가 없습니다.");
                        return;
                    }

                    caller.gridView02.addRow();
                    var itemH = caller.gridView01.getData('selected')[0]
                    var lastIdx = nvl(caller.gridView02.target.list.length, caller.gridView02.lastRow());
                    caller.gridView02.target.select(lastIdx - 1);
                    selectRow2 = lastIdx - 1;
                    caller.gridView02.target.focus(lastIdx - 1);
                    caller.gridView02.target.setValue(lastIdx - 1, "COMPANY_CD", itemH.COMPANY_CD);
                    caller.gridView02.target.setValue(lastIdx - 1, "DISTRIB_PT_CD", itemH.DISTRIB_PT_CD);
                    caller.gridView02.target.setValue(lastIdx - 1, "DISTRIB_PT_NM", itemH.DISTRIB_PT_NM);
                    caller.gridView02.target.setValue(lastIdx - 1, "ITEM_CD", itemH.ITEM_CD);
                    caller.gridView02.target.setValue(lastIdx - 1, "ITEM_NM", itemH.ITEM_NM);
                    caller.gridView02.target.setValue(lastIdx - 1, "MAKE_PT_CD", itemH.MAKE_PT_CD);
                    caller.gridView02.target.setValue(lastIdx - 1, "MAKE_PT_NM", itemH.MAKE_PT_NM);


                },
                ITEM_DEL1: function (caller, act, data) {
                    var beforeIdx = caller.gridView01.getData('selected')[0].__index;
                    caller.gridView01.delRow("selected");
                }
                ,
                ITEM_DEL2: function (caller, act, data) {
                    caller.gridView02.delRow("selected");
                }
                ,APPLY_WEB01: function (caller, act, data) {
                    var param = isChecked(fnObj.gridView04.getData())
                    if(param.length == 0){
                        qray.alert('체크된 데이터가 없습니다.')
                        return ;
                    }
                    for(var i = 0; i < param.length; i++){
                        if(nvl(param[i].MAKE_VERIFY_YN,'N') == 'Y'){
                            qray.alert('이미 승인된 내역입니다.')
                            return
                        }
                        param[i]['GROUP'] = 'WEB01'
                    }


                    axboot.ajax({
                        type: "POST",
                        url: ["DeliverPartner", "APPLY_INOUT"],
                        data: JSON.stringify({list : param}),
                        callback: function (res) {
                            qray.alert("저장 되었습니다.");
                            ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                            caller.gridView01.target.select(afterIndex);
                            caller.gridView01.target.focus(afterIndex);

                        }
                    });
                }
                ,APPLY_WEB04: function (caller, act, data) {
                    var param = isChecked(fnObj.gridView04.getData())
                    if(param.length == 0){
                        qray.alert('체크된 데이터가 없습니다.')
                        return ;
                    }
                    for(var i = 0; i < param.length; i++){
                        if(nvl(param[i].MAKE_VERIFY_YN,'N') != 'Y'){
                            qray.alert('본사 승인이 선행되어야합니다.')
                            return
                        }
                        if(nvl(param[i].DISTRIB_VERIFY_YN,'N') == 'Y'){
                            qray.alert('이미 승인된 내역입니다.')
                            return
                        }
                        param[i]['GROUP'] = 'WEB04'
                    }

                    axboot.ajax({
                        type: "POST",
                        url: ["DeliverPartner", "APPLY_INOUT"],
                        data: JSON.stringify({list : param}),
                        callback: function (res) {
                            qray.alert("저장 되었습니다.");
                            ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                            caller.gridView01.target.select(afterIndex);
                            caller.gridView01.target.focus(afterIndex);

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
                this.gridView03.initView();
                this.gridView04.initView();

                $('#applyWEB01').css('display','none')
                $('#applyWEB04').css('display','none')

                if(SCRIPT_SESSION.cdGroup == 'WEB01'){
                    $('#applyWEB01').css('display','')
                }
                if(SCRIPT_SESSION.cdGroup == 'WEB04'){
                    $('#applyWEB04').css('display','')
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

                        }
                    });
                }
            });

            //== view 시작
            fnObj.searchView = axboot.viewExtend(axboot.searchView, {
                initView: function () {
                    this.target = $(document["searchView0"]);
                    this.target.attr("onsubmit", "return ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);");
                },
                getData: function () {
                    return {
                    }
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
                             {key: "COMPANY_CD"       , label: ""              , width: 150, align: "left" , sortabled:true ,  hidden:true , editor: false }
                            ,{key: "DISTRIB_PT_CD"    , label: "<span style=\"color:red;\"> * </span> 물류거래처코드" , width: 150, align: "left" , sortabled:true ,  hidden:false , editor: false
                                , styleClass: function () {
                                    return "readonly";
                                }
                             }
                            ,{key: "DISTRIB_PT_NM"    , label: "<span style=\"color:red;\"> * </span> 물류거래처명"   , width: 150, align: "left" , sortabled:true ,  hidden:false , editor: false
                                ,picker: {
                                    top: _pop_top,
                                    width: 600,
                                    height: _pop_height,
                                    url: "distrib_partner",
                                    action: ["commonHelp", "HELP_DISTRIP_PARTNER"],
                                    param: function () {
                                    },
                                    callback: function (e) {
                                        fnObj.gridView01.target.setValue(this.dindex, "DISTRIB_PT_CD", e[0].PT_CD);
                                        fnObj.gridView01.target.setValue(this.dindex, "DISTRIB_PT_NM", e[0].PT_NM);
                                    },
                                    disabled: function () {
                                        if(nvl(this.__created__,false)){
                                            return true;
                                        }else{
                                            return false;
                                        }
                                    }
                                }
                            }
                            ,{key: "ITEM_CD"          , label: "<span style=\"color:red;\"> * </span> 상품코드"	    , width: 150, align: "left" , sortabled:true ,  hidden:false , editor: false
                                , styleClass: function () {
                                    return "readonly";
                                }
                             }
                            ,{key: "ITEM_NM"          , label: "<span style=\"color:red;\"> * </span> 상품명"		, width: 150, align: "left" , sortabled:true ,  hidden:false , editor: false
                                ,picker: {
                                    top: _pop_top,
                                    width: 600,
                                    height: _pop_height,
                                    url: "item",
                                    action: ["commonHelp", "HELP_ITEM"],
                                    param: function () {
                                    },
                                    callback: function (e) {
                                        fnObj.gridView01.target.setValue(this.dindex, "ITEM_CD", e[0].ITEM_CD);
                                        fnObj.gridView01.target.setValue(this.dindex, "ITEM_NM", e[0].ITEM_NM);
                                        fnObj.gridView01.target.setValue(this.dindex, "MAKE_PT_CD", e[0].MAKE_PT_CD);
                                        fnObj.gridView01.target.setValue(this.dindex, "MAKE_PT_NM", e[0].MAKE_PT_NM);
                                    },
                                    disabled: function () {
                                        if(nvl(this.__created__,false)){
                                            return true;
                                        }else{
                                            return false;
                                        }
                                    }
                                }
                            }
                            ,{key: "BEGINING_IN_NUM"  , label: "<span style=\"color:red;\"> * </span> 초기입고수량"	, width: 150, align: "left" , sortabled:true ,  hidden:false , editor: {type:"number"} }
                            ,{key: "SAFE_STOCK_NUM"   , label: "<span style=\"color:red;\"> * </span> 안전재고수량"	, width: 150, align: "left" , sortabled:true ,  hidden:false , editor: {type:"number"} }
                            ,{key: "STOCK_NUM"        , label: "<span style=\"color:red;\"> * </span> 재고수량"	    , width: 150, align: "left" , sortabled:true ,  hidden:false , editor: {type:"number"} }
                            ,{key: "ORDR_STAT"        , label: "발주상태"	    , width: 150, align: "left" , sortabled:true ,  hidden:false
                                , editor: {
                                    type: "select", config: {
                                        columnKeys: {
                                            optionValue: "value", optionText: "text"
                                        },
                                        options: ORDR_STAT
                                    }
                                    , disabled: function () {
                                    }
                                }
                                ,formatter: function () {
                                    return $.changeTextValue(ORDR_STAT, this.value)
                                }
                            }
                            ,{key: "MAKE_PT_CD"       , label:	"제조거래처코드"  , width: 150, align: "left" , sortabled:true ,  hidden:true, editor: false}
                            ,{key: "MAKE_PT_NM"       , label:	"제조거래처명"  , width: 150, align: "left" , sortabled:true ,  hidden:false , editor: false}
                        ],

                        body: {
                            onDataChanged: function () {

                            },
                            //444
                            onClick: function () {
                                var index = this.dindex;
                                if(afterIndex == index){return false;}
                                var data = []
                                //     [].concat(fnObj.gridView01.getData("modified"));
                                // data = data.concat(fnObj.gridView01.getData("deleted"));
                                // data = data.concat(fnObj.gridView02.getData("modified"));
                                // data = data.concat(fnObj.gridView02.getData("deleted"));

                                if(data.length > 0){
                                    qray.confirm({
                                        msg: "작업중인 상세 데이터를 먼저 저장해주십시오."
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
                    axboot.buttonClick(this, "data-grid-view-01-btn", {
                        "add": function () {
                            ACTIONS.dispatch(ACTIONS.ITEM_ADD1);
                        },
                        "delete": function () {

                            var beforeIdx = this.target.selectedDataIndexs[0];
                            var dataLen = this.target.getList().length;

                            if ((beforeIdx + 1) == dataLen) {
                                beforeIdx = beforeIdx - 1;
                            }

                            ACTIONS.dispatch(ACTIONS.ITEM_DEL1);
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
                             {key: "COMPANY_CD"       , label: ""                , width: 150, align: "left" , sortabled:true ,  hidden:true , editor: false }
                            ,{key: "DISTRIB_PT_CD"    , label: "<span style=\"color:red;\"> * </span> 물류거래처코드"  , width: 150, align: "left" , sortabled:true , required:true ,  hidden:true , editor: false }
                            ,{key: "DISTRIB_PT_NM"    , label: "<span style=\"color:red;\"> * </span> 물류거래처명"    , width: 150, align: "left" , sortabled:true , required:true ,  hidden:false , editor: false
                                , styleClass: function () {
                                    return "readonly";
                                }
                            }
                            ,{key: "ITEM_CD"          , label: "<span style=\"color:red;\"> * </span> 상품코드"	      , width: 150, align: "left" , sortabled:true , required:true ,  hidden:true , editor: false }
                            ,{key: "ITEM_NM"          , label: "<span style=\"color:red;\"> * </span> 상품명"		  , width: 150, align: "left" , sortabled:true , required:true ,  hidden:false , editor: false
                                , styleClass: function () {
                                    return "readonly";
                                }
                            }
                            ,{key: "INOUT_SEQ"        , label: "<span style=\"color:red;\"> * </span> 입출고순번"      , width: 150, align: "left" , sortabled:true ,  hidden:true , editor: false }
                            ,{key: "INOUT_TP"         , label: "입출고구분"      , width: 150, align: "left" , sortabled:true ,  hidden:false
                                , editor: {
                                    type: "select", config: {
                                        columnKeys: {
                                            optionValue: "value", optionText: "text"
                                        },
                                        options: INOUT_TP
                                    }
                                    , disabled: function () {
                                        // if(this.item.MAKE_VERIFY_YN == 'Y' && this.item.DISTRIB_VERIFY_YN == 'Y'){
                                            return true;
                                        // }
                                    }
                                }
                                ,formatter: function () {
                                    return $.changeTextValue(INOUT_TP, this.value)
                                }
                            }
                            ,{key: "INOUT_DTE"        , label:	"입출고일자"      , width: 150, align: "left" , sortabled:true ,  hidden:false
                                , editor: {type:"date"
                                    ,disabled: function () {
                                        if(this.item.MAKE_VERIFY_YN == 'Y' && this.item.DISTRIB_VERIFY_YN == 'Y'){
                                            return true;
                                        }
                                    }
                                }
                             }
                            ,{key: "INOUT_NUM"        , label:	"입출고수량"      , width: 150, align: "left" , sortabled:true ,  hidden:false
                                , editor: {type:"number"
                                    ,disabled: function () {
                                        if(this.item.MAKE_VERIFY_YN == 'Y' && this.item.DISTRIB_VERIFY_YN == 'Y'){
                                            return true;
                                        }
                                    }
                                }
                             }
                            ,{key: "CCL_PRIOD_ST_DTE" , label:	"<span style=\"color:red;\"> * </span>유통기간시작일"  , width: 150, align: "left" , sortabled:true, required:true ,  hidden:false
                                , editor: {type:"date"
                                    ,disabled: function () {
                                        if(this.item.MAKE_VERIFY_YN == 'Y' && this.item.DISTRIB_VERIFY_YN == 'Y'){
                                            return true;
                                        }
                                    }
                                }
                            }
                            ,{key: "CCL_PRIOD_ED_DTE" , label:	"<span style=\"color:red;\"> * </span>유통기간종료일"  , width: 150, align: "left" , sortabled:true, required:true ,  hidden:false
                                , editor: {type:"date"
                                    ,disabled: function () {
                                        if(this.item.MAKE_VERIFY_YN == 'Y' && this.item.DISTRIB_VERIFY_YN == 'Y'){
                                            return true;
                                        }
                                    }
                                }
                            }
                            ,{key: "MAKE_PT_CD"       , label:	"제조거래처코드"  , width: 150, align: "left" , sortabled:true ,  hidden:true, editor: false}
                            ,{key: "MAKE_PT_NM"       , label:	"제조거래처명"  , width: 150, align: "left" , sortabled:true ,  hidden:false , editor: false
                                ,picker: {
                                    top: _pop_top,
                                    width: 600,
                                    height: _pop_height,
                                    url: "partner",
                                    action: ["commonHelp", "HELP_PARTNER"],
                                    param: function () {
                                        return {PT_SP : '03'}
                                    },
                                    callback: function (e) {
                                        fnObj.gridView02.target.setValue(this.dindex, "MAKE_PT_CD", e[0].PT_CD);
                                        fnObj.gridView02.target.setValue(this.dindex, "MAKE_PT_NM", e[0].PT_NM);
                                    }
                                    ,disabled: function () {
                                        if(this.item.MAKE_VERIFY_YN == 'Y' && this.item.DISTRIB_VERIFY_YN == 'Y'){
                                            return true;
                                        }
                                    }
                                }
                             }
                            ,{key: "MAKE_VERIFY_YN"   , label:	"<span style=\"color:red;\"> * </span>본사입고확인"  , width: 150, align: "left" , sortabled:true , required:true ,  hidden:false
                                , editor: {
                                    type: "select", config: {
                                        columnKeys: {
                                            optionValue: "value", optionText: "text"
                                        },
                                        options: YN_OP
                                    }
                                    ,disabled: function () {
                                        // if(this.item.MAKE_VERIFY_YN == 'Y' && this.item.DISTRIB_VERIFY_YN == 'Y'){
                                            return true;
                                        // }
                                    }
                                }
                                ,formatter: function () {
                                    return $.changeTextValue(YN_OP, this.value)
                                }
                            }
                            ,{key: "DISTRIB_VERIFY_YN", label:	"<span style=\"color:red;\"> * </span>물류사입고확인"  , width: 150, align: "left" , sortabled:true , required:true ,  hidden:false
                                , editor: {
                                    type: "select", config: {
                                        columnKeys: {
                                            optionValue: "value", optionText: "text"
                                        },
                                        options: YN_OP
                                    }
                                    ,disabled: function () {
                                        // if(this.item.MAKE_VERIFY_YN == 'Y' && this.item.DISTRIB_VERIFY_YN == 'Y'){
                                            return true;
                                        // }
                                    }
                                }
                                ,formatter: function () {
                                    return $.changeTextValue(YN_OP, this.value)
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
                            {key: "COMPANY_CD"       , label: ""                , width: 150, align: "left" , sortabled:true ,  hidden:true , editor: false }
                            ,{key: "DISTRIB_PT_CD"    , label: "<span style=\"color:red;\"> * </span> 물류거래처코드"  , width: 150, align: "left" , sortabled:true , required:true ,  hidden:true , editor: false }
                            ,{key: "DISTRIB_PT_NM"    , label: "<span style=\"color:red;\"> * </span> 물류거래처명"    , width: 150, align: "left" , sortabled:true , required:true ,  hidden:false , editor: false
                                , styleClass: function () {
                                    return "readonly";
                                }
                            }
                            ,{key: "ITEM_CD"          , label: "<span style=\"color:red;\"> * </span> 상품코드"	      , width: 150, align: "left" , sortabled:true , required:true ,  hidden:true , editor: false }
                            ,{key: "ITEM_NM"          , label: "<span style=\"color:red;\"> * </span> 상품명"		  , width: 150, align: "left" , sortabled:true , required:true ,  hidden:false , editor: false
                                , styleClass: function () {
                                    return "readonly";
                                }
                            }
                            ,{key: "INOUT_SEQ"        , label: "<span style=\"color:red;\"> * </span> 입출고순번"      , width: 150, align: "left" , sortabled:true ,  hidden:true , editor: false }
                            ,{key: "INOUT_TP"         , label: "입출고구분"      , width: 150, align: "left" , sortabled:true ,  hidden:false
                                , editor: {
                                    type: "select", config: {
                                        columnKeys: {
                                            optionValue: "value", optionText: "text"
                                        },
                                        options: INOUT_TP
                                    }
                                    , disabled: function () {
                                        if(this.item.MAKE_VERIFY_YN == 'Y' && this.item.DISTRIB_VERIFY_YN == 'Y'){
                                            return true;
                                        }
                                    }
                                }
                                ,formatter: function () {
                                    return $.changeTextValue(INOUT_TP, this.value)
                                }
                            }
                            ,{key: "INOUT_DTE"        , label:	"입출고일자"      , width: 150, align: "left" , sortabled:true ,  hidden:false
                                , editor: {type:"date"
                                    ,disabled: function () {
                                        if(this.item.MAKE_VERIFY_YN == 'Y' && this.item.DISTRIB_VERIFY_YN == 'Y'){
                                            return true;
                                        }
                                    }
                                }
                            }
                            ,{key: "INOUT_NUM"        , label:	"입출고수량"      , width: 150, align: "left" , sortabled:true ,  hidden:false
                                , editor: {type:"number"
                                    ,disabled: function () {
                                        if(this.item.MAKE_VERIFY_YN == 'Y' && this.item.DISTRIB_VERIFY_YN == 'Y'){
                                            return true;
                                        }
                                    }
                                }
                            }
                            ,{key: "CCL_PRIOD_ST_DTE" , label:	"<span style=\"color:red;\"> * </span>유통기간시작일"  , width: 150, align: "left" , sortabled:true, required:true ,  hidden:false
                                , editor: {type:"date"
                                    ,disabled: function () {
                                        if(this.item.MAKE_VERIFY_YN == 'Y' && this.item.DISTRIB_VERIFY_YN == 'Y'){
                                            return true;
                                        }
                                    }
                                }
                            }
                            ,{key: "CCL_PRIOD_ED_DTE" , label:	"<span style=\"color:red;\"> * </span>유통기간종료일"  , width: 150, align: "left" , sortabled:true, required:true ,  hidden:false
                                , editor: {type:"date"
                                    ,disabled: function () {
                                        if(this.item.MAKE_VERIFY_YN == 'Y' && this.item.DISTRIB_VERIFY_YN == 'Y'){
                                            return true;
                                        }
                                    }
                                }
                            }
                            ,{key: "MAKE_PT_CD"       , label:	"제조거래처코드"  , width: 150, align: "left" , sortabled:true ,  hidden:true, editor: false}
                            ,{key: "MAKE_PT_NM"       , label:	"제조거래처명"  , width: 150, align: "left" , sortabled:true ,  hidden:false , editor: false
                                ,picker: {
                                    top: _pop_top,
                                    width: 600,
                                    height: _pop_height,
                                    url: "partner",
                                    action: ["commonHelp", "HELP_PARTNER"],
                                    param: function () {
                                        return {PT_SP : '03'}
                                    },
                                    callback: function (e) {
                                        fnObj.gridView02.target.setValue(this.dindex, "MAKE_PT_CD", e[0].PT_CD);
                                        fnObj.gridView02.target.setValue(this.dindex, "MAKE_PT_NM", e[0].PT_NM);
                                    }
                                    ,disabled: function () {
                                        if(this.item.MAKE_VERIFY_YN == 'Y' && this.item.DISTRIB_VERIFY_YN == 'Y'){
                                            return true;
                                        }
                                    }
                                }
                            }
                            ,{key: "MAKE_VERIFY_YN"   , label:	"<span style=\"color:red;\"> * </span>본사입고확인"  , width: 150, align: "left" , sortabled:true , required:true ,  hidden:false
                                , editor: {
                                    type: "select", config: {
                                        columnKeys: {
                                            optionValue: "value", optionText: "text"
                                        },
                                        options: YN_OP
                                    }
                                    ,disabled: function () {
                                        // if(this.item.MAKE_VERIFY_YN == 'Y' && this.item.DISTRIB_VERIFY_YN == 'Y'){
                                            return true;
                                        // }
                                    }
                                }
                                ,formatter: function () {
                                    return $.changeTextValue(YN_OP, this.value)
                                }
                            }
                            ,{key: "DISTRIB_VERIFY_YN", label:	"<span style=\"color:red;\"> * </span>물류사입고확인"  , width: 150, align: "left" , sortabled:true , required:true ,  hidden:false
                                , editor: {
                                    type: "select", config: {
                                        columnKeys: {
                                            optionValue: "value", optionText: "text"
                                        },
                                        options: YN_OP
                                    }
                                    ,disabled: function () {
                                        // if(this.item.MAKE_VERIFY_YN == 'Y' && this.item.DISTRIB_VERIFY_YN == 'Y'){
                                            return true;
                                        // }
                                    }
                                }
                                ,formatter: function () {
                                    return $.changeTextValue(YN_OP, this.value)
                                }
                            }

                        ],
                        body: {
                            onClick: function () {
                                var data = this.item;           //  선택한 ROW의 ITEM들
                                var column = this.column.key;   //  컬럼 KEY명
                                var idx = this.dindex;          //  선택한 ROW의 INDEX

                                // selectRow2 = idx;
                                // this.self.select(selectRow2);
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
                        "applyWEB01": function () {
                            ACTIONS.dispatch(ACTIONS.APPLY_WEB01);
                        },
                        "applyWEB04": function () {

                            ACTIONS.dispatch(ACTIONS.APPLY_WEB04);

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
                                key: "CHKED", label: "", width: 30, align: "center",
                                label:
                                    '<div id="headerBox" data-ax5grid-editor="checkbox" data-ax5grid-checked="false" data-ax5grid-column-selected="true" style="height:17px;width:17px;margin-top:2px;  onclick="javascript:alert(1);"></div>',
                                editor: {
                                    type: "checkbox", config: {height: 17, trueValue: true, falseValue: false}
                                }
                            }
                            ,{key: "COMPANY_CD"       , label: ""                , width: 150, align: "left" , sortabled:true ,  hidden:true , editor: false }
                            ,{key: "DISTRIB_PT_CD"    , label: "<span style=\"color:red;\"> * </span> 물류거래처코드"  , width: 150, align: "left" , sortabled:true , required:true ,  hidden:true , editor: false }
                            ,{key: "DISTRIB_PT_NM"    , label: "<span style=\"color:red;\"> * </span> 물류거래처명"    , width: 150, align: "left" , sortabled:true , required:true ,  hidden:false , editor: false
                                , styleClass: function () {
                                    return "readonly";
                                }
                            }
                            ,{key: "ITEM_CD"          , label: "<span style=\"color:red;\"> * </span> 상품코드"	      , width: 150, align: "left" , sortabled:true , required:true ,  hidden:true , editor: false }
                            ,{key: "ITEM_NM"          , label: "<span style=\"color:red;\"> * </span> 상품명"		  , width: 150, align: "left" , sortabled:true , required:true ,  hidden:false , editor: false
                                , styleClass: function () {
                                    return "readonly";
                                }
                            }
                            ,{key: "INOUT_SEQ"        , label: "<span style=\"color:red;\"> * </span> 입출고순번"      , width: 150, align: "left" , sortabled:true ,  hidden:true , editor: false }
                            ,{key: "INOUT_TP"         , label: "입출고구분"      , width: 150, align: "left" , sortabled:true ,  hidden:false
                                , editor: {
                                    type: "select", config: {
                                        columnKeys: {
                                            optionValue: "value", optionText: "text"
                                        },
                                        options: INOUT_TP
                                    }
                                    , disabled: function () {
                                        if(this.item.MAKE_VERIFY_YN == 'Y' && this.item.DISTRIB_VERIFY_YN == 'Y'){
                                            return true;
                                        }
                                    }
                                }
                                ,formatter: function () {
                                    return $.changeTextValue(INOUT_TP, this.value)
                                }
                            }
                            ,{key: "INOUT_DTE"        , label:	"입출고일자"      , width: 150, align: "left" , sortabled:true ,  hidden:false
                                , editor: {type:"date"
                                    ,disabled: function () {
                                        if(this.item.MAKE_VERIFY_YN == 'Y' && this.item.DISTRIB_VERIFY_YN == 'Y'){
                                            return true;
                                        }
                                    }
                                }
                            }
                            ,{key: "INOUT_NUM"        , label:	"입출고수량"      , width: 150, align: "left" , sortabled:true ,  hidden:false
                                , editor: {type:"number"
                                    ,disabled: function () {
                                        if(this.item.MAKE_VERIFY_YN == 'Y' && this.item.DISTRIB_VERIFY_YN == 'Y'){
                                            return true;
                                        }
                                    }
                                }
                            }
                            ,{key: "CCL_PRIOD_ST_DTE" , label:	"<span style=\"color:red;\"> * </span>유통기간시작일"  , width: 150, align: "left" , sortabled:true, required:true ,  hidden:false
                                , editor: {type:"date"
                                    ,disabled: function () {
                                        if(this.item.MAKE_VERIFY_YN == 'Y' && this.item.DISTRIB_VERIFY_YN == 'Y'){
                                            return true;
                                        }
                                    }
                                }
                            }
                            ,{key: "CCL_PRIOD_ED_DTE" , label:	"<span style=\"color:red;\"> * </span>유통기간종료일"  , width: 150, align: "left" , sortabled:true, required:true ,  hidden:false
                                , editor: {type:"date"
                                    ,disabled: function () {
                                        if(this.item.MAKE_VERIFY_YN == 'Y' && this.item.DISTRIB_VERIFY_YN == 'Y'){
                                            return true;
                                        }
                                    }
                                }
                            }
                            ,{key: "MAKE_PT_CD"       , label:	"제조거래처코드"  , width: 150, align: "left" , sortabled:true ,  hidden:true, editor: false}
                            ,{key: "MAKE_PT_NM"       , label:	"제조거래처명"  , width: 150, align: "left" , sortabled:true ,  hidden:false , editor: false
                                ,picker: {
                                    top: _pop_top,
                                    width: 600,
                                    height: _pop_height,
                                    url: "partner",
                                    action: ["commonHelp", "HELP_PARTNER"],
                                    param: function () {
                                        return {PT_SP : '03'}
                                    },
                                    callback: function (e) {
                                        fnObj.gridView02.target.setValue(this.dindex, "MAKE_PT_CD", e[0].PT_CD);
                                        fnObj.gridView02.target.setValue(this.dindex, "MAKE_PT_NM", e[0].PT_NM);
                                    }
                                    ,disabled: function () {
                                        if(this.item.MAKE_VERIFY_YN == 'Y' && this.item.DISTRIB_VERIFY_YN == 'Y'){
                                            return true;
                                        }
                                    }
                                }
                            }
                            ,{key: "MAKE_VERIFY_YN"   , label:	"<span style=\"color:red;\"> * </span>본사입고확인"  , width: 150, align: "left" , sortabled:true , required:true ,  hidden:false
                                , editor: {
                                    type: "select", config: {
                                        columnKeys: {
                                            optionValue: "value", optionText: "text"
                                        },
                                        options: YN_OP
                                    }
                                    ,disabled: function () {
                                        // if(this.item.MAKE_VERIFY_YN == 'Y' && this.item.DISTRIB_VERIFY_YN == 'Y'){
                                        return true;
                                        // }
                                    }
                                }
                                ,formatter: function () {
                                    return $.changeTextValue(YN_OP, this.value)
                                }
                            }
                            ,{key: "DISTRIB_VERIFY_YN", label:	"<span style=\"color:red;\"> * </span>물류사입고확인"  , width: 150, align: "left" , sortabled:true , required:true ,  hidden:false
                                , editor: {
                                    type: "select", config: {
                                        columnKeys: {
                                            optionValue: "value", optionText: "text"
                                        },
                                        options: YN_OP
                                    }
                                    ,disabled: function () {
                                        // if(this.item.MAKE_VERIFY_YN == 'Y' && this.item.DISTRIB_VERIFY_YN == 'Y'){
                                        return true;
                                        // }
                                    }
                                }
                                ,formatter: function () {
                                    return $.changeTextValue(YN_OP, this.value)
                                }
                            }

                        ],
                        body: {
                            onClick: function () {
                                var data = this.item;           //  선택한 ROW의 ITEM들
                                var column = this.column.key;   //  컬럼 KEY명
                                var idx = this.dindex;          //  선택한 ROW의 INDEX

                                afterIndex
                                var list = fnObj.gridView01.getData();
                                for(var i = 0 ; i < list.length; i++){
                                    if(data.DISTRIB_PT_CD == list[i].DISTRIB_PT_CD && data.ITEM_CD == list[i].ITEM_CD){
                                        afterIndex = list[i].__index
                                        fnObj.gridView01.target.focus(afterIndex)
                                        fnObj.gridView01.target.select(afterIndex)
                                        ACTIONS.dispatch(ACTIONS.ITEM_CLICK);

                                    }
                                }
                                // selectRow2 = idx;
                                // this.self.select(selectRow2);
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
                        "applyWEB01": function () {
                            ACTIONS.dispatch(ACTIONS.APPLY_WEB01);
                        },
                        "applyWEB04": function () {

                            ACTIONS.dispatch(ACTIONS.APPLY_WEB04);

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
            $(document).on('click', '#headerBox', function () {
                if (cnt == 0) {
                    $("div [data-ax5grid='grid-view-04']").find("div #headerBox").attr("data-ax5grid-checked", true);
                    cnt++;
                    var gridList = fnObj.gridView04.getData();
                    gridList.forEach(function (e, i) {
                        fnObj.gridView04.target.setValue(i, "CHKED", true);
                    });
                    $("div [data-ax5grid-editor='checkbox']").attr("data-ax5grid-checked", true)
                } else {
                    $("div [data-ax5grid='grid-view-04']").find("div #headerBox").attr("data-ax5grid-checked", false);
                    cnt = 0;
                    var gridList = fnObj.gridView04.getData();
                    gridList.forEach(function (e, i) {
                        fnObj.gridView04.target.setValue(i, "CHKED", false);
                    });
                    $("div [data-ax5grid-editor='checkbox']").attr("data-ax5grid-checked", false)
                }

            })

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
                var tempgridheight = datarealheight - $("#left_title").height()

                $("#left_grid").css("height" ,(tempgridheight / 100 * 99 - $('.ax-button-group').height() ) / 2 );
                $("#tab_area").css("height", (tempgridheight / 100 * 99 - $('.ax-button-group').height()) / 2 );

                $("#tab1_grid").css("height", $("#tab_area").height() - 50 - $("#tab1_button").height() );
                $("#tab2_grid").css("height", $("#tab_area").height() - 50 - $("#tab2_button").height() );
                $("#tab3_grid").css("height", $("#tab_area").height() - 50 - $("#tab3_button").height() );
                /*
                alert($("#ax-base-root").height()); // 컨텐츠영역높이
                ax-base-title //타이틀부분높이(class)
                ax-base-content //검색조건높이(class)
                 */
            }

        </script>
    </jsp:attribute>
    <jsp:body>

        <div data-page-buttons="">
            <div class="button-warp">

                <button type="button" class="btn btn-reload" data-page-btn="reload"
                        onclick="window.location.reload();" style="width:80px;">

                    <i class="icon_reload"></i></button>
                <button type="button" class="btn btn-info" data-page-btn="search" style="width:80px;"><i
                        class="icon_search"></i><ax:lang
                        id="ax.admin.sample.modal.button.search"/></button>
                <button type="button" class="btn btn-info" data-page-btn="save" style="width:80px;"><i
                        class="icon_save"></i>저장
                </button>
            </div>
        </div>

        <div role="page-header" id="pageheader">
            <ax:form name="searchView0">
                <ax:tbl clazz="ax-search-tb1" minWidth="500px">
                </ax:tbl>
            </ax:form>
            <div class="H10"></div>
        </div>


        <%-- 그리드 영역 시작 --%>
        <div style="width:100%;overflow:hidden">
            <div style="width:99%;overflow:hidden;">
                <div class="ax-button-group" data-fit-height-aside="grid-view-01" id="left_title" name="왼쪽그리드타이틀">
                    <div class="left">
                        <h2>
                            <i class="icon_list"></i> 입출고리스트
                        </h2>
                    </div>
                    <div class="right">
                        <button type="button" class="btn btn-small" data-grid-view-01-btn="add" style="width:80px;"><i
                                class="icon_add"></i>
                            <ax:lang id="ax.admin.add"/></button>
                        <button type="button" class="btn btn-small" data-grid-view-01-btn="delete" style="width:80px;">
                            <i
                                    class="icon_del"></i> <ax:lang id="ax.admin.delete"/></button>
                    </div>
                </div>

                <div data-ax5grid="grid-view-01"
                     data-ax5grid-config="{  showLineNumber: true,showRowSelector: false, multipleSelect: false,lineNumberColumnWidth: 40,rowSelectorColumnWidth: 27, }"
                     id = "left_grid"
                     name="왼쪽그리드"
                ></div>
                <div class="H10"></div>
                <div class="H10"></div>
        <div id="tab_area" data-ax5layout="ax1" data-config="{layout:'tab-panel'}" style="height:300px;" name="하단탭영역">
            <div data-tab-panel="{label: '미승인 입고정보', active: 'true'}" id="tabGrid3">
                <div class="ax-button-group" data-fit-height-aside="grid-view-04" id="tab3_button" name="왼쪽그리드타이틀">
                    <div class="right">
                        <button type="button" class="btn btn-small" data-grid-view-04-btn="applyWEB01" style="width:80px;" id="applyWEB01">
                            <i class="icon_add"></i>본사승인</button>
                        <button type="button" class="btn btn-small" data-grid-view-04-btn="applyWEB04" style="width:80px;" id="applyWEB04">
                            <i class="icon_add"></i> 물류사승인</button>
                    </div>
                </div>
                <div data-ax5grid="grid-view-04"
                     data-ax5grid-config="{  showLineNumber: true,showRowSelector: false, multipleSelect: false,lineNumberColumnWidth: 40,rowSelectorColumnWidth: 27, }"
                     id = "tab3_grid"
                     name="왼쪽그리드">
                </div>
            </div>
            <div data-tab-panel="{label: '입고 정보', active: 'true'}" id="tabGrid1">
                <div data-ax5grid="grid-view-02"
                     data-ax5grid-config="{  showLineNumber: true,showRowSelector: false, multipleSelect: false,lineNumberColumnWidth: 40,rowSelectorColumnWidth: 27, }"
                     id = "tab1_grid"
                     name="왼쪽그리드">
                </div>
            </div>
            <div data-tab-panel="{label: '출고 정보', active: 'true'}" id="tabGrid2">
                <div data-ax5grid="grid-view-03"
                     data-ax5grid-config="{  showLineNumber: true,showRowSelector: false, multipleSelect: false,lineNumberColumnWidth: 40,rowSelectorColumnWidth: 27, }"
                     id = "tab2_grid"
                     name="왼쪽그리드">
                </div>
            </div>
        </div>

            </div>
        </div>



    </jsp:body>
</ax:layout>