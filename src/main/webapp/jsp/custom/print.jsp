<%@ page import="com.chequer.axboot.core.utils.MessageUtils" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>

<ax:set key="title" value="결의서"/>
<ax:set key="page_desc" value="${pageRemark}"/>
<ax:set key="page_auto_height" value="true"/>


<ax:layout name="base">
    <jsp:attribute name="script">


        <ax:script-lang key="ax.script"/>

        <style>
            .red {
                background: #f8d2cb !important;
            }

            .sales_table {
                width: 100%;
            }

            .sales_td {
                display: table-cell;

                height: 50px;
                padding: 7px;
                vertical-align: middle;
                text-align: center;
                background: #f6f6f6;
                letter-spacing: -1px;
                color: #222;
                line-height: 12px;
                font-weight: bold;
                border: 1px solid #4b525a;
                font-size: 15px;
                color: #363636;
            }

            .sales_input_left {
                display: table-cell;
                width: 100px;
                padding: 7px;
                vertical-align: middle;
                text-align: left;
                background: #ffffff;
                line-height: 12px;
                border: 1px solid #4b525a;
                font-size: 14px;
                color: #363636;
            }

            .sales_footer_right {
                display: table-cell;
                width: 100px;
                padding: 7px;
                vertical-align: middle;
                text-align: right;
                background: #FCE9E3;
                line-height: 12px;
                border: 1px solid #4b525a;
                font-weight: bold;
                font-size: 14px;
                color: #363636;
            }

            .sales_footer {
                display: table-cell;
                width: 100px;
                padding: 7px;
                vertical-align: middle;
                text-align: center;
                background: #FCE9E3;
                line-height: 12px;
                border: 1px solid #4b525a;
                font-weight: bold;
                font-size: 14px;
                color: #363636;
            }

            .sales_input_right {
                display: table-cell;
                width: 100px;
                padding: 7px;
                vertical-align: middle;
                text-align: right;
                background: #ffffff;
                line-height: 12px;
                border: 1px solid #4b525a;
                font-size: 14px;
                color: #363636;
            }

            .sales_input {
                display: table-cell;
                width: 100px;
                padding: 7px;
                vertical-align: middle;
                text-align: center;
                background: #ffffff;
                line-height: 12px;
                border: 1px solid #4b525a;
                font-size: 14px;
                color: #363636;
            }

            .binder_tb {
                border-collapse: separate;
                border-spacing: 0;
                text-align: left;
                line-height: 1.5;
                border-top: 1px solid #ccc;
                border-left: 1px solid #ccc;
                margin-top: 20px;
            }

            #binder_td {
                text-align: center;
                width: 100px;
                padding: 10px;
                vertical-align: top;
                border-right: 1px solid #ccc;
                border-bottom: 1px solid #ccc;
            }

            #binder_td2 {
                text-align: center;
                width: 100px;
                padding: 10px;
                vertical-align: top;
            }

            .binder {
                width: 121px;
                border: none;
                text-align: center;
            }

            table th {
                width: 100px;
                padding: 10px;
                font-weight: bold;
                vertical-align: middle;
                border-right: 1px solid #ccc;
                border-bottom: 1px solid #ccc;
                border-top: 1px solid #fff;
                border-left: 1px solid #fff;
                background: #eee;
                text-align: center;
            }

            #Resolution_td {
                width: 350px;
                padding: 10px;
                vertical-align: middle;
                border-right: 1px solid #ccc;
                border-bottom: 1px solid #ccc;
            }

        </style>

        <script type="text/javascript">
            var param = ax5.util.param(ax5.info.urlUtil().param);
            var FLAG = param.FLAG;          //  1: 매출 / 2: 지출결의
            var NO_DRAFT = param.NO_DRAFT;  //  품의번호
            var GB = param.GB;              //  R: 승인, 반려버튼 비활성화  /   U: 승인, 반려버튼 활성화
            var CD_APPROVE = param.CD_APPROVE;          //  사업팀
            var CD_APPROVE_FI = param.CD_APPROVE_FI;    //  회계팀
            var A_CD_APPROVE = param.A_CD_APPROVE;
            var SEQ = param.SEQ;
            var html2canvasHeight = 0;
            var html2canvasWidth = 0;
            /// INITDATA 파라메터
            var GROUP_NUMBER;
            var resultList = [];
            var myModel = new ax5.ui.binder();

            var fg_taxApproveData = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'CZ_Q0016', true); //  세무구분
            var fnObj = {}, CODE = {};
            var ACTIONS = axboot.actionExtend(fnObj, {
                PAGE_SEARCH: function (caller, act, data) {
                    axboot.ajax({
                        type: "POST",
                        url: ["dmwaiting", "approvelin_agree"],       //  DmwaitingController
                        async: false,
                        data: JSON.stringify({
                            NO_DRAFT: param.NO_DRAFT,
                        }),
                        callback: function (res) {
                            console.log("res : ", res);
                            var SALE_LIST = [];
                            if (res.list.length > 0) {
                                PDF_DATA_LIST = res.list;
                                $("#DT_DRAFT").val(res.list[0].DT_DRAFT.replace(/(\d{4})(\d{2})(\d{2})/, '$1-$2-$3'));
                                $("#DEFT_DRAFT").val(res.list[0].NM_DEPT_DRAFT);
                                $("#DEFT_DRAFT").attr('code', res.list[0].DEPT_DRAFT);
                                $("#USER_DRAFT").attr('code', res.list[0].USER_DRAFT);
                                $("#USER_DRAFT").val(res.list[0].NM_USER_DRAFT);
                                $("#DOC_TITLE").val(res.list[0].DOC_TITLE);
                                $("#NO_DRAFT").val(res.list[0].NO_DRAFT);

                                var cd_approve = [];
                                var cd_approve_fi = [];
                                for (var i = 0; i < res.list.length; i++) {
                                    var data = res.list[i];
                                    if (data.CD_SETTLE_KIND == '01') {
                                        cd_approve.push(data);
                                    } else if (data.CD_SETTLE_KIND == '02') {
                                        cd_approve_fi.push(data);
                                    }
                                }

                                if (cd_approve.length > 0) {
                                    ACTIONS.dispatch(ACTIONS.CREATE_TABLE, cd_approve);
                                }
                                /*else {
                                    $("#binder_tb").remove();
                                }*/
                                if (cd_approve_fi.length > 0) {
                                    ACTIONS.dispatch(ACTIONS.CREATE_TABLE, cd_approve_fi);
                                }
                                /*else {
                                    $("#binder_tb").remove();
                                }*/

                                /* 최웅석 20200624 전표별 결재양식 표현을 위해 수정
                                axboot.ajax({
                                    type: "POST",
                                    url: ["dmwaiting", "selectRequest"],
                                    data: JSON.stringify({
                                        NO_DRAFT: NO_DRAFT,
                                        GROUP_NUMBER: res.list[0].GROUP_NUMBER
                                    }),
                                    async: false,
                                    callback: function (result) {
                                        if (result.list.length > 0) {
                                            if (FLAG == '1') {
                                                $("#TP_DOCUMENT").html('매출발행요청');
                                                ACTIONS.dispatch(ACTIONS.CREATE_SALE_PUSAIV, result.list);
                                            } else if (FLAG == '2') {
                                                $("#TP_DOCUMENT").html('전표결재품의');
                                                ACTIONS.dispatch(ACTIONS.CREATE_DOCU, result.list);
                                            }
                                        } else {
                                            $(".sales_table").remove();
                                            $("#Resolution").html("<div style='text-align: center; vertical-align: middle;'><span style='font-size: 20px;'>데이터가 사용자의 임의로 삭제하였습니다.</span></div>");
                                        }
                                    }
                                });
                                */
                                GROUP_NUMBER = res.list[0].GROUP_NUMBER;
                                var nodataFlag = null;
                                var SPLIT_GROUP_NUMBER = res.list[0].GROUP_NUMBER.split('|');
                                PDF_GROUP_NUMBER = res.list[0].GROUP_NUMBER.split('|');
                                SPLIT_GROUP_NUMBER.forEach(function (item, index) {
                                    axboot.ajax({
                                        type: "POST",
                                        url: ["dmwaiting", "selectRequest"],
                                        data: JSON.stringify({
                                            NO_DRAFT: NO_DRAFT,
                                            GROUP_NUMBER: item
                                        }),
                                        async: false,
                                        callback: function (result) {
                                            if (result.list.length > 0) {
                                                resultList = result.list;
                                                nodataFlag = nvl(result.list[0].RESULT, false);
                                                if (FLAG == '1') {
                                                    SALE_LIST = SALE_LIST.concat(result.list)
                                                } else if (FLAG == '2') {
                                                    $("#TP_DOCUMENT").html('전표결재품의');
                                                    ACTIONS.dispatch(ACTIONS.CREATE_DOCU, result.list);
                                                }
                                            } else {
                                                $(".sales_table").remove();
                                                // $("#cdmessage").remove();
                                                // $("#Resolution").html("<div id= 'cdmessage' style='text-align: center; vertical-align: middle;'><span style='font-size: 20px;'>데이터가 사용자의 임의로 삭제하였습니다.</span></div>");
                                            }
                                        }
                                    });
                                });
                                if (FLAG == '1') {
                                    $("#TP_DOCUMENT").html('매출발행요청');
                                    ACTIONS.dispatch(ACTIONS.CREATE_SALE_PUSAIV, SALE_LIST);
                                }

                                if (nodataFlag == 'NO_DATA') {
                                    $("#cdmessage").remove();
                                    $("#Resolution").html("<div id= 'cdmessage' style='text-align: center; vertical-align: middle;'><span style='font-size: 20px;'>데이터가 사용자의 임의로 삭제하였습니다.</span></div>");
                                }
                            }
                        }
                    });
                },
                CREATE_TABLE: function (caller, act, data) {
                    for (var i = 0; i < data.length; i++) {
                        if (data[i].CD_SETTLE_KIND == '01') {       //  사업
                            var GB_APPROVE_01 = $("#GB_APPROVE_01");
                            var CD_DEPT_01 = $("#CD_DEPT_01");
                            var CD_DUTY_RANK_01 = $("#CD_DUTY_RANK_01");
                            var EMP_DT_01 = $("#EMP_DT_01");

                            if (GB == 'U') {
                                if (data[i].YN_AUTHOR == 'Y' && data[i].SEQ == SEQ) {   //  결재할 SEQ차례, 결재대기함 양식일 때
                                    data[i].NM_GB_APPROVE += " (위임)";
                                    data[i].NM_APPROVE_EMP += " -> " + SCRIPT_SESSION.nmEmp
                                }
                            } else if (GB == 'R') {
                                if (nvl(data[i].FINAL_AUTHORIZER) != '') {
                                    data[i].NM_GB_APPROVE += " (위임)";
                                    data[i].NM_APPROVE_EMP += " -> " + data[i].NM_FINAL_AUTHORIZER;
                                }
                            }

                            if (i == 0) {
                                var GB_APPROVE_html = "<td id='binder_td'><input type='text' id='GB_APPROVE_S' value='결재방법' class='binder' readonly></td>";
                                GB_APPROVE_01.append(GB_APPROVE_html);

                                var CD_DEPT_html = "<td id='binder_td'><input type='text' id='CD_DEPT_S' value='부서' class='binder' readonly></td>";
                                CD_DEPT_01.append(CD_DEPT_html);

                                var CD_DUTY_RANK_html = "<td id='binder_td'><input type='text' id='CD_DUTY_RANK_S' value='직위' class='binder' readonly></td>";
                                CD_DUTY_RANK_01.append(CD_DUTY_RANK_html);

                                var EMP_DT_html = "<td id='binder_td'><table class=''><tr id='CD_APPROVE_EMP_01_S' ></tr><tr id='DT_APPROVE_01_S'></tr></table></td>";
                                EMP_DT_01.append(EMP_DT_html);

                                var CD_APPROVE_EMP_01 = $("#CD_APPROVE_EMP_01_S");
                                var CD_APPROVE_EMP_html = "<td id='binder_td2'><input type='text' id='CD_APPROVE_EMP_S' value='성명' class='binder' readonly></td>";
                                CD_APPROVE_EMP_01.append(CD_APPROVE_EMP_html);

                                var DT_APPROVE_01 = $("#DT_APPROVE_01_S");
                                var DT_APPROVE_html = "<td id='binder_td2'><input type='text' id='DT_APPROVE_S' value='결재날짜' class='binder' readonly></td>";
                                DT_APPROVE_01.append(DT_APPROVE_html);
                            }

                            var GB_APPROVE_html = "<td id='binder_td'><input type='text' id='GB_APPROVE_S' value='" + nvl(data[i].NM_GB_APPROVE, "") + "' class='binder' readonly></td>";
                            GB_APPROVE_01.append(GB_APPROVE_html);

                            var CD_DEPT_html = "<td id='binder_td'><input type='text' id='CD_DEPT" + i + "' value='" + nvl(data[i].NM_DEPT, "") + "' class='binder' readonly></td>";
                            CD_DEPT_01.append(CD_DEPT_html);

                            var CD_DUTY_RANK_html = "<td id='binder_td'><input type='text' id='CD_DUTY_RANK" + i + "' value='" + nvl(data[i].NM_DUTY_RANK, "") + "' class='binder' readonly></td>";
                            CD_DUTY_RANK_01.append(CD_DUTY_RANK_html);

                            var EMP_DT_html = "<td id='binder_td'><table class=''><tr id='CD_APPROVE_EMP_01_" + i + "' ></tr><tr id='DT_APPROVE_01_" + i + "'></tr></table></td>";
                            EMP_DT_01.append(EMP_DT_html);

                            var CD_APPROVE_EMP_01 = $("#CD_APPROVE_EMP_01_" + i);
                            var CD_APPROVE_EMP_html = "<td id='binder_td2'><input type='text' id='CD_APPROVE_EMP" + i + "' value='" + nvl(data[i].NM_APPROVE_EMP, "") + "' class='binder' readonly></td>";
                            CD_APPROVE_EMP_01.append(CD_APPROVE_EMP_html);

                            var DT_APPROVE_01 = $("#DT_APPROVE_01_" + i);
                            var DT_APPROVE_html = "<td id='binder_td2'><input type='text' id='DT_APPROVE" + i + "' value='" + nvl($.changeDataFormat(data[i].DT_APPROVE, 'YYYYMMDD')) + " " + nvl($.changeDataFormat(data[i].DT_RESET)) + "' class='binder' readonly></td>";
                            DT_APPROVE_01.append(DT_APPROVE_html);
                        }
                        if (data[i].CD_SETTLE_KIND == '02') {       //  회계
                            var GB_APPROVE_02 = $("#GB_APPROVE_02");
                            var CD_DEPT_02 = $("#CD_DEPT_02");
                            var CD_DUTY_RANK_02 = $("#CD_DUTY_RANK_02");
                            var EMP_DT_02 = $("#EMP_DT_02");

                            var GB_APPROVE_html = "<td id='binder_td'><input type='text' id='GB_APPROVE" + i + "' value='" + nvl(data[i].NM_GB_APPROVE, "") + "' class='binder' readonly></td>";
                            GB_APPROVE_02.append(GB_APPROVE_html);

                            var CD_DEPT_html = "<td id='binder_td'><input type='text' id='CD_DEPT" + i + "' value='" + nvl(data[i].NM_DEPT, "") + "' class='binder' readonly></td>";
                            CD_DEPT_02.append(CD_DEPT_html);

                            var CD_DUTY_RANK_html = "<td id='binder_td'><input type='text' id='CD_DUTY_RANK" + i + "' value='" + nvl(data[i].NM_DUTY_RANK, "") + "' class='binder' readonly></td>";
                            CD_DUTY_RANK_02.append(CD_DUTY_RANK_html);

                            var EMP_DT_html = "<td id='binder_td'><table class=''><tr id='CD_APPROVE_EMP_02_" + i + "' ></tr><tr id='DT_APPROVE_02_" + i + "'></tr></table></td>";
                            EMP_DT_02.append(EMP_DT_html);

                            var CD_APPROVE_EMP_02 = $("#CD_APPROVE_EMP_02_" + i);
                            var CD_APPROVE_EMP_html = "<td id='binder_td2'><input type='text' id='CD_APPROVE_EMP" + i + "' value='" + nvl(data[i].NM_APPROVE_EMP, "") + "' class='binder' readonly></td>";
                            CD_APPROVE_EMP_02.append(CD_APPROVE_EMP_html);

                            var DT_APPROVE_02 = $("#DT_APPROVE_02_" + i);
                            var DT_APPROVE_html = "<td id='binder_td2'><input type='text' id='DT_APPROVE" + i + "' value='" + nvl($.changeDataFormat(data[i].DT_APPROVE, 'YYYYMMDD')) + " " + nvl($.changeDataFormat(data[i].DT_RESET)) + "' class='binder' readonly></td>";
                            DT_APPROVE_02.append(DT_APPROVE_html);
                        }
                    }
                }
                , CREATE_SALE_PUSAIV: function (caller, act, result) {
                    $("#Resolution_table").remove();

                    var amt = 0;
                    var vat = 0;
                    var amt_tot = 0;
                    for (var i = 0; i < result.length; i++) {
                        var data = result[i];
                        var FG_TAX;
                        for (var z = 0; z < fg_taxApproveData.length; z++) {
                            if (fg_taxApproveData[z].CODE == data.FG_TAX) {
                                FG_TAX = fg_taxApproveData[z].TEXT;
                                break;
                            }
                        }

                        $(".sales_table").append(
                            "<tr>\n" +
                            "<td class=\"sales_input\" style=\"vertical-align: middle;\">" + nvl(FG_TAX) + "</td>\n" +
                            "<td class=\"sales_input\" style=\"vertical-align: middle;\">" + nvl($.changeDataFormat(data.DT_TRANS, 'YYYYMMDD')) + "</td>\n" +
                            "<td class=\"sales_input_left\" style=\"vertical-align: middle;\">" + nvl(data.REMARK) + "</td>\n" +
                            "<td class=\"sales_input_left\" style=\"vertical-align: middle;\">" + nvl(data.LN_PARTNER) + "</td>\n" +
                            "<td class=\"sales_input\" style=\"vertical-align: middle;\">" + nvl($.changeDataFormat(data.NO_COMPANY, 'company')) + "</td>\n" +
                            "<td class=\"sales_input\" style=\"vertical-align: middle;\">" + nvl(data.CD_EMP_PARTNER) + "</td>\n" +
                            "<td class=\"sales_input_left\" style=\"vertical-align: middle;\">" + nvl(data.E_MAIL) + "</td>\n" +
                            "<td class=\"sales_input\" style=\"vertical-align: middle;\">" + nvl($.changeDataFormat(data.NO_HPEMP_PARTNER, 'tel')) + "</td>\n" +
                            "<td class=\"sales_input_right\" style=\"vertical-align: middle;\">" + nvl(comma(data.AMT), '0') + "</td>\n" +
                            "<td class=\"sales_input_right\" style=\"vertical-align: middle;\">" + nvl(comma(data.VAT), '0') + "</td>\n" +
                            "<td class=\"sales_input_right\" style=\"vertical-align: middle;\">" + nvl(comma(data.AMT_TOT), '0') + "</td>\n" +
                            "</tr>"
                        );
                        amt += data.AMT;
                        vat += data.VAT;
                        amt_tot += data.AMT_TOT

                    }
                    $(".sales_table").append(
                        "<tr>\n" +
                        "<td class=\"sales_footer\" style=\"vertical-align: middle;\">합계</td>\n" +
                        "<td class=\"sales_footer\" style=\"vertical-align: middle;\"></td>\n" +
                        "<td class=\"sales_footer\" style=\"vertical-align: middle;\"></td>\n" +
                        "<td class=\"sales_footer\" style=\"vertical-align: middle;\"></td>\n" +
                        "<td class=\"sales_footer\" style=\"vertical-align: middle;\"></td>\n" +
                        "<td class=\"sales_footer\" style=\"vertical-align: middle;\"></td>\n" +
                        "<td class=\"sales_footer\" style=\"vertical-align: middle;\"></td>\n" +
                        "<td class=\"sales_footer\" style=\"vertical-align: middle;\"></td>\n" +
                        "<td class=\"sales_footer_right\" style=\"vertical-align: middle;\">" + comma(amt) + "</td>\n" +
                        "<td class=\"sales_footer_right\" style=\"vertical-align: middle;\">" + comma(vat) + "</td>\n" +
                        "<td class=\"sales_footer_right\" style=\"vertical-align: middle;\">" + comma(amt_tot) + "</td>\n" +
                        "</tr>"
                    )
                }
                // , CREATE_DOCU: function (caller, act, result) {
                //     $(".sales_table").remove();
                //
                //     var sum_cr = 0;
                //     var sum_dr = 0;
                //     var str = "";
                //     for (var i = 0; i < result.length; i++) {
                //         sum_cr += result[i].AMT_CR;
                //         sum_dr += result[i].AMT_DR;
                //         str += "<tr>"
                //             + "<td id='Resolution_td' rowspan='2'>" + (result[i].NM_ACCT != undefined ? result[i].NM_ACCT : '')
                //             + "</td>"
                //             + "<td id='Resolution_td' rowspan='2'>" + (result[i].REMARK != undefined ? result[i].REMARK : '')
                //             + "</td>"
                //             + "<td id='Resolution_td' rowspan='2' style='text-align: right'>" + (result[i].AMT_DR != undefined ? comma(result[i].AMT_DR) : '')
                //             + "</td>"
                //             + "<td id='Resolution_td' rowspan='2' style='text-align: right'>" + (result[i].AMT_CR != undefined ? comma(result[i].AMT_CR) : '')
                //             + "</td>"
                //             + "<td id='Resolution_td'>" + undefinedCheck(result[i].NM_MNG1, result[i].NM_MNGD1) + "</td>"
                //             + "<td id='Resolution_td'>" + undefinedCheck(result[i].NM_MNG2, result[i].NM_MNGD2) + "</td>"
                //             + "<td id='Resolution_td'>" + undefinedCheck(result[i].NM_MNG3, result[i].NM_MNGD3) + "</td>"
                //             + "<td id='Resolution_td'>" + undefinedCheck(result[i].NM_MNG4, result[i].NM_MNGD4) + "</td>"
                //             + "</tr>"
                //             + "<tr>"
                //             + "<td id='Resolution_td'>" + undefinedCheck(result[i].NM_MNG5, result[i].NM_MNGD5) + "</td>"
                //             + "<td id='Resolution_td'>" + undefinedCheck(result[i].NM_MNG6, result[i].NM_MNGD6) + "</td>"
                //             + "<td id='Resolution_td'>" + undefinedCheck(result[i].NM_MNG7, result[i].NM_MNGD7) + "</td>"
                //             + "<td id='Resolution_td'>" + undefinedCheck(result[i].NM_MNG8, result[i].NM_MNGD8) + "</td>"
                //             + "</tr>"
                //     }
                //     $("#Resolution_table").append(str);
                //     str = "";
                //     str += "<tr style='background: #ffff0070;'>"
                //         + "<td id='Resolution_td' colspan='2'> 합계 </td>"
                //         + "<td id='Resolution_td' style='text-align: right'>" + comma(sum_dr)
                //         + "</td>"
                //         + "<td id='Resolution_td' style='text-align: right'>" + comma(sum_cr)
                //         + "</td>"
                //         + "<td id='Resolution_td' colspan='4'></td>"
                //         + "</tr>";
                //     $("#Resolution_table").append(str);
                // }
                , CREATE_DOCU: function (caller, act, result) {
                    $(".sales_table").remove();

                    console.log("result", result);

                    var sum_cr = 0;
                    var sum_dr = 0;
                    var str = "";
                    str += '<div style="margin-top: 5px;">';
                    str += '<label> <span>전표번호 : ';
                    str += nvl(result[0].NO_DOCU);
                    str += '</span> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <span> 회계일자 : ';
                    str += $.changeDataFormat(nvl(result[0].DT_ACCT), 'YYYYMMDD');
                    str += '</span> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <span> 전표적요 : ';
                    str += nvl(result[0].DOCU_REMARK);
                    str += '</span></label>';
                    str += '<table id="Resolution_table">';
                    str += ' <tr><th rowspan="2" style="vertical-align : middle;"> 계정과목 </th>';
                    str += ' <th rowspan="2" style="vertical-align : middle;">적요 </th>';
                    str += ' <th rowspan="2" style="vertical-align : middle;">차변금액 </th>';
                    str += ' <th rowspan="2" style="vertical-align : middle;"> 대변금액 </th>';
                    if (result[0].CD_DOCU == '003' || result[0].TP_GB == '06') {
                        str += ' <th rowspan="2" style="vertical-align : middle;">카드승인일자</th>';
                        str += ' <th rowspan="2" style="vertical-align : middle;">카드승인시간</th>'
                    }
                    str += ' <th>관리항목1</th>';
                    str += ' <th>관리항목2 </th>';
                    str += ' <th> 관리항목3 </th>';
                    str += ' <th> 관리항목4 </th> </tr>';
                    str += ' <tr> <th> 관리항목5 </th>';
                    str += ' <th> 관리항목6 </th>';
                    str += ' <th> 관리항목7 </th> ';
                    str += ' <th> 관리항목8 </th> </tr>';
                    for (var i = 0; i < result.length; i++) {
                        sum_cr += result[i].AMT_CR;
                        sum_dr += result[i].AMT_DR;
                        str += "<tr>";
                        str += "<td id='Resolution_td' rowspan='2'>";
                        str += (result[i].NM_ACCT != undefined ? result[i].NM_ACCT : '');
                        str += "</td>";
                        str += "<td id='Resolution_td' rowspan='2'>";
                        str += (result[i].REMARK != undefined ? result[i].REMARK : '');
                        str += "</td>";
                        str += "<td id='Resolution_td' rowspan='2' style='text-align: right'>";
                        str += (result[i].AMT_DR != undefined ? comma(result[i].AMT_DR) : '');
                        str += "</td>";
                        str += "<td id='Resolution_td' rowspan='2' style='text-align: right'>";
                        str += (result[i].AMT_CR != undefined ? comma(result[i].AMT_CR) : '');
                        str += "</td>";
                        if (result[0].CD_DOCU == '003' || result[0].TP_GB == '06') {
                            str += "<td id='Resolution_td' rowspan='2'>";
                            str += $.changeDataFormat(nvl(result[i].BC_TRADE_DATE), 'YYYYMMDD');
                            str += "</td>";
                            str += "<td id='Resolution_td' rowspan='2'>";
                            str += $.changeDataFormat(nvl(result[i].BC_TRADE_TIME), 'time');
                            str += "</td>"
                        }
                        str += "<td id='Resolution_td'>";
                        str += undefinedCheck(result[i].NM_MNG1, result[i].NM_MNGD1);
                        str += "</td>";
                        str += "<td id='Resolution_td'>";
                        str += undefinedCheck(result[i].NM_MNG2, result[i].NM_MNGD2);
                        str += "</td>";
                        str += "<td id='Resolution_td'>";
                        str += undefinedCheck(result[i].NM_MNG3, result[i].NM_MNGD3);
                        str += "</td>";
                        str += "<td id='Resolution_td'>";
                        str += undefinedCheck(result[i].NM_MNG4, result[i].NM_MNGD4);
                        str += "</td>";
                        str += "</tr>";
                        str += "<tr>";
                        str += "<td id='Resolution_td'>";
                        str += undefinedCheck(result[i].NM_MNG5, result[i].NM_MNGD5);
                        str += "</td>";
                        str += "<td id='Resolution_td'>";
                        str += undefinedCheck(result[i].NM_MNG6, result[i].NM_MNGD6);
                        str += "</td>";
                        str += "<td id='Resolution_td'>";
                        str += undefinedCheck(result[i].NM_MNG7, result[i].NM_MNGD7);
                        str += "</td>";
                        str += "<td id='Resolution_td'>";
                        str += undefinedCheck(result[i].NM_MNG8, result[i].NM_MNGD8);
                        str += "</td>";
                        str += "</tr>"
                    }

                    str += "<tr style='background: #ffff0070;'>";
                    str += "<td id='Resolution_td' colspan='2'> 합계 </td>";
                    str += "<td id='Resolution_td' style='text-align: right'>";
                    str += comma(sum_dr);
                    str += "</td>";
                    str += "<td id='Resolution_td' style='text-align: right'>";
                    str += comma(sum_cr);
                    str += "</td>";
                    if (result[0].CD_DOCU == '003' || result[0].TP_GB == '06') {
                        str += "<td id='Resolution_td' colspan='6'></td>"
                    } else {
                        str += "<td id='Resolution_td' colspan='4'></td>"
                    }
                    str += "</tr>";
                    str += '</table>';
                    str += '</div>';
                    $("#Resolution").append(str);
                }
            });

            // fnObj 기본 함수 스타트와 리사이즈
            fnObj.pageStart = function () {
                ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);

                html2canvasHeight = $(".ax-base-title").height() + $("#kind01_div").height() + $("#kind02_div").height() + $("#Resolution").height() + $(".ax-base-title").height() + 50 + ( 5 * resultList.length );
                html2canvasWidth = 1450;
                var doc = new jsPDF('p', 'mm', 'a4');
                setTimeout(function () {
                    //var myOffscreenEl = document.getElementById('ax-base-root');
                    var myOffscreenEl = document.body;
                    html2canvas(myOffscreenEl,{}).then(function(canvas) {
                        var imgData = canvas.toDataURL('image/png');

                        var imgWidth = 210;
                        var pageHeight = imgWidth * 1.414;  // 출력 페이지 세로 길이 계산 A4 기준
                        var imgHeight = canvas.height * imgWidth / canvas.width;
                        var heightLeft = imgHeight;
                        var position = 0;

                        doc.addImage(imgData, 'PNG', 0, position, imgWidth, imgHeight);
                        heightLeft -= pageHeight;

                        while (heightLeft >= 0) {
                            position = heightLeft - imgHeight;
                            doc.addPage();
                            doc.addImage(imgData, 'PNG', 0, position, imgWidth, imgHeight);
                            heightLeft -= pageHeight;
                        }
                        parent[param.callBack](doc);

                    })
                }, 1000);
            };

            function undefinedCheck(param1, param2) {
                var str = nvl(param1) == '' ? '' : param1;
                var str2 = nvl(param2) == '' ? '' : " : " + param2;
                var result;
                if (nvl(param1) == '' && nvl(param2) == '') {
                    result = "&nbsp;&nbsp;";
                } else {
                    result = str + str2
                }
                return result;
            }
        </script>
        <style>
            #ax-base-root {
                padding : 50px !important;
            }


            /*.html2canvas-container {height: 10000px }*/
        </style>
    </jsp:attribute>
    <jsp:body>
        <div id="myOffscreenEl">
        <div class="H10"></div>
            <!-- 목록 -->
                    <ax:form name="binder_form">
                        <ax:tbl clazz="ax-search-tb2" minWidth="900px">
                            <ax:tr>
                                <ax:td label='문서번호' width="300px">
                                    <div class="input-group">
                                        <input type="text" class="form-control" name="NO_DRAFT" id="NO_DRAFT" readonly/>
                                    </div>
                                </ax:td>
                                <ax:td label='기안일자' width="300px">
                                    <div class="input-group" data-ax5picker="basic">
                                        <input type="text" class="form-control" placeholder="yyyy-mm-dd" id="DT_DRAFT"
                                               readonly>
                                        <span class="input-group-addon"><i class="cqc-calendar"></i></span>
                                    </div>
                                </ax:td>
                                <ax:td label='기안팀' width="300px">
                                    <div class="input-group">
                                        <input type="text" class="form-control" name="DEFT_DRAFT" id="DEFT_DRAFT"
                                               readonly/>
                                    </div>
                                </ax:td>
                                <ax:td label='기안자' width="300px">
                                    <div class="input-group">
                                        <input type="text" class="form-control" name="USER_DRAFT" id="USER_DRAFT"
                                               readonly/>
                                    </div>
                                </ax:td>
                            </ax:tr>
                            <ax:tr>
                                <ax:td label='문서제목' width="900px">
                                    <input type="text" style="width:867px;" class="form-control" name="DOC_TITLE"
                                           id="DOC_TITLE" readonly>
                                </ax:td>
                            </ax:tr>
                            <ax:tr>
                                <ax:td label='첨부파일' width="900px">
                                    <filemodal id="FILE" MODE="2" WIDTH="841px" BOARD_TYPE="DRAFT" HEIGHT="30px"
                                               DISABLED="true" READONLY/>
                                </ax:td>
                            </ax:tr>
                        </ax:tbl>
                        <div style="overflow: hidden; margin-bottom: 15px;" id="kind01_div">
                            <div style="width:100%; height: 300px; float: left;" id="CD_SETTLE_KIND01_DIV">
                                <div style="margin-top: 10px; height: 300px;">
                                    <h2>
                                        <i class="icon_list"></i> 사업부결재라인
                                    </h2>
                                    <div style="overflow-y: hidden; min-height: 260px; height: 260px; margin-top: 8px; border-top: 1px solid #a9a9a9; border-bottom: 1px solid #a9a9a9;">
                                        <table class="binder_tb">
                                            <tr id="GB_APPROVE_01">

                                            </tr>
                                            <tr id="CD_DEPT_01">

                                            </tr>
                                            <tr id="CD_DUTY_RANK_01">

                                            </tr>
                                            <tr id="EMP_DT_01">

                                            </tr>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div style="overflow: hidden; margin-bottom: 15px;"  id=" id="kind02_div">
                            <div style="width:100%; height: 300px;" id="CD_SETTLE_KIND02_DIV">
                                <div style="margin-top: 10px; height: 300px;">
                                    <h2>
                                        <i class="icon_list"></i> 회계팀결재라인
                                    </h2>
                                    <div style="overflow-y: hidden; min-height: 260px; height: 260px; margin-top: 8px; border-top: 1px solid #a9a9a9; border-bottom: 1px solid #a9a9a9;">
                                        <table class="binder_tb">
                                            <tr id="GB_APPROVE_02">

                                            </tr>
                                            <tr id="CD_DEPT_02">

                                            </tr>
                                            <tr id="CD_DUTY_RANK_02">

                                            </tr>
                                            <tr id="EMP_DT_02">

                                            </tr>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div style="display: none;" data-ax5grid="grid-view-01"
                             data-ax5grid-config="{  showLineNumber: true,showRowSelector: false, multipleSelect: false,lineNumberColumnWidth: 40,rowSelectorColumnWidth: 27, }"
                             id="top_grid"
                        ></div>
                        <div style="display: none;" data-ax5grid="grid-view-02"
                             data-ax5grid-config="{  showLineNumber: true,showRowSelector: false, multipleSelect: false,lineNumberColumnWidth: 40,rowSelectorColumnWidth: 27, }"
                             id="top_grid"
                        ></div>
                        <div class="ax-base-title" role="page-title" align="center">
                            <h1 class="title"><i class="cqc-browser"></i><span id="TP_DOCUMENT"></span></h1>
                            <p class="desc"></p>
                        </div>
                        <table class="sales_table">
                            <tr>
                                <td class="sales_td" rowspan="2" style="vertical-align: middle;">구분코드명</td>
                                <td class="sales_td" rowspan="2" style="vertical-align: middle;">발행일자</td>
                                <td class="sales_td" rowspan="2" style="vertical-align: middle;">적요</td>
                                <td class="sales_td" colspan="5" style="vertical-align: middle;">업체정보</td>
                                <td class="sales_td" rowspan="2" style="vertical-align: middle;">공급가액</td>
                                <td class="sales_td" rowspan="2" style="vertical-align: middle;">세액</td>
                                <td class="sales_td" rowspan="2" style="vertical-align: middle;">합계
                                </td>
                            </tr>
                            <tr>
                                <td class="sales_td" style="vertical-align: middle;">거래처</td>
                                <td class="sales_td" style="vertical-align: middle;">사업자번호</td>
                                <td class="sales_td" style="vertical-align: middle;">담당자</td>
                                <td class="sales_td" style="vertical-align: middle;">이메일</td>
                                <td class="sales_td" style="vertical-align: middle;">연락처</td>
                            </tr>

                        </table>

                        <div id="Resolution">
                                <%--                        <table id="Resolution_table">--%>
                                <%--                            <tr>--%>
                                <%--                                <th rowspan="2" style="vertical-align : middle;">--%>
                                <%--                                    계정과목--%>
                                <%--                                </th>--%>
                                <%--                                <th rowspan="2" style="vertical-align : middle;">--%>
                                <%--                                    적요--%>
                                <%--                                </th>--%>
                                <%--                                <th rowspan="2" style="vertical-align : middle;">--%>
                                <%--                                    차변금액--%>
                                <%--                                </th>--%>
                                <%--                                <th rowspan="2" style="vertical-align : middle;">--%>
                                <%--                                    대변금액--%>
                                <%--                                </th>--%>
                                <%--                                <th>--%>
                                <%--                                    관리항목1--%>
                                <%--                                </th>--%>
                                <%--                                <th>--%>
                                <%--                                    관리항목2--%>
                                <%--                                </th>--%>
                                <%--                                <th>--%>
                                <%--                                    관리항목3--%>
                                <%--                                </th>--%>
                                <%--                                <th>--%>
                                <%--                                    관리항목4--%>
                                <%--                                </th>--%>
                                <%--                            </tr>--%>
                                <%--                            <tr>--%>
                                <%--                                <th>--%>
                                <%--                                    관리항목5--%>
                                <%--                                </th>--%>
                                <%--                                <th>--%>
                                <%--                                    관리항목6--%>
                                <%--                                </th>--%>
                                <%--                                <th>--%>
                                <%--                                    관리항목7--%>
                                <%--                                </th>--%>
                                <%--                                <th>--%>
                                <%--                                    관리항목8--%>
                                <%--                                </th>--%>
                                <%--                            </tr>--%>
                                <%--                        </table>--%>
                        </div>

                    </ax:form>
        </div>
    </jsp:body>
</ax:layout>