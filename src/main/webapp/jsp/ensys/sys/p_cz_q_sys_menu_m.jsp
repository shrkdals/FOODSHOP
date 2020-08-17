<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>

<ax:set key="title" value="메뉴등록"/>
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
            var selectRow2 = 0;


            var fnObj = {}, CODE = {};
            var ACTIONS = axboot.actionExtend(fnObj, {
                PAGE_SEARCH: function (caller, act, data) {
                    axboot.ajax({
                        type: "POST",
                        url: ["sysmenu", "menuList"],
                        data: JSON.stringify({'LEVEL': '0', 'PARENT_ID': ''}),
                        callback: function (res) {
                            caller.gridView01.setData(res.list);
                            if (res.list.length > 0) {
                                caller.gridView01.target.select(selectRow);
                                caller.gridView01.target.focus(selectRow);
                                ACTIONS.dispatch(ACTIONS.ITEM_CLICK, '');
                            }

                        }
                    });

                    return false;
                },
                PAGE_SAVE: function (caller, act, data) {

                    var checkData1 = [].concat(caller.gridView01.getData("modified"));
                    var checkData2 = [].concat(caller.gridView02.getData("modified"));

                    var chkVal;
                    var msg = '';
                    $(checkData1).each(function (i, e) {
                        if (nvl(checkData1[i].MENU_ID) == '') {
                            msg = '메뉴 ID는 필수입력 입니다.';
                            chkVal = true;
                        }
                        /* if (nvl(checkData1[i].MENU_ID) != '' && checkData1[i].MENU_ID.length > 3) {
                             msg = '메뉴 ID의 값이 3자리 수를 넘을 수 없습니다.';
                             chkVal = true;
                         }*/
                    });
                    $(checkData2).each(function (i, e) {
                        if (nvl(checkData2[i].MENU_ID) == '') {
                            msg = '메뉴 ID는 필수입력 입니다.';
                            chkVal = true;
                        }
                        /*if (nvl(checkData2[i].MENU_ID) != '' && checkData2[i].MENU_ID.length > 3) {
                            msg = '메뉴 ID의 값이 3자리 수를 넘을 수 없습니다.';
                            chkVal = true;
                        }*/
                    });

                    if (chkVal) {
                        qray.alert(msg);
                        return;
                    }

                    for (var i = 0; i < caller.gridView01.target.list.length; i++) {
                        for (var i2 = 0; i2 < caller.gridView02.target.list.length; i2++) {
                            if (caller.gridView01.target.list[i].MENU_ID == caller.gridView02.target.list[i2].MENU_ID) {
                                qray.alert('메인메뉴와 하위메뉴의 메뉴아이디가 중복됩니다.');
                                return false;
                            }
                        }

                        for (var i2 = 0; i2 < caller.gridView01.target.list.length; i2++) {
                            if (i == i2) continue;


                            if (caller.gridView01.target.list[i].MENU_ID == caller.gridView01.target.list[i2].MENU_ID) {
                                qray.alert('메인메뉴의 메뉴아이디가 중복됩니다.');
                                return false;
                            }
                        }
                    }

                    for (var i = 0; i < caller.gridView02.target.list.length; i++) {
                        for (var i2 = 0; i2 < caller.gridView02.target.list.length; i2++) {
                            if (i == i2) continue;

                            /* if (caller.gridView02.target.list[i].ID_SORT == caller.gridView02.target.list[i2].ID_SORT) {
                                if (nvl(caller.gridView02.target.list[i].ID_SORT) != '' && nvl(caller.gridView02.target.list[i2].ID_SORT) != '') {
                                    qray.alert('하위메뉴의 조회순서가 중복됩니다.');
                                    return false;
                                }
                            } */

                            if (caller.gridView02.target.list[i].MENU_ID == caller.gridView02.target.list[i2].MENU_ID) {
                                qray.alert('하위메뉴의 메뉴아이디가 중복됩니다.');
                                return false;
                            }
                        }
                    }


                    var saveList = [].concat(caller.gridView01.getData("modified"));
                    saveList = saveList.concat(caller.gridView01.getData("deleted"));

                    var saveList2 = [].concat(caller.gridView02.getData("modified"));
                    saveList2 = saveList2.concat(caller.gridView02.getData("deleted"));

                    if (nvl(saveList) == '' && nvl(saveList2) == '') {
                        qray.alert('변경된 내용이 없습니다.');
                        return false;
                    }

                    var data = {
                        listM: saveList
                        , listD: saveList2
                    };

                    var MENU_ID = [];
                    for (var i = 0; i < caller.gridView02.getData("modified").length; i++) {
                        if (caller.gridView02.getData("modified")[i].__created__) {
                            MENU_ID.push(caller.gridView02.getData("modified")[i].MENU_ID);
                        }
                    }

                    var chkVal;
                    axboot.ajax({
                        type: "POST",
                        url: ["sysmenu", "chkMenuId"],
                        async: false,
                        data: JSON.stringify({
                            MENU_ID: MENU_ID.join(('|'))
                        }),
                        callback: function (res) {
                            console.log(res);
                            if (res.map.COUNT > 0) {
                                chkVal = true;
                            }
                        }
                    });

                    if (chkVal) {
                        qray.alert('중복된 메뉴ID값이 들어갔습니다.');
                        return false;
                    }

                    qray.confirm({
                        msg: "저장 하시겠습니까?"
                    }, function () {
                        if (this.key == "ok") {
                            axboot.ajax({
                                type: "PUT",
                                url: ["sysmenu", "seveMenu"],
                                async: false,
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
                        type: "POST",
                        url: ["sysmenu", "menuList"],
                        data: JSON.stringify({
                            'LEVEL': '1',
                            'PARENT_ID': caller.gridView01.getData('selected')[0].MENU_ID
                        }),
                        callback: function (res) {
                            var chkVal = false;
                            for (var i = 0 ; i < res.list.length ; i ++){
                                if (nvl(res.list[i].ID_SORT) == ''){
                                    chkVal = true;
                                }
                            }
                            if (chkVal){
                                for (var i = 0 ; i < res.list.length ; i ++){
                                    res.list[i].ID_SORT = i;
                                }
                            }

                            caller.gridView02.setData(res.list);
                            caller.gridView02.target.select(selectRow2);
                            caller.gridView02.target.focus(selectRow2);
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

                    caller.gridView01.target.setValue(lastIdx - 1, "LEVEL", "0");
                    // caller.gridView01.target.setValue(lastIdx - 1, "PARENT_ID", "");
                    // caller.gridView01.target.setValue(lastIdx - 1, "PROG_CD", "");
                    caller.gridView02.clear();

                },

                ITEM_ADD2: function (caller, act, data) {

                    caller.gridView02.addRow();

                    var MENU_ID = caller.gridView01.getData('selected')[0].MENU_ID;
                    var lastIdx = nvl(caller.gridView02.target.list.length, caller.gridView02.lastRow());
                    caller.gridView02.target.select(lastIdx - 1);
                    caller.gridView02.target.focus(lastIdx - 1);
                    selectRow2 = lastIdx - 1;

                    caller.gridView02.target.setValue(lastIdx - 1, "PARENT_ID", MENU_ID);
                    caller.gridView02.target.setValue(lastIdx - 1, "LEVEL", "1");
                    caller.gridView02.target.setValue(lastIdx - 1, "ID_SORT", lastIdx - 1);


                },
                ITEM_UP: function (caller, act, data) {
                    var selected = caller.gridView02.getData('selected')[0];    //  선택한 데이터

                    var selectedIndex = selected.__index;

                    if (selectedIndex == 0) {
                        return false;
                    }

                    var data = caller.gridView02.target.list[selectedIndex - 1];


                    caller.gridView02.target.select(data.__index);
                    caller.gridView02.target.focus(data.__index);
                    selectRow2 = data.__index;

                    caller.gridView02.target.setValue(selectedIndex, 'MENU_ID', data.MENU_ID);
                    caller.gridView02.target.setValue(selectedIndex, 'MENU_NM', data.MENU_NM);
                    caller.gridView02.target.setValue(selectedIndex, 'PROG_CD', data.PROG_CD);
                    caller.gridView02.target.setValue(selectedIndex, 'PROG_NM', data.PROG_NM);
                    caller.gridView02.target.setValue(selectedIndex, 'PROG_PH', data.PROG_PH);
                    caller.gridView02.target.setValue(selectedIndex, 'LEVEL', data.LEVEL);
                    caller.gridView02.target.setValue(selectedIndex, 'GB_APPROVE', data.GB_APPROVE);
                    caller.gridView02.target.setValue(selectedIndex, '__modified__', data.__modified__);
                    caller.gridView02.target.setValue(selectedIndex, '__created__', data.__created__);

                    caller.gridView02.target.setValue(data.__index, 'MENU_ID', selected.MENU_ID);
                    caller.gridView02.target.setValue(data.__index, 'MENU_NM', selected.MENU_NM);
                    caller.gridView02.target.setValue(data.__index, 'PROG_CD', selected.PROG_CD);
                    caller.gridView02.target.setValue(data.__index, 'PROG_NM', selected.PROG_NM);
                    caller.gridView02.target.setValue(data.__index, 'PROG_PH', selected.PROG_PH);
                    caller.gridView02.target.setValue(data.__index, 'LEVEL', selected.LEVEL);
                    caller.gridView02.target.setValue(data.__index, 'PARENT_ID', selected.PARENT_ID);
                    caller.gridView02.target.setValue(data.__index, '__modified__', selected.__modified__);
                    caller.gridView02.target.setValue(data.__index, '__created__', selected.__created__);

                },
                ITEM_DOWN: function (caller, act, data) {
                    var selected = caller.gridView02.getData('selected')[0];    //  선택한 데이터

                    var selectedIndex = selected.__index;

                    if ((selectedIndex + 1) == caller.gridView02.target.list.length) {
                        return false;
                    }

                    var data = caller.gridView02.target.list[(selectedIndex + 1)];

                    caller.gridView02.target.select(data.__index);
                    caller.gridView02.target.focus(data.__index);
                    selectRow2 = data.__index;

                    caller.gridView02.target.setValue(selectedIndex, 'MENU_ID', data.MENU_ID);
                    caller.gridView02.target.setValue(selectedIndex, 'MENU_NM', data.MENU_NM);
                    caller.gridView02.target.setValue(selectedIndex, 'PROG_CD', data.PROG_CD);
                    caller.gridView02.target.setValue(selectedIndex, 'PROG_NM', data.PROG_NM);
                    caller.gridView02.target.setValue(selectedIndex, 'PROG_PH', data.PROG_PH);
                    caller.gridView02.target.setValue(selectedIndex, 'LEVEL', data.LEVEL);
                    caller.gridView02.target.setValue(selectedIndex, 'GB_APPROVE', data.GB_APPROVE);
                    caller.gridView02.target.setValue(selectedIndex, '__modified__', data.__modified__);
                    caller.gridView02.target.setValue(selectedIndex, '__created__', data.__created__);

                    caller.gridView02.target.setValue(data.__index, 'MENU_ID', selected.MENU_ID);
                    caller.gridView02.target.setValue(data.__index, 'MENU_NM', selected.MENU_NM);
                    caller.gridView02.target.setValue(data.__index, 'PROG_CD', selected.PROG_CD);
                    caller.gridView02.target.setValue(data.__index, 'PROG_NM', selected.PROG_NM);
                    caller.gridView02.target.setValue(data.__index, 'PROG_PH', selected.PROG_PH);
                    caller.gridView02.target.setValue(data.__index, 'LEVEL', selected.LEVEL);
                    caller.gridView02.target.setValue(data.__index, 'PARENT_ID', selected.PARENT_ID);
                    caller.gridView02.target.setValue(data.__index, '__modified__', selected.__modified__);
                    caller.gridView02.target.setValue(data.__index, '__created__', selected.__created__);


                },
                ITEM_DEL1: function (caller, act, data) {
                    caller.gridView01.delRow("selected");
                    caller.gridView02.clear();
                }
                ,
                ITEM_DEL2: function (caller, act, data) {
                    caller.gridView02.delRow("selected");

                    for (var i = 0 ; i < caller.gridView02.target.list.length ; i ++){
                        caller.gridView02.target.setValue(i, 'ID_SORT', i);
                    }
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
                            {key: "ID_SORT", label: "조회순서", width: 80, align: "center", editor: false, hidden: true
                            },
                            {
                                key: "MENU_ID", label: "ID", width: 80, align: "left", editor: {
                                    type: "number",
                                    disabled: function () {
                                        if (nvl(this.item.__created__) == '') {
                                            return true;
                                        } else {
                                            return false;
                                        }
                                    }
                                }
                            },
                            {key: "MENU_NM", label: "메뉴명", width: 200, align: "left", editor: {type: "text"}},
                            {key: "LEVEL", label: "LEVEL", width: 80, align: "right", hidden: true},
                            // {key: "PARENT_ID", label: "PARENT_ID", width: 80, align: "right", hidden: true},
                            // {key: "PROG_CD", label: "PROG_CD", width: 80, align: "right", hidden: true},
                        ],
                        body: {
                            onClick: function () {
                                var idx = this.dindex;

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

                                selectRow = this.dindex;
                                this.self.select(this.dindex);
                                ACTIONS.dispatch(ACTIONS.ITEM_CLICK, this.item);
                            },
                            onDataChanged: function () {
                                var item = this.item;

                                if (this.key == 'MENU_ID') {
                                    if (nvl(item.MENU_ID) != '') {
                                        fnObj.gridView01.target.setValue(this.dindex, 'ID_SORT', this.value);
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
                                }

                            });
                            $(fnObj.gridView02.target.list).each(function (i, e) {  //  그리드2 변경됬는 지 validate
                                if (e.__modified__) {
                                    chekVal = true;
                                }

                            });

                            if (chekVal) {
                                qray.alert("작업중인 데이터가 있습니다. 저장 후 진행하세요");
                                return false;
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
                                key: "ID_SORT",
                                label: "조회순서",
                                width: 80,
                                align: "center",
                                editor: {type: "number"},
                                hidden: true
                            },
                            {
                                key: "MENU_ID", label: "ID", width: 80, align: "left", editor: {
                                    type: "number",
                                    disabled: function () {
                                        if (nvl(this.item.__created__) == '') {
                                            return true;
                                        } else {
                                            return false;
                                        }
                                    }
                                }
                            },
                            {key: "MENU_NM", label: "하위메뉴명", width: 150, align: "left", editor: {type: "text"}},
                            {
                                key: "PROG_CD", label: "프로그램코드", width: 100, align: "left", editor: {type: "text"},
                                picker: {
                                    width: 600,
                                    height: 600,
                                    url: "prog",
                                    action: ["commonHelp", "HELP_PROG"],
                                    param: function () {
                                        return {
                                            menu_id: "menu_id",
                                            test: "test"
                                        }
                                    },
                                    callback: function (e) {
                                        var selectRow2 = fnObj.gridView02.getData('selected')[0].__index;
                                        fnObj.gridView02.target.setValue(selectRow2, "PROG_CD", e[0].PROG_CD);
                                        fnObj.gridView02.target.setValue(selectRow2, "PROG_NM", e[0].PROG_NM);
                                        fnObj.gridView02.target.setValue(selectRow2, "PROG_PH", e[0].PROG_PH);
                                    },
                                }
                            },
                            {key: "PROG_NM", label: "프로그램명", width: 200, align: "left", editor: false},
                            {key: "PROG_PH", label: "프로그램경로", width: 300, align: "left", editor: false},

                            {key: "LEVEL", label: "LEVEL", width: 80, align: "right", hidden: true},
                            {key: "PARENT_ID", label: "PARENT_ID", width: 80, align: "right", hidden: true},
                        ],
                        body: {
                            onClick: function () {
                                this.self.select(this.dindex);
                                selectRow2 = this.dindex;

                            },
                            onDBLClick: function () {
                                var Col = this.colIndex;
                                var selected = this.item
                                /*if (Col > 1) {
                                    $.openCommonPopup("prog", "progCallBack", "HELP_PROG", selected.PROG_NM);
                                }*/
                            },
                            onDataChanged: function () {
                                if (this.item.PROG_CD == '') {
                                    fnObj.gridView02.target.setValue(this.dindex, 'PROG_NM', '');
                                    fnObj.gridView02.target.setValue(this.dindex, 'PROG_PH', '');
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
                                selectRow2 = beforeIdx;
                            }


                        },
                        "up": function () {
                            ACTIONS.dispatch(ACTIONS.ITEM_UP);
                        },
                        "down": function () {
                            ACTIONS.dispatch(ACTIONS.ITEM_DOWN);
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


        <ax:split-layout name="ax1" orientation="vertical">
            <ax:split-panel width="350" style="padding-right: 10px;">
                <!-- 목록 -->
                <div class="ax-button-group" data-fit-height-aside="grid-view-01">
                    <div class="left">
                        <h2>
                            <i class="icon_list"></i> 메인메뉴
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
                     data-fit-height-content="grid-view-01"
                     style="height: 300px;"
                     data-ax5grid-config="{  showLineNumber: true,showRowSelector: false, multipleSelect: false,lineNumberColumnWidth: 40,rowSelectorColumnWidth: 27, }"
                ></div>

            </ax:split-panel>
            <ax:splitter></ax:splitter>
            <ax:split-panel width="*" style="padding-left: 10px;" scroll="scroll">
                <!-- 목록 -->
                <div class="ax-button-group" data-fit-height-aside="grid-view-02">
                    <div class="left">
                        <h2>
                            <i class="icon_list"></i> 하위메뉴
                        </h2>
                    </div>
                    <div class="right">
                        <button type="button" class="btn btn-small" data-grid-view-02-btn="up" style="width:80px;"><i
                                class="icon_up"></i>
                            위로
                        </button>
                        <button type="button" class="btn btn-small" data-grid-view-02-btn="down" style="width:80px;"><i
                                class="icon_down"></i> 아래로
                        </button>
                        <button type="button" class="btn btn-small" data-grid-view-02-btn="add" style="width:80px;"><i
                                class="icon_add"></i>
                            <ax:lang id="ax.admin.add"/></button>
                        <button type="button" class="btn btn-small" data-grid-view-02-btn="delete" style="width:80px;">
                            <i
                                    class="icon_del"></i> <ax:lang id="ax.admin.delete"/></button>
                    </div>
                </div>


                <div data-ax5grid="grid-view-02"
                     data-fit-height-content="grid-view-02"
                     style="height: 300px;"
                     data-ax5grid-config="{  showLineNumber: true,showRowSelector: false, multipleSelect: false,lineNumberColumnWidth: 40,rowSelectorColumnWidth: 27, }"


                ></div>
            </ax:split-panel>
        </ax:split-layout>

    </jsp:body>
</ax:layout>