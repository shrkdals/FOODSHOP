<%@ page import="com.chequer.axboot.core.utils.MessageUtils" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>

<ax:set key="title" value="전표등록"/>
<ax:set key="page_desc" value="${pageRemark}"/>
<ax:set key="page_auto_height" value="true"/>


<ax:layout name="base">
    <jsp:attribute name="script">
        <ax:script-lang key="ax.script"/>
 <style>
     .red {
         background: #ffe0cf !important;
     }

     .readonly {
         background: #EEEEEE !important;
     }

     .bottomlabel {
         width: 60px;
         background: #f6f6f6;
         text-align: center;
         font-size: 12px;
         font-weight: 700;
         min-height: 32px;
         height: 32px;
         line-height: 32px;
         float: left;
     }

     .bottominput {
         width: 70px;
         float: left;
         padding-top: 3px;
         margin-left: 5px;
         margin-right: 5px;
     }
 </style>

        <script type="text/javascript">
            var  gridData_ = [], delete_ = [];

            var actionRowIdx = 0;
            var actionRowIdxR = 0;
            var actionRowIdxL = 0;

            var _tabview = this.parent.fnObj.tabView; //받아온데이터 대상객체(초기화할때사용함)
            var _urlGetData = this.parent.fnObj.tabView.urlGetData(); //받아온데이터
            var _etcdocuyn = true; //기타전표여부(점프해서 넘어온게 아닌 화면에서 직접입력할때는 true,점프해서 넘어오면 false)
            var _LINENO = 0;
            var mode;
            var data_cdDocu = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, "CZ_Q0002", true, 'Y');    //  전표유형 CD_FLAG1 : "Y" 인 경우만 가져오기.
            if (!_urlGetData || _urlGetData.length == 0) {  //넘어온데이터가 없음
                _etcdocuyn = true;
                mode = '기타';
            } else {
                _etcdocuyn = false;
                if (sessionStorage.getItem("prevmenuid") == "10502") { //매입세금계산서관리
                    mode = '매입';
                    data_cdDocu = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, "CZ_Q0002", true, '', '', 'Y');               //  전표유형 모두 가져오기, 단 전표유형 disabled : true;
                }
                if (sessionStorage.getItem("prevmenuid") == "10504") { //매출세금계산서
                    mode = '매출';
                    data_cdDocu = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, "CZ_Q0002", false);
                }
            }
            var myModel_LEFT = new ax5.ui.binder();
            var myModel_RIGHT = new ax5.ui.binder();
            var benefitList; //  편익
            var modal = new ax5.ui.modal();
            var menuParam = ax5.util.param(ax5.info.urlUtil().param);
            var userCallBack;
            $(document.body).ready(function () {
                $('[data-ax5layout]').ax5layout();
            });

            var fg_taxApproveData = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'CZ_Q0016', true);   //  세무구분 공백 없는것
            fg_taxApproveData = fg_taxApproveData.concat($.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'CZ_Q0015', true));


            var data_tpEvidence = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, "CZ_Q0022"); // 증빙유형
            // var data_purch = $.getCommonCodeList(SCRIPT_SESSION.cdCompany, "CZ_Q0015"); // 매입 부가세
            // var data_sales = $.getCommonCodeList(SCRIPT_SESSION.cdCompany, "CZ_Q0016"); // 매출 부가세

            var data_drcr = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, "CZ_Q0004"); // 증빙유형
            // var data_fg_tax = data_purch.concat(data_sales);//포멧용 매입 매출 부가세


            var par = parent.fnObj;

            var tax_code_dr = ""; //차변 부가세 계정
            var tax_code_cr = ""; //대변 부가세 계정
            var tax_code_recept = ""; //접대비 계정
            var tax_acct = "";

            axboot.ajax({
                type: "GET",
                url: ["gldocum", "getAcctcode"],
                data: "CD_RELATION=30",
                async: false,
                callback: function (res) {
                    if (nvl(res.map) != '') {
                        tax_code_dr = res.map.CD_ACCT;
                        tax_acct += "," + res.map.CD_ACCT;
                    }
                }
            });

            axboot.ajax({
                type: "GET",
                url: ["gldocum", "getAcctcode"],
                data: "CD_RELATION=31",
                async: false,
                callback: function (res) {
                    if (nvl(res.map) != '') {
                        tax_code_cr = res.map.CD_ACCT;
                        tax_acct += "," + res.map.CD_ACCT;
                    }
                }
            });

            console.log(tax_acct);

            axboot.ajax({
                type: "GET",
                url: ["gldocum", "getAcctcode"],
                data: "CD_RELATION=82",
                async: false,
                callback: function (res) {
                    if (nvl(res.map) != '') {
                        tax_code_recept = res.map.CD_ACCT;
                    }
                }
            });

            var dialog = new ax5.ui.dialog();
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

                }
            });


            var fnObj = {};
            fnObj.pageStart = function () {
                this.pageButtonView.initView();
                this.gridHeader.initView();
                this.gridDetailLeft.initView();
                this.gridDetailRight.initView();

                // $("#dtAcct").formatter('YYYYMMDD');
                var today = new Date();
                $("#dtAcct").val(ax5.util.date(today, {"return": "yyyy-MM-dd"})); //회계일자

                if (!_etcdocuyn) {
                    if (mode == '매입') {
                        $("#dtAcct").val(datedash(_urlGetData.DT_ACCT));
                        $("#NM_NOTE").val(_urlGetData.REMARK);

                        console.log("_urlGetData", _urlGetData);
                        for (var i = 0; i < _urlGetData.RESULT.length; i++) {
                            fnObj.gridHeader.addRow();
                            var lastIdx = nvl(fnObj.gridHeader.target.list.length, fnObj.gridHeader.lastRow());
                            fnObj.gridHeader.target.select(lastIdx - 1);
                            fnObj.gridHeader.target.setValue(lastIdx - 1, "LINENO", ++_LINENO);
                            fnObj.gridHeader.target.setValue(lastIdx - 1, "noTpdocu", datedash(_urlGetData.RESULT[i].NO_TAX));
                            fnObj.gridHeader.target.setValue(lastIdx - 1, "cdDocu", _urlGetData.CD_DOCU); //전표유형:매입(001)(CZ_Q0002)
                            fnObj.gridHeader.target.setValue(lastIdx - 1, "tpEvidence", "3"); //증빙유형:세금계산서(3)(CZ_Q0022)
                            fnObj.gridHeader.target.setValue(lastIdx - 1, "AMT_SUPPLY", _urlGetData.RESULT[i].AM); //공급가//매입세금계산서에서 클릭해서 넘어온거라서 무조건데이터가 있음
                            fnObj.gridHeader.target.setValue(lastIdx - 1, "AMT_VAT", _urlGetData.RESULT[i].AM_VAT); //부가세
                            fnObj.gridHeader.target.setValue(lastIdx - 1, "AMT_SUM", _urlGetData.RESULT[i].AMT); //합계금액
                            fnObj.gridHeader.target.setValue(lastIdx - 1, "cdPartner", _urlGetData.RESULT[i].CD_PARTNER); //거래처코드
                            fnObj.gridHeader.target.setValue(lastIdx - 1, "lnPartner", _urlGetData.RESULT[i].SELL_NM_CORP); //거래처명
                            fnObj.gridHeader.target.setValue(lastIdx - 1, "dtTrans", datedash(_urlGetData.RESULT[i].YMD_WRITE)); //계산서일자
                            fnObj.gridHeader.target.setValue(lastIdx - 1, "NO_TAX", datedash(_urlGetData.RESULT[i].NO_TAX)); //매입세금계산서키값
                            fnObj.gridHeader.target.setValue(lastIdx - 1, "CD_EXCH", "000");
                            fnObj.gridHeader.target.setValue(lastIdx - 1, "NM_EXCH", "KRW");
                            fnObj.gridHeader.target.setValue(lastIdx - 1, "RT_EXCH", "1.00");
                            fnObj.gridHeader.target.focus(lastIdx - 1);

                        }
                        _tabview.urlSetData(null);
                    }
                    if (mode == '매출') {
                        if (nvl(_urlGetData) == '') {
                            return false;
                        }
                        var list = _urlGetData["result"];
                        var map = _urlGetData["result2"];
                        $("#dtAcct").val(datedash(map.DT_ACCT));
                        $("#cdDept").val(map.NM_DEPT);
                        $("#cdDept").attr("name", map.NM_DEPT);
                        $("#cdDept").attr("code", map.CD_DEPT);
                        $("#cdEmp").val(map.NM_EMP);
                        $("#cdEmp").attr("name", map.NM_EMP);
                        $("#cdEmp").attr("code", map.CD_EMP);
                        $("#NM_NOTE").val(map.REMARKS);

                        for (var i = 0; i < list.result.length; i++) {

                            fnObj.gridHeader.addRow();
                            var lastIdx = nvl(fnObj.gridHeader.target.list.length, fnObj.gridHeader.lastRow());
                            fnObj.gridHeader.target.select(lastIdx - 1);
                            fnObj.gridHeader.target.setValue(lastIdx - 1, "LINENO", ++_LINENO);
                            fnObj.gridHeader.target.setValue(lastIdx - 1, "noTpdocu", list.result[i].NO_TPDOCU);
                            fnObj.gridHeader.target.setValue(lastIdx - 1, "cdDocu", "005"); //전표유형:매출(세)(005)(CZ_Q0002)
                            fnObj.gridHeader.target.setValue(lastIdx - 1, "tpEvidence", "3"); //증빙유형:세금계산서(3)(CZ_Q0022)
                            fnObj.gridHeader.target.setValue(lastIdx - 1, "AMT_SUPPLY", list.result[i].AMT); //공급가//매입세금계산서에서 클릭해서 넘어온거라서 무조건데이터가 있음
                            fnObj.gridHeader.target.setValue(lastIdx - 1, "AMT_VAT", list.result[i].VAT); //부가세
                            fnObj.gridHeader.target.setValue(lastIdx - 1, "AMT_SUM", list.result[i].AMT_TOT); //합계금액
                            fnObj.gridHeader.target.setValue(lastIdx - 1, "cdPartner", list.result[i].CD_PARTNER); //거래처코드
                            fnObj.gridHeader.target.setValue(lastIdx - 1, "lnPartner", list.result[i].LN_PARTNER); //거래처명
                            fnObj.gridHeader.target.setValue(lastIdx - 1, "remark", map.REMARKS); //거래처명
                            fnObj.gridHeader.target.setValue(lastIdx - 1, "dtTrans", datedash(list.result[i].YMD_WRITE)); //계산서일자
                            fnObj.gridHeader.target.setValue(lastIdx - 1, "NO_TAX", datedash(list.result[i].NO_TAX)); //매출세금계산서키값
                            fnObj.gridHeader.target.setValue(lastIdx - 1, "PARAM", datedash(list.result[i].ACCTENT_NO_TAX)); //매출세금계산서키값
                            fnObj.gridHeader.target.setValue(lastIdx - 1, "CD_EXCH", "000");
                            fnObj.gridHeader.target.setValue(lastIdx - 1, "NM_EXCH", "KRW");
                            fnObj.gridHeader.target.setValue(lastIdx - 1, "RT_EXCH", "1.00");
                            //fnObj.gridHeader.target.setValue(lastIdx - 1, "DT_INEND", list.result[i].DT_INEND.replace(/-/gi, ""));

                            fnObj.gridHeader.target.focus(lastIdx - 1);
                        }
                        _tabview.urlSetData(null);
                    }
                }
            };

            fnObj.pageButtonView = axboot.viewExtend({
                initView: function () {
                    axboot.buttonClick(this, "data-page-btn", {
                        "save": function () {
                            ACTIONS.dispatch(ACTIONS.PAGE_SAVE);
                        },
                        "docucopy": function () {
                            ACTIONS.dispatch(ACTIONS.DOCU_COPY);
                        }
                    });
                }
            });

            var ACTIONS = axboot.actionExtend(fnObj, {
                PAGE_SAVE: function (caller) {
                    //전표처리 액션

                    if (!$("#dtAcct").val() || $("#dtAcct").val() == "") {
                        qray.alert('회계일자를 입력하여 주십시오.');
                        return false;
                    }

                    if (!$("#cdDept").val() || $("#cdDept").val() == "") {
                        qray.alert('작성부서를 입력하여 주십시오.');
                        return false;
                    }

                    if (!$("#cdEmp").val() || $("#cdEmp").val() == "") {
                        qray.alert('작성사원을 입력하여 주십시오.');
                        return false;
                    }

                    if (!$("#NM_NOTE").val() || $("#NM_NOTE").val() == "") {
                        qray.alert('적요를 입력하여 주십시오.');
                        return false;
                    }

                    //마감월 체크로직
                    var param = {
                        CD_COMPANY: SCRIPT_SESSION.cdCompany
                        , DT_ACCT: $("#dtAcct").val().replace(/-/gi, "")
                        , CD_DOCU: "90"
                        , CD_DEPT: $("#cdDept").attr('code')
                        , DT_WRITE: ax5.util.date(new Date(), {"return": "yyyyMMdd"})
                    };
                    var result = $.DATA_SEARCH('commonutility', 'checkMagam', param);
                    if (result.map.CHECK_YN == 'Y') {
                        qray.alert('마감된 날짜입니다.');
                        return false;
                    }

                    //편익제공 체크
                    var chkVal = false;
                    var gridH = fnObj.gridHeader.target.list;
                    var temp_sumtot = 0;
                    var pcnt = 0;
                    var etcnt = 0;

                    if (!gridH || gridH.length == 0) {
                        qray.alert("전표내용이 없습니다.");
                        return false;
                    }
                    /*   CZ_Q_DOCU TP_GB 구하기.   */
                    var tp_gb, etcYn = 'N', BenefitsYn = 'N';
                    if (_etcdocuyn){    //  기타전표
                        for (var i = 0 ; i < gridH.length; i++){
                            if (gridH[i].cdDocu == '002' || gridH[i].cdDocu == '004' || gridH[i].cdDocu == '006'){
                                etcYn = 'Y'
                            }else if (gridH[i].cdDocu == '007'){
                                BenefitsYn = 'Y'
                            }
                        }
                        if (etcYn == 'Y' && BenefitsYn == 'Y'){
                            qray.alert('동일한 유형의 전표를 등록해야합니다.');
                            return false;
                        }else if (etcYn == 'Y' && BenefitsYn == 'N'){
                            tp_gb = '03'
                        }else if (etcYn == 'N' && BenefitsYn == 'Y'){
                            tp_gb = '07'
                        }
                    }else{
                        tp_gb = '01'
                    }
                    /*   CZ_Q_DOCU TP_GB 구하기.   */

                    var noTpdocuArr = [];
                    for (var i = 0; i < gridH.length; i++) {
                        noTpdocuArr.push(gridH[i].noTpdocu);
                        if (gridH[i].AMT_SUPPLY == 0) {
                            qray.alert('공급가액이 없습니다.');
                            return false;
                        }
                        if (gridH[i].cdDocu == "002") { //전표유형 002:편익
                            if (nvl(benefitList) == '') {
                                qray.alert('전표유형이 편익일때는 편익제공 내용을 입력하여 주십시오.');
                                return false;
                            }
                            pcnt++;
                            chkVal = true;      //  전표유형 002 편익인 row가 한 줄이라도 있다
                        } else {
                            etcnt++;
                        }
                        temp_sumtot += parseInt(uncomma(gridH[i].AMT_SUM));
                    }
                    var _noTpdocu = noTpdocuArr.join('|');

                    var count = 0;
                    axboot.ajax({
                        type: "POST",
                        url: ["gldocum", "getchkValidate"],
                        async: false,
                        data: JSON.stringify({
                            "NO_TPDOCU": _noTpdocu
                        }),
                        callback: function (res) {
                            count = res.map.COUNT;
                        }
                    });

                    if (count > 0) {
                        qray.alert('이미 전표처리된 데이터입니다.');
                        return false;
                    }

                    if (pcnt > 1) {
                        qray.alert('편익은 한 전표에 한 건만 등록가능합니다.');
                        return false;
                    }
                    if (pcnt > 0 && etcnt > 0) {
                        qray.alert('편익은 다른유형의 전표들과 같이 처리할 수 없습니다.');
                        return false;
                    }

                    if (!chkVal) {       //  편익제공 내용 등록한 후 삭제했을 경우 초기화해준다.
                        benefitList = [];
                    }
                    if (chkVal) {   //  전표유형 002 편익인 row가 한 줄이라도 있다
                        var benefit_sumtot = 0;
                        for (var i = 0; i < benefitList.length; i++) {
                            benefit_sumtot += Number(nvl(benefitList[i].AMT_USE, "0"))
                        }
                        if (temp_sumtot != benefit_sumtot) {        //  편익제공 합계금액과 전표등록 gridHeader 의 총합계금액 validate
                            qray.alert('합계금액과 편익제공 금액의 합이 다릅니다');
                            return false;
                        }
                    }

                    erroMsg = "";
                    var listH = fnObj.gridHeader.target.list;
                    for (var i = 0; i < listH.length; i++) {
                        if (!listH[i].cdDocu) {
                            erroMsg = "전표유형은 필수값입니다.";
                            break;
                        }

                        if (!listH[i].cdTpdocu) {
                            erroMsg = "지출유형은 필수값입니다.";
                            break;
                        }

                    }

                    if (erroMsg != "") {
                        dialog.alert({
                            theme: "danger",
                            title: "에러",
                            msg: erroMsg,
                            onStateChanged: function () {
                                if (this.state === "open") {
                                    mask.open({theme: "danger"});
                                } else if (this.state === "close") {
                                    mask.close();
                                }
                            }
                        });
                        return false;
                    }


                    if ($("#calc").val() != 0) {
                        qray.alert("차변 대변 금액이 다릅니다.");
                        return false;
                    }

                    var AMTH = gridValueSum(fnObj.gridHeader, "AMT_SUM");
                    var AMTL = gridValueSum(fnObj.gridDetailLeft, "amt");

                    if ((AMTH - AMTL) != 0) {
                        qray.alert("합계 금액이 차변, 대변과 다릅니다.");
                        return false;
                    }

                    var gridH = fnObj.gridHeader.target.list;
                    var gridL = fnObj.gridDetailLeft.target.list;
                    var gridR = fnObj.gridDetailRight.target.list;


                    for (var i = 0; i < gridH.length; i++) {
                        var amtleft = 0;
                        for (var k = 0; k < gridL.length; k++) {
                            if (gridH[i].noTpdocu == gridL[k].noTpdocu) {
                                amtleft += parseInt(gridL[k].amt);
                            }
                        }
                        var amtright = 0;
                        for (var k = 0; k < gridR.length; k++) {
                            if (gridH[i].noTpdocu == gridR[k].noTpdocu) {
                                amtright += parseInt(gridR[k].amt);
                            }
                        }
                        if (gridH[i].AMT_SUM != amtleft || gridH[i].AMT_SUM != amtright) {
                            qray.alert('라인별 합계금액이 다릅니다.');
                            return false;
                        }

                        // var tempvatsum = 0;
                        var left_sales_tax_no_count = 0; //  매출(세) 일 때 하나의 헤더그리드에 디테일그리드의 NO_TAX가 몇 번 있는 지 체크
                        var right_sales_tax_no_count = 0;
                        for (var k = 0; k < gridL.length; k++) {
                            if (gridH[i].noTpdocu == gridL[k].noTpdocu) {    //  NO_TPDOCU 가 같은 헤더, 디테일 그리드에서 부가세팝업에서 넘어온 값이 있다면
                                // tempvatsum += parseInt(nvl(gridL[k].VAT));
                                if (gridH[i].cdDocu == '005' && tax_code_dr.indexOf(gridL[i].cdAcct) > -1) {
                                    left_sales_tax_no_count++;
                                }
                            }
                        }
                        for (var k = 0; k < gridR.length; k++) {
                            if (gridH[i].noTpdocu == gridR[k].noTpdocu) {    //  NO_TPDOCU 가 같은 헤더, 디테일 그리드에서 부가세팝업에서 넘어온 값이 있다면
                                // tempvatsum += parseInt(nvl(gridR[k].VAT));
                                if (gridH[i].cdDocu == '005' && tax_code_cr.indexOf(gridR[k].cdAcct) > -1) {
                                    right_sales_tax_no_count++;
                                }
                            }
                        }
                        if (left_sales_tax_no_count > 1) {
                            qray.alert('[차변항목] 하나의 지출유형에 여러 건의 부가세를 입력하셨습니다.');
                            return false;
                        }
                        if (right_sales_tax_no_count > 1) {
                            qray.alert('[대변항목] 하나의 지출유형에 여러 건의 부가세를 입력하셨습니다.');
                            return false;
                        }
                        //  매출(세), 매입(세) 일 때 공급가액, 부가세는 변경할 수 없다.
                        //  부가세 세무구분이 불공제로 쳐야하는 경우 받아온 금액은 부가세가 0 이 아니지만, 불공때문에 차대변 부가세금액을 0으로 처리해야하는 경우가 있다.
                        //  결론 : 합계금액만을 validate 하며, 공급가액과 부가세는 동일한지 체크하지않는다.
                        /*if (gridH[i].AMT_VAT != tempvatsum) {
                           qray.alert("임시저장된 부가세금액과 현재설정된 부가세 금액이 다른항목이 있습니다.");
                           return false;
                       }*/

                    }

                    var temp_vat_tot = 0;

                    for (var i = 0; i < gridL.length; i++) {
                        if (gridL[i].OVER_AMT && gridL[i].OVER_AMT != "0") {
                            qray.alert("예산초과된 항목이 있습니다");
                            return false;
                        }

                        if (tax_code_recept.indexOf(gridL[i].cdAcct) > -1 && !gridL[i].ADDPARAM) {
                            qray.alert("접대비계정에 접대비내용을 등록하여 주십시오..");
                            return false;
                        }
                        // if (tax_code_recept.indexOf(gridL[i].cdAcct) > -1 && gridL[i].ADDPARAM && gridL[i].amt != gridL[i].TEMP_RECEPT) {
                        //     qray.alert("임시저장된 접대비금액과 현재설정된 접대비 금액이 다른항목이 있습니다.");
                        //     return false;
                        // }
                        if (tax_code_dr.indexOf(gridL[i].cdAcct) > -1 && !gridL[i].ADDPARAM) {
                            qray.alert("부가세계정에 부가세내용을 등록하여 주십시오.");
                            return false;
                        }

                        if (nvl(gridL[i].cdAcct,"") == "") {
                            qray.alert("계정은 필수항목 입니다");
                            return false;
                        }
                    }

                    for (var i = 0; i < gridR.length; i++) {
                        if (gridR[i].OVER_AMT && gridR[i].OVER_AMT != "0") {
                            qray.alert("예산초과된 항목이 있습니다");
                            return false;
                        }

                        if (tax_code_recept.indexOf(gridR[i].cdAcct) > -1 && !gridR[i].ADDPARAM) {
                            qray.alert("접대비계정에 접대비내용을 등록하여 주십시오..");
                            return false;
                        }

                        // if (tax_code_recept.indexOf(gridR[i].cdAcct) > -1 && gridL[i].ADDPARAM && gridR[i].amt != gridR[i].TEMP_RECEPT) {
                        //     qray.alert("임시저장된 접대비금액과 현재설정된 접대비 금액이 다른항목이 있습니다.");
                        //     return false;
                        // }

                        if (tax_code_cr.indexOf(gridR[i].cdAcct) > -1 && !gridR[i].ADDPARAM) {
                            qray.alert("부가세계정에 부가세내용을 등록하여 주십시오..");
                            return false;
                        }

                        if (nvl(gridR[i].cdAcct,"") == "") {
                            qray.alert("계정은 필수항목 입니다");
                            return false;
                        }
                    }


                    //관리항목체크
                    if (checkStMngd() == false) {
                        qray.alert("필수관리항목이 입력되지 않았습니다.");
                        return;
                    }

                    var header = [].concat(caller.gridHeader.getData("modified"));
                    //header = header.concat(caller.gridHeader.getData("deleted"));
                    var gridDetailLeft = [].concat(caller.gridDetailLeft.getData("modified"));
                    //gridDetailLeft = gridDetailLeft.concat(caller.gridDetailLeft.getData("deleted"));
                    var gridDetailRight = [].concat(caller.gridDetailRight.getData("modified"));
                    //gridDetailRight = gridDetailRight.concat(caller.gridDetailRight.getData("deleted"));

                    qray.confirm({
                        msg: "전표 처리하시겠습니까?"
                    }, function () {
                        if (this.key == "ok") {
                            axboot.ajax({
                                type: "PUT",
                                url: ["gldocum", "insert"],
                                data: JSON.stringify({
                                    "header": header,
                                    "gridDetailLeft": gridDetailLeft,
                                    "gridDetailRight": gridDetailRight,
                                    "cdDept": $("#cdDept").attr("code"),
                                    "cdEmp": $("#cdEmp").attr("code"),
                                    "dtAcct": $("#dtAcct").val().replace(/-/gi, ""),
                                    "remark": $("#NM_NOTE").val(), //DOCU 용 적요
                                    "benefitList": benefitList,     //  편익 array 들어옴.
                                    "tp_gb" : tp_gb,        //  유형
                                    "etcdocu": (_etcdocuyn == true ? "Y" : "N"),    //기타전표여부
                                    "file": {
                                        'gridData' : gridData_,
                                        'delete' : delete_
                                    }
                                }),
                                callback: function (res) {
                                    qray.alert("성공적으로 전표처리 되었습니다.").then(function(){
                                        sessionStorage.setItem("prevmenuid", "");
                                        _urlGetData = "";

                                        menuInfo = {
                                            menuId: "10506",
                                            id: "10506",
                                            menuNm: "전표조회상신관리",
                                            name: "전표관리",
                                            parentId: "5",
                                            progNm: "전표조회",
                                            progPh: "/jsp/ensys/gl/p_cz_q_gl_docu_s.jsp"
                                        };
                                        sessionStorage.setItem("prevmenuid", "10505");
                                        try {
                                            parent.fnObj.tabView.close("10506");
                                        } catch (e) {

                                        }
                                        parent.fnObj.tabView.urlSetData({GROUP_NUMBER: res.map["GROUP_NUMBER"]});

                                        parent.fnObj.tabView.open(menuInfo);

                                        /*      초기화 작업      */
                                        fnObj.gridHeader.clear();
                                        fnObj.gridDetailLeft.clear();
                                        fnObj.gridDetailRight.clear();
                                        var today = new Date();
                                        $("#dtAcct").val(ax5.util.date(today, {"return": "yyyy-MM-dd"})); //회계일자
                                        $("#cdDept").val(SCRIPT_SESSION.nmDept);
                                        $("#cdDept").attr("text", SCRIPT_SESSION.nmDept);
                                        $("#cdDept").attr("code", SCRIPT_SESSION.cdDept);
                                        $("#cdEmp").val(SCRIPT_SESSION.nmEmp);
                                        $("#cdEmp").attr("text", SCRIPT_SESSION.nmEmp);
                                        $("#cdEmp").attr("code", SCRIPT_SESSION.noEmp);
                                        $("#NM_NOTE").val('');
                                        $("#LEFT_GB_TAX").val('');
                                        $("#LEFT_AMOUNT_SUPPLY").val('');
                                        $("#LEFT_AM_SUPPLY").val('');
                                        $("#LEFT_TEMP_VAT").val('');
                                        $("#RIGHT_GB_TAX").val('');
                                        $("#RIGHT_AMOUNT_SUPPLY").val('');
                                        $("#RIGHT_AM_SUPPLY").val('');
                                        $("#RIGHT_TEMP_VAT").val('');
                                        _etcdocuyn = true;
                                        benefitList = [];
                                        gridData_ = []; delete_ = [];
                                        _LINENO = 0;
                                        $("#BtnHeaderExp")[0].disabled = false;
                                        $("#BtnHeaderAdd")[0].disabled = false;
                                        $("#BtnDocuCopy")[0].disabled = false;
                                        mode = '기타';
                                        actionRowIdx = 0;
                                        actionRowIdxR = 0;
                                        actionRowIdxL = 0;
                                        /*      초기화 작업      */
                                    });
                                    /*
                                    dialog.alert({
                                        title: "알림",
                                        msg: '성공적으로 전표처리 되었습니다.',
                                        onStateChanged: function () {
                                            if (this.state === "open") {
                                                mask.open();
                                            } else if (this.state === "close") {
                                                mask.close();
                                                sessionStorage.setItem("prevmenuid", "");
                                                _urlGetData = "";

                                                menuInfo = {
                                                    menuId: "10506",
                                                    id: "10506",
                                                    menuNm: "전표조회상신관리",
                                                    name: "전표관리",
                                                    parentId: "5",
                                                    progNm: "전표조회",
                                                    progPh: "/jsp/ensys/gl/p_cz_q_gl_docu_s.jsp"
                                                };
                                                sessionStorage.setItem("prevmenuid", "10505");
                                                try {
                                                    parent.fnObj.tabView.close("10506");
                                                } catch (e) {

                                                }
                                                parent.fnObj.tabView.urlSetData({GROUP_NUMBER: res.map["GROUP_NUMBER"]});

                                                parent.fnObj.tabView.open(menuInfo);
                                            }
                                        }
                                    });
                                    */
                                    /*      초기화 작업      */
                                    /*
                                    fnObj.gridHeader.clear();
                                    fnObj.gridDetailLeft.clear();
                                    fnObj.gridDetailRight.clear();
                                    var today = new Date();
                                    $("#dtAcct").val(ax5.util.date(today, {"return": "yyyy-MM-dd"})); //회계일자
                                    $("#cdDept").val(SCRIPT_SESSION.nmDept);
                                    $("#cdDept").attr("text", SCRIPT_SESSION.nmDept);
                                    $("#cdDept").attr("code", SCRIPT_SESSION.cdDept);
                                    $("#cdEmp").val(SCRIPT_SESSION.nmEmp);
                                    $("#cdEmp").attr("text", SCRIPT_SESSION.nmEmp);
                                    $("#cdEmp").attr("code", SCRIPT_SESSION.noEmp);
                                    $("#NM_NOTE").val('');
                                    $("#LEFT_GB_TAX").val('');
                                    $("#LEFT_AMOUNT_SUPPLY").val('');
                                    $("#LEFT_AM_SUPPLY").val('');
                                    $("#LEFT_TEMP_VAT").val('');
                                    $("#RIGHT_GB_TAX").val('');
                                    $("#RIGHT_AMOUNT_SUPPLY").val('');
                                    $("#RIGHT_AM_SUPPLY").val('');
                                    $("#RIGHT_TEMP_VAT").val('');
                                    _etcdocuyn = true;
                                    benefitList = [];
                                    _LINENO = 0;
                                    */
                                    /*      초기화 작업      */

                                }
                            });
                        }
                    });
                },
                DOCU_COPY: function (caller) {
                    //전표복사 액션
                    openDcopy();
                },
                HEADER_EXP: function (caller) {
                    var temprow = fnObj.gridHeader.target.list;
                    if (temprow.length == 0) {
                        qray.alert("상단을 먼저 추가하셔야합니다");
                        return;
                    }
                    var count = 0;
                    for (var i = 0; i < temprow.length; i++) {
                        if (temprow[i].cdDocu == '002') {
                            count++;
                        }
                    }
                    if (count > 1) {
                        qray.alert('편익은 한 전표에 한 건만 등록가능합니다.');
                        return false;
                    }

                    var chkVal = false;
                    var expIndex = 0;
                    for (var i = 0; i < temprow.length; i++) {
                        if (temprow[i].cdDocu == '002') {   //  전표유형 공통코드 002 : 편익
                            chkVal = true;
                            expIndex = i;       //  전표유형 편익인 row index
                            if (nvl(temprow[i].cdPartner) == '') {
                                qray.alert('전표유형이 편익인 비용처리건은 거래처가 필수입니다.');
                                return false;
                            }
                        }
                    }

                    if (!chkVal) {
                        qray.alert('전표유형 편익인 데이터가 없습니다.');
                        return false;
                    }

                    var temp_sumtot = 0;
                    for (var i = 0; i < temprow.length; i++) {
                        if (temprow[i].AMT_SUM)
                            temp_sumtot += parseInt(uncomma(temprow[i].AMT_SUM));
                    }

                    //편익제공
                    openExp(temprow[expIndex].cdPartner, temprow[expIndex].lnPartner, temp_sumtot);
                },
                HEADER_ADD: function (caller) {
                    // 상단 추가
                    var gridH = fnObj.gridHeader.target.list;

                    for (var i = 0; i < gridH.length; i++) {
                        if (nvl(gridH[i].cdTpdocu) == '' || nvl(gridH[i].AMT_SUM) == '') {
                            qray.alert("필수 값이 없는 항목이 있습니다. \n 입력후 추가하셔야합니다");
                            return;
                        }
                    }

                    caller.gridHeader.addRow();
                    var lastIdx = nvl(caller.gridHeader.target.list.length, caller.gridHeader.lastRow());

                    axboot.ajax({
                        type: "GET",
                        url: ["gldocum", "getTpDocu"],
                        async: false,
                        callback: function (res) {
                            if (nvl(res.map) != '') {
                                var lastIdx = nvl(caller.gridHeader.target.list.length, caller.gridHeader.lastRow());
                                caller.gridHeader.target.select(lastIdx - 1);
                                caller.gridHeader.target.setValue(lastIdx - 1, "noTpdocu", res.map.noTpdocu);
                                caller.gridHeader.target.setValue(lastIdx - 1, "LINENO", ++_LINENO);
                                caller.gridHeader.target.setValue(lastIdx - 1, "CD_EXCH", "000");
                                caller.gridHeader.target.setValue(lastIdx - 1, "NM_EXCH", "KRW");
                                caller.gridHeader.target.setValue(lastIdx - 1, "RT_EXCH", "1.00");
                                caller.gridHeader.target.focus(lastIdx - 1);
                            }
                        }
                    });
                },
                HEADER_DEvarE: function (caller) {
                    // caller.gridHeader.delRow("selected");

                    var list = caller.gridHeader.target.list;
                    var i = list.length;
                    while (i--) {
                        if (list[i][caller.gridHeader.target.config.columnKeys.selected]) {
                            var noTpdocu = list[i].noTpdocu;
                            caller.gridHeader.target.removeRow(i);

                            var listL = caller.gridDetailLeft.target.list;
                            var listR = caller.gridDetailRight.target.list;

                            var j = listL.length;
                            while (j--) {
                                if (listL[j].noTpdocu == noTpdocu) {
                                    caller.gridDetailLeft.target.removeRow(j);
                                }
                            }
                            j = null;

                            j = listR.length;
                            while (j--) {
                                if (listR[j].noTpdocu == noTpdocu) {
                                    caller.gridDetailRight.target.removeRow(j);
                                }
                            }
                            j = null;
                        }
                    }
                    i = null;
                },
                DETAIL_LEFT_ADD: function (caller) {
                    var temprow = fnObj.gridHeader.getData("selected")[0];
                    if (!temprow) {
                        qray.alert("상단을 먼저 추가하셔야합니다");
                        return;
                    }

                    var gridL = fnObj.gridDetailLeft.target.list;

                    for (var i = 0; i < gridL.length; i++) {
                        if (nvl(gridL[i].cdAcct) == '') {
                            qray.alert("계정이 없는 항목이 있습니다. \n 입력후 추가하셔야합니다");
                            return;
                        }
                    }

                    var addRowDefault;
                    addRowDefault = $.DATA_SEARCH('gldocum', 'ccAddRow', {
                        CD_DEPT: $("#cdDept").attr("code")
                    });
                    caller.gridDetailLeft.addRow();
                    var lastIdx = nvl(caller.gridDetailLeft.target.list.length, caller.gridDetailLeft.lastRow());
                    caller.gridDetailLeft.target.select(lastIdx - 1);
                    caller.gridDetailLeft.target.setValue(lastIdx - 1, "LINENO", temprow.LINENO);
                    caller.gridDetailLeft.target.setValue(lastIdx - 1, "noTpdocu", temprow.noTpdocu);
                    caller.gridDetailLeft.target.setValue(lastIdx - 1, "tpDrCr", "1");
                    caller.gridDetailLeft.target.setValue(lastIdx - 1, "cd_budget", addRowDefault.list[0].CD_BUDGET);
                    caller.gridDetailLeft.target.setValue(lastIdx - 1, "nm_budget", addRowDefault.list[0].NM_BUDGET);
                    caller.gridDetailLeft.target.setValue(lastIdx - 1, "tpEvidence", temprow.tpEvidence);
                    caller.gridDetailLeft.target.focus(lastIdx - 1);

                },
                DETAIL_LEFT_DEvarE: function (caller) {
                    caller.gridDetailLeft.delRow("selected");
                    calc();
                },
                DETAIL_RIGHT_ADD: function (caller) {
                    var temprow = fnObj.gridHeader.getData("selected")[0];
                    if (!temprow) {
                        qray.alert("상단을 먼저 추가하셔야합니다");
                        return;
                    }

                    var gridR = fnObj.gridDetailRight.target.list;

                    for (var i = 0; i < gridR.length; i++) {
                        if (nvl(gridR[i].cdAcct) == '') {
                            qray.alert("계정이 없는 항목이 있습니다. \n 입력후 추가하셔야합니다");
                            return;
                        }
                    }

                    var addRowDefault;
                    addRowDefault = $.DATA_SEARCH('gldocum', 'ccAddRow', {
                        CD_DEPT: $("#cdDept").attr("code")
                    });
                    caller.gridDetailRight.addRow();
                    var lastIdx = nvl(caller.gridDetailRight.target.list.length, caller.gridDetailRight.lastRow());
                    caller.gridDetailRight.target.select(lastIdx - 1);
                    caller.gridDetailRight.target.setValue(lastIdx - 1, "LINENO", temprow.LINENO);
                    caller.gridDetailRight.target.setValue(lastIdx - 1, "noTpdocu", temprow.noTpdocu);
                    caller.gridDetailRight.target.setValue(lastIdx - 1, "tpDrCr", "2");
                    caller.gridDetailRight.target.setValue(lastIdx - 1, "cd_budget", addRowDefault.list[0].CD_BUDGET);
                    caller.gridDetailRight.target.setValue(lastIdx - 1, "nm_budget", addRowDefault.list[0].NM_BUDGET);
                    caller.gridDetailRight.target.setValue(lastIdx - 1, "tpEvidence", temprow.tpEvidence);
                    caller.gridDetailRight.target.focus(lastIdx - 1);
                },
                DETAIL_RIGHT_DEvarE: function (caller) {
                    caller.gridDetailRight.delRow("selected");
                    calc();
                },
                FILE_UPLOAD: function(caller){
                    var temprow = fnObj.gridHeader.target.list;
                    if (temprow.length == 0) {
                        qray.alert("상단을 먼저 추가하셔야합니다");
                        return;
                    }

                    userCallBack = function(e){
                        console.log(e);
                        qray.alert('임시저장하였습니다.');
                        gridData_ = e.gridData;
                        delete_ = e.delete;

                        modal.close();
                    };

                    modal.open({
                        top: _pop_top,
                        width: 1000,
                        height: _pop_height,
                        iframe: {
                            method: "get",
                            url: "../../common/fileBrowser.jsp",
                            param: "callBack=userCallBack"
                        },
                        sendData: {
                            "P_BOARD_TYPE": '', // [ 모듈_메뉴명_해당ID값
                            "P_SEQ": '',
                            "imsiFile": {
                                gridData: gridData_,
                                delete: delete_
                            }
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

            /**
             * gridHeader 상단그리드
             */
            fnObj.gridHeader = axboot.viewExtend(axboot.gridView, {
                page: {
                    pageNumber: 0,
                    pageSize: 10
                },
                initView: function () {
                    var _this = this;

                    this.target = axboot.gridBuilder({
                        // showRowSelector: true, // check
                        frozenColumnIndex: 0,
                        target: $('[data-ax5grid="grid-header"]'),
                        virtualScrollX: true,
                        columns: [
                            {
                                key: "LINENO",
                                label: "순번",
                                width: 40,
                                align: "center",
                                editor: false,
                                hidden: false,
                                styleClass: function () {
                                    return "readonly";
                                }
                            },
                            {
                                key: "noTpdocu",
                                label: "h_noTpdocu고유번호",
                                width: 200,
                                align: "left",
                                editor: false,
                                hidden: true
                            },
                            {
                                key: "cdDocu", label: "전표유형", width: 80, align: "center",
                                formatter: function () {
                                    return $.changeTextValue(data_cdDocu, this.value);
                                }
                                , editor: {
                                    type: "select", config: {
                                        columnKeys: {
                                            optionValue: "CODE", optionText: "TEXT"
                                        },
                                        options: data_cdDocu

                                    },
                                    disabled: function () {
                                        if (mode == '매출') {
                                            return true;
                                        } else {
                                            return false;
                                        }
                                    }

                                },
                                styleClass: function () {
                                    return "red";
                                }
                            },
                            {
                                key: "cdTpdocu",
                                label: "h_지출유형",
                                width: 150,
                                align: "center",
                                editor: false,
                                hidden: true
                            },
                            {
                                key: "nmTpdocu",
                                label: "지출유형",
                                width: 150,
                                align: "center",
                                editor: {
                                    type: "text",
                                    /*disabled: function () {
                                        var cdDocu = fnObj.gridHeader.target.getList()[actionRowIdx].cdDocu;
                                        if (nvl(cdDocu) == '') {
                                            return true;
                                        } else {
                                            return false;
                                        }
                                    }*/
                                },
                                picker: {
                                    top: _pop_top,
                                    width: 600,
                                    height: _pop_height,
                                    url: "tpdocu",
                                    action: ["customHelp", "CUSTOM_HELP_TPDOCU"],
                                    param: function () {
                                        return {
                                            "CD_DOCU": fnObj.gridHeader.target.getList()[actionRowIdx].cdDocu,
                                            "CD_DEPT": $("#cdDept").attr('code')
                                        }
                                    },
                                    disabled: function () {
                                        var cdDocu = fnObj.gridHeader.target.getList()[actionRowIdx].cdDocu;
                                        if (nvl(cdDocu) == '') {
                                            qray.alert("전표유형을 선택하여 주십시오");
                                            return true;
                                        } else {
                                            return false;
                                        }
                                    },
                                    callback: function (e) {
                                        var cdDocu = fnObj.gridHeader.target.getList()[actionRowIdx].cdDocu;
                                        var noTpdocu = fnObj.gridHeader.target.getList()[actionRowIdx].noTpdocu;
                                        var tpEvidence = fnObj.gridHeader.target.getList()[actionRowIdx].tpEvidence;    //  증빙유형
                                        var lineno = fnObj.gridHeader.target.getList()[actionRowIdx].LINENO;
                                        var noTax = fnObj.gridHeader.target.getList()[actionRowIdx].PARAM;      //  매출세금계산서에서 넘어온 NO_TAX [ ACCTENT 테이블 ]

                                        var listL = fnObj.gridDetailLeft.target.list;
                                        var listR = fnObj.gridDetailRight.target.list;

                                        var j = listL.length;
                                        while (j--) {
                                            if (listL[j].noTpdocu == noTpdocu) {
                                                fnObj.gridDetailLeft.target.removeRow(j);
                                            }
                                        }
                                        j = null;

                                        j = listR.length;
                                        while (j--) {
                                            if (listR[j].noTpdocu == noTpdocu) {
                                                fnObj.gridDetailRight.target.removeRow(j);
                                            }
                                        }
                                        j = null;

                                        fnObj.gridHeader.target.setValue(actionRowIdx, "cdTpdocu", e[0].CD_TPDOCU);
                                        fnObj.gridHeader.target.setValue(actionRowIdx, "nmTpdocu", e[0].NM_TPDOCU);

                                        axboot.ajax({
                                            type: "GET",
                                            url: ["gldocum", "tpdocuAcct"],
                                            async: false,
                                            data: {
                                                P_CD_TPDOCU: e[0].CD_TPDOCU,
                                                P_CD_DOCU: cdDocu
                                            },
                                            callback: function (res) {
                                                var addRowDefault;
                                                addRowDefault = $.DATA_SEARCH('gldocum', 'ccAddRow', {
                                                    CD_DEPT: $("#cdDept").attr("code")
                                                });
                                                //지출유형 선택시 하단그리드입력
                                                for (var i = 0; i < res.list.length; i++) {
                                                    var obj = res.list[i];
                                                    if (obj.TP_DRCR == "1") {
                                                        fnObj.gridDetailLeft.addRow();
                                                        var lastIdx = nvl(fnObj.gridDetailLeft.target.list.length, fnObj.gridDetailLeft.lastRow());
                                                        fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "tpDrCr", obj.TP_DRCR);
                                                        fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "LINENO", lineno);
                                                        fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "noTpdocu", noTpdocu);
                                                        fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "cdAcct", obj.CD_ACCT);
                                                        fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "nmAcct", obj.NM_ACCT);
                                                        fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "cd_budget", addRowDefault.list[0].CD_BUDGET);
                                                        fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "nm_budget", addRowDefault.list[0].NM_BUDGET);
                                                        fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "tpEvidence", tpEvidence);
                                                        fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "remark", obj.NM_DESC);

                                                        var data = $.DATA_SEARCH('apbucard', 'bgacctSetting', {
                                                            CD_ACCT: obj.CD_ACCT,
                                                            CD_BUDGET: addRowDefault.list[0].CD_BUDGET
                                                        });
                                                        if (data.list.length > 0) {
                                                            fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "NM_BGACCT", data.list[0].NM_BGACCT);
                                                            fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "CD_BGACCT", data.list[0].CD_BGACCT);
                                                        } else {
                                                            fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "NM_BGACCT", '');
                                                            fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "CD_BGACCT", '');
                                                        }
                                                        fnObj.gridDetailLeft.target.focus(lastIdx - 1);
                                                        setStMngd(obj.CD_ACCT, "1", lastIdx - 1);

                                                        /*   CZ_Q_FI_TAX 에서 임시저장된 부가세 정보 가져오기 [ 세무구분, 공급대가, 공급가액, 부가세액 ]   */
                                                        if (tax_code_dr.indexOf(obj.CD_ACCT) > -1) {
                                                            fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "ADDPARAM", noTax);
                                                            var result = $.DATA_SEARCH_GET('predocu', 'search_fi_tax2', {
                                                                no_tax: noTax
                                                            });
                                                            if (Object.keys(result).length > 0) {
                                                                fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "TEMP_VAT", comma(result.AM_ADDTAX));
                                                                fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "GB_TAX", result.TP_TAX);
                                                                fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "AMOUNT_SUPPLY", comma(result.AM_UNCLT));
                                                                fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "AM_SUPPLY", comma(result.AM_TAXSTD));

                                                                for (var j = 1 ; j < 9; j++){
                                                                    if (fnObj.gridDetailLeft.target.getList()[lastIdx - 1]["CD_MNG" + j] == "C14") {   //  세무구분
                                                                        fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "CD_MNGD" + j, result.TP_TAX);
                                                                        fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "NM_MNGD" + j, $.changeTextValue(fg_taxApproveData, result.TP_TAX));
                                                                    }
                                                                }
                                                            }
                                                        }
                                                        /*   CZ_Q_FI_TAX 에서 임시저장된 부가세 정보 가져오기 [ 세무구분, 공급대가, 공급가액, 부가세액 ]   */

                                                    } else if (obj.TP_DRCR == "2") {
                                                        fnObj.gridDetailRight.addRow();
                                                        var lastIdx = nvl(fnObj.gridDetailRight.target.list.length, fnObj.gridDetailRight.lastRow());
                                                        fnObj.gridDetailRight.target.setValue(lastIdx - 1, "tpDrCr", obj.TP_DRCR);
                                                        fnObj.gridDetailRight.target.setValue(lastIdx - 1, "LINENO", lineno);
                                                        fnObj.gridDetailRight.target.setValue(lastIdx - 1, "noTpdocu", noTpdocu);
                                                        fnObj.gridDetailRight.target.setValue(lastIdx - 1, "cdAcct", obj.CD_ACCT);
                                                        fnObj.gridDetailRight.target.setValue(lastIdx - 1, "nmAcct", obj.NM_ACCT);
                                                        fnObj.gridDetailRight.target.setValue(lastIdx - 1, "cd_budget", addRowDefault.list[0].CD_BUDGET);
                                                        fnObj.gridDetailRight.target.setValue(lastIdx - 1, "nm_budget", addRowDefault.list[0].NM_BUDGET);
                                                        fnObj.gridDetailRight.target.setValue(lastIdx - 1, "tpEvidence", tpEvidence);
                                                        fnObj.gridDetailRight.target.setValue(lastIdx - 1, "remark", obj.NM_DESC);

                                                        var data = $.DATA_SEARCH('apbucard', 'bgacctSetting', {
                                                            CD_ACCT: obj.CD_ACCT,
                                                            CD_BUDGET: addRowDefault.list[0].CD_BUDGET
                                                        });
                                                        if (data.list.length > 0) {
                                                            fnObj.gridDetailRight.target.setValue(lastIdx - 1, "NM_BGACCT", data.list[0].NM_BGACCT);
                                                            fnObj.gridDetailRight.target.setValue(lastIdx - 1, "CD_BGACCT", data.list[0].CD_BGACCT);
                                                        } else {
                                                            fnObj.gridDetailRight.target.setValue(lastIdx - 1, "NM_BGACCT", '');
                                                            fnObj.gridDetailRight.target.setValue(lastIdx - 1, "CD_BGACCT", '');
                                                        }
                                                        fnObj.gridDetailRight.target.focus(lastIdx - 1);
                                                        setStMngd(obj.CD_ACCT, "2", lastIdx - 1);

                                                        /*   CZ_Q_FI_TAX 에서 임시저장된 부가세 정보 가져오기 [ 세무구분, 공급대가, 공급가액, 부가세액 ]   */
                                                        if (tax_code_cr.indexOf(obj.CD_ACCT) > -1) {
                                                            fnObj.gridDetailRight.target.setValue(lastIdx - 1, "ADDPARAM", noTax);
                                                            var result = $.DATA_SEARCH_GET('predocu', 'search_fi_tax2', {
                                                                no_tax: noTax
                                                            });
                                                            if (Object.keys(result).length > 0) {
                                                                fnObj.gridDetailRight.target.setValue(lastIdx - 1, "TEMP_VAT", comma(result.AM_ADDTAX));
                                                                fnObj.gridDetailRight.target.setValue(lastIdx - 1, "GB_TAX", result.TP_TAX);
                                                                fnObj.gridDetailRight.target.setValue(lastIdx - 1, "AMOUNT_SUPPLY", comma(result.AM_UNCLT));
                                                                fnObj.gridDetailRight.target.setValue(lastIdx - 1, "AM_SUPPLY", comma(result.AM_TAXSTD));

                                                                for (var j = 1 ; j < 9; j++){
                                                                    if (fnObj.gridDetailRight.target.getList()[lastIdx - 1]["CD_MNG" + j] == "C14") {   //  세무구분
                                                                        fnObj.gridDetailRight.target.setValue(lastIdx - 1, "CD_MNGD" + j, result.TP_TAX);
                                                                        fnObj.gridDetailRight.target.setValue(lastIdx - 1, "NM_MNGD" + j, $.changeTextValue(fg_taxApproveData, result.TP_TAX));
                                                                    }
                                                                }
                                                            }
                                                        }
                                                        /*   CZ_Q_FI_TAX 에서 임시저장된 부가세 정보 가져오기 [ 세무구분, 공급대가, 공급가액, 부가세액 ]   */
                                                    }
                                                }

                                                //자동으로 들어갈수있는 관리항목들은 자동으로 들어가게 세팅
                                                var tempemp = $("#cdEmp").attr("code");
                                                var temppartner = fnObj.gridHeader.target.getList()[actionRowIdx]["cdPartner"];
                                                var tempdt = nvl($("#dtAcct").val()).replace(/-/gi, "");
                                                var tempnotpdocu = fnObj.gridHeader.target.getList()[actionRowIdx]["noTpdocu"];
                                                var tempamt = fnObj.gridHeader.target.getList()[actionRowIdx]["AMT_SUPPLY"];
                                                var tempvat = fnObj.gridHeader.target.getList()[actionRowIdx]["AMT_VAT"];
                                                var tempsum = fnObj.gridHeader.target.getList()[actionRowIdx]["AMT_SUM"];
                                                var tempcddocu = fnObj.gridHeader.target.getList()[actionRowIdx]["cdDocu"];
                                                //사원코드,거래처코드,날짜,금액,키값명칭,키값
                                                getAutoMngd(tempemp, temppartner, tempdt, tempamt, "noTpdocu", tempnotpdocu);
                                                //하단그리드 금액자동세팅
                                                setamtline(fnObj.gridHeader.target.getList()[actionRowIdx]);
                                            }
                                        });
                                    },
                                },
                                styleClass: function () {
                                    return "red";
                                }
                            },
                            {
                                key: "tpEvidence", label: "증빙유형", width: 120, align: "left",
                                formatter: function () {
                                    return $.changeTextValue(data_tpEvidence, this.value);
                                }
                                , editor: {
                                    type: "select", config: {
                                        columnKeys: {
                                            optionValue: "CODE", optionText: "TEXT"
                                        },
                                        options: data_tpEvidence

                                    }
                                }
                            },
                            {
                                key: "cdPartner",
                                label: "h_거래처코드",
                                width: 150,
                                align: "left",
                                editor: false,
                                hidden: true
                            },
                            {
                                key: "lnPartner", label: "거래처", width: 150, align: "left",
                                editor: {
                                    type: "text",
                                    disabled: function () {
                                        var cdDocu = fnObj.gridHeader.target.getList()[actionRowIdx].cdDocu;
                                        if (nvl(cdDocu) == '') {
                                            return true;
                                        } else {
                                            return false;
                                        }
                                    }
                                },
                                picker: {
                                    top: _pop_top,
                                    width: 600,
                                    height: _pop_height,
                                    url: "partner",
                                    action: ["commonHelp", "HELP_PARTNER"],
                                    callback: function (e) {
                                        fnObj.gridHeader.target.setValue(actionRowIdx, "cdPartner", e[0].CD_PARTNER);
                                        fnObj.gridHeader.target.setValue(actionRowIdx, "lnPartner", e[0].LN_PARTNER);
                                    },
                                    disabled: function () {
                                        var cdDocu = fnObj.gridHeader.target.getList()[actionRowIdx].cdDocu;
                                        if (nvl(cdDocu) == '') {
                                            return true;
                                        } else {
                                            return false;
                                        }
                                    }
                                }
                            },
                            {
                                key: "dtTrans", label: "계산서일자", width: 80, align: "center", editor: {
                                    type: "date",
                                    config: {
                                        content: {
                                            config: {
                                                mode: "day", selectMode: "day"
                                            }
                                        }
                                    }
                                }
                            },
                            {key: "remark", label: "적요", width: 200, align: "left", editor: {type: "text"}},
                            {
                                key: "CD_EXCH",
                                label: "환종",
                                width: 100,
                                align: "center",
                                editor: false,
                                hidden: true
                            },
                            {
                                key: "NM_EXCH",
                                label: "환종",
                                width: 100,
                                align: "left",
                                hidden: false,
                                editor: {
                                    type: "text",
                                    disabled: function () {
                                        var cdDocu = fnObj.gridHeader.target.getList()[actionRowIdx].cdDocu;
                                        if (nvl(cdDocu) == '') {
                                            return true;
                                        } else {
                                            return false;
                                        }
                                    }
                                },
                                picker: {
                                    top: _pop_top,
                                    width: 600,
                                    height: _pop_height,
                                    url: "anticipation",
                                    action: ["commonHelp", "HELP_ANTICIPATION"],
                                    callback: function (e) {
                                        fnObj.gridHeader.target.setValue(actionRowIdx, "CD_EXCH", e[0].CD_SYSDEF);
                                        fnObj.gridHeader.target.setValue(actionRowIdx, "NM_EXCH", e[0].NM_SYSDEF);
                                    },
                                    disabled: function () {
                                        var cdDocu = fnObj.gridHeader.target.getList()[actionRowIdx].cdDocu;
                                        if (nvl(cdDocu) == '') {
                                            return true;
                                        } else {
                                            return false;
                                        }
                                    }
                                }
                            },
                            {
                                key: "RT_EXCH",
                                label: "환율",
                                width: 100,
                                align: "center",
                                editor: {
                                    type: "number",
                                    disabled: function () {
                                        var CD_EXCH = this.item.CD_EXCH;
                                        if (nvl(CD_EXCH, '') == '' || CD_EXCH == '000') {
                                            return true;
                                        } else {
                                            return false;
                                        }
                                    }
                                },
                                formatter: function () {
                                    var value = this.item.RT_EXCH;
                                    if (value == '') {
                                        value = 0;
                                    }
                                    this.item.RT_EXCH = value;
                                    return value;
                                },
                                hidden: false
                            },

                            {
                                key: "AMT_LOCAL",
                                label: "외화금액",
                                width: 100,
                                align: "right",
                                editor: {type: "number",},
                                hidden: false,
                                formatter: function () {
                                    var value = this.item.AMT_LOCAL;
                                    if (value == '') {
                                        value = 0;
                                    }
                                    this.item.AMT_LOCAL = value;
                                    return ax5.util.number(value, {"money": true});
                                }
                            },
                            {
                                key: "AMT_SUPPLY",
                                label: "공급가액",
                                width: 150,
                                align: "right",
                                editor: {
                                    type: "number",
                                    disabled: function () {
                                        if (mode == '매입' || mode == '매출') {
                                            return true;
                                        } else {
                                            return false;
                                        }
                                    }
                                },
                                formatter: function () {
                                    var value = this.item.AMT_SUPPLY;
                                    if (value == '') {
                                        value = 0;
                                    }
                                    this.item.AMT_SUPPLY = value;
                                    return ax5.util.number(value, {"money": true});
                                },
                                styleClass: function () {
                                    return "red";
                                }
                            },
                            {
                                key: "AMT_VAT",
                                label: "부가세",
                                width: 150,
                                align: "right",
                                editor: {
                                    type: "number",
                                    disabled: function () {
                                        if (mode == '매입' || mode == '매출') {
                                            return true;
                                        } else {
                                            return false;
                                        }
                                    }
                                },
                                formatter: function () {
                                    var value = this.item.AMT_VAT;
                                    if (value == '') {
                                        value = 0;
                                    }
                                    this.item.AMT_VAT = value;
                                    return ax5.util.number(value, {"money": true});
                                },
                                styleClass: function () {
                                    return "red";
                                }
                            },
                            {
                                key: "AMT_SUM",
                                label: "합계금액",
                                width: 150,
                                align: "right",
                                editor: false,
                                formatter: "money"
                                , styleClass: function () {
                                    return "readonly";
                                }
                            },
                            {
                                key: "NO_TAX",  //  PUSAIV 테이블 NO_TAX
                                label: "h_NO_TAX매입세금계산서",
                                width: 150,
                                align: "left",
                                editor: false,
                                hidden: true
                            },
                            {
                                key: "PARAM",   //  매출선발행 부가세팝업에서 넘어온 ACCTENT 테이블 NO_TAX
                                label: "h_NO_TAX매입세금계산서",
                                width: 150,
                                align: "left",
                                editor: false,
                                hidden: true
                            },
                            {
                                key: "DT_INEND",   //  관리항목에서 자금예정일자 가져와서 박아둠.
                                label: "자금예정일자",
                                width: 150,
                                align: "left",
                                editor: false,
                                hidden: true
                            },
                        ],
                        body: {
                            onClick: function () {
                                actionRowIdx = this.dindex;
                                if (this.column.key == "FG_TAX") {
                                    for (var i = 0; i < fnObj.gridHeader.target.config.columns.length; i++) {
                                        if (fnObj.gridHeader.target.config.columns[i].key == "FG_TAX") {
                                            if (this.list[this.dindex].cdDocu == "001") {
                                                fnObj.gridHeader.target.config.columns[i].editor.config.options = data_purch;
                                            } else if (this.list[this.dindex].cdDocu == "005") {
                                                fnObj.gridHeader.target.config.columns[i].editor.config.options = data_sales;
                                            } else {
                                                fnObj.gridHeader.target.config.columns[i].editor.config.options = [];
                                            }
                                            break;
                                        }
                                    }

                                }
                                this.self.focus(this.dindex);
                            },
                            onDBLClick: function () {
                                actionRowIdx = this.dindex;
                            },
                            onDataChanged: function () {
                                if (this.key == 'tpEvidence') {
                                    var listL = fnObj.gridDetailLeft.target.list;
                                    var i = listL.length;
                                    while (i--) {
                                        if (listL[i].noTpdocu == this.item.noTpdocu) {
                                            fnObj.gridDetailLeft.target.setValue(i, "tpEvidence", this.value);
                                        }
                                    }
                                    i = null;

                                    var listR = fnObj.gridDetailRight.target.list;
                                    var i = listR.length;
                                    while (i--) {
                                        if (listR[i].noTpdocu == this.item.noTpdocu) {
                                            fnObj.gridDetailRight.target.setValue(i, "tpEvidence", this.value);
                                        }
                                    }
                                    i = null;
                                }
                                if (this.key == 'CD_EXCH') { //환종변경시 ( 회계일자 변경시도 이벤트 똑같이 넣어줘야함)
                                    if (nvl($("#dtAcct").val()).replace(/-/gi, "") != '' && nvl(this.item.CD_EXCH) != '') {
                                        var data = $.DATA_SEARCH('gldocum', 'getRtExch', {
                                            DT_TARGET: nvl($("#dtAcct").val()).replace(/-/gi, ""),
                                            CD_EXCH: this.item.CD_EXCH
                                        });

                                        fnObj.gridHeader.target.setValue(this.dindex, "RT_EXCH", data.map.RT_EXCH);
                                        if (nvl(this.item.AMT_LOCAL).trim() != '' && nvl($("#dtAcct").val()).replace(/-/gi, "") != '' && nvl(this.item.CD_EXCH) != '')
                                            fnObj.gridHeader.target.setValue(this.dindex, "AMT_SUPPLY", (parseInt(this.item.AMT_LOCAL) * parseInt(this.item.RT_EXCH)));
                                    } else {
                                        fnObj.gridHeader.target.setValue(this.dindex, "RT_EXCH", 0);
                                    }
                                }
                                if (this.key == 'RT_EXCH') { // 환율변경시
                                    if (nvl(this.item.AMT_LOCAL).trim() != '') {
                                        fnObj.gridHeader.target.setValue(this.dindex, "AMT_SUPPLY", (parseInt(this.value) * parseInt(this.item.AMT_LOCAL)));
                                    }
                                }
                                if (this.key == 'AMT_LOCAL') { //외화금액 변경시 원화공급가에 계산해서 넣어줌
                                    if (nvl($("#dtAcct").val()).replace(/-/gi, "") != '' && nvl(this.item.CD_EXCH) != '') {
                                        fnObj.gridHeader.target.setValue(this.dindex, "AMT_SUPPLY", (parseInt(this.value) * parseInt(this.item.RT_EXCH)));
                                    }
                                }

                                if (this.key == 'cdDocu') {
                                    var noTpdocu = fnObj.gridHeader.target.list[this.dindex].noTpdocu;

                                    var listL = fnObj.gridDetailLeft.target.list;
                                    var listR = fnObj.gridDetailRight.target.list;

                                    var j = listL.length;
                                    while (j--) {
                                        if (listL[j].noTpdocu == noTpdocu) {
                                            fnObj.gridDetailLeft.target.removeRow(j);
                                        }
                                    }
                                    j = null;

                                    j = listR.length;
                                    while (j--) {
                                        if (listR[j].noTpdocu == noTpdocu) {
                                            fnObj.gridDetailRight.target.removeRow(j);
                                        }
                                    }
                                    j = null;

                                    fnObj.gridHeader.target.setValue(this.dindex, "cdTpdocu", '');
                                    fnObj.gridHeader.target.setValue(this.dindex, "nmTpdocu", '');

                                    if (mode == '매출') {
                                        $("#BtnHeaderExp")[0].disabled = true;
                                        $("#BtnHeaderAdd")[0].disabled = true;
                                        $("#BtnDocuCopy")[0].disabled = true;
                                    }
                                    if (mode == '매입') {
                                        $("#BtnHeaderAdd")[0].disabled = true;
                                        $("#BtnDocuCopy")[0].disabled = true;
                                    }
                                }
                                //부가세를 임시저장한후 상단의 부가세를 변경하고 전표처리해버리면 임시저장한값과 전표의 부가세값이 달라지는 문제가 생기기때문에
                                //fnObj.gridDetailLeft.target.setValue(i, "amt", this.value); 부분(자동으로 값을넣어주는 부분) 을 주석처리함

                                //금액을 자동으로 넣어주려면 부가세 팝업에서 부가세 금액을 리턴해서 그값을 부가세라인의 특정 컬럼에 넣어서
                                //부가세 라인의 금액과 비교해서 값이 다르면 전표처리안되게 해야함

                                //금액,부가세,합계금액 변경시 합계값,하단그리드 금액등 세팅
                                if (this.key == "AMT_SUPPLY") {

                                    var tempindex = this.dindex;
                                    var tempvat = fnObj.gridHeader.getData("selected")[0];
                                    fnObj.gridHeader.target.setValue(tempindex, "AMT_SUM", Number(this.value) + Number(nvl(tempvat.AMT_VAT, 0)));

                                    setamtline(fnObj.gridHeader.getData("selected")[0]);

                                } else if (this.key == "AMT_VAT") { //부가세
                                    var tempvat = fnObj.gridHeader.getData("selected")[0];
                                    fnObj.gridHeader.target.setValue(this.dindex, "AMT_SUM", Number(this.value) + Number(nvl(tempvat.AMT_SUPPLY, 0)));
                                    setamtline(fnObj.gridHeader.getData("selected")[0]);
                                } else if (this.key == "AMT_SUM") { //합계금액
                                    setamtline(fnObj.gridHeader.getData("selected")[0]);
                                } else if (this.key == "remark") { //적요
                                    /*
                                    var listL = fnObj.gridDetailLeft.target.list;
                                    var i = listL.length;
                                    while (i--) {
                                        if (listL[i].noTpdocu == this.item.noTpdocu) {
                                            fnObj.gridDetailLeft.target.setValue(i, "remark", this.value);
                                        }
                                    }
                                    listR = fnObj.gridDetailRight.target.list;
                                    i = listR.length;
                                    while (i--) {
                                        if (listR[i].noTpdocu == this.item.noTpdocu) {
                                            fnObj.gridDetailRight.target.setValue(i, "remark", this.value);
                                        }
                                    }
                                    i = null;
                                    */
                                }

                                if (this.key == "cdPartner" || this.key == "dtTrans" || this.key == "AMT_SUPPLY") {
                                    var actionRowIdx = this.dindex;
                                    //자동으로 들어갈수있는 관리항목들은 자동으로 들어가게 세팅
                                    var tempemp = $("#cdEmp").attr("code");
                                    var temppartner = fnObj.gridHeader.target.getList()[actionRowIdx]["cdPartner"];
                                    var tempdt = nvl($("#dtAcct").val()).replace(/-/gi, "");
                                    var tempnotpdocu = fnObj.gridHeader.target.getList()[actionRowIdx]["noTpdocu"];
                                    var tempamt = fnObj.gridHeader.target.getList()[actionRowIdx]["AMT_SUPPLY"];
                                    var tempvat = fnObj.gridHeader.target.getList()[actionRowIdx]["AMT_VAT"];
                                    var tempsum = fnObj.gridHeader.target.getList()[actionRowIdx]["AMT_SUM"];
                                    var tempcddocu = fnObj.gridHeader.target.getList()[actionRowIdx]["cdDocu"];
                                    //사원코드,거래처코드,날짜,금액,키값명칭,키값
                                    getAutoMngd(tempemp, temppartner, tempdt, tempamt, "noTpdocu", tempnotpdocu);
                                }

                            }
                        },
                        onPageChange: function (pageNumber) {
                            _this.setPageData({pageNumber: pageNumber});
                            ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                        },
                        page: { //그리드아래 목록개수보여주는부분 숨김
                            display: false,
                            statusDisplay: false
                        }
                    });

                    axboot.buttonClick(this, "data-grid-header-btn", {
                        "add": function () {
                            ACTIONS.dispatch(ACTIONS.HEADER_ADD);
                        },
                        "devare": function () {
                            var beforeIdx = this.target.selectedDataIndexs[0];
                            var dataLen = this.target.getList().length;

                            if ((beforeIdx + 1) == dataLen) {
                                beforeIdx = beforeIdx - 1;
                            }

                            ACTIONS.dispatch(ACTIONS.HEADER_DEvarE);
                            if (beforeIdx > 0 || beforeIdx == 0) {
                                this.target.select(beforeIdx);
                            }
                        },
                        "exp": function () {
                            ACTIONS.dispatch(ACTIONS.HEADER_EXP);
                        },
                        "file": function() {
                            //BtnHeaderFile
                            ACTIONS.dispatch(ACTIONS.FILE_UPLOAD)
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

                    this.target.addRow({
                        __created__: true,
                        tpEvidence: "01",
                        AMT_SUPPLY: 0,
                        AMT_VAT: 0,
                        AMT_SUM: 0
                    }, "last");
                },
                lastRow: function () {
                    return ($("div [data-ax5grid='grid-header']").find("div [data-ax5grid-panel='body'] table tr").length)
                },
                getSelectRow: function () {
                    return actionRowIdx;
                }
            });

            fnObj.gridDetailLeft = axboot.viewExtend(axboot.gridView, {
                page: {
                    pageNumber: 0,
                    pageSize: 10
                },
                initView: function () {
                    var _this = this;

                    this.target = axboot.gridBuilder({
                        //showRowSelector: true,
                        frozenColumnIndex: 0,
                        target: $('[data-ax5grid="grid-detail-left"]'),
                        virtualScrollX: true,
                        columns: [
                            {
                                key: "LINENO",
                                label: "순번",
                                width: 40,
                                align: "left",
                                editor: false,
                                hidden: false,
                                styleClass: function () {
                                    return "readonly";
                                }
                            },
                            {
                                key: "tpDrCr", label: "h_차대구분", width: 150, align: "center", formatter: function () {
                                    return $.changeTextValue(data_drcr, this.value);
                                },
                                hidden: true
                                , editor: {
                                    type: "select", config: {
                                        columnKeys: {
                                            optionValue: "CODE", optionText: "TEXT"
                                        },
                                        options: data_drcr

                                    }
                                }
                            },
                            {
                                key: "noTpdocu",
                                label: "h_noTpdocu고유번호",
                                width: 200,
                                align: "left",
                                editor: false,
                                hidden: true
                            },
                            {
                                key: "cdAcct",
                                label: "계정코드",
                                width: 80,
                                align: "center",
                                editor: {
                                    type: "text",
                                    disabled: function () {
                                        var cdDocu = fnObj.gridHeader.target.getList()[actionRowIdx].cdDocu;
                                        if (nvl(cdDocu) == '') {
                                            return true;
                                        } else {
                                            return false;
                                        }
                                    }
                                },
                                picker: {
                                    top: _pop_top,
                                    width: 600,
                                    height: _pop_height,
                                    url: "acct",
                                    action: ["commonHelp", "HELP_ACCT"],
                                    param: function () {
                                        var noTpdocu = fnObj.gridDetailLeft.target.getList()[actionRowIdxL].noTpdocu;
                                        var listH = fnObj.gridHeader.target.getList();
                                        var i = listH.length;
                                        var item;
                                        while (i--) {
                                            if (listH[i].noTpdocu == noTpdocu) {
                                                console.log(listH[i]);
                                                item = listH[i];
                                                break;
                                            }
                                        }
                                        if (item.cdDocu == '004' || item.cdDocu == '008' || item.cdDocu == '009') {   //  전표유형이 기타,반제일 때는 차대구분 없이 모든 계정을 조회한다.
                                            //전표유형이 기타,반제일때는 프로시저 매개변수의 TP_DRCR 을 '' 으로넣어준다
                                            return {
                                                TP_DRCR: ''
                                            }
                                        }
                                        else{
                                            //전표유형이 기타,반제가 아닐때는 프로시저 매개변수의 TP_DRCR 을 선택한 차변,대변 구분코드로 넣어준다
                                            return {
                                                TP_DRCR: 1
                                            }
                                        }
                                    },
                                    callback: function (e) {
                                        fnObj.gridDetailLeft.target.setValue(fnObj.gridDetailLeft.getData("selected")[0].__index, "cdAcct", e[0].CD_ACCT);
                                        fnObj.gridDetailLeft.target.setValue(fnObj.gridDetailLeft.getData("selected")[0].__index, "nmAcct", e[0].NM_ACCT);
                                    },
                                    disabled: function () {
                                        var cdDocu = fnObj.gridHeader.target.getList()[actionRowIdx].cdDocu;
                                        if (nvl(cdDocu) == '') {
                                            return true;
                                        } else {
                                            return false;
                                        }
                                    }
                                },
                                styleClass: function () {
                                    return "red";
                                }
                            },
                            {
                                key: "nmAcct",
                                label: "계정명",
                                width: 150,
                                align: "center",
                                editor: false,
                                styleClass: function () {
                                    return "readonly";
                                }
                            },
                            {
                                key: "amt",
                                label: "금액",
                                width: 100,
                                align: "right",
                                editor: {type: "text"},
                                formatter: "money", styleClass: function () {
                                    return "red";
                                }
                            },
                            {
                                key: "NO_TAX", label: "부가세여부", width: 70, align: "center", editor: false,
                                styleClass: function () {
                                    return "readonly";
                                },
                            },
                            {key: "remark", label: "계정별적요", width: 150, align: "left", editor: {type: "text"}},
                            {
                                key: "tpEvidence", label: "증빙", width: 150, align: "left", hidden: true,
                                formatter: function () {
                                    return $.changeTextValue(data_tpEvidence, this.value);
                                }
                                , editor: {
                                    type: "select", config: {
                                        columnKeys: {
                                            optionValue: "CODE", optionText: "TEXT"
                                        },
                                        options: data_tpEvidence

                                    }
                                }
                            },
                            {
                                key: "cd_budget",
                                label: "h_예산단위코드",
                                width: 150,
                                align: "right",
                                editor: false,
                                hidden: true
                            },
                            {
                                key: "nm_budget", label: "예산단위", width: 150, align: "left", editor: {type: "text"},
                                picker: {
                                    top: _pop_top,
                                    width: 600,
                                    height: _pop_height,
                                    url: "budget",
                                    action: ["commonHelp", "HELP_BUDGET"],
                                    callback: function (e) {
                                        fnObj.gridDetailLeft.target.setValue(fnObj.gridDetailLeft.getData("selected")[0].__index, "cd_budget", e[0].CD_BUDGET);
                                        fnObj.gridDetailLeft.target.setValue(fnObj.gridDetailLeft.getData("selected")[0].__index, "nm_budget", e[0].NM_BUDGET);
                                    }
                                }
                            },
                            {key: "CD_BGACCT", label: "h_예산계정코드", width: 80, align: "left", editor: true, hidden: true},
                            {
                                key: "NM_BGACCT",
                                label: "예산계정명",
                                width: 80,
                                align: "left",
                                editor: {type: "text"},
                                hidden: false,
                                picker: {
                                    top: _pop_top,
                                    width: 600,
                                    height: _pop_height,
                                    url: "bgAcct",
                                    action: ["commonHelp", "HELP_BGACCT"],
                                    param: function () {
                                        return {
                                            CD_ACCT: fnObj.gridDetailLeft.target.getList()[actionRowIdxL].cdAcct
                                        };
                                    },
                                    callback: function (e) {
                                        fnObj.gridDetailLeft.target.setValue(fnObj.gridDetailLeft.getData("selected")[0].__index, "CD_BGACCT", e[0].CD_BGACCT);
                                        fnObj.gridDetailLeft.target.setValue(fnObj.gridDetailLeft.getData("selected")[0].__index, "NM_BGACCT", e[0].NM_BGACCT);
                                    }
                                }
                            },
                            {key: "mngd", label: "관리항목", width: 150, align: "left", editor: false},
                            {
                                key: "cd_bizcar",
                                label: "h_업무용차량코드",
                                width: 150,
                                align: "right",
                                editor: false,
                                hidden: true
                            },
                            {
                                key: "nm_bizcar", label: "업무용차량", width: 150, align: "left", editor: {type: "text"},
                                picker: {
                                    top: _pop_top,
                                    width: 600,
                                    height: _pop_height,
                                    url: "bizCar",
                                    action: ["commonHelp", "HELP_BIZCAR"],
                                    callback: function (e) {
                                        fnObj.gridDetailLeft.target.setValue(fnObj.gridDetailLeft.getData("selected")[0].__index, "cd_bizcar", e[0].CD_BIZCAR);
                                        fnObj.gridDetailLeft.target.setValue(fnObj.gridDetailLeft.getData("selected")[0].__index, "nm_bizcar", e[0].NM_BIZCAR);
                                    }
                                }
                            },
                            {key: "CD_MNG1", label: "h_관리항목코드1", editor: false, hidden: true},
                            {key: "CD_MNG2", label: "h_관리항목코드2", editor: false, hidden: true},
                            {key: "CD_MNG3", label: "h_관리항목코드3", editor: false, hidden: true},
                            {key: "CD_MNG4", label: "h_관리항목코드4", editor: false, hidden: true},
                            {key: "CD_MNG5", label: "h_관리항목코드5", editor: false, hidden: true},
                            {key: "CD_MNG6", label: "h_관리항목코드6", editor: false, hidden: true},
                            {key: "CD_MNG7", label: "h_관리항목코드7", editor: false, hidden: true},
                            {key: "CD_MNG8", label: "h_관리항목코드8", editor: false, hidden: true},
                            {key: "NM_MNG1", label: "h_관리항목명1", editor: false, hidden: true},
                            {key: "NM_MNG2", label: "h_관리항목명2", editor: false, hidden: true},
                            {key: "NM_MNG3", label: "h_관리항목명3", editor: false, hidden: true},
                            {key: "NM_MNG4", label: "h_관리항목명4", editor: false, hidden: true},
                            {key: "NM_MNG5", label: "h_관리항목명5", editor: false, hidden: true},
                            {key: "NM_MNG6", label: "h_관리항목명6", editor: false, hidden: true},
                            {key: "NM_MNG7", label: "h_관리항목명7", editor: false, hidden: true},
                            {key: "NM_MNG8", label: "h_관리항목명8", editor: false, hidden: true},
                            {key: "ST_MNG1", label: "h_관리항목필수1", editor: false, hidden: true},//X 필수아님 , A 차대필수, C 대변필수 , D 차변필수
                            {key: "ST_MNG2", label: "h_관리항목필수2", editor: false, hidden: true},//X 필수아님 , A 차대필수, C 대변필수 , D 차변필수
                            {key: "ST_MNG3", label: "h_관리항목필수3", editor: false, hidden: true},//X 필수아님 , A 차대필수, C 대변필수 , D 차변필수
                            {key: "ST_MNG4", label: "h_관리항목필수4", editor: false, hidden: true},//X 필수아님 , A 차대필수, C 대변필수 , D 차변필수
                            {key: "ST_MNG5", label: "h_관리항목필수5", editor: false, hidden: true},//X 필수아님 , A 차대필수, C 대변필수 , D 차변필수
                            {key: "ST_MNG6", label: "h_관리항목필수6", editor: false, hidden: true},//X 필수아님 , A 차대필수, C 대변필수 , D 차변필수
                            {key: "ST_MNG7", label: "h_관리항목필수7", editor: false, hidden: true},//X 필수아님 , A 차대필수, C 대변필수 , D 차변필수
                            {key: "ST_MNG8", label: "h_관리항목필수8", editor: false, hidden: true},//X 필수아님 , A 차대필수, C 대변필수 , D 차변필수
                            {key: "CD_MNGD1", label: "h_관리항목값코드1", editor: false, hidden: true},
                            {key: "CD_MNGD2", label: "h_관리항목값코드2", editor: false, hidden: true},
                            {key: "CD_MNGD3", label: "h_관리항목값코드3", editor: false, hidden: true},
                            {key: "CD_MNGD4", label: "h_관리항목값코드4", editor: false, hidden: true},
                            {key: "CD_MNGD5", label: "h_관리항목값코드5", editor: false, hidden: true},
                            {key: "CD_MNGD6", label: "h_관리항목값코드6", editor: false, hidden: true},
                            {key: "CD_MNGD7", label: "h_관리항목값코드7", editor: false, hidden: true},
                            {key: "CD_MNGD8", label: "h_관리항목값코드8", editor: false, hidden: true},
                            {key: "NM_MNGD1", label: "h_관리항목값명1", editor: false, hidden: true},
                            {key: "NM_MNGD2", label: "h_관리항목값명2", editor: false, hidden: true},
                            {key: "NM_MNGD3", label: "h_관리항목값명3", editor: false, hidden: true},
                            {key: "NM_MNGD4", label: "h_관리항목값명4", editor: false, hidden: true},
                            {key: "NM_MNGD5", label: "h_관리항목값명5", editor: false, hidden: true},
                            {key: "NM_MNGD6", label: "h_관리항목값명6", editor: false, hidden: true},
                            {key: "NM_MNGD7", label: "h_관리항목값명7", editor: false, hidden: true},
                            {key: "NM_MNGD8", label: "h_관리항목값명8", editor: false, hidden: true},
                            {key: "bank_acct_no", label: "h_계좌번호", editor: false, hidden: true},
                            {key: "bank_nm", label: "h_은행명", editor: false, hidden: true},
                            {key: "GB_TAX", label: "부가세_세무구분", editor: false, hidden: true},
                            {key: "AMOUNT_SUPPLY", label: "부가세_공급대가", editor: false, hidden: true},
                            {key: "AM_SUPPLY", label: "부가세_공급가액", editor: false, hidden: true},
                            {key: "TEMP_VAT", label: "부가세_부가세", editor: false, hidden: true},
                            {key: "ADDPARAM", label: "h_ADDPARAM", editor: false, hidden: true},
                            {
                                key: "AMT0",
                                label: "h_예산금액",
                                width: 80,
                                align: "right",
                                editor: false,
                                formatter: "money",
                                hidden: true
                            },
                            {
                                key: "AMT1",
                                label: "h_집행금액",
                                width: 80,
                                align: "right",
                                editor: false,
                                formatter: "money",
                                hidden: true
                            },
                            {
                                key: "OVER_AMT",
                                label: "h_예산초과금액",
                                width: 80,
                                align: "right",
                                editor: false,
                                formatter: "money",
                                hidden: true
                            },
                            {
                                key: "TEMP_RECEPT",
                                label: "h_임시저장한접대비금액",
                                width: 80,
                                align: "right",
                                editor: false,
                                formatter: "money",
                                hidden: true
                            },
                        ],
                        body: {
                            onClick: function () {
                                actionRowIdxL = this.dindex;
                                if (this.column.key == "amt") {
                                    var cdAcct = fnObj.gridDetailLeft.target.getList()[this.dindex].cdAcct;
                                    var nmAcct = fnObj.gridDetailLeft.target.getList()[this.dindex].nmAcct;
                                    var noTpdocu = fnObj.gridDetailLeft.target.getList()[this.dindex].noTpdocu;
                                    var tpDrCr = fnObj.gridDetailLeft.target.getList()[this.dindex].tpDrCr;
                                    var ADDPARAM = fnObj.gridDetailLeft.target.getList()[this.dindex].ADDPARAM;

                                    if (tax_code_dr.indexOf(cdAcct) > -1) {     //  차변 부가세계정
                                        var templist = fnObj.gridDetailLeft.target.getList();
                                        var tempnmacct = "";
                                        for (var i = 0; i < templist.length; i++) {
                                            if (templist[i].noTpdocu == noTpdocu && templist[i].cdAcct != cdAcct) {
                                                tempnmacct = templist[i].nmAcct;
                                            }
                                        }

                                        var listH = fnObj.gridHeader.target.getList();
                                        var i = listH.length;
                                        var item;
                                        while (i--) {
                                            if (listH[i].noTpdocu == noTpdocu) {
                                                console.log(listH[i]);
                                                item = listH[i];
                                                break;
                                            }
                                        }
                                        var initData = {
                                            AMT: item.AMT_SUPPLY,
                                            VAT: item.AMT_VAT,
                                            CD_PARTNER: item.cdPartner,
                                            LN_PARTNER: item.lnPartner,
                                            CD_DOCU: item.cdDocu,
                                            SEQ: this.dindex,
                                            TPDRCR: tpDrCr,
                                            index: this.dindex,
                                            NO_TAX: ADDPARAM,
                                            NM_ITEM: tempnmacct,
                                            DT_TAX: nvl($("#dtAcct").val()).replace(/-/gi, ""),//item.dtTrans
                                            CD_RELATION: 30,
                                            ETC_DOCU_YN : _etcdocuyn
                                        };
                                        tagetUrl = "../../custom/vatHelper.jsp";
                                        tagetCallbck = "callBack=vatCallBack";
                                        width = 900;
                                        height = _pop_height;
                                        top = _pop_top;
                                        initDatas = function (caller, act, data) {  //  자식창에 넘겨줄 데이터

                                            return {
                                                "initData": initData
                                            };
                                        };


                                        modal.open({
                                            width: width,
                                            height: height,
                                            top: top,
                                            iframe: {
                                                method: "get",
                                                url: tagetUrl,
                                                param: tagetCallbck
                                            },
                                            sendData: initDatas,
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
                                    } else if (tax_code_recept.indexOf(cdAcct) > -1) {  //  차변 접대비계정
                                        var listH = fnObj.gridHeader.target.getList();
                                        var i = listH.length;
                                        var item;
                                        while (i--) {
                                            if (listH[i].noTpdocu == noTpdocu) {
                                                console.log(listH[i]);
                                                item = listH[i];
                                                break;
                                            }
                                        }
                                        var initData = {
                                            CD_ACCT: cdAcct,
                                            NM_ACCT: nmAcct,
                                            TPDRCR: tpDrCr,
                                            AMT: item.AMT_SUM,
                                            index: this.dindex,
                                            ADDPARAM: ADDPARAM,
                                            GUBUN: '2',

                                        };
                                        tagetUrl = "../../custom/receptHelper.jsp";
                                        tagetCallbck = "callBack=receptCallBack";
                                        width = 900;
                                        height = _pop_height;
                                        top = _pop_top;
                                        initDatas = function (caller, act, data) {  //  자식창에 넘겨줄 데이터

                                            return {
                                                "initData": initData
                                            };
                                        };


                                        modal.open({
                                            width: width,
                                            height: height,
                                            top: top,
                                            iframe: {
                                                method: "get",
                                                url: tagetUrl,
                                                param: tagetCallbck
                                            },
                                            sendData: initDatas,
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
                                }

                                /*  부가세 값 바인딩   */
                                var item = fnObj.gridDetailLeft.target.list[this.dindex];
                                var GB_TAX = '';
                                for (var i = 0; i < fg_taxApproveData.length; i++) {
                                    if (fg_taxApproveData[i].CODE == item.GB_TAX) {
                                        GB_TAX = fg_taxApproveData[i].TEXT;
                                    }
                                }
                                myModel_LEFT.setModel({
                                    LEFT_GB_TAX: GB_TAX,
                                    LEFT_AMOUNT_SUPPLY: item.AMOUNT_SUPPLY,
                                    LEFT_AM_SUPPLY: item.AM_SUPPLY,
                                    LEFT_TEMP_VAT: item.TEMP_VAT
                                }, $(document["binder-form-Left"]));
                                /*  부가세 값 바인딩   */

                                this.self.focus(this.dindex);
                            },
                            onDBLClick: function () {
                                actionRowIdxL = this.dindex;
                                if (this.column.key == "mngd") {
                                    //관리항목팝업
                                    var cdAcct = fnObj.gridDetailLeft.target.getList()[actionRowIdxL].cdAcct;
                                    var tpDrCr = fnObj.gridDetailLeft.target.getList()[actionRowIdxL].tpDrCr;
                                    var noTpdocu = fnObj.gridDetailLeft.target.getList()[actionRowIdxL].noTpdocu;

                                    var cdDocu = "";
                                    for (var i = 0; i < fnObj.gridHeader.target.getList().length; i++) {
                                        if (fnObj.gridHeader.target.getList()[i].noTpdocu == noTpdocu) {
                                            cdDocu = fnObj.gridHeader.target.getList()[i].cdDocu;
                                            break;
                                        }
                                    }

                                    if (!cdDocu) {
                                        qray.alert("상단의 전표유형을 선택하여 주십시오.");
                                        return;
                                    }

                                    if (!cdAcct) {
                                        qray.alert("계정코드를 선택하여 주십시오.");
                                        return;
                                    }

                                    if (!tpDrCr) {
                                        qray.alert("차대구분값이 없습니다.");
                                        return;
                                    }

                                    openMngd(cdAcct, tpDrCr, cdDocu, this.item);
                                }


                            },
                            onDataChanged: function () {

                                if (this.key == 'ADDPARAM') {
                                    if (tax_code_dr.indexOf(this.item.cdAcct) > -1) {
                                        if (nvl(this.value) != '') {
                                            fnObj.gridDetailLeft.target.setValue(this.dindex, 'NO_TAX', "Y");
                                        }
                                    }
                                }
                                if (this.key == "amt") {
                                    calc()
                                }
                                if (this.key == 'cdAcct' && nvl(this.item.cdAcct) != '') { // 차변 계정변경시 DR

                                    fnObj.gridDetailLeft.target.setValue(this.dindex, "remark", '');
                                    fnObj.gridDetailLeft.target.setValue(this.dindex, "ADDPARAM", '');
                                    fnObj.gridDetailLeft.target.setValue(this.dindex, "NM_BGACCT", '');
                                    fnObj.gridDetailLeft.target.setValue(this.dindex, "CD_BGACCT", '');
                                    fnObj.gridDetailLeft.target.setValue(this.dindex, "OVER_AMT", '');
                                    fnObj.gridDetailLeft.target.setValue(this.dindex, "tpEvidence", '');
                                    fnObj.gridDetailLeft.target.setValue(this.dindex, "NO_TAX", '');
                                    fnObj.gridDetailLeft.target.setValue(this.dindex, "cd_bizcar", '');
                                    fnObj.gridDetailLeft.target.setValue(this.dindex, "nm_bizcar", '');
                                    fnObj.gridDetailLeft.target.setValue(this.dindex, "TEMP_VAT", '');
                                    fnObj.gridDetailLeft.target.setValue(this.dindex, "GB_TAX", '');
                                    fnObj.gridDetailLeft.target.setValue(this.dindex, "AMOUNT_SUPPLY", '');
                                    fnObj.gridDetailLeft.target.setValue(this.dindex, "AM_SUPPLY", '');
                                    fnObj.gridDetailLeft.target.setValue(this.dindex, "TEMP_RECEPT", '');


                                    var data = $.DATA_SEARCH('apbucard', 'bgacctSetting', {
                                        CD_ACCT: this.item.cdAcct,
                                        CD_BUDGET: this.item.cd_budget
                                    });
                                    if (data.list.length > 0) {
                                        fnObj.gridDetailLeft.target.setValue(this.dindex, "NM_BGACCT", data.list[0].NM_BGACCT);
                                        fnObj.gridDetailLeft.target.setValue(this.dindex, "CD_BGACCT", data.list[0].CD_BGACCT);
                                    } else {
                                        fnObj.gridDetailLeft.target.setValue(this.dindex, "NM_BGACCT", '');
                                        fnObj.gridDetailLeft.target.setValue(this.dindex, "CD_BGACCT", '');
                                    }
                                    setStMngd(this.item.cdAcct, "1", this.dindex);
                                    clearMngd("1", this.dindex);

                                    //자동으로 들어갈수있는 관리항목들은 자동으로 들어가게 세팅
                                    var tempitemH = fnObj.gridHeader.getData('selected')[0];
                                    var tempemp = $("#cdEmp").attr("code");
                                    var temppartner = tempitemH.cdPartner;
                                    var tempdt = nvl($("#dtAcct").val()).replace(/-/gi, "");
                                    var tempnotpdocu = tempitemH.noTpdocu;
                                    var tempamt = tempitemH.AMT_SUPPLY;
                                    //사원코드,거래처코드,날짜,금액,키값명칭,키값
                                    getAutoMngd(tempemp, temppartner, tempdt, tempamt, "noTpdocu", tempnotpdocu);

                                    if (fnObj.gridDetailLeft.target.getList()[this.dindex]["cdAcct"] == "")
                                        fnObj.gridDetailLeft.target.setValue(this.dindex, "nmAcct", '');
                                }

                                //예산통제 팝업
                                if (this.key == 'amt' || this.key == 'cdAcct') {
                                    BudgetControl(fnObj.gridDetailLeft, this.item);    //  예산계정
                                }

                            }
                        },
                        onPageChange: function (pageNumber) {
                            _this.setPageData({pageNumber: pageNumber});
                            ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                        },
                        page: { //그리드아래 목록개수보여주는부분 숨김
                            display: false,
                            statusDisplay: false
                        }
                    });

                    axboot.buttonClick(this, "data-grid-detail-left-btn", {
                        "add": function () {
                            ACTIONS.dispatch(ACTIONS.DETAIL_LEFT_ADD);
                        },
                        "devare": function () {
                            var beforeIdx = this.target.selectedDataIndexs[0];
                            var dataLen = this.target.getList().length;

                            if ((beforeIdx + 1) == dataLen) {
                                beforeIdx = beforeIdx - 1;
                            }

                            ACTIONS.dispatch(ACTIONS.DETAIL_LEFT_DEvarE);
                            if (beforeIdx > 0 || beforeIdx == 0) {
                                this.target.select(beforeIdx);
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
                    this.target.addRow({__created__: true, amt: 0,}, "last");

                },
                lastRow: function () {
                    return ($("div [data-ax5grid='grid-detail-left']").find("div [data-ax5grid-panel='body'] table tr").length)
                },
                getSelectRow: function () {
                    return actionRowIdxL;
                }
            });

            fnObj.gridDetailRight = axboot.viewExtend(axboot.gridView, {
                page: {
                    pageNumber: 0,
                    pageSize: 10
                },
                initView: function () {
                    var _this = this;

                    this.target = axboot.gridBuilder({
                        //showRowSelector: true,
                        frozenColumnIndex: 0,
                        target: $('[data-ax5grid="grid-detail-right"]'),
                        virtualScrollX: true,
                        columns: [
                            {
                                key: "LINENO",
                                label: "순번",
                                width: 40,
                                align: "left",
                                editor: false,
                                hidden: false,
                                styleClass: function () {
                                    return "readonly";
                                }
                            },
                            {
                                key: "tpDrCr", label: "h_차대구분", width: 150, align: "center", formatter: function () {
                                    return $.changeTextValue(data_drcr, this.value);
                                }
                                , editor: {
                                    type: "select", config: {
                                        columnKeys: {
                                            optionValue: "CODE", optionText: "TEXT"
                                        },
                                        options: data_drcr

                                    }
                                },
                                hidden: true
                            },
                            {
                                key: "noTpdocu",
                                label: "h_고유번호noTpdocu",
                                width: 200,
                                align: "left",
                                editor: false,
                                hidden: true
                            },
                            {
                                key: "cdAcct",
                                label: "계정코드",
                                width: 80,
                                align: "center",
                                editor: {
                                    type: "text",
                                    disabled: function () {
                                        var cdDocu = fnObj.gridHeader.target.getList()[actionRowIdx].cdDocu;
                                        if (nvl(cdDocu) == '') {
                                            return true;
                                        } else {
                                            return false;
                                        }
                                    }
                                },
                                picker: {
                                    top: _pop_top,
                                    width: 600,
                                    height: _pop_height,
                                    url: "acct",
                                    action: ["commonHelp", "HELP_ACCT"],
                                    param: function () {
                                        var noTpdocu = fnObj.gridDetailRight.target.getList()[actionRowIdxR].noTpdocu;
                                        var listH = fnObj.gridHeader.target.getList();
                                        var i = listH.length;
                                        var item;
                                        while (i--) {
                                            if (listH[i].noTpdocu == noTpdocu) {
                                                console.log(listH[i]);
                                                item = listH[i];
                                                break;
                                            }
                                        }
                                        if (item.cdDocu == '004' || item.cdDocu == '008' || item.cdDocu == '009') {   //  전표유형이 기타,반제일 때는 차대구분 없이 모든 계정을 조회한다.
                                            //전표유형이 기타,반제일때는 프로시저 매개변수의 TP_DRCR 을 '' 으로넣어준다
                                            return {
                                                TP_DRCR: ''
                                            }
                                        }
                                        else{
                                            //전표유형이 기타,반제가 아닐때는 프로시저 매개변수의 TP_DRCR 을 선택한 차변,대변 구분코드로 넣어준다
                                            return {
                                                TP_DRCR: 2
                                            }
                                        }
                                    },
                                    callback: function (e) {
                                        fnObj.gridDetailRight.target.setValue(fnObj.gridDetailRight.getData("selected")[0].__index, "cdAcct", e[0].CD_ACCT);
                                        fnObj.gridDetailRight.target.setValue(fnObj.gridDetailRight.getData("selected")[0].__index, "nmAcct", e[0].NM_ACCT);
                                    },
                                    disabled: function () {
                                        var cdDocu = fnObj.gridHeader.target.getList()[actionRowIdx].cdDocu;
                                        if (nvl(cdDocu) == '') {
                                            return true;
                                        } else {
                                            return false;
                                        }
                                    }
                                },
                                styleClass: function () {
                                    return "red";
                                }
                            },
                            {
                                key: "nmAcct",
                                label: "계정명",
                                width: 150,
                                align: "center",
                                editor: false,
                                styleClass: function () {
                                    return "readonly";
                                }
                            },
                            {
                                key: "amt",
                                label: "금액",
                                width: 100,
                                align: "right",
                                editor: {type: "text"},
                                formatter: "money", styleClass: function () {
                                    return "red";
                                }
                            },
                            {
                                key: "NO_TAX", label: "부가세여부", width: 70, align: "center", editor: false,
                                styleClass: function () {
                                    return "readonly";
                                },
                            },
                            {key: "remark", label: "계정별적요", width: 150, align: "left", editor: {type: "text"}},

                            {
                                key: "tpEvidence", label: "증빙", width: 150, align: "left", hidden: true,
                                formatter: function () {
                                    return $.changeTextValue(data_tpEvidence, this.value);
                                }
                                , editor: {
                                    type: "select", config: {
                                        columnKeys: {
                                            optionValue: "CODE", optionText: "TEXT"
                                        },
                                        options: data_tpEvidence

                                    }
                                }
                            },
                            {
                                key: "cd_budget",
                                label: "h_예산단위",
                                width: 150,
                                align: "left",
                                editor: false,
                                hidden: true
                            },
                            {
                                key: "nm_budget", label: "예산단위", width: 150, align: "left", editor: {type: "text"},
                                picker: {
                                    top: _pop_top,
                                    width: 600,
                                    height: _pop_height,
                                    url: "budget",
                                    action: ["commonHelp", "HELP_BUDGET"],
                                    callback: function (e) {
                                        fnObj.gridDetailRight.target.setValue(fnObj.gridDetailRight.getData("selected")[0].__index, "cd_budget", e[0].CD_BUDGET);
                                        fnObj.gridDetailRight.target.setValue(fnObj.gridDetailRight.getData("selected")[0].__index, "nm_budget", e[0].NM_BUDGET);
                                    }
                                }
                            },

                            {key: "CD_BGACCT", label: "h_예산계정코드", width: 80, align: "left", editor: true, hidden: true},
                            {
                                key: "NM_BGACCT",
                                label: "예산계정명",
                                width: 80,
                                align: "left",
                                editor: {type: "text"},
                                hidden: false,
                                picker: {
                                    top: _pop_top,
                                    width: 600,
                                    height: _pop_height,
                                    url: "bgAcct",
                                    action: ["commonHelp", "HELP_BGACCT"],
                                    param: function () {
                                        return {
                                            CD_ACCT: fnObj.gridDetailRight.target.getList()[actionRowIdxR].cdAcct
                                        };
                                    },
                                    callback: function (e) {
                                        fnObj.gridDetailRight.target.setValue(fnObj.gridDetailRight.getData("selected")[0].__index, "CD_BGACCT", e[0].CD_BGACCT);
                                        fnObj.gridDetailRight.target.setValue(fnObj.gridDetailRight.getData("selected")[0].__index, "NM_BGACCT", e[0].NM_BGACCT);
                                    }
                                }
                            },
                            {key: "mngd", label: "관리항목", width: 150, align: "left", editor: false},
                            {key: "CD_MNG1", label: "h_관리항목코드1", editor: false, hidden: true},
                            {key: "CD_MNG2", label: "h_관리항목코드2", editor: false, hidden: true},
                            {key: "CD_MNG3", label: "h_관리항목코드3", editor: false, hidden: true},
                            {key: "CD_MNG4", label: "h_관리항목코드4", editor: false, hidden: true},
                            {key: "CD_MNG5", label: "h_관리항목코드5", editor: false, hidden: true},
                            {key: "CD_MNG6", label: "h_관리항목코드6", editor: false, hidden: true},
                            {key: "CD_MNG7", label: "h_관리항목코드7", editor: false, hidden: true},
                            {key: "CD_MNG8", label: "h_관리항목코드8", editor: false, hidden: true},
                            {key: "NM_MNG1", label: "h_관리항목명1", editor: false, hidden: true},
                            {key: "NM_MNG2", label: "h_관리항목명2", editor: false, hidden: true},
                            {key: "NM_MNG3", label: "h_관리항목명3", editor: false, hidden: true},
                            {key: "NM_MNG4", label: "h_관리항목명4", editor: false, hidden: true},
                            {key: "NM_MNG5", label: "h_관리항목명5", editor: false, hidden: true},
                            {key: "NM_MNG6", label: "h_관리항목명6", editor: false, hidden: true},
                            {key: "NM_MNG7", label: "h_관리항목명7", editor: false, hidden: true},
                            {key: "NM_MNG8", label: "h_관리항목명8", editor: false, hidden: true},
                            {key: "ST_MNG1", label: "h_관리항목필수1", editor: false, hidden: true},//X 필수아님 , A 차대필수, C 대변필수 , D 차변필수
                            {key: "ST_MNG2", label: "h_관리항목필수2", editor: false, hidden: true},//X 필수아님 , A 차대필수, C 대변필수 , D 차변필수
                            {key: "ST_MNG3", label: "h_관리항목필수3", editor: false, hidden: true},//X 필수아님 , A 차대필수, C 대변필수 , D 차변필수
                            {key: "ST_MNG4", label: "h_관리항목필수4", editor: false, hidden: true},//X 필수아님 , A 차대필수, C 대변필수 , D 차변필수
                            {key: "ST_MNG5", label: "h_관리항목필수5", editor: false, hidden: true},//X 필수아님 , A 차대필수, C 대변필수 , D 차변필수
                            {key: "ST_MNG6", label: "h_관리항목필수6", editor: false, hidden: true},//X 필수아님 , A 차대필수, C 대변필수 , D 차변필수
                            {key: "ST_MNG7", label: "h_관리항목필수7", editor: false, hidden: true},//X 필수아님 , A 차대필수, C 대변필수 , D 차변필수
                            {key: "ST_MNG8", label: "h_관리항목필수8", editor: false, hidden: true},//X 필수아님 , A 차대필수, C 대변필수 , D 차변필수
                            {key: "CD_MNGD1", label: "h_관리항목값코드1", editor: false, hidden: true},
                            {key: "CD_MNGD2", label: "h_관리항목값코드2", editor: false, hidden: true},
                            {key: "CD_MNGD3", label: "h_관리항목값코드3", editor: false, hidden: true},
                            {key: "CD_MNGD4", label: "h_관리항목값코드4", editor: false, hidden: true},
                            {key: "CD_MNGD5", label: "h_관리항목값코드5", editor: false, hidden: true},
                            {key: "CD_MNGD6", label: "h_관리항목값코드6", editor: false, hidden: true},
                            {key: "CD_MNGD7", label: "h_관리항목값코드7", editor: false, hidden: true},
                            {key: "CD_MNGD8", label: "h_관리항목값코드8", editor: false, hidden: true},
                            {key: "NM_MNGD1", label: "h_관리항목값명1", editor: false, hidden: true},
                            {key: "NM_MNGD2", label: "h_관리항목값명2", editor: false, hidden: true},
                            {key: "NM_MNGD3", label: "h_관리항목값명3", editor: false, hidden: true},
                            {key: "NM_MNGD4", label: "h_관리항목값명4", editor: false, hidden: true},
                            {key: "NM_MNGD5", label: "h_관리항목값명5", editor: false, hidden: true},
                            {key: "NM_MNGD6", label: "h_관리항목값명6", editor: false, hidden: true},
                            {key: "NM_MNGD7", label: "h_관리항목값명7", editor: false, hidden: true},
                            {key: "NM_MNGD8", label: "h_관리항목값명8", editor: false, hidden: true},
                            {key: "bank_acct_no", label: "h_계좌번호", editor: false, hidden: true},
                            {key: "bank_nm", label: "h_은행명", editor: false, hidden: true},
                            {key: "GB_TAX", label: "부가세_세무구분", editor: false, hidden: true},
                            {key: "AMOUNT_SUPPLY", label: "부가세_공급대가", editor: false, hidden: true},
                            {key: "AM_SUPPLY", label: "부가세_공급가액", editor: false, hidden: true},
                            {key: "TEMP_VAT", label: "부가세_부가세", editor: false, hidden: true},
                            {key: "ADDPARAM", label: "h_ADDPARAM", editor: false, hidden: true},
                            {
                                key: "AMT0",
                                label: "h_예산금액",
                                width: 80,
                                align: "right",
                                editor: false,
                                formatter: "money",
                                hidden: true
                            },
                            {
                                key: "AMT1",
                                label: "h_집행금액",
                                width: 80,
                                align: "right",
                                editor: false,
                                formatter: "money",
                                hidden: true
                            },
                            {
                                key: "OVER_AMT",
                                label: "h_예산초과금액",
                                width: 80,
                                align: "right",
                                editor: false,
                                formatter: "money",
                                hidden: true
                            },
                            {
                                key: "TEMP_RECEPT",
                                label: "h_임시저장한접대비금액",
                                width: 80,
                                align: "right",
                                editor: false,
                                formatter: "money",
                                hidden: true
                            },
                        ],
                        body: {
                            onClick: function () {
                                if (this.column.key == "amt") {
                                    //var cdAcct = fnObj.gridDetailRight.target.getList()[this.dindex].cdAcct;
                                    //var noTpdocu = fnObj.gridDetailRight.target.getList()[this.dindex].noTpdocu;

                                    var cdAcct = fnObj.gridDetailRight.target.getList()[this.dindex].cdAcct;
                                    var nmAcct = fnObj.gridDetailRight.target.getList()[this.dindex].nmAcct;
                                    var noTpdocu = fnObj.gridDetailRight.target.getList()[this.dindex].noTpdocu;
                                    var tpDrCr = fnObj.gridDetailRight.target.getList()[this.dindex].tpDrCr;
                                    var ADDPARAM = fnObj.gridDetailRight.target.getList()[this.dindex].ADDPARAM;
                                    if (tax_code_cr.indexOf(cdAcct) > -1) {
                                        var templist = fnObj.gridDetailRight.target.getList();
                                        var tempnmacct = "";
                                        for (var i = 0; i < templist.length; i++) {
                                            if (templist[i].noTpdocu == noTpdocu && templist[i].cdAcct != cdAcct) {
                                                tempnmacct = templist[i].nmAcct;
                                            }
                                        }

                                        var listH = fnObj.gridHeader.target.getList();
                                        var i = listH.length;
                                        var item;
                                        while (i--) {
                                            if (listH[i].noTpdocu == noTpdocu) {
                                                console.log(listH[i]);
                                                item = listH[i];
                                                break;
                                            }
                                        }

                                        var initData = {
                                            AMT: item.AMT_SUPPLY,
                                            VAT: item.AMT_VAT,
                                            CD_PARTNER: item.cdPartner,
                                            LN_PARTNER: item.lnPartner,
                                            CD_DOCU: item.cdDocu,
                                            CD_RELATION: 31,
                                            SEQ: this.dindex,
                                            TPDRCR: tpDrCr,
                                            index: this.dindex,
                                            NO_TAX: ADDPARAM,
                                            NM_ITEM: tempnmacct,
                                            DT_TAX: nvl($("#dtAcct").val()).replace(/-/gi, ""),//item.dtTrans
                                            ETC_DOCU_YN : _etcdocuyn
                                        };
                                        tagetUrl = "../../custom/vatHelper.jsp";
                                        tagetCallbck = "callBack=vatCallBack";
                                        width = 900;
                                        height = _pop_height;
                                        top = _pop_top;
                                        initDatas = function (caller, act, data) {  //  자식창에 넘겨줄 데이터

                                            return {
                                                "initData": initData
                                            };
                                        };


                                        modal.open({
                                            width: width,
                                            height: height,
                                            top: top,
                                            iframe: {
                                                method: "get",
                                                url: tagetUrl,
                                                param: tagetCallbck
                                            },
                                            sendData: initDatas,
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
                                    } else if (tax_code_recept.indexOf(cdAcct) > -1) {
                                        var listH = fnObj.gridHeader.target.getList();
                                        var i = listH.length;
                                        var item;
                                        while (i--) {
                                            if (listH[i].noTpdocu == noTpdocu) {
                                                console.log(listH[i]);
                                                item = listH[i];
                                                break;
                                            }
                                        }
                                        var initData = {
                                            CD_ACCT: cdAcct,
                                            NM_ACCT: nmAcct,
                                            TPDRCR: tpDrCr,
                                            AMT: item.AMT_SUM,
                                            index: this.dindex,
                                            ADDPARAM: ADDPARAM,
                                            GUBUN: '2'
                                        };
                                        tagetUrl = "../../custom/receptHelper.jsp";
                                        tagetCallbck = "callBack=receptCallBack";
                                        width = 900;
                                        height = _pop_height;
                                        top = _pop_top;
                                        initDatas = function (caller, act, data) {  //  자식창에 넘겨줄 데이터

                                            return {
                                                "initData": initData
                                            };
                                        };


                                        modal.open({
                                            width: width,
                                            height: height,
                                            top: top,
                                            iframe: {
                                                method: "get",
                                                url: tagetUrl,
                                                param: tagetCallbck
                                            },
                                            sendData: initDatas,
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
                                }
                                /*  부가세 값 바인딩   */
                                var item = fnObj.gridDetailRight.target.list[this.dindex];
                                var GB_TAX = '';
                                for (var i = 0; i < fg_taxApproveData.length; i++) {
                                    if (fg_taxApproveData[i].CODE == item.GB_TAX) {
                                        GB_TAX = fg_taxApproveData[i].TEXT;
                                    }
                                }
                                myModel_RIGHT.setModel({
                                    RIGHT_GB_TAX: GB_TAX,
                                    RIGHT_AMOUNT_SUPPLY: item.AMOUNT_SUPPLY,
                                    RIGHT_AM_SUPPLY: item.AM_SUPPLY,
                                    RIGHT_TEMP_VAT: item.TEMP_VAT
                                }, $(document["binder-form-Right"]));
                                /*  부가세 값 바인딩   */
                                this.self.focus(this.dindex);
                            },
                            onDBLClick: function () {
                                actionRowIdxR = this.dindex;
                                if (this.column.key == "mngd") {
                                    var cdAcct = fnObj.gridDetailRight.target.getList()[actionRowIdxR].cdAcct;
                                    var tpDrCr = fnObj.gridDetailRight.target.getList()[actionRowIdxR].tpDrCr;
                                    var noTpdocu = fnObj.gridDetailRight.target.getList()[actionRowIdxR].noTpdocu;

                                    var cdDocu = "";
                                    for (var i = 0; i < fnObj.gridHeader.target.getList().length; i++) {
                                        if (fnObj.gridHeader.target.getList()[i].noTpdocu == noTpdocu) {
                                            cdDocu = fnObj.gridHeader.target.getList()[i].cdDocu;
                                            break;
                                        }
                                    }

                                    openMngd(cdAcct, tpDrCr, cdDocu, this.item);
                                }
                            },
                            onDataChanged: function () {
                                if (this.key == 'ADDPARAM') {
                                    if (tax_code_cr.indexOf(this.item.cdAcct) > -1) {
                                        if (nvl(this.value) != '') {
                                            fnObj.gridDetailRight.target.setValue(this.dindex, 'NO_TAX', "Y");
                                        }
                                    }
                                }
                                if (this.key == "amt") {
                                    calc()
                                }
                                if (this.key == 'cdAcct') { // 대변 계정변경시 CR

                                    fnObj.gridDetailRight.target.setValue(this.dindex, "remark", '');
                                    fnObj.gridDetailRight.target.setValue(this.dindex, "ADDPARAM", '');
                                    fnObj.gridDetailRight.target.setValue(this.dindex, "NM_BGACCT", '');
                                    fnObj.gridDetailRight.target.setValue(this.dindex, "CD_BGACCT", '');
                                    fnObj.gridDetailRight.target.setValue(this.dindex, "OVER_AMT", '');
                                    fnObj.gridDetailRight.target.setValue(this.dindex, "tpEvidence", '');
                                    fnObj.gridDetailRight.target.setValue(this.dindex, "NO_TAX", '');
                                    fnObj.gridDetailRight.target.setValue(this.dindex, "cd_bizcar", '');
                                    fnObj.gridDetailRight.target.setValue(this.dindex, "nm_bizcar", '');
                                    fnObj.gridDetailRight.target.setValue(this.dindex, "TEMP_VAT", '');
                                    fnObj.gridDetailRight.target.setValue(this.dindex, "GB_TAX", '');
                                    fnObj.gridDetailRight.target.setValue(this.dindex, "AMOUNT_SUPPLY", '');
                                    fnObj.gridDetailRight.target.setValue(this.dindex, "AM_SUPPLY", '');
                                    fnObj.gridDetailRight.target.setValue(this.dindex, "TEMP_RECEPT", '');

                                    var data = $.DATA_SEARCH('apbucard', 'bgacctSetting', {
                                        CD_ACCT: this.item.cdAcct,
                                        CD_BUDGET: this.item.cd_budget
                                    });
                                    if (data.list.length > 0) {
                                        fnObj.gridDetailRight.target.setValue(this.dindex, "NM_BGACCT", data.list[0].NM_BGACCT);
                                        fnObj.gridDetailRight.target.setValue(this.dindex, "CD_BGACCT", data.list[0].CD_BGACCT);
                                    } else {
                                        fnObj.gridDetailRight.target.setValue(this.dindex, "NM_BGACCT", '');
                                        fnObj.gridDetailRight.target.setValue(this.dindex, "CD_BGACCT", '');
                                    }
                                    setStMngd(this.item.cdAcct, "2", this.dindex);
                                    clearMngd("2", this.dindex);
                                    //자동으로 들어갈수있는 관리항목들은 자동으로 들어가게 세팅
                                    var tempitemH = fnObj.gridHeader.getData('selected')[0];
                                    var tempemp = $("#cdEmp").attr("code");
                                    var temppartner = tempitemH.cdPartner;
                                    var tempdt = nvl($("#dtAcct").val()).replace(/-/gi, "");
                                    var tempnotpdocu = tempitemH.noTpdocu;
                                    var tempamt = tempitemH.AMT_SUPPLY;
                                    //사원코드,거래처코드,날짜,금액,키값명칭,키값
                                    getAutoMngd(tempemp, temppartner, tempdt, tempamt, "noTpdocu", tempnotpdocu);

                                    if (fnObj.gridDetailRight.target.getList()[this.dindex]["cdAcct"] == "")
                                        fnObj.gridDetailRight.target.setValue(this.dindex, "nmAcct", '');
                                }

                                //예산통제 팝업
                                if (this.item.CD_BGACCT && this.item.cd_budget && this.item.cdAcct) {
                                    if (this.key == 'amt' || this.key == 'cdAcct') {
                                        BudgetControl(fnObj.gridDetailRight);
                                    }
                                }
                            }
                        },
                        onPageChange: function (pageNumber) {

                            _this.setPageData({pageNumber: pageNumber});
                            ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                        },
                        page: { //그리드아래 목록개수보여주는부분 숨김
                            display: false,
                            statusDisplay: false
                        }
                    });

                    axboot.buttonClick(this, "data-grid-detail-right-btn", {
                        "add": function () {
                            ACTIONS.dispatch(ACTIONS.DETAIL_RIGHT_ADD);
                        },
                        "devare": function () {
                            var beforeIdx = this.target.selectedDataIndexs[0];
                            var dataLen = this.target.getList().length;

                            if ((beforeIdx + 1) == dataLen) {
                                beforeIdx = beforeIdx - 1;
                            }

                            ACTIONS.dispatch(ACTIONS.DETAIL_RIGHT_DEvarE);
                            if (beforeIdx > 0 || beforeIdx == 0) {
                                this.target.select(beforeIdx);
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
                    this.target.addRow({__created__: true, amt: 0,}, "last");
                },
                lastRow: function () {
                    return ($("div [data-ax5grid='grid-detail-right']").find("div [data-ax5grid-panel='body'] table tr").length)
                },
                getSelectRow: function () {
                    return actionRowIdxR;
                }
            });

            //관리항목 팝업
            var openMngd = function (cdAcct, tpDrCr, cdDocu, INITDATA) {
                userCallBack = function (e) {
                    if (e.length > 0) {
                        var grid;
                        if (tpDrCr == "2") {
                            grid = fnObj.gridDetailRight;
                        } else {
                            grid = fnObj.gridDetailLeft;
                        }
                        var mngd = "";
                        var no_tpdocu = grid.getData('selected')[0].NO_TPDOCU;
                        var row = grid.getData("selected")[0].__index;
                        for (var i = 0; i < e.length; i++) {
                            if (e[i].get("cd_mng") == 'B22'){   //  자금예정일자
                                for (var h = 0 ; h < fnObj.gridHeader.target.list.length; h++){
                                    if (fnObj.gridHeader.target.list[h].NO_TPDOCU == no_tpdocu){
                                        fnObj.gridHeader.target.setValue(h, 'DT_INEND', e[i].get("nm_mngd"));
                                    }
                                }
                            }
                            grid.target.setValue(row, "CD_MNGD" + (i + 1), e[i].get("cd_mngd"));
                            grid.target.setValue(row, "NM_MNGD" + (i + 1), e[i].get("nm_mngd"));
                            grid.target.setValue(row, "CD_MNG" + (i + 1), e[i].get("cd_mng"));
                            grid.target.setValue(row, "NM_MNG" + (i + 1), e[i].get("nm_mng"));
                            mngd += nvl(e[i].get("nm_mngd"), '');

                            if (i < e.length - 1) {
                                mngd += "*"
                            }
                        }
                        grid.target.setValue(row, "mngd", mngd);
                    }
                };

                modal.open({
                    width: 600,
                    height: _pop_height300,
                    position: {
                        left: "center",
                        top: _pop_top300
                    },
                    iframe: {
                        method: "get",
                        url: "/jsp/ensys/gl/popMngd.jsp",
                        param: "callBack=userCallBack&cdAcct=" + cdAcct + "&tpDrCr=" + tpDrCr.substr(0, 1) + "&cdDocu=" + cdDocu
                    },
                    sendData: function () {
                        return {
                            "initData": INITDATA,
                            "disabledYn": 'N'
                        }
                    },
                    onStateChanged: function () {
                        // mask
                        if (this.state === "open") {
                            mask.open();
                        } else if (this.state === "close") {
                            mask.close();
                        }
                    }
                }, function () {

                });
            };

            //편익제공 팝업
            var openExp = function (CD_PARTNER, LN_PARTNER, AMT) {
                userCallBack = function (e) {
                    var benefitObj = {};
                    benefitObj = cloneObject(e);

                    benefitList = benefitObj.list;

                    modal.close();
                };

                var parameterDATA = {
                    "DT_ACCT": $("#dtAcct").val().replace(/-/gi, "")
                    , "AMT": AMT
                    , "benefitList": benefitList
                    , "CD_PARTNER": CD_PARTNER
                    , "LN_PARTNER": LN_PARTNER
                };

                modal.open({
                    width: 800,
                    height: _pop_height400,
                    position: {
                        left: "center",
                        top: _pop_top400
                    },
                    iframe: {
                        method: "get",
                        url: "/jsp/ensys/gl/popExpenses.jsp",
                        param: "callBack=userCallBack"
                        //param: "callBack=userCallBack&groupnumber=" + cdAcct +"&tpDrCr=" + tpDrCr.substr(0,1) +"&cdDocu="+cdDocu
                    },
                    sendData: parameterDATA,
                    onStateChanged: function () {
                        // mask
                        if (this.state === "open") {
                            mask.open();
                        } else if (this.state === "close") {
                            mask.close();
                        }
                    }
                }, function () {

                });
            };

            //전표복사 팝업
            var openDcopy = function () {
                userCallBack = function (e) {

                    if (nvl(e) == '') {
                        return false;
                    }

                    fnObj.gridHeader.clear();
                    fnObj.gridDetailLeft.clear();
                    fnObj.gridDetailRight.clear();


                    axboot.ajax({
                        type: "POST",
                        url: ["gldocum", "getDocuPusaivCopy"],  // 복사할 전표 CZ_Q_PUSAIV 테이블 [ HEADER 그리드 ] 값 불러오기.
                        async: false,
                        data: JSON.stringify({
                            P_GROUP_NUMBER: e.GROUP_NUMBER
                        }),
                        callback: function (res) {
                            console.log("getDocuPusaivCopy", res);

                            for (var i = 0; i < res.list.length; i++) {
                                var oldNoTpdocu = res.list[i].NO_TPDOCU;
                                axboot.ajax({
                                    type: "GET",
                                    url: ["gldocum", "getTpDocu"],
                                    async: false,
                                    callback: function (tpdocu) {
                                        console.log("tpdocu", tpdocu);
                                        var newNoTpdocu = tpdocu.map.noTpdocu;
                                        _LINENO++;
                                        fnObj.gridHeader.addRow();
                                        var lastIdx = nvl(fnObj.gridHeader.target.list.length, fnObj.gridHeader.lastRow());
                                        fnObj.gridHeader.target.select(lastIdx - 1);

                                        fnObj.gridHeader.target.setValue(lastIdx - 1, "noTpdocu", newNoTpdocu);              // 새로 딴 데이터
                                        fnObj.gridHeader.target.setValue(lastIdx - 1, "LINENO", _LINENO); //순번
                                        fnObj.gridHeader.target.setValue(lastIdx - 1, "cdDocu", res.list[i].CD_DOCU); //전표유형:매입(001)(CZ_Q0002)
                                        fnObj.gridHeader.target.setValue(lastIdx - 1, "tpEvidence", res.list[i].TP_EVIDENCE); //증빙유형:세금계산서(3)(CZ_Q0022)
                                        fnObj.gridHeader.target.setValue(lastIdx - 1, "AMT_SUPPLY", res.list[i].AMT); //공급가//매입세금계산서에서 클릭해서 넘어온거라서 무조건데이터가 있음
                                        fnObj.gridHeader.target.setValue(lastIdx - 1, "AMT_VAT", res.list[i].VAT); //부가세
                                        fnObj.gridHeader.target.setValue(lastIdx - 1, "AMT_SUM", res.list[i].AMT_TOT); //합계금액
                                        fnObj.gridHeader.target.setValue(lastIdx - 1, "cdPartner", res.list[i].CD_PARTNER); //거래처코드
                                        fnObj.gridHeader.target.setValue(lastIdx - 1, "lnPartner", res.list[i].LN_PARTNER); //거래처명
                                        fnObj.gridHeader.target.setValue(lastIdx - 1, "dtTrans", datedash(res.list[i].DT_TRANS)); //계산서일자
                                        fnObj.gridHeader.target.setValue(lastIdx - 1, "NO_TAX", datedash(res.list[i].NO_TAX)); //매입세금계산서키값
                                        fnObj.gridHeader.target.setValue(lastIdx - 1, "remark", datedash(res.list[i].REMARK)); //매입세금계산서키값
                                        fnObj.gridHeader.target.setValue(lastIdx - 1, "cdTpdocu", datedash(res.list[i].CD_TPDOCU));
                                        fnObj.gridHeader.target.setValue(lastIdx - 1, "nmTpdocu", datedash(res.list[i].NM_TPDOCU));
                                        fnObj.gridHeader.target.setValue(lastIdx - 1, "CD_EXCH", "000");
                                        fnObj.gridHeader.target.setValue(lastIdx - 1, "NM_EXCH", "KRW");
                                        fnObj.gridHeader.target.setValue(lastIdx - 1, "RT_EXCH", "1.00");
                                        fnObj.gridHeader.target.focus(lastIdx - 1);

                                        axboot.ajax({
                                            type: "POST",
                                            url: ["gldocum", "getDocuAcctentCopy"],  //  복사할 전표 CZ_Q_PUSAIV의 NO_TPDOCU를 가지고 CZ_Q_ACCTENT 값 불러오기.
                                            async: false,
                                            data: JSON.stringify({
                                                P_GROUP_NUMBER: e.GROUP_NUMBER,
                                                P_NO_TPDOCU: oldNoTpdocu
                                            }),
                                            callback: function (result) {
                                                for (var i = 0; i < result.list.length; i++) {
                                                    var obj = result.list[i];
                                                    if (obj.GB == "1") {  //  차변

                                                        fnObj.gridDetailLeft.addRow();

                                                        var lastIdx = nvl(fnObj.gridDetailLeft.target.list.length, fnObj.gridDetailLeft.lastRow());

                                                        fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "tpDrCr", "1");
                                                        fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "LINENO", _LINENO); //순번
                                                        fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "noTpdocu", newNoTpdocu);
                                                        fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "cdAcct", obj.CD_ACCT);
                                                        fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "nmAcct", obj.NM_ACCT);
                                                        fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "amt", obj.AMT);
                                                        fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "cd_budget", obj.CD_BUDGET);
                                                        fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "nm_budget", obj.NM_BUDGET);
                                                        fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "NM_BGACCT", obj.NM_BGACCT);
                                                        fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "CD_BGACCT", obj.CD_BGACCT);
                                                        fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "remark", obj.REMARK);
                                                        fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "tpEvidence", obj.TP_EVIDENCE);
                                                        fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "mngd", obj.CD_MNGD);
                                                        fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "fg_tax", obj.FG_TAX);
                                                        fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "bank_nm", obj.BANK_NM);
                                                        fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "bank_acct_no", obj.BANK_ACCT_NO);
                                                        for (var z = 1; z < 9; z++) {
                                                            fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "CD_MNG" + z, obj["CD_MNG" + z]);
                                                            fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "NM_MNG" + z, obj["NM_MNG" + z]);
                                                            fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "CD_MNGD" + z, obj["CD_MNGD" + z]);
                                                            fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "NM_MNGD" + z, obj["NM_MNGD" + z]);
                                                        }
                                                        fnObj.gridDetailLeft.target.focus(lastIdx - 1);

                                                    } else if (obj.GB == "2") {  //  대변

                                                        fnObj.gridDetailRight.addRow();

                                                        var lastIdx = nvl(fnObj.gridDetailRight.target.list.length, fnObj.gridDetailRight.lastRow());

                                                        fnObj.gridDetailRight.target.setValue(lastIdx - 1, "tpDrCr", "2");
                                                        fnObj.gridDetailRight.target.setValue(lastIdx - 1, "LINENO", _LINENO); //순번
                                                        fnObj.gridDetailRight.target.setValue(lastIdx - 1, "noTpdocu", newNoTpdocu);
                                                        fnObj.gridDetailRight.target.setValue(lastIdx - 1, "cdAcct", obj.CD_ACCT);
                                                        fnObj.gridDetailRight.target.setValue(lastIdx - 1, "nmAcct", obj.NM_ACCT);
                                                        fnObj.gridDetailRight.target.setValue(lastIdx - 1, "amt", obj.AMT);
                                                        fnObj.gridDetailRight.target.setValue(lastIdx - 1, "cd_budget", obj.CD_BUDGET);
                                                        fnObj.gridDetailRight.target.setValue(lastIdx - 1, "nm_budget", obj.NM_BUDGET);
                                                        fnObj.gridDetailRight.target.setValue(lastIdx - 1, "NM_BGACCT", obj.NM_BGACCT);
                                                        fnObj.gridDetailRight.target.setValue(lastIdx - 1, "CD_BGACCT", obj.CD_BGACCT);
                                                        fnObj.gridDetailRight.target.setValue(lastIdx - 1, "remark", obj.REMARK);
                                                        fnObj.gridDetailRight.target.setValue(lastIdx - 1, "tpEvidence", obj.TP_EVIDENCE);
                                                        fnObj.gridDetailRight.target.setValue(lastIdx - 1, "mngd", obj.CD_MNGD);
                                                        fnObj.gridDetailRight.target.setValue(lastIdx - 1, "fg_tax", obj.FG_TAX);
                                                        fnObj.gridDetailRight.target.setValue(lastIdx - 1, "bank_nm", obj.BANK_NM);
                                                        fnObj.gridDetailRight.target.setValue(lastIdx - 1, "bank_acct_no", obj.BANK_ACCT_NO);
                                                        for (var z = 1; z < 9; z++) {
                                                            fnObj.gridDetailRight.target.setValue(lastIdx - 1, "CD_MNG" + z, obj["CD_MNG" + z]);
                                                            fnObj.gridDetailRight.target.setValue(lastIdx - 1, "NM_MNG" + z, obj["NM_MNG" + z]);
                                                            fnObj.gridDetailRight.target.setValue(lastIdx - 1, "CD_MNGD" + z, obj["CD_MNGD" + z]);
                                                            fnObj.gridDetailRight.target.setValue(lastIdx - 1, "NM_MNGD" + z, obj["NM_MNGD" + z]);
                                                        }

                                                        fnObj.gridDetailRight.target.focus(lastIdx - 1);
                                                    }
                                                }

                                            }
                                        })
                                    }
                                });
                            }

                        }
                    });
                    modal.close();
                };

                modal.open({
                    width: 800,
                    height: _pop_height500,
                    position: {
                        left: "center",
                        top: _pop_top500
                    },
                    iframe: {
                        method: "get",
                        url: "/jsp/ensys/gl/popDocucopy.jsp",
                        param: "callBack=userCallBack"
                        //param: "callBack=userCallBack&groupnumber=" + cdAcct +"&tpDrCr=" + tpDrCr.substr(0,1) +"&cdDocu="+cdDocu
                    },
                    onStateChanged: function () {
                        // mask
                        if (this.state === "open") {
                            mask.open();
                        } else if (this.state === "close") {
                            mask.close();
                        }
                    }
                }, function () {

                });
            };

            var ParentModal = new ax5.ui.modal();
            var calenderModal = new ax5.ui.modal();

            function openCalenderModal(callBack, viewName, initData) {  //  관리항목 CALENDER 도움창오픈 (달력)
                var map = new Map();
                map.set("modal", calenderModal);
                map.set("modalText", "calenderModal");
                map.set("viewName", viewName);
                map.set("initData", initData);

                $.openCommonUtils(callBack, map, 'calender');
            }

            function openModal2(name, action, callBack, viewName, initData) {
                var map = new Map();
                map.set("modal", ParentModal);
                map.set("modalText", "ParentModal");
                map.set("action", action);
                map.set("keyword", "");
                map.set("viewName", viewName);
                map.set("initData", initData);

                $.openMuiltiPopup(name, callBack, map, 600, _pop_height, _pop_top);
            }

            function calc() {
                var AMTL = gridValueSum(fnObj.gridDetailLeft, "amt");
                var AMTR = gridValueSum(fnObj.gridDetailRight, "amt");
                $("#calc").val(comma(AMTL - AMTR));
            }

            function gridValueSum(grid, column) {
                var list = grid.target.list;
                var i = list.length;
                var AMT = 0;
                while (i--) {
                    AMT += parseInt(eval("list[" + i + "]." + column)) || 0;
                }
                i = null;

                return AMT;
            }

            function receptCallBack(map) {
                var mngd = "";
                if (map.get("TPDRCR") == "1") {
                    fnObj.gridDetailLeft.target.setValue(map.get("index"), "ADDPARAM", map.get("ADDPARAM"));
                    // 접대비 팝업창 금액수정시 본 화면으로 금액 재설정 주석
                    //fnObj.gridDetailLeft.target.setValue(map.get("index"), "amt", map.get("AMT"));
                    //fnObj.gridDetailLeft.target.setValue(map.get("index"), "TEMP_RECEPT", map.get("AMT"));

                    for (var i = 1; i <= 8; i++) {
                        if (fnObj.gridDetailLeft.target.getList()[map.get("index")]["CD_MNG" + i] == "C14") {
                            fnObj.gridDetailLeft.target.setValue(map.get("index"), "CD_MNGD" + i, map.get("GB_TAX"));
                            fnObj.gridDetailLeft.target.setValue(map.get("index"), "NM_MNGD" + i, map.get("NM_GB_TAX"));
                        }
                        mngd += nvl(fnObj.gridDetailLeft.target.getList()[map.get("index")]["NM_MNGD" + i], '');
                        if (i != 8) mngd += "*";
                    }
                    fnObj.gridDetailLeft.target.setValue(map.get("index"), "mngd", mngd);
                } else {
                    fnObj.gridDetailRight.target.setValue(map.get("index"), "ADDPARAM", map.get("ADDPARAM"));
                    // 접대비 팝업창 금액수정시 본 화면으로 금액 재설정 주석
                    // fnObj.gridDetailRight.target.setValue(map.get("index"), "amt", map.get("AMT"));
                    // fnObj.gridDetailRight.target.setValue(map.get("index"), "TEMP_RECEPT", map.get("AMT"));

                    for (var i = 1; i <= 8; i++) {
                        if (fnObj.gridDetailRight.target.getList()[map.get("index")]["CD_MNG" + i] == "C14") {
                            fnObj.gridDetailRight.target.setValue(map.get("index"), "CD_MNGD" + i, map.get("GB_TAX"));
                            fnObj.gridDetailRight.target.setValue(map.get("index"), "NM_MNGD" + i, map.get("NM_GB_TAX"));
                        }
                        mngd += nvl(fnObj.gridDetailRight.target.getList()[map.get("index")]["NM_MNGD" + i], '');
                        if (i != 8) mngd += "*";
                    }
                    fnObj.gridDetailRight.target.setValue(map.get("index"), "mngd", mngd);
                }

            }

            function vatCallBack(map) {
                var mngd = "";
                if (map.get("TPDRCR") == "1") {
                    fnObj.gridDetailLeft.target.setValue(map.get("index"), "ADDPARAM", map.get("ADDPARAM"));
                    fnObj.gridDetailLeft.target.setValue(map.get("index"), "amt", map.get("AMT"));
                    /*for (var i = 0; i < fnObj.gridHeader.target.list.length; i++) {
                        if (fnObj.gridDetailLeft.target.list[map.get("index")].noTpdocu == fnObj.gridHeader.target.list[i].noTpdocu) {
                            fnObj.gridHeader.target.setValue(i, "cdPartner", map.get("CD_PARTNER"));
                            fnObj.gridHeader.target.setValue(i, "lnPartner", map.get("LN_PARTNER"));
                        }
                    }*/
                    fnObj.gridDetailLeft.target.setValue(map.get("index"), "GB_TAX", map.get("GB_TAX"));
                    fnObj.gridDetailLeft.target.setValue(map.get("index"), "AMOUNT_SUPPLY", map.get("AMOUNT_SUPPLY"));
                    fnObj.gridDetailLeft.target.setValue(map.get("index"), "TEMP_VAT", map.get("TEMP_VAT"));
                    fnObj.gridDetailLeft.target.setValue(map.get("index"), "AM_SUPPLY", map.get("AM_SUPPLY"));


                    /*  부가세 값 바인딩   */
                    var item = fnObj.gridDetailLeft.target.list[this.dindex];
                    var GB_TAX = '';
                    for (var i = 0; i < fg_taxApproveData.length; i++) {
                        if (fg_taxApproveData[i].CODE == map.get("GB_TAX")) {
                            GB_TAX = fg_taxApproveData[i].TEXT;
                        }
                    }
                    myModel_LEFT.setModel({
                        LEFT_GB_TAX: GB_TAX,
                        LEFT_AMOUNT_SUPPLY: map.get("AMOUNT_SUPPLY"),
                        LEFT_AM_SUPPLY: map.get("AM_SUPPLY"),
                        LEFT_TEMP_VAT: map.get("TEMP_VAT")
                    }, $(document["binder-form-Left"]));
                    /*  부가세 값 바인딩   */


                    for (var i = 1; i <= 8; i++) {
                        if (fnObj.gridDetailLeft.target.getList()[map.get("index")]["CD_MNG" + i] == "A06") {   //  거래처
                            fnObj.gridDetailLeft.target.setValue(map.get("index"), "CD_MNGD" + i, map.get("CD_PARTNER"));
                            fnObj.gridDetailLeft.target.setValue(map.get("index"), "NM_MNGD" + i, map.get("LN_PARTNER"));
                        }
                        if (fnObj.gridDetailLeft.target.getList()[map.get("index")]["CD_MNG" + i] == "C01") {   //  사업자번호
                            fnObj.gridDetailLeft.target.setValue(map.get("index"), "CD_MNGD" + i, map.get("NO_COMPANY"));
                            fnObj.gridDetailLeft.target.setValue(map.get("index"), "NM_MNGD" + i, $.changeDataFormat(map.get("NO_COMPANY")), 'company');
                        }
                        if (fnObj.gridDetailLeft.target.getList()[map.get("index")]["CD_MNG" + i] == "C14") {   //  세무구분
                            fnObj.gridDetailLeft.target.setValue(map.get("index"), "CD_MNGD" + i, map.get("GB_TAX"));
                            fnObj.gridDetailLeft.target.setValue(map.get("index"), "NM_MNGD" + i, map.get("NM_GB_TAX"));
                        }
                        if (fnObj.gridDetailLeft.target.getList()[map.get("index")]["CD_MNG" + i] == "C05") {   //  과세표준액
                            fnObj.gridDetailLeft.target.setValue(map.get("index"), "CD_MNGD" + i, uncomma(map.get("AM_SUPPLY")));
                            fnObj.gridDetailLeft.target.setValue(map.get("index"), "NM_MNGD" + i, map.get("AM_SUPPLY"));
                        }
                        mngd += nvl(fnObj.gridDetailLeft.target.getList()[map.get("index")]["NM_MNGD" + i], '');
                        if (i != 8) mngd += "*";
                    }
                    fnObj.gridDetailLeft.target.setValue(map.get("index"), "mngd", mngd);
                } else {
                    fnObj.gridDetailRight.target.setValue(map.get("index"), "ADDPARAM", map.get("ADDPARAM"));
                    fnObj.gridDetailRight.target.setValue(map.get("index"), "amt", map.get("AMT"));
                    /*for (var i = 0; i < fnObj.gridHeader.target.list.length; i++) {
                        if (fnObj.gridDetailRight.target.list[map.get("index")].noTpdocu == fnObj.gridHeader.target.list[i].noTpdocu) {
                            fnObj.gridHeader.target.setValue(i, "cdPartner", map.get("CD_PARTNER"));
                            fnObj.gridHeader.target.setValue(i, "lnPartner", map.get("LN_PARTNER"));
                        }
                    }*/

                    fnObj.gridDetailRight.target.setValue(map.get("index"), "GB_TAX", map.get("GB_TAX"));
                    fnObj.gridDetailRight.target.setValue(map.get("index"), "AMOUNT_SUPPLY", map.get("AMOUNT_SUPPLY"));
                    fnObj.gridDetailRight.target.setValue(map.get("index"), "TEMP_VAT", map.get("TEMP_VAT"));
                    fnObj.gridDetailRight.target.setValue(map.get("index"), "AM_SUPPLY", map.get("AM_SUPPLY"));

                    /*  부가세 값 바인딩   */
                    var item = fnObj.gridDetailRight.target.list[this.dindex];
                    var GB_TAX = '';
                    for (var i = 0; i < fg_taxApproveData.length; i++) {
                        if (fg_taxApproveData[i].CODE == map.get("GB_TAX")) {
                            GB_TAX = fg_taxApproveData[i].TEXT;
                        }
                    }
                    myModel_RIGHT.setModel({
                        RIGHT_GB_TAX: GB_TAX,
                        RIGHT_AMOUNT_SUPPLY: map.get("AMOUNT_SUPPLY"),
                        RIGHT_AM_SUPPLY: map.get("AM_SUPPLY"),
                        RIGHT_TEMP_VAT: map.get("TEMP_VAT")
                    }, $(document["binder-form-Right"]));
                    /*  부가세 값 바인딩   */

                    for (var i = 1; i <= 8; i++) {
                        if (fnObj.gridDetailRight.target.getList()[map.get("index")]["CD_MNG" + i] == "A06") {   //  거래처
                            fnObj.gridDetailRight.target.setValue(map.get("index"), "CD_MNGD" + i, map.get("CD_PARTNER"));
                            fnObj.gridDetailRight.target.setValue(map.get("index"), "NM_MNGD" + i, map.get("LN_PARTNER"));
                        }
                        if (fnObj.gridDetailRight.target.getList()[map.get("index")]["CD_MNG" + i] == "C01") {   //  사업자번호
                            fnObj.gridDetailRight.target.setValue(map.get("index"), "CD_MNGD" + i, map.get("NO_COMPANY"));
                            fnObj.gridDetailRight.target.setValue(map.get("index"), "NM_MNGD" + i, $.changeDataFormat(map.get("NO_COMPANY")), 'company');
                        }
                        if (fnObj.gridDetailRight.target.getList()[map.get("index")]["CD_MNG" + i] == "C14") {
                            fnObj.gridDetailRight.target.setValue(map.get("index"), "CD_MNGD" + i, map.get("GB_TAX"));
                            fnObj.gridDetailRight.target.setValue(map.get("index"), "NM_MNGD" + i, map.get("NM_GB_TAX"));
                        }
                        if (fnObj.gridDetailRight.target.getList()[map.get("index")]["CD_MNG" + i] == "C05") {   //  과세표준액
                            fnObj.gridDetailRight.target.setValue(map.get("index"), "CD_MNGD" + i, uncomma(map.get("AM_SUPPLY")));
                            fnObj.gridDetailRight.target.setValue(map.get("index"), "NM_MNGD" + i, map.get("AM_SUPPLY"));
                        }
                        mngd += nvl(fnObj.gridDetailRight.target.getList()[map.get("index")]["NM_MNGD" + i], '');
                        if (i != 8) mngd += "*";
                    }
                    fnObj.gridDetailRight.target.setValue(map.get("index"), "mngd", mngd);
                }

            }

            function comma(num) {
                num = num.toString();

                var len, point, str;
                if (num.substring(0, 1) == "-") {
                    num = num.replace("-", "");
                    num = num + "";
                    point = num.length % 3;
                    len = num.length;

                    str = num.substring(0, point);
                    while (point < len) {
                        if (str != "") str += ",";
                        str += num.substring(point, point + 3);
                        point += 3;
                    }
                    return "-" + str;
                } else {
                    point = num.length % 3;
                    len = num.length;

                    str = num.substring(0, point);
                    while (point < len) {
                        if (str != "") str += ",";
                        str += num.substring(point, point + 3);
                        point += 3;
                    }
                    return str;
                }
            }

            function uncomma(str) {
                str = str.toString();
                var len = str.length;
                var sReturn = "";
                for (var i = 0; i < len; i++) {
                    if ((str.charAt(i) >= "0") && (str.charAt(i) <= "9")) {
                        sReturn += str.charAt(i);
                    }
                }

                return Number(sReturn);
            }

            function datedash(str) {
                if (!str)
                    return "";

                if (str.length != 8) {
                    return str;
                }

                var returnstr = '';
                returnstr = str.substring(0, 4) + "-" + str.substring(4, 6) + "-" + str.substring(6, 8);

                return returnstr;
            }

            // 예산통제 팝업
            function BudgetControl(grid, item) {
                if (item.CD_BGACCT && item.cd_budget && item.cdAcct) {
                    var list = grid.target.list;

                    var temp_amt_tot = 0;
                    for (var i = 0; i < list.length; i++) {
                        if (list[i].cd_budget == item.cd_budget && list[i].CD_BGACCT == item.CD_BGACCT)
                            temp_amt_tot += parseInt(uncomma(list[i].amt));
                    }


                    var result = $.DATA_SEARCH('apbucard', 'acctBudgetAmt', {
                        CD_BGACCT: item.CD_BGACCT,
                        CD_BUDGET: item.cd_budget,
                        DT_ACCT: $("#dtAcct").val().replace(/-/g, ""),
                        APPLY_AMT: temp_amt_tot
                    });
                    grid.target.setValue(item.__index, "AMT0", result.list[0].AMT0);
                    grid.target.setValue(item.__index, "AMT1", result.list[0].AMT1);
                    console.log("예산통제 팝업으로 보내는 데이터 : ", result);


                    var data = {
                        CD_BGACCT: item.CD_BGACCT,
                        CD_BUDGET: item.cd_budget,
                        CD_ACCT: item.cdAcct,
                        AMT0: result.list[0].AMT0, //실행
                        AMT1: result.list[0].AMT1, //집행
                        AMT2: result.list[0].AMT2, //잔여
                        APPLY_AMT: temp_amt_tot,       //신청
                        OVER_AMT: result.list[0].OVER_AMT //초과
                    };

                    $.openCommonPopup('budgetControl', "", '', '', data, 500, 380, _pop_top380);

                    for (var i = 0; i < list.length; i++) {
                        if (list[i].cd_budget == item.cd_budget && list[i].CD_BGACCT == item.CD_BGACCT) {
                            if (result && result.list && result.list[i] && result.list[i].CONTROL_YN && result.list[i].CONTROL_YN == "Y") {
                                grid.target.setValue(i, "OVER_AMT", result.list[0].OVER_AMT);
                            }
                            else{
                                grid.target.setValue(i, "OVER_AMT", 0);
                            }
                        }
                    }
                }
            }

            //관리항목필수여부,계정에 대한 관리항목 그리드에 세팅
            function setStMngd(cdacct, drcr, gridindex) {
                axboot.ajax({
                    async:false,
                    type: "POST",
                    url: ["gldocum", "getMngd"],
                    data: JSON.stringify({
                        CD_ACCT: cdacct
                    }),
                    callback: function (res) {
                        console.log(res);
                        if (res.map['RESULT'] == null) {

                            if (drcr == "1") { //left차변
                                //{key: "ST_MNG1",  label: "h_관리항목필수1", editor: false, hidden:false},//X 필수아님 , A 차대필수, C 대변필수 , D 차변필수
                                for (var i = 1; i <= 8; i++) {
                                    fnObj.gridDetailLeft.target.setValue(gridindex, "ST_MNG" + i, res.map["ST_MNG" + i]);
                                    fnObj.gridDetailLeft.target.setValue(gridindex, "CD_MNG" + i, res.map["CD_MNG" + i]);
                                    fnObj.gridDetailLeft.target.setValue(gridindex, "NM_MNG" + i, res.map["NM_MNG" + i]);
                                }
                            } else { //right 대변
                                for (var i = 1; i <= 8; i++) {
                                    fnObj.gridDetailRight.target.setValue(gridindex, "ST_MNG" + i, res.map["ST_MNG" + i]);
                                    fnObj.gridDetailRight.target.setValue(gridindex, "CD_MNG" + i, res.map["CD_MNG" + i]);
                                    fnObj.gridDetailRight.target.setValue(gridindex, "NM_MNG" + i, res.map["NM_MNG" + i]);
                                }
                            }
                        }
                    }
                });
            }

            //관리항목필수체크
            function checkStMngd() {
                var gridL = fnObj.gridDetailLeft.target.list;
                var gridR = fnObj.gridDetailRight.target.list;

                for (var i = 0; i < gridL.length; i++) {
                    //{key: "ST_MNG1",  label: "h_관리항목필수1", editor: false, hidden:false},//X 필수아님 , A 차대필수, C 대변필수 , D 차변필수
                    for (var k = 1; k <= 8; k++) {
                        if ((gridL[i]["ST_MNG" + k] == "A" || gridL[i]["ST_MNG" + k] == "D") && !gridL[i]["CD_MNGD" + k]) return false;
                    }
                }

                for (var i = 0; i < gridR.length; i++) {
                    //{key: "ST_MNG1",  label: "h_관리항목필수1", editor: false, hidden:false},//X 필수아님 , A 차대필수, C 대변필수 , D 차변필수
                    for (var k = 1; k <= 8; k++) {
                        if ((gridR[i]["ST_MNG" + k] == "A" || gridR[i]["ST_MNG" + k] == "C") && !gridR[i]["CD_MNGD" + k]) return false;
                    }
                }

                return true;
            }

            //계정변경시 관리항목 클리어
            function clearMngd(drcr, gridindex) {
                if (drcr == "1") { //left차변
                    fnObj.gridDetailLeft.target.setValue(gridindex, "mngd", "");
                    for (var i = 1; i <= 8; i++) {
                        fnObj.gridDetailLeft.target.setValue(gridindex, "CD_MNGD" + i, "");
                        fnObj.gridDetailLeft.target.setValue(gridindex, "NM_MNGD" + i, "");
                    }
                } else { //right 대변
                    fnObj.gridDetailRight.target.setValue(gridindex, "mngd", "");
                    for (var i = 1; i <= 8; i++) {
                        fnObj.gridDetailRight.target.setValue(gridindex, "CD_MNGD" + i, "");
                        fnObj.gridDetailRight.target.setValue(gridindex, "NM_MNGD" + i, "");
                    }
                }
            }

            //관리항목자동세팅해줄값가져오기
            //사원코드,거래처코드,날짜,금액,키값명칭,키값
            function getAutoMngd(no_emp, cd_partner, date, amt, keyvaluename, keyvalue) {
                axboot.ajax({
                    type: "POST",
                    url: ["gldocum", "getAutoMngd"],
                    data: JSON.stringify({
                        NO_EMP: no_emp
                        , CD_PARTNER: cd_partner
                        , DATE: date
                        , AMT: amt
                    }),
                    callback: function (res) {
                        var gridL = fnObj.gridDetailLeft.target.list;
                        var gridR = fnObj.gridDetailRight.target.list;

                        for (var i = 0; i < gridL.length; i++) {
                            var lmngd = "";
                            for (var k = 1; k <= 8; k++) {
                                if (gridL[i]["CD_MNG" + k] == "A01" && gridL[i][keyvaluename] == keyvalue) {
                                    gridL[i]["CD_MNGD" + k] = res.map["A01"];
                                    gridL[i]["NM_MNGD" + k] = res.map["N_A01"];
                                }
                                if (gridL[i]["CD_MNG" + k] == "A02" && gridL[i][keyvaluename] == keyvalue) {
                                    gridL[i]["CD_MNGD" + k] = res.map["A02"];
                                    gridL[i]["NM_MNGD" + k] = res.map["N_A02"];
                                }
                                if (gridL[i]["CD_MNG" + k] == "A03" && gridL[i][keyvaluename] == keyvalue) {
                                    gridL[i]["CD_MNGD" + k] = res.map["A03"];
                                    gridL[i]["NM_MNGD" + k] = res.map["N_A03"];
                                }
                                if (gridL[i]["CD_MNG" + k] == "A04" && gridL[i][keyvaluename] == keyvalue) {
                                    gridL[i]["CD_MNGD" + k] = res.map["A04"];
                                    gridL[i]["NM_MNGD" + k] = res.map["N_A04"];
                                }
                                if (gridL[i]["CD_MNG" + k] == "A05" && gridL[i][keyvaluename] == keyvalue) {
                                    gridL[i]["CD_MNGD" + k] = res.map["A05"];
                                    gridL[i]["NM_MNGD" + k] = res.map["N_A05"];
                                }
                                if (gridL[i]["CD_MNG" + k] == "A06" && gridL[i][keyvaluename] == keyvalue) {
                                    gridL[i]["CD_MNGD" + k] = res.map["A06"];
                                    gridL[i]["NM_MNGD" + k] = res.map["N_A06"];
                                }
                                if (gridL[i]["CD_MNG" + k] == "B21" && gridL[i][keyvaluename] == keyvalue) {
                                    gridL[i]["CD_MNGD" + k] = res.map["B21"];
                                    gridL[i]["NM_MNGD" + k] = res.map["B21"];
                                }
                                if (gridL[i]["CD_MNG" + k] == "B23" && gridL[i][keyvaluename] == keyvalue) {
                                    gridL[i]["CD_MNGD" + k] = res.map["B23"];
                                    gridL[i]["NM_MNGD" + k] = res.map["B23"];
                                }
                                if (gridL[i]["CD_MNG" + k] == "C01" && gridL[i][keyvaluename] == keyvalue) {
                                    gridL[i]["CD_MNGD" + k] = res.map["C01"];
                                    gridL[i]["NM_MNGD" + k] = res.map["C01"];
                                }
                                if (gridL[i]["CD_MNG" + k] == "C05" && gridL[i][keyvaluename] == keyvalue) {
                                    gridL[i]["CD_MNGD" + k] = res.map["C05"];
                                    gridL[i]["NM_MNGD" + k] = res.map["C05"];
                                }
                                if (gridL[i]["CD_MNG" + k] == "C12" && gridL[i][keyvaluename] == keyvalue) {
                                    gridL[i]["CD_MNGD" + k] = res.map["C12"];
                                    gridL[i]["NM_MNGD" + k] = res.map["C12"];
                                }
                                if (gridL[i]["CD_MNG" + k] == "C15" && gridL[i][keyvaluename] == keyvalue) {
                                    gridL[i]["CD_MNGD" + k] = res.map["C15"];
                                    gridL[i]["NM_MNGD" + k] = res.map["N_C15"];
                                }
                                if (gridL[i]["CD_MNG" + k] == "C16" && gridL[i][keyvaluename] == keyvalue) {
                                    gridL[i]["CD_MNGD" + k] = res.map["C16"];
                                    gridL[i]["NM_MNGD" + k] = res.map["C16"];
                                }
                                lmngd += nvl(gridL[i]["NM_MNGD" + k], '');
                                if (k != 8) lmngd += "*";
                            }
                            gridL[i]["mngd"] = lmngd;
                        }

                        for (var i = 0; i < gridR.length; i++) {
                            var rmngd = "";
                            for (var k = 1; k <= 8; k++) {
                                if (gridR[i]["CD_MNG" + k] == "A01" && gridR[i][keyvaluename] == keyvalue) {
                                    gridR[i]["CD_MNGD" + k] = res.map["A01"];
                                    gridR[i]["NM_MNGD" + k] = res.map["N_A01"];
                                }
                                if (gridR[i]["CD_MNG" + k] == "A02" && gridR[i][keyvaluename] == keyvalue) {
                                    gridR[i]["CD_MNGD" + k] = res.map["A02"];
                                    gridR[i]["NM_MNGD" + k] = res.map["N_A02"];
                                }
                                if (gridR[i]["CD_MNG" + k] == "A03" && gridR[i][keyvaluename] == keyvalue) {
                                    gridR[i]["CD_MNGD" + k] = res.map["A03"];
                                    gridR[i]["NM_MNGD" + k] = res.map["N_A03"];
                                }
                                if (gridR[i]["CD_MNG" + k] == "A04" && gridR[i][keyvaluename] == keyvalue) {
                                    gridR[i]["CD_MNGD" + k] = res.map["A04"];
                                    gridR[i]["NM_MNGD" + k] = res.map["N_A04"];
                                }
                                if (gridR[i]["CD_MNG" + k] == "A05" && gridR[i][keyvaluename] == keyvalue) {
                                    gridR[i]["CD_MNGD" + k] = res.map["A05"];
                                    gridR[i]["NM_MNGD" + k] = res.map["N_A05"];
                                }
                                if (gridR[i]["CD_MNG" + k] == "A06" && gridR[i][keyvaluename] == keyvalue) {
                                    gridR[i]["CD_MNGD" + k] = res.map["A06"];
                                    gridR[i]["NM_MNGD" + k] = res.map["N_A06"];
                                }
                                if (gridR[i]["CD_MNG" + k] == "B21" && gridR[i][keyvaluename] == keyvalue) {
                                    gridR[i]["CD_MNGD" + k] = res.map["B21"];
                                    gridR[i]["NM_MNGD" + k] = res.map["B21"];
                                }
                                if (gridR[i]["CD_MNG" + k] == "B23" && gridR[i][keyvaluename] == keyvalue) {
                                    gridR[i]["CD_MNGD" + k] = res.map["B23"];
                                    gridR[i]["NM_MNGD" + k] = res.map["B23"];
                                }
                                if (gridR[i]["CD_MNG" + k] == "C01" && gridR[i][keyvaluename] == keyvalue) {
                                    gridR[i]["CD_MNGD" + k] = res.map["C01"];
                                    gridR[i]["NM_MNGD" + k] = res.map["C01"];
                                }
                                if (gridR[i]["CD_MNG" + k] == "C05" && gridR[i][keyvaluename] == keyvalue) {
                                    gridR[i]["CD_MNGD" + k] = res.map["C05"];
                                    gridR[i]["NM_MNGD" + k] = res.map["C05"];
                                }
                                if (gridR[i]["CD_MNG" + k] == "C12" && gridR[i][keyvaluename] == keyvalue) {
                                    gridR[i]["CD_MNGD" + k] = res.map["C12"];
                                    gridR[i]["NM_MNGD" + k] = res.map["C12"];
                                }
                                if (gridR[i]["CD_MNG" + k] == "C15" && gridR[i][keyvaluename] == keyvalue) {
                                    gridR[i]["CD_MNGD" + k] = res.map["C15"];
                                    gridR[i]["NM_MNGD" + k] = res.map["N_C15"];
                                }
                                if (gridR[i]["CD_MNG" + k] == "C16" && gridR[i][keyvaluename] == keyvalue) {
                                    gridR[i]["CD_MNGD" + k] = res.map["C16"];
                                    gridR[i]["NM_MNGD" + k] = res.map["C16"];
                                }
                                rmngd += nvl(gridR[i]["NM_MNGD" + k], '');
                                if (k != 8) rmngd += "*";
                            }
                            gridR[i]["mngd"] = rmngd;
                        }

                        /*
                        A01 사업장
                        A02 코스트센타
                        A03 부서
                        A04 사원
                        A05 프로젝트
                        A06 거래처

                        B21 발생일자
                        B23 만기일자

                        C01 사업자등록번호
                        C05 과세표준액 amt?
                        C12 수금일자 날짜
                        C14 세무구분?
                        C15 거래처계좌번호
                        */
                    }
                });
            }

            function setamtline(model){

                var gridleft = fnObj.gridDetailLeft.target;
                var gridright = fnObj.gridDetailRight.target;
                var t_rowDatasleft = fnObj.gridDetailLeft.target.list;
                var t_rowDatasright = fnObj.gridDetailRight.target.list;

                if (t_rowDatasleft.length > 0){

                    var DrCnt = 0; // 차변계정
                    var CrCnt = 0; // 대변계정
                    var DrTaxCnt = 0;	//	차변부가세계정
                    var CrTaxCnt = 0;	//	대변부가세계정
                    var DifferenceNoTaxAmt = 0; //
                    var DifferenceTaxAmt = 0; //
                    var NoTaxChkVal = false;
                    var TaxChkVal = false;


                    for(var i =0;i<t_rowDatasleft.length;i++){

                        if (model.noTpdocu == t_rowDatasleft[i].noTpdocu ) {
                            if (tax_acct.indexOf(t_rowDatasleft[i].cdAcct) > -1){
                                DrTaxCnt++;
                            }else{
                                DrCnt++;
                            }
                        }
                    }

                    var AMT = 0, VAT = 0;
                    if (DrTaxCnt == 0){
                        AMT = Number(model.AMT_SUM);
                        VAT = 0;
                    }else{
                        AMT = Number(model.AMT_SUPPLY);
                        VAT = Number(model.AMT_VAT);
                    }

                    if ((Math.floor(AMT / DrCnt)) * DrCnt != AMT){	// 차변부가세계정 갯 수만큼	나눈 후 절사했을 때 총합 금액이 같지않는다면
                        DifferenceNoTaxAmt =  Number(AMT) - (Math.floor(Number((AMT) / DrCnt)) * DrCnt);
                        NoTaxChkVal = true;
                    }
                    if ((Math.floor(VAT / DrTaxCnt)) * DrTaxCnt != VAT){	// 차변부가세계정 갯 수만큼	나눈 후 절사했을 때 총합 금액이 같지않는다면
                        DifferenceTaxAmt =  Number(VAT) - (Math.floor(Number((VAT) / DrTaxCnt)) * DrTaxCnt);
                        TaxChkVal = true;
                    }

                    for(var i =0;i<t_rowDatasleft.length;i++){

                        if (model.noTpdocu == t_rowDatasleft[i].noTpdocu ) {
                            if (tax_acct.indexOf(t_rowDatasleft[i].cdAcct) > -1){
                                if(TaxChkVal){
                                    gridleft.setValue(i, 'amt', Math.floor(VAT / DrTaxCnt) + DifferenceTaxAmt);
                                    TaxChkVal = false;
                                }else{
                                    gridleft.setValue(i, 'amt', Math.floor(VAT / DrTaxCnt));
                                }
                            }else{
                                if(NoTaxChkVal){
                                    gridleft.setValue(i, 'amt', Math.floor(AMT / DrCnt) + DifferenceNoTaxAmt);
                                    NoTaxChkVal = false;
                                }else{
                                    gridleft.setValue(i, 'amt', Math.floor(AMT / DrCnt));
                                }
                            }
                        }
                    }
                }

                if (t_rowDatasright != null){

                    var DrCnt = 0; // 차변계정
                    var CrCnt = 0; // 대변계정
                    var DrTaxCnt = 0;	//	차변부가세계정
                    var CrTaxCnt = 0;	//	대변부가세계정
                    var DifferenceNoTaxAmt = 0; //
                    var DifferenceTaxAmt = 0; //
                    var NoTaxChkVal = false;
                    var TaxChkVal = false;

                    for(var i =0;i<t_rowDatasright.length;i++){

                        if (model.noTpdocu == t_rowDatasright[i].noTpdocu ) {
                            if (tax_acct.indexOf(t_rowDatasright[i].cdAcct) > -1){
                                DrTaxCnt++;
                            }else{
                                DrCnt++;
                            }
                        }
                    }


                    var AMT = 0, VAT = 0;
                    if (DrTaxCnt == 0){
                        AMT = Number(model.AMT_SUM);
                        VAT = 0;
                    }else{
                        AMT = Number(model.AMT_SUPPLY);
                        VAT = Number(model.AMT_VAT);
                    }

                    if ((Math.floor(AMT / DrCnt)) * DrCnt != AMT){	// 차변부가세계정 갯 수만큼	나눈 후 절사했을 때 총합 금액이 같지않는다면
                        DifferenceNoTaxAmt =  Number(AMT) - (Math.floor(Number((AMT) / DrCnt)) * DrCnt);
                        NoTaxChkVal = true;
                    }
                    if ((Math.floor(VAT / DrTaxCnt)) * DrTaxCnt != VAT){	// 차변부가세계정 갯 수만큼	나눈 후 절사했을 때 총합 금액이 같지않는다면
                        DifferenceTaxAmt =  Number(VAT) - (Math.floor(Number((VAT) / DrTaxCnt)) * DrTaxCnt);
                        TaxChkVal = true;
                    }

                    for(var i =0;i<t_rowDatasright.length;i++){

                        if (model.noTpdocu == t_rowDatasright[i].noTpdocu ) {
                            if (tax_acct.indexOf(t_rowDatasright[i].cdAcct) > -1){
                                if(TaxChkVal){
                                    gridright.setValue(i, 'amt', Math.floor(VAT / DrTaxCnt) + DifferenceTaxAmt);
                                    TaxChkVal = false;
                                }else{
                                    gridright.setValue(i, 'amt', Math.floor(VAT / DrTaxCnt));
                                }
                            }else{
                                if(NoTaxChkVal){
                                    gridright.setValue(i, 'amt', Math.floor(AMT / DrCnt) + DifferenceNoTaxAmt);
                                    NoTaxChkVal = false;
                                }else{
                                    gridright.setValue(i, 'amt', Math.floor(AMT / DrCnt));
                                }
                            }
                        }
                    }
                }
            }

            $("#dtAcct").change(function () {
                var gridH = fnObj.gridHeader.target.list;

                for (var i = 0; i < gridH.length; i++) {
                    if (nvl($("#dtAcct").val()).replace(/-/gi, "") != '' && nvl(gridH[i].CD_EXCH) != '') {
                        var data = $.DATA_SEARCH('gldocum', 'getRtExch', {
                            DT_TARGET: nvl($("#dtAcct").val()).replace(/-/gi, ""),
                            CD_EXCH: gridH[i].CD_EXCH
                        });

                        fnObj.gridHeader.target.setValue(i, "RT_EXCH", data.map.RT_EXCH);
                        if (nvl(gridH[i].AMT_LOCAL).trim() != '' && nvl($("#dtAcct").val()).replace(/-/gi, "") != '' && nvl(gridH[i].CD_EXCH) != '')
                            fnObj.gridHeader.target.setValue(i, "AMT_SUPPLY", (parseInt(gridH[i].AMT_LOCAL) * parseInt(gridH[i].RT_EXCH)));
                    } else {
                        fnObj.gridHeader.target.setValue(i, "RT_EXCH", 0);
                    }
                    if (nvl(gridH[i].AMT_LOCAL).trim() != '') {
                        fnObj.gridHeader.target.setValue(i, "AMT_SUPPLY", (parseInt(gridH[i].RT_EXCH) * parseInt(gridH[i].AMT_LOCAL)));
                    }
                }
                for (var i = 0; i < fnObj.gridDetailLeft.target.list.length; i++) {
                    var list = fnObj.gridDetailLeft.target.list[i];

                    if (list.CD_BGACCT && list.cd_budget && list.cdAcct) {
                        BudgetControl(fnObj.gridDetailLeft, list);    //  예산계정
                    }
                }

                for (var i = 0; i < fnObj.gridDetailRight.target.list.length; i++) {
                    var list = fnObj.gridDetailRight.target.list[i];

                    if (list.CD_BGACCT && list.cd_budget && list.cdAcct) {
                        BudgetControl(fnObj.gridDetailRight, list);    //  예산계정
                    }
                }
            });

            function clone(obj) {
                if (obj === null || typeof (obj) !== 'object')
                    return obj;

                var copy = obj.constructor();

                for (var attr in obj) {
                    if (obj.hasOwnProperty(attr)) {
                        copy[attr] = obj[attr];
                    }
                }

                return copy;
            }

            function cloneObject(obj) {
                return JSON.parse(JSON.stringify(obj));
            }

            $(document).ready(function () {

                $("#cdEmp").setParam({
                    CD_DEPT: $("#cdDept").attr('code')
                });

                $("#cdDept").on('change', function (e) {
                    $("#cdEmp").setParam({
                        CD_DEPT: $("#cdDept").attr('code')
                    })
                });

                $("#cdDept").on('dataBind', function (e) {
                    $("#cdEmp").val('');
                    $("#cdEmp").attr('code', '');
                    $("#cdEmp").attr('text', '');

                    $("#cdEmp").setParam({
                        CD_DEPT: $("#cdDept").attr('code')
                    })
                })
            });
            //////////////////////////////////////
            //크기자동조정
            var _pop_top = 0;
            var _pop_top300 = 0;
            var _pop_top380 = 0;
            var _pop_top400 = 0;
            var _pop_top500 = 0;
            var _pop_top800 = 0;
            var _pop_height = 0;
            var _pop_height300 = 0;
            var _pop_height400 = 0;
            var _pop_height500 = 0;
            var _pop_height800 = 0;
            var _pop_width1200 = 0;
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
                    _pop_height300 = 300;
                    _pop_height400 = 400;
                    _pop_height500 = 500;
                    _pop_height800 = 800;
                    _pop_top = parseInt((totheight - _pop_height) / 2);
                    _pop_top300 = parseInt((totheight - 300) / 2);
                    _pop_top380 = parseInt((totheight - 380) / 2);
                    _pop_top400 = parseInt((totheight - 400) / 2);
                    _pop_top500 = parseInt((totheight - 500) / 2);
                    _pop_top800 = parseInt((totheight - 800) / 2);
                } else {
                    _pop_height = totheight / 10 * 8;
                    _pop_height300 = 300;
                    _pop_height400 = 400;
                    _pop_height500 = 500;
                    _pop_height800 = totheight / 10 * 9;
                    _pop_top = parseInt((totheight - _pop_height) / 2);
                    _pop_top300 = parseInt((totheight - 300) / 2);
                    _pop_top380 = parseInt((totheight - 380) / 2);
                    _pop_top400 = parseInt((totheight - 400) / 2);
                    _pop_top500 = parseInt((totheight - 500) / 2);
                    _pop_top800 = parseInt((totheight - _pop_height800) / 2);
                }

                $("#cdDept").attr("HEIGHT", _pop_height);
                $("#cdDept").attr("TOP", _pop_top);
                $("#cdEmp").attr("HEIGHT", _pop_height);
                $("#cdEmp").attr("TOP", _pop_top);

                //데이터가 들어갈 실제높이
                var datarealheight = $("#ax-base-root").height() - $(".ax-base-title").height() - $("#pageheader").height();
                //타이틀을 뺀 상하단 그리드 합친높이
                var tempgridheight = datarealheight - $("#top_title").height() - $("#bottom_left_title").height() - $("#bottom_left_amt").height();

                $("#top_grid").css("height", tempgridheight / 100 * 50);
                $("#bottom_left_grid").css("height", tempgridheight / 100 * 49);
                $("#bottom_right_grid").css("height", tempgridheight / 100 * 49);


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
                        style="width:80px;">
                    <i class="icon_reload"></i></button>

                <button type="button" class="btn btn-info" data-page-btn="new" style="display:none;"><i
                        class="icon_new"></i>신규
                </button>
                <button type="button" class="btn btn-info" id="BtnDocuCopy" data-page-btn="docucopy"
                        style="width:80px;"><i
                        class="icon_slip"></i>전표복사
                </button>
                <button type="button" class="btn btn-info" data-page-btn="save" style="width:80px;"><i
                        class="icon_ok"></i>전표처리
                </button>
            </div>
        </div>
        <div role="page-header" id="pageheader">
            <ax:form name="searchView0">
                <ax:tbl clazz="ax-search-tb1" minWidth="500px">
                    <ax:tr>
                        <ax:td label="회계일자" width="350px">
                            <div class="input-group" data-ax5picker="basic">
                                <input type="text" class="form-control" placeholder="yyyymmdd" name="dtAcct"
                                       id="dtAcct" formatter="YYYYMMDD"/>
                                <span class="input-group-addon"><i class="cqc-calculator"
                                                                   style="cursor: pointer"></i></span>
                            </div>
                        </ax:td>
                        <ax:td label="작성부서" width="350px">
                            <codepicker id="cdDept" HELP_ACTION="HELP_DEPT" HELP_URL="dept" BIND-CODE="CD_DEPT"
                                        BIND-TEXT="NM_DEPT" HELP_DISABLED="false" SESSION/>
                        </ax:td>
                        <ax:td label="작성사원" width="350px">
                            <codepicker id="cdEmp" HELP_ACTION="HELP_EMP" HELP_URL="emp" BIND-CODE="NO_EMP"
                                        BIND-TEXT="NM_EMP" HELP_DISABLED="false" SESSION/>
                        </ax:td>
                        <ax:td label='적요' width="400px">
                            <input type="text" class="form-control W250" name="NM_NOTE" id="NM_NOTE" class="red"
                                   style="background:#ffe4e4"/>
                        </ax:td>
                    </ax:tr>
                </ax:tbl>
            </ax:form>
        </div>

        <%-- 그리드 영역 시작 --%>
        <div style="width:100%;" style="overflow:auto;">
            <div class="ax-button-group" data-fit-height-aside="grid-header" id="top_title">
                <div class="right">
                    <span style="margin-right: 25px">* 편익분류 비용처리 건은 건별 전표처리만 가능합니다.</span>
                    <button type="button" class="btn btn-small" id="BtnHeaderFile" data-grid-header-btn="file"
                            style="width:80px;"><i
                            class=""></i> 파일업로드
                    </button>
                    <button type="button" class="btn btn-small" id="BtnHeaderExp" data-grid-header-btn="exp"
                            style="width:80px;"><i
                            class=""></i> 편익제공
                    </button>
                    <button type="button" class="btn btn-small" id="BtnHeaderAdd" data-grid-header-btn="add"
                            style="width:80px;"><i
                            class="icon_add"></i>
                        <ax:lang id="ax.admin.add"/></button>
                    <button type="button" class="btn btn-small" id="BtnHeaderDelete" data-grid-header-btn="devare"
                            style="width:80px;"><i
                            class="icon_del"></i> <ax:lang id="ax.admin.delete"/></button>
                </div>
            </div>
            <div data-ax5grid="grid-header"
                 data-ax5grid-config="{
                        lineNumberColumnWidth: 40,
                        rowSelectorColumnWidth: 27
                     }"
                 id="top_grid"
            ></div>
            <div style="width:100%;overflow:hidden;" id="bottom_wrap">
                <div style="float:left;width:49%;">
                    <div class="ax-button-group" data-fit-height-aside="grid-detail-left" id="bottom_left_title">
                        <div class="left">
                            <h2>
                                <i class="icon_list"></i> 차변
                            </h2>
                        </div>
                        <div class="right">
                            <button type="button" class="btn btn-small" data-grid-detail-left-btn="add"
                                    style="width:80px;"><i
                                    class="icon_add"></i> <ax:lang id="ax.admin.add"/></button>
                            <button type="button" class="btn btn-small" data-grid-detail-left-btn="devare"
                                    style="width:80px;"><i
                                    class="icon_del"></i> <ax:lang id="ax.admin.delete"/></button>

                        </div>
                    </div>
                    <div data-ax5grid="grid-detail-left"
                         data-ax5grid-config="{
                                lineNumberColumnWidth: 40,
                                rowSelectorColumnWidth: 27,
                             }"
                         id="bottom_left_grid"
                    ></div>
                    <div style="overflow:auto;min-height:34px;height:34px;max-height:34px;" id="bottom_left_amt">
                        <ax:form name="binder-form-Left">
                            <div class="ax-button-group" data-fit-height-aside="grid-detail-left"
                                 style="border:1px solid #d2deec;background:#f7f8fa;min-height:32px;height:32px;">
                                <div style="width:80px;background:#e9e9e9;float:left;min-height:32px;height:32px;line-height:32px;font-size:12px;font-weight:700;">
                                    부가세정보
                                </div>
                                <div class="bottomlabel" style="margin-left:5px;">
                                    세무구분
                                </div>
                                <div class="bottominput">
                                    <input type="text" class="form-control" name="LEFT_GB_TAX"
                                           id="LEFT_GB_TAX" data-ax-path="LEFT_GB_TAX" readonly/>
                                </div>
                                <div class="bottomlabel">
                                    공급대가
                                </div>
                                <div class="bottominput">
                                    <input type="text" class="form-control" name="LEFT_AMOUNT_SUPPLY"
                                           id="LEFT_AMOUNT_SUPPLY" data-ax-path="LEFT_AMOUNT_SUPPLY" readonly/>
                                </div>
                                <div class="bottomlabel">
                                    공급가액
                                </div>
                                <div class="bottominput">
                                    <input type="text" class="form-control" name="LEFT_AM_SUPPLY"
                                           id="LEFT_AM_SUPPLY" data-ax-path="LEFT_AM_SUPPLY" readonly/>
                                </div>
                                <div class="bottomlabel">
                                    부가세
                                </div>
                                <div class="bottominput">
                                    <input type="text" class="form-control" name="LEFT_TEMP_VAT"
                                           id="LEFT_TEMP_VAT"
                                           data-ax-path="LEFT_TEMP_VAT" readonly/>
                                </div>
                            </div>
                        </ax:form>
                    </div>
                </div>
                <div style="float:right;width:50%;">
                    <div class="ax-button-group" data-fit-height-aside="grid-detail-right">
                        <div class="left">
                            <h2>
                                <i class="icon_list"></i> 대변
                            </h2>
                        </div>
                        <div class="right">
                            차액 <input type="text" class="btn" value="0" id="calc"
                                      style="text-align:right;letter-spacing: 5px;"
                                      disabled/>
                            <button type="button" class="btn btn-small" data-grid-detail-right-btn="add"
                                    style="width:80px;"><i
                                    class="icon_add"></i> <ax:lang id="ax.admin.add"/></button>
                            <button type="button" class="btn btn-small" data-grid-detail-right-btn="devare"
                                    style="width:80px;"><i
                                    class="icon_del"></i> <ax:lang id="ax.admin.delete"/></button>
                        </div>
                    </div>
                    <div data-ax5grid="grid-detail-right"
                         data-ax5grid-config="{
                                lineNumberColumnWidth: 40,
                                rowSelectorColumnWidth: 27,
                             }"
                         id="bottom_right_grid"
                    ></div>
                    <div style="overflow:auto;min-height:34px;height:34px;max-height:34px;" id="bottom_right_amt">
                        <ax:form name="binder-form-Right">
                            <div class="ax-button-group" data-fit-height-aside="grid-detail-right"
                                 style="border:1px solid #d2deec;background:#f7f8fa;min-height:32px;height:32px;">
                                <div style="width:80px;background:#e9e9e9;float:left;min-height:32px;height:32px;line-height:32px;font-size:12px;font-weight:700;">
                                    부가세정보
                                </div>
                                <div class="bottomlabel" style="margin-left:5px;">
                                    세무구분
                                </div>
                                <div class="bottominput">
                                    <input type="text" class="form-control" name="RIGHT_GB_TAX"
                                           id="RIGHT_GB_TAX" data-ax-path="RIGHT_GB_TAX" readonly/>
                                </div>
                                <div class="bottomlabel">
                                    공급대가
                                </div>
                                <div class="bottominput">
                                    <input type="text" class="form-control" name="RIGHT_AMOUNT_SUPPLY"
                                           id="RIGHT_AMOUNT_SUPPLY" data-ax-path="RIGHT_AMOUNT_SUPPLY" readonly/>
                                </div>
                                <div class="bottomlabel">
                                    공급가액
                                </div>
                                <div class="bottominput">
                                    <input type="text" class="form-control" name="RIGHT_AM_SUPPLY"
                                           id="RIGHT_AM_SUPPLY" data-ax-path="RIGHT_AM_SUPPLY" readonly/>
                                </div>
                                <div class="bottomlabel">
                                    부가세
                                </div>
                                <div class="bottominput">
                                    <input type="text" class="form-control" name="RIGHT_TEMP_VAT"
                                           id="RIGHT_TEMP_VAT" data-ax-path="RIGHT_TEMP_VAT" readonly/>
                                </div>
                            </div>
                        </ax:form>
                    </div>
                </div>
            </div>
        </div>

    </jsp:body>
</ax:layout>