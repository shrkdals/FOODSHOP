<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>

<ax:set key="title" value="제조사배송관리"/>
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
            var VERIFY_STAT = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'MA00021');
            var YN_OP = [{value:'' , text:''},{value:'Y' , text:'Y'},{value:'N' , text:'N'}];

            var CallBack1;
            var fnObj = {}, CODE = {};
            var ACTIONS = axboot.actionExtend(fnObj, {
                PAGE_SEARCH: function (caller, act, data) {
                    var list = $.DATA_SEARCH('mkpartner','selectH',{CD_COMPANY:SCRIPT_SESSION.cdCompany , KEYWORD : $('#KEYWORD').val()});
                    fnObj.gridView01.target.setData(list);
                    caller.gridView01.target.select(afterIndex);
                    caller.gridView01.target.focus(afterIndex);
                    ACTIONS.dispatch(ACTIONS.ITEM_CLICK,caller);
                    selectRow2 = 0;

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
                    var list = $.DATA_SEARCH('DeliverPartner','selectD',selected);
                    fnObj.gridView02.target.setData(list);

                    return false;
                },
                ITEM_ADD1: function (caller, act, data) {

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

                },

                ITEM_ADD2: function (caller, act, data) {

                    caller.gridView02.addRow();
                    var itemH = caller.gridView01.getData('selected')[0]
                    var lastIdx = nvl(caller.gridView02.target.list.length, caller.gridView02.lastRow());
                    caller.gridView02.target.select(lastIdx - 1);
                    selectRow2 = lastIdx - 1;
                    caller.gridView02.target.focus(lastIdx - 1);
                    caller.gridView02.target.setValue(lastIdx - 1, "COMPANY_CD", itemH.COMPANY_CD);

                },
                ITEM_DEL1: function (caller, act, data) {
                    var beforeIdx = caller.gridView01.getData('selected')[0].__index;
                    caller.gridView01.delRow("selected");
                }
                ,
                ITEM_DEL2: function (caller, act, data) {
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
                            {key: "COMPANY_CD"         , label: ""              , width: 150, align: "left" , sortabled:true ,  hidden:true , editor: false }
                            ,{key: "MAKE_PT_CD"        , label: "제조사코드"              , width: 150, align: "left" , sortabled:true ,  hidden:false , editor: false }
                            ,{key: "MAKE_PT_NM"        , label: "제조사명"              , width: 150, align: "left" , sortabled:true ,  hidden:false , editor: false }
                            ,{key: "ITEM_CD"           , label: "상품코드"              , width: 150, align: "left" , sortabled:true ,  hidden:false , editor: false }
                            ,{key: "ITEM_CD"           , label: "상품명"              , width: 150, align: "left" , sortabled:true ,  hidden:false , editor: false }
                            ,{key: "DELI_SEQ"          , label: "배송순번"              , width: 150, align: "left" , sortabled:true ,  hidden:false , editor: false }
                            ,{key: "DELI_DTE"          , label: "배송일자"              , width: 150, align: "left" , sortabled:true ,  hidden:false , editor: false }
                            ,{key: "DELI_NUM"          , label: "배송수량"              , width: 150, align: "left" , sortabled:true ,  hidden:false , editor: false }
                            ,{key: "CCL_PRIOD_ST_DTE"  , label: "유통기간시작일"              , width: 150, align: "left" , sortabled:true ,  hidden:false , editor: false }
                            ,{key: "CCL_PRIOD_ED_DTE"  , label: "유통기간종료일"              , width: 150, align: "left" , sortabled:true ,  hidden:false , editor: false }
                            ,{key: "VERIFY_STAT"       , label: "검증상태"              , width: 150, align: "left" , sortabled:true ,  hidden:false
                                , editor: {
                                    type: "select", config: {
                                        columnKeys: {
                                            optionValue: "value", optionText: "text"
                                        },
                                        options: VERIFY_STAT
                                    }
                                    , disabled: function () {
                                    }
                                }
                                , formatter: function () {
                                    return $.changeTextValue(VERIFY_STAT, this.value)
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
                                // var data = []
                                // data = data.concat(fnObj.gridView02.getData("modified"));
                                // data = data.concat(fnObj.gridView02.getData("deleted"));
                                //
                                // if(data.length > 0){
                                //     qray.confirm({
                                //         msg: "작업중인 상세 데이터를 먼저 저장해주십시오."
                                //         ,btns: {
                                //             cancel: {
                                //                 label:'확인', onClick: function(key){
                                //                     qray.close();
                                //                 }
                                //             }
                                //         }
                                //     })
                                // }else{
                                //     afterIndex = index;
                                //     this.self.select(this.dindex);
                                //     ACTIONS.dispatch(ACTIONS.ITEM_CLICK, this.item);
                                // }

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

                            {key: "COMPANY_CD"         , label: ""              , width: 150, align: "left" , sortabled:true ,  hidden:true , editor: false }
                            ,{key: "MAKE_PT_CD"       , label:	"<span style=\"color:red;\"> * </span> 제조거래처코드"  , width: 150, align: "left" , sortabled:true ,  hidden:true, editor: false}
                            ,{key: "MAKE_PT_NM"       , label:	"<span style=\"color:red;\"> * </span>  제조거래처명"  , width: 150, align: "left" , sortabled:true ,  hidden:false , editor: false
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
                            ,{key: "ITEM_CD"          , label: "<span style=\"color:red;\"> * </span> 상품코드"	      , width: 150, align: "left" , sortabled:true , required:true ,  hidden:true , editor: false }
                            ,{key: "ITEM_NM"          , label: "<span style=\"color:red;\"> * </span> 상품명"		  , width: 150, align: "left" , sortabled:true , required:true ,  hidden:false , editor: false
                                ,picker: {
                                    top: _pop_top,
                                    width: 600,
                                    height: _pop_height,
                                    url: "item",
                                    action: ["commonHelp", "HELP_ITEM"],
                                    param: function () {
                                        return {PT_SP : '03'}
                                    },
                                    callback: function (e) {
                                        fnObj.gridView02.target.setValue(this.dindex, "ITEM_CD", e[0].ITEM_CD);
                                        fnObj.gridView02.target.setValue(this.dindex, "ITEM_NM", e[0].ITEM_NM);
                                    }
                                    ,disabled: function () {
                                    }
                                }
                            }
                            ,{key: "DELI_SEQ"          , label: "배송순번"              , width: 150, align: "left" , sortabled:true ,  hidden:true , editor: false }
                            ,{key: "DELI_DTE"          , label: "배송일자"              , width: 150, align: "left" , sortabled:true ,  hidden:false , editor: {type:"date"} }
                            ,{key: "DELI_NUM"          , label: "<span style=\"color:red;\"> * </span> 배송수량"              , width: 150, align: "left" , required:true , sortabled:true ,  hidden:false , editor: {type:"number"} }
                            ,{key: "CCL_PRIOD_ST_DTE"  , label: "<span style=\"color:red;\"> * </span> 유통기간시작일"              , width: 150, align: "left" , required:true , sortabled:true ,  hidden:false , editor: {type:"date"} }
                            ,{key: "CCL_PRIOD_ED_DTE"  , label: "<span style=\"color:red;\"> * </span> 유통기간종료일"              , width: 150, align: "left" , required:true , sortabled:true ,  hidden:false , editor: {type:"date"} }
                            ,{key: "VERIFY_STAT"       , label: "검증상태"              , width: 150, align: "left" , sortabled:true ,  hidden:false
                                , editor: {
                                    type: "select", config: {
                                        columnKeys: {
                                            optionValue: "value", optionText: "text"
                                        },
                                        options: VERIFY_STAT
                                    }
                                    , disabled: function () {
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

                $("#left_grid").css("height" ,(tempgridheight / 100 * 99 - $('.ax-button-group').height() ) / 2 );
                $("#left_grid2").css("height", (tempgridheight / 100 * 99 - $('.ax-button-group').height()) / 2 );

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
                            <i class="icon_list"></i> 배송리스트
                        </h2>
                    </div>
                    <div class="right">
<%--                        <button type="button" class="btn btn-small" data-grid-view-01-btn="add" style="width:80px;"><i--%>
<%--                                class="icon_add"></i>--%>
<%--                            <ax:lang id="ax.admin.add"/></button>--%>
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

                <div class="ax-button-group" data-fit-height-aside="grid-view-02" id="left_title2" name="왼쪽그리드타이틀">
                    <div class="left">
                        <h2>
                            <i class="icon_list"></i> 배송추가
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

                <div data-ax5grid="grid-view-02"
                     data-ax5grid-config="{  showLineNumber: true,showRowSelector: false, multipleSelect: false,lineNumberColumnWidth: 40,rowSelectorColumnWidth: 27, }"
                     id = "left_grid2"
                     name="왼쪽그리드"
                ></div>
            </div>
        </div>



    </jsp:body>
</ax:layout>