<%@ page import="com.chequer.axboot.core.utils.MessageUtils" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>

<ax:set key="title" value="관할구역관리"/>
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
            var PT_SP         = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'MA00002');
            var CLOSING_TP    = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'MA00010');
            var TAX_SP        = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'MA00004');
            var COMT_SP       = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'MA00003');
            var CONTRACT_SP   = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'MA00012');
            var CONTRACT_STAT = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'MA00013');
            var USER_SP       = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'MA00007');
            var USER_STAT     = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'MA00006');
            var SALES_PERSON_LV = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'MA00016');
            var YN_OP = [{value:'' , text:''},{value:'Y' , text:'Y'},{value:'N' , text:'N'}];


            $("#CONTRACT_STAT").ax5select({
                options: CONTRACT_STAT
            });

            $("#S_PT_SP").ax5select({
                options: PT_SP
            });

            $("#S_CONTRACT").ax5select({
                options: YN_OP
            });
            var UserCallBack
            var modal = new ax5.ui.modal();
            var selectRow2 = 0;

            var fnObj = {}, CODE = {};
            var ACTIONS = axboot.actionExtend(fnObj, {
                PAGE_SEARCH: function (caller, act, data) {
                    var param = {
                        S_PT_CD : $('#S_PT_CD').getCodes()
                        , KEYWORD : $('#KEYWORD').val()
                        , S_TYPE : '1'
                    };
                    var list = $.DATA_SEARCH('area','select1',param).list;
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

                    // $.DATA_SEARCH('area','test',{}).list;
                    // return
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
                    var Grid3 = caller.gridView03.getData("modified")
                    for(var i = 0; i < Grid3.length; i++){
                        if( nvl(Grid3[i].SALES_PERSON_ID) == ''){
                            qray.alert('영업 담당자의 선택은 필수입니다.')
                            return ;
                        }
                        if( nvl(Grid3[i].SALES_PERSON_LV) == '02' &&  nvl(Grid3[i].PARENT_SALES_PERSON_ID) == ''){
                            qray.alert('영업 담당자의 레벨이 영업일 경우 상위담당자 지정은 필수입니다.')
                            return ;
                        }
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
                ITEM_CLICK: function (caller, act, data) {
                    var selected = caller.gridView01.getData('selected')[0];
                    selected.S_TYPE = '2'
                    var list2 = $.DATA_SEARCH('area','select1',nvl(selected,{}));
                    fnObj.gridView02.target.setData(list2);

                    selected.S_TYPE = '3'
                    var list3 = $.DATA_SEARCH('area','select1',nvl(selected,{}));
                    fnObj.gridView03.target.setData(list3);

                }


                , ITEM_ADD2: function (caller, act, data) {

                    if (caller.gridView01.getData('selected').length == 0) {
                        qray.alert("선택된 관할구역이 없습니다.");
                        return;
                    }

                    caller.gridView02.addRow();
                    var itemH = caller.gridView01.getData('selected')[0]
                    var lastIdx = nvl(caller.gridView02.target.list.length, caller.gridView02.lastRow());
                    caller.gridView02.target.select(lastIdx - 1);
                    caller.gridView02.target.focus(lastIdx - 1);
                    caller.gridView02.target.setValue(lastIdx - 1, "CONTROL_AREA_CD", itemH.CONTROL_AREA_CD);
                    caller.gridView02.target.setValue(lastIdx - 1, "CONTROL_AREA_NM", itemH.CONTROL_AREA_NM);
                    caller.gridView02.target.setValue(lastIdx - 1, "DISTRIB_PT_CD", itemH.DISTRIB_PT_CD);
                    caller.gridView02.target.setValue(lastIdx - 1, "DISTRIB_PT_NM", itemH.DISTRIB_PT_NM);


                }
                , ITEM_ADD3: function (caller, act, data) {

                    if (caller.gridView01.getData('selected').length == 0) {
                        qray.alert("선택된 관할구역이 없습니다.");
                        return;
                    }

                    caller.gridView03.addRow();
                    var itemH = caller.gridView01.getData('selected')[0]
                    var lastIdx = nvl(caller.gridView03.target.list.length, caller.gridView03.lastRow());
                    caller.gridView03.target.select(lastIdx - 1);
                    caller.gridView03.target.focus(lastIdx - 1);
                    caller.gridView03.target.setValue(lastIdx - 1, "CONTROL_AREA_CD", itemH.CONTROL_AREA_CD);
                    caller.gridView03.target.setValue(lastIdx - 1, "CONTROL_AREA_NM", itemH.CONTROL_AREA_NM);

                }
                , ITEM_DEL2: function (caller, act, data) {
                    caller.gridView02.delRow("selected");
                }
                , ITEM_DEL3: function (caller, act, data) {
                    caller.gridView03.delRow("selected");
                }
            });
            // fnObj 기본 함수 스타트와 리사이즈
            fnObj.pageStart = function () {
                this.pageButtonView.initView();
                this.searchView.initView();
                this.gridView01.initView();
                this.gridView02.initView();
                this.gridView03.initView();
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
                            ,{key: "CONTROL_AREA_CD", label: "관할구역코드", width: 150   , align: "center" , editor: false}
                            ,{key: "CONTROL_AREA_NM", label: "관할구역명", width: 150   , align: "center" , editor: false}
                            ,{key: "ADM_PT_CD", label: "관리거래처", width: 150, align: "center", editor: false}
                            ,{key: "ADM_PT_NM", label: "관리거래처명", width: 150, align: "center", editor: false
                                ,picker: {
                                    top: _pop_top,
                                    width: 600,
                                    height: _pop_height,
                                    url: "partner",
                                    action: ["commonHelp", "HELP_PARTNER"],
                                    param: function () {
                                    },
                                    callback: function (e) {
                                        fnObj.gridView01.target.setValue(this.dindex, "ADM_PT_CD", e[0].PT_CD);
                                        fnObj.gridView01.target.setValue(this.dindex, "ADM_PT_NM", e[0].PT_NM);
                                        //fnObj.gridView02.target.setValue(index, "USER_SP", e[0].USER_SP);
                                    },
                                    disabled: function () {
                                    }
                                }
                                ,styleClass: function () {
                                    return "red";
                                }
                            }
                            , {key: "DISTRIB_PT_CD"   , label: "물류거래처코드"  , width: 150, align: "center", hidden:true}
                            , {
                                key: "DISTRIB_PT_NM", label: "물류거래처명", width: 150, align: "center", hidden: false
                                , picker: {
                                    top: _pop_top,
                                    width: 600,
                                    height: _pop_height,
                                    url: "partner",
                                    action: ["commonHelp", "HELP_PARTNER"],
                                    param: function () {
                                        return {PT_SP: '04'}
                                    },
                                    callback: function (e) {
                                        fnObj.gridView01.target.setValue(this.dindex, "DISTRIB_PT_CD", e[0].PT_CD);
                                        fnObj.gridView01.target.setValue(this.dindex, "DISTRIB_PT_NM", e[0].PT_NM);

                                        var list = fnObj.gridView02.getData()

                                        list.forEach(function(item, index){
                                            fnObj.gridView02.target.setValue(item.__index, "DISTRIB_PT_CD", e[0].PT_CD);
                                            fnObj.gridView02.target.setValue(item.__index, "DISTRIB_PT_NM", e[0].PT_NM);
                                        })

                                    }
                                }
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
                                data = data.concat(fnObj.gridView02.getData("deleted"))
                                data = data.concat(fnObj.gridView03.getData("modified"));
                                data = data.concat(fnObj.gridView03.getData("deleted"));

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
                            , {key: "CONTROL_AREA_CD" , label: "관할구역코드"    , width: 150, align: "center", hidden:true}
                            , {key: "CONTROL_AREA_NM" , label: "관할구역명"      , width: 150, align: "center", hidden:false}
                            , {key: "AREA_SEQ"        , label: "구역순번"        , width: 150, align: "center", hidden:true}
                            , {key: "LV1_AREA_CD"     , label: "1레벨 구역코드"  , width: 150, align: "center", hidden:true}
                            , {key: "LV1_AREA_NM"     , label: "1레벨 구역명"    , width: 150, align: "center", hidden:false
                                ,picker: {
                                    top: _pop_top,
                                    width: 600,
                                    height: _pop_height,
                                    url: "area",
                                    action: ["commonHelp", "HELP_AREA"],
                                    param: function () {
                                        return {LEVEL : '1'}
                                    },
                                    callback: function (e) {
                                        fnObj.gridView02.target.setValue(this.dindex, "LV1_AREA_CD", e[0].AREA_CD);
                                        fnObj.gridView02.target.setValue(this.dindex, "LV1_AREA_NM", e[0].AREA_NM);
                                        //fnObj.gridView02.target.setValue(index, "USER_SP", e[0].USER_SP);
                                    }
                                }
                                ,styleClass: function () {
                                    return "red";
                                }
                                , required:true
                            }
                            , {key: "LV2_AREA_CD"     , label: "2레벨 구역코드"  , width: 150, align: "center", hidden:true}
                            , {key: "LV2_AREA_NM"     , label: "2레벨 구역명"    , width: 150, align: "center", hidden:false
                                ,picker: {
                                    top: _pop_top,
                                    width: 600,
                                    height: _pop_height,
                                    url: "area",
                                    action: ["commonHelp", "HELP_AREA"],
                                    param: function () {
                                        return { LEVEL : '2' , LV1_AREA_CD : this.item.LV1_AREA_CD }
                                    },
                                    callback: function (e) {
                                        fnObj.gridView02.target.setValue(this.dindex, "LV2_AREA_CD", e[0].AREA_CD);
                                        fnObj.gridView02.target.setValue(this.dindex, "LV2_AREA_NM", e[0].AREA_NM);
                                        //fnObj.gridView02.target.setValue(index, "USER_SP", e[0].USER_SP);
                                    }
                                }
                                ,styleClass: function () {
                                    return "red";
                                }, required:true
                            }
                            , {key: "DISTRIB_PT_CD"   , label: "물류거래처코드"  , width: 150, align: "center", hidden:true}
                            , {key: "DISTRIB_PT_NM"   , label: "물류거래처명"    , width: 150, align: "center", hidden:false
                                ,picker: {
                                    top: _pop_top,
                                    width: 600,
                                    height: _pop_height,
                                    url: "partner",
                                    action: ["commonHelp", "HELP_PARTNER"],
                                    param: function () {
                                        return {PT_SP : '04'}
                                    },
                                    callback: function (e) {
                                        fnObj.gridView02.target.setValue(this.dindex, "DISTRIB_PT_CD", e[0].PT_CD);
                                        fnObj.gridView02.target.setValue(this.dindex, "DISTRIB_PT_NM", e[0].PT_NM);
                                        //fnObj.gridView02.target.setValue(index, "USER_SP", e[0].USER_SP);
                                    }
                                    ,disabled:function(){
                                        return true;
                                    }
                                }
                            }
                            , {key: "DELI_PRIOD"      , label: "배송기간"        , width: 150, align: "center", hidden:false}
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
                              {key: "COMPANY_CD"              , label: "회사코드"               , width: 150, align: "left", editor: {type: "file"} ,hidden:true}
                            , {key: "CONTROL_AREA_CD"         , label: "관할구역코드"           , width: 150, align: "center", hidden:true}
                            , {key: "CONTROL_AREA_NM"         , label: "관할구역명"             , width: 150, align: "center", hidden:false}
                            , {key: "SALES_PERSON_ID"         , label: "영업담당자아이디"       , width: 150, align: "center", hidden:false}
                            , {key: "SALES_PERSON_NM"         , label: "영업담당자명"           , width: 150, align: "center", hidden:false
                                ,picker: {
                                    top: _pop_top,
                                    width: 600,
                                    height: _pop_height,
                                    url: "user",
                                    action: ["commonHelp", "HELP_USER2"],
                                    param: function () {
                                    },
                                    callback: function (e) {
                                        fnObj.gridView03.target.setValue(this.dindex, "SALES_PERSON_ID", e[0].USER_ID);
                                        fnObj.gridView03.target.setValue(this.dindex, "SALES_PERSON_NM", e[0].USER_NM);
                                    },
                                    disabled: function () {
                                        if(!nvl(this.item.__created__,false)){
                                            return true;
                                        }
                                    }
                                }
                                ,styleClass: function () {
                                    return "red";
                                }, required:true
                            }
                            , {key: "SALES_PERSON_LV"         , label: "영업담당자레벨"         , width: 150, align: "center", hidden:false
                               , formatter: function () {
                                    return $.changeTextValue(SALES_PERSON_LV, this.value)
                                }
                                , editor: {
                                    type: "select", config: {
                                        columnKeys: {
                                            optionValue: "value", optionText: "text"
                                        },
                                        options: SALES_PERSON_LV
                                    }, disabled: function () {
                                        // if(!nvl(this.item.__created__,false)){
                                        //     return true;
                                        // }
                                    }
                                }
                            }
                            , {key: "COMT_RATE"               , label: "수수료율"               , width: 150, align: "center", hidden:false , editor:{type:"number"}
                                ,formatter : function(){
                                    //Number(this.value).toFixed(2)
                                    return Number(nvl(this.value,0)).toFixed(2) + '%'
                                }
                            }
                            , {key: "PARENT_SALES_PERSON_ID"  , label: "상위영업담당자아이디"   , width: 150, align: "center", hidden:true}
                            , {key: "PARENT_SALES_PERSON_NM"  , label: "상위영업담당자명"       , width: 150, align: "center", hidden:false
                                ,picker: {
                                    top: _pop_top,
                                    width: 600,
                                    height: _pop_height,
                                    url: "user",
                                    action: ["commonHelp", "HELP_USER2"],
                                    param: function () {
                                    },
                                    callback: function (e) {
                                        fnObj.gridView03.target.setValue(this.dindex, "PARENT_SALES_PERSON_ID", e[0].USER_ID);
                                        fnObj.gridView03.target.setValue(this.dindex, "PARENT_SALES_PERSON_NM", e[0].USER_NM);
                                    },
                                    disabled: function () {
                                    }
                                }
                            }
                            , {key: "SORT"                    , label: "정렬"                   , width: 150, align: "center", hidden:true}
                        ],
                        body: {
                            onClick: function () {
                                var data = this.item;           //  선택한 ROW의 ITEM들
                                var column = this.column.key;   //  컬럼 KEY명
                                var idx = this.dindex;          //  선택한 ROW의 INDEX

                                selectRow2 = idx;
                                this.self.select(selectRow2);
                            }
                            ,onDataChanged: function () {
                                console.log(this)
                                if(this.key == 'SALES_PERSON_LV' && this.value == '01'){
                                    fnObj.gridView03.target.setValue(this.dindex , 'PARENT_SALES_PERSON_ID' ,'')
                                    fnObj.gridView03.target.setValue(this.dindex , 'PARENT_SALES_PERSON_NM' ,'')
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

                    axboot.buttonClick(this, "data-grid-view-03-btn", {
                        "add": function () {
                            ACTIONS.dispatch(ACTIONS.ITEM_ADD3);
                        },
                        "delete": function () {

                            var beforeIdx = this.target.selectedDataIndexs[0];
                            var dataLen = this.target.getList().length;

                            if ((beforeIdx + 1) == dataLen) {
                                beforeIdx = beforeIdx - 1;
                            }

                            var item = fnObj.gridView03.getData('selected')[0]

                            ACTIONS.dispatch(ACTIONS.ITEM_DEL3);
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
                    return ($("div [data-ax5grid='grid-view-03']").find("div [data-ax5grid-panel='body'] table tr").length)
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
                $("#right_grid").css("height", (tempgridheight / 100 * 99) / 2);
                $("#right_grid2").css("height", (tempgridheight / 100 * 99) / 2 - $('.ax-button-group').height());
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

                        <ax:td label='거래처' width="350px">
                            <multipicker id="S_PT_CD" HELP_ACTION="HELP_PARTNER" HELP_URL="multiPartner"
                                         BIND-CODE="PT_CD"
                                         BIND-TEXT="PT_NM"/>
                        </ax:td>
                        <ax:td label="시군구 검색" width="350px">
                            <div class="input-group" style="width:100%">
                                <input type="text" class="form-control" name="s_cd_partner" id="KEYWORD" style="width:100%"/>
                            </div>
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
                            <i class="icon_list"></i> 관할구역리스트
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
                            <i class="icon_list"></i> 상세1
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


                <div class="ax-button-group" id="right_title2" name="오른쪽부분타이틀">
                    <div class="left">
                        <h2>
                            <i class="icon_list"></i> 상세2
                        </h2>
                    </div>
                    <div class="right">
                        <button type="button" class="btn btn-small" data-grid-view-03-btn="add" style="width:80px;"><i
                                class="icon_add"></i>
                            <ax:lang id="ax.admin.add"/></button>
                        <button type="button" class="btn btn-small" data-grid-view-03-btn="delete" style="width:80px;">
                            <i
                                    class="icon_del"></i> <ax:lang id="ax.admin.delete"/></button>
                    </div>
                </div>
                <div id="right_content2" style="overflow-y:auto;" name="오른쪽부분내용">
                    <div data-ax5grid="grid-view-03"
                         data-ax5grid-config="{  showLineNumber: true,showRowSelector: false, multipleSelect: false,lineNumberColumnWidth: 40,rowSelectorColumnWidth: 27, }"
                         id = "right_grid2"
                         name="오른쪽그리드"
                    ></div>
                </div>

            </div>


            </div>
        </div>


    </jsp:body>
</ax:layout>