<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>

<ax:set key="title" value="출장전표조회"/>
<ax:set key="page_desc" value="${pageRemark}"/>
<ax:set key="page_auto_height" value="true"/>


<ax:layout name="base">
    <jsp:attribute name="script">
        <ax:script-lang key="ax.script"/>

        <script type="text/javascript">
            var modal = new ax5.ui.modal();
            var picker = new ax5.ui.picker();
            var confirmDialog = new ax5.ui.dialog();
            var menuParam = this.parent.fnObj.tabView.urlGetData();

            /* 오늘 날짜 :: 년 / 월 / 일 :: 구하기 시작 */
            var today = new Date();
            var dtF = ax5.util.date(today, {"return": "yyyy-MM-01"});
            var dtT = ax5.util.date(today, {"return": "yyyy-MM"}) + '-' + ax5.util.daysOfMonth(today.getFullYear(), today.getMonth());
            var dtNow = ax5.util.date(today, {"return": "yyyy-MM-dd"});
            var _urlGetData = this.parent.fnObj.tabView.urlGetData();    //  다른 메뉴에서 받아오는 파라메터
            /* 오늘 날짜 :: 년 / 월 / 일 :: 구하기 끝 */

            console.log(" [ *** 타메뉴에서 넘어오는 데이터 : ", menuParam, " *** ] ");
            confirmDialog.setConfig({
                title: "Confirm title",
                theme: "danger"
            });
            picker.bind({
                target: $('[data-ax5picker="basic"]'),
                direction: "auto",
                content: {
                    width: 270,
                    margin: 10,
                    type: 'date',
                    config: {
                        control: {
                            left: '<i class="cqc-chevron-left"></i>',
                            yearTmpl: '%s',
                            monthTmpl: '%s',
                            right: '<i class="cqc-chevron-right"></i>'
                        },
                        lang: {
                            yearTmpl: "%s년",
                            months: ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12'],
                            dayTmpl: "%s"
                        }
                    }
                },
                onStateChanged: function () {
                },
                btns: {
                    today: {
                        label: "오늘", onClick: function () {

                            $("#S_DT_START").val(dtNow);
                            $("#S_DT_END").val(dtNow);
                            this.self.close();
                        }
                    },
                    thisMonth: {
                        label: "이번달", onClick: function () {
                            $("#S_DT_END").val(dtT);
                            $("#S_DT_START").val(dtF);
                            this.self.close();
                        }
                    },
                    ok: {label: "확인", theme: "default"}
                }
            });

            $('document').ready(function () {
                $('[data-ax5layout]').ax5layout();
                $("#cdPc").keydown(function (e) {
                    if (e.keyCode == '8' || e.keyCode == '16') {
                        $("#cdPc").val("");
                        $("#cdPc").attr({code: "", text: ""})
                    }
                });
                $('#S_DEPT [data-ax5select]').ax5select({
                    theme: 'primary',
                    onStateChanged: function (e) {
                        $("#S_NM_EMP").setHelpParam(JSON.stringify({CD_DEPT: $("#S_DEPT").getCodes()}));
                    }
                });
            });

            $("#S_DT_START").val(getPastDate());
            $("#S_DT_END").val(getRecentDate());

            function getRecentDate() {
                var dt = new Date();
                var recentYear = dt.getFullYear();
                var recentMonth = dt.getMonth() + 1;
                var recentDay = dt.getDate();
                if (recentMonth < 10) recentMonth = "0" + recentMonth;
                if (recentDay < 10) recentDay = "0" + recentDay;
                return recentYear + "-" + recentMonth + "-" + recentDay;
            }

            function getPastDate() {
                var dt = new Date();
                var year = dt.getFullYear();
                var month = dt.getMonth() + 1;
                if (month < 10) month = "0" + month;
                return year + "-" + month + "-01";
            }

            var fnObj = {}, CODE = {};
            var ACTIONS = axboot.actionExtend(fnObj, {
                PAGE_SEARCH: function (caller, act, data) {
                    caller.gridView01.clear();
                    caller.gridView02.clear();
                    var list = $.DATA_SEARCH("BiztripDocu", "getMasterList", fnObj.searchView.getData(), caller.gridView01);
                    console.log("list", list);
                    ACTIONS.dispatch(ACTIONS.ITEM_CLICK, '');
                    return false;
                },
                ITEM_CLICK: function (caller, act, data) {
                    if (caller.gridView01.getData('selected')[0] != undefined) {
                        $.DATA_SEARCH("BiztripDocu", "getDetailList", caller.gridView01.getData('selected')[0], caller.gridView02);
                    }
                    return false;
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
                        "print": function () {
                            ACTIONS.dispatch(ACTIONS.PRINT);
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
                    if (nvl($("#S_DT_END").val()) == '' || nvl($("#S_DT_START").val()) == '') {
                        qray.alert('조회할 회계일자를 입력해주세요.');
                        return false;
                    }
                    return {
                        P_CD_PC: $("#cdPc").attr('code')
                        , P_CD_DEPT: $("#S_DEPT").getCodes()
                        , P_DT_START: $("#S_DT_START").val().replace(/\-/g, '')
                        , P_DT_END: $("#S_DT_END").val().replace(/\-/g, '')
                        , P_ST_ING: $("select[name='S_ST_ING']").val()
                        , P_CD_EMP: $("#S_NM_EMP").getCodes()
                    }
                }
            });

            var st_ing = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'CZ_Q0005');
            $("#S_ST_ING").ax5select({
                options: st_ing
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
                                key: "CHKED", label: "", width: 30, align: "center",
                                label:
                                    '<div id="headerBox" data-ax5grid-editor="checkbox" data-ax5grid-checked="false" data-ax5grid-column-selected="true" style="height:17px;width:17px;margin-top:2px;  onclick="javascript:alert(1);"></div>',
                                editor: {
                                    type: "checkbox", config: {height: 17, trueValue: true, falseValue: false}
                                }
                            },
                            {
                                key: "DT_ACCT", label: "회계일자", width: 110, align: "center"
                                , formatter: function () {
                                    return $.changeDataFormat(this.value)
                                }
                            },
                            {
                                key: "GROUP_NUMBER",
                                label: "상신번호",
                                width: 150,
                                align: "left",
                                editor: false,
                                hidden: true
                            },
                            {key: "NO_DRAFT", label: "품의번호", width: "*", align: "left", editor: false},
                            {key: "NO_DOCU", label: "전표번호", width: "*", align: "left", editor: false},
                            {
                                key: "ST_ING", label: "진행상태", width: "*", align: "left"
                                , formatter: function () {
                                    return $.changeTextValue(st_ing, this.value)
                                }
                            },
                            {key: "IU_DOCUYN", label: "IU전표여부", width: 80, align: "left", editor: false, hidden: true},
                            {key: "NM_DEPT", label: "작성부서", width: 150, align: "left", editor: false},
                            {key: "CD_DEPT", label: "작성부서코드", width: 150, align: "left", editor: false, hidden: true},
                            {key: "NM_EMP", label: "작성사원", width: 150, align: "left", editor: false},
                            {key: "CD_DEPT", label: "작성사원코드", width: 150, align: "left", editor: false, hidden: true},
                            {key: "REMARK", label: "품의내역", width: 150, align: "left", editor: false},
                            {key: "AMT", label: "금액", width: 150, align: "right", editor: false, formatter: "money"},
                            {
                                key: "CD_COMPANY",
                                label: "회사코드",
                                width: 150,
                                align: "center",
                                editor: false,
                                hidden: true
                            },
                            {key: "CHK", label: "", width: 150, align: "center", editor: false, hidden: true}
                        ],
                        footSum: [
                            [
                                {label: "", colspan: 8, align: "center"},
                                {key: "AMT", collector: "sum", formatter: "money", align: "right"},
                            ]
                        ],
                        body: {
                            onClick: function () {
                                this.self.select(this.dindex);
                                ACTIONS.dispatch(ACTIONS.ITEM_CLICK, this.item);

                            }
                        }
                    });

                    axboot.buttonClick(this, "data-grid-view-01-btn", {});
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
                            {key: "GB", label: "계정구분", width: 100, align: "center", enable: false},
                            {key: "CD_GB", label: "계정구분코드", width: 0, align: "center", enable: false, hidden: true},
                            {key: "CD_ACCT", label: "계정코드", width: 100, align: "center", enable: false},
                            {key: "NM_ACCT", label: "계정명", width: 130, align: "left", enable: false},
                            {
                                key: "AMT_DR",
                                label: "차변금액",
                                width: 120,
                                align: "right",
                                enable: false,
                                formatter: "money"
                            },
                            {
                                key: "AMT_CR",
                                label: "대변금액",
                                width: 120,
                                align: "right",
                                enable: false,
                                formatter: "money"
                            },
                            {key: "REMARK", label: "적요", width: "*", align: "left", enable: false},
                            {key: "CD_MNGD", label: "관리항목", width: "*", align: "left", enable: false},
                            {key: "CD_MNG1", hidden: true}, {key: "CD_MNG2", hidden: true},
                            {key: "CD_MNG3", hidden: true}, {key: "CD_MNG4", hidden: true},
                            {key: "CD_MNG5", hidden: true}, {key: "CD_MNG6", hidden: true},
                            {key: "CD_MNG7", hidden: true}, {key: "CD_MNG8", hidden: true},
                            {key: "NM_MNG1", hidden: true}, {key: "NM_MNG2", hidden: true},
                            {key: "NM_MNG3", hidden: true}, {key: "NM_MNG4", hidden: true},
                            {key: "NM_MNG5", hidden: true}, {key: "NM_MNG6", hidden: true},
                            {key: "NM_MNG7", hidden: true}, {key: "NM_MNG8", hidden: true},
                            {key: "CD_MNGD1", hidden: true}, {key: "CD_MNGD2", hidden: true},
                            {key: "CD_MNGD3", hidden: true}, {key: "CD_MNGD4", hidden: true},
                            {key: "CD_MNGD5", hidden: true}, {key: "CD_MNGD6", hidden: true},
                            {key: "CD_MNGD7", hidden: true}, {key: "CD_MNGD8", hidden: true},
                            {key: "NM_MNGD1", hidden: true}, {key: "NM_MNGD2", hidden: true},
                            {key: "NM_MNGD3", hidden: true}, {key: "NM_MNGD4", hidden: true},
                            {key: "NM_MNGD5", hidden: true}, {key: "NM_MNGD6", hidden: true},
                            {key: "NM_MNGD7", hidden: true}, {key: "NM_MNGD8", hidden: true},
                        ],
                        footSum: [
                            [
                                {label: "", colspan: 3, align: "center"},
                                {key: "AMT_CR", collector: "sum", formatter: "money", align: "right"},
                                {key: "AMT_DR", collector: "sum", formatter: "money", align: "right"}
                            ]
                        ],
                        body: {
                            onClick: function (e) {
                                this.self.select(this.dindex);
                                if (this.colIndex == 6) {
                                    $.openCustomPopup('customMngdS', "userCallBack", 'CUSTOM_MNGD_PC', this.item, '', 900, 330,_pop_top330);
                                }
                            }
                        }
                    });
                },
                lastRow: function () {
                    return ($("div [data-ax5grid='grid-view-02']").find("div [data-ax5grid-panel='body'] table tr").length)
                }
            });


            var userCallBack;
            var openPopup = function (name) {
                if (name == "pc") {
                    userCallBack = function (e) {
                        if (e.length > 0) {
                            $("#cdPc").val(e[0].NM_PC);
                            $("#cdPc").attr({"code": e[0].CD_PC, "text": e[0].NM_PC});
                        }
                        modal.close();
                    };
                    $.openCustomPopup('customPc', "userCallBack", 'CUSTOM_HELP_PC', $("#cdPc").val(), {P_CD_COMPANY: '1000'},600,_pop_height,_pop_top);
                }

            };

            function isCheckedTest(data) {
                var array = [];
                for (var i = 0; i < data.length; i++) {
                    if (data[i].CHKED == true) {
                        array.push(data[i])
                    }
                }
                return array;
            }

            function isChecked(data) {
                var array = [];
                for (var i = 0; i < data.length; i++) {
                    if (data[i].ST_ING == '01' && data[i].CHKED == true) {
                        array.push(data[i])
                    }
                    if (data[i].ST_ING != '01' && data[i].CHKED == true) {
                        return false;
                    }
                }
                return array;
            }

            var cnt = 0;

            $(document).on('click', '#headerBox', function (caller) {
                if (cnt == 0) {
                    $("div [data-ax5grid='grid-view-01']").find("div #headerBox").attr("data-ax5grid-checked", true);
                    cnt++;
                    var gridList = fnObj.gridView01.getData();
                    gridList.forEach(function (e, i) {
                        fnObj.gridView01.target.setValue(i, "CHKED", true);
                    });
                    $("div [data-ax5grid-editor='checkbox']").attr("data-ax5grid-checked", true)
                } else {
                    $("div [data-ax5grid='grid-view-01']").find("div #headerBox").attr("data-ax5grid-checked", false);
                    cnt = 0;
                    var gridList = fnObj.gridView01.getData();
                    gridList.forEach(function (e, i) {
                        fnObj.gridView01.target.setValue(i, "CHKED", false);
                    });
                    $("div [data-ax5grid-editor='checkbox']").attr("data-ax5grid-checked", false)
                }

            });
            $('window').ready(function () {
                $("#S_NM_EMP").setPicker([{code: SCRIPT_SESSION.noEmp, text: SCRIPT_SESSION.nmEmp}]);
                $("#S_DEPT").setPicker([{code: SCRIPT_SESSION.cdDept, text: SCRIPT_SESSION.nmDept}]);
            });

            //////////////////////////////////////
            //크기자동조정
            var _pop_top = 0;
            var _pop_top330 = 0;
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
                    _pop_top330 = parseInt((totheight - 330) / 2);
                }
                else{
                    _pop_height = totheight / 10 * 8;
                    _pop_top = parseInt((totheight - _pop_height) / 2);
                    _pop_top330 = parseInt((totheight - 330) / 2);
                }

                $("#cdPc").attr("HEIGHT",_pop_height);
                $("#cdPc").attr("TOP",_pop_top);
                $("#S_DEPT").attr("HEIGHT",_pop_height);
                $("#S_DEPT").attr("TOP",_pop_top);
                $("#S_NM_EMP").attr("HEIGHT",_pop_height);
                $("#S_NM_EMP").attr("TOP",_pop_top);

                //데이터가 들어갈 실제높이
                var datarealheight = $("#ax-base-root").height() - $(".ax-base-title").height() - $("#pageheader").height();
                //타이틀을 뺀 상하단 그리드 합친높이
                var tempgridheight = datarealheight - $("#middle_space").height();

                $("#top_grid").css("height",tempgridheight /100 * 50);
                $("#bottom_grid").css("height",tempgridheight /100 * 49);

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
                    <%--<button type="button" class="btn btn-info" data-page-btn="print" style="width:80px;">출력</button>--%>
            </div>
        </div>


        <div role="page-header" id="pageheader">
            <ax:form name="searchView0">
                <ax:tbl clazz="ax-search-tb1">
                    <ax:tr>
                        <ax:td label='회계단위' width="450px">
                            <codepicker id="cdPc" HELP_ACTION="HELP_PC" HELP_URL="pc" BIND-CODE="CD_PC"
                                        BIND-TEXT="NM_PC" HELP_DISABLED="false" SESSION/>
                        </ax:td>
                        <ax:td label='작성부서' width="450px">
                            <multipicker id="S_DEPT" HELP_ACTION="HELP_DEPT" HELP_URL="multiDept" BIND-CODE="CD_DEPT"
                                         BIND-TEXT="NM_DEPT"/>
                        </ax:td>
                        <ax:td label='회계일자' width="450px">
                            <div class="input-group" data-ax5picker="basic">
                                <input type="text" class="form-control" placeholder="yyyy/mm/dd" id="S_DT_START">
                                <span class="input-group-addon">~</span>
                                <input type="text" class="form-control" placeholder="yyyy/mm/dd" id="S_DT_END">
                                <span class="input-group-addon"><i class="cqc-calendar"></i></span>
                            </div>
                        </ax:td>

                        <ax:td label='진행상태' width="450px">
                            <div id="S_ST_ING" data-ax5select="S_ST_ING" data-ax5select-config='{}'></div>
                        </ax:td>
                        <ax:td label='작성사원' width="450px">
                            <multipicker id="S_NM_EMP" HELP_ACTION="HELP_MULTI_EMP" HELP_URL="multiEmp"
                                         BIND-CODE="NO_EMP"
                                         BIND-TEXT="NM_EMP"/>
                        </ax:td>
                    </ax:tr>
                </ax:tbl>
            </ax:form>
            <div class="H10"></div>
        </div>

        <div>
            <div data-ax5grid="grid-view-01"
                 data-ax5grid-config="{  showLineNumber: true,showRowSelector: false, multipleSelect: false,lineNumberColumnWidth: 40,rowSelectorColumnWidth: 27, }"
                 id="top_grid"
            ></div>
            <div style="width:100%;min-height:10px;height:10px;" id="middle_space">
            </div>
            <div data-ax5grid="grid-view-02"
                 data-ax5grid-config="{  showLineNumber: true,showRowSelector: false, multipleSelect: false,lineNumberColumnWidth: 40,rowSelectorColumnWidth: 27, }"
                 id="bottom_grid"
            ></div>
        </div>
    </jsp:body>
</ax:layout>