<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>

<ax:set key="title" value="관리항목"/>
<ax:set key="page_desc" value="${PAGE_REMARK}"/>
<ax:set key="page_auto_height" value="true"/>

<ax:layout name="base">
    <jsp:attribute name="script">

        <script type="text/javascript">

            var initData = parent.modal.modalConfig.sendData().initData;        //  관리항목값들 this.item

            var disabledYn = parent.modal.modalConfig.sendData().disabledYn;    //  전표처리여부 Y: 전표처리
                                                                                // N: 전표미처리

            if (nvl(disabledYn) != '') {
                if (disabledYn == 'Y') {
                    $("#BtnSave").attr('disabled', true);
                } else {
                    $("#BtnSave").attr('disabled', false);
                }
            }

            var dialog = new ax5.ui.dialog();
            var param = ax5.util.param(ax5.info.urlUtil().param);
            var fnObj = {};

            var ACTIONS = axboot.actionExtend(fnObj, {
                PAGE_CLOSE: function (caller, act, data) {
                    parent.modal.close();
                },

                ITEM_SAVE: function (caller, act, data) {
                    var list = [];
                    for (var i = 1; i <= 8; i++) {
                        var chkVal;
                        if ($("#a" + i).attr("code")) {
                            $("#a" + i).attr("code", $("#a" + i).attr("code"));
                        }
                        if ($("#a" + i).attr("text")) {
                            $("#a" + i).attr("text", $("#a" + i).val());
                        }
                        if (nvl($("#a" + i).attr("class")).indexOf("required") > -1) { //필수값 체크
                            if (!$("#a" + i).attr("code") && !$("#a" + i).val()) {
                                chkVal = true;
                            }
                        }

                        if (chkVal) {
                            dialog.alert({
                                theme: "danger",
                                title: "에러",
                                msg: "필수값이 누락되었습니다.",
                                onStateChanged: function () {
                                    if (this.state === "open") {
                                        mask.open({theme: "danger"});
                                    } else if (this.state === "close") {
                                        mask.close();
                                    }
                                }
                            });
                            return;
                        }

                        var map = new Map();
                        map.set("cd_mngd", nvl($("#a" + i).attr("code")));
                        map.set("nm_mngd", nvl($("#a" + i).attr("text")));
                        map.set("cd_mng", nvl($("#a" + i).attr("cd-mng")));
                        map.set("nm_mng", nvl($("#a" + i).attr("nm-mng")));
                        list.push(map);

                    }


                    parent[param.callBack](list);
                    parent.modal.close();
                }
            });

            fnObj.pageStart = function () {
                fnObj.pageButtonView.initView();

                fnObj.loadMngd();
            };

            fnObj.loadMngd = function () {
                var data_fg_tax;


                if (param.cdDocu == "001" || param.cdDocu == "002" || param.cdDocu == "003" || param.cdDocu == "004" || param.cdDocu == "006") {
                    data_fg_tax = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'CZ_Q0015', false);
                } else if (param.cdDocu == "005" || param.cdDocu == "007") {
                    data_fg_tax = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'CZ_Q0016', false);
                }

                axboot.ajax({
                    type: "POST",
                    async: false,
                    url: ["gldocum", "getMngd"],
                    data: JSON.stringify({
                        CD_ACCT: param.cdAcct
                    }),
                    callback: function (res) {

                        for (var i = 1; i <= 8; i++) {


                            var required = "";
                            var mark = "";
                            var st_mng = eval("res.map.ST_MNG" + i).toUpperCase();
                            if (st_mng == "A" || st_mng == "C" || st_mng == "D") {
                                required = "required";
                                mark = "*"
                            }


                            $("div [data-ax-td-label='mng" + i + "']").html(nvl(eval("res.map.NM_MNG" + i)) + " " + mark);

                            if (nvl(eval("res.map.NM_MNG" + i)) == ''){
                                continue;
                            }

                            switch (eval("res.map.CD_MNG" + i)) {
                                case "A01":			//귀속사업장
                                    $("div [data-ax-td-label='mng" + i + "']").next().html('<div class="input-group"><input type="text" class="form-control ' + required + '" id="a' + i + '" cd-mng="' + eval("res.map.CD_MNG" + i) + '" nm-mng="' + eval("res.map.NM_MNG" + i) + '" text="' + eval("nvl(initData.NM_MNGD" + i + ", '')") + '" code="' + eval("nvl(initData.CD_MNGD" + i + ", '')") + '" value="' + eval("nvl(initData.NM_MNGD" + i + ", '')") + '"><span class="input-group-addon"><i class="cqc-magnifier" style="cursor: pointer" onclick="openPopup(\'bizarea\' ,\'a' + i + '\',\'' + eval("res.map.CD_MNG" + i) + '\')"></i></span></div>');
                                    break;
                                case "A02":			//코스트센타
                                    $("div [data-ax-td-label='mng" + i + "']").next().html('<div class="input-group"><input type="text" class="form-control ' + required + '" id="a' + i + '" cd-mng="' + eval("res.map.CD_MNG" + i) + '" nm-mng="' + eval("res.map.NM_MNG" + i) + '" text="' + eval("nvl(initData.NM_MNGD" + i + ", '')") + '" code="' + eval("nvl(initData.CD_MNGD" + i + ", '')") + '" value="' + eval("nvl(initData.NM_MNGD" + i + ", '')") + '"><span class="input-group-addon"><i class="cqc-magnifier" style="cursor: pointer" onclick="openPopup(\'cc\' ,\'a' + i + '\',\'' + eval("res.map.CD_MNG" + i) + '\')"></i></span></div>');
                                    break;
                                case "A03":			//부서
                                    $("div [data-ax-td-label='mng" + i + "']").next().html('<div class="input-group"><input type="text" class="form-control ' + required + '" id="a' + i + '" cd-mng="' + eval("res.map.CD_MNG" + i) + '" nm-mng="' + eval("res.map.NM_MNG" + i) + '" text="' + eval("nvl(initData.NM_MNGD" + i + ", '')") + '" code="' + eval("nvl(initData.CD_MNGD" + i + ", '')") + '" value="' + eval("nvl(initData.NM_MNGD" + i + ", '')") + '"><span class="input-group-addon"><i class="cqc-magnifier" style="cursor: pointer" onclick="openPopup(\'dept\' ,\'a' + i + '\',\'' + eval("res.map.CD_MNG" + i) + '\')"></i></span></div>');
                                    break;
                                case "A04":				//사원
                                    $("div [data-ax-td-label='mng" + i + "']").next().html('<div class="input-group"><input type="text" class="form-control ' + required + '" id="a' + i + '" cd-mng="' + eval("res.map.CD_MNG" + i) + '" nm-mng="' + eval("res.map.NM_MNG" + i) + '" text="' + eval("nvl(initData.NM_MNGD" + i + ", '')") + '" code="' + eval("nvl(initData.CD_MNGD" + i + ", '')") + '" value="' + eval("nvl(initData.NM_MNGD" + i + ", '')") + '"><span class="input-group-addon"><i class="cqc-magnifier" style="cursor: pointer" onclick="openPopup(\'emp\' ,\'a' + i + '\',\'' + eval("res.map.CD_MNG" + i) + '\')"></i></span></div>');
                                    break;
                                case "A05":				//프로젝트
                                    $("div [data-ax-td-label='mng" + i + "']").next().html('<div class="input-group"><input type="text" class="form-control ' + required + '" id="a' + i + '" cd-mng="' + eval("res.map.CD_MNG" + i) + '" nm-mng="' + eval("res.map.NM_MNG" + i) + '" text="' + eval("nvl(initData.NM_MNGD" + i + ", '')") + '" code="' + eval("nvl(initData.CD_MNGD" + i + ", '')") + '" value="' + eval("nvl(initData.NM_MNGD" + i + ", '')") + '"><span class="input-group-addon"><i class="cqc-magnifier" style="cursor: pointer" onclick="openPopup(\'project\' ,\'a' + i + '\',\'' + eval("res.map.CD_MNG" + i) + '\')"></i></span></div>');
                                    break;
                                case "A06":				//거래처
                                    $("div [data-ax-td-label='mng" + i + "']").next().html('<div class="input-group"><input type="text" class="form-control ' + required + '" id="a' + i + '" cd-mng="' + eval("res.map.CD_MNG" + i) + '" nm-mng="' + eval("res.map.NM_MNG" + i) + '" text="' + eval("nvl(initData.NM_MNGD" + i + ", '')") + '" code="' + eval("nvl(initData.CD_MNGD" + i + ", '')") + '" VALUE="' + eval("nvl(initData.NM_MNGD" + i + ", '')") + '"><span class="input-group-addon"><i class="cqc-magnifier" style="cursor: pointer" onclick="openPopup(\'partner\' ,\'a' + i + '\',\'' + eval("res.map.CD_MNG" + i) + '\')"></i></span></div>');
                                    break;
                                case "A07":				//예적금계좌
                                    $("div [data-ax-td-label='mng" + i + "']").next().html('<div class="input-group"><input type="text" class="form-control ' + required + '" id="a' + i + '" cd-mng="' + eval("res.map.CD_MNG" + i) + '" nm-mng="' + eval("res.map.NM_MNG" + i) + '" text="' + eval("nvl(initData.NM_MNGD" + i + ", '')") + '" code="' + eval("nvl(initData.CD_MNGD" + i + ", '')") + '" VALUE="' + eval("nvl(initData.NM_MNGD" + i + ", '')") + '"><span class="input-group-addon"><i class="cqc-magnifier" style="cursor: pointer" onclick="openPopup(\'deposit\' ,\'a' + i + '\',\'' + eval("res.map.CD_MNG" + i) + '\')"></i></span></div>');
                                    break;
                                case "A08":				//신용카드
                                    $("div [data-ax-td-label='mng" + i + "']").next().html('<div class="input-group"><input type="text" class="form-control ' + required + '" id="a' + i + '" cd-mng="' + eval("res.map.CD_MNG" + i) + '" nm-mng="' + eval("res.map.NM_MNG" + i) + '" text="' + eval("nvl(initData.NM_MNGD" + i + ", '')") + '" code="' + eval("nvl(initData.CD_MNGD" + i + ", '')") + '" VALUE="' + eval("nvl(initData.NM_MNGD" + i + ", '')") + '"><span class="input-group-addon"><i class="cqc-magnifier" style="cursor: pointer" onclick="openPopup(\'card\' ,\'a' + i + '\',\'' + eval("res.map.CD_MNG" + i) + '\')"></i></span></div>');
                                    break;
                                case "A09":				//금융기관
                                    $("div [data-ax-td-label='mng" + i + "']").next().html('<div class="input-group"><input type="text" class="form-control ' + required + '" id="a' + i + '" cd-mng="' + eval("res.map.CD_MNG" + i) + '" nm-mng="' + eval("res.map.NM_MNG" + i) + '" text="' + eval("nvl(initData.NM_MNGD" + i + ", '')") + '" code="' + eval("nvl(initData.CD_MNGD" + i + ", '')") + '" VALUE="' + eval("nvl(initData.NM_MNGD" + i + ", '')") + '"><span class="input-group-addon"><i class="cqc-magnifier" style="cursor: pointer" onclick="openPopup(\'bank\' ,\'a' + i + '\',\'' + eval("res.map.CD_MNG" + i) + '\')"></i></span></div>');
                                    break;
                                case "B01":				//자산관리번호
                                    $("div [data-ax-td-label='mng" + i + "']").next().html('<div class="input-group"><input type="text" class="form-control ' + required + '" id="a' + i + '" cd-mng="' + eval("res.map.CD_MNG" + i) + '" nm-mng="' + eval("res.map.NM_MNG" + i) + '" text="' + eval("nvl(initData.NM_MNGD" + i + ", '')") + '" code="' + eval("nvl(initData.CD_MNGD" + i + ", '')") + '" VALUE="' + eval("nvl(initData.NM_MNGD" + i + ", '')") + '"><span class="input-group-addon"><i class="cqc-magnifier" style="cursor: pointer" onclick="openPopup(\'assetMngdNo\' ,\'a' + i + '\',\'' + eval("res.map.CD_MNG" + i) + '\')"></i></span></div>');
                                    break;
                                case "B02":				//받을어음NO
                                    $("div [data-ax-td-label='mng" + i + "']").next().html('<div class="input-group"><input type="text" class="form-control ' + required + '" id="a' + i + '" cd-mng="' + eval("res.map.CD_MNG" + i) + '" nm-mng="' + eval("res.map.NM_MNG" + i) + '" text="' + eval("nvl(initData.NM_MNGD" + i + ", '')") + '" code="' + eval("nvl(initData.CD_MNGD" + i + ", '')") + '" VALUE="' + eval("nvl(initData.NM_MNGD" + i + ", '')") + '"><span class="input-group-addon"><i class="cqc-magnifier" style="cursor: pointer" onclick="openPopup(\'takeBillrec\' ,\'a' + i + '\',\'' + eval("res.map.CD_MNG" + i) + '\')"></i></span></div>');
                                    break;
                                case "B11":				//자산처리구분
                                    $("div [data-ax-td-label='mng" + i + "']").next().html('<div class="input-group"><input type="text" class="form-control ' + required + '" id="a' + i + '" cd-mng="' + eval("res.map.CD_MNG" + i) + '" nm-mng="' + eval("res.map.NM_MNG" + i) + '" text="' + eval("nvl(initData.NM_MNGD" + i + ", '')") + '" code="' + eval("nvl(initData.CD_MNGD" + i + ", '')") + '" VALUE="' + eval("nvl(initData.NM_MNGD" + i + ", '')") + '"><span class="input-group-addon"><i class="cqc-magnifier" style="cursor: pointer" onclick="openPopup(\'assetProcGb\' ,\'a' + i + '\',\'' + eval("res.map.CD_MNG" + i) + '\')"></i></span></div>');
                                    break;
                                case "B12":				//받을어음정리구분
                                    $("div [data-ax-td-label='mng" + i + "']").next().html('<div class="input-group"><input type="text" class="form-control ' + required + '" id="a' + i + '" style="width:184px;"></div>');
                                    break;
                                case "B21":				//발생일자
                                    $("div [data-ax-td-label='mng" + i + "']").next().html('<div class="input-group"><input type="text" class="form-control ' + required + '" id="a' + i + '" cd-mng="' + eval("res.map.CD_MNG" + i) + '" nm-mng="' + eval("res.map.NM_MNG" + i) + '" text="' + eval("nvl(initData.NM_MNGD" + i + ", '')") + '" code="' + eval("nvl(initData.CD_MNGD" + i + ", '')") + '" VALUE="' + $.changeDataFormat(eval("nvl(initData.NM_MNGD" + i + ", '')"), 'YYYYMMDD') + '"><span class="input-group-addon"><i class="cqc-magnifier" style="cursor: pointer" onclick="openCalender(\'calender\' ,\'a' + i + '\',\'' + eval("res.map.CD_MNG" + i) + '\')"></i></span></div>');
                                    break;
                                case "B23":				//만기일자
                                    $("div [data-ax-td-label='mng" + i + "']").next().html('<div class="input-group"><input type="text" class="form-control ' + required + '" id="a' + i + '" cd-mng="' + eval("res.map.CD_MNG" + i) + '" nm-mng="' + eval("res.map.NM_MNG" + i) + '" text="' + eval("nvl(initData.NM_MNGD" + i + ", '')") + '" code="' + eval("nvl(initData.CD_MNGD" + i + ", '')") + '" VALUE="' + $.changeDataFormat(eval("nvl(initData.NM_MNGD" + i + ", '')"), 'YYYYMMDD') + '"><span class="input-group-addon"><i class="cqc-magnifier" style="cursor: pointer" onclick="openCalender(\'calender\' ,\'a' + i + '\',\'' + eval("res.map.CD_MNG" + i) + '\')"></i></span></div>');
                                    break;
                                case "B24":				//환종
                                    $("div [data-ax-td-label='mng" + i + "']").next().html('<div class="input-group"><input type="text" class="form-control ' + required + '" id="a' + i + '" cd-mng="' + eval("res.map.CD_MNG" + i) + '" nm-mng="' + eval("res.map.NM_MNG" + i) + '" text="' + eval("nvl(initData.NM_MNGD" + i + ", '')") + '" code="' + eval("nvl(initData.CD_MNGD" + i + ", '')") + '" VALUE="' + eval("nvl(initData.NM_MNGD" + i + ", '')") + '"><span class="input-group-addon"><i class="cqc-magnifier" style="cursor: pointer" onclick="openPopup(\'anticipation\' ,\'a' + i + '\',\'' + eval("res.map.CD_MNG" + i) + '\')"></i></span></div>');
                                    break;
                                case "B25":				//환율
                                    $("div [data-ax-td-label='mng" + i + "']").next().html('<div class="input-group"><input type="text" class="form-control ' + required + '" id="a' + i + '" cd-mng="' + eval("res.map.CD_MNG" + i) + '" nm-mng="' + eval("res.map.NM_MNG" + i) + '" text="' + eval("nvl(initData.NM_MNGD" + i + ", '')") + '" code="' + eval("nvl(initData.CD_MNGD" + i + ", '')") + '" VALUE="' + eval("nvl(initData.NM_MNGD" + i + ", '')") + '"></div>');
                                    break;
                                case "B26":				//외화금액
                                    $("div [data-ax-td-label='mng" + i + "']").next().html('<div class="input-group"><input type="text" class="form-control ' + required + '" id="a' + i + '" cd-mng="' + eval("res.map.CD_MNG" + i) + '" nm-mng="' + eval("res.map.NM_MNG" + i) + '" formatter="money"></div>');
                                    break;

                                case "C01":				//사업자등록번호
                                    $("div [data-ax-td-label='mng" + i + "']").next().html('<div class="input-group"><input type="text" class="form-control ' + required + '" id="a' + i + '" cd-mng="' + eval("res.map.CD_MNG" + i) + '" nm-mng="' + eval("res.map.NM_MNG" + i) + '" text="' + eval("nvl(initData.NM_MNGD" + i + ", '')") + '" code="' + eval("nvl(initData.CD_MNGD" + i + ", '')") + '" VALUE="' + eval("nvl(initData.NM_MNGD" + i + ", '')") + '"><span class="input-group-addon"><i class="cqc-magnifier" style="cursor: pointer" onclick="openPopup(\'partner\' ,\'a' + i + '\',\'' + eval("res.map.CD_MNG" + i) + '\')"></i></span></div>');
                                    break;
                                case "C05":				//과세표준액
                                    $("div [data-ax-td-label='mng" + i + "']").next().html('<div class="input-group"><input type="text" class="form-control ' + required + '" id="a' + i + '" cd-mng="' + eval("res.map.CD_MNG" + i) + '" nm-mng="' + eval("res.map.NM_MNG" + i) + '" text="' + eval("nvl(initData.NM_MNGD" + i + ", '')") + '" code="' + eval("nvl(initData.CD_MNGD" + i + ", '')") + '" VALUE="' + eval("nvl(initData.NM_MNGD" + i + ", '')") + '" formatter="money"></div>');
                                    break;
                                case "C14":				//세무구분
                                    $("div [data-ax-td-label='mng" + i + "']").next().html('<div  class="form-group ' + required + '" id="a' + i + '" cd-mng="' + eval("res.map.CD_MNG" + i) + '" nm-mng="' + eval("res.map.NM_MNG" + i) + '"   data-ax5select="fg_tax" data-ax5select-config="{}"></div>');

                                    $('[data-ax5select="fg_tax"]').ax5select({
                                        options: data_fg_tax,
                                        onStateChanged: function () {
                                            if (this.state == "close") {
                                                $(this.item.target).attr("code", this.value[0].value);
                                                $(this.item.target).attr("text", this.value[0].text);
                                            }
                                        }
                                    });


                                    if (nvl(initData['CD_MNGD' + i], '') != '') {
                                        $('[data-ax5select="fg_tax"]').ax5select("setValue", initData['CD_MNGD' + i], true);
                                        $("#a" + i).attr("code", initData['CD_MNGD' + i]);
                                        $("#a" + i).attr("text", initData['NM_MNGD' + i]);
                                    }

                                    break;
                                case "C12":				//수금일자
                                    $("div [data-ax-td-label='mng" + i + "']").next().html('<div class="input-group"><input type="text" class="form-control ' + required + '" id="a' + i + '" cd-mng="' + eval("res.map.CD_MNG" + i) + '" nm-mng="' + eval("res.map.NM_MNG" + i) + '" text="' + eval("nvl(initData.NM_MNGD" + i + ", '')") + '" code="' + eval("nvl(initData.CD_MNGD" + i + ", '')") + '" VALUE="' + $.changeDataFormat(eval("nvl(initData.NM_MNGD" + i + ", '')"), 'YYYYMMDD') + '"><span class="input-group-addon"><i class="cqc-magnifier" style="cursor: pointer" onclick="openCalender(\'calender\' ,\'a' + i + '\',\'' + eval("res.map.CD_MNG" + i) + '\')"></i></span></div>');
                                    break;
                                case "C15":				//거래처계좌번호
                                    $("div [data-ax-td-label='mng" + i + "']").next().html('<div class="input-group"><input type="text" class="form-control ' + required + '" id="a' + i + '" cd-mng="' + eval("res.map.CD_MNG" + i) + '" nm-mng="' + eval("res.map.NM_MNG" + i) + '" text="' + eval("nvl(initData.NM_MNGD" + i + ", '')") + '" code="' + eval("nvl(initData.CD_MNGD" + i + ", '')") + '" VALUE="' + eval("nvl(initData.NM_MNGD" + i + ", '')") + '"><span class="input-group-addon"><i class="cqc-magnifier" style="cursor: pointer" onclick="openPopup(\'partner_deposit\' ,\'a' + i + '\',\'' + eval("res.map.CD_MNG" + i) + '\')"></i></span></div>');
                                    break;
                                case "C28":				//지급조건
                                    $("div [data-ax-td-label='mng" + i + "']").next().html('<div class="input-group"><input type="text" class="form-control ' + required + '" id="a' + i + '" cd-mng="' + eval("res.map.CD_MNG" + i) + '" nm-mng="' + eval("res.map.NM_MNG" + i) + '" text="' + eval("nvl(initData.NM_MNGD" + i + ", '')") + '" code="' + eval("nvl(initData.CD_MNGD" + i + ", '')") + '" VALUE="' + eval("nvl(initData.NM_MNGD" + i + ", '')") + '"><span class="input-group-addon"><i class="cqc-magnifier" style="cursor: pointer" onclick="openPopup(\'payment_sub\' ,\'a' + i + '\',\'' + eval("res.map.CD_MNG" + i) + '\')"></i></span></div>');
                                    break;
                                default :
                                    $("div [data-ax-td-label='mng" + i + "']").next().html('<input type="text" class="default form-control ' + required + '" id="a' + i + '" cd-mng="' + eval("res.map.CD_MNG" + i) + '" nm-mng="' + eval("res.map.NM_MNG" + i) + '" text="' + eval("nvl(initData.NM_MNGD" + i + ", '')") + '" code="' + eval("nvl(initData.CD_MNGD" + i + ", '')") + '" VALUE="' + eval("nvl(initData.NM_MNGD" + i + ", '')") + '">');
                                    break;
                            }
                            $(".default").change(function(){
                                var target = $(this);
                                var value = target.val();
                                target.attr('code', target.val());
                                target.attr('text', target.val());
                            })
                        }

                    }
                });
            };

            fnObj.pageButtonView = axboot.viewExtend({
                initView: function () {
                    axboot.buttonClick(this, "data-page-btn", {
                        "close": function () {
                            ACTIONS.dispatch(ACTIONS.PAGE_CLOSE);
                        },
                        "save": function () {
                            ACTIONS.dispatch(ACTIONS.ITEM_SAVE);
                        },

                    });
                }
            });

            var userCallBack;
            var openCalender = function (name, t, cd_mng) {
                if (disabledYn == 'N') {
                    userCallBack = function (e) {
                        console.log(e);
                        if (name == "calender") {
                            $("#" + t).val(e.YYYY_MM_DD);
                            $("#" + t).attr({"code": e.YYYYMMDD, "text": e.YYYYMMDD});
                        }
                        parent.calenderModal.close();
                    };
                    console.log("calender ", this.name);
                    parent.openCalenderModal("userCallBack", this.name);
                }
            };


            var openPopup = function (name, t, cd_mng) {
                var mngdModal = this.name;
                if (disabledYn == 'N') {
                    if (name == "payment_sub"){
                        userCallBack = function (e) {
                            if (e.length > 0) {
                                $("#" + t).val(e[0].NM_PAYMENT);
                                $("#" + t).attr({"code": e[0].CD_PAYMENT, "text": e[0].NM_PAYMENT});
                            }
                            parent.ParentModal.close();
                        };
                        parent.openModal2("paymentSub", "HELP_PAYMENT_SUB", "userCallBack", mngdModal);
                    }else if (name == "bizarea") {
                        userCallBack = function (e) {
                            if (e.length > 0) {
                                $("#" + t).val(e[0].NM_BIZAREA);
                                $("#" + t).attr({"code": e[0].CD_BIZAREA, "text": e[0].NM_BIZAREA});
                            }
                            parent.ParentModal.close();
                        };
                        parent.openModal2("bizarea", "HELP_BIZAREA", "userCallBack", mngdModal);
                    } else if (name == "cc") {
                        userCallBack = function (e) {
                            if (e.length > 0) {
                                $("#" + t).val(e[0].NM_CC);
                                $("#" + t).attr({"code": e[0].CD_CC, "text": e[0].NM_CC});
                            }
                            parent.ParentModal.close();
                        };
                        parent.openModal2("cc", "HELP_CC", "userCallBack", mngdModal);

                    } else if (name == "dept") {
                        userCallBack = function (e) {
                            if (e.length > 0) {
                                $("#" + t).val(e[0].NM_DEPT);
                                $("#" + t).attr({"code": e[0].CD_DEPT, "text": e[0].NM_DEPT});
                            }
                            parent.ParentModal.close();
                        };
                        parent.openModal2("dept", "HELP_DEPT", "userCallBack", mngdModal);


                    } else if (name == "emp") {
                        userCallBack = function (e) {
                            if (e.length > 0) {
                                $("#" + t).val(e[0].NM_EMP);
                                $("#" + t).attr({"code": e[0].NO_EMP, "text": e[0].NM_EMP});
                            }
                            parent.ParentModal.close();
                        };
                        parent.openModal2("emp", "HELP_EMP", "userCallBack", mngdModal);

                    } else if (name == "project") {
                        userCallBack = function (e) {
                            if (e.length > 0) {
                                $("#" + t).val(e[0].NM_PROJECT);
                                $("#" + t).attr({"code": e[0].NO_PROJECT, "text": e[0].NM_PROJECT});
                            }
                            parent.ParentModal.close();
                        };
                        parent.openModal2("project", "HELP_PROJECT", "userCallBack", mngdModal);
                    } else if (name == "partner") {
                        userCallBack = function (e) {
                            if (e.length > 0) {

                                if (cd_mng == "C01") {
                                    $("#" + t).val(e[0].NO_COMPANY);
                                    $("#" + t).attr({"code": e[0].NO_COMPANY, "text": e[0].NO_COMPANY});
                                } else {
                                    $("#" + t).val(e[0].LN_PARTNER);
                                    $("#" + t).attr({"code": e[0].CD_PARTNER, "text": e[0].LN_PARTNER});
                                }
                                parent.ParentModal.close();
                            }
                        };
                        parent.openModal2("partner", "HELP_PARTNER", "userCallBack", mngdModal);
                    } else if (name == "deposit") {
                        userCallBack = function (e) {
                            if (e.length > 0) {

                                $("#" + t).val(e[0].NM_DEPOSIT);
                                $("#" + t).attr({"code": e[0].CD_DEPOSIT, "text": e[0].NM_DEPOSIT});

                            }
                            parent.ParentModal.close();
                        };
                        parent.openModal2("deposit", "HELP_DEPOSIT", "userCallBack", mngdModal);
                    }else if (name == "partner_deposit"){
                        var input = $("input");
                        var CD_PARTNER;
                        for (var i = 0 ; i < input.length ; i ++){
                            if ($(input[i]).attr('cd-mng') == 'A06'){
                                CD_PARTNER = $(input[i]).attr('code');
                            }
                        }
                        var initData = {
                            CD_PARTNER: CD_PARTNER
                        };
                        userCallBack = function (e) {
                            if (e.length > 0) {
                                var NM_BANK = (nvl(e[0].NM_BANK) == '') ? "은행없음" : e[0].NM_BANK;
                                var NO_DEPOSIT = (nvl(e[0].NO_DEPOSIT) == '') ? "계좌없음" : e[0].NO_DEPOSIT;
                                var LN_PARTNER = (nvl(e[0].LN_PARTNER) == '') ? "거래처없음" : e[0].LN_PARTNER;
                                var NM_MNGD = NM_BANK + "/" + NO_DEPOSIT + "/" + LN_PARTNER;
                                if (cd_mng == "C15") {
                                    $("#" + t).val(e[0].NO_DEPOSIT);    //  신한은행/110408761891/(주)동부산C.C
                                    $("#" + t).attr({"code": e[0].NO_DEPOSIT, "text": NM_MNGD});
                                }
                            }
                            parent.ParentModal.close();
                        };
                        parent.openModal2("partner_deposit", "HELP_PARTNER_DEPOSIT", "userCallBack", mngdModal, initData);
                    } else if (name == "card") {
                        userCallBack = function (e) {
                            if (e.length > 0) {
                                $("#" + t).val(e[0].NM_CARD);
                                $("#" + t).attr({"code": e[0].NO_CARD, "text": e[0].NM_CARD});
                            }
                            parent.ParentModal.close();
                        };
                        parent.openModal2("card", "HELP_CARD", "userCallBack", mngdModal);
                    } else if (name == "bank") {
                        userCallBack = function (e) {
                            if (e.length > 0) {
                                $("#" + t).val(e[0].NM_BANK);
                                $("#" + t).attr({"code": e[0].CD_BANK, "text": e[0].NM_BANK});
                            }
                            parent.ParentModal.close();
                        };
                        parent.openModal2("bank", "HELP_BANK", "userCallBack", mngdModal);
                    } else if (name == "takeBillrec") {
                        userCallBack = function (e) {
                            if (e.length > 0) {
                                $("#" + t).val(e[0].NM_BILL);
                                $("#" + t).attr({"code": e[0].NO_BILLREC, "text": e[0].NM_BILL});
                            }
                            parent.ParentModal.close();
                        };
                        parent.openModal2("takeBillrec", "HELP_BILLREC", "userCallBack", mngdModal);
                    } else if (name == "anticipation") {
                        userCallBack = function (e) {
                            if (e.length > 0) {
                                $("#" + t).val(e[0].NM_SYSDEF);
                                $("#" + t).attr({"code": e[0].CD_SYSDEF, "text": e[0].NM_SYSDEF});
                            }
                            parent.ParentModal.close();
                        };
                        parent.openModal2("anticipation", "HELP_ANTICIPATION", "userCallBack", mngdModal);
                    } else if (name == 'assetMngdNo') {
                        userCallBack = function (e) {
                            if (e.length > 0) {
                                $("#" + t).val(e[0].NM_ASSET);
                                $("#" + t).attr({"code": e[0].CD_ASSET, "text": e[0].NM_ASSET});
                            }
                            parent.ParentModal.close();
                        };
                        parent.openModal2("assetMngdNo", "HELP_ASSET_MNGDNO", "userCallBack", mngdModal);

                    } else if (name == 'assetProcGb') {
                        userCallBack = function (e) {
                            if (e.length > 0) {
                                $("#" + t).val(e[0].NAME);
                                $("#" + t).attr({"code": e[0].CODE, "text": e[0].NAME});
                            }
                            parent.ParentModal.close();
                        };
                        parent.openModal2("assetProcGb", "HELP_ASSET_PROCGB", "userCallBack", mngdModal);

                    }
                }
            }


        </script>
        </jsp:attribute>
    <jsp:body>

        <div data-page-buttons="">
            <div class="button-warp">
                <button type="button" class="btn btn-popup-default" data-page-btn="save" id="BtnSave"><i
                        class="icon_ok"></i>저장
                </button>
                <button type="button" class="btn btn-popup-close" data-page-btn="close"><ax:lang
                        id="ax.admin.sample.modal.button.close"/></button>
            </div>
        </div>

        <ax:form name="formView01">
            <input type="hidden" name="hiddenValue" value=""/>
            <ax:tbl clazz="ax-form-tbl" minWidth="500px">
                <ax:tr>
                    <ax:td label="이름" labelWidth="120px;" width="50%" id="mng1" style="border-right:1px solid #D8D8D8;">
                        <input type="text" name="userNm" data-ax-path="userNm" maxlength="15" title="이름"
                               class="av-required form-control W230" value=""/>
                    </ax:td>
                    <ax:td label="아이디" labelWidth="120px;" width="50%" id="mng5">

                    </ax:td>
                </ax:tr>
                <ax:tr>
                    <ax:td label="이름" labelWidth="120px;" width="50%" id="mng2" style="border-right:1px solid #D8D8D8;">

                    </ax:td>
                    <ax:td label="아이디" labelWidth="120px;" width="50%" id="mng6">

                    </ax:td>
                </ax:tr>
                <ax:tr>
                    <ax:td label="이름" labelWidth="120px;" width="50%" id="mng3" style="border-right:1px solid #D8D8D8;">

                    </ax:td>
                    <ax:td label="아이디" labelWidth="120px;" width="50%" id="mng7">

                    </ax:td>
                </ax:tr>
                <ax:tr>
                    <ax:td label="이름" labelWidth="120px;" width="50%" id="mng4" style="border-right:1px solid #D8D8D8;">

                    </ax:td>
                    <ax:td label="아이디" labelWidth="120px;" width="50%" id="mng8">

                    </ax:td>
                </ax:tr>
            </ax:tbl>
        </ax:form>

    </jsp:body>
</ax:layout>


