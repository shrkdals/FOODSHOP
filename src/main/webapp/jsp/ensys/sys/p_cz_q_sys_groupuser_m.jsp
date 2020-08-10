<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>

<ax:set key="title" value="그룹사용자관리"/>
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
                        url: ["sysgroupuser", "groupMselect"],
                        data: {'groupGb': 'U'},
                        callback: function (res) {
                            caller.gridView01.setData(res.listResponse.list);

                            if (res.listResponse.list.length > 0) {
                                caller.gridView01.target.select(0);
                                ACTIONS.dispatch(ACTIONS.ITEM_CLICK, '');

                            }

                        }
                    });

                    return false;
                },
                PAGE_SAVE: function (caller, act, data) {

                    for (var i = 0; i < caller.gridView01.target.list.length; i++) {
                        for (var i2 = 0; i2 < caller.gridView01.target.list.length; i2++) {
                            if (i == i2) continue;

                            var list = caller.gridView01.target.list;

                            if (list[i].groupCd == list[i2].groupCd) {
                                qray.alert('그룹코드가 중복됩니다.');
                                return false;
                            }
                        }
                    }

                    if (caller.gridView02.target.list.length == 0) {
                        qray.alert('사용자를 한 명이상 등록해주십시오.');
                        return false;
                    }

                    for (var i = 0; i < caller.gridView02.target.list.length; i++) {
                        for (var i2 = 0; i2 < caller.gridView02.target.list.length; i2++) {
                            if (i == i2) continue;

                            var list = caller.gridView02.target.list;

                            if (list[i].idUser == list[i2].idUser) {
                                qray.alert('사용자 아이디가 중복됩니다.');
                                return false;
                            }
                        }
                    }

                    var checkData = [].concat(caller.gridView02.getData("modified"));
                    var chkVal;
                    $(checkData).each(function (i, e) {
                        if (checkData[i].idUser == undefined) {
                            chkVal = true;
                        }

                    });
                    if (chkVal) {
                        qray.alert("사용자ID 필수입력 입니다.");
                        return false;
                    }

                    var grid01 = fnObj.gridView01.target.list;

                    for (var i = 0; i < grid01.length; i++) {
                        if (!grid01[i].groupNm || grid01[i].groupNm == "") {
                            qray.alert("그룹명은 필수입력 입니다.");
                            return false;
                        }
                    }

                    var saveList = [].concat(caller.gridView01.getData("modified"));
                    saveList = saveList.concat(caller.gridView01.getData("deleted"));

                    var saveList2 = caller.gridView02.getData();
                    // saveList2 = saveList2.concat(caller.gridView02.getData("deleted"));

                    if (saveList.length == 0 && [].concat(caller.gridView02.getData("modified")).concat(caller.gridView02.getData("deleted")).length == 0) {
                        qray.alert('변경된 내용이 없습니다.');
                        return false;
                    }
                    var data = {
                        listM: saveList
                        , listD: saveList2
                    };
                    qray.confirm({
                        msg: "저장하시겠습니까?"
                    }, function () {
                        if (this.key == "ok") {
                            axboot.ajax({
                                type: "PUT",
                                url: ["sysgroupuser", "seveAuthGroup"],
                                data: JSON.stringify(data),
                                callback: function (res) {
                                    ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                                    qray.alert("저장 되었습니다.");
                                }
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


                    axboot.ajax({
                        type: "GET",
                        url: ["sysgroupuser", "groupDselect"],
                        data: {
                            'groupCd': caller.gridView01.getData('selected')[0].groupCd,
                            'groupGb': caller.gridView01.getData('selected')[0].groupGb
                        },
                        callback: function (res) {
                            caller.gridView02.setData(res.listResponse.list);
                            caller.gridView02.target.select(0);
                        }
                    });

                    return false;


                },
                ITEM_ADD1: function (caller, act, data) {

                    caller.gridView02.clear();
                    axboot.ajax({
                        type: "GET",
                        url: ["common", "getAuthSeq"],
                        async: false,
                        callback: function (res) {
                            caller.gridView01.addRow();
                            var lastIdx = caller.gridView01.lastRow();
                            caller.gridView01.target.select(lastIdx - 1);
                            caller.gridView01.target.setValue(lastIdx - 1, "groupGb", "U");
                            caller.gridView01.target.setValue(lastIdx - 1, "groupCd", "WEB" + res.list[0].webSeq);

                        }
                    });

                    return false;


                    caller.gridView02.clear();

                },

                ITEM_ADD2: function (caller, act, data) {


                    deptCallBack2 = function (e) {
                        var chkArr = [];
                        for (var i = 0; i < fnObj.gridView02.target.list.length; i++) {
                            chkArr.push(fnObj.gridView02.target.list[i].idUser);
                        }
                        chkArr = chkArr.join('|');

                        if (e.length > 0) {
                            for (var i = 0; i < e.length; i++) {
                                if (chkArr.indexOf(e[i].ID_USER) > -1) continue;
                                fnObj.gridView02.addRow();

                                var lastIdx = nvl(fnObj.gridView02.target.list.length, fnObj.gridView02.lastRow());
                                var item = fnObj.gridView01.getData('selected')[0];
                                var groupCd = fnObj.gridView01.getData('selected')[0].groupCd;
                                var groupGb = fnObj.gridView01.getData('selected')[0].groupGb;

                                fnObj.gridView02.target.setValue(lastIdx - 1, "nmUser", e[i].NM_EMP);
                                fnObj.gridView02.target.setValue(lastIdx - 1, "idUser", e[i].ID_USER);
                                fnObj.gridView02.target.setValue(lastIdx - 1, "groupCd", groupCd);
                                fnObj.gridView02.target.setValue(lastIdx - 1, "groupGb", groupGb);
                                fnObj.gridView02.target.select(lastIdx - 1);
                            }

                        }
                        modal.close();
                    };
                    $.openCommonPopup("multiGroupUser", "deptCallBack2", 'HELP_GROUP_USER', '', null, 600, _pop_height, _pop_top);

                    // caller.gridView02.addRow();
                    // var lastIdx =  nvl(caller.gridView02.target.list.length, caller.gridView02.lastRow());
                    // caller.gridView02.target.select(lastIdx - 1);
                    // var groupCd = caller.gridView01.getData('selected')[0].groupCd;
                    // var groupGb = caller.gridView01.getData('selected')[0].groupGb;
                    // var lastIdx = caller.gridView02.lastRow();
                    // // caller.gridView02.target.select(lastIdx - 1);
                    // caller.gridView02.target.setValue(lastIdx - 1, "groupCd", groupCd);
                    // caller.gridView02.target.setValue(lastIdx - 1, "groupGb", groupGb);

                },


                ITEM_DEL1: function (caller, act, data) {
                    caller.gridView01.delRow("selected");
                    caller.gridView02.clear();
                }
                ,
                ITEM_DEL2: function (caller, act, data) {
                    caller.gridView02.delRow("selected");
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

            //== view 시작
            fnObj.searchView = axboot.viewExtend(axboot.searchView, {
                initView: function () {
                    this.target = $(document["searchView0"]);
                    this.target.attr("onsubmit", "return ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);");
                    this.tpBill = $("#tpBill");
                    this.nmDmk = $("#nmDmk");
                },
                getData: function () {
                    return {
                        tpBill: this.tpBill.val(),
                        nmDmk: this.nmDmk.val()
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

                            {
                                key: "groupCd", label: "그룹코드", width: 80, align: "left", sortable: true, editor: {
                                    type: "text",
                                    disabled: function () {
                                        var created = fnObj.gridView01.getData('selected')[0].__created__;
                                        if (nvl(created, '') == '') {
                                            return true;
                                        } else {
                                            return false;
                                        }
                                    }
                                }
                            },
                            {key: "groupNm", label: "그룹명", width: '200', align: "left", editor: {type: "text"}, sortable: true},
                            {key: "groupGb", label: "그룹구분", width: '150', align: "left", hidden: true},

                        ],
                        body: {
                            onClick: function () {
                                var chekVal;
                                var sameSelected;
                                var idx;
                                idx = this.dindex;
                                $(this.list).each(function (i, e) {
                                    if (e.__created__) {
                                        if (i != idx) {
                                            chekVal = true;
                                        }

                                    }

                                    if (e.__selected__) {
                                        if (i == idx) {
                                            sameSelected = true;
                                        }
                                    }

                                });

                                if (sameSelected == false && chekVal == false) {
                                    $(fnObj.gridView02.target.list).each(function (i, e) {
                                        if (e.__modified__) {
                                            chekVal = true;
                                            return false;
                                        }
                                    });
                                }

                                if (chekVal) {
                                    qray.alert("작업중인 데이터가 있습니다. 저장 후 진행하세요");
                                    return false;
                                }

                                if (sameSelected) return;

                                this.self.select(this.dindex);
                                ACTIONS.dispatch(ACTIONS.ITEM_CLICK, this.item);
                            },
                            onDataChanged: function () {
                                if (this.key == 'groupCd') {
                                    var list = fnObj.gridView02.target.list;

                                    for (var i = 0; i < list.length; i++) {
                                        fnObj.gridView02.target.setValue(i, 'groupCd', this.value);
                                    }
                                }
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
                                    return false;
                                }
                            });
                            $(fnObj.gridView02.target.list).each(function (i, e) {
                                if (e.__modified__) {
                                    chekVal = true;
                                    return false;
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
                                key: "groupCd",
                                label: "그룹아이디",
                                width: 80,
                                align: "left",
                                editor: {type: "text"},
                                hidden: true
                            },
                            {key: "groupGb", label: "그룹구분", width: '100', align: "left", hidden: true},
                            {
                                key: "idUser", label: "사용자ID", width: 150, align: "left", sortable: true, editor: {type: "text"},
                                picker: {
                                    top: _pop_top,
                                    width: 600,
                                    height: _pop_height,
                                    url: "user",
                                    action: ["commonHelp", "HELP_USER"],
                                    callback: function (e) {
                                        fnObj.gridView02.target.setValue(selectRow, "idUser", e[0].ID_USER);
                                        fnObj.gridView02.target.setValue(selectRow, "nmUser", e[0].NM_EMP);
                                    },
                                }
                            },
                            {key: "nmUser", label: "사용자명", width: 100, align: "left", editor: false, sortable: true},

                        ],
                        body: {
                            onClick: function () {
                                this.self.select(this.dindex);
                                selectRow = this.dindex;
                            },
                            onDataChanged: function () {
                                if (this.key == 'idUser') {
                                    if (this.value == '') {
                                        fnObj.gridView02.target.setValue(this.dindex, "nmUser", '');
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

            //== view 시작
            /**
             * searchView
             */
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

        <div style="width:100%;overflow:hidden">
            <div style="width:39%;float:left;">
                <!-- 목록 -->
                <div class="ax-button-group" data-fit-height-aside="grid-view-01" id="left_title" name="왼쪽영역제목부분">
                    <div class="left">
                        <h2>
                            <i class="icon_list"></i> 그룹정보
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
                            <i class="icon_list"></i> 그룹사용자
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