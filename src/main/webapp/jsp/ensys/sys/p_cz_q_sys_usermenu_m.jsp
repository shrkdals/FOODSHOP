<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>

<ax:set key="title" value="사용자메뉴관리"/>
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


            var checkedIdx = [];
            var chkAuth_S = [];
            var chkAuth_I = [];
            var chkAuth_U = [];
            var chkAuth_D = [];


            axboot.ajax({
                type: "POST",
                url: ["sysusermenu", "selectMst"],
                data: JSON.stringify(),
                async: false,
                callback: function (res) {
                    var options = [];
                    res.list.forEach(function (n) {
                        console.log("n", n);
                        options.push({value: n.CD_GROUP, text: n.NM_GROUP});
                    });
                    $('[data-ax5select]').ax5select({
                        options: options,

                        onChange: function () {
                            ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                        }

                    });
                }
            });


            var userCallBack = function (e) {
                if (e.length > 0) {
                    fnObj.gridView01.target.setValue(selectRow, "AUTH_CODE", e[0].cdEmp);
                    fnObj.gridView01.target.setValue(selectRow, "AUTH_NAME", e[0].nmEmp);

                    var cdDept = e[0].CD_DEPT;

                    $(fnObj.gridView02.target.list).each(function (i, e) {
                        fnObj.gridView02.target.setValue(i, "AUTH_CODE", cdDept);
                    });
                }
                modal.close();
            };


            var fnObj = {}, CODE = {};
            var ACTIONS = axboot.actionExtend(fnObj, {
                PAGE_SEARCH: function (caller, act, data) {
                    caller.gridView01.clear();
                    caller.gridView02.clear();

                    checkedIdx = [];
                    /*chkAuth_S = [];
                    chkAuth_I = [];
                    chkAuth_U = [];
                    chkAuth_D = [];*/

                    axboot.ajax({
                        type: "POST",
                        url: ["sysusermenu", "select"],
                        data: JSON.stringify(caller.searchView.getData()),
                        callback: function (res) {
                            if (res.list.length > 0) {
                                caller.gridView01.setData(res);
                                caller.gridView01.target.select(0);
                                ACTIONS.dispatch(ACTIONS.ITEM_CLICK, '');
                            }
                        }
                    });

                    return false;
                },
                PAGE_SAVE: function (caller, act, data) {
                    var saveList = [].concat(caller.gridView02.target.list);

                    var chkVal = false;
                    for (var i = 0; i < saveList.length; i++) {
                        if (saveList[i].YN_USE == 'Y') {
                            chkVal = true;
                        }
                    }

                    /*if (!chkVal) {
                        qray.alert('메뉴정보에 사용할 메뉴 1개이상 체크해야합니다.');
                        return false;
                    }*/

                    var data = {
                        gridData: saveList
                    };

                    qray.confirm({
                        msg: "저장하시겠습니까?"
                    }, function () {
                        if (this.key == "ok") {
                            axboot.ajax({
                                type: "PUT",
                                url: ["sysusermenu", "seveAuth"],
                                data: JSON.stringify(data),
                                callback: function (res) {
                                    ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                                    //ACTIONS.dispatch(ACTIONS.ITEM_CLICK, '');
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
                    var gridM = caller.gridView01.getData('selected')[0];
                    if (nvl(gridM) == '') {
                        return false;
                    }
                    axboot.ajax({
                        type: "POST",
                        url: ["sysusermenu", "selectDtl"],
                        data: JSON.stringify({
                            'P_CD_GROUP': gridM.CD_GROUP,
                            'P_ID_USER': gridM.ID_USER
                        }),
                        callback: function (res) {
                            caller.gridView02.clear();
                            if (res.list.length > 0) {
                                caller.gridView02.setData(res);
                            }
                        }
                    });

                    return false;


                },
                ITEM_ADD1: function (caller, act, data) {
                    caller.gridView01.addRow();
                    var lastIdx = nvl(caller.gridView01.target.list.length, caller.gridView01.lastRow());
                    caller.gridView01.target.select(lastIdx - 1);
                    caller.gridView01.target.focus(lastIdx - 1);
                    caller.gridView01.target.setValue(lastIdx - 1, "AUTH_TYPE", '1');
                    caller.gridView02.clear();
                    checkedIdx = [];
                    /*chkAuth_S = [];
                    chkAuth_I = [];
                    chkAuth_U = [];
                    chkAuth_D = [];*/

                    ACTIONS.dispatch(ACTIONS.ITEM_CLICK, '');

                },
                ITEM_DEL1: function (caller, act, data) {
                    caller.gridView01.delRow("selected");
                    caller.gridView02.clear();
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
                    this.cdGroup = $('[data-ax5select="cdGroup"]');


                },
                getData: function () {
                    return {
                        P_CD_GROUP: this.cdGroup.ax5select("getValue")[0].value
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
                        target: $('[data-ax5grid="grid-view-01"]'),
                        columns: [

                            {key: "CD_GROUP", label: "권한타입", width: 80, align: "left", hidden: true},
                            {key: "ID_USER", label: "사원번호", width: 100, align: "center", editor: false},
                            {key: "NM_USER", label: "사원명", width: 200, align: "center", editor: false},

                        ],
                        body: {
                            onClick: function () {
                                var idx = this.dindex;
                                var chekVal;
                                var sameSelected;
                                $(this.list).each(function (i, e) { //  해당 그리드
                                    if (e.__selected__) {   //  선택되어있다면
                                        if (i == idx) {     //  선택된 ROW와 새로추가된 ROW가 같다면
                                            sameSelected = true;
                                        } else {
                                            $(fnObj.gridView02.target.list).each(function (i, e) {  //  그리드2 변경됬는 지 validate
                                                if (e.__modified__) {
                                                    chekVal = true;
                                                    return false;
                                                }
                                            });
                                        }
                                    }
                                });

                                if (chekVal) {  //  팅겨내기
                                    qray.alert("작업중인 데이터가 있습니다. 저장 후 진행하세요");
                                    return;
                                }

                                if (sameSelected) return;

                                this.self.select(this.dindex);

                                ACTIONS.dispatch(ACTIONS.ITEM_CLICK, this.item);
                            }
                        },
                        onPageChange: function (pageNumber) {
                            _this.setPageData({pageNumber: pageNumber});
                            ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
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
                        frozenColumnIndex: 0,
                        target: $('[data-ax5grid="grid-view-02"]'),
                        columns: [
                            {key: "CD_GROUP", label: "그룹코드", width: 120, align: "left", hidden: true},
                            {
                                key: "YN_USE", label: "", width: 30, align: "center",
                                label:
                                    '<div id="headerBox" data-ax5grid-editor="checkbox" data-ax5grid-checked="false" data-ax5grid-column-selected="true" style="height:17px;width:17px;margin-top:2px;  onclick="javascript:alert(1);"></div>',

                                formatter: function () {
                                    var DIS_YN = this.item.DIS_YN;
                                    var YN_USE = this.item.YN_USE;
                                    if (DIS_YN == 'Y') {
                                        if (YN_USE == 'N') {
                                            return '<div id="columnBox" class="columnBox' + this.dindex + '" data-ax5grid-editor="checkbox" data-ax5grid-checked="false" style="height:17px;width:17px;margin-top:2px;  onclick="javascript:itemChk(' + this.dindex + ');"></div>';
                                        } else {
                                            return '<div id="columnBox" class="columnBox' + this.dindex + '" data-ax5grid-editor="checkbox" data-ax5grid-checked="true" style="height:17px;width:17px;margin-top:2px;  onclick="javascript:itemChk(' + this.dindex + ');"></div>';
                                        }
                                    } else {
                                        return '';
                                    }
                                }
                            },
                            {key: "PARENT_ID", label: "상위메뉴ID", width: 100, align: "left", hidden: true},
                            {key: "PARENT_NM", label: "메인메뉴명", width: 200, align: "left", editor: false},
                            {key: "MENU_ID", label: "메뉴ID", width: 100, align: "left", hidden: true},
                            {key: "MENU_NM", label: "메뉴명", width: 200, align: "left", editor: false},
                            {key: "PROG_CD", label: "프로그램ID", width: 100, align: "left", hidden: true},
                            {key: "PROG_NM", label: "프로그램명", width: 200, align: "left", editor: false},
                            {
                                key: "DIS_YN",
                                label: "Y:체크가능, N:안가능",
                                width: 200,
                                align: "left",
                                hidden: true,
                                editor: false
                            },
                            {key: "AUTH_TYPE", label: "권한구분", width: 100, align: "left", hidden: true},
                            {key: "AUTH_CODE", label: "권한코드", width: 120, align: "left", hidden: true},
                            {key: "KONGBACK", label: " ", width: "*", align: "left", editor: false},

                            /*{
                                key: "authS",
                                width: 60,
                                align: "center",
                                formatter: "checkbox",
                                label: "조회",
                                formatter: function () {
                                    return "<input type='checkbox'  id='auth_s'  onclick='itemChk(this  )'   rowIdx='" + this.dindex + "'    " + (
                                        ($.inArray(this.dindex.toString(), chkAuth_S) >= 0) ? "checked " : "") + ((this.item.disYn == "N") ? " style='display:none'" : " style='display:inline'  ") + " >";
                                }, hidden: true

                            },
                            {
                                key: "authI",
                                width: 60,
                                align: "center",
                                formatter: "checkbox",
                                label: "저장",
                                formatter: function () {
                                    return "<input type='checkbox'  id='auth_i'  onclick='itemChk(this  )'   rowIdx='" + this.dindex + "'    " + (
                                        ($.inArray(this.dindex.toString(), chkAuth_I) >= 0
                                        ) ? "checked" : "") + ((this.item.disYn == "N") ? " style='display:none'" : " style='display:inline'  ") + " >";
                                },
                                disabled: function () {
                                    // 필드 B의 에이트 활성화 여부를 item.a의 값으로 런타임 판단.
                                    return this.item.disYn == "N";
                                }, hidden: true
                            },


                            {
                                key: "authU",
                                width: 60,
                                align: "center",
                                formatter: "checkbox",
                                label: "수정",
                                formatter: function () {
                                    return "<input type='checkbox'  id='auth_u'  onclick='itemChk(this  )'   rowIdx='" + this.dindex + "'    " + (
                                        ($.inArray(this.dindex.toString(), chkAuth_U) >= 0
                                        ) ? "checked" : "") + ((this.item.disYn == "N") ? " style='display:none'" : " style='display:inline'  ") + " >";
                                },
                                disabled: function () {
                                    // 필드 B의 에이트 활성화 여부를 item.a의 값으로 런타임 판단.
                                    return this.item.disYn == "N";
                                }, hidden: true
                            },


                            {
                                key: "authD",
                                width: 60,
                                align: "center",
                                formatter: "checkbox",
                                label: "삭제",
                                formatter: function () {
                                    return "<input type='checkbox'  id='auth_d'  onclick='itemChk(this  )'   rowIdx='" + this.dindex + "'    " + (
                                        ($.inArray(this.dindex.toString(), chkAuth_D) >= 0
                                        ) ? "checked" : "") + ((this.item.disYn == "N") ? " style='display:none'" : " style='display:inline'  ") + " >";
                                },
                                disabled: function () {
                                    // 필드 B의 에이트 활성화 여부를 item.a의 값으로 런타임 판단.
                                    return this.item.disYn == "N";
                                }, hidden: true
                            },*/

                        ],
                        body: {
                            mergeCells: ["KONGBACK", "PARENT_NM"],
                            onClick: function () {
                                if (this.column.key == 'YN_USE') {
                                    var checked = $(".columnBox" + this.dindex).attr('data-ax5grid-checked');
                                    if (nvl(checked) != '') {
                                        if (checked == 'true') {
                                            fnObj.gridView02.target.setValue(this.dindex, 'YN_USE', 'N');
                                            $(".columnBox" + this.dindex).attr('data-ax5grid-checked', false);
                                        } else if (checked ==  'false') {
                                            fnObj.gridView02.target.setValue(this.dindex, 'YN_USE', 'Y');
                                            $(".columnBox" + this.dindex).attr('data-ax5grid-checked', true);
                                        }
                                    }
                                }
                            }
                        },
                        onPageChange: function (pageNumber) {
                            _this.setPageData({pageNumber: pageNumber});
                            ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
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


            var cnt = 0;
            $(document).on('click', '#headerBox', function (caller) {
                var gridList = fnObj.gridView02.target.list;

                if (cnt == 0) {
                    cnt++;

                    $("div [data-ax5grid='grid-view-02']").find("div #headerBox").attr("data-ax5grid-checked", true);

                    gridList.forEach(function (e, i) {
                        if (fnObj.gridView02.target.list[i].DIS_YN == 'Y') {
                            fnObj.gridView02.target.setValue(i, "YN_USE", "Y");
                        }

                    });

                    $("div [data-ax5grid-editor='checkbox']").attr("data-ax5grid-checked", true)
                } else {
                    cnt = 0;

                    $("div [data-ax5grid='grid-view-02']").find("div #headerBox").attr("data-ax5grid-checked", false);

                    gridList.forEach(function (e, i) {
                        if (fnObj.gridView02.target.list[i].DIS_YN == 'Y') {
                            fnObj.gridView02.target.setValue(i, "YN_USE", "N");
                        }

                    });

                    $("div [data-ax5grid-editor='checkbox']").attr("data-ax5grid-checked", false)
                }

            });
            /* var itemChk = function (e) {
                 if ($(e).is(":checked")) {

                     if($(e).attr("id") == "useYn")
                     {
                         var idx = $(e).attr("rowIdx");
                         checkedIdx.push(idx);
                         chkAuth_S.push(idx);
                         chkAuth_I.push(idx);
                         chkAuth_U.push(idx);
                         chkAuth_D.push(idx);


                         $("[id='auth_s']").eq(parseInt(idx)).prop("checked" , true);
                         $("[id='auth_i']").eq(parseInt(idx)).prop("checked" , true);
                         $("[id='auth_u']").eq(parseInt(idx)).prop("checked" , true);
                         $("[id='auth_d']").eq(parseInt(idx)).prop("checked" , true);
                     }

                     if($(e).attr("id") == "auth_s")
                     {
                         chkAuth_S.push($(e).attr("rowIdx"));
                     }

                     if($(e).attr("id") == "auth_i")
                     {
                         chkAuth_I.push($(e).attr("rowIdx"));
                     }

                     if($(e).attr("id") == "auth_u")
                     {
                         chkAuth_U.push($(e).attr("rowIdx"));
                     }

                     if($(e).attr("id") == "auth_d")
                     {
                         chkAuth_D.push($(e).attr("rowIdx"));
                     }


                 } else {


                     if($(e).attr("id") == "useYn")
                     {
                         checkedIdx = $.grep(checkedIdx, function (v) {
                             return v != $(e).attr("rowIdx");
                         })

                         chkAuth_S = $.grep(chkAuth_S, function (v) {
                             return v != $(e).attr("rowIdx");
                         })

                         chkAuth_I= $.grep(chkAuth_I, function (v) {
                             return v != $(e).attr("rowIdx");
                         })

                         chkAuth_U= $.grep(chkAuth_U, function (v) {
                             return v != $(e).attr("rowIdx");
                         })

                         chkAuth_D= $.grep(chkAuth_D, function (v) {
                             return v != $(e).attr("rowIdx");
                         })

                         var idx = $(e).attr("rowIdx");
                         $("[id='auth_s']").eq(parseInt(idx)).prop("checked" , false);
                         $("[id='auth_i']").eq(parseInt(idx)).prop("checked" , false);
                         $("[id='auth_u']").eq(parseInt(idx)).prop("checked" , false);
                         $("[id='auth_d']").eq(parseInt(idx)).prop("checked" , false);


                     }

                     if($(e).attr("id") == "auth_s")
                     {
                         chkAuth_S = $.grep(chkAuth_S, function (v) {
                             return v != $(e).attr("rowIdx");
                         })
                     }

                     if($(e).attr("id") == "auth_i")
                     {
                         chkAuth_I= $.grep(chkAuth_I, function (v) {
                             return v != $(e).attr("rowIdx");
                         })
                     }

                     if($(e).attr("id") == "auth_u")
                     {
                         chkAuth_U= $.grep(chkAuth_U, function (v) {
                             return v != $(e).attr("rowIdx");
                         })
                     }

                     if($(e).attr("id") == "auth_d")
                     {
                         chkAuth_D= $.grep(chkAuth_D, function (v) {
                             return v != $(e).attr("rowIdx");
                         })
                     }




                 }

             }*/

            //////////////////////////////////////
            //크기자동조정
            var _pop_top = 0;
            var _pop_height = 0;
            $(document).ready(function() {
                changesize();
            });
            $(window).resize(function(){
                changesize();
            });
            function changesize(){
                //전체영역높이
                var totheight = $("#ax-base-root").height();
                if(totheight > 700){
                    _pop_height = 600;
                    _pop_top = parseInt((totheight - _pop_height) / 2);
                }
                else{
                    _pop_height = totheight / 10 * 8;
                    _pop_top = parseInt((totheight - _pop_height) / 2);
                }

                //데이터가 들어갈 실제높이
                var datarealheight = $("#ax-base-root").height() - $(".ax-base-title").height() - $("#pageheader").height();
                //타이틀을 뺀 상하단 그리드 합친높이
                var tempgridheight = datarealheight - $("#left_title").height();

                $("#left_grid").css("height",tempgridheight /100 * 99);
                $("#right_grid").css("height",tempgridheight /100 * 99);

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
                        style="width:80px;"><i class="icon_reload"></i></button>
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
                <ax:tbl clazz="ax-search-tb1" minWidth="500px">
                    <ax:tr>
                        <ax:td label="그룹" width="400px">
                            <div data-ax5select="cdGroup" data-ax5select-config="{
                            multiple: false,
                            reset:'<i class=\'fa fa-trash\'></i>'
                            }"></div>
                        </ax:td>

                    </ax:tr>
                </ax:tbl>
            </ax:form>
            <div class="H10"></div>
        </div>

        <div style = "width:100%;overflow:hidden">
            <div style="width:24%;float:left;">
                <!-- 목록 -->
                <div class="ax-button-group" data-fit-height-aside="grid-view-01" id="left_title" name="왼쪽타이틀">
                    <div class="left">
                        <h2>
                            <i class="icon_list"></i> 사용자
                        </h2>
                    </div>
                </div>
                <div data-ax5grid="grid-view-01"
                     data-ax5grid-config="{  showLineNumber: true,showRowSelector: false, multipleSelect: false,lineNumberColumnWidth: 40,rowSelectorColumnWidth: 27, }"
                     id="left_grid"
                     name="왼쪽그리드"
                ></div>
            </div>
            <div style="width:75%;float:right">
                <!-- 목록 -->
                <div class="ax-button-group" data-fit-height-aside="grid-view-02" id="right_title">
                    <div class="left">
                        <h2>
                            <i class="icon_list"></i> 메뉴정보
                        </h2>
                    </div>
                </div>
                <div data-ax5grid="grid-view-02"
                     data-ax5grid-config="{showLineNumber: true,showRowSelector: false, multipleSelect: false,lineNumberColumnWidth: 40,rowSelectorColumnWidth: 27, }"
                     id="right_grid"
                     name="오른쪽그리드"
                ></div>
            </div>
        </div>
    </jsp:body>
</ax:layout>