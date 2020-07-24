<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>

<ax:set key="title" value="프로그램목록"/>
<ax:set key="page_desc" value="${pageRemark}"/>
<ax:set key="page_auto_height" value="true"/>


<ax:layout name="base">
    <jsp:attribute name="script">


        <ax:script-lang key="ax.script"/>
        <script type="text/javascript">

            var tpBill;
            var tpDrcr;
            var mask = new ax5.ui.mask();
            var modal = new ax5.ui.modal();
            var selectRow = 0;


            var fnObj = {}, CODE = {};
            var ACTIONS = axboot.actionExtend(fnObj, {
                PAGE_SEARCH: function (caller, act, data) {
                    axboot.ajax({
                        type: "GET",
                        url: ["sysprogram", "progList"],
                        data: caller.searchView.getData(),
                        callback: function (res) {
                            console.log(res);
                            caller.gridView01.setData(res.listResponse.list);
                            caller.gridView01.target.select(selectRow);
                            caller.gridView01.target.focus(selectRow);
                        }
                    });

                    return false;
                },
                PAGE_SAVE: function (caller, act, data) {
                    var saveList = [].concat(caller.gridView01.getData("modified"));
                    saveList = saveList.concat(caller.gridView01.getData("deleted"));

                    if (nvl(saveList) == '') {
                        qray.alert('변경된 내용이 없습니다.');
                        return false;
                    }
                    var savecheck = $.gridValidation(caller.gridView01.getData("modified"), {
                        "progCd": "프로그램코드",
                        "progNm": "프로그램명"
                    });
                    if (savecheck) {
                        return false;
                    }

                    var grid = fnObj.gridView01.target.list;
                    var overcnt = 0; //중복된 프로그램코드 개수
                    var overtxt = ""; //중복된 프로그램코드

                    for (var i = 0; i < grid.length; i++) {
                        overcnt = 0;
                        for (var k = 0; k < grid.length; k++) {
                            if (grid[i].progCd == grid[k].progCd) {
                                overcnt++;
                                overtxt = grid[k].progCd;
                            }
                        }

                        if (overcnt > 1) { //자기자신때문에 무조건1나옴 1초과는 중복된내용이 있을때나옴
                            qray.alert("프로그램코드 : " + overtxt + " 가 중복되었습니다");
                            return;

                        }
                    }


                    axboot.ajax({
                        type: "PUT",
                        url: ["sysprogram", "seveProg"],
                        data: JSON.stringify(saveList),
                        callback: function (res) {
                            qray.alert('성공적으로 저장되었습니다.');
                            ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                        }
                    });
                },

                ITEM_CLICK: function (caller, act, data) {


                    return false;


                },
                ITEM_ADD1: function (caller, act, data) {
                    caller.gridView01.addRow();

                    var lastIdx = nvl(caller.gridView01.target.list.length, caller.gridView01.lastRow());

                    caller.gridView01.target.select(lastIdx - 1);
                    caller.gridView01.target.focus(lastIdx - 1);
                    selectRow = lastIdx - 1;
                },


                ITEM_DEL1: function (caller, act, data) {
                    caller.gridView01.delRow("selected");
                }
            });


            fnObj.pageStart = function () {

                this.pageButtonView.initView();
                this.searchView.initView();
                this.gridView01.initView();

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
                    return {}
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
                        frozenColumnIndex: 0,
                        target: $('[data-ax5grid="grid-view-01"]'),
                        columns: [

                            {
                                key: "progCd", label: "프로그램코드", width: 200, align: "left", editor: {
                                    type: "text",
                                    disabled: function () {
                                        if (nvl(this.item.__created__) == '') {
                                            return true;
                                        } else {
                                            return false;
                                        }
                                    }
                                }
                            },
                            {key: "progNm", label: "프로그램명", width: 300, align: "left", editor: {type: "text"}},
                            {key: "progPh", label: "프로그램경로", width: 300, align: "left", editor: {type: "text"}},

                        ],
                        body: {
                            onClick: function () {
                                selectRow = this.dindex;
                                this.self.select(this.dindex);
                            }
                        },
                        onPageChange: function (pageNumber) {
                            _this.setPageData({pageNumber: pageNumber});
                            ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
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
                                selectRow = beforeIdx;

                                ACTIONS.dispatch(ACTIONS.ITEM_CLICK, this.item);
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
                    return ($("div [data-ax5grid='grid-view-01']").find("div [data-ax5grid-panel='body'] table tr").length)
                }


            });

            //== view 시작
            fnObj.searchView = axboot.viewExtend(axboot.searchView, {
                initView: function () {
                    this.target = $(document["searchView0"]);
                    this.target.attr("onsubmit", "return ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);");
                    this.progNm = $("#progNm");

                },
                getData: function () {
                    return {
                        progNm: this.progNm.val()

                    }
                }
            });

        </script>
    </jsp:attribute>
    <jsp:body>

        <div data-page-buttons="">
            <div class="button-warp">
                <button type="button" class="btn btn-reload" data-page-btn="reload" onclick="window.location.reload();"
                        style="width:80px;">
                    <i class="icon_reload"></i></button>
                <button type="button" class="btn btn-info" data-page-btn="search" style="width:80px;"><i
                        class="icon_search"></i>조회
                </button>
                <button type="button" class="btn btn-info" data-page-btn="save" style="width:80px;"><i
                        class="icon_save"></i>저장
                </button>
            </div>
        </div>

        <div role="page-header">
            <ax:form name="searchView0">
                <ax:tbl clazz="ax-search-tb1" minWidth="500px">
                    <ax:tr>
                        <ax:td label='프로그램명' width="400px">
                            <input type="text" class="form-control" name="progNm" id="progNm"/>
                        </ax:td>
                    </ax:tr>
                </ax:tbl>
            </ax:form>
            <div class="H10"></div>
        </div>

        <!-- 목록 -->
        <div class="ax-button-group" data-fit-height-aside="grid-view-01">
            <div class="left">
                <h2>
                    <i class="icon_list"></i> 프로그램리스트
                </h2>
            </div>
            <div class="right">
                <button type="button" class="btn btn-small" data-grid-view-01-btn="add" style="width:80px;"><i
                        class="icon_add"></i>
                    <ax:lang id="ax.admin.add"/></button>
                <button type="button" class="btn btn-small" data-grid-view-01-btn="delete" style="width:80px;"><i
                        class="icon_del"></i>
                    <ax:lang id="ax.admin.delete"/></button>
            </div>
        </div>


        <div role="page-content" data-ax5layout="ax1">
            <div data-ax5grid="grid-view-01"
                 data-fit-height-content="grid-view-01"
                 style="height: 300px;"
                 data-ax5grid-config="{  showLineNumber: true,showRowSelector: false, multipleSelect: false,lineNumberColumnWidth: 40,rowSelectorColumnWidth: 27, }"
            ></div>

        </div>
    </jsp:body>
</ax:layout>