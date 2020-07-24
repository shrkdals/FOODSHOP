<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>

<ax:set key="title" value="날짜"/>
<ax:set key="page_desc" value="${PAGE_REMARK}"/>
<ax:set key="page_auto_height" value="true"/>

<ax:layout name="base">
    <jsp:attribute name="script">

        <script type="text/javascript">
            var fnObj = {};

            var param = ax5.util.param(ax5.info.urlUtil().param);

            var initData;
            if (param.modalName) {
                initData = eval("parent." + param.modalName + ".modalConfig.sendData");  // 부모로 부터 받은 Parameter Object
            } else {
                initData = parent.modal.modalConfig.sendData;  // 부모로 부터 받은 Parameter Object
            }

            var today = new Date();//오늘 날짜//내 컴퓨터 로컬을 기준으로 today에 Date 객체를 넣어줌
            var date = new Date();//today의 Date를 세어주는 역할

            var selectedDate_YYYY_MM_DD;
            var selectedDate_YYYY_MM;

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
                //tbCalendarYM.innerHTML = today.getFullYear() + "년 " + (today.getMonth() + 1) + "월";
                var str = "<div style='width:100%;min-height:40px;height:40px;background:#f5f5f5;border:1px solid #dddddd;border-radius: 5px 5px 5px 5px;overflow:hidden;'>";
                str += "<div style='width:15%;font-size:16px;font-weight:700;float:left;text-align:center;line-height:40px;user-select:none;' onclick='prevCalendar()'><</div>";
                str += "<div style='font-size:14px;font-weight:700;width:68%;float:left;text-align:center;line-height:40px;'>" + today.getFullYear() + "&nbsp;&nbsp;&nbsp;" + (today.getMonth() + 1) + "</div>";
                str += "<div style='width:15%;font-size:16px;font-weight:700;float:right;text-align:center;line-height:40px;user-select:none;' onclick='nextCalendar()'>></div>";
                str += "</div>";
                tbCalendarYM.innerHTML = str;
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
                        "<table ondblclick='DblClickFunction()' onclick='clickFunction(" + '"' + i + '"' + ")' style='height: 100%;' id='table" + i + "'>" +
                        "<tr>" +
                        "   <td class='tdcl'><div class = 'tdcldiv' id='div" + i + "'>" + i + "</div></td>" +
                        "</tr>" +
                        "</table>";//셀을 1부터 마지막 day까지 HTML 문법에 넣어줌

                    cnt = cnt + 1;//열의 갯수를 계속 다음으로 위치하게 해주는 역할
                    if (cnt % 7 == 1) {/*일요일 계산*/
                        //1주일이 7일 이므로 일요일 구하기
                        //월화수목금토일을 7로 나눴을때 나머지가 1이면 cnt가 1번째에 위치함을 의미한다
                        cell.innerHTML =
                            "<table ondblclick='DblClickFunction()' onclick='clickFunction(" + '"' + i + '"' + ")' id='table" + i + "'>" +
                            "<tr>" +
                            "   <td class='tdcl'><div class = 'tdcldiv' id='div" + i + "'><font color=#c78b81>" + i + "</font></div></td>" +
                            "</tr>" +
                            "</table>";
                        //1번째의 cell에만 색칠
                    }
                    if (cnt % 7 == 0) {/* 1주일이 7일 이므로 토요일 구하기*/
                        //월화수목금토일을 7로 나눴을때 나머지가 0이면 cnt가 7번째에 위치함을 의미한다
                        cell.innerHTML =
                            "<table ondblclick='DblClickFunction()' onclick='clickFunction(" + '"' + i + '"' + ")' id='table" + i + "'>" +
                            "<tr>" +
                            "   <td class='tdcl'><div class = 'tdcldiv' id='div" + i + "'><font color=#32b4dc>" + i + "</font></div></td>" +
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
            }

            var clickFunction = function (index) {

                if ($(".selected").length > 0) {
                    $(".selected").removeClass();
                }
                var obj = $("#table" + index);
                obj.addClass('selected');

                selectedDate_YYYY_MM_DD = selectedDate_YYYY_MM + index;
            };

            var DblClickFunction = function () {
                var data = {};
                data.YYYY = selectedDate_YYYY_MM_DD.substr(0, 4);
                data.MM = selectedDate_YYYY_MM_DD.substr(4, 2);
                data.DD = selectedDate_YYYY_MM_DD.substr(6, 2);
                data.YYYYMM = selectedDate_YYYY_MM;
                data.YYYYMMDD = selectedDate_YYYY_MM_DD;
                data.YYYY_MM_DD = $.changeDataFormat(selectedDate_YYYY_MM_DD, 'YYYYMMDD');

                console.log(data);
                if (param.viewName) {
                    parent.document.getElementsByName(param.viewName)[0].contentWindow[param.callBack](data);
                    return;
                }
                parent[param.callBack](data);
            };

            fnObj.pageStart = function () {
                this.pageButtonView.initView();
                buildCalendar();
                var day = date.getDate();
                day = day < 10 ? "0" + day : day;

                var obj = $("#table" + day);
                obj.addClass('selected');

                selectedDate_YYYY_MM_DD = selectedDate_YYYY_MM + day;
            };

            fnObj.pageButtonView = axboot.viewExtend({
                initView: function () {
                    axboot.buttonClick(this, "data-page-btn", {
                        "select": function () {
                            var data = {};
                            data.YYYY = selectedDate_YYYY_MM_DD.substr(0, 4);
                            data.MM = selectedDate_YYYY_MM_DD.substr(4, 2);
                            data.DD = selectedDate_YYYY_MM_DD.substr(6, 2);
                            data.YYYYMM = selectedDate_YYYY_MM;
                            data.YYYYMMDD = selectedDate_YYYY_MM_DD;
                            data.YYYY_MM_DD = $.changeDataFormat(selectedDate_YYYY_MM_DD, 'YYYYMMDD');

                            console.log(data);
                            if (param.viewName) {
                                parent.document.getElementsByName(param.viewName)[0].contentWindow[param.callBack](data);
                                return;
                            }
                            parent[param.callBack](data);
                        },
                        "close": function () {

                            if (param.modalName) {
                                eval("parent." + param.modalName + ".close()");
                                return;
                            }
                            parent.modal.close();
                        }
                    });
                }
            });
        </script>
    </jsp:attribute>
    <jsp:body>
        <style>
            .selected {
                background-color: #32b4dc;
            }

            .tdcl {
                width: 42px;
                height: 42px;
                text-align: center;
                font-size: 12px;
                user-select:none;
            }

            .tdcldiv{
                width:38px;
                height:38px;
                min-height:38px;
                margin:2px;
                background:#f0f0f0;
                border-radius: 2px 2px 2px 2px;
                line-height:38px;
                user-select:none;
            }

            #calendar {
                border: none;
            }
        </style>

        <ax:split-layout name="ax1" orientation="horizontal">
            <ax:split-panel width="*" height="*">
                <table id="calendar" border="0" align="center">
                    <tr><!-- label은 마우스로 클릭을 편하게 해줌 -->
                        <!--<td onclick="prevCalendar()"><label></label></td>-->
                        <td align="center" id="tbCalendarYM" colspan="7">
                            yyyy년 m월
                        </td>
                        <!--<td onclick="nextCalendar()"><label></label></td>-->
                    </tr>
                    <tr>
                        <td align="center" class="tdcl"><font color="#c78b81">일</td>
                        <td align="center" class="tdcl"><font color="#6d6e70">월</td>
                        <td align="center" class="tdcl"><font color="#6d6e70">화</td>
                        <td align="center" class="tdcl"><font color="#6d6e70">수</td>
                        <td align="center" class="tdcl"><font color="#6d6e70">목</td>
                        <td align="center" class="tdcl"><font color="#6d6e70">금</td>
                        <td align="center" class="tdcl"><font color="#32b4dc">토</td>
                    </tr>
                </table>
            </ax:split-panel>
            <ax:split-panel width="*" height="50">
                <div align="center">
                    <button type="button" class="btn btn-info" data-page-btn="select" style="width:80px;">선택</button>
                    <button type="button" class="btn btn-info" data-page-btn="close" style="width:80px;">닫기</button>
                </div>
            </ax:split-panel>
        </ax:split-layout>
    </jsp:body>
</ax:layout>


