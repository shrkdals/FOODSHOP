<%@ page import="com.chequer.axboot.core.utils.MessageUtils" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>

<ax:set key="title" value="공지사항"/>
<ax:set key="page_desc" value="${pageRemark}"/>
<ax:set key="page_auto_height" value="true"/>


<ax:layout name="base">
    <jsp:attribute name="script">


        <ax:script-lang key="ax.script"/>

        <script type="text/javascript">
            var modal = new ax5.ui.modal();
            var menuParam = this.parent.fnObj.tabView.urlGetData();
            var FileBrowserModal = new ax5.ui.modal();
            var loca = document.location.search;
            console.log("loca", loca);
            var InitData = {};
            if (nvl(loca, '') != '') {
                var search = document.location.search.split('?')[1].split('&');

                for (var i = 0; i < search.length; i++) {
                    var key = search[i].split('=')[0];
                    var value = search[i].split('=')[1];
                    eval("InitData." + key + "= value");
                }
            }
            var page = 1;               //  페이지 기초값 : 1
            var BOARD_TYPE = "notice";  //  종류
            var paging_size;            //  화면에 보여줄 데이터 수
            var condition;              //  조회조건
            var keyword;                //  조회조건 검색어

            var CONDITION = [
                {value: "COM", text: "제목+내용"},
                {value: "SUB", text: "제목"},
                {value: "CON", text: "내용"},
                {value: "AUT", text: "작성자"}
            ];

            $('#CONDITION').ax5select({
                options: CONDITION
            });

            var EACHPG = [
                {value: "10", text: "10개씩보기"},
                {value: "15", text: "15개씩보기"},
                {value: "20", text: "20개씩보기"}
                /* {value: "50", text: "50개씩보기"},
                 {value: "100", text: "100개씩보기"}*/
            ];

            $('#EACHPG').ax5select({
                options: EACHPG
            });

            goPaging_notice_m = function (index) {
                page = index;
                ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
            };

            goPage = function (url) {
                window.location.href = url;
            };


            Paging = function (totalCnt, dataSize, pageSize, pageNo, token) {
                totalCnt = parseInt(totalCnt);// 전체레코드수
                dataSize = parseInt(dataSize); // 페이지당 보여줄 데이타수
                pageSize = parseInt(pageSize); // 페이지 그룹 범위 1 2 3 5 6 7 8 9 10
                pageNo = parseInt(pageNo); // 현재페이지
                var html = [];
                if (totalCnt == 0) {
                    return "";
                } // 페이지 카운트
                var pageCnt = totalCnt % dataSize;
                if (pageCnt == 0) {
                    pageCnt = parseInt(totalCnt / dataSize);
                } else {
                    pageCnt = parseInt(totalCnt / dataSize) + 1;
                }
                var pRCnt = parseInt(pageNo / pageSize);
                if (pageNo % pageSize == 0) {
                    pRCnt = parseInt(pageNo / pageSize) - 1;
                } //이전 화살표
                if (pageNo > pageSize) {
                    console.log("이전 gopaging");
                    var s2;
                    if (pageNo % pageSize == 0) {
                        s2 = pageNo - pageSize;
                    } else {
                        s2 = pageNo - pageNo % pageSize;
                    }
                    html.push('<span>');
                    html.push('<a href=javascript:goPaging_' + token + '("');
                    html.push(s2);
                    html.push('"); class="nav prev">');
                    html.push("</a>");
                    html.push('</span>');
                } else {
                    console.log("이전 #");
                    html.push('<span>');
                    html.push('<a href="#" class="nav prev">');
                    html.push('</a>');
                    html.push('</span>');
                } //paging Bar
                for (var index = pRCnt * pageSize + 1; index < (pRCnt + 1) * pageSize + 1; index++) {
                    if (index == pageNo) {
                        html.push('<span>');
                        html.push('<a class="on">');
                        html.push(index);
                        html.push('</a>');
                        html.push('</span>');
                    } else {
                        html.push('<span>');
                        html.push('<a href=javascript:goPaging_' + token + '("');
                        html.push(index);
                        html.push('");>');
                        html.push(index);
                        html.push('</a>');
                        html.push('</span>');
                    }
                    if (index == pageCnt) {
                        break;
                    }
                } //다음 화살표
                if (pageCnt > (pRCnt + 1) * pageSize) {
                    html.push('<a class="nav next" href=javascript:goPaging_' + token + '("');
                    html.push((pRCnt + 1) * pageSize + 1);
                    html.push('");>');
                    html.push('</a>');
                } else {
                    html.push('<a href="#" class="nav next">');
                    html.push('</a>');
                }
                return html.join("");
            };


            var writeCallBack = function (e) {
                ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                modal.close();
                qray.alert('성공적으로 저장되었습니다.');
            };

            var fnObj = {}, CODE = {};
            var ACTIONS = axboot.actionExtend(fnObj, {
                PAGE_SEARCH: function (caller, act, data) {

                    condition = $('[data-ax5select="CONDITION"]').ax5select("getValue")[0].value;
                    keyword = $("#KEYWORD").val();
                    paging_size = $('[data-ax5select="EACHPG"]').ax5select("getValue")[0].value;
                    var totalPageCount = 0;
                    var totalDataCount = 0;

                    axboot.ajax({
                        type: "GET",
                        url: ["Bbs", "selectList"],
                        async: false,
                        data: {
                            "P_NOWPAGE": page,
                            "P_PAGING_SIZE": 0,
                            "P_BOARD_TYPE": BOARD_TYPE,
                            "P_KEYWORD": keyword,
                            "P_CONDITION": condition,
                            "P_OPT": "TOT",
                            "P_SEQ": 0
                        },
                        callback: function (res) {
                            if (res.list.length > 0) {
                                console.log(res.list[0]);
                                totalDataCount = res.list[0].TOT_PAGE;
                                totalPageCount = Math.ceil(res.list[0].TOT_PAGE / paging_size);
                            }
                        }
                    });

                    axboot.ajax({
                        type: "GET",
                        url: ["Bbs", "selectList"],
                        async: false,
                        data: {
                            "P_BOARD_TYPE": BOARD_TYPE,
                            "P_KEYWORD": keyword,
                            "P_CONDITION": condition,
                            "P_NOWPAGE": page,
                            "P_PAGING_SIZE": paging_size,
                            "P_OPT": 0,
                            "P_SEQ": 0
                        },
                        callback: function (res) {

                            $(".noData").remove();
                            $(".selectTR").remove();
                            var html = "";

                            if (res.list.length == 0) {     //  조회데이터가 없다.
                                html = "";
                                html += "</tr class='noData'>";
                                html += "<td colspan='5' height='500px' align='center'>데이터가 없습니다.";
                                html += "</tr>";

                                $("#body").append(html);
                            }

                            var searchQuery = "";
                            if ($("#keyword").val()) {
                                searchQuery = '&condition=' + condition + '&keyword=' + keyword;
                            }
                            var pagingQuery = "";
                            if (paging_size) {
                                pagingQuery = "&paging_size=" + paging_size;
                            }

                            var listNum = totalDataCount - (page - 1) * paging_size;
                            for (var i = 0; i < res.list.length; i++) {
                                var result = res.list[i];

                                var detailPath = "p_cz_q_bbs_detail_m.jsp?page=" + page + "&BOARD_TYPE=" + BOARD_TYPE +
                                    "&seq=" + result.SEQ + searchQuery + pagingQuery;
                                html = "";
                                html += "<tr class='selectTR' onclick=\"goPage('../bbs/" + detailPath + "')\" style=\"cursor:hand\">";
                                html += "<td>" + result.SEQ + "</td>";
                                html += "<td class=\"tit\">" + result.TITLE + "</td>";
                                html += "<td>" + $.changeDataFormat(result.DTS_INSERT, "yyyyMMddhhmmss") + "</td>";
                                html += "<td>" + result.NM_KOR + "</td>";
                                html += "<td>" + result.HIT + "</td>";
                                html += "</tr>";

                                $("#body").append(html);
                            }
                            var page_viewList = Paging(totalDataCount, paging_size, 5, page, "notice_m"); //Paging(전체데이타수,페이지당 보여줄 데이타수,페이지 그룹 범위,현재페이지 번호,token명)
                            $("#pager1").empty().html(page_viewList);
                        }
                    });
                },
                ITEM_WRITE: function (caller, act, data) {
                    modal.open({
                        width: 1000,
                        height: 700,
                        top: _pop_top,
                        iframe: {
                            method: "get",
                            url: '../bbs/p_cz_q_bbs_write_m.jsp',
                            param: "callBack=writeCallBack"
                        },
                        sendData: {
                            P_BOARD_TYPE: BOARD_TYPE,
                            FileBrowserModal: FileBrowserModal
                        },
                        onStateChanged: function () {
                            // mask
                            if (this.state === "open") {
                                mask.open({
                                    content: '<h1><i class="fa fa-spinner fa-spin"></i> Loading</h1>'
                                });
                            } else if (this.state === "close") {
                                mask.close();
                            }
                        }
                    }, function () {

                    });
                }
            });


            // fnObj 기본 함수 스타트와 리사이즈
            fnObj.pageStart = function () {
                this.pageButtonView.initView();
                this.searchView.initView();


                page = nvl(InitData["page"], '') != '' ? InitData["page"] : page;
                BOARD_TYPE = nvl(InitData["BOARD_TYPE"], '') != '' ? InitData["BOARD_TYPE"] : BOARD_TYPE;
                paging_size = nvl(InitData["paging_size"], '') != '' ? InitData["paging_size"] : paging_size;
                condition = nvl(InitData["condition"], '') != '' ? InitData["condition"] : condition;
                keyword = nvl(InitData["keyword"], '') != '' ? InitData["keyword"] : keyword;

                $("#CONDITION").ax5select("setValue", nvl(condition, "COM"), true);
                $("#EACHPG").ax5select("setValue", nvl(paging_size, "10"), true);

                ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
            };


            fnObj.pageResize = function () {

            };

            fnObj.pageButtonView = axboot.viewExtend({
                initView: function () {
                    axboot.buttonClick(this, "data-page-btn", {
                        "search": function () {
                            page = '1';
                            ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                        },
                        "write": function () {
                            ACTIONS.dispatch(ACTIONS.ITEM_WRITE);
                        },
                    });
                }
            });

            function openCalenderModal(callBack, viewName, initData) {
                var map = new Map();
                map.set("modal", calenderModal);
                map.set("modalText", "calenderModal");
                map.set("viewName", viewName);
                map.set("initData", initData);

                $.openCommonUtils(callBack, map, 'calender', 340, 450, _pop_top450);
            }

            function openFileModal(callBack, viewName, initData) {
                var map = new Map();
                map.set("modal", FileBrowserModal);
                map.set("modalText", "FileBrowserModal");
                map.set("viewName", viewName);
                map.set("initData", initData);

                $.openCommonUtils(callBack, map, 'fileBrowser', _pop_width1000, _pop_height, _pop_top);
            }

            //== view 시작
            fnObj.searchView = axboot.viewExtend(axboot.searchView, {
                initView: function () {
                    this.target = $(document["searchView0"]);
                    this.target.attr("onsubmit", "return ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);");
                    this.lnPartner = $("#lnPartner");
                    this.noCompany = $("#noCompany");
                },
                getData: function () {
                    return {
                        P_NOWPAGE: page,
                        P_BOARD_TYPE: BOARD_TYPE,
                        P_KEYWORD: keyword,
                        P_CONDITION: condition,
                        P_PAGING_SIZE: paging_size,
                        P_OPT: 0,
                        P_SEQ: 0
                    }
                }
            });

            $(document).on("change", "#EACHPG", function () {
                paging_size = $('[data-ax5select="EACHPG"]').ax5select("getValue")[0].value;
                page = 1;
                ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                var winHeight = $(window).height();
                //$("#scrollBody").attr("style", "overflow-y :auto;height:" + (winHeight - 100) + "px;");
                //$("#jb-container").attr("style", "height:" + (winHeight - 100) + "px;");
            });

            $(window).resize(function () {
                var winHeight = $(window).height();
                //$("#scrollBody").attr("style", "overflow-y :auto;height:" + (winHeight - 100) + "px;");
                //$("#jb-container").attr("style", "height:" + (winHeight - 100) + "px;");

                // $('#table01').css('height', $(window).height() - 50);
            });
            $(document).ready(function () {
                var winHeight = $(window).height();
                //$("#scrollBody").attr("style", "overflow-y :auto;height:" + (winHeight - 100) + "px;");
                //$("#jb-container").attr("style", "height:" + (winHeight - 100) + "px;");
            });

            //////////////////////////////////////
            //크기자동조정
            var _pop_top = 0;
            var _pop_top450 = 0;
            var _pop_height = 0;
            var _pop_width1000 = 0;
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
                    _pop_top450 = parseInt((totheight - 450) / 2);
                    _pop_width1000 = 1000;
                } else {
                    _pop_height = totheight / 10 * 8;
                    _pop_top = parseInt((totheight - _pop_height) / 2);
                    _pop_top450 = parseInt((totheight - 450) / 2);
                    _pop_width1000 = 900;
                }

                var totheight = $("#ax-base-root").height();

                //데이터가 들어갈 실제높이
                var datarealheight = $("#ax-base-root").height() - $(".ax-base-title").height() - $("#pageheader").height();
                //타이틀을 뺀 상하단 그리드 합친높이
                var tempgridheight = datarealheight - $("#title").height();

                $("#scrollBody").css("height", tempgridheight / 100 * 99);

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

            /* CSS 입력 */

            tr.selectTR:hover {
                background-color: lightyellow;
                cursor: hand;
            }

            * {
                -moz-box-sizing: border-box;
                box-sizing: border-box;
            }

            html, body {
                margin: 0;
                padding: 0;
                width: 100%;
                height: 100%;
                font-size: 12px;
                overflow: auto;
            }

            .wrapperDiv {
                width: 100%;
                height: 100%;
            }

            .leftDiv {
                background-color: #fcf8e3;
                position: absolute;
                width: auto;
                height: auto;
                top: 0px;
                right: 0px;
                bottom: 0px;
                left: 0px;
                margin-top: 100px;

            }

            .rightDiv {
                background-color: #dff0d8;
                position: absolute;
                top: 0;
                right: 0;
                width: 100%;
                height: 100px;
            }

            .table-area {
                position: relative;
                z-index: 0;
            }

            table.responsive-table {
                width: 100%;
            }

            table.responsive-table th {
                background: #eee;
            }

            table.responsive-table td {
                line-height: 2em;
            }

            td {
                border-top: 1px solid #ddd;
                border-bottom: 1px solid #ddd;
            }

        </style>
        <div data-page-buttons="">
            <div class="button-warp">
                <button type="button" class="btn btn-reload" data-page-btn="reload"
                        onclick="window.location.reload();" style="width:80px;">
                    <i class="icon_reload"></i></button>
                <button type="button" class="btn btn-info" data-page-btn="write" style="width:80px;"><i
                        class="icon_add"></i>
                    쓰기
                </button>
                <button type="button" class="btn btn-info" data-page-btn="search" style="width:80px;"><i
                        class="icon_search"></i> <ax:lang
                        id="ax.admin.sample.modal.button.search"/></button>

            </div>
        </div>
        <div role="page-header" id="pageheader">
            <ax:form name="searchView0">
                <ax:tbl clazz="ax-search-tb1" minWidth="500px">
                    <ax:tr>
                        <ax:td label='조회조건' width="300px">
                            <div id="CONDITION" name="CONDITION" data-ax5select="CONDITION"
                                 data-ax5select-config='{edit:false}'></div>
                        </ax:td>
                        <ax:td label='검색내용' width="300px">
                            <input type="text" class="form-control" id="KEYWORD">
                        </ax:td>
                    </ax:tr>
                </ax:tbl>
            </ax:form>
            <div class="H10"></div>
        </div>
        <div class="ax-button-group" data-fit-height-aside="grid-view-01" id="title">
            <div class="left">
                <h2>
                    <i class="icon_list"></i> 목록
                </h2>
            </div>
        </div>
        <div id="scrollBody" style="overflow-y :auto;">
            <div style="width:100%;" id="scrollBodyin">
                <div class="board">
                    <div class="bbsList">
                        <table>
                            <colgroup>
                                <col style="width:40px">
                                <col>
                                <col style="width:170px">
                                <col style="width:120px">
                                <col style="width:100px">
                            </colgroup>
                            <thead>
                            <tr>
                                <th scope="col" style="text-align: center">번호</th>
                                <th scope="col" style="text-align: left">제목</th>
                                <th scope="col" style="text-align: center">등록일자</th>
                                <th scope="col" style="text-align: center">작성자</th>
                                <th scope="col" style="text-align: center">조회수</th>
                            </tr>
                            </thead>
                            <tbody id="body">
                            </tbody>
                        </table>
                    </div>
                    <div class="page">
                        <div class="view">
                            <div id="EACHPG" name="EACHPG" data-ax5select="EACHPG"
                                 data-ax5select-config='{edit:false}' style="width: 100px;"></div>
                        </div>

                        <div id="pager1"></div>

                    </div>
                </div>
            </div>
        </div>
    </jsp:body>
</ax:layout>