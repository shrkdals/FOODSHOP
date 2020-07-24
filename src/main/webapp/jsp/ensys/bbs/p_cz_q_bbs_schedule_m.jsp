<%@ page import="com.chequer.axboot.core.utils.MessageUtils" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>

<ax:set key="title" value="일정관리"/>
<ax:set key="page_desc" value="${pageRemark}"/>
<ax:set key="page_auto_height" value="true"/>


<ax:layout name="base">
    <jsp:attribute name="script">


        <ax:script-lang key="ax.script"/>

        <script type="text/javascript">

            var today = new Date();//오늘 날짜//내 컴퓨터 로컬을 기준으로 today에 Date 객체를 넣어줌
            var date = new Date();//today의 Date를 세어주는 역할
            var FileBrowserModal = new ax5.ui.modal();
            var calenderModal = new ax5.ui.modal();
            var selectedDate_YYYY_MM_DD;
            var selectedDate_YYYY_MM;
            var detailSeq;
            var TypeMode = 'list';

            var totalDataCount = 0;
            var page = 1;               //  페이지 기초값 : 1
            var paging_size = 10;            //  화면에 보여줄 데이터 수 [ 고정 ]

            function openCalenderModal(callBack, viewName, initData) {  //  관리항목 CALENDER 도움창오픈
                var map = new Map();
                map.set("modal", calenderModal);
                map.set("modalText", "calenderModal");
                map.set("viewName", viewName);
                map.set("initData", initData);

                $.openCommonUtils(callBack, map, 'calender');
            }

            function openFileModal(callBack, viewName, initData) {
                var map = new Map();
                map.set("modal", FileBrowserModal);
                map.set("modalText", "FileBrowserModal");
                map.set("viewName", viewName);
                map.set("initData", initData);

                $.openCommonUtils(callBack, map, 'fileBrowser');
            }

            var goPaging_schedule_m = function (index) {
                page = index;
                ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
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
                    var s2;
                    if (pageNo % pageSize == 0) {
                        s2 = pageNo - pageSize;
                    } else {
                        s2 = pageNo - pageNo % pageSize;
                    }
                    html.push('<a href=javascript:goPaging_' + token + '("');
                    html.push(s2);
                    html.push('");>');
                    html.push('◀');
                    html.push("</a>");
                } else {
                    html.push('<a href="#">\n');
                    html.push('◀');
                    html.push('</a>');
                } //paging Bar
                for (var index = pRCnt * pageSize + 1; index < (pRCnt + 1) * pageSize + 1; index++) {
                    if (index == pageNo) {
                        html.push('<strong>');
                        html.push(index);
                        html.push('</strong>');
                    } else {
                        html.push('<a href=javascript:goPaging_' + token + '("');
                        html.push(index);
                        html.push('");>');
                        html.push(index);
                        html.push('</a>');
                    }
                    if (index == pageCnt) {
                        break;
                    } else html.push('|');
                } //다음 화살표
                if (pageCnt > (pRCnt + 1) * pageSize) {
                    html.push('<a href=javascript:goPaging_' + token + '("');
                    html.push((pRCnt + 1) * pageSize + 1);
                    html.push('");>');
                    html.push('▶');
                    html.push('</a>');
                } else {
                    html.push('<a href="#">');
                    html.push('▶');
                    html.push('</a>');
                }
                return html.join("");
            };

            goPage = function (mode, userId) {
                console.log("userId", userId);
                $("#mode").remove();
                var html = "";
                if (mode == 'list') {
                    TypeMode = 'list';
                    $("#Btnlist").hide();
                    $("#Btndelete").hide();
                    $("#Btnupdate").hide();
                    $("#Btnwrite").show();

                    $("#pager1").show();
                    $("#pager2").hide();
                    html =
                        "<div class=\"ax-button-group\">\n" +
                        "                        <div class=\"left\">\n" +
                        "                            <h2>\n" +
                        "                                <i class=\"icon_list\"></i> 목록\n" +
                        "                            </h2>\n" +
                        "                        </div>\n" +
                        "                    </div>" +
                        "<table class=\"responsive-table table\" id=\"mode\">\n" +
                        "                    <colgroup>\n" +
                        "                        <col width=\"50px\">\n" +
                        "                        <col width=\"*\">\n" +
                        "                        <col width=\"150px\">\n" +
                        "                        <col width=\"150px\">\n" +
                        "                    </colgroup>\n" +
                        "                    <tbody id=\"list\" style=\"height: auto;\">\n" +
                        "                    <tr>\n" +
                        "<td class='board-th one'>번호</td>" +
                        "<td class='board-th two'>제목</td>" +
                        "<td class='board-th three'>작성자</td>" +
                        "<td class='board-th four'>등록일시</td>" +
                        "                    </tr>\n" +
                        "                    </tbody>\n" +
                        "                </table>";
                    $("#body").html(html);
                    ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                } else {
                    TypeMode = 'detail';
                    $("#Btnlist").show();
                    $("#Btnwrite").hide();

                    if (userId == SCRIPT_SESSION.idUser) {
                        $("#Btndelete").show();
                        $("#Btnupdate").show();
                    } else {
                        $("#Btndelete").hide();
                        $("#Btnupdate").hide();
                    }
                    $("#pager1").hide();
                    $("#pager2").show();

                    html =
                        "<div class=\"ax-button-group\">\n" +
                        "                        <div class=\"left\">\n" +
                        "                            <h2>\n" +
                        "                                <i class=\"icon_list\"></i> 상세정보\n" +
                        "                            </h2>\n" +
                        "                        </div>\n" +
                        "                    </div>" +
                        "<table class=\"responsive-table table\" id=\"mode\">\n" +
                        "                            <colgroup>\n" +
                        "                                <col width=\"100px\">\n" +
                        "                                <col width=\"*\">\n" +
                        "                            </colgroup>\n" +
                        "                            <tbody>\n" +
                        "                            <tr>\n" +
                        "                                <td class='th' style=\"vertical-align: middle;\">제목</td>\n" +
                        "                                <td class='td' style=\"vertical-align: middle;\">\n" +
                        "                                    <div class=\"left-box\"><input type=\"text\" id=\"TITLE\" class=\"inputText\" width: 105%;\n" +
                        "                                                                 disabled>\n" +
                        "                                    </div>\n" +
                        "                                    <div class=\"right-box\" align=\"right\" id=\"HIT\"></div>\n" +
                        "                                </td>\n" +
                        "                            </tr>\n" +
                        "                            </tbody>\n" +
                        "                        </table>\n" +
                        "                        <div class=\"right-box\" align=\"right\" id=\"INFO\">\n" +
                        "                        </div>\n" +
                        "                        <br>\n" +
                        "                        <input type='hidden' id='TYPE' name='TYPE'>" +
                        "                        <div id=\"CONTENTS\" class=\"noresize\" readonly></div>\n";
                    $("#body").html(html);

                    ACTIONS.dispatch(ACTIONS.DETAIL_SEARCH, mode);

                }

            };

            function prevCalendar() {//이전 달
                // 이전 달을 today에 값을 저장하고 달력에 today를 넣어줌
                //today.getFullYear() 현재 년도//today.getMonth() 월  //today.getDate() 일
                //getMonth()는 현재 달을 받아 오므로 이전달을 출력하려면 -1을 해줘야함
                today = new Date(today.getFullYear(), today.getMonth() - 1, today.getDate());
                buildCalendar(); //달력 cell 만들어 출력
            }

            function nextCalendar() {//다음 달
                // 다음 달을 today에 값을 저장하고 달력에 today 넣어줌
                //today.getFullYear() 현재 년도//today.getMonth() 월  //today.getDate() 일
                //getMonth()는 현재 달을 받아 오므로 다음달을 출력하려면 +1을 해줘야함
                today = new Date(today.getFullYear(), today.getMonth() + 1, today.getDate());
                buildCalendar();//달력 cell 만들어 출력
            }

            function buildCalendar() {//현재 달 달력 만들기
                var doMonth = new Date(today.getFullYear(), today.getMonth(), 1);
                //이번 달의 첫째 날,
                //new를 쓰는 이유 : new를 쓰면 이번달의 로컬 월을 정확하게 받아온다.
                //new를 쓰지 않았을때 이번달을 받아오려면 +1을 해줘야한다.
                //왜냐면 getMonth()는 0~11을 반환하기 때문
                var lastDate = new Date(today.getFullYear(), today.getMonth() + 1, 0);
                //이번 달의 마지막 날
                //new를 써주면 정확한 월을 가져옴, getMonth()+1을 해주면 다음달로 넘어가는데
                //day를 1부터 시작하는게 아니라 0부터 시작하기 때문에
                //대로 된 다음달 시작일(1일)은 못가져오고 1 전인 0, 즉 전달 마지막일 을 가져오게 된다
                var tbCalendar = document.getElementById("calendar");
                //날짜를 찍을 테이블 변수 만듬, 일 까지 다 찍힘
                var tbCalendarYM = document.getElementById("tbCalendarYM");
                //테이블에 정확한 날짜 찍는 변수ㅁ
                //innerHTML : js 언어를 HTML의 권장 표준 언어로 바꾼다
                //new를 찍지 않아서 month는 +1을 더해줘야 한다.
                tbCalendarYM.innerHTML = today.getFullYear() + "년 " + (today.getMonth() + 1) + "월";
                var daymonth = (today.getMonth() + 1);
                daymonth = daymonth < 10 ? "0" + daymonth : daymonth;
                selectedDate_YYYY_MM = today.getFullYear() + "" + daymonth;
                /*while은 이번달이 끝나면 다음달로 넘겨주는 역할*/
                while (tbCalendar.rows.length > 2) {
                    //열을 지워줌
                    //기본 열 크기는 body 부분에서 2로 고정되어 있다.
                    tbCalendar.deleteRow(tbCalendar.rows.length - 1);
                    //테이블의 tr 갯수 만큼의 열 묶음은 -1칸 해줘야지
                    //30일 이후로 담을달에 순서대로 열이 계속 이어진다.
                }
                var row = null;
                row = tbCalendar.insertRow();
                //테이블에 새로운 열 삽입//즉, 초기화
                var cnt = 0;// count, 셀의 갯수를 세어주는 역할
                // 1일이 시작되는 칸을 맞추어 줌
                for (i = 0; i < doMonth.getDay(); i++) {
                    /*이번달의 day만큼 돌림*/
                    cell = row.insertCell();//열 한칸한칸 계속 만들어주는 역할
                    cnt = cnt + 1;//열의 갯수를 계속 다음으로 위치하게 해주는 역할
                }
                /*달력 출력*/
                for (i = 1; i <= lastDate.getDate(); i++) {

                    i = i < 10 ? "0" + i : i;
                    //1일부터 마지막 일까지 돌림
                    cell = row.insertCell();//열 한칸한칸 계속 만들어주는 역할
                    cell.innerHTML =
                        "<table onclick='clickFunction(" + '"' + i + '"' + ")' style='height: 100%;' id='table" + i + "'>" +
                        "<tr>" +
                        "   <td align='right'><div align='right' style='margin-right: 30px;font-size:14px;' id='div" + i + "'>" + i + "</div></td>" +
                        "</tr>" +
                        "<tr>" +
                        "   <td><div class='TITLE' id='TITLE" + i + "'/></td>" +
                        "</tr>" +
                        "</table>";//셀을 1부터 마지막 day까지 HTML 문법에 넣어줌

                    cnt = cnt + 1;//열의 갯수를 계속 다음으로 위치하게 해주는 역할
                    if (cnt % 7 == 1) {/*일요일 계산*/
                        //1주일이 7일 이므로 일요일 구하기
                        //월화수목금토일을 7로 나눴을때 나머지가 1이면 cnt가 1번째에 위치함을 의미한다
                        cell.innerHTML =
                            "<table onclick='clickFunction(" + '"' + i + '"' + ")' id='table" + i + "'>" +
                            "<tr>" +
                            "   <td align='right'><div align='right' style='margin-right: 30px;font-size:14px;color:#eb5739;' id='div" + i + "'>" + i + "</div></td>" +
                            "</tr>" +
                            "<tr>" +
                            "   <td><div class='TITLE' id='TITLE" + i + "'/></td>" +
                            "</tr>" +
                            "</table>";
                        //1번째의 cell에만 색칠
                    }
                    if (cnt % 7 == 0) {/* 1주일이 7일 이므로 토요일 구하기*/
                        //월화수목금토일을 7로 나눴을때 나머지가 0이면 cnt가 7번째에 위치함을 의미한다
                        cell.innerHTML =
                            "<table onclick='clickFunction(" + '"' + i + '"' + ")' id='table" + i + "'>" +
                            "<tr>" +
                            "   <td align='right'><div align='right' style='margin-right: 30px;font-size:14px;color:#4987d3;' id='div" + i + "'>" + i + "</div></td>" +
                            "</tr>" +
                            "<tr>" +
                            "   <td><div class='TITLE' id='TITLE" + i + "'/></td>" +
                            "</tr>" +
                            "</table>";
                        //7번째의 cell에만 색칠
                        row = calendar.insertRow();
                        //토요일 다음에 올 셀을 추가
                    }

                    if (today.getFullYear() == date.getFullYear()
                        && today.getMonth() == date.getMonth()
                        && i == date.getDate()) {


                    }
                }
                if (TypeMode == 'detail') {
                    goPage('list');
                }
                ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
            }

            var clickFunction = function (index) {

                if (TypeMode == 'detail') {
                    goPage('list');
                }

                if ($(".selected").length > 0) {
                    $(".selected").removeClass();
                }
                var obj = $("#table" + index);
                obj.addClass('selected');

                selectedDate_YYYY_MM_DD = selectedDate_YYYY_MM + index;
                ACTIONS.dispatch(ACTIONS.ITEM_SEARCH);
            };

            var fnObj = {}, CODE = {};
            var ACTIONS = axboot.actionExtend(fnObj, {

                PAGE_SEARCH: function (caller, act, data) {
                    axboot.ajax({
                        type: "GET",
                        url: ["schedule", "selectList"],
                        async: false,
                        data: {
                            "P_DATE": selectedDate_YYYY_MM,
                            "P_OPT": "TOT",
                            "P_NOWPAGE": 0,
                            "P_PAGING_SIZE": 0
                        },
                        callback: function (res) {

                            // 초기화
                            var titles = $(".TITLE");
                            for (var i = 0; i < titles.length; i++) {
                                titles.html("");
                            }

                            // 값 설정
                            if (res.list.length > 0) {

                                for (var i = 0; i < res.list.length; i++) {
                                    var list = res.list[i];
                                    var day = list.SCHEDULE.substr(6, 8);
                                    var count = Number(list.CNT);

                                    $("#table" + day).attr('count', nvl(count, 0));

                                    axboot.ajax({
                                        type: "GET",
                                        url: ["schedule", "selectList"],
                                        async: false,
                                        data: {
                                            "P_DATE": list.SCHEDULE,
                                            "P_OPT": "",
                                            "P_NOWPAGE": page,
                                            "P_PAGING_SIZE": paging_size
                                        },
                                        callback: function (result) {
                                            if (result.list.length == 0) {
                                                $("#TITLE" + day).val('');
                                            }
                                            if (result.list.length > 0) {
                                                var html = "";
                                                for (var t = 0; t < result.list.length; t++) {
                                                    var title = result.list[t].TITLE;
                                                    var nm_kor = result.list[t].NM_KOR;

                                                    if (result.list[t].TYPE == '1') {
                                                        if (title.length > 6) {
                                                            html += '<div style="font-size: 12px;color:#898989">' + "[" + nm_kor + "] " + title.substring(0, 6) + ".." + '</div>';
                                                        } else {
                                                            html += '<div style="font-size: 12px;color:#898989">' + "[" + nm_kor + "] " + title.substring(0, 6) + '</div>';
                                                        }
                                                        if (t < (result.list.length - 1)) {
                                                            html += "\n";
                                                        }
                                                    }
                                                }
                                                $("#TITLE" + day).html(html);
                                            }
                                        }
                                    });

                                }
                            } else {

                            }
                            if ($(".selected").length == 0) {
                                var year = date.getFullYear();
                                var month = (date.getMonth() + 1);
                                month = month < 10 ? "0" + month : month;

                                if (selectedDate_YYYY_MM == (year + "" + month)) {
                                    index = date.getDate();
                                    index = index < 10 ? "0" + index : index;
                                } else {
                                    index = "01";
                                }
                                var obj = $("#table" + index);
                                obj.addClass('selected');

                                selectedDate_YYYY_MM_DD = selectedDate_YYYY_MM + index;
                                ACTIONS.dispatch(ACTIONS.ITEM_SEARCH);
                            } else {
                                ACTIONS.dispatch(ACTIONS.ITEM_SEARCH);
                            }
                        }
                    });

                },
                ITEM_SEARCH: function (caller, act, data) {
                    axboot.ajax({
                        type: "GET",
                        url: ["schedule", "selectList"],
                        async: false,
                        data: {
                            "P_DATE": selectedDate_YYYY_MM_DD,
                            "P_OPT": "",
                            "P_NOWPAGE": page,
                            "P_PAGING_SIZE": paging_size
                        },
                        callback: function (res) {
                            var html = "<tr>" +
                                "<td class='board-th one'>번호</td>" +
                                "<td class='board-th two'>제목</td>" +
                                "<td class='board-th three'>작성자</td>" +
                                "<td class='board-th four'>등록일시</td>" +
                                "</tr>";
                            $("#list").html(html);
                            /**********************/

                            if (res.list.length == 0) {     //  조회데이터가 없다.
                                html = "";
                                html += "</tr>";
                                html += "<td class=\"board-td\" colspan='4' height='500px' align='center'>데이터가 없습니다.</td>";
                                html += "</tr>";

                                $("#list").append(html);
                            }

                            for (var i = 0; i < res.list.length; i++) {
                                var result = res.list[i];
                                var detailPath = "p_cz_q_bbs_detail_m.jsp";
                                html = "";
                                html += "<tr class=\"selectTR\" onclick=\"goPage(\'" + result.SEQ + "\',\'" + result.ID_INSERT + "\')\" style=\"cursor:hand\">";
                                html += "<td class=\"board-td\">" + result.SEQ + "</td>";
                                html += "<td class=\"board-td\">" + result.TITLE + "</td>";
                                html += "<td class=\"board-td\">" + result.NM_KOR + "</td>";
                                html += "<td class=\"board-td\">" + $.changeDataFormat(result.DTS_INSERT, "yyyyMMddhhmmss") + "</td>";
                                html += "</tr>";

                                $("#list").append(html);
                            }
                            if (nvl($("#table" + selectedDate_YYYY_MM_DD.substr(6, 8)).attr('count')) == '') {
                                $("#pager1").empty()
                            } else {
                                var page_viewList = Paging($("#table" + selectedDate_YYYY_MM_DD.substr(6, 8)).attr('count'), paging_size, 5, page, "schedule_m"); //Paging(전체데이타수,페이지당 보여줄 데이타수,페이지 그룹 범위,현재페이지 번호,token명)
                                $("#pager1").empty().html(page_viewList);
                            }
                        }
                    });
                },
                DETAIL_SEARCH: function (caller, act, data) {
                    if (nvl(data, '') == '') {
                        return false;
                    }
                    axboot.ajax({
                        type: "GET",
                        url: ["schedule", "selectDetail"],
                        async: false,
                        data: {
                            "P_SEQ": data,
                            "P_DATE": selectedDate_YYYY_MM_DD,
                            "P_OPT": "DEF"
                        },
                        callback: function (res) {
                            console.log("selectDetail", res);
                            $("#TITLE").val(res.list[0].TITLE);
                            $("#TYPE").val(res.list[0].TYPE);
                            document.getElementById('CONTENTS').innerHTML = res.list[0].CONTENTS;
                            // $("#CONTENTS").val(res.list[0].CONTENTS);
                            detailSeq = data;

                            axboot.ajax({
                                type: "GET",
                                url: ["schedule", "selectDetail"],
                                async: false,
                                data: {
                                    "P_SEQ": data,
                                    "P_DATE": selectedDate_YYYY_MM_DD,
                                    "P_OPT": "LIK"
                                },
                                callback: function (res) {
                                    for (var i = 0; i < res.list.length; i++) {
                                        var result = res.list[i];
                                        if (result.CD_STAT == 'NEXT') {
                                            var title = result.TITLE;
                                            $("#NEXT").text(title);
                                            $("#nextLink").attr("href", "javascript:goPage(\'" + result.SEQ + "\',\'" + result.ID_INSERT + "\')");
                                        }
                                        if (result.CD_STAT == 'PREV') {
                                            var title = result.TITLE;
                                            $("#PREV").text(title);
                                            $("#prevLink").attr("href", "javascript:goPage(\'" + result.SEQ + "\',\'" + result.ID_INSERT + "\')");
                                        }
                                    }
                                    if (res.list.length == 1) {
                                        if (res.list[0].CD_STAT == 'NEXT') {
                                            var title = "이전글이 없습니다.";
                                            $("#PREV").text(title);
                                            $("#prevLink").attr("href", "#");
                                        }
                                        if (res.list[0].CD_STAT == 'PREV') {
                                            var title = "다음글이 없습니다.";
                                            $("#NEXT").text(title);
                                            $("#nextLink").attr("href", "#");
                                        }
                                    }
                                    if (res.list.length == 0) {
                                        var title = "이전글이 없습니다.";
                                        $("#PREV").text(title);
                                        $("#prevLink").attr("href", "#");

                                        var title = "다음글이 없습니다.";
                                        $("#NEXT").text(title);
                                        $("#nextLink").attr("href", "#");
                                    }
                                    var DATA = {
                                        "BOARD_TYPE": 'schedule',
                                        "SEQ": data
                                    };
                                    axboot.ajax({
                                        type: "POST",
                                        async: false,
                                        url: ["commonutility", "BbsFileSearch"],
                                        data: JSON.stringify(DATA),
                                        callback: function (res) {
                                            var html = "";
                                            var chkVal;
                                            for (var i = 0; i < res.list.length; i++) {
                                                var list = res.list[i];
                                                if (i == 0) {
                                                    var FILEPATH = axboot.getfileRoot() + "\\" + list.FILE_NAME + "." + list.FILE_EXT;

                                                    if (window.navigator.msSaveBlob) { // IE
                                                        // html += '<a href="#" onclick="downloadFunc(\"'+ list.FILE_PATH +'\",\"' + list.FILE_NAME + '\",\"' + list.FILE_EXT + '\",\"' + list.ORGN_FILE_NAME + '\");">';
                                                        html += list.ORGN_FILE_NAME /*+ "</a>"*/
                                                    } else {
                                                        html += "<a href=\"" + FILEPATH + "\" download=\"" + list.ORGN_FILE_NAME + "\">";
                                                        html += list.ORGN_FILE_NAME + "</a>"
                                                    }
                                                } else {
                                                    chkVal = true;
                                                    break;
                                                }
                                            }
                                            if (chkVal) {
                                                html += ".. 외 " + (res.list.length - 1) + "개";
                                            }
                                            if (res.list.length == 0) {
                                                $("#FILE").html("");
                                            }
                                            $("#FILE").html(html);
                                        }
                                    });
                                }
                            });

                        }
                    });
                },
                ITEM_WRITE: function (caller, act, data) {
                    modal.open({
                        width: 1000,
                        height: 800,
                        iframe: {
                            method: "get",
                            url: '../bbs/p_cz_q_bbs_schedule_write_m.jsp',
                            param: "callBack=writeCallBack"
                        },
                        sendData: {
                            P_SCHEDULE: selectedDate_YYYY_MM_DD,
                            P_BOARD_TYPE: "schedule",
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
                },
                ITEM_DELETE: function (caller, act, data) {
                    var data = {
                        "P_SEQ": detailSeq,
                        "P_BOARD_TYPE": "schedule"
                    };
                    qray.confirm({
                        msg: "삭제하시겠습니까?"
                    }, function () {
                        if (this.key == "ok") {

                            axboot.ajax({
                                type: "PUT",
                                url: ["schedule", "deleteWrite"],
                                data: JSON.stringify(data),
                                callback: function (result) {
                                    if (nvl(result.map["MSG"], '') != '') {
                                        qray.alert(result.map["MSG"]);
                                    }
                                    if (result.map["chkVal"] == "N") {
                                        messageDialog.alert({
                                            title: "알림",
                                            msg: "성공적으로 삭제되었습니다.",
                                            onStateChanged: function () {
                                                if (this.state === "open") {
                                                    mask.open();
                                                } else if (this.state === "close") {
                                                    mask.close();
                                                    goPage('list');
                                                    ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                                                }
                                            }
                                        });
                                    }
                                }
                            })
                        }
                    })
                },
                ITEM_UPDATE: function (caller, act, data) {
                    modal.open({
                        width: 1000,
                        height: 800,
                        iframe: {
                            method: "get",
                            url: '../bbs/p_cz_q_bbs_schedule_write_m.jsp',
                            param: "callBack=writeCallBack2"
                        },
                        sendData: {
                            P_SEQ: detailSeq,
                            P_SCHEDULE: selectedDate_YYYY_MM_DD,
                            P_CONTENTS: document.getElementById('CONTENTS').innerHTML,
                            P_TITLE: $("#TITLE").val(),
                            P_TYPE: $("#TYPE").val(),
                            P_BOARD_TYPE: "schedule",
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
                },
            });

            var writeCallBack = function (e) {
                qray.alert('정상적으로 저장되었습니다.');
                selectedDate_YYYY_MM_DD = e["P_SCHEDULE"];
                ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
            };

            var writeCallBack2 = function (e) {
                qray.alert('정상적으로 저장되었습니다.');
                ACTIONS.dispatch(ACTIONS.DETAIL_SEARCH, e["P_SEQ"]);
                ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
            };


            // fnObj 기본 함수 스타트와 리사이즈
            fnObj.pageStart = function () {
                this.pageButtonView.initView();
                $("#Btnlist").hide();
                $("#Btndelete").hide();
                $("#Btnupdate").hide();
                $("#Btnwrite").show();

                $("#pager1").show();
                $("#pager2").hide();
                buildCalendar();
                var day = date.getDate();
                day = day < 10 ? "0" + day : day;

                var obj = $("#table" + day);
                obj.addClass('selected');

                selectedDate_YYYY_MM_DD = selectedDate_YYYY_MM + day;
                ACTIONS.dispatch(ACTIONS.ITEM_SEARCH);

            };

            $(window).resize(function () {
                var winHeight = $(window).height();
                $("#scrollBody1").attr("style", "overflow-y :auto;height:" + (winHeight - 100) + "px;");
                $("#scrollBody2").attr("style", "overflow-y :auto;height:" + (winHeight - 100) + "px;");
            });

            $(document).ready(function () {
                var winHeight = $(window).height();
                $("#scrollBody1").attr("style", "overflow-y :auto;height:" + (winHeight - 100) + "px;");
                $("#scrollBody2").attr("style", "overflow-y :auto;height:" + (winHeight - 100) + "px;");
            });

            var downloadFunc = function (FILE_PATH, FILE_NAME, FILE_EXT, ORGN_FILE_NAME) {

                var list = {
                    FILE_PATH : FILE_PATH,
                    FILE_NAME : FILE_NAME,
                    FILE_EXT : FILE_EXT,
                    ORGN_FILE_NAME : ORGN_FILE_NAME
                };

                var xhr = getXmlHttpRequest();

                xhr.open('POST', "/api/commonutility/downloadFile");
                xhr.responseType = 'blob';
                xhr.setRequestHeader('Content-type', 'application/json');
                xhr.onreadystatechange = function () {
                    if (this.readyState == 4 && this.status == 200) {
                        console.log(this.response);
                        var _data = this.response;
                        var _blob = new Blob([_data], {type: this.response.type});

                        window.navigator.msSaveOrOpenBlob(_blob, list.ORGN_FILE_NAME)
                    }
                };
                xhr.send(JSON.stringify(list));
            };


            fnObj.pageResize = function () {

            };

            fnObj.pageButtonView = axboot.viewExtend({
                initView: function () {
                    axboot.buttonClick(this, "data-page-btn", {
                        "search": function () {
                            ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                        },
                        "write": function () {
                            ACTIONS.dispatch(ACTIONS.ITEM_WRITE);
                        },
                        "list": function () {
                            goPage("list");
                        },
                        "update": function () {
                            ACTIONS.dispatch(ACTIONS.ITEM_UPDATE);
                        },
                        "delete": function () {
                            ACTIONS.dispatch(ACTIONS.ITEM_DELETE);
                        }
                    });
                }
            });

            var getXmlHttpRequest = function () {
                if (window.ActiveXObject) {
                    try {
                        return new ActiveXObject("Msxml2.XMLHTTP");
                    } catch (e) {
                        try {
                            return new ActiveXObject("Microsoft.XMLHTTP");
                        } catch (e1) {
                            qray.alert('에러에러');
                        }
                    }
                } else if (window.XMLHttpRequest) {
                    return new XMLHttpRequest();
                } else {
                    qray.alert('에러에러');
                }
            }


        </script>
    </jsp:attribute>
    <jsp:body>
        <style type="text/css">
            i {
                font-style: italic;
            }

            input[type=text] {
                border: none;
                background-color: transparent;
                width: 100%;
                font-size: 12px;
                outline-style: none;
            }

            tr.selectTR:hover {
                background-color: lightyellow;
                cursor: hand;
            }

            .selected {
                background-color: #f8dd24;
            }

            .circle {
                background-color: transparent;
                border: 3px solid #ff0000;
                width: 100px;
                height: 100px;
                border-radius: 75px;
                vertical-align: middle;
                line-height: 100px;

            }

            td {
                width: 227px;
                height: 60px;
                text-align: center;
                font-size: 20px;
                border-radius: 8px;
            }

            .board-td {
                border-top: 1px solid #ddd;
                border-bottom: 1px solid #ddd;
                text-align: left;
                font-size: 12px;
                width: 10%;
                height: 40px;
                line-height: 2em;
                vertical-align: middle;
            }

            .board-th {
                border-top: 1px solid #ddd;
                border-bottom: 1px solid #ddd;
                text-align: left;
                font-size: 14px;
                width: 10%;
                height: 50px;
                line-height: 2em;
                vertical-align: middle;
                background-color: #eee;
                border-radius: 0px;
            }

            .board-th one {
                width: 10%;
            }

            .board-th two {
                width: 50%;
            }

            .board-th three {
                width: 20%;
            }

            .board-th four {
                width: 20%;
            }

            #calendar {
                border: none;
            }


            .td {
                line-height: 5em;
                height: 50px;
                font-size: 12px;
                border: 1px solid #ddd;
            }

            .th {
                line-height: 5em;
                height: 50px;
                text-align: center;
                width: 10%;
                font-size: 12px;
                border: 1px solid #ddd;
            }

            #jb-footer1 {
                clear: both;
                height: 10%;
                border: 0px solid #eee;
            }

            .noresize {
                outline-style: none;
                border: 1px solid #eee;
                resize: none; /* 사용자 임의 변경 불가 */
                width: 100%;
                height: 50%;
                /* resize: both; !* 사용자 변경이 모두 가능 *!
                 resize: horizontal; !* 좌우만 가능 *!
                 resize: vertical; !* 상하만 가능 *!*/
            }

            .inputText {
                outline-style: none;
                border: 0px solid #eee;
            }

            .left-box {
                float: left;
                width: 90%;
            }

            .right-box {
                float: right;
            }

            .TITLE {
                text-align: left;
            }
        </style>

        <div data-page-buttons="">
            <div class="button-warp">
                <button type="button" class="btn btn-reload" data-page-btn="reload"
                        onclick="window.location.reload();" style="width:80px;">
                    <i class="icon_reload"></i></button>
                <button type="button" class="btn btn-info" id='Btnwrite' data-page-btn="write" id="write"
                        style="width:80px;">
                    글쓰기
                </button>
                <button type="button" class="btn btn-info" id='Btnupdate' data-page-btn="update" style="width:80px;">
                    수정
                </button>
                <button type="button" class="btn btn-info" id='Btndelete' data-page-btn="delete" style="width:80px;">
                    삭제
                </button>
                <button type="button" class="btn btn-info" data-page-btn="search" style="width:80px;"><i
                        class="icon_search"></i> <ax:lang
                        id="ax.admin.sample.modal.button.search"/></button>
                <button type="button" class="btn btn-info" id='Btnlist' data-page-btn="list" style="width:80px;">목록
                </button>
            </div>
        </div>
        <ax:split-layout name="ax1" orientation="vertical">
            <ax:split-panel width="1000" style="padding-right: 20px;height:1000px;">


                <div class="ax-button-group">
                    <div class="left">
                        <h2>
                            <i class="icon_list"></i> 달력
                        </h2>
                    </div>
                </div>

                <div id="scrollBody1" style="height: 800px;">
                    <table id="calendar" border="3" align="center">
                        <tr><!-- label은 마우스로 클릭을 편하게 해줌 -->
                            <td onclick="prevCalendar()"><label style="font-size:14px;"><</label></td>
                            <td align="center" id="tbCalendarYM" colspan="5" style="font-size:18px;font-weight:700">
                                yyyy년 m월
                            </td>
                            <td onclick="nextCalendar()"><label style="font-size:14px;">>

                            </label></td>
                        </tr>
                        <tr>
                            <td align="center" style="font-size:14px;font-weight:700;color:#eb5739;">일</td>
                            <td align="center" style="font-size:14px;font-weight:700;">월</td>
                            <td align="center" style="font-size:14px;font-weight:700;">화</td>
                            <td align="center" style="font-size:14px;font-weight:700;">수</td>
                            <td align="center" style="font-size:14px;font-weight:700;">목</td>
                            <td align="center" style="font-size:14px;font-weight:700;">금</td>
                            <td align="center" style="font-size:14px;font-weight:700;color:#4987d3;">토</td>
                        </tr>
                    </table>
                </div>
            </ax:split-panel>
            <ax:split-panel width="3" height="1000" style="background-color: #eee;"></ax:split-panel>
            <ax:split-panel width="*" height="1000" style="padding-left: 20px;">
                <div id="scrollBody2" style="height: 800px;">
                    <div id="body" style="height: 600px;">
                        <div class="ax-button-group">
                            <div class="left">
                                <h2>
                                    <i class="icon_list"></i> 목록
                                </h2>
                            </div>
                        </div>
                        <table class="responsive-table table" id="mode">
                            <colgroup>
                                <col width="50px">
                                <col width="*">
                                <col width="150px">
                            </colgroup>
                            <tbody id="list" style="height: auto;">
                            <tr>
                                <td class='board-th one'>번호</td>
                                <td class='board-th two'>제목</td>
                                <td class='board-th three'>작성자</td>
                                <td class='board-th four'>등록일시</td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                    <div id="jb-footer1">
                        <div id="pager1" align="middle" style="height: 100px;"></div>
                        <div id="pager2">
                            <table class="responsive-table table">
                                <colgroup>
                                    <col width="100px">
                                    <col width="*">
                                </colgroup>
                                <tbody>
                                <tr>
                                    <td class='th' style="vertical-align: middle;">첨부파일</td>
                                    <td class='td' style="vertical-align: middle; margin-left: 10px;" id="FILE">
                                    </td>
                                </tr>
                                <tr>
                                    <td class='th' style="vertical-align: middle;">이전글</td>
                                    <td class='td' style="vertical-align: middle;">
                                        <p class="gray_font"><a style="margin-left: 10px;" id="prevLink"><span
                                                id="PREV"></span></a></p>
                                    </td>
                                </tr>
                                <tr>
                                    <td class='th' style="vertical-align: middle;">다음글</td>
                                    <td class='td' style="vertical-align: middle;">
                                        <p class="gray_font"><a style="margin-left: 10px;" id="nextLink"><span
                                                id="NEXT"></span></a></p>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </ax:split-panel>
        </ax:split-layout>
    </jsp:body>
</ax:layout>