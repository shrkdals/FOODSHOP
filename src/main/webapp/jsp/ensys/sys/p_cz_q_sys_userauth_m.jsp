<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>

<ax:set key="title" value="사용자권한관리"/>
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
            var deptCallBack;
            var cnt = 0;

            var fnObj = {}, CODE = {};
            var ACTIONS = axboot.actionExtend(fnObj, {
                PAGE_SEARCH: function (caller, act, data) {
                    caller.gridView02.clear();
                    caller.gridView01.clear();
                    cnt = 0;
                    $("div [data-ax5grid='grid-view-01']").find("div #headerBox").attr("data-ax5grid-checked", false);

                    axboot.call({
                        type: "POST",
                        url: ["sysuserauth", "select"],
                        data: JSON.stringify(caller.searchView.getData()),
                        callback: function (res) {
                            if (res.list.length > 0) {
                                caller.gridView02.setData(res);
                                caller.gridView02.target.select(0);
                                ACTIONS.dispatch(ACTIONS.ITEM_CLICK, '');
                            }
                        }
                    }).done(function () {

                    });

                    return false;
                },
                PAGE_SAVE: function (caller, act, data) {
                    var saveList2 = [].concat(caller.gridView01.getData("deleted"));
                    saveList2 = saveList2.concat(caller.gridView01.getData("modified"));    //  부서

                    var saveList = [].concat(caller.gridView02.getData("modified"));    //  사용자

                    for (var i = 0; i < saveList.length; i++) {
                        if (nvl(saveList[i].ID_USER) == '') {
                            qray.alert('사용자ID는 필수입니다.');
                            return false;
                        }
                    }

                    var chk = caller.gridView01.getData("modified");
                    for (var i = 0; i < chk.length; i++) {
                        if (nvl(chk[i].ID_USER) == '') {
                            qray.alert('사용자ID는 필수입니다.');
                            return false;
                        }
                        if (nvl(chk[i].CD_DEPT) == '') {
                            qray.alert('부서는 필수입니다.');
                            return false;
                        }
                    }

                    if (caller.gridView02.target.list.length > 0) {
                        if (caller.gridView01.target.list.length == 0) {
                            qray.alert('부서를 하나 이상 등록해주세요.');
                            return false;
                        }
                    }

                    for (var i = 0; i < caller.gridView02.target.list.length; i++) {
                        for (var i2 = 0; i2 < caller.gridView02.target.list.length; i2++) {
                            if (i == i2) continue;

                            if (caller.gridView02.target.list[i].ID_USER == caller.gridView02.target.list[i2].ID_USER) {
                                qray.alert('사용자가 중복됩니다.');
                                return false;
                            }
                        }
                    }

                    for (var i = 0; i < caller.gridView01.target.list.length; i++) {
                        for (var i2 = 0; i2 < caller.gridView01.target.list.length; i2++) {
                            if (i == i2) continue;

                            if (caller.gridView01.target.list[i].CD_DEPT == caller.gridView01.target.list[i2].CD_DEPT) {
                                qray.alert('부서가 중복됩니다.');
                                return false;
                            }
                        }
                    }

                    qray.confirm({
                        msg: "저장하시겠습니까?"
                    }, function () {
                        if (this.key == "ok") {
                            qray.loading.show("저장 중입니다.");
                            axboot.call({
                                type: "PUT",
                                url: ["sysuserauth", "saveAll"],       //  SysuserauthController
                                data: JSON.stringify({
                                    gridData: saveList2,
                                    gridDataDelete: caller.gridView02.getData("deleted")
                                }),
                                callback: function (res) {
                                    ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                                }
                            }).done(function () {
                                qray.loading.hide();
                                qray.alert('저장되었습니다.');
                            });
                        }
                    });
                },
                FORM_CLEAR: function (caller, act, data) {
                    qray.confirm({
                        msg: LANG("ax.script.form.clearconfirm")
                    }, function () {
                        if (this.key == "ok") {

                            caller.gridView02.clear();
                        }
                    });
                },
                ITEM_CLICK: function (caller, act, data) {
                    var gridM = caller.gridView02.getData('selected')[0];
                    cnt = 0;
                    $("div [data-ax5grid='grid-view-01']").find("div #headerBox").attr("data-ax5grid-checked", false);
                    axboot.ajax({
                        type: "POST",
                        url: ["sysuserauth", "selectDtl"],
                        data: JSON.stringify({'P_ID_USER': gridM.ID_USER}),
                        callback: function (res) {
                            caller.gridView01.clear();
                            if (res.list.length > 0) {
                                caller.gridView01.setData(res);
                            }
                        }
                    });
                    return false;
                },
                ITEM_ADD1: function (caller, act, data) {       //  부서
                    var selected = caller.gridView02.getData('selected')[0];
                    if (nvl(selected) == '') {
                        qray.alert('사용자를 선택해주세요.');
                        return false;
                    }
                    $.openCommonPopup("multiDept", "deptCallBack2", 'HELP_ALL_DEPT', '', null, 600, _pop_height, _pop_top);
                },

                ITEM_ADD2: function (caller, act, data) {       //  사용자
                    caller.gridView01.clear();

                    caller.gridView02.addRow();

                    var lastIdx = nvl(fnObj.gridView02.target.list.length, fnObj.gridView02.lastRow());

                    caller.gridView02.target.select(lastIdx - 1);
                    caller.gridView02.target.focus(lastIdx - 1);
                },


                ITEM_DEL1: function (caller, act, data) {
                    var grid = caller.gridView01.target.list;
                    var i = grid.length;
                    while (i--) {
                        if (grid[i].CHK == 'Y') {
                            caller.gridView01.delRow(i);
                        }
                    }
                    i = null;
                }
                ,
                ITEM_DEL2: function (caller, act, data) {
                    caller.gridView02.delRow("selected");
                    caller.gridView01.clear();
                }
            });


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

            fnObj.searchView = axboot.viewExtend(axboot.searchView, {
                initView: function () {
                    this.target = $(document["searchView0"]);
                    this.target.attr("onsubmit", "return ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);");
                    this.CD_DEPT = $("#nmDept");
                    this.CD_EMP = $("#cdEmp");
                },
                getData: function () {
                    return {
                        P_CD_DEPT: '',
                        P_ID_USER: this.CD_EMP.getCodes()
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
                        showRowSelector: false,
                        frozenColumnIndex: 0,
                        showLineNumber: true,
                        multipleSelect: true,
                        lineNumberColumnWidth: 40,
                        rowSelectorColumnWidth: 27,
                        target: $('[data-ax5grid="grid-view-01"]'),
                        columns: [
                            {
                                key: "CHK", label: "", width: 40, align: "center", dirty:false,
                                label:
                                    '<div id="headerBox" data-ax5grid-editor="checkbox" data-ax5grid-checked="false" data-ax5grid-column-selected="true" style="height:17px;width:17px;margin-top:2px;  onclick="javascript:alert(1);"></div>',
                                editor: {
                                    type: "checkbox", config: {height: 17, trueValue: "Y", falseValue: "N"}
                                }
                            },
                            {key: "CD_DEPT", label: "부서코드", width: 200, align: "center", editor: false , sortable: true,},
                            {key: "NM_DEPT", label: "부서명", width: 250, align: "left", editor: false , sortable: true,},
                            {key: "ID_USER", label: "사용자ID", width: 100, align: "left", editor: false, hidden: true},
                        ],
                        body: {
                            onClick: function () {
                                var idx = this.dindex;
                                var data = this.item;

                                /*if (this.column.key == 'CD_DEPT') {

                                    deptCallBack = function (e) {
                                        if (e.length > 0) {
                                            fnObj.gridView01.target.setValue(idx, "CD_DEPT", e[0].CD_DEPT);
                                            fnObj.gridView01.target.setValue(idx, "NM_DEPT", e[0].NM_DEPT);
                                        }
                                        modal.close();
                                    };

                                    $.openCommonPopup("dept", "deptCallBack", "HELP_ALL_DEPT", data.NM_DEPT);
                                }*/
                            },
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
                            ACTIONS.dispatch(ACTIONS.ITEM_DEL1);
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
                                key: "ID_USER", label: "사용자ID", width: 150, align: "left", sortable: true, editor: {type: "text"}, sortable: true,
                                picker: {
                                    top: _pop_top,
                                    width: 600,
                                    height: _pop_height,
                                    url: "user",
                                    action: ["commonHelp", "HELP_USER"],
                                    disabled: function () {
                                        if (nvl(fnObj.gridView02.target.list[fnObj.gridView02.getData('selected')[0].__index].__created__) == '') {
                                            return true;
                                        } else {
                                            return false;
                                        }
                                    },
                                    callback: function (e) {
                                        axboot.ajax({
                                            type: "POST",
                                            url: ["sysuserauth", "select"],
                                            async: false,
                                            data: JSON.stringify({
                                                P_CD_DEPT: '',
                                                P_ID_USER: ''
                                            }),
                                            callback: function (res) {
                                                var chkVal;
                                                for (var i = 0; i < res.list.length; i++) {
                                                    if (res.list[i].ID_USER == e[0].ID_USER) {
                                                        chkVal = true;
                                                    }
                                                }
                                                if (chkVal) {
                                                    qray.alert('중복된 사용자를 선택하셨습니다.');
                                                    modal.close();
                                                    return false;
                                                }
                                                for (var i = 0; i < fnObj.gridView01.target.list.length; i++) {
                                                    fnObj.gridView01.target.setValue(i, "ID_USER", e[0].ID_USER);
                                                }

                                                fnObj.gridView02.target.setValue(fnObj.gridView02.getData('selected')[0].__index, "ID_USER", e[0].ID_USER);
                                                fnObj.gridView02.target.setValue(fnObj.gridView02.getData('selected')[0].__index, "NM_USER", e[0].NM_EMP);
                                            }
                                        });
                                    },
                                }
                            },
                            {key: "NM_USER", label: "사용자명", width: 100, align: "left", editor: false, sortable: true},
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

                                if (fnObj.gridView01.getData('deleted').length > 0) {
                                    qray.alert("삭제된 데이터가 있습니다. 저장 후 진행하세요");
                                    return false;
                                }

                                //  selectRow : 해당 그리드의 선택된 INDEX
                                if (sameSelected == false && chekVal == false) {

                                    $(fnObj.gridView01.getData()).each(function (i, e) {  //  그리드2 변경됬는 지 validate
                                        if (e.__modified__ || e.__deleted__) {
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

                                this.self.select(this.dindex);
                                ACTIONS.dispatch(ACTIONS.ITEM_CLICK, this.item);
                            },
                            onDataChanged:function(){
                                if (this.key == 'ID_USER'){
                                    if (this.value == ''){
                                        fnObj.gridView02.target.setValue(this.dindex, 'NM_USER', '');
                                    }
                                }
                            }

                        },
                        onPageChange: function (pageNumber) {
                            _this.setPageData({pageNumber: pageNumber});
                            ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                        }
                    });

                    axboot.buttonClick(this, "data-grid-view-02-btn", {
                        "add": function () {
                            var chekVal;

                            if (nvl(fnObj.gridView01.getData('deleted')) != '') {
                                qray.alert("삭제된 데이터가 있습니다. 저장 후 진행하세요");
                                return false;
                            }

                            $(this.target.list).each(function (i, e) {
                                if (e.__created__) {
                                    chekVal = true;
                                }
                            });

                            $(fnObj.gridView01.getData()).each(function (i, e) {

                                if (e.__modified__) {
                                    chekVal = true;
                                }
                            });

                            if (chekVal) {
                                qray.alert("작업중인 데이터가 있습니다. 저장 후 진행하세요");
                                return false;
                            }
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
                            }
                            ACTIONS.dispatch(ACTIONS.ITEM_CLICK, this.item);
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

            var deptCallBack2 = function (e) {
                var ID_USER = fnObj.gridView02.getData('selected')[0].ID_USER;

                var chkArr = [];
                for (var i = 0; i < fnObj.gridView01.target.list.length; i++) {
                    chkArr.push(fnObj.gridView01.target.list[i].CD_DEPT);
                }

                if (e.length > 0) {
                    for (var i = 0; i < e.length; i++) {

                        if (chkArr.indexOf(e[i].CD_DEPT) > -1)
                            continue;

                        fnObj.gridView01.addRow();

                        var lastIdx = nvl(fnObj.gridView01.target.list.length, fnObj.gridView01.lastRow());

                        fnObj.gridView01.target.setValue(lastIdx - 1, "CD_DEPT", e[i].CD_DEPT);
                        fnObj.gridView01.target.setValue(lastIdx - 1, "NM_DEPT", e[i].NM_DEPT);
                        fnObj.gridView01.target.setValue(lastIdx - 1, "ID_USER", ID_USER);
                    }

                }
                modal.close();
            };



            $(document).on('click', '#headerBox', function (caller) {
                var gridList = fnObj.gridView01.target.list;

                if (cnt == 0) {
                    cnt++;

                    $("div [data-ax5grid='grid-view-01']").find("div #headerBox").attr("data-ax5grid-checked", true);

                    gridList.forEach(function (e, i) {
                        fnObj.gridView01.target.setValue(i, "CHK", "Y");
                    });

                } else {
                    cnt = 0;

                    $("div [data-ax5grid='grid-view-01']").find("div #headerBox").attr("data-ax5grid-checked", false);

                    gridList.forEach(function (e, i) {
                        fnObj.gridView01.target.setValue(i, "CHK", "N");
                    });

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

                $("#cdEmp").attr("HEIGHT", _pop_height);
                $("#cdEmp").attr("TOP", _pop_top);

                //데이터가 들어갈 실제높이
                var datarealheight = $("#ax-base-root").height() - $(".ax-base-title").height() - $("#pageheader").height();
                //타이틀을 뺀 상하단 그리드 합친높이
                var tempgridheight = datarealheight - $("#left_title").height();

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


        <div role="page-header" id="pageheader">
            <ax:form name="searchView0">
                <ax:tbl clazz="ax-search-tbl" minWidth="500px">
                    <ax:tr>
                        <ax:td label='사용자' width="400px">
                            <multipicker id="cdEmp" HELP_ACTION="HELP_USER" HELP_URL="multiUser"
                                         BIND-CODE="ID_USER" BIND-TEXT="NM_EMP"/>
                        </ax:td>
                    </ax:tr>
                </ax:tbl>
            </ax:form>
            <div class="H10"></div>
        </div>

        <div style="width:100%;overflow:hidden">
            <div style="width:44%;float:left;">
                <!-- 목록 -->
                <div class="ax-button-group" data-fit-height-aside="grid-view-02" id="left_title" name="왼쪽제목">
                    <div class="left">
                        <h2>
                            <i class="icon_list"></i> 사용자
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
                     id="left_grid"
                     name="왼쪽그리드"
                ></div>
            </div>
            <div style="width:55%;float:right;">
                <!-- 목록 -->
                <div class="ax-button-group" data-fit-height-aside="grid-view-01" id="right_title" name="오른쪽타이틀">
                    <div class="left">
                        <h2>
                            <i class="icon_list"></i> 부서
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
                     data-ax5grid-config="{  }"
                     id="right_grid"
                     name="오른쪽그리드"
                ></div>
            </div>
        </div>

    </jsp:body>
</ax:layout>