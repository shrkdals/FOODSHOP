<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>

<ax:set key="title" value="공통코드관리"/>
<ax:set key="page_desc" value="${pageRemark}"/>
<ax:set key="page_auto_height" value="true"/>


<ax:layout name="base">
    <jsp:attribute name="script">


        <ax:script-lang key="ax.script"/>
        <script type="text/javascript">

            var selectRow = 0;
            var selectRow2 = 0;

            var fnObj = {}, CODE = {};
            var ACTIONS = axboot.actionExtend(fnObj, {
                PAGE_SEARCH: function (caller, act, data) {
                    axboot.ajax({
                        type: "GET",
                        url: ["macode", "select"],
                        data: caller.searchView.getData(),
                        callback: function (res) {
                            caller.gridView01.clear();
                            caller.gridView02.clear();

                            caller.gridView01.setData(res);
                            caller.gridView01.target.select(0);

                            ACTIONS.dispatch(ACTIONS.ITEM_CLICK);

                        }
                    });

                    return false;
                },
                PAGE_SAVE: function (caller, act, data) {
                    var DataSource = [].concat(caller.gridView01.getData("modified"));
                    if ($.gridValidation(DataSource, {"NM_FIELD": "코드명"})) {
                        return false;
                    }

                    var DataSource = [].concat(caller.gridView02.getData("modified"));
                    if ($.gridValidation(DataSource, {"CD_SYSDEF": "코드", "NM_SYSDEF": "코드명"})) {
                        return false;
                    }
                    for (var i = 0; i < caller.gridView02.target.list.length; i++) {
                        for (var i2 = 0; i2 < caller.gridView02.target.list.length; i2++) {
                            if (i == i2) continue;

                            if (caller.gridView02.target.list[i].CD_SYSDEF.toUpperCase() == caller.gridView02.target.list[i2].CD_SYSDEF.toUpperCase()) {
                                qray.alert('코드값이 중복됩니다.');
                                return false;
                            }
                        }
                    }

                    var macode = [].concat(caller.gridView01.getData("modified"));
                    macode = macode.concat(caller.gridView01.getData("deleted"));

                    var macodeDtl = [].concat(caller.gridView02.getData("modified"));
                    macodeDtl = macodeDtl.concat(caller.gridView02.getData("deleted"));

                    var data = {
                        gridH: macode,
                        gridD: macodeDtl
                    };

                    axboot.ajax({
                        type: "PUT",
                        url: ["macode", "allsave"],
                        data: JSON.stringify(data),
                        callback: function (res) {
                            qray.alert("저장 되었습니다.");
                            ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);

                        }
                    });
                },
                ITEM_CLICK: function (caller, act, data) {
                    var selected = caller.gridView01.getData('selected')[0];
                    if (nvl(selected) == '') {
                        return false;
                    }
                    axboot.ajax({
                        type: "GET",
                        url: ["macode", "selectDtl"],
                        data: {
                            P_CD_FIELD: selected.CD_FIELD
                        },
                        callback: function (res) {
                            caller.gridView02.setData(res);
                            caller.gridView02.target.select(0);
                        }
                    });

                    return false;
                },
                ITEM_ADD1: function (caller, act, data) {
                    caller.gridView01.addRow();
                    var lastIdx = nvl(caller.gridView01.target.list.length, caller.gridView01.lastRow());
                    caller.gridView01.target.select(lastIdx - 1);
                    caller.gridView01.target.focus(lastIdx - 1);
                    selectRow = lastIdx - 1;
                    caller.gridView02.clear();
                },

                ITEM_ADD2: function (caller, act, data) {

                    if (caller.gridView01.getData('selected').length == 0) {
                        qray.alert("상위코드를 먼저 입력하세요.");
                        return;
                    }

                    caller.gridView02.addRow();
                    var cdField = caller.gridView01.getData('selected')[0].CD_FIELD;
                    var lastIdx = nvl(caller.gridView02.target.list.length, caller.gridView02.lastRow());
                    caller.gridView02.target.select(lastIdx - 1);
                    selectRow2 = lastIdx - 1;
                    caller.gridView02.target.focus(lastIdx - 1);
                    caller.gridView02.target.setValue(lastIdx - 1, "CD_FIELD", cdField);
                    caller.gridView02.target.setValue(lastIdx - 1, "USE_YN", 'Y');


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

            fnObj.beforeClose = {
                initView: function () {

                    var gridView01 = [].concat(fnObj.gridView01.getData("modified"));
                    gridView01 = gridView01.concat(fnObj.gridView01.getData("deleted"));

                    var gridView02 = [].concat(fnObj.gridView02.getData("modified"));
                    gridView02 = gridView02.concat(fnObj.gridView02.getData("deleted"));

                    if (gridView02.length > 0 || gridView01.length > 0) {
                        return true;
                    } else {
                        return false;
                    }
                },
                ok: function () {   //  저장하시겠습니까? yes
                    var result = ACTIONS.dispatch(ACTIONS.PAGE_SAVE);
                    return result;
                }
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
                    this.NM_FIELD = $("#NM_FIELD");
                },
                getData: function () {
                    return {
                        P_NM_FIELD: this.NM_FIELD.val(),
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
                        frozenColumnIndex: 0,
                        target: $('[data-ax5grid="grid-view-01"]'),
                        columns: [
                            {key: "CD_FIELD", label: "코드", width: 150, align: "left", editor: false},
                            {key: "NM_FIELD", label: "명", width: 300, align: "left", editor: {type: "text"}},
                            {
                                key: "FG_YN", label: "표시여부", width: 80, align: "left", editor: {
                                    type: "select", config: {
                                        columnKeys: {
                                            optionValue: "value", optionText: "text"
                                        },
                                        options: [{value: 'Y', text: 'Y'}, {value: 'N', text: 'N'}]
                                    }, disabled: function () {
                                        if (SCRIPT_SESSION.idUser != 'WEBSYS') {
                                            return true;
                                        } else {
                                            return false;
                                        }

                                    }
                                }, hidden:true
                            }
                        ],
                        body: {
                            onClick: function () {
                                var data = this.item;           //  선택한 ROW의 ITEM들
                                var column = this.column.key;   //  컬럼 KEY명
                                var idx = this.dindex;          //  선택한 ROW의 INDEX

                                var chekVal = false;        //  FLAG
                                var sameSelected = false;   //  FLAG


                                $(this.list).each(function (i, e) { //  해당 그리드
                                    if (e.__created__) {    //  새로 추가되었다면
                                        if (i != idx) {     //  선택된 ROW와 새로추가된 ROW가 다르다면
                                            chekVal = true; //
                                            return false;
                                        }
                                    }
                                    if (e.__selected__) {   //  선택되어있다면
                                        if (i == idx) {     //  선택된 ROW와 새로추가된 ROW가 같다면
                                            sameSelected = true;
                                        }
                                    }
                                });
                                //  selectRow : 해당 그리드의 선택된 INDEX
                                if (selectRow != idx && chekVal == false) {

                                    $(fnObj.gridView02.target.list).each(function (i, e) {  //  그리드2 변경됬는 지 validate
                                        if (e.__modified__) {
                                            chekVal = true;
                                            return false;
                                        }
                                    });
                                }
                                if (chekVal) {  //  팅겨내기
                                    qray.alert("작업중인 데이터가 있습니다. 저장 후 진행하세요");
                                    return;
                                }
                                if (sameSelected) {     //  같은 ROW를 선택했을 경우
                                    return;                 // ACTIONS.ITEM_CLICK_H [ 디테일그리드 조회 데이터소스 ] 를 읽지 못하게끔 막기
                                }

                                selectRow = idx;
                                this.self.select(selectRow);

                                ACTIONS.dispatch(ACTIONS.ITEM_CLICK, this.item);

                            }
                        },
                        onPageChange: function (pageNumber) {
                            _this.setPageData({pageNumber: pageNumber});
                            ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                        }
                    });

                    axboot.buttonClick(this, "data-grid-view-01-btn", {
                        "add": function () {
                            var chekVal;
                            $(this.target.list).each(function (i, e) {
                                if (e.__created__) {
                                    chekVal = true;
                                }

                            });
                            $(fnObj.gridView02.target.list).each(function (i, e) {

                                if (e.__modified__) {
                                    chekVal = true;
                                }
                            });

                            if (chekVal) {
                                qray.alert("작업중인 데이터가 있습니다. 저장 후 진행하세요");
                                return;
                            }
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
                                ACTIONS.dispatch(ACTIONS.ITEM_CLICK);
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
                                key: "CD_SYSDEF", label: "코드", width: 100, align: "center", editor: {
                                    type: "text",
                                    disabled: function () {
                                        var selected = fnObj.gridView02.getData('selected')[0];
                                        if (nvl(selected.__created__, '') == '') {
                                            return true;
                                        } else {
                                            return false;
                                        }
                                    }
                                }
                            },
                            {key: "NM_SYSDEF", label: "명", width: 200, align: "left", editor: {type: "text"}},
                            {key: "CD_FLAG1", label: "관련1", width: 150, align: "left", editor: {type: "text"}, hidden:true},
                            {key: "CD_FLAG2", label: "관련2", width: 150, align: "left", editor: {type: "text"}, hidden:true},
                            {key: "CD_FLAG3", label: "관련3", width: 150, align: "left", editor: {type: "text"}, hidden:true},
                            {key: "NM_SYSDEF_E", label: "비고", width: 300, align: "left", editor: {type: "text"}, hidden:true},
                            {
                                key: "USE_YN", label: "사용여부", width: 100, align: "center"
                                , editor: {
                                    type: "select", config: {
                                        columnKeys: {
                                            optionValue: "CODE", optionText: "NAME"
                                        },
                                        options: [{CODE: 'Y', NAME: "Y"}, {CODE: 'N', NAME: "N"}]

                                    }
                                }, hidden:true
                            },
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

                $("#left_grid").css("height", tempgridheight / 100 * 99);
                $("#right_grid").css("height", tempgridheight / 100 * 99);

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
                    <ax:tr>
                        <ax:td label='코드명' width="400px">
                            <input type="text" class="form-control" name="NM_FIELD" id="NM_FIELD"/>
                        </ax:td>
                    </ax:tr>
                </ax:tbl>
            </ax:form>
            <div class="H10"></div>
        </div>

        <div style="width:100%;overflow:hidden">
            <div style="width:39%;float:left;">
                <!-- 목록 -->
                <div class="ax-button-group" data-fit-height-aside="grid-view-01" id="left_title" name="왼쪽타이틀">
                    <div class="left">
                        <h2>
                            <i class="icon_list"></i> 코드
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
                     id="left_grid"
                     name="왼쪽그리드"
                ></div>
            </div>
            <div style="width:60%;float:right">
                <!-- 목록 -->
                <div class="ax-button-group" data-fit-height-aside="grid-view-02" id="right_title" name="오른쪽타이틀">
                    <div class="left">
                        <h2>
                            <i class="icon_list"></i> 상세
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
                     id="right_grid"
                     name="오른쪽그리드"
                ></div>
            </div>
        </div>

    </jsp:body>
</ax:layout>