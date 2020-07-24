<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>

<ax:set key="title" value="고객편익사용조회"/>
<ax:set key="page_desc" value="${pageRemark}"/>
<ax:set key="page_auto_height" value="true"/>


<ax:layout name="base">
    <jsp:attribute name="script">
        <ax:script-lang key="ax.script"/>

        <script type="text/javascript">
            /************ 선행 스크립트 START ************/
            /* 오늘 날짜 :: 년 / 월 / 일 :: 구하기 시작 */
            var today = new Date();
            var dtF = ax5.util.date(today, {"return": "yyyy-MM-01"});
            var dtT = ax5.util.date(today, {"return": "yyyy-MM"}) + '-' + ax5.util.daysOfMonth(today.getFullYear(), today.getMonth());
            var dtNow = ax5.util.date(today, {"return": "yyyy-MM-dd"});
            var _urlGetData = this.parent.fnObj.tabView.urlGetData();    //  다른 메뉴에서 받아오는 파라메터
            /* 오늘 날짜 :: 년 / 월 / 일 :: 구하기 끝 */

            var picker = new ax5.ui.picker();
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

                            $("#DT_END").val(dtNow);
                            $("#DT_START").val(dtNow);
                            this.self.close();
                        }
                    },
                    thisMonth: {
                        label: "이번달", onClick: function () {
                            $("#DT_END").val(dtT);
                            $("#DT_START").val(dtF);
                            this.self.close();
                        }
                    },
                    ok: {label: "확인", theme: "default"}
                }
            });
            $("#DT_START").val(getPastDate());
            $("#DT_END").val(getRecentDate());


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


            /************ 선행 스크립트 END ************/

            var fnObj = {}, CODE = {};
            var ACTIONS = axboot.actionExtend(fnObj, {
                PAGE_SEARCH: function (caller, act, data) {
                    data = {
                         DT_START : $("#DT_START").val().replace(/-/g, "")
                        ,DT_END   : $("#DT_END").val().replace(/-/g, "")
                        ,CD_DEPT  : $("#cdDept").getCodes()
                        ,CD_PC    : $("#cdPc").attr("code")
                    };
                    $.DATA_SEARCH("apBnft","getBnftList",data,caller.gridView01)
                }
            });


            // fnObj 기본 함수 스타트와 리사이즈
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
                                key: "DT_START", label: "증빙일자", width: 100, align: "center", editor: false,sortable: true,
                                formatter: function () {
                                    if (this.value != undefined) {
                                        return this.value.replace(/(\d{4})(\d{2})(\d{2})/, '$1-$2-$3');
                                    }
                                }
                            },
                            {key: "CONT_CUST", label: "거래상대방명", width: 100, align: "left", editor: false,sortable: true,},
                            {key: "NM_CUST", label: "고객회사", width: 130, align: "center", editor: false,sortable: true,},
                            {key: "NM_USER", label: "사용자명", width: 100, align: "left", editor: false,sortable: true,},
                            {key: "NM_DEPT", label: "팀", width: 120, align: "center", editor: false,sortable: true,},
                            {key: "BNFT_SUP_TYPE", label: "이익제공 내용", width: 110, align: "left", editor: false,sortable: true,},
                            {key: "ACCT_NO", label: "법인카드번호", width: 140, align: "center", editor: false,sortable: true
                                ,formatter : function(){
                                    return $.changeDataFormat(this.value,"card")
                                }},
                            {key: "PEOPLE", label: "참석자명단", width: 180, align: "left", editor: false,sortable: true,},
                            {key: "PEOPLE_NO", label: "참석자수", width: 90, align: "left", editor: false,sortable: true,},
                            {key: "AMT_USE", label: "사용금액", width: 180, align: "right", editor: false, formatter: "money",sortable: true,},
                            {key: "ACC_AMT_USE", label: "누계금액", width: 180, align: "right", editor: false, formatter: "money",sortable: true,}
                        ],
                        body: {
                            onClick: function () {
                                this.self.select(this.dindex);
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
                , sort: function () {
                }
            });

            $('window').ready(function () {
                $("#cdDept").setPicker([{code: SCRIPT_SESSION.cdDept, text: SCRIPT_SESSION.nmDept}]);
            });

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

                $("#cdPc").attr("HEIGHT",_pop_height);
                $("#cdPc").attr("TOP",_pop_top);
                $("#cdDept").attr("HEIGHT",_pop_height);
                $("#cdDept").attr("TOP",_pop_top);

                //데이터가 들어갈 실제높이
                var datarealheight = $("#ax-base-root").height() - $(".ax-base-title").height() - $("#pageheader").height();
                //타이틀을 뺀 상하단 그리드 합친높이
                //var tempgridheight = datarealheight - $("#top_title").height() - $("#bottom_left_title").height() - $("#bottom_left_amt").height();
                var tempgridheight = datarealheight;

                $("#top_grid").css("height",tempgridheight /100 * 99);

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
                <button type="button" class="btn btn-reload" data-page-btn="reload" onclick="window.location.reload();" style="width:80px;">
                    <i class="icon_reload"></i></button>
                <button type="button" class="btn btn-info" data-page-btn="search" style="width:80px;"><i class="icon_search"></i><ax:lang
                        id="ax.admin.sample.modal.button.search"/></button>
            </div>
        </div>

        <div role="page-header" id="pageheader">
            <ax:form name="searchView0">
                <ax:tbl clazz="ax-search-tb1" minWidth="500px">
                    <ax:tr>
                        <ax:td label='회계단위' width="400px">
                            <codepicker id="cdPc" HELP_ACTION="HELP_PC" HELP_URL="pc" BIND-CODE="CD_PC"
                                        BIND-TEXT="NM_PC" READONLY SESSION/>
                        </ax:td>
                        <ax:td label='사용부서' width="400px">
                            <multipicker id="cdDept" HELP_ACTION="HELP_DEPT" HELP_URL="multiDept" BIND-CODE="CD_DEPT"
                                         BIND-TEXT="NM_DEPT"/>
                        </ax:td>
                        <ax:td label='증빙일자' width="400px">
                            <div class="input-group" data-ax5picker="basic">
                                <input type="text" class="form-control" placeholder="yyyy/mm/dd" id="DT_START" formatter="YYYYMMDD">
                                <span class="input-group-addon">~</span>
                                <input type="text" class="form-control" placeholder="yyyy/mm/dd" id="DT_END" formatter="YYYYMMDD">
                                <span class="input-group-addon"><i class="cqc-calendar"></i></span>
                            </div>
                        </ax:td>
                    </ax:tr>
                </ax:tbl>
            </ax:form>
            <div class="H10"></div>
        </div>

        <div data-ax5grid="grid-view-01"
             data-ax5grid-config="{  showLineNumber: true,showRowSelector: false, multipleSelect: false,lineNumberColumnWidth: 40,rowSelectorColumnWidth: 27, }"
             id="top_grid"
        ></div>

    </jsp:body>
</ax:layout>