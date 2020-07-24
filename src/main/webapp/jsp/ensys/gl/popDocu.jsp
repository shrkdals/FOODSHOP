<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>

<ax:set key="title" value="전표처리"/>
<ax:set key="page_desc" value="${PAGE_REMARK}"/>
<ax:set key="page_auto_height" value="true"/>

<ax:layout name="base">
    <jsp:attribute name="script">
<%--        <script type="text/javascript" src="<c:url value='/assets/js/view/ensys/Helper_1.js' />"></script>--%>
        <script type="text/javascript">
            var param = ax5.util.param(ax5.info.urlUtil().param);
            var initData = parent.modal.modalConfig.sendData;
            console.log("param", param);
            console.log("initData", initData);

            var userCallBack;

            var gb_benefit = [];
            var data_gb_benefit = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, "CZ_Q0024");   //  편익구분
            for (var i = 0 ; i < data_gb_benefit.length ; i ++){
                if (initData.chkH[0].CD_DOCU == '002') {
                    if (data_gb_benefit[i].CODE == '1'){
                        gb_benefit.push(data_gb_benefit[i]);
                    }
                }else{
                    if (data_gb_benefit[i].CODE == '0'){
                        gb_benefit.push(data_gb_benefit[i]);
                    }
                }
            }
            $("#BEFT_GB").ax5select({
                options: gb_benefit
            });

            var tp_gb = [];
            var data_tp_gb = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, "CZ_Q0006");   //  유형
            for (var i = 0 ; i < data_tp_gb.length ; i ++){
                if (data_tp_gb[i].CODE == initData.chkH[0].TP_GB){
                    tp_gb.push(data_tp_gb[i]);
                }
            }
            $("#TP_GB").ax5select({
                options: tp_gb
            });

            /*var cd_docu = [];
            var data_cdDocu = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, "CZ_Q0002");   //  전표유형 모두 가져오기, 단 전표유형 disabled : true;
            for (var i = 0; i < data_cdDocu.length; i++) {
                if (initData.chkH[0].CD_DOCU == data_cdDocu[i].CODE) {
                    cd_docu.push(data_cdDocu[i]);
                }
            }

            $("#DOCU_TP").ax5select({
                options: cd_docu
            })
*/


            var today = new Date();
            var dtNow = ax5.util.date(today, {"return": "yyyy-MM-dd"});

            var picker = new ax5.ui.picker();
            picker.bind({
                target: $('[data-ax5picker="DT_ACCT"]'),
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
                    if (this.state == "changeValue") {
                        var target = $(".chk.on");
                        var id = target[0].id;
                        var index = 0;
                        var mode;
                        if (id.split('chkL').length > 1) {
                            index = id.split('chkL')[1];
                            mode = 'DR';
                        } else if (id.split('chkR').length > 1) {
                            index = id.split('chkR')[1];
                            mode = 'CR';
                        }

                        ACTIONS.dispatch(ACTIONS.PAGE_BUDGET_CONTROL, mode);
                    }
                },
                btns: {
                    today: {
                        label: "오늘", onClick: function () {

                            $("#dtAcct").val(dtNow);
                            this.self.close();
                        }
                    },
                    ok: {label: "확인", theme: "default"}
                }
            });

            var fnObj = {};
            var ACTIONS = axboot.actionExtend(fnObj, {
                PAGE_CLOSE: function (caller, act, data) {
                    parent.modal.close();
                },
                PAGE_SEARCH: function (caller, act, data) {
                    var amtR = 0, amtL = 0;
                    for (var i = 0 ; i < initData.chkR.length ; i++){
                        amtR += initData.chkR[i].AMT;
                    }
                    for (var i = 0 ; i < initData.chkL.length ; i++){
                        amtL += initData.chkL[i].AMT;
                    }
                    $("#CR").append(
                        "                                   <div data-ax-tr style='background: #ffe7e2'>\n" +
                        "                                        <div data-ax-td style=\"width: 100%;\">\n" +
                        "                                            <div data-ax-td-label style='width: 60%; border-right: 1px solid #e9e9e9;''></div>\n" +
                        "                                            <div data-ax-td-wrap style='width: 40%; text-align: right;'>" + comma(amtR) +"</div>\n" +
                        "                                        </div>\n" +
                        "                                    </div>"
                    );
                    $("#DR").append(
                        "                                   <div data-ax-tr style='background:#ffe7e2'>\n" +
                        "                                        <div data-ax-td style=\"width: 100%;\">\n" +
                        "                                            <div data-ax-td-label style='width: 60%; text-align: center; border-right: 1px solid #e9e9e9;''>합 계</div>\n" +
                        "                                            <div data-ax-td-wrap style='width: 40%; text-align: right;'>" + comma(amtL) +"</div>\n" +
                        "                                        </div>\n" +
                        "                                    </div>"
                    );
                    for (var i = 0 ; i < initData.chkR.length ; i++){
                        var data = initData.chkR[i];
                        $("#CR").append(
                        "                                   <div data-ax-tr class='chk' id='chkR"+ i +"'  style='background: #fff; cursor: pointer;'>\n" +
                        "                                        <div data-ax-td style=\"width: 100%;\">\n" +

                            "                                            <div data-ax-td-label style='width: 60%; text-align: left; border-right: 1px solid #e9e9e9;'>" + data.NM_ACCT +"</div>\n" +
                            "                                            <div data-ax-td-wrap style='width: 40%; text-align: right;'>" + comma(data.AMT) +"</div>\n" +

                        "                                        </div>\n" +
                        "                                    </div>"
                        );
                    }
                    for (var i = 0 ; i < initData.chkL.length ; i++){
                         var data = initData.chkL[i];
                         $("#DR").append(
                             "                                   <div data-ax-tr class='chk' id='chkL"+ i +"' style='background: #fff; cursor: pointer;'>\n" +
                             "                                        <div data-ax-td style=\"width: 100%;\">\n" +
                             "                                            <div data-ax-td-label style='width: 60%; text-align: left; border-right: 1px solid #e9e9e9;''>" + data.NM_ACCT +"</div>\n" +
                             "                                            <div data-ax-td-wrap style='width: 40%; text-align: right;'>" + comma(data.AMT) +"</div>\n" +
                             "                                        </div>\n" +
                             "                                    </div>"
                         );
                        if (i == 0){
                            $("#chkL0").toggleClass('on');
                            $("#chkL0").css('background', '#fffae6');
                        }
                     }
                    ACTIONS.dispatch(ACTIONS.PAGE_MNGD, 'DR');
                    ACTIONS.dispatch(ACTIONS.PAGE_BUDGET_CONTROL, 'DR');

                    $(".chk").click(function(){
                        var target = this;
                        var id = this.id;
                        var index = 0;
                        var mode;
                        if (id.split('chkL').length > 1){
                            index = id.split('chkL')[1];
                            mode = 'DR';
                        }else if (id.split('chkR').length > 1){
                            index = id.split('chkR')[1];
                            mode = 'CR';
                        }

                        var selected = $(".chk.on");
                        if (selected.length > 0){
                            if (selected[0].id != id){
                                $("#" + selected[0].id).toggleClass('on');
                                $("#" + id).toggleClass('on');
                                $("#" + selected[0].id).css('background', '#fff');
                                $("#" + id).css('background', '#fffae6');
                            }
                        }else{
                            $("#" + id).toggleClass('on');
                            $("#" + id).css('background', '#fffae6');
                        }
                        ACTIONS.dispatch(ACTIONS.PAGE_MNGD, mode);
                        ACTIONS.dispatch(ACTIONS.PAGE_BUDGET_CONTROL, mode);
                    })
                },
                PAGE_MNGD: function(caller, act, data){
                    var mngd;
                    if (data == 'CR'){  //  대변

                        var select = $(".chk.on");
                        var id = select[0].id;
                        var index = id.split('chkR')[1];

                        mngd = initData.chkR[index];
                    }else if (data == 'DR'){    //  차변

                        var select = $(".chk.on");
                        var id = select[0].id;
                        var index = id.split('chkL')[1];

                        mngd = initData.chkL[index];
                    }
                    for (var i = 1; i < 9; i++){
                        $("#mng" + i).html(nvl(mngd['NM_MNG' + i]));
                        $("#mng" + i + "_span").html(nvl(mngd['NM_MNGD' + i]));
                        if (nvl(mngd['CD_MNGD' + i]) != ''){
                            $("#mngd" + i).attr('data-tooltip-text', mngd['CD_MNGD' + i]);
                        }else{
                            $("#mngd" + i)[0].removeAttribute('data-tooltip-text', null);
                        }

                    }
                },
                PAGE_BUDGET_CONTROL : function(caller, act, data){
                    $("#table").remove();
                    var selected, index, mode, list = [];
                    if (data == 'CR'){
                        var select = $(".chk.on");
                        var id = select[0].id;
                        index = id.split('chkR')[1];
                        selected = initData.chkR[index];
                        mode = 'CR';
                        list = initData.chkR;
                    }else if (data == 'DR'){
                        var select = $(".chk.on");
                        var id = select[0].id;
                        index = id.split('chkL')[1];
                        selected = initData.chkL[index];
                        mode = 'DR';
                        list = initData.chkL;
                    }
                    if (nvl(selected.CD_BUDGET) == '' || nvl(selected.CD_BGACCT) == ''){
                        $("#budgetControl").append("<table id=\"table\">\n" +
                            "                        <tr>\n" +
                            "                            <th scope=\"row\" style=\"text-align: right;\">예산단위</th>\n" +
                            "                            <td rowspan='8' style='    text-align: center;color: red;'>예산통제 대상이 아닙니다.</td>" +
                            "                        </tr>\n" +
                            "                        <tr>\n" +
                            "                            <th scope=\"row\" style=\"text-align: right;\">예산계정</th>\n" +
                            "                        </tr>\n" +
                            "                        <tr>\n" +
                            "                            <th scope=\"row\" style=\"text-align: right;\">실행예산</th>\n" +
                            "                        </tr>\n" +
                            "                        <tr>\n" +
                            "                            <th scope=\"row\" style=\"text-align: right\">집행실적</th>\n" +
                            "                        </tr>\n" +
                            "                        <tr>\n" +
                            "                            <th scope=\"row\" style=\"text-align: right\">집행신청</th>\n" +
                            "                        </tr>\n" +
                            "                        <tr>\n" +
                            "                            <th scope=\"row\" style=\"text-align: right\">집행률</th>\n" +
                            "                        </tr>\n" +
                            "                        <tr>\n" +
                            "                            <th scope=\"row\" style=\"text-align: right\">잔여예산</th>\n" +
                            "                        </tr>\n" +
                            "                        <tr>\n" +
                            "                            <th scope=\"row\" style=\"text-align: right\">초과금액</th>\n" +
                            "                        </tr>\n" +
                            "                    </table>")
                    }else{
                        $("#budgetControl").append("<table id=\"table\">\n" +
                            "                        <tr>\n" +
                            "                            <th scope=\"row\" style=\"text-align: right;\">예산단위</th>\n" +
                            "                            <td id=\"CD_BUDGET\"></td>\n" +
                            "                        </tr>\n" +
                            "                        <tr>\n" +
                            "                            <th scope=\"row\" style=\"text-align: right;\">예산계정</th>\n" +
                            "                            <td id=\"CD_BGACCT\"></td>\n" +
                            "                        </tr>\n" +
                            "                        <tr>\n" +
                            "                            <th scope=\"row\" style=\"text-align: right;\">실행예산</th>\n" +
                            "                            <td id=\"AMT0\"></td>\n" +
                            "                        </tr>\n" +
                            "                        <tr>\n" +
                            "                            <th scope=\"row\" style=\"text-align: right\">집행실적</th>\n" +
                            "                            <td id=\"AMT1\"></td>\n" +
                            "                        </tr>\n" +
                            "                        <tr>\n" +
                            "                            <th scope=\"row\" style=\"text-align: right\">집행신청</th>\n" +
                            "                            <td id=\"AMT2\"></td>\n" +
                            "                        </tr>\n" +
                            "                        <tr>\n" +
                            "                            <th scope=\"row\" style=\"text-align: right\">집행률</th>\n" +
                            "                            <td id=\"AMT3\"></td>\n" +
                            "                        </tr>\n" +
                            "                        <tr>\n" +
                            "                            <th scope=\"row\" style=\"text-align: right\">잔여예산</th>\n" +
                            "                            <td id=\"AMT4\"></td>\n" +
                            "                        </tr>\n" +
                            "                        <tr>\n" +
                            "                            <th scope=\"row\" style=\"text-align: right\">초과금액</th>\n" +
                            "                            <td id=\"AMT5\"></td>\n" +
                            "                        </tr>\n" +
                            "                    </table>");

                        var temp_amt_tot = 0;
                        for (var i = 0 ; i < list.length ; i ++){
                            if (nvl(list[i].CD_BUDGET) != '' && nvl(list[i].CD_BGACCT) != ''){
                                if (list[i].CD_BUDGET == selected.CD_BUDGET && list[i].CD_BGACCT == selected.CD_BGACCT){
                                    temp_amt_tot += Number(list[i].AMT);
                                }
                            }
                        }
                        var result = $.DATA_SEARCH('apbucard', 'acctBudgetAmt', {
                            CD_BGACCT: selected.CD_BGACCT,
                            CD_BUDGET: selected.CD_BUDGET,
                            DT_ACCT: $("#dtAcct").val().replace(/-/g, ""),
                            APPLY_AMT: temp_amt_tot
                        });
                        $("#CD_BUDGET").html(selected.NM_BUDGET);
                        $("#CD_BUDGET").attr('data-tooltip-text', selected.CD_BUDGET);
                        $("#CD_BGACCT").html(selected.NM_BGACCT);
                        $("#CD_BGACCT").attr('data-tooltip-text', selected.CD_BGACCT);
                        $("#AMT0").html(comma(result.list[0].AMT0));
                        $("#AMT1").html(comma(result.list[0].AMT1));
                        $("#AMT2").html(comma(temp_amt_tot));
                        if(Number(result.list[0].AMT0) == 0){
                            $("#AMT3").html("0 %")
                        }else{
                            var percent = (((Number(result.list[0].AMT1) + (Number(temp_amt_tot))) / Number(result.list[0].AMT0))*100).toFixed(2);
                            var temp = percent.split(".");
                            percent = comma(temp[0]) + '.'+ temp[1];
                            $("#AMT3").html(percent+"%")  //집행률
                        }
                        $("#AMT4").html(comma(result.list[0].AMT2)); // 잔여예산
                        $("#AMT5").html(comma(result.list[0].OVER_AMT)); //예산대비 신청초과액
                        if(result.list[0].OVER_AMT < 0){
                            $("#AMT5").css("color","red")
                        }
                    }
                },
                PAGE_SAVE: function (caller, act, data) {
                    if (nvl($("#dtAcct").val()) == ''){
                        qray.alert('회계일자를 입력해주십시오.');
                        return;
                    }
                    if (nvl($("#REMARK").val()) == ''){
                        qray.alert('적요를 입력해주십시오.');
                        return;
                    }
                    var params = {
                        CD_COMPANY: SCRIPT_SESSION.cdCompany
                        , DT_ACCT: $("#dtAcct").val().replace(/-/gi, "")
                        , CD_DOCU: "90"
                        , CD_DEPT: SCRIPT_SESSION.cdCompany
                        , DT_WRITE: ax5.util.date(new Date(), {"return": "yyyyMMdd"})
                    };
                    var result = $.DATA_SEARCH('commonutility', 'checkMagam', params);
                    if (result.map.CHECK_YN == 'Y') {
                        qray.alert('마감된 날짜입니다.');
                        return false;
                    }

                    var _noTpdocu = [];
                    var TP_GB_01 = 0, TP_GB_03 = 0, TP_GB_07 = 0, GB_BENEFIT = 0, CD_DOCU_001 = 0, CD_DOCU_002 = 0, CD_DOCU_005 = 0;
                    var tp_gb;
                    for (var i = 0; i < initData.chkH.length; i++) {
                        _noTpdocu.push(initData.chkH[i].NO_TPDOCU);

                        if (initData.chkH[i].TP_GB == '01'){
                            TP_GB_01++;
                            tp_gb = '01';
                            if (initData.chkH[i].CD_DOCU == '001'){
                                CD_DOCU_001++;
                            }
                            if (initData.chkH[i].CD_DOCU == '002'){
                                CD_DOCU_002++;
                            }
                            if (initData.chkH[i].CD_DOCU == '005'){
                                CD_DOCU_005++;
                            }
                        }else if (initData.chkH[i].TP_GB == '03'){
                            TP_GB_03++;
                            if (initData.chkH[i].CD_DOCU == '002'){
                                CD_DOCU_002++;
                            }
                            tp_gb = '03';
                        }else if (initData.chkH[i].TP_GB == '07'){
                            TP_GB_07++;
                            tp_gb = '07';
                        }
                    }

                    var chkVal = false;
                    if (CD_DOCU_001 > 0 && (CD_DOCU_002 > 0 || CD_DOCU_005 > 0)){
                        chkVal = true;
                    }
                    if (CD_DOCU_002 > 0 && (CD_DOCU_001 > 0 || CD_DOCU_005 > 0)){
                        chkVal = true;
                    }
                    if (CD_DOCU_005 > 0 && (CD_DOCU_002 > 0 || CD_DOCU_001 > 0)){
                        chkVal = true;
                    }
                    if (TP_GB_01 > 0 && (TP_GB_03 > 0 || TP_GB_07 > 0)){
                        chkVal = true;
                    }
                    if (TP_GB_03 > 0 && (CD_DOCU_002 > 0 ||TP_GB_01 > 0 || TP_GB_07 > 0)){
                        chkVal = true;
                    }
                    if (TP_GB_07 > 0 && (TP_GB_03 > 0 || TP_GB_01 > 0)){
                        chkVal = true;
                    }

                    if (chkVal){
                        qray.alert('동일한 유형의 전표를 등록해야합니다.');
                        return false;
                    }

                    var count = 0;
                    axboot.ajax({
                        type: "POST",
                        url: ["gldocum", "getchkValidate"],
                        async: false,
                        data: JSON.stringify({
                            "NO_TPDOCU": _noTpdocu.join('|')
                        }),
                        callback: function (res) {
                            count = res.map.COUNT;
                        }
                    });

                    if (count > 0) {
                        qray.alert('이미 전표처리된 데이터가 존재합니다.');
                        return false;
                    }

                    for (var i = 0 ; i < initData.chkL.length ; i ++){
                        if (nvl(initData.chkL[i].CD_BUDGET) != '' && nvl(initData.chkL[i].CD_BGACCT) != ''){
                            var temp_amt_tot = Number(initData.chkL[i].AMT);
                            for (var i2 = 0 ; i2 < initData.chkL.length ; i2 ++){
                                if (i == i2) continue;

                                if (nvl(initData.chkL[i2].CD_BUDGET) != '' && nvl(initData.chkL[i2].CD_BGACCT) != ''){
                                    if (initData.chkL[i].CD_BUDGET == initData.chkL[i2].CD_BUDGET && initData.chkL[i].CD_BGACCT == initData.chkL[i2].CD_BGACCT){
                                        temp_amt_tot += Number(initData.chkL[i2].AMT);
                                    }
                                }
                            }
                            var result = $.DATA_SEARCH('apbucard', 'acctBudgetAmt', {
                                CD_BGACCT: initData.chkL[i].CD_BGACCT,
                                CD_BUDGET: initData.chkL[i].CD_BUDGET,
                                DT_ACCT: $("#dtAcct").val().replace(/-/g, ""),
                                APPLY_AMT: temp_amt_tot
                            });
                            console.log("예산통제 차변 : ", result);
                            if (nvl(Number(result.list[0]['OVER_AMT']), 0) != 0){
                                qray.alert("차변계정 [ " + initData.chkL[i].NM_ACCT +" ]<br>예산을 초과하였습니다.");
                                return false;
                            }
                        }
                    }

                    for (var i = 0 ; i < initData.chkR.length ; i ++){
                        if (nvl(initData.chkR[i].CD_BUDGET) != '' && nvl(initData.chkR[i].CD_BGACCT) != ''){
                            var temp_amt_tot = Number(initData.chkR[i].AMT);
                            for (var i2 = 0 ; i2 < initData.chkR.length ; i2 ++){
                                if (i == i2) continue;

                                if (nvl(initData.chkR[i2].CD_BUDGET) != '' && nvl(initData.chkR[i2].CD_BGACCT) != ''){
                                    if (initData.chkR[i].CD_BUDGET == initData.chkR[i2].CD_BUDGET && initData.chkR[i].CD_BGACCT == initData.chkR[i2].CD_BGACCT){
                                        temp_amt_tot += Number(initData.chkR[i2].AMT);
                                    }
                                }
                            }
                            var result = $.DATA_SEARCH('apbucard', 'acctBudgetAmt', {
                                CD_BGACCT: initData.chkR[i].CD_BGACCT,
                                CD_BUDGET: initData.chkR[i].CD_BUDGET,
                                DT_ACCT: $("#dtAcct").val().replace(/-/g, ""),
                                APPLY_AMT: temp_amt_tot
                            });
                            console.log("예산통제 차변 : ", result);
                            if (nvl(Number(result.list[0]['OVER_AMT']), 0) != 0){
                                qray.alert("예산초과된 항목이 있습니다");
                                return false;
                            }


                        }
                    }


                    qray.confirm({
                        msg: "전표 처리하시겠습니까?"
                    }, function () {
                        if (this.key == "ok") {
                            axboot.ajax({
                                type: "PUT",
                                url: ["gldocum2", "insert"],
                                data: JSON.stringify({
                                    "header": initData.chkH,
                                    "gridDetailLeft": initData.chkL,
                                    "gridDetailRight": initData.chkR,
                                    "cdDept": SCRIPT_SESSION.cdDept,
                                    "cdEmp": SCRIPT_SESSION.noEmp,
                                    "dtAcct": $("#dtAcct").val().replace(/-/gi, ""),
                                    "remark": $("#REMARK").val(), //DOCU 용 적요
                                    "tp_gb": tp_gb,        //  유형
                                    "etcdocu": (tp_gb == '03' ? "Y" : "N"),    //기타전표여부
                                }),
                                callback: function (res) {
                                    qray.alert("성공적으로 전표처리 되었습니다.").then(function() {
                                        parent[param.callBack]({GROUP_NUMBER : res.map.GROUP_NUMBER});
                                    });
                                }
                            })
                        }
                    })
                }
            });

            // fnObj 기본 함수 스타트와 리사이즈
            fnObj.pageStart = function () {
                this.pageButtonView.initView();
                var str = '';
                /*if(parent.modal.modalConfig.sendData().initData.RESULT.length == 0){
                    str = '';
                }else{
                    str = '';
                }*/
                $('#dtAcct').val(dtNow);
                $("#REMARK").val(str);

                ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
            };

            fnObj.pageResize = function () {

            };


            fnObj.pageButtonView = axboot.viewExtend({
                initView: function () {
                    axboot.buttonClick(this, "data-page-btn", {
                        "select": function () {

                        },
                        "close": function () {
                            parent.modal.close();
                        },
                        "ok": function () {
                            ACTIONS.dispatch(ACTIONS.PAGE_SAVE);
                        }
                    });
                }
            });


        </script>
        <style>
            #table {
                border-collapse: separate;
                border-spacing: 0;
                text-align: left;
                line-height: 1.5;
                border-left: 1px solid #ccc;
                border-top: 1px solid #ccc;
                width: 100%;
            }

            #table th {
                width: 150px;
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

            #table td {
                width: 350px;
                padding: 10px;
                vertical-align: middle;
                border-right: 1px solid #ccc;
                border-bottom: 1px solid #ccc;
            }


        </style>
    </jsp:attribute>
    <jsp:body>

        <div data-page-buttons="">
            <div class="button-warp">
                <button type="button" class="btn btn-reload" data-page-btn="reload" onclick="window.location.reload();"
                        style="width:80px;">
                    <i class="icon_reload"></i></button>
                <button type="button" class="btn btn-popup-default" data-page-btn="ok"><i class="icon_ok"></i>전표처리
                </button>
                <button type="button" class="btn btn-popup-close" data-page-btn="close"><ax:lang
                        id="ax.admin.sample.modal.button.close"/></button>
            </div>
        </div>


        <div role="page-header">
            <ax:form name="searchView0">
                <ax:tbl clazz="ax-search-tbl" minWidth="700px">
                    <ax:tr>
                        <%--<ax:td label='전표유형' width="150px">
                            <div id="DOCU_TP" name="DOCU_TP" data-ax5select="DOCU_TP" data-ax5select-config='{}'></div>
                        </ax:td>--%>
                        <ax:td label='유형' width="350px">
                            <div id="TP_GB" name="TP_GB" data-ax5select="TP_GB" readonly data-ax5select-config='{}'></div>
                        </ax:td>
                        <ax:td label='편익구분' width="350px">
                            <div id="BEFT_GB" name="BEFT_GB" data-ax5select="BEFT_GB" readonly data-ax5select-config='{}'></div>
                        </ax:td>
                        <ax:td label="회계일자" width="350px">
                            <div class="input-group" data-ax5picker="DT_ACCT">
                                <input type="text" class="form-control" style="background: #ffe0cf" placeholder="yyyy-mm-dd" id="dtAcct"
                                       formatter="YYYYMMDD">
                                <span class="input-group-addon"><i class="cqc-calendar"></i></span>
                            </div>
                        </ax:td>
                        <ax:td label='적요' width="350px">
                            <input type="text" class="form-control" style="background: #ffe0cf" name="REMARK" id="REMARK" autocomplete="off"/>
                        </ax:td>
                    </ax:tr>
                </ax:tbl>
            </ax:form>
            <div class="H10"></div>
        </div>
        <ax:split-layout name="ax1" orientation="horizontal">
            <ax:split-panel style=" heightpadding-bottom: 10px;" scroll="scroll">

                <div style="height: 30px;">
                    <div style="width:50%; float: left;">
                        <h2>
                            차변
                        </h2>
                    </div>
                    <div style="width:50%; float: right;">
                        <h2>
                            대변
                        </h2>
                    </div>
                </div>
                <div style="overflow: auto; overflow: auto; height: 300px; background: #F7F8FA;">
                    <div style="width:50%; height:100%; float: left;">
                        <div>
                            <div style="border-left: 1px solid #D8D8D8;border-top: 1px solid #D8D8D8;border-bottom: 1px solid #D8D8D8;">
                                <div data-ax-tbl id="DR" class="ax-search-tbl">
                                </div>
                            </div>
                        </div>
                    </div>
                    <div style="width:50%; float: right;">
                        <div style="">
                            <div style="border-right: 1px solid #D8D8D8;border-top: 1px solid #D8D8D8;border-bottom: 1px solid #D8D8D8;">
                                <div data-ax-tbl id="CR" class="ax-search-tbl">

                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div style="padding-top: 20px">
                    <h2>
                        <i class="cqc-list"></i>관리항목
                    </h2>
                    <div style="padding-top: 10px"></div>
                    <div style="width:100%;">
                        <div data-ax-tbl class="ax-form-tbl">
                            <div data-ax-tr>
                                <div data-ax-td id="mngd1" style="border-right: 1px solid #D8D8D8; width: 50%;">
                                    <div data-ax-td-label id="mng1" style="width: 30%;"></div>
                                    <div data-ax-td-wrap id="mng1_span"></div>
                                </div>
                                <div data-ax-td id="mngd5" style="width: 50%;">
                                    <div data-ax-td-label id="mng5" style="width: 30%;"></div>
                                    <div data-ax-td-wrap id="mng5_span"></div>
                                </div>
                            </div>
                            <div data-ax-tr>
                                <div data-ax-td id="mngd2" style="border-right: 1px solid #D8D8D8; width: 50%;">
                                    <div data-ax-td-label id="mng2" style="width: 30%;"></div>
                                    <div data-ax-td-wrap id="mng2_span"></div>
                                </div>
                                <div data-ax-td id="mngd6" style="width: 50%;">
                                    <div data-ax-td-label id="mng6" style="width: 30%;"></div>
                                    <div data-ax-td-wrap id="mng6_span"></div>
                                </div>
                            </div>
                            <div data-ax-tr>
                                <div data-ax-td id="mngd3" style="border-right: 1px solid #D8D8D8; width: 50%;">
                                    <div data-ax-td-label id="mng3" style="width: 30%;"></div>
                                    <div data-ax-td-wrap id="mng3_span"></div>
                                </div>
                                <div data-ax-td id="mngd7" style="width: 50%;">
                                    <div data-ax-td-label id="mng7" style="width: 30%;"></div>
                                    <div data-ax-td-wrap id="mng7_span"></div>
                                </div>
                            </div>
                            <div data-ax-tr>
                                <div data-ax-td id="mngd4" style="border-right: 1px solid #D8D8D8; width: 50%;">
                                    <div data-ax-td-label id="mng4" style="width: 30%;"></div>
                                    <div data-ax-td-wrap id="mng4_span"></div>
                                </div>
                                <div data-ax-td id="mngd8" style="width: 50%;">
                                    <div data-ax-td-label id="mng8" style="width: 30%;"></div>
                                    <div data-ax-td-wrap id="mng8_span"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div style="padding-top: 20px">
                    <h2>
                        <i class="cqc-list"></i>예산통제
                    </h2>
                    <div style="width:100%; padding-top: 10px;" id="budgetControl">
                    <table id="table">
                        <tr>
                            <th scope="row" style="text-align: right;">예산단위</th>
                            <td id="CD_BUDGET"></td>
                        </tr>
                        <tr>
                            <th scope="row" style="text-align: right;">예산계정</th>
                            <td id="NM_BGACCT"></td>
                        </tr>
                        <tr>
                            <th scope="row" style="text-align: right;">실행예산</th>
                            <td id="AMT0"></td>
                        </tr>
                        <tr>
                            <th scope="row" style="text-align: right">집행실적</th>
                            <td id="AMT1"></td>
                        </tr>
                        <tr>
                            <th scope="row" style="text-align: right">집행신청</th>
                            <td id="AMT2"></td>
                        </tr>
                        <tr>
                            <th scope="row" style="text-align: right">집행률</th>
                            <td id="AMT3"></td>
                        </tr>
                        <tr>
                            <th scope="row" style="text-align: right">잔여예산</th>
                            <td id="AMT4"></td>
                        </tr>
                        <tr>
                            <th scope="row" style="text-align: right">초과금액</th>
                            <td id="AMT5"></td>
                        </tr>
                    </table>
                </div>
                </div>
            </ax:split-panel>
        </ax:split-layout>

    </jsp:body>
</ax:layout>