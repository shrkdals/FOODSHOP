<%@ page import="com.chequer.axboot.core.utils.MessageUtils" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>

<ax:set key="title" value="전표등록관리"/>
<ax:set key="page_desc" value="${pageREMARK}"/>
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

                        var modal = new ax5.ui.modal();
            var today = new Date();
            var dtF = ax5.util.date(today, {"return": "yyyy-MM-01"});
            var dtT = ax5.util.date(today, {"return": "yyyy-MM"}) + '-' + ax5.util.daysOfMonth(today.getFullYear(), today.getMonth());
            var dtNow = ax5.util.date(today, {"return": "yyyy-MM-dd"});
            var fg_taxApproveData = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'CZ_Q0016', true);   //  세무구분 공백 없는것
            fg_taxApproveData = fg_taxApproveData.concat($.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'CZ_Q0015', true));
            var data_TP_EVIDENCE = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, "CZ_Q0022"); // 증빙유형
            var data_drcr = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, "CZ_Q0004"); // 차대구분
            var data_tp_gb = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, "CZ_Q0006");   //  유형
            var search_cdDocu = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, "CZ_Q0002");
            var data_cdDocu;
            var data_cdDocu_ = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, "CZ_Q0002", true, 'Y');
            var tax_code_dr = $.DATA_SEARCH_GET('gldocum', 'getAcctcode', {CD_RELATION: 30}).map.CD_ACCT; //차변 부가세 계정
            var tax_code_cr = $.DATA_SEARCH_GET('gldocum', 'getAcctcode', {CD_RELATION: 31}).map.CD_ACCT; //대변 부가세 계정
            var tax_code_recept = $.DATA_SEARCH_GET('gldocum', 'getAcctcode', {CD_RELATION: 82}).map.CD_ACCT; //접대비 계정
            var budget = $.DATA_SEARCH('gldocum', 'ccAddRow', { CD_DEPT: SCRIPT_SESSION.cdDept});   //  예산단위
            var tax_acct = tax_code_dr + "," + tax_code_cr;
            var _etcdocuyn, userCallBack;
            var _tabview = this.parent.fnObj.tabView; //받아온데이터 대상객체(초기화할때사용함)
            var _urlGetData = this.parent.fnObj.tabView.urlGetData(); //받아온데이터
            var mode;
            if (!_urlGetData || _urlGetData.length == 0) {  //넘어온데이터가 없음
                _etcdocuyn = true;
                mode = '기타';
                $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, "CZ_Q0002", true, 'Y');    //  전표유형 CD_FLAG1 : "Y" 인 경우만 가져오기.
            } else {
                _etcdocuyn = false;
                if (sessionStorage.getItem("prevmenuid") == "10502") { //매입세금계산서관리
                    mode = '매입';
                    data_cdDocu = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, "CZ_Q0002", true, '', '', 'Y');               //  전표유형 모두 가져오기, 단 전표유형 disabled : true;
                    $("#BtnHeaderAdd")[0].disabled = true;
                    $("#BtnDocuCopy")[0].disabled = true;

                }
                if (sessionStorage.getItem("prevmenuid") == "10504") { //매출세금계산서
                    mode = '매출';
                    data_cdDocu = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, "CZ_Q0002", false);
                    $("#BtnHeaderExp")[0].disabled = true;
                    $("#BtnHeaderAdd")[0].disabled = true;
                    $("#BtnDocuCopy")[0].disabled = true;
                }
            }
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
            var myModel_LEFT = new ax5.ui.binder();
            var myModel_RIGHT = new ax5.ui.binder();

            var searchCdDocuInfo = [];
            if (search_cdDocu != null){
                for (var i = 0 ; i < search_cdDocu.length ; i++) {
                    if (search_cdDocu[i].CODE != '003' && search_cdDocu[i].CODE != '008' && search_cdDocu[i].CODE != '009') {
                        searchCdDocuInfo.push(search_cdDocu[i])
                    }
                }
            }
            $("#cdDocu").ax5select({
                options: searchCdDocuInfo
            });


            var fnObj = {};
            fnObj.pageStart = function () {
                this.pageButtonView.initView();
                this.searchView.initView();
                this.gridHeader.initView();
                this.gridDetailLeft.initView();
                this.gridDetailRight.initView();

                $('#dtAcct').val(ax5.util.date(new Date(), {"return": "yyyy-MM-dd"}));
                if (mode == '기타'){
                    ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                }else{
                    if (mode == '매입') {
                        console.log("_urlGetData", _urlGetData);
                        $("#dtAcct").val($.changeDataFormat(_urlGetData.DT_ACCT, 'YYYYMMDD'));
                        for (var i = 0; i < _urlGetData.RESULT.length; i++) {
                            axboot.ajax({
                                type: "GET",
                                url: ["gldocum2", "getGroupNumber"],
                                async: false,
                                callback: function (groupnumber) {
                                    if (nvl(groupnumber.map) != '') {
                                        fnObj.gridHeader.addRow();
                                        var lastIdx = nvl(fnObj.gridHeader.target.list.length, fnObj.gridHeader.lastRow());
                                        fnObj.gridHeader.target.select(lastIdx - 1);
                                        fnObj.gridHeader.target.focus(lastIdx - 1);
                                        fnObj.gridHeader.target.setValue(lastIdx - 1, "NO_LINE", lastIdx);
                                        fnObj.gridHeader.target.setValue(lastIdx - 1, "TP_GB", '01'); //일반
                                        fnObj.gridHeader.target.setValue(lastIdx - 1, "GROUP_NUMBER", groupnumber.map.GROUP_NUMBER);
                                        fnObj.gridHeader.target.setValue(lastIdx - 1, "NO_TPDOCU", datedash(_urlGetData.RESULT[i].NO_TAX));
                                        fnObj.gridHeader.target.setValue(lastIdx - 1, "CD_DOCU", _urlGetData.CD_DOCU); //전표유형:매입(001)(CZ_Q0002)
                                        fnObj.gridHeader.target.setValue(lastIdx - 1, "TP_EVIDENCE", "3"); //증빙유형:세금계산서(3)(CZ_Q0022)
                                        fnObj.gridHeader.target.setValue(lastIdx - 1, "AMT_SUPPLY", _urlGetData.RESULT[i].AM); //공급가//매입세금계산서에서 클릭해서 넘어온거라서 무조건데이터가 있음
                                        fnObj.gridHeader.target.setValue(lastIdx - 1, "AMT_VAT", _urlGetData.RESULT[i].AM_VAT); //부가세
                                        fnObj.gridHeader.target.setValue(lastIdx - 1, "AMT_SUM", _urlGetData.RESULT[i].AMT); //합계금액
                                        fnObj.gridHeader.target.setValue(lastIdx - 1, "CD_PARTNER", _urlGetData.RESULT[i].CD_PARTNER); //거래처코드
                                        fnObj.gridHeader.target.setValue(lastIdx - 1, "LN_PARTNER", _urlGetData.RESULT[i].SELL_NM_CORP); //거래처명
                                        fnObj.gridHeader.target.setValue(lastIdx - 1, "DT_TRANS", datedash(_urlGetData.RESULT[i].YMD_WRITE)); //계산서일자
                                        fnObj.gridHeader.target.setValue(lastIdx - 1, "NO_TAX", datedash(_urlGetData.RESULT[i].NO_TAX)); //매입세금계산서키값
                                        fnObj.gridHeader.target.setValue(lastIdx - 1, "REMARK", nvl(_urlGetData.REMARK, '')); //전표유형:매입(001)(CZ_Q0002)
                                        fnObj.gridHeader.target.setValue(lastIdx - 1, "CD_EXCH", "000");
                                        fnObj.gridHeader.target.setValue(lastIdx - 1, "NM_EXCH", "KRW");
                                        fnObj.gridHeader.target.setValue(lastIdx - 1, "RT_EXCH", "1");
                                        fnObj.gridHeader.target.setValue(lastIdx - 1, "AMT_LOCAL", 0);

                                    }
                                }
                            })
                        }
                        _tabview.urlSetData(null);
                    }
                    if (mode == '매출') {
                        if (nvl(_urlGetData) == '') {
                            return false;
                        }
                        var list = _urlGetData["result"];
                        var map = _urlGetData["result2"];
                        /*$("#dtAcct").val(datedash(map.DT_ACCT));
                        $("#cdDept").val(map.NM_DEPT);
                        $("#cdDept").attr("name", map.NM_DEPT);
                        $("#cdDept").attr("code", map.CD_DEPT);
                        $("#cdEmp").val(map.NM_EMP);
                        $("#cdEmp").attr("name", map.NM_EMP);
                        $("#cdEmp").attr("code", map.CD_EMP);
                        $("#NM_NOTE").val(map.REMARKS);*/

                        for (var i = 0; i < list.result.length; i++) {

                            axboot.ajax({
                                type: "GET",
                                url: ["gldocum2", "getGroupNumber"],
                                async: false,
                                callback: function (groupnumber) {
                                    if (nvl(groupnumber.map) != '') {
                                        fnObj.gridHeader.addRow();
                                        var lastIdx = nvl(fnObj.gridHeader.target.list.length, fnObj.gridHeader.lastRow());
                                        fnObj.gridHeader.target.select(lastIdx - 1);
                                        fnObj.gridHeader.target.focus(lastIdx - 1);
                                        fnObj.gridHeader.target.setValue(lastIdx - 1, "NO_LINE", lastIdx);
                                        fnObj.gridHeader.target.setValue(lastIdx - 1, "TP_GB", '01'); //일반
                                        fnObj.gridHeader.target.setValue(lastIdx - 1, "GROUP_NUMBER", groupnumber.map.GROUP_NUMBER);
                                        fnObj.gridHeader.target.setValue(lastIdx - 1, "NO_TPDOCU", list.result[i].NO_TPDOCU);
                                        fnObj.gridHeader.target.setValue(lastIdx - 1, "CD_DOCU", "005"); //전표유형:매출(세)(005)(CZ_Q0002)
                                        fnObj.gridHeader.target.setValue(lastIdx - 1, "TP_EVIDENCE", "3"); //증빙유형:세금계산서(3)(CZ_Q0022)
                                        fnObj.gridHeader.target.setValue(lastIdx - 1, "AMT_SUPPLY", list.result[i].AMT); //공급가//매입세금계산서에서 클릭해서 넘어온거라서 무조건데이터가 있음
                                        fnObj.gridHeader.target.setValue(lastIdx - 1, "AMT_VAT", list.result[i].VAT); //부가세
                                        fnObj.gridHeader.target.setValue(lastIdx - 1, "AMT_SUM", list.result[i].AMT_TOT); //합계금액
                                        fnObj.gridHeader.target.setValue(lastIdx - 1, "CD_PARTNER", list.result[i].CD_PARTNER); //거래처코드
                                        fnObj.gridHeader.target.setValue(lastIdx - 1, "LN_PARTNER", list.result[i].LN_PARTNER); //거래처명
                                        fnObj.gridHeader.target.setValue(lastIdx - 1, "REMARK", map.REMARKS); //거래처명
                                        fnObj.gridHeader.target.setValue(lastIdx - 1, "DT_TRANS", datedash(list.result[i].DT_TRANS)); //계산서일자
                                        fnObj.gridHeader.target.setValue(lastIdx - 1, "NO_TAX", datedash(list.result[i].NO_TAX)); //매출세금계산서키값
                                        fnObj.gridHeader.target.setValue(lastIdx - 1, "PARAM", datedash(list.result[i].ACCTENT_NO_TAX)); //매출세금계산서키값
                                        fnObj.gridHeader.target.setValue(lastIdx - 1, "CD_EXCH", "000");
                                        fnObj.gridHeader.target.setValue(lastIdx - 1, "NM_EXCH", "KRW");
                                        fnObj.gridHeader.target.setValue(lastIdx - 1, "RT_EXCH", "1");
                                    }
                                }
                            })
                        }
                        _tabview.urlSetData(null);
                    }
                }
            };

            fnObj.pageButtonView = axboot.viewExtend({
                initView: function () {
                    axboot.buttonClick(this, "data-page-btn", {
                        "imsisave": function () {
                            ACTIONS.dispatch(ACTIONS.PAGE_IMSI_SAVE);
                        },
                        "save": function () {
                            ACTIONS.dispatch(ACTIONS.PAGE_SAVE);
                        },
                        "docucopy": function () {
                            ACTIONS.dispatch(ACTIONS.DOCU_COPY);
                        },
                        "search": function(){
                            if (nvl($("#CD_DEPT").getCodes()) == ''){
                                qray.alert('부서는 필수조회값입니다.');
                                return;
                            }
                            ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                        },
                        "new": function(){
                            fnObj.gridHeader.clear();
                            fnObj.gridDetailLeft.clear();
                            fnObj.gridDetailRight.clear();
                        }
                    });
                }
            });

            var ACTIONS = axboot.actionExtend(fnObj, {
                PAGE_SEARCH: function(caller, act, data){
                    caller.gridHeader.clear();
                    caller.gridDetailLeft.clear();
                    caller.gridDetailRight.clear();
                    $("#REMARK").val('');
                    $("#dtAcct").val(dtNow);
                    axboot.ajax({
                        type: "GET",
                        url: ["gldocum2", "getHeaderList"],
                        data: fnObj.searchView.getData(),
                        callback: function (res) {
                            caller.gridHeader.setData(res);
                            var no_tpdocu = [];
                            for (var i = 0 ; i < res.list.length; i++){
                                no_tpdocu.push(res.list[i].NO_TPDOCU);
                            }
                            var obj = fnObj.searchView.getData();
                            obj.NO_TPDOCU = no_tpdocu.join('|');

                            ACTIONS.dispatch(ACTIONS.DETAIL_SEARCH, obj);
                        }
                    });

                    return false;
                },
                DETAIL_SEARCH: function(caller, act, data){
                    console.log("DETAIL_SEARCH", data);
                    axboot.ajax({
                        type: "GET",
                        url: ["gldocum2", "getDetailList"],
                        data: data,
                        callback: function (res) {
                            console.log("detail_search res : ", res);
                            if (nvl(res.map) != ''){
                                if (res.map.GRID_DR.length > 0){
                                    caller.gridDetailLeft.setData(res.map.GRID_DR);
                                }
                                if (res.map.GRID_CR.length > 0){
                                    caller.gridDetailRight.setData(res.map.GRID_CR);
                                }
                            }
                        }
                    });
                    return false;
                },
                PAGE_IMSI_SAVE: function(caller){
                    var data_h = [].concat(caller.gridHeader.getData("modified"));
                    data_h = data_h.concat(caller.gridHeader.getData("deleted"));

                    var data_l = [].concat(caller.gridDetailLeft.getData("modified"));
                    data_l = data_l.concat(caller.gridDetailLeft.getData("deleted"));

                    var data_r = [].concat(caller.gridDetailRight.getData("modified"));
                    data_r = data_r.concat(caller.gridDetailRight.getData("deleted"));


                    if (nvl(data_h, '') == '' && nvl(data_l, '') == '' && nvl(data_r, '') == '') {
                        qray.alert("변경된 데이터가 없습니다.");
                        return false;
                    }

                    if ($("#calc").val() != 0) {
                        qray.alert("차변 대변 금액이 다릅니다.");
                        return false;
                    }

                    for (var i = 0 ; i < caller.gridHeader.getData().length ; i++){
                        var listH = caller.gridHeader.getData()[i];

                        if (nvl(listH.CD_DOCU) == ''){
                            qray.alert('상단그리드의 전표유형은 필수값입니다.');
                            return false;
                        }
                        if (nvl(listH.REMARK) == ''){
                            qray.alert('상단그리드의 적요는 필수값입니다.');
                            return false;
                        }
                        if (nvl(listH.CD_TPDOCU) == ''){
                            qray.alert('상단그리드의 지출유형은 필수값입니다.');
                            return false;
                        }
                        if (listH.CD_DOCU == '002'){
                            if (nvl(listH.YN_BENEFIT, 'N') == 'N') {
                                qray.alert('전표유형이 편익일때는 편익제공 내용을 입력하여 주십시오.');
                                return false;
                            }
                            var amtB = 0;
                            if (nvl(listH.BENEFIT) != '' && listH.BENEFIT.length > 0) {
                                for (var b = 0; b < listH.BENEFIT.length; b++) {
                                    amtB += Number(nvl(listH.BENEFIT[b].AMT_USE, 0));
                                }
                                if (listH.AMT_SUM != amtB) {
                                    qray.alert('합계금액과 편익제공 금액의 합이 다릅니다.');
                                    return false;
                                }
                            }
                        }



                        var amtL = 0, cntL = 0 ;
                        for (var l = 0 ; l < caller.gridDetailLeft.getData().length; l++){
                            var listL = caller.gridDetailLeft.getData()[l];

                            if (listH.NO_TPDOCU == listL.NO_TPDOCU){
                                amtL += Number(listL.AMT);
                                cntL++;
                            }
                        }
                        var amtR = 0, cntR = 0 ;
                        for (var r = 0 ; r < caller.gridDetailRight.getData().length; r++){
                            var listR = caller.gridDetailRight.getData()[r];

                            if (listH.NO_TPDOCU == listR.NO_TPDOCU){
                                amtR += Number(listR.AMT);
                                cntR++;
                            }
                        }
                        if (cntL == 0){
                            qray.alert(listH.NO_LINE + '번 차변 데이터가 없습니다.');
                            return false;
                        }
                        if (cntR == 0){
                            qray.alert(listH.NO_LINE + '번 대변 데이터가 없습니다.');
                            return false;
                        }
                        if (listH.AMT_SUM != amtL || listH.AMT_SUM != amtR || amtL != amtR){
                            qray.alert(listH.NO_LINE + '번 라인별 합계금액이 다릅니다.');
                            return false;
                        }
                    }
                    var no_tpdocu_ = [];
                    for (var i = 0 ; i < caller.gridHeader.getData("modified").length ; i ++){
                        var list = caller.gridHeader.getData("modified")[i];
                        if (list.__created__){
                            no_tpdocu_.push(list.NO_TPDOCU);
                        }
                    }


                    var result = $.DATA_SEARCH("apTaxBill","getSelectCheckImsi",{ CD_COMPANY : SCRIPT_SESSION.cdCompany, NO_TPDOCU : no_tpdocu_.join('|')});

                    var imsiCount = 0;
                    axboot.ajax({
                        type: "GET",
                        url: ["arTaxBill", "chk_NOTPDOCU_IMSI"],       //  해당프로시저  UP_CZ_Q_TAX_INVOICE_S
                        async: false,
                        data: {
                            NO_TPDOCU: no_tpdocu_.join('|')
                        },
                        callback: function (res) {
                            imsiCount = res.map.COUNT;
                        }
                    });

                    if(result.map.YN == 'Y'){
                        qray.alert("매입세금계산서관리에서<br>가전표로 이미 저장된 데이터가 존재합니다.");
                        return false;
                    }
                    if(imsiCount > 0){
                        qray.alert("매출세금계산서관리에서<br>가전표로 이미 저장된 데이터가 존재합니다.");
                        return false;
                    }

                    for (var i = 0 ; i < caller.gridDetailLeft.getData("modified").length ; i ++){
                        var list = caller.gridDetailLeft.getData("modified")[i];

                        if (nvl(list.CD_ACCT,"") == "") {
                            qray.alert("계정은 필수항목 입니다");
                            return false;
                        }
                        if (tax_code_dr.indexOf(list.CD_ACCT) > -1 && nvl(list.NO_TAX) == '') {
                            qray.alert("[차변] " + list.NO_LINE + "번 " + list.NM_ACCT + "<br>부가세계정에 부가세내용을 등록하여 주십시오.");
                            return false;
                        }

                        if (tax_code_recept.indexOf(list.CD_ACCT) > -1 && nvl(list.NO_TAX) == '') {
                            qray.alert("[차변] " + list.NO_LINE + "번 " + list.NM_ACCT + "<br>접대비계정에 접대비내용을 등록하여 주십시오..");
                            return false;
                        }

                        for (var k = 1; k <= 8; k++) {
                            if ((list["ST_MNG" + k] == "A" || list["ST_MNG" + k] == "D") && nvl(list["NM_MNGD" + k]) == '' && nvl(list["CD_MNGD" + k]) == ''){
                                qray.alert("[차변] " + list.NO_LINE + "번 " + list.NM_ACCT + "<br>필수관리항목이 입력되지 않았습니다.");
                                return false;
                            }
                        }
                    }
                    for (var i = 0 ; i < caller.gridDetailRight.getData("modified").length ; i ++){
                        var list = caller.gridDetailRight.getData("modified")[i];

                        if (nvl(list.CD_ACCT,"") == "") {
                            qray.alert("계정은 필수항목 입니다");
                            return false;
                        }

                        if (tax_code_cr.indexOf(list.CD_ACCT) > -1 && !list.NO_TAX) {
                            qray.alert("[대변] " + list.NO_LINE + "번 " + list.NM_ACCT + "<br>부가세계정에 부가세내용을 등록하여 주십시오.");
                            return false;
                        }

                        if (tax_code_recept.indexOf(list.CD_ACCT) > -1 && !list.NO_TAX) {
                            qray.alert("[대변] " + list.NO_LINE + "번 " + list.NM_ACCT + "<br>접대비계정에 접대비내용을 등록하여 주십시오..");
                            return false;
                        }
                        for (var k = 1; k <= 8; k++) {
                            if ((list["ST_MNG" + k] == "A" || list["ST_MNG" + k] == "D")  && nvl(list["NM_MNGD" + k]) == '' && nvl(list["CD_MNGD" + k]) == ''){
                                qray.alert("[대변] " + list.NO_LINE + "번 " + list.NM_ACCT + "<br>필수관리항목이 입력되지 않았습니다.");
                                return false;
                            }
                        }
                    }

                    qray.confirm({
                        msg: "저장하시겠습니까?"
                    }, function () {
                        if (this.key == "ok") {


                            axboot.ajax({
                                type: "PUT",
                                url: ["gldocum2", "saveimsi"],
                                data: JSON.stringify({
                                    data_h: data_h,
                                    data_l: data_l,
                                    data_r: data_r,
                                }),
                                callback: function (res) {
                                    console.log(res);
                                    if (nvl(res.map.MSG) != '') {
                                        qray.alert(res.map.MSG.cause.message);
                                        return false;
                                    } else {
                                        qray.alert('성공적으로 저장하였습니다.').then(function () {
                                            mode = '기타';
                                            if (nvl($("#CD_DEPT").getCodes()) == ''){
                                                $("#CD_DEPT").setPicker([{code: SCRIPT_SESSION.cdDept, text: SCRIPT_SESSION.nmDept}]);
                                            }
                                            $("#BtnHeaderExp")[0].disabled = false;
                                            $("#BtnHeaderAdd")[0].disabled = false;
                                            $("#BtnDocuCopy")[0].disabled = false;
                                            /*if (nvl($("#cdDept").attr('code')) == ''){
                                                $("#cdDept").attr('code', SCRIPT_SESSION.cdDept);
                                            }*/
                                            ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                                        });
                                    }
                                }
                            });
                        }
                    });

                },
                PAGE_SAVE: function (caller) {
                    var data_h = [].concat(caller.gridHeader.getData("modified"));
                    data_h = data_h.concat(caller.gridHeader.getData("deleted"));

                    var data_l = [].concat(caller.gridDetailLeft.getData("modified"));
                    data_l = data_l.concat(caller.gridDetailLeft.getData("deleted"));

                    var data_r = [].concat(caller.gridDetailRight.getData("modified"));
                    data_r = data_r.concat(caller.gridDetailRight.getData("deleted"));

                    if (nvl(data_h, '') != '' || nvl(data_l, '') != '' || nvl(data_r, '') != '') {
                        qray.alert("변경된 데이터가 있습니다.<br>저장 후 진행해주십시오.");
                        return false;
                    }

                    var gridH = caller.gridHeader.target.list;

                    var chkCnt = 0;
                    for (var i = 0 ; i < gridH.length ; i++){
                        if (gridH[i].CHK == 'Y'){
                            chkCnt++;
                        }
                    }
                    if (chkCnt == 0){
                        qray.alert('체크된 데이터가 없습니다.');
                        return false;
                    }

                    if ($("#calc").val() != 0) {
                        qray.alert("차변 대변 금액이 다릅니다.");
                        return false;
                    }
                    if (nvl($("#dtAcct").val()) == ''){
                        qray.alert('회계일자를 입력해주십시오.');
                        return;
                    }
                    if (nvl($("#REMARK").val()) == ''){
                        qray.alert('적요를 입력해주십시오.');
                        return;
                    }
                    var tp_gb;
                    var TP_GB_01 = 0, TP_GB_03 = 0, TP_GB_07 = 0, GB_BENEFIT = 0, CD_DOCU_001 = 0, TP_GB_03_CD_DOCU_002 = 0, TP_GB_01_CD_DOCU_002 = 0, CD_DOCU_005 = 0;
                    for (var i = 0 ; i < caller.gridHeader.getData().length ; i++){
                        if (caller.gridHeader.getData()[i].CHK == 'Y'){
                            var listH = caller.gridHeader.getData()[i];

                            if (nvl(listH.CD_DOCU) == ''){
                                qray.alert('상단그리드의 전표유형은 필수값입니다.');
                                return false;
                            }
                            if (nvl(listH.CD_TPDOCU) == ''){
                                qray.alert('상단그리드의 지출유형은 필수값입니다.');
                                return false;
                            }
                            if (nvl(listH.REMARK) == ''){
                                qray.alert('상단그리드의 적요는 필수값입니다.');
                                return false;
                            }
                            if (listH.CD_DOCU == '002'){
                                if (nvl(listH.YN_BENEFIT, 'N') == 'N') {
                                    qray.alert('전표유형이 편익일때는 편익제공 내용을 입력하여 주십시오.');
                                    return false;
                                }
                                var amtB = 0;
                                if (nvl(listH.BENEFIT) != '' && listH.BENEFIT.length > 0) {
                                    for (var b = 0 ; b < listH.BENEFIT.length ; b++){
                                        amtB += Number(nvl(listH.BENEFIT[b].AMT_USE, 0));
                                    }
                                    if (listH.AMT_SUM != amtB){
                                        qray.alert('합계금액과 편익제공 금액의 합이 다릅니다.');
                                        return false;
                                    }
                                }
                            }

                            if (listH.TP_GB == '01'){
                                TP_GB_01++;
                                tp_gb = '01';
                                if (listH.CD_DOCU == '001'){
                                    CD_DOCU_001++;
                                }
                                if (listH.CD_DOCU == '002'){
                                    TP_GB_01_CD_DOCU_002++;
                                }
                                if (listH.CD_DOCU == '005'){
                                    CD_DOCU_005++;
                                }
                            }else if (listH.TP_GB == '03'){
                                TP_GB_03++;
                                tp_gb = '03';
                                if (listH.CD_DOCU == '002'){
                                    TP_GB_03_CD_DOCU_002++;
                                }
                            }else if (listH.TP_GB == '07'){
                                TP_GB_07++;
                                tp_gb = '07';
                            }

                            var amtL = 0, cntL = 0 ;
                            for (var l = 0 ; l < caller.gridDetailLeft.getData().length; l++){
                                var listL = caller.gridDetailLeft.getData()[l];

                                if (listH.NO_TPDOCU == listL.NO_TPDOCU){
                                    amtL += Number(listL.AMT);
                                    cntL++;
                                }
                            }
                            var amtR = 0, cntR = 0 ;
                            for (var r = 0 ; r < caller.gridDetailRight.getData().length; r++){
                                var listR = caller.gridDetailRight.getData()[r];

                                if (listH.NO_TPDOCU == listR.NO_TPDOCU){
                                    amtR += Number(listR.AMT);
                                    cntR++;
                                }
                            }
                            if (cntL == 0){
                                qray.alert(listH.NO_LINE + '번 차변 데이터가 없습니다.');
                                return false;
                            }
                            if (cntR == 0){
                                qray.alert(listH.NO_LINE + '번 대변 데이터가 없습니다.');
                                return false;
                            }
                            if (listH.AMT_SUM != amtL || listH.AMT_SUM != amtR || amtL != amtR){
                                qray.alert(listH.NO_LINE + '번 라인별 합계금액이 다릅니다.');
                                return false;
                            }
                        }
                    }
                    var chkVal = false;
                    if (CD_DOCU_001 > 0 && (TP_GB_01_CD_DOCU_002 > 0 || CD_DOCU_005 > 0 || TP_GB_03_CD_DOCU_002 > 0)){
                        chkVal = true;
                    }
                    if (TP_GB_01_CD_DOCU_002 > 0 && (CD_DOCU_001 > 0 || CD_DOCU_005 > 0 || TP_GB_03_CD_DOCU_002 > 0)){
                        chkVal = true;
                    }
                    if (CD_DOCU_005 > 0 && (TP_GB_01_CD_DOCU_002 > 0 || CD_DOCU_001 > 0 || TP_GB_03_CD_DOCU_002 > 0)){
                        chkVal = true;
                    }
                    if (TP_GB_03_CD_DOCU_002 > 0 && (CD_DOCU_005 > 0 || CD_DOCU_001 > 0 || TP_GB_01_CD_DOCU_002 > 0)){
                        chkVal = true;
                    }
                    if (TP_GB_01 > 0 && (TP_GB_03 > 0 || TP_GB_07 > 0)){
                        chkVal = true;
                    }
                    if (TP_GB_03 > 0 && (TP_GB_01 > 0 || TP_GB_07 > 0)){
                        chkVal = true;
                    }
                    if (TP_GB_07 > 0 && (TP_GB_03 > 0 || TP_GB_01 > 0)){
                        chkVal = true;
                    }

                    if (chkVal){
                        qray.alert('동일한 유형의 전표를 등록해야합니다.');
                        return false;
                    }

                    var params = {
                        CD_COMPANY: SCRIPT_SESSION.cdCompany
                        , DT_ACCT: $("#dtAcct").val().replace(/-/gi, "")
                        , CD_DOCU: (tp_gb == '03' || tp_gb == '07') ? '91' : '92'   //  기타:91 / 매입매출:92
                        , CD_DEPT: SCRIPT_SESSION.cdCompany
                        , DT_WRITE: ax5.util.date(new Date(), {"return": "yyyyMMdd"})
                    };
                    var result = $.DATA_SEARCH('commonutility', 'checkMagam', params);
                    if (result.map.CHECK_YN == 'Y') {
                        qray.alert('마감된 날짜입니다.');
                        return false;
                    }

                    var chkH = isChecked(caller.gridHeader.getData("CHK"));
                    var chkL = [];
                    var chkR = [];
                    var _noTpdocu = [];
                    for (var i = 0 ; i < chkH.result.length ; i++){
                        var notpdoch_h = chkH.result[i].NO_TPDOCU;
                        _noTpdocu.push(chkH.result[i].NO_TPDOCU);
                        for (var l = 0 ; l < caller.gridDetailLeft.getData().length ; l++){
                            if (notpdoch_h == caller.gridDetailLeft.getData()[l].NO_TPDOCU){


                                if (nvl(caller.gridDetailLeft.getData()[l].CD_BUDGET) != '' && nvl(caller.gridDetailLeft.getData()[l].CD_BGACCT) != ''){
                                    var temp_amt_tot = Number(caller.gridDetailLeft.getData()[l].AMT);
                                    for (var i2 = 0 ; i2 < caller.gridDetailLeft.getData().length ; i2 ++){
                                        if (notpdoch_h == caller.gridDetailLeft.getData()[l].NO_TPDOCU) {
                                            if (l == i2) continue;

                                            if (nvl(caller.gridDetailLeft.getData()[i2].CD_BUDGET) != '' && nvl(caller.gridDetailLeft.getData()[i2].CD_BGACCT) != '') {
                                                if (caller.gridDetailLeft.getData()[l].CD_BUDGET == caller.gridDetailLeft.getData()[i2].CD_BUDGET && caller.gridDetailLeft.getData()[l].CD_BGACCT == caller.gridDetailLeft.getData()[i2].CD_BGACCT) {
                                                    temp_amt_tot += Number(caller.gridDetailLeft.getData()[i2].AMT);
                                                }
                                            }
                                        }
                                    }
                                    var result = $.DATA_SEARCH('apbucard', 'acctBudgetAmt', {
                                        CD_BGACCT: caller.gridDetailLeft.getData()[l].CD_BGACCT,
                                        CD_BUDGET: caller.gridDetailLeft.getData()[l].CD_BUDGET,
                                        DT_ACCT: $("#dtAcct").val().replace(/-/g, ""),
                                        APPLY_AMT: temp_amt_tot
                                    });
                                    console.log("예산통제 차변 : ", result);
                                    if (nvl(Number(result.list[0]['OVER_AMT']), 0) != 0){
                                        qray.alert("예산초과된 항목이 있습니다").then(function(){
                                            var data = {
                                                CD_BGACCT: caller.gridDetailLeft.getData()[l].CD_BGACCT,
                                                CD_BUDGET: caller.gridDetailLeft.getData()[l].CD_BUDGET,
                                                CD_ACCT: caller.gridDetailLeft.getData()[l].CD_ACCT,
                                                AMT0: result.list[0].AMT0, //실행
                                                AMT1: result.list[0].AMT1, //집행
                                                AMT2: result.list[0].AMT2, //잔여
                                                APPLY_AMT: temp_amt_tot,       //신청
                                                OVER_AMT: result.list[0].OVER_AMT //초과
                                            };

                                            $.openCommonPopup('budgetControl', "", '', '', data, 500, 380, _pop_top380);
                                        });
                                        return false;
                                    }
                                }

                                chkL.push(caller.gridDetailLeft.getData()[l]);
                            }
                        }
                        for (var r = 0 ; r < caller.gridDetailRight.getData().length ; r++){
                            if (notpdoch_h == caller.gridDetailRight.getData()[r].NO_TPDOCU){

                                if (nvl(caller.gridDetailRight.getData()[r].CD_BUDGET) != '' && nvl(caller.gridDetailRight.getData()[r].CD_BGACCT) != ''){
                                    var temp_amt_tot = Number(caller.gridDetailRight.getData()[r].AMT);
                                    for (var i2 = 0 ; i2 < caller.gridDetailRight.getData().length ; i2 ++){
                                        if (notpdoch_h == caller.gridDetailRight.getData()[r].NO_TPDOCU) {
                                            if (r == i2) continue;

                                            if (nvl(caller.gridDetailRight.getData()[i2].CD_BUDGET) != '' && nvl(caller.gridDetailRight.getData()[i2].CD_BGACCT) != '') {
                                                if (caller.gridDetailRight.getData()[r].CD_BUDGET == caller.gridDetailRight.getData()[i2].CD_BUDGET && caller.gridDetailRight.getData()[r].CD_BGACCT == caller.gridDetailRight.getData()[i2].CD_BGACCT) {
                                                    temp_amt_tot += Number(caller.gridDetailRight.getData()[i2].AMT);
                                                }
                                            }
                                        }
                                    }
                                    var result = $.DATA_SEARCH('apbucard', 'acctBudgetAmt', {
                                        CD_BGACCT: caller.gridDetailRight.getData()[r].CD_BGACCT,
                                        CD_BUDGET: caller.gridDetailRight.getData()[r].CD_BUDGET,
                                        DT_ACCT: $("#dtAcct").val().replace(/-/g, ""),
                                        APPLY_AMT: temp_amt_tot
                                    });
                                    console.log("예산통제 차변 : ", result);
                                    if (nvl(Number(result.list[0]['OVER_AMT']), 0) != 0){
                                        qray.alert("예산초과된 항목이 있습니다").then(function(){
                                            var data = {
                                                CD_BGACCT: caller.gridDetailRight.getData()[r].CD_BGACCT,
                                                CD_BUDGET: caller.gridDetailRight.getData()[r].CD_BUDGET,
                                                CD_ACCT: caller.gridDetailRight.getData()[r].CD_ACCT,
                                                AMT0: result.list[0].AMT0, //실행
                                                AMT1: result.list[0].AMT1, //집행
                                                AMT2: result.list[0].AMT2, //잔여
                                                APPLY_AMT: temp_amt_tot,       //신청
                                                OVER_AMT: result.list[0].OVER_AMT //초과
                                            };

                                            $.openCommonPopup('budgetControl', "", '', '', data, 500, 380, _pop_top380);
                                        });
                                        return false;
                                    }
                                }

                                chkR.push(caller.gridDetailRight.getData()[r]);
                            }
                        }
                    }

                    qray.confirm({
                        msg: "전표 처리하시겠습니까?"
                    }, function () {
                        if (this.key == "ok") {
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

                            axboot.ajax({
                                type: "PUT",
                                url: ["gldocum2", "insert"],
                                data: JSON.stringify({
                                    "header": chkH.result,
                                    "gridDetailLeft": chkL,
                                    "gridDetailRight": chkR,
                                    "cdDept": SCRIPT_SESSION.cdDept,
                                    "cdEmp": SCRIPT_SESSION.noEmp,
                                    "dtAcct": $("#dtAcct").val().replace(/-/gi, ""),
                                    "remark": $("#REMARK").val(), //DOCU 용 적요
                                    "tp_gb": tp_gb,        //  유형
                                    "etcdocu": (tp_gb == '03' || tp_gb == '07' ? "Y" : "N"),    //기타전표여부
                                }),
                                callback: function (res) {
                                    console.log(res);
                                    if (nvl(res.map['MSG']) != ''){
                                        qray.alert(res.map['MSG'].cause.message);
                                        return false;
                                    }
                                    /*console.log(res.map.MSG.cause.message);*/
                                    qray.alert("성공적으로 전표처리 되었습니다.").then(function() {
                                        if (nvl($("#CD_DEPT").getCodes()) == ''){
                                            $("#CD_DEPT").setPicker([{code: SCRIPT_SESSION.cdDept, text: SCRIPT_SESSION.nmDept}]);
                                        }
                                        ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                                        //parent[param.callBack]({GROUP_NUMBER : res.map.GROUP_NUMBER});
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
                                        parent.fnObj.tabView.urlSetData({GROUP_NUMBER: res.map.GROUP_NUMBER});

                                        parent.fnObj.tabView.open(menuInfo);
                                    });
                                }
                            })
                        }
                    })

                    /*userCallBack = function(e){
                        console.log("save callback", e);

                        modal.close();

                        ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);

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
                        parent.fnObj.tabView.urlSetData({GROUP_NUMBER: e["GROUP_NUMBER"]});

                        parent.fnObj.tabView.open(menuInfo);
                    }

                    modal.open({
                        width: 800,
                        height: _pop_height800,
                        position: {
                            left: "center",
                            top: _pop_top800
                        },
                        iframe: {
                            method: "get",
                            url: "/jsp/ensys/gl/popDocu.jsp",
                            param: "callBack=userCallBack"
                        },
                        sendData:{
                            chkH : chkH.result,
                            chkR : chkR,
                            chkL : chkL,
                            etcdocuyn : _etcdocuyn
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

                    });*/
                },
                DOCU_COPY: function (caller) {
                    userCallBack = function (e) {

                        if (nvl(e) == '') {
                            return false;
                        }

                        axboot.ajax({
                            type: "POST",
                            url: ["gldocum", "getDocuPusaivCopy"],  // 복사할 전표 CZ_Q_PUSAIV 테이블 [ HEADER 그리드 ] 값 불러오기.
                            async: false,
                            data: JSON.stringify({
                                P_GROUP_NUMBER: e.GROUP_NUMBER
                            }),
                            callback: function (res) {
                                for (var i = 0; i < res.list.length; i++) {
                                    var oldNO_TPDOCU = res.list[i].NO_TPDOCU;
                                    var H_lastIdx, newNO_TPDOCU, newGROUP_NUMBER;
                                    axboot.ajax({
                                        type: "GET",
                                        url: ["gldocum", "getTpDocu"],
                                        async: false,
                                        callback: function (tpdocu) {
                                            axboot.ajax({
                                                type: "GET",
                                                url: ["gldocum2", "getGroupNumber"],
                                                async: false,
                                                callback: function (groupnumber) {
                                                    if (nvl(groupnumber.map) != '') {
                                                        newNO_TPDOCU = tpdocu.map.noTpdocu;
                                                        newGROUP_NUMBER = groupnumber.map.GROUP_NUMBER;
                                                        fnObj.gridHeader.addRow();
                                                        H_lastIdx = nvl(fnObj.gridHeader.target.list.length, fnObj.gridHeader.lastRow());

                                                        fnObj.gridHeader.target.focus(H_lastIdx - 1);
                                                        fnObj.gridHeader.target.select(H_lastIdx - 1);

                                                        fnObj.gridHeader.target.setValue(H_lastIdx - 1, "GROUP_NUMBER", newGROUP_NUMBER);              // 새로 딴 데이터
                                                        fnObj.gridHeader.target.setValue(H_lastIdx - 1, "NO_TPDOCU", newNO_TPDOCU);              // 새로 딴 데이터
                                                        fnObj.gridHeader.target.setValue(H_lastIdx - 1, "NO_LINE", H_lastIdx); //순번
                                                        fnObj.gridHeader.target.setValue(H_lastIdx - 1, "TP_GB", '03'); //기타
                                                        fnObj.gridHeader.target.setValue(H_lastIdx - 1, "CD_DOCU", res.list[i].CD_DOCU); //전표유형:매입(001)(CZ_Q0002)
                                                        fnObj.gridHeader.target.setValue(H_lastIdx - 1, "TP_EVIDENCE", res.list[i].TP_EVIDENCE); //증빙유형:세금계산서(3)(CZ_Q0022)
                                                        fnObj.gridHeader.target.setValue(H_lastIdx - 1, "AMT_SUPPLY", res.list[i].AMT); //공급가//매입세금계산서에서 클릭해서 넘어온거라서 무조건데이터가 있음
                                                        fnObj.gridHeader.target.setValue(H_lastIdx - 1, "AMT_VAT", res.list[i].VAT); //부가세
                                                        fnObj.gridHeader.target.setValue(H_lastIdx - 1, "AMT_SUM", res.list[i].AMT_TOT); //합계금액
                                                        fnObj.gridHeader.target.setValue(H_lastIdx - 1, "CD_PARTNER", res.list[i].CD_PARTNER); //거래처코드
                                                        fnObj.gridHeader.target.setValue(H_lastIdx - 1, "LN_PARTNER", res.list[i].LN_PARTNER); //거래처명
                                                        fnObj.gridHeader.target.setValue(H_lastIdx - 1, "DT_TRANS", datedash(res.list[i].DT_TRANS)); //계산서일자
                                                        fnObj.gridHeader.target.setValue(H_lastIdx - 1, "NO_TAX", datedash(res.list[i].NO_TAX)); //매입세금계산서키값
                                                        fnObj.gridHeader.target.setValue(H_lastIdx - 1, "REMARK", datedash(res.list[i].REMARK)); //매입세금계산서키값
                                                        fnObj.gridHeader.target.setValue(H_lastIdx - 1, "CD_TPDOCU", datedash(res.list[i].CD_TPDOCU));
                                                        fnObj.gridHeader.target.setValue(H_lastIdx - 1, "NM_TPDOCU", datedash(res.list[i].NM_TPDOCU));
                                                        fnObj.gridHeader.target.setValue(H_lastIdx - 1, "CD_EXCH", "000");
                                                        fnObj.gridHeader.target.setValue(H_lastIdx - 1, "NM_EXCH", "KRW");
                                                        fnObj.gridHeader.target.setValue(H_lastIdx - 1, "RT_EXCH", "1");

                                                    }
                                                }
                                            });
                                            axboot.ajax({
                                                type: "POST",
                                                url: ["gldocum", "getDocuAcctentCopy"],  //  복사할 전표 CZ_Q_PUSAIV의 NO_TPDOCU를 가지고 CZ_Q_ACCTENT 값 불러오기.
                                                async: false,
                                                data: JSON.stringify({
                                                    P_GROUP_NUMBER: e.GROUP_NUMBER,
                                                    P_NO_TPDOCU: oldNO_TPDOCU
                                                }),
                                                callback: function (result) {
                                                    for (var i = 0; i < result.list.length; i++) {
                                                        var obj = result.list[i];
                                                        if (obj.GB == "1") {  //  차변

                                                            fnObj.gridDetailLeft.addRow();

                                                            var lastIdx = nvl(fnObj.gridDetailLeft.target.list.length, fnObj.gridDetailLeft.lastRow());

                                                            fnObj.gridDetailLeft.target.focus(lastIdx - 1);
                                                            fnObj.gridDetailLeft.target.select(lastIdx - 1);

                                                            fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "TP_DRCR", "1");
                                                            fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "NO_LINE", H_lastIdx); //순번
                                                            fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "NO_TPDOCU", newNO_TPDOCU);
                                                            fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "GROUP_NUMBER", newGROUP_NUMBER);
                                                            fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "CD_ACCT", obj.CD_ACCT);
                                                            fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "NM_ACCT", obj.NM_ACCT);
                                                            fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "AMT", obj.AMT);
                                                            fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "CD_BUDGET", obj.CD_BUDGET);
                                                            fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "NM_BUDGET", obj.NM_BUDGET);
                                                            fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "NM_BGACCT", obj.NM_BGACCT);
                                                            fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "CD_BGACCT", obj.CD_BGACCT);
                                                            fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "REMARK", obj.REMARK);
                                                            fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "TP_EVIDENCE", obj.TP_EVIDENCE);
                                                            fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "CD_MNGD", obj.CD_MNGD);
                                                            fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "FG_TAX", obj.FG_TAX);
                                                            fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "BANK_NM", obj.BANK_NM);
                                                            fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "BANK_ACCT_NO", obj.BANK_ACCT_NO);
                                                            for (var z = 1; z < 9; z++) {
                                                                fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "CD_MNG" + z, obj["CD_MNG" + z]);
                                                                fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "NM_MNG" + z, obj["NM_MNG" + z]);
                                                                fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "CD_MNGD" + z, obj["CD_MNGD" + z]);
                                                                fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "NM_MNGD" + z, obj["NM_MNGD" + z]);
                                                            }


                                                        } else if (obj.GB == "2") {  //  대변

                                                            fnObj.gridDetailRight.addRow();

                                                            var lastIdx = nvl(fnObj.gridDetailRight.target.list.length, fnObj.gridDetailRight.lastRow());

                                                            fnObj.gridDetailRight.target.focus(lastIdx - 1);
                                                            fnObj.gridDetailRight.target.select(lastIdx - 1);

                                                            fnObj.gridDetailRight.target.setValue(lastIdx - 1, "TP_DRCR", "2");
                                                            fnObj.gridDetailRight.target.setValue(lastIdx - 1, "NO_LINE", H_lastIdx); //순번
                                                            fnObj.gridDetailRight.target.setValue(lastIdx - 1, "NO_TPDOCU", newNO_TPDOCU);
                                                            fnObj.gridDetailRight.target.setValue(lastIdx - 1, "GROUP_NUMBER", newGROUP_NUMBER);
                                                            fnObj.gridDetailRight.target.setValue(lastIdx - 1, "CD_ACCT", obj.CD_ACCT);
                                                            fnObj.gridDetailRight.target.setValue(lastIdx - 1, "NM_ACCT", obj.NM_ACCT);
                                                            fnObj.gridDetailRight.target.setValue(lastIdx - 1, "AMT", obj.AMT);
                                                            fnObj.gridDetailRight.target.setValue(lastIdx - 1, "CD_BUDGET", obj.CD_BUDGET);
                                                            fnObj.gridDetailRight.target.setValue(lastIdx - 1, "NM_BUDGET", obj.NM_BUDGET);
                                                            fnObj.gridDetailRight.target.setValue(lastIdx - 1, "NM_BGACCT", obj.NM_BGACCT);
                                                            fnObj.gridDetailRight.target.setValue(lastIdx - 1, "CD_BGACCT", obj.CD_BGACCT);
                                                            fnObj.gridDetailRight.target.setValue(lastIdx - 1, "REMARK", obj.REMARK);
                                                            fnObj.gridDetailRight.target.setValue(lastIdx - 1, "TP_EVIDENCE", obj.TP_EVIDENCE);
                                                            fnObj.gridDetailRight.target.setValue(lastIdx - 1, "CD_MNGD", obj.CD_MNGD);
                                                            fnObj.gridDetailRight.target.setValue(lastIdx - 1, "FG_TAX", obj.FG_TAX);
                                                            fnObj.gridDetailRight.target.setValue(lastIdx - 1, "BANK_NM", obj.BANK_NM);
                                                            fnObj.gridDetailRight.target.setValue(lastIdx - 1, "BANK_ACCT_NO", obj.BANK_ACCT_NO);
                                                            for (var z = 1; z < 9; z++) {
                                                                fnObj.gridDetailRight.target.setValue(lastIdx - 1, "CD_MNG" + z, obj["CD_MNG" + z]);
                                                                fnObj.gridDetailRight.target.setValue(lastIdx - 1, "NM_MNG" + z, obj["NM_MNG" + z]);
                                                                fnObj.gridDetailRight.target.setValue(lastIdx - 1, "CD_MNGD" + z, obj["CD_MNGD" + z]);
                                                                fnObj.gridDetailRight.target.setValue(lastIdx - 1, "NM_MNGD" + z, obj["NM_MNGD" + z]);
                                                            }


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
                },
                HEADER_EXP: function (caller) {
                    var temprow = fnObj.gridHeader.getData('selected')[0];
                    if (fnObj.gridHeader.target.list.length == 0) {
                        qray.alert("상단을 먼저 추가하셔야합니다");
                        return;
                    }
                    if (nvl(temprow) == ''){
                        qray.alert('선택된 데이터가 없습니다.');
                        return;
                    }
                    if (temprow.CD_DOCU != '002'){
                        qray.alert('전표유형이 편익인 데이터가 아닙니다.');
                        return;
                    }
                    if (nvl(temprow.CD_PARTNER) == '') {
                        qray.alert('전표유형이 편익인 비용처리건은 거래처가 필수입니다.');
                        return false;
                    }

                    userCallBack = function (e) {
                        fnObj.gridHeader.target.setValue(temprow.__index, 'YN_BENEFIT', "Y");
                        fnObj.gridHeader.target.setValue(temprow.__index, 'BENEFIT', e.list);
                        fnObj.gridHeader.target.list[temprow.__index]['BENEFIT'] = e.list;
                        modal.close();
                    };

                    var parameterDATA = {
                        "DT_ACCT": ax5.util.date(new Date(), {"return": "yyyy-MM-dd"}).replace(/-/gi, "")
                        , "AMT": temprow.AMT_SUM
                        , "benefitList": (nvl(fnObj.gridHeader.target.list[temprow.__index]['BENEFIT']) == '')? [] : fnObj.gridHeader.target.list[temprow.__index]['BENEFIT']
                        , "CD_PARTNER": temprow.CD_PARTNER
                        , "LN_PARTNER": temprow.LN_PARTNER
                        , "GROUP_NUMBER" : temprow.GROUP_NUMBER
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
                },
                HEADER_ADD: function (caller) {
                    // 상단 추가
                    var gridH = fnObj.gridHeader.target.list;

                    for (var i = 0; i < gridH.length; i++) {
                        if (nvl(gridH[i].CD_TPDOCU) == '' || nvl(gridH[i].AMT_SUM) == '') {
                            qray.alert("필수 값이 없는 항목이 있습니다. \n 입력후 추가하셔야합니다");
                            return;
                        }
                    }

                    axboot.ajax({
                        type: "GET",
                        url: ["gldocum2", "getTpDocu"],
                        async: false,
                        callback: function (tpdocu) {
                            if (nvl(tpdocu.map) != '') {
                                axboot.ajax({
                                    type: "GET",
                                    url: ["gldocum2", "getGroupNumber"],
                                    async: false,
                                    callback: function (groupnumber) {
                                        if (nvl(groupnumber.map) != ''){
                                            caller.gridHeader.addRow();

                                            var lastIdx = nvl(caller.gridHeader.target.list.length, caller.gridHeader.lastRow());

                                            caller.gridHeader.target.focus(lastIdx - 1);
                                            caller.gridHeader.target.select(lastIdx - 1);
                                            caller.gridHeader.target.setValue(lastIdx - 1, "GROUP_NUMBER", groupnumber.map.GROUP_NUMBER);
                                            caller.gridHeader.target.setValue(lastIdx - 1, "NO_TPDOCU", tpdocu.map.noTpdocu);
                                            caller.gridHeader.target.setValue(lastIdx - 1, "NO_LINE", lastIdx);
                                            caller.gridHeader.target.setValue(lastIdx - 1, "TP_GB", '03'); //기타
                                            caller.gridHeader.target.setValue(lastIdx - 1, "CD_EXCH", "000");
                                            caller.gridHeader.target.setValue(lastIdx - 1, "NM_EXCH", "KRW");
                                            caller.gridHeader.target.setValue(lastIdx - 1, "RT_EXCH", "1");
                                        }
                                    }
                                })
                            }
                        }
                    });
                },
                HEADER_DEvarE: function (caller) {
                    // caller.gridHeader.delRow("selected");



                            var grid = caller.gridHeader.target.list;
                            var i = grid.length;
                            while (i--) {
                                if (grid[i].CHK == 'Y') {
                                    var notpdocu_h = grid[i].NO_TPDOCU;

                                    caller.gridHeader.delRow(i);

                                    var listL = caller.gridDetailLeft.target.list;
                                    var listR = caller.gridDetailRight.target.list;

                                    var j = listL.length;
                                    while (j--) {
                                        if (listL[j].NO_TPDOCU == notpdocu_h) {
                                            caller.gridDetailLeft.delRow(j);
                                        }
                                    }
                                    j = null;

                                    j = listR.length;
                                    while (j--) {
                                        if (listR[j].NO_TPDOCU == notpdocu_h) {
                                            caller.gridDetailRight.delRow(j);
                                        }
                                    }
                                    j = null;
                                }
                            }
                            i = null;
                },
                DETAIL_LEFT_ADD: function (caller) {
                    var temprow = fnObj.gridHeader.getData("selected")[0];
                    if (fnObj.gridHeader.getData().length == 0) {
                        qray.alert("상단을 먼저 추가하셔야합니다");
                        return;
                    }
                    if (nvl(temprow) == '') {
                        qray.alert("선택된 상위 그리드가 없습니다.");
                        return;
                    }

                    var gridL = fnObj.gridDetailLeft.target.list;

                    for (var i = 0; i < gridL.length; i++) {
                        if (nvl(gridL[i].CD_ACCT) == '') {
                            qray.alert("계정이 없는 항목이 있습니다. \n 입력후 추가하셔야합니다");
                            return;
                        }
                    }

                    caller.gridDetailLeft.addRow();
                    var lastIdx = nvl(caller.gridDetailLeft.target.list.length, caller.gridDetailLeft.lastRow());
                    caller.gridDetailLeft.target.select(lastIdx - 1);
                    caller.gridDetailLeft.target.focus(lastIdx - 1);
                    caller.gridDetailLeft.target.setValue(lastIdx - 1, "NO_LINE", temprow.NO_LINE);
                    caller.gridDetailLeft.target.setValue(lastIdx - 1, "NO_TPDOCU", temprow.NO_TPDOCU);
                    caller.gridDetailLeft.target.setValue(lastIdx - 1, "GROUP_NUMBER", temprow.GROUP_NUMBER);
                    caller.gridDetailLeft.target.setValue(lastIdx - 1, "TP_DRCR", "1");
                    caller.gridDetailLeft.target.setValue(lastIdx - 1, "CD_BUDGET", budget.list[0].CD_BUDGET);
                    caller.gridDetailLeft.target.setValue(lastIdx - 1, "NM_BUDGET", budget.list[0].NM_BUDGET);
                    caller.gridDetailLeft.target.setValue(lastIdx - 1, "TP_EVIDENCE", temprow.TP_EVIDENCE)

                },
                DETAIL_LEFT_DEvarE: function (caller) {
                    var grid = caller.gridDetailLeft.target.list;
                    var i = grid.length;
                    while (i--) {
                        if (grid[i].CHK == 'Y') {
                            caller.gridDetailLeft.delRow(i);
                        }
                    }
                    i = null;
                            calc();

                },
                DETAIL_RIGHT_ADD: function (caller) {
                    var temprow = fnObj.gridHeader.getData("selected")[0];
                    if (fnObj.gridHeader.getData().length == 0) {
                        qray.alert("상단을 먼저 추가하셔야합니다");
                        return;
                    }
                    if (nvl(temprow) == '') {
                        qray.alert("선택된 상위 그리드가 없습니다.");
                        return;
                    }

                    var gridR = fnObj.gridDetailRight.target.list;

                    for (var i = 0; i < gridR.length; i++) {
                        if (nvl(gridR[i].CD_ACCT) == '') {
                            qray.alert("계정이 없는 항목이 있습니다. \n 입력후 추가하셔야합니다");
                            return;
                        }
                    }

                    caller.gridDetailRight.addRow();
                    var lastIdx = nvl(caller.gridDetailRight.target.list.length, caller.gridDetailRight.lastRow());
                    caller.gridDetailRight.target.focus(lastIdx - 1);
                    caller.gridDetailRight.target.select(lastIdx - 1);
                    caller.gridDetailRight.target.setValue(lastIdx - 1, "NO_LINE", temprow.NO_LINE);
                    caller.gridDetailRight.target.setValue(lastIdx - 1, "GROUP_NUMBER", temprow.GROUP_NUMBER);
                    caller.gridDetailRight.target.setValue(lastIdx - 1, "NO_TPDOCU", temprow.NO_TPDOCU);
                    caller.gridDetailRight.target.setValue(lastIdx - 1, "TP_DRCR", "2");
                    caller.gridDetailRight.target.setValue(lastIdx - 1, "CD_BUDGET", budget.list[0].CD_BUDGET);
                    caller.gridDetailRight.target.setValue(lastIdx - 1, "NM_BUDGET", budget.list[0].NM_BUDGET);
                    caller.gridDetailRight.target.setValue(lastIdx - 1, "TP_EVIDENCE", temprow.TP_EVIDENCE);

                },
                DETAIL_RIGHT_DEvarE: function (caller) {
                    var grid = caller.gridDetailRight.target.list;
                    var i = grid.length;
                    while (i--) {
                        if (grid[i].CHK == 'Y') {
                            caller.gridDetailRight.delRow(i);
                        }
                    }
                    i = null;
                    calc();
                },
                FILE_UPLOAD: function(caller){
                    var selectedH = caller.gridHeader.getData('selected')[0];

                    if (nvl(selectedH) == ''){
                        qray.alert('선택된 데이터가 없습니다.');
                        return false;
                    }

                    userCallBack = function(e){
                        console.log(e);
                        qray.alert('임시저장하였습니다.<br>본화면에서 저장을 누르셔야 저장됩니다.');
                        caller.gridHeader.target.setValue(selectedH.__index, 'fileData',  JSON.stringify({gridData : e.gridData,delete : e.delete}));
                        caller.gridHeader.target.list[selectedH.__index]['fileData'] = {
                            gridData : e.gridData,
                            delete : e.delete
                        };
                        modal.close();
                    };

                    if (nvl(selectedH.fileData) != ''){
                        var sendData = {
                            "P_BOARD_TYPE": 'DOCU', // [ 모듈_메뉴명_해당ID값
                            "P_SEQ": selectedH.GROUP_NUMBER,
                            "imsiFile": {
                                gridData:   selectedH.fileData.gridData,
                                delete  :   selectedH.fileData.delete
                            }
                        }
                    }else{
                        var sendData = {
                            "P_BOARD_TYPE": 'DOCU', // [ 모듈_메뉴명_해당ID값
                            "P_SEQ": selectedH.GROUP_NUMBER,
                        }
                    }

                    modal.open({
                        top: _pop_top,
                        width: 1000,
                        height: _pop_height,
                        iframe: {
                            method: "get",
                            url: "../../common/fileBrowser.jsp",
                            param: "callBack=userCallBack"
                        },
                        sendData: sendData,
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
                        showLineNumber : false,
                        frozenColumnIndex: 0,
                        target: $('[data-ax5grid="grid-header"]'),
                        virtualScrollX: true,
                        columns: [
                            {
                                key: "CHK", label: "", width: 30, align: "center", dirty:false,
                                label:
                                    '<div id="headerBox" data-ax5grid-editor="checkbox" data-ax5grid-checked="false" data-ax5grid-column-selected="true" style="height:17px;width:17px;margin-top:2px;  onclick="javascript:alert(1);"></div>',
                                editor: {
                                    type: "checkbox", config: {height: 17, trueValue: "Y", falseValue: "N"}
                                }
                            },
                            {
                                key: "NO_LINE",
                                label: "순번",
                                width: 43,
                                align: "center",
                                editor: false,
                                hidden: false,
                                sortable : true,
                                styleClass: function () {
                                    return "readonly";
                                }
                            },
                            {
                                key: "GROUP_NUMBER",
                                label: "h_그룹넘버",
                                width: 150,
                                align: "center",
                                editor: false,
                                hidden: true
                            },
                            {
                                key: "NO_TPDOCU",
                                label: "h_NO_TPDOCU고유번호",
                                width: 200,
                                align: "left",
                                editor: false,
                                hidden: true
                            },
                            {
                                key: "TP_GB",
                                label: "유형",
                                width: 57,
                                align: "center",
                                editor: false,
                                hidden: false,
                                formatter: function () {
                                    return $.changeTextValue(data_tp_gb, this.value)
                                },
                                styleClass: function () {
                                    return "readonly";
                                }
                            },
                            {
                                key: "CD_DOCU", label: "<span style=\"color:red;\"> * </span>전표유형", width: 70, align: "center",
                                formatter: function () {
                                    return $.changeTextValue(searchCdDocuInfo, this.value)
                                }
                                , editor: {
                                    type: "select", config: {
                                        columnKeys: {
                                            optionValue: "CODE", optionText: "TEXT"
                                        },
                                        options: data_cdDocu_

                                    },
                                    disabled: function () {
                                        if (this.item.TP_GB == '01') {
                                            return true;
                                        } else {
                                            return false;
                                        }
                                    }

                                },
                            },
                            {
                                key: "GROUP_NUMBER",
                                label: "h_그룹넘버",
                                width: 150,
                                align: "center",
                                editor: false,
                                hidden: true
                            },
                            {
                                key: "CD_TPDOCU",
                                label: "h_지출유형",
                                width: 150,
                                align: "center",
                                editor: false,
                                hidden: true
                            },
                            {
                                key: "NM_TPDOCU",
                                label: "<span style=\"color:red;\"> * </span>지출유형",
                                width: 150,
                                align: "left",
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
                                            "CD_DOCU": fnObj.gridHeader.target.getList()[actionRowIdx].CD_DOCU,
                                            "CD_DEPT": SCRIPT_SESSION.cdDept
                                        }
                                    },
                                    disabled: function () {
                                        var CD_DOCU = fnObj.gridHeader.target.getList()[actionRowIdx].CD_DOCU;
                                        if (nvl(CD_DOCU) == '') {
                                            qray.alert("전표유형을 선택하여 주십시오");
                                            return true;
                                        } else {
                                            return false;
                                        }
                                    },
                                    callback: function (e) {
                                        var CD_DOCU = fnObj.gridHeader.target.getList()[actionRowIdx].CD_DOCU;
                                        var GROUP_NUMBER = fnObj.gridHeader.target.getList()[actionRowIdx].GROUP_NUMBER;
                                        var NO_TPDOCU = fnObj.gridHeader.target.getList()[actionRowIdx].NO_TPDOCU;
                                        var TP_EVIDENCE = fnObj.gridHeader.target.getList()[actionRowIdx].TP_EVIDENCE;    //  증빙유형
                                        var NO_LINE = fnObj.gridHeader.target.getList()[actionRowIdx].NO_LINE;
                                        var noTax = fnObj.gridHeader.target.getList()[actionRowIdx].PARAM;      //  매출세금계산서에서 넘어온 NO_TAX [ ACCTENT 테이블 ]

                                        var listL = fnObj.gridDetailLeft.target.list;
                                        var listR = fnObj.gridDetailRight.target.list;

                                        var j = listL.length;
                                        while (j--) {
                                            if (listL[j].NO_TPDOCU == NO_TPDOCU) {
                                                fnObj.gridDetailLeft.delRow(j);
                                            }
                                        }
                                        j = null;

                                        j = listR.length;
                                        while (j--) {
                                            if (listR[j].NO_TPDOCU == NO_TPDOCU) {
                                                fnObj.gridDetailRight.delRow(j);
                                            }
                                        }
                                        j = null;

                                        fnObj.gridHeader.target.setValue(actionRowIdx, "CD_TPDOCU", e[0].CD_TPDOCU);
                                        fnObj.gridHeader.target.setValue(actionRowIdx, "NM_TPDOCU", e[0].NM_TPDOCU);

                                        axboot.ajax({
                                            async: false,
                                            type: "GET",
                                            url: ["gldocum", "tpdocuAcct"],
                                            data: {
                                                P_CD_TPDOCU: e[0].CD_TPDOCU,
                                                P_CD_DOCU: CD_DOCU
                                            },
                                            callback: function (res) {
                                                //지출유형 선택시 하단그리드입력
                                                for (var i = 0; i < res.list.length; i++) {
                                                    var obj = res.list[i];
                                                    if (obj.TP_DRCR == "1") {
                                                        fnObj.gridDetailLeft.addRow();
                                                        var lastIdx = nvl(fnObj.gridDetailLeft.target.list.length, fnObj.gridDetailLeft.lastRow());
                                                        fnObj.gridDetailLeft.target.focus(lastIdx - 1);
                                                        fnObj.gridDetailLeft.target.select(lastIdx - 1);
                                                        fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "TP_DRCR", obj.TP_DRCR);
                                                        fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "NO_LINE", NO_LINE);
                                                        fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "GROUP_NUMBER", GROUP_NUMBER);
                                                        fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "NO_TPDOCU", NO_TPDOCU);
                                                        fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "CD_ACCT", obj.CD_ACCT);
                                                        fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "NM_ACCT", obj.NM_ACCT);
                                                        fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "CD_BUDGET", budget.list[0].CD_BUDGET);
                                                        fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "NM_BUDGET", budget.list[0].NM_BUDGET);
                                                        fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "TP_EVIDENCE", TP_EVIDENCE);
                                                        fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "REMARK", obj.NM_DESC);

                                                        var data = $.DATA_SEARCH('apbucard', 'bgacctSetting', {
                                                            CD_ACCT: obj.CD_ACCT,
                                                            CD_BUDGET: budget.list[0].CD_BUDGET
                                                        });
                                                        if (data.list.length > 0) {
                                                            fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "NM_BGACCT", data.list[0].NM_BGACCT);
                                                            fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "CD_BGACCT", data.list[0].CD_BGACCT);
                                                        } else {
                                                            fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "NM_BGACCT", '');
                                                            fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "CD_BGACCT", '');
                                                        }

                                                        setStMngd(obj.CD_ACCT, "1", lastIdx - 1);

                                                        /*   CZ_Q_FI_TAX 에서 임시저장된 부가세 정보 가져오기 [ 세무구분, 공급대가, 공급가액, 부가세액 ]   */
                                                        if (tax_code_dr.indexOf(obj.CD_ACCT) > -1) {
                                                            fnObj.gridDetailLeft.target.setValue(lastIdx - 1, "NO_TAX", noTax);
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
                                                        fnObj.gridDetailRight.target.focus(lastIdx - 1);
                                                        fnObj.gridDetailRight.target.select(lastIdx - 1);
                                                        fnObj.gridDetailRight.target.setValue(lastIdx - 1, "TP_DRCR", obj.TP_DRCR);
                                                        fnObj.gridDetailRight.target.setValue(lastIdx - 1, "NO_LINE", NO_LINE);
                                                        fnObj.gridDetailRight.target.setValue(lastIdx - 1, "GROUP_NUMBER", GROUP_NUMBER);
                                                        fnObj.gridDetailRight.target.setValue(lastIdx - 1, "NO_TPDOCU", NO_TPDOCU);
                                                        fnObj.gridDetailRight.target.setValue(lastIdx - 1, "CD_ACCT", obj.CD_ACCT);
                                                        fnObj.gridDetailRight.target.setValue(lastIdx - 1, "NM_ACCT", obj.NM_ACCT);
                                                        fnObj.gridDetailRight.target.setValue(lastIdx - 1, "CD_BUDGET", budget.list[0].CD_BUDGET);
                                                        fnObj.gridDetailRight.target.setValue(lastIdx - 1, "NM_BUDGET", budget.list[0].NM_BUDGET);
                                                        fnObj.gridDetailRight.target.setValue(lastIdx - 1, "TP_EVIDENCE", TP_EVIDENCE);
                                                        fnObj.gridDetailRight.target.setValue(lastIdx - 1, "REMARK", obj.NM_DESC);

                                                        var data = $.DATA_SEARCH('apbucard', 'bgacctSetting', {
                                                            CD_ACCT: obj.CD_ACCT,
                                                            CD_BUDGET: budget.list[0].CD_BUDGET
                                                        });
                                                        if (data.list.length > 0) {
                                                            fnObj.gridDetailRight.target.setValue(lastIdx - 1, "NM_BGACCT", data.list[0].NM_BGACCT);
                                                            fnObj.gridDetailRight.target.setValue(lastIdx - 1, "CD_BGACCT", data.list[0].CD_BGACCT);
                                                        } else {
                                                            fnObj.gridDetailRight.target.setValue(lastIdx - 1, "NM_BGACCT", '');
                                                            fnObj.gridDetailRight.target.setValue(lastIdx - 1, "CD_BGACCT", '');
                                                        }
                                                        setStMngd(obj.CD_ACCT, "2", lastIdx - 1);

                                                        /*   CZ_Q_FI_TAX 에서 임시저장된 부가세 정보 가져오기 [ 세무구분, 공급대가, 공급가액, 부가세액 ]   */
                                                        if (tax_code_cr.indexOf(obj.CD_ACCT) > -1) {
                                                            fnObj.gridDetailRight.target.setValue(lastIdx - 1, "NO_TAX", noTax);
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
                                                var tempemp = SCRIPT_SESSION.noEmp;
                                                var temppartner = fnObj.gridHeader.target.getList()[actionRowIdx]["CD_PARTNER"];
                                                var tempdt = fnObj.gridHeader.target.getList()[actionRowIdx]["DT_TRANS"];
                                                var tempNO_TPDOCU = fnObj.gridHeader.target.getList()[actionRowIdx]["NO_TPDOCU"];
                                                var tempAMT = fnObj.gridHeader.target.getList()[actionRowIdx]["AMT_SUPPLY"];
                                                //사원코드,거래처코드,날짜,금액,키값명칭,키값
                                                getAutoMngd(tempemp, temppartner, tempdt, tempAMT, "NO_TPDOCU", tempNO_TPDOCU);
                                                //하단그리드 금액자동세팅
                                                setAMTline(fnObj.gridHeader.target.getList()[actionRowIdx]);
                                            }
                                        });
                                    },
                                },
                            },
                            {
                                key: "TP_EVIDENCE", label: "증빙유형", width: 110, align: "left",
                                formatter: function () {
                                    return $.changeTextValue(data_TP_EVIDENCE, this.value);
                                }
                                , editor: {
                                    type: "select", config: {
                                        columnKeys: {
                                            optionValue: "CODE", optionText: "TEXT"
                                        },
                                        options: data_TP_EVIDENCE

                                    }
                                }
                            },
                            {
                                key: "CD_PARTNER",
                                label: "h_거래처코드",
                                width: 150,
                                align: "left",
                                editor: false,
                                hidden: true
                            },
                            {
                                key: "LN_PARTNER", label: "거래처", width: 150, align: "left",
                                editor: {
                                    type: "text",
                                    disabled: function () {
                                        console.log("LN_PARTNER editor this : ", this);
                                        if (this.item.TP_GB == '01') {
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
                                        fnObj.gridHeader.target.setValue(actionRowIdx, "CD_PARTNER", e[0].CD_PARTNER);
                                        fnObj.gridHeader.target.setValue(actionRowIdx, "LN_PARTNER", e[0].LN_PARTNER);
                                    },
                                    disabled: function(){
                                        if (this.item.TP_GB == '01') {
                                            return true;
                                        } else {
                                            if (nvl(this.item.CD_DOCU) == ''){
                                                qray.alert('전표유형을 선택해주세요.');
                                                return true;
                                            }
                                            return false;
                                        }
                                    }
                                    /*disabled: function () {
                                        var CD_DOCU = fnObj.gridHeader.target.getList()[actionRowIdx].CD_DOCU;
                                        if (nvl(CD_DOCU) == '') {
                                            return true;
                                        } else {
                                            return false;
                                        }
                                    }*/
                                }
                            },
                            {
                                key: "DT_TRANS", label: "계산서일자", width: 80, align: "center", editor: {
                                    type: "date",
                                    config: {
                                        content: {
                                            config: {
                                                mode: "day", selectMode: "day"
                                            }
                                        }
                                    },
                                    disabled: function(){
                                        if (this.item.TP_GB == '01') {
                                            return true;
                                        } else {
                                            if (nvl(this.item.CD_DOCU) == ''){
                                                qray.alert('전표유형을 선택해주세요.');
                                                return true;
                                            }
                                            return false;
                                        }
                                    }
                                },
                                formatter: function () {
                                    var returnValue = this.item.DT_TRANS;
                                    if (nvl(this.item.DT_TRANS, '') != '') {
                                        this.item.DT_TRANS = this.item.DT_TRANS.replace(/\-/g, '');
                                        returnValue = this.item.DT_TRANS.replace(/(\d{4})(\d{2})(\d{2})/, '$1-$2-$3');
                                    }
                                    return returnValue;
                                }
                            },
                            {key: "REMARK", label: "<span style=\"color:red;\"> * </span>적요", width: "*", align: "left", editor: {type: "text"}},
                            {
                                key: "CD_EXCH",
                                label: "환종",
                                width: 80,
                                align: "center",
                                editor: false,
                                hidden: true
                            },
                            {
                                key: "NM_EXCH",
                                label: "환종",
                                width: 40,
                                align: "center",
                                hidden: false,
                                editor: {
                                    type: "text",
                                    /*disabled: function () {
                                        console.log("환종 : ", this);
                                        var CD_DOCU = fnObj.gridHeader.target.getList()[actionRowIdx].CD_DOCU;
                                        if (nvl(CD_DOCU) == '') {
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
                                    url: "anticipation",
                                    action: ["commonHelp", "HELP_ANTICIPATION"],
                                    callback: function (e) {
                                        fnObj.gridHeader.target.setValue(actionRowIdx, "CD_EXCH", e[0].CD_SYSDEF);
                                        fnObj.gridHeader.target.setValue(actionRowIdx, "NM_EXCH", e[0].NM_SYSDEF);
                                    },
                                    disabled: function(){
                                        if (this.item.TP_GB == '01') {
                                            return true;
                                        } else {
                                            if (nvl(this.item.CD_DOCU) == ''){
                                                qray.alert('전표유형을 선택해주세요.');
                                                return true;
                                            }
                                            return false;
                                        }
                                    }
                                    /*disabled: function () {
                                        var CD_DOCU = fnObj.gridHeader.target.getList()[actionRowIdx].CD_DOCU;
                                        if (nvl(CD_DOCU) == '') {
                                            return true;
                                        } else {
                                            return false;
                                        }
                                    }*/
                                }
                            },
                            {
                                key: "RT_EXCH",
                                label: "환율",
                                width: 50,
                                align: "center",
                                editor: {
                                    type: "number",
                                    disabled:  function () {
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
                                width: 120,
                                align: "right",
                                editor: {type: "number",
                                    disabled: function(){
                                        if (this.item.TP_GB == '01') {
                                            return true;
                                        } else {
                                            return false;
                                        }
                                    }
                                },
                                hidden: false,
                                formatter: function() {
                                    if (nvl(this.item.AMT_LOCAL) == '') {
                                        this.item.AMT_LOCAL = 0;
                                    }
                                    this.item.AMT_LOCAL = Number(this.item.AMT_LOCAL);
                                    return comma(this.item.AMT_LOCAL);
                                }
                            },
                            {
                                key: "AMT_SUPPLY",
                                label: "<span style=\"color:red;\"> * </span>공급가액",
                                width: 120,
                                align: "right",
                                editor: {
                                    type: "number",
                                    disabled: function(){
                                        if (this.item.TP_GB == '01') {
                                            return true;
                                        } else {
                                            return false;
                                        }
                                    }
                                },
                                formatter: function() {
                                    if (nvl(this.item.AMT_SUPPLY) == '') {
                                        this.item.AMT_SUPPLY = 0;
                                    }
                                    this.item.AMT_SUPPLY = Number(this.item.AMT_SUPPLY);
                                    return comma(this.item.AMT_SUPPLY);
                                }
                            },
                            {
                                key: "AMT_VAT",
                                label: "<span style=\"color:red;\"> * </span>부가세",
                                width: 120,
                                align: "right",
                                editor: {
                                    type: "number",
                                    disabled: function(){
                                        if (this.item.TP_GB == '01') {
                                            return true;
                                        } else {
                                            return false;
                                        }
                                    }
                                },
                                formatter: function() {
                                    if (nvl(this.item.AMT_VAT) == '') {
                                        this.item.AMT_VAT = 0;
                                    }
                                    this.item.AMT_VAT = Number(this.item.AMT_VAT);
                                    return comma(this.item.AMT_VAT);
                                }
                            },
                            {
                                key: "AMT_SUM",
                                label: "합계금액",
                                width: 120,
                                align: "right",
                                editor: false,
                                formatter: "money"
                                , styleClass: function () {
                                    return "readonly";
                                }
                            },
                            {
                                key: "ID_INSERT",
                                label: "처리자사번",
                                width: 150,
                                align: "left",
                                editor: false,
                                hidden: true,
                            },
                            {
                                key: "NM_INSERT",
                                label: "처리자",
                                width: 80,
                                align: "center",
                                editor: false,
                                styleClass: function () {
                                    return "readonly";
                                }
                            },
                            {
                                key: "ID_UPDATE",
                                label: "최종수정자사번",
                                width: 80,
                                align: "left",
                                editor: false,
                                hidden: true,
                            },
                            {
                                key: "NM_UPDATE",
                                label: "최종처리자",
                                width: 80,
                                align: "center",
                                editor: false,
                                styleClass: function () {
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
                            {
                                key: "fileData",
                                label: "파일",
                                width: 150,
                                align: "left",
                                editor: false,
                                hidden: true
                            },
                            {
                                key: "BENEFIT",
                                label: "편익",
                                width: 150,
                                align: "left",
                                editor: false,
                                hidden: true
                            },
                            {
                                key: "YN_BENEFIT",
                                label: "편익여부",
                                width: 150,
                                align: "left",
                                editor: false,
                                hidden: true
                            },

                        ],
                        footSum: [
                            [
                                {label: "합 계", colspan: 11, align: "center"},
                                {key: "AMT_LOCAL", collector: "sum", formatter: "money", align: "right"},
                                {key: "AMT_SUPPLY", collector: "sum", formatter: "money", align: "right"},
                                {key: "AMT_VAT", collector: "sum", formatter: "money", align: "right"},
                                {key: "AMT_SUM", collector: "sum", formatter: "money", align: "right"},
                            ]
                        ],
                        body: {
                            onClick: function () {
                                actionRowIdx = this.dindex;
                                fnObj.gridHeader.target.select(this.dindex);
                                if (this.column.key == "FG_TAX") {
                                    for (var i = 0; i < fnObj.gridHeader.target.config.columns.length; i++) {
                                        if (fnObj.gridHeader.target.config.columns[i].key == "FG_TAX") {
                                            if (this.list[this.dindex].CD_DOCU == "001") {
                                                fnObj.gridHeader.target.config.columns[i].editor.config.options = data_purch;
                                            } else if (this.list[this.dindex].CD_DOCU == "005") {
                                                fnObj.gridHeader.target.config.columns[i].editor.config.options = data_sales;
                                            } else {
                                                fnObj.gridHeader.target.config.columns[i].editor.config.options = [];
                                            }
                                            break;
                                        }
                                    }

                                }
                                /*this.self.focus(this.dindex);*/
                            },
                            onDBLClick: function () {
                                actionRowIdx = this.dindex;
                            },
                            onDataChanged: function () {
                                if (this.key == 'CHK'){
                                    var remark = "";
                                    var count = 0;
                                    var chkH = isChecked(fnObj.gridHeader.getData("CHK"));
                                    for (var i = 0 ; i < chkH.length ; i ++){
                                        if (i == 0){
                                            remark = nvl(chkH.result[0].REMARK);
                                        }
                                        count++;
                                    }
                                    if (count == 0){
                                        $("#REMARK").val('');
                                    }else if (count == 1){
                                        $("#REMARK").val("[지출결의] " + remark  + " ( " + SCRIPT_SESSION.nmEmp + ", " + ax5.util.date($("#dtAcct").val(), {"return": "MM/dd"}) + " )");

                                    }else{
                                        $("#REMARK").val("[지출결의] " + remark + " 외 " + (count - 1) + "건 ( " + SCRIPT_SESSION.nmEmp + ", " + ax5.util.date($("#dtAcct").val(), {"return": "MM/dd"}) + " )");
                                    }
                                }
                                /*if (this.key == 'CHK'){
                                    var no_tpdocu = this.item.NO_TPDOCU;
                                    if (this.value == 'Y'){
                                        for (var i = 0 ; i < fnObj.gridDetailRight.target.list.length ; i ++){
                                            if (no_tpdocu == fnObj.gridDetailRight.target.list[i].NO_TPDOCU){
                                                fnObj.gridDetailRight.target.setValue(i, "CHK", "Y");
                                            }
                                        }
                                        for (var i = 0 ; i < fnObj.gridDetailLeft.target.list.length ; i ++){
                                            if (no_tpdocu == fnObj.gridDetailLeft.target.list[i].NO_TPDOCU){
                                                fnObj.gridDetailLeft.target.setValue(i, "CHK", "Y");
                                            }
                                        }
                                    }else{
                                        for (var i = 0 ; i < fnObj.gridDetailRight.target.list.length ; i ++){
                                            if (no_tpdocu == fnObj.gridDetailRight.target.list[i].NO_TPDOCU){
                                                fnObj.gridDetailRight.target.setValue(i, "CHK", "N");
                                            }
                                        }
                                        for (var i = 0 ; i < fnObj.gridDetailLeft.target.list.length ; i ++){
                                            if (no_tpdocu == fnObj.gridDetailLeft.target.list[i].NO_TPDOCU){
                                                fnObj.gridDetailLeft.target.setValue(i, "CHK", "N");
                                            }
                                        }
                                    }
                                }*/
                                if (this.key == 'TP_EVIDENCE') {
                                    var listL = fnObj.gridDetailLeft.target.list;
                                    var i = listL.length;
                                    while (i--) {
                                        if (listL[i].NO_TPDOCU == this.item.NO_TPDOCU) {
                                            fnObj.gridDetailLeft.target.setValue(i, "TP_EVIDENCE", this.value);
                                        }
                                    }
                                    i = null;

                                    var listR = fnObj.gridDetailRight.target.list;
                                    var i = listR.length;
                                    while (i--) {
                                        if (listR[i].NO_TPDOCU == this.item.NO_TPDOCU) {
                                            fnObj.gridDetailRight.target.setValue(i, "TP_EVIDENCE", this.value);
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
                                        if (nvl(this.item.AMT_LOCAL) != '' && nvl($("#dtAcct").val()).replace(/-/gi, "") != '' && nvl(this.item.CD_EXCH) != '')
                                            fnObj.gridHeader.target.setValue(this.dindex, "AMT_SUPPLY", (parseInt(this.item.AMT_LOCAL) * parseInt(this.item.RT_EXCH)));
                                    } else {
                                        fnObj.gridHeader.target.setValue(this.dindex, "RT_EXCH", 0);
                                    }
                                }
                                if (this.key == 'RT_EXCH') { // 환율변경시
                                    if (nvl(this.item.AMT_LOCAL) != '') {
                                        fnObj.gridHeader.target.setValue(this.dindex, "AMT_SUPPLY", (parseInt(this.value) * parseInt(this.item.AMT_LOCAL)));
                                    }
                                }
                                if (this.key == 'AMT_LOCAL') { //외화금액 변경시 원화공급가에 계산해서 넣어줌
                                    if (nvl($("#dtAcct").val()).replace(/-/gi, "") != '' && nvl(this.item.CD_EXCH) != '') {
                                        fnObj.gridHeader.target.setValue(this.dindex, "AMT_SUPPLY", (parseInt(this.value) * parseInt(this.item.RT_EXCH)));
                                    }
                                }

                                if (this.key == 'CD_DOCU') {
                                    if (this.value == '004'){
                                        fnObj.gridHeader.target.setValue(this.dindex, 'TP_GB', '03')
                                    }else if (this.value == '006'){
                                        fnObj.gridHeader.target.setValue(this.dindex, 'TP_GB', '03')
                                    } else if (this.value == '007'){
                                        fnObj.gridHeader.target.setValue(this.dindex, 'TP_GB', '07')
                                    } else if (this.value == '002'){
                                        if (this.item.TP_GB == '01'){
                                            fnObj.gridHeader.target.setValue(this.dindex, 'TP_GB', '01')
                                        }else if (this.item.TP_GB == '03'){
                                            fnObj.gridHeader.target.setValue(this.dindex, 'TP_GB', '03')
                                        }
                                    }
                                    var NO_TPDOCU = fnObj.gridHeader.target.list[this.dindex].NO_TPDOCU;

                                    var listL = fnObj.gridDetailLeft.target.list;
                                    var listR = fnObj.gridDetailRight.target.list;

                                    var j = listL.length;
                                    while (j--) {
                                        if (listL[j].NO_TPDOCU == NO_TPDOCU) {
                                            fnObj.gridDetailLeft.delRow(j);
                                        }
                                    }
                                    j = null;

                                    j = listR.length;
                                    while (j--) {
                                        if (listR[j].NO_TPDOCU == NO_TPDOCU) {
                                            fnObj.gridDetailRight.delRow(j);
                                        }
                                    }
                                    j = null;

                                    fnObj.gridHeader.target.setValue(this.dindex, "CD_TPDOCU", '');
                                    fnObj.gridHeader.target.setValue(this.dindex, "NM_TPDOCU", '');
                                }
                                //부가세를 임시저장한후 상단의 부가세를 변경하고 전표처리해버리면 임시저장한값과 전표의 부가세값이 달라지는 문제가 생기기때문에
                                //fnObj.gridDetailLeft.target.setValue(i, "AMT", this.value); 부분(자동으로 값을넣어주는 부분) 을 주석처리함

                                //금액을 자동으로 넣어주려면 부가세 팝업에서 부가세 금액을 리턴해서 그값을 부가세라인의 특정 컬럼에 넣어서
                                //부가세 라인의 금액과 비교해서 값이 다르면 전표처리안되게 해야함

                                //금액,부가세,합계금액 변경시 합계값,하단그리드 금액등 세팅
                                if (this.key == "AMT_SUPPLY") {
                                    if (nvl(this.value) == ''){
                                        this.item.AMT_SUPPLY = 0;
                                    }
                                    var tempindex = this.dindex;
                                    var tempvat = fnObj.gridHeader.getData("selected")[0];
                                    fnObj.gridHeader.target.setValue(tempindex, "AMT_SUM", Number(this.value) + Number(nvl(tempvat.AMT_VAT, 0)));

                                    setAMTline(fnObj.gridHeader.getData("selected")[0]);

                                } else if (this.key == "AMT_VAT") { //부가세
                                    if (nvl(this.value) == ''){
                                        this.item.AMT_VAT = 0;
                                    }
                                    var tempvat = fnObj.gridHeader.getData("selected")[0];
                                    fnObj.gridHeader.target.setValue(this.dindex, "AMT_SUM", Number(this.value) + Number(nvl(tempvat.AMT_SUPPLY, 0)));
                                    setAMTline(fnObj.gridHeader.getData("selected")[0]);
                                } else if (this.key == "AMT_SUM") { //합계금액
                                    setAMTline(fnObj.gridHeader.getData("selected")[0]);
                                } else if (this.key == "REMARK") { //적요
                                  
                                }

                                if (this.key == "CD_PARTNER" || this.key == "DT_TRANS" || this.key == "AMT_SUPPLY") {
                                    var actionRowIdx = this.dindex;
                                    //자동으로 들어갈수있는 관리항목들은 자동으로 들어가게 세팅
                                    var tempemp = SCRIPT_SESSION.noEmp;
                                    var temppartner = fnObj.gridHeader.target.getList()[actionRowIdx]["CD_PARTNER"];
                                    var tempdt = fnObj.gridHeader.target.getList()[actionRowIdx]["DT_TRANS"];
                                    var tempNO_TPDOCU = fnObj.gridHeader.target.getList()[actionRowIdx]["NO_TPDOCU"];
                                    var tempAMT = fnObj.gridHeader.target.getList()[actionRowIdx]["AMT_SUPPLY"];
                                    var tempvat = fnObj.gridHeader.target.getList()[actionRowIdx]["AMT_VAT"];
                                    var tempsum = fnObj.gridHeader.target.getList()[actionRowIdx]["AMT_SUM"];
                                    var tempcddocu = fnObj.gridHeader.target.getList()[actionRowIdx]["CD_DOCU"];
                                    //사원코드,거래처코드,날짜,금액,키값명칭,키값
                                    getAutoMngd(tempemp, temppartner, tempdt, tempAMT, "NO_TPDOCU", tempNO_TPDOCU);
                                }

                            }
                        },
                        onPageChange: function (pageNumber) {
                            _this.setPageData({pageNumber: pageNumber});
                            //ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
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
                        TP_EVIDENCE: "01",
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
                        showLineNumber : false,
                        frozenColumnIndex: 0,
                        target: $('[data-ax5grid="grid-detail-left"]'),
                        virtualScrollX: true,
                        columns: [
                            {
                                key: "CHK", label: "", width: 40, align: "center", dirty:false,
                                label:
                                    '<div id="left_headerBox" data-ax5grid-editor="checkbox" data-ax5grid-checked="false" data-ax5grid-column-selected="true" style="height:17px;width:17px;margin-top:2px;  onclick="javascript:alert(1);"></div>',
                                editor: {
                                    type: "checkbox", config: {height: 17, trueValue: "Y", falseValue: "N"}
                                }
                            },
                            {
                                key: "NO_LINE",
                                label: "순번",
                                width: 50,
                                align: "center",
                                editor: false,
                                hidden: false,
                                sortable : true,
                                styleClass: function () {
                                    return "readonly";
                                }
                            },
                            {
                                key: "SEQ",
                                label: "순번",
                                width: 40,
                                align: "left",
                                editor: false,
                                hidden: true,
                                styleClass: function () {
                                    return "readonly";
                                }
                            },
                            {
                                key: "GB", label: "h_차대구분", width: 150, align: "center", formatter: function () {
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
                                key: "TP_DRCR", label: "h_차대구분", width: 150, align: "center", formatter: function () {
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
                                key: "GROUP_NUMBER",
                                label: "h_그룹넘버",
                                width: 150,
                                align: "center",
                                editor: false,
                                hidden: true
                            },
                            {
                                key: "NO_TPDOCU",
                                label: "h_NO_TPDOCU고유번호",
                                width: 200,
                                align: "left",
                                editor: false,
                                hidden: true
                            },
                            {
                                key: "CD_ACCT",
                                label: "<span style=\"color:red;\"> * </span>계정코드",
                                width: 80,
                                align: "center",
                                editor: {
                                    type: "text",
                                    /*disabled: function () {
                                        var NO_TPDOCU = fnObj.gridDetailLeft.target.getList()[actionRowIdxL].NO_TPDOCU;
                                        var listH = fnObj.gridHeader.target.getList();
                                        var i = listH.length;
                                        var item;
                                        while (i--) {
                                            if (listH[i].NO_TPDOCU == NO_TPDOCU) {
                                                console.log(listH[i]);
                                                item = listH[i];
                                                break;
                                            }
                                        }
                                        if (nvl(item.CD_DOCU) == '') {
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
                                    url: "acct",
                                    action: ["commonHelp", "HELP_ACCT"],
                                    param: function () {
                                        var NO_TPDOCU = fnObj.gridDetailLeft.target.getList()[actionRowIdxL].NO_TPDOCU;
                                        var listH = fnObj.gridHeader.target.getList();
                                        var i = listH.length;
                                        var item;
                                        while (i--) {
                                            if (listH[i].NO_TPDOCU == NO_TPDOCU) {
                                                console.log(listH[i]);
                                                item = listH[i];
                                                break;
                                            }
                                        }
                                        if (item.CD_DOCU == '004' || item.CD_DOCU == '008' || item.CD_DOCU == '009') {   //  전표유형이 기타,반제일 때는 차대구분 없이 모든 계정을 조회한다.
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
                                        var index = this.dindex;
                                        fnObj.gridDetailLeft.target.setValue(this.dindex, "CD_ACCT", e[0].CD_ACCT);
                                        fnObj.gridDetailLeft.target.setValue(this.dindex, "NM_ACCT", e[0].NM_ACCT);

                                        var data = $.DATA_SEARCH('apbucard', 'bgacctSetting', {
                                            CD_ACCT: e[0].CD_ACCT,
                                            CD_BUDGET: this.item.CD_BUDGET
                                        });
                                        if (data.list.length > 0) {
                                            fnObj.gridDetailLeft.target.setValue(this.dindex, "NM_BGACCT", data.list[0].NM_BGACCT);
                                            fnObj.gridDetailLeft.target.setValue(this.dindex, "CD_BGACCT", data.list[0].CD_BGACCT);
                                        } else {
                                            fnObj.gridDetailLeft.target.setValue(this.dindex, "NM_BGACCT", '');
                                            fnObj.gridDetailLeft.target.setValue(this.dindex, "CD_BGACCT", '');
                                        }
                                        setStMngd(this.item.CD_ACCT, "1", this.dindex);
                                        clearMngd("1", this.dindex);

                                        //자동으로 들어갈수있는 관리항목들은 자동으로 들어가게 세팅
                                        var listH = fnObj.gridHeader.target.getList();
                                        var i = listH.length;
                                        var tempitemH;
                                        while (i--) {
                                            if (listH[i].NO_TPDOCU == this.item.NO_TPDOCU) {
                                                console.log(listH[i]);
                                                tempitemH = listH[i];
                                                break;
                                            }
                                        }
                                        var tempemp = SCRIPT_SESSION.noEmp;
                                        var temppartner = tempitemH.CD_PARTNER;
                                        var tempdt = tempitemH.DT_TRANS;
                                        var tempNO_TPDOCU = tempitemH.NO_TPDOCU;
                                        var tempAMT = tempitemH.AMT_SUPPLY;
                                        //사원코드,거래처코드,날짜,금액,키값명칭,키값
                                        getAutoMngd(tempemp, temppartner, tempdt, tempAMT, "NO_TPDOCU", tempNO_TPDOCU, fnObj.gridDetailLeft, index);
                                    },
                                    /*disabled: function () {
                                        var CD_DOCU = fnObj.gridHeader.target.getList()[actionRowIdx].CD_DOCU;
                                        if (nvl(CD_DOCU) == '') {
                                            return true;
                                        } else {
                                            return false;
                                        }
                                    }*/
                                },
                            },
                            {
                                key: "NM_ACCT",
                                label: "계정명",
                                width: 150,
                                align: "left",
                                editor: false,
                                styleClass: function () {
                                    return "readonly";
                                }
                            },
                            {
                                key: "AMT",
                                label: "<span style=\"color:red;\"> * </span>금액",
                                width: 100,
                                align: "right",
                                editor: {type: "number"},
                                formatter: function(){
                                    if (nvl(this.item.AMT) == ''){
                                        this.item.AMT = 0;
                                    }
                                    this.item.AMT = Number(this.item.AMT);
                                    return comma(this.item.AMT);
                                }
                            },
                            {
                                key: "YN_VAT", label: "부가세여부", width: 70, align: "center", editor: false,
                                styleClass: function () {
                                    return "readonly";
                                },
                            },
                            {key: "REMARK", label: "계정별적요", width: 150, align: "left", editor: {type: "text"}},
                            {key: "CD_MNGD", label: "관리항목", width: 150, align: "left", editor: false},
                            {
                                key: "TP_EVIDENCE", label: "증빙", width: 150, align: "left", hidden: true,
                                formatter: function () {
                                    return $.changeTextValue(data_TP_EVIDENCE, this.value);
                                }
                                , editor: {
                                    type: "select", config: {
                                        columnKeys: {
                                            optionValue: "CODE", optionText: "TEXT"
                                        },
                                        options: data_TP_EVIDENCE

                                    }
                                }
                            },
                            {
                                key: "CD_BUDGET",
                                label: "h_예산단위코드",
                                width: 150,
                                align: "right",
                                editor: false,
                                hidden: true
                            },
                            {
                                key: "NM_BUDGET", label: "예산단위", width: 150, align: "left", editor: {type: "text"},
                                picker: {
                                    top: _pop_top,
                                    width: 600,
                                    height: _pop_height,
                                    url: "budget",
                                    action: ["commonHelp", "HELP_BUDGET"],
                                    callback: function (e) {
                                        fnObj.gridDetailLeft.target.setValue(fnObj.gridDetailLeft.getData("selected")[0].__index, "CD_BUDGET", e[0].CD_BUDGET);
                                        fnObj.gridDetailLeft.target.setValue(fnObj.gridDetailLeft.getData("selected")[0].__index, "NM_BUDGET", e[0].NM_BUDGET);
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
                                            CD_ACCT: fnObj.gridDetailLeft.target.getList()[actionRowIdxL].CD_ACCT,
                                            CD_BUDGET: fnObj.gridDetailLeft.target.getList()[actionRowIdxL].CD_BUDGET,
                                        };
                                    },
                                    callback: function (e) {
                                        fnObj.gridDetailLeft.target.setValue(fnObj.gridDetailLeft.getData("selected")[0].__index, "CD_BGACCT", e[0].CD_BGACCT);
                                        fnObj.gridDetailLeft.target.setValue(fnObj.gridDetailLeft.getData("selected")[0].__index, "NM_BGACCT", e[0].NM_BGACCT);
                                    }
                                }
                            },
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
                            {key: "NO_TAX", label: "부가세 키", editor: false, hidden: true},

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
                        footSum: [
                            [
                                {label: "합 계", colspan: 4, align: "center"},
                                {key: "AMT", collector: "sum", formatter: "money", align: "right"},
                            ]
                        ],
                        body: {
                            onClick: function () {
                                actionRowIdxL = this.dindex;
                                var data = this.item;
                                fnObj.gridDetailLeft.target.select(this.dindex);
                                if (this.column.key == "CD_MNGD") {
                                    //관리항목팝업
                                    var CD_ACCT = fnObj.gridDetailLeft.target.getList()[actionRowIdxL].CD_ACCT;
                                    var TP_DRCR = fnObj.gridDetailLeft.target.getList()[actionRowIdxL].TP_DRCR;
                                    var NO_TPDOCU = fnObj.gridDetailLeft.target.getList()[actionRowIdxL].NO_TPDOCU;

                                    var cdDocu = "";
                                    for (var i = 0; i < fnObj.gridHeader.target.getList().length; i++) {
                                        if (fnObj.gridHeader.target.getList()[i].NO_TPDOCU == NO_TPDOCU) {
                                            cdDocu = fnObj.gridHeader.target.getList()[i].CD_DOCU;
                                            break;
                                        }
                                    }

                                    if (!cdDocu) {
                                        qray.alert("상단의 전표유형을 선택하여 주십시오.");
                                        return;
                                    }

                                    if (!CD_ACCT) {
                                        qray.alert("계정코드를 선택하여 주십시오.");
                                        return;
                                    }

                                    if (!TP_DRCR) {
                                        qray.alert("차대구분값이 없습니다.");
                                        return;
                                    }

                                    openMngd(CD_ACCT, TP_DRCR, cdDocu, this.item);
                                }
                                if (this.column.key == "AMT") {
                                    var CD_ACCT = fnObj.gridDetailLeft.target.getList()[this.dindex].CD_ACCT;
                                    var NM_ACCT = fnObj.gridDetailLeft.target.getList()[this.dindex].NM_ACCT;
                                    var NO_TPDOCU = fnObj.gridDetailLeft.target.getList()[this.dindex].NO_TPDOCU;
                                    var TP_DRCR = fnObj.gridDetailLeft.target.getList()[this.dindex].TP_DRCR;
                                    var NO_TAX = fnObj.gridDetailLeft.target.getList()[this.dindex].NO_TAX;

                                    if (tax_code_dr.indexOf(CD_ACCT) > -1) {     //  차변 부가세계정
                                        var templist = fnObj.gridDetailLeft.target.getList();
                                        var tempNM_ACCT = "";
                                        for (var i = 0; i < templist.length; i++) {
                                            if (templist[i].NO_TPDOCU == NO_TPDOCU && templist[i].CD_ACCT != CD_ACCT) {
                                                tempNM_ACCT = templist[i].NM_ACCT;
                                            }
                                        }

                                        var listH = fnObj.gridHeader.target.getList();
                                        var i = listH.length;
                                        var item;
                                        while (i--) {
                                            if (listH[i].NO_TPDOCU == NO_TPDOCU) {
                                                console.log(listH[i]);
                                                item = listH[i];
                                                break;
                                            }
                                        }
                                        var initData = {
                                            AMT: item.AMT_SUPPLY,
                                            VAT: item.AMT_VAT,
                                            CD_PARTNER: item.CD_PARTNER,
                                            LN_PARTNER: item.LN_PARTNER,
                                            CD_DOCU: item.CD_DOCU,
                                            SEQ: this.dindex,
                                            TPDRCR: TP_DRCR,
                                            index: this.dindex,
                                            NO_TAX: NO_TAX,
                                            NM_ITEM: tempNM_ACCT,
                                            DT_TAX: nvl($("#dtAcct").val()).replace(/-/gi, ""),//item.DT_TRANS
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

                                                    if (nvl(data.CD_ACCT) != '' && nvl(data.CD_BUDGET) != '' && nvl(data.CD_BGACCT) != '' ){
                                                        BudgetControl(fnObj.gridDetailLeft, data);    //  예산계정
                                                    }

                                                }
                                            }
                                        }, function () {

                                        });
                                    } else if (tax_code_recept.indexOf(CD_ACCT) > -1) {  //  차변 접대비계정
                                        var listH = fnObj.gridHeader.target.getList();
                                        var i = listH.length;
                                        var item;
                                        while (i--) {
                                            if (listH[i].NO_TPDOCU == NO_TPDOCU) {
                                                console.log(listH[i]);
                                                item = listH[i];
                                                break;
                                            }
                                        }
                                        var initData = {
                                            CD_ACCT: CD_ACCT,
                                            NM_ACCT: NM_ACCT,
                                            TPDRCR: TP_DRCR,
                                            AMT: item.AMT_SUM,
                                            index: this.dindex,
                                            ADDPARAM: NO_TAX,
                                            GUBUN: '2',
                                            AC_GROUP_NUMBER : item.GROUP_NUMBER,
                                            AC_NO_TPDOCU : item.NO_TPDOCU,
                                            AC_GB : item.GB,
                                            AC_SEQ : item.SEQ,

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

                                                    if (nvl(data.CD_ACCT) != '' && nvl(data.CD_BUDGET) != '' && nvl(data.CD_BGACCT) != '' ){
                                                        BudgetControl(fnObj.gridDetailLeft, data);    //  예산계정
                                                    }

                                                }
                                            }
                                        }, function () {

                                        });
                                    }else{
                                        if (nvl(data.CD_ACCT) != '' && nvl(data.CD_BUDGET) != '' && nvl(data.CD_BGACCT) != '' ){
                                            BudgetControl(fnObj.gridDetailLeft, data);    //  예산계정
                                        }
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

                                /*this.self.focus(this.dindex);*/
                            },
                            onDBLClick: function(){
                                actionRowIdxL = this.dindex;
                            },
                            onDataChanged: function () {
                                var index = this.dindex;
                                if (this.key == 'NO_TAX') {
                                    if (tax_code_dr.indexOf(this.item.CD_ACCT) > -1) {
                                        if (nvl(this.value) != '') {
                                            fnObj.gridDetailLeft.target.setValue(this.dindex, 'YN_VAT', "Y");
                                        }
                                    }
                                }
                                if (this.key == "AMT") {
                                    calc()
                                }
                                if (this.key == 'CD_ACCT') { // 차변 계정변경시 DR
                                    if (nvl(this.value) == ''){
                                        fnObj.gridDetailLeft.target.setValue(this.dindex, "NM_ACCT", '');
                                    }
                                    fnObj.gridDetailLeft.target.setValue(this.dindex, "REMARK", '');
                                    fnObj.gridDetailLeft.target.setValue(this.dindex, "NO_TAX", '');
                                    fnObj.gridDetailLeft.target.setValue(this.dindex, "NM_BGACCT", '');
                                    fnObj.gridDetailLeft.target.setValue(this.dindex, "CD_BGACCT", '');
                                    fnObj.gridDetailLeft.target.setValue(this.dindex, "OVER_AMT", '');
                                    fnObj.gridDetailLeft.target.setValue(this.dindex, "TP_EVIDENCE", '');
                                    fnObj.gridDetailLeft.target.setValue(this.dindex, "NO_TAX", '');
                                    fnObj.gridDetailLeft.target.setValue(this.dindex, "cd_bizcar", '');
                                    fnObj.gridDetailLeft.target.setValue(this.dindex, "nm_bizcar", '');
                                    fnObj.gridDetailLeft.target.setValue(this.dindex, "TEMP_VAT", '');
                                    fnObj.gridDetailLeft.target.setValue(this.dindex, "GB_TAX", '');
                                    fnObj.gridDetailLeft.target.setValue(this.dindex, "AMOUNT_SUPPLY", '');
                                    fnObj.gridDetailLeft.target.setValue(this.dindex, "AM_SUPPLY", '');
                                    fnObj.gridDetailLeft.target.setValue(this.dindex, "TEMP_RECEPT", '');
                                }

                                /*//예산통제 팝업
                                if (this.key == 'AMT' || this.key == 'CD_ACCT') {
                                    BudgetControl(fnObj.gridDetailLeft, this.item);    //  예산계정
                                }*/

                            }
                        },
                        onPageChange: function (pageNumber) {
                            _this.setPageData({pageNumber: pageNumber});
                            //ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
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
                    this.target.addRow({__created__: true, AMT: 0, GB: '1'}, "last");

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
                        showLineNumber : false,
                        frozenColumnIndex: 0,
                        target: $('[data-ax5grid="grid-detail-right"]'),
                        virtualScrollX: true,
                        columns: [
                            {
                                key: "CHK", label: "", width: 40, align: "center", dirty:false,
                                label:
                                    '<div id="right_headerBox" data-ax5grid-editor="checkbox" data-ax5grid-checked="false" data-ax5grid-column-selected="true" style="height:17px;width:17px;margin-top:2px;  onclick="javascript:alert(1);"></div>',
                                editor: {
                                    type: "checkbox", config: {height: 17, trueValue: "Y", falseValue: "N"}
                                }
                            },
                            {
                                key: "NO_LINE",
                                label: "순번",
                                width: 50,
                                align: "center",
                                editor: false,
                                hidden: false,
                                sortable : true,
                                styleClass: function () {
                                    return "readonly";
                                }
                            },
                            {
                                key: "SEQ",
                                label: "순번",
                                width: 40,
                                align: "left",
                                editor: false,
                                hidden: true,
                                styleClass: function () {
                                    return "readonly";
                                }
                            },
                            {
                                key: "GB", label: "h_차대구분", width: 150, align: "center", formatter: function () {
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
                                key: "TP_DRCR", label: "h_차대구분", width: 150, align: "center", formatter: function () {
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
                                key: "NO_TPDOCU",
                                label: "h_고유번호NO_TPDOCU",
                                width: 200,
                                align: "left",
                                editor: false,
                                hidden: true
                            },
                            {
                                key: "CD_ACCT",
                                label: "<span style=\"color:red;\"> * </span>계정코드",
                                width: 80,
                                align: "center",
                                editor: {
                                    type: "text",
                                    /*disabled: function () {
                                        var NO_TPDOCU = fnObj.gridDetailLeft.target.getList()[actionRowIdxL].NO_TPDOCU;
                                        var listH = fnObj.gridHeader.target.getList();
                                        var i = listH.length;
                                        var item;
                                        while (i--) {
                                            if (listH[i].NO_TPDOCU == NO_TPDOCU) {
                                                console.log(listH[i]);
                                                item = listH[i];
                                                break;
                                            }
                                        }
                                        if (nvl(item.CD_DOCU) == '') {
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
                                    url: "acct",
                                    action: ["commonHelp", "HELP_ACCT"],
                                    param: function () {
                                        var NO_TPDOCU = fnObj.gridDetailRight.target.getList()[actionRowIdxR].NO_TPDOCU;
                                        var listH = fnObj.gridHeader.target.getList();
                                        var i = listH.length;
                                        var item;
                                        while (i--) {
                                            if (listH[i].NO_TPDOCU == NO_TPDOCU) {
                                                console.log(listH[i]);
                                                item = listH[i];
                                                break;
                                            }
                                        }
                                        if (item.CD_DOCU == '004' || item.CD_DOCU == '008' || item.CD_DOCU == '009') {   //  전표유형이 기타,반제일 때는 차대구분 없이 모든 계정을 조회한다.
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
                                        var index = this.dindex;
                                        fnObj.gridDetailRight.target.setValue(this.dindex, "CD_ACCT", e[0].CD_ACCT);
                                        fnObj.gridDetailRight.target.setValue(this.dindex, "NM_ACCT", e[0].NM_ACCT);

                                        var data = $.DATA_SEARCH('apbucard', 'bgacctSetting', {
                                            CD_ACCT: e[0].CD_ACCT,
                                            CD_BUDGET: this.item.CD_BUDGET
                                        });
                                        if (data.list.length > 0) {
                                            fnObj.gridDetailRight.target.setValue(this.dindex, "NM_BGACCT", data.list[0].NM_BGACCT);
                                            fnObj.gridDetailRight.target.setValue(this.dindex, "CD_BGACCT", data.list[0].CD_BGACCT);
                                        } else {
                                            fnObj.gridDetailRight.target.setValue(this.dindex, "NM_BGACCT", '');
                                            fnObj.gridDetailRight.target.setValue(this.dindex, "CD_BGACCT", '');
                                        }
                                        setStMngd(this.item.CD_ACCT, "2", this.dindex);
                                        clearMngd("2", this.dindex);

                                        //자동으로 들어갈수있는 관리항목들은 자동으로 들어가게 세팅
                                        var listH = fnObj.gridHeader.target.getList();
                                        var i = listH.length;
                                        var tempitemH;
                                        while (i--) {
                                            if (listH[i].NO_TPDOCU == this.item.NO_TPDOCU) {
                                                console.log(listH[i]);
                                                tempitemH = listH[i];
                                                break;
                                            }
                                        }
                                        var tempemp = SCRIPT_SESSION.noEmp;
                                        var temppartner = tempitemH.CD_PARTNER;
                                        var tempdt = tempitemH.DT_TRANS;
                                        var tempNO_TPDOCU = tempitemH.NO_TPDOCU;
                                        var tempAMT = tempitemH.AMT_SUPPLY;
                                        //사원코드,거래처코드,날짜,금액,키값명칭,키값
                                        getAutoMngd(tempemp, temppartner, tempdt, tempAMT, "NO_TPDOCU", tempNO_TPDOCU, fnObj.gridDetailRight, index);
                                    }
                                },
                            },
                            {
                                key: "NM_ACCT",
                                label: "계정명",
                                width: 150,
                                align: "left",
                                editor: false,
                                styleClass: function () {
                                    return "readonly";
                                }
                            },
                            {
                                key: "AMT",
                                label: "<span style=\"color:red;\"> * </span>금액",
                                width: 100,
                                align: "right",
                                editor: {type: "number"},
                                formatter: function() {
                                    if (nvl(this.item.AMT) == '') {
                                        this.item.AMT = 0;
                                    }
                                    this.item.AMT = Number(this.item.AMT);
                                    return comma(this.item.AMT);
                                }
                            },
                            {
                                key: "YN_VAT", label: "부가세여부", width: 70, align: "center", editor: false,
                                styleClass: function () {
                                    return "readonly";
                                },
                            },
                            {key: "REMARK", label: "계정별적요", width: 150, align: "left", editor: {type: "text"}},
                            {key: "CD_MNGD", label: "관리항목", width: 150, align: "left", editor: false},

                            {
                                key: "TP_EVIDENCE", label: "증빙", width: 150, align: "left", hidden: true,
                                formatter: function () {
                                    return $.changeTextValue(data_TP_EVIDENCE, this.value);
                                }
                                , editor: {
                                    type: "select", config: {
                                        columnKeys: {
                                            optionValue: "CODE", optionText: "TEXT"
                                        },
                                        options: data_TP_EVIDENCE

                                    }
                                }
                            },
                            {
                                key: "CD_BUDGET",
                                label: "h_예산단위",
                                width: 150,
                                align: "left",
                                editor: false,
                                hidden: true
                            },
                            {
                                key: "NM_BUDGET", label: "예산단위", width: 150, align: "left", editor: {type: "text"},
                                picker: {
                                    top: _pop_top,
                                    width: 600,
                                    height: _pop_height,
                                    url: "budget",
                                    action: ["commonHelp", "HELP_BUDGET"],
                                    callback: function (e) {
                                        fnObj.gridDetailRight.target.setValue(fnObj.gridDetailRight.getData("selected")[0].__index, "CD_BUDGET", e[0].CD_BUDGET);
                                        fnObj.gridDetailRight.target.setValue(fnObj.gridDetailRight.getData("selected")[0].__index, "NM_BUDGET", e[0].NM_BUDGET);
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
                                            CD_ACCT: fnObj.gridDetailRight.target.getList()[actionRowIdxR].CD_ACCT,
                                            CD_BUDGET: fnObj.gridDetailLeft.target.getList()[actionRowIdxL].CD_BUDGET,
                                        };
                                    },
                                    callback: function (e) {
                                        fnObj.gridDetailRight.target.setValue(fnObj.gridDetailRight.getData("selected")[0].__index, "CD_BGACCT", e[0].CD_BGACCT);
                                        fnObj.gridDetailRight.target.setValue(fnObj.gridDetailRight.getData("selected")[0].__index, "NM_BGACCT", e[0].NM_BGACCT);
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
                            {key: "NO_TAX", label: "h_NO_TAX", editor: false, hidden: true},

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
                        footSum: [
                            [
                                {label: "합 계", colspan: 4, align: "center"},
                                {key: "AMT", collector: "sum", formatter: "money", align: "right"},
                            ]
                        ],
                        body: {
                            onClick: function () {
                                actionRowIdxR = this.dindex;
                                fnObj.gridDetailRight.target.select(this.dindex);
                                var data = this.item;
                                if (this.column.key == "CD_MNGD") {
                                    var CD_ACCT = fnObj.gridDetailRight.target.getList()[actionRowIdxR].CD_ACCT;
                                    var TP_DRCR = fnObj.gridDetailRight.target.getList()[actionRowIdxR].TP_DRCR;
                                    var NO_TPDOCU = fnObj.gridDetailRight.target.getList()[actionRowIdxR].NO_TPDOCU;

                                    var cdDocu = "";
                                    for (var i = 0; i < fnObj.gridHeader.target.getList().length; i++) {
                                        if (fnObj.gridHeader.target.getList()[i].NO_TPDOCU == NO_TPDOCU) {
                                            cdDocu = fnObj.gridHeader.target.getList()[i].CD_DOCU;
                                            break;
                                        }
                                    }

                                    openMngd(CD_ACCT, TP_DRCR, cdDocu, this.item);
                                }
                                if (this.column.key == "AMT") {
                                    //var CD_ACCT = fnObj.gridDetailRight.target.getList()[this.dindex].CD_ACCT;
                                    //var NO_TPDOCU = fnObj.gridDetailRight.target.getList()[this.dindex].NO_TPDOCU;

                                    var CD_ACCT = fnObj.gridDetailRight.target.getList()[this.dindex].CD_ACCT;
                                    var NM_ACCT = fnObj.gridDetailRight.target.getList()[this.dindex].NM_ACCT;
                                    var NO_TPDOCU = fnObj.gridDetailRight.target.getList()[this.dindex].NO_TPDOCU;
                                    var TP_DRCR = fnObj.gridDetailRight.target.getList()[this.dindex].TP_DRCR;
                                    var NO_TAX = fnObj.gridDetailRight.target.getList()[this.dindex].NO_TAX;

                                    if (tax_code_cr.indexOf(CD_ACCT) > -1) {
                                        var templist = fnObj.gridDetailRight.target.getList();
                                        var tempNM_ACCT = "";
                                        for (var i = 0; i < templist.length; i++) {
                                            if (templist[i].NO_TPDOCU == NO_TPDOCU && templist[i].CD_ACCT != CD_ACCT) {
                                                tempNM_ACCT = templist[i].NM_ACCT;
                                            }
                                        }

                                        var listH = fnObj.gridHeader.target.getList();
                                        var i = listH.length;
                                        var item;
                                        while (i--) {
                                            if (listH[i].NO_TPDOCU == NO_TPDOCU) {
                                                console.log(listH[i]);
                                                item = listH[i];
                                                break;
                                            }
                                        }

                                        var initData = {
                                            AMT: item.AMT_SUPPLY,
                                            VAT: item.AMT_VAT,
                                            CD_PARTNER: item.CD_PARTNER,
                                            LN_PARTNER: item.LN_PARTNER,
                                            CD_DOCU: item.CD_DOCU,
                                            CD_RELATION: 31,
                                            SEQ: this.dindex,
                                            TPDRCR: TP_DRCR,
                                            index: this.dindex,
                                            NO_TAX: NO_TAX,
                                            NM_ITEM: tempNM_ACCT,
                                            DT_TAX: nvl($("#dtAcct").val()).replace(/-/gi, ""),//item.DT_TRANS
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
                                                    if (nvl(data.CD_ACCT) != '' && nvl(data.CD_BUDGET) != '' && nvl(data.CD_BGACCT) != '' ){
                                                        BudgetControl(fnObj.gridDetailRight, data);    //  예산계정
                                                    }

                                                }
                                            }
                                        }, function () {

                                        });
                                    } else if (tax_code_recept.indexOf(CD_ACCT) > -1) {
                                        var listH = fnObj.gridHeader.target.getList();
                                        var i = listH.length;
                                        var item;
                                        while (i--) {
                                            if (listH[i].NO_TPDOCU == NO_TPDOCU) {
                                                console.log(listH[i]);
                                                item = listH[i];
                                                break;
                                            }
                                        }
                                        var initData = {
                                            CD_ACCT: CD_ACCT,
                                            NM_ACCT: NM_ACCT,
                                            TPDRCR: TP_DRCR,
                                            AMT: item.AMT_SUM,
                                            index: this.dindex,
                                            ADDPARAM: NO_TAX,
                                            GUBUN: '2',
                                            AC_GROUP_NUMBER : item.GROUP_NUMBER,
                                            AC_NO_TPDOCU : item.NO_TPDOCU,
                                            AC_GB : item.GB,
                                            AC_SEQ : item.SEQ,
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

                                                    if (nvl(data.CD_ACCT) != '' && nvl(data.CD_BUDGET) != '' && nvl(data.CD_BGACCT) != '' ){
                                                        BudgetControl(fnObj.gridDetailRight, data);    //  예산계정
                                                    }

                                                }
                                            }
                                        }, function () {

                                        });
                                    }else{
                                        if (nvl(data.CD_ACCT) != '' && nvl(data.CD_BUDGET) != '' && nvl(data.CD_BGACCT) != '' ){
                                            BudgetControl(fnObj.gridDetailRight, data);    //  예산계정
                                        }
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
                                /*this.self.focus(this.dindex);*/
                            },
                            onDBLClick: function () {
                                actionRowIdxR = this.dindex;

                            },
                            onDataChanged: function () {
                                var index = this.dindex;
                                if (this.key == 'NO_TAX') {
                                    if (tax_code_cr.indexOf(this.item.CD_ACCT) > -1) {
                                        if (nvl(this.value) != '') {
                                            fnObj.gridDetailRight.target.setValue(this.dindex, 'YN_VAT', "Y");
                                        }
                                    }
                                }
                                if (this.key == "AMT") {
                                    calc()
                                }
                                if (this.key == 'CD_ACCT') { // 대변 계정변경시 CR
                                    if (nvl(this.value) == ''){
                                        fnObj.gridDetailRight.target.setValue(this.dindex, "NM_ACCT", '');
                                    }
                                    fnObj.gridDetailRight.target.setValue(this.dindex, "REMARK", '');
                                    fnObj.gridDetailRight.target.setValue(this.dindex, "NO_TAX", '');
                                    fnObj.gridDetailRight.target.setValue(this.dindex, "NM_BGACCT", '');
                                    fnObj.gridDetailRight.target.setValue(this.dindex, "CD_BGACCT", '');
                                    fnObj.gridDetailRight.target.setValue(this.dindex, "OVER_AMT", '');
                                    fnObj.gridDetailRight.target.setValue(this.dindex, "TP_EVIDENCE", '');
                                    fnObj.gridDetailRight.target.setValue(this.dindex, "NO_TAX", '');
                                    fnObj.gridDetailRight.target.setValue(this.dindex, "cd_bizcar", '');
                                    fnObj.gridDetailRight.target.setValue(this.dindex, "nm_bizcar", '');
                                    fnObj.gridDetailRight.target.setValue(this.dindex, "TEMP_VAT", '');
                                    fnObj.gridDetailRight.target.setValue(this.dindex, "GB_TAX", '');
                                    fnObj.gridDetailRight.target.setValue(this.dindex, "AMOUNT_SUPPLY", '');
                                    fnObj.gridDetailRight.target.setValue(this.dindex, "AM_SUPPLY", '');
                                    fnObj.gridDetailRight.target.setValue(this.dindex, "TEMP_RECEPT", '');
                                }

                                /*//예산통제 팝업
                                if (this.item.CD_BGACCT && this.item.CD_BUDGET && this.item.CD_ACCT) {
                                    if (this.key == 'AMT' || this.key == 'CD_ACCT') {
                                        BudgetControl(fnObj.gridDetailRight);
                                    }
                                }*/
                            }
                        },
                        onPageChange: function (pageNumber) {

                            _this.setPageData({pageNumber: pageNumber});
                            //ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
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
                    this.target.addRow({__created__: true, AMT: 0, GB: '2'}, "last");
                },
                lastRow: function () {
                    return ($("div [data-ax5grid='grid-detail-right']").find("div [data-ax5grid-panel='body'] table tr").length)
                },
                getSelectRow: function () {
                    return actionRowIdxR;
                }
            });

            //관리항목 팝업
            var openMngd = function (CD_ACCT, TP_DRCR, cdDocu, INITDATA) {
                userCallBack = function (e) {
                    if (e.length > 0) {
                        var grid;
                        if (TP_DRCR == "2") {
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
                        grid.target.setValue(row, "CD_MNGD", mngd);
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
                        param: "callBack=userCallBack&cdAcct=" + CD_ACCT + "&tpDrCr=" + TP_DRCR.substr(0, 1) + "&cdDocu=" + cdDocu
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

            fnObj.searchView = axboot.viewExtend(axboot.searchView, {
                initView: function () {
                    this.target = $(document["searchView0"]);
                    this.target.attr("onsubmit", "return ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);");
                },
                getData: function () {
                    return {
                        CD_DOCU : $("select[name='cdDocu']").val(),
                        CD_DEPT : $("#CD_DEPT").getCodes(),
                        CD_EMP : $("#CD_EMP").getCodes()
                        /*CD_DEPT : $("#cdDept").attr('code'),
                        CD_EMP : nvl($("#cdEmp").attr('code')),*/
                    }
                }
            });

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
                var AMTL = gridValueSum(fnObj.gridDetailLeft, "AMT");
                var AMTR = gridValueSum(fnObj.gridDetailRight, "AMT");
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
                    fnObj.gridDetailLeft.target.setValue(map.get("index"), "NO_TAX", map.get("ADDPARAM"));

                    for (var i = 1; i <= 8; i++) {
                        if (fnObj.gridDetailLeft.target.getList()[map.get("index")]["CD_MNG" + i] == "C14") {
                            fnObj.gridDetailLeft.target.setValue(map.get("index"), "CD_MNGD" + i, map.get("GB_TAX"));
                            fnObj.gridDetailLeft.target.setValue(map.get("index"), "NM_MNGD" + i, map.get("NM_GB_TAX"));
                        }
                        mngd += nvl(fnObj.gridDetailLeft.target.getList()[map.get("index")]["NM_MNGD" + i], '');
                        if (i != 8) mngd += "*";
                    }
                    fnObj.gridDetailLeft.target.setValue(map.get("index"), "CD_MNGD", mngd);
                } else {
                    fnObj.gridDetailRight.target.setValue(map.get("index"), "NO_TAX", map.get("ADDPARAM"));

                    for (var i = 1; i <= 8; i++) {
                        if (fnObj.gridDetailRight.target.getList()[map.get("index")]["CD_MNG" + i] == "C14") {
                            fnObj.gridDetailRight.target.setValue(map.get("index"), "CD_MNGD" + i, map.get("GB_TAX"));
                            fnObj.gridDetailRight.target.setValue(map.get("index"), "NM_MNGD" + i, map.get("NM_GB_TAX"));
                        }
                        mngd += nvl(fnObj.gridDetailRight.target.getList()[map.get("index")]["NM_MNGD" + i], '');
                        if (i != 8) mngd += "*";
                    }
                    fnObj.gridDetailRight.target.setValue(map.get("index"), "CD_MNGD", mngd);
                }

            }

            function vatCallBack(map) {
                var mngd = "";
                if (map.get("TPDRCR") == "1") {
                    fnObj.gridDetailLeft.target.setValue(map.get("index"), "NO_TAX", map.get("ADDPARAM"));
                    fnObj.gridDetailLeft.target.setValue(map.get("index"), "AMT", map.get("AMT"));
                    /*for (var i = 0; i < fnObj.gridHeader.target.list.length; i++) {
                        if (fnObj.gridDetailLeft.target.list[map.get("index")].NO_TPDOCU == fnObj.gridHeader.target.list[i].NO_TPDOCU) {
                            fnObj.gridHeader.target.setValue(i, "CD_PARTNER", map.get("CD_PARTNER"));
                            fnObj.gridHeader.target.setValue(i, "LN_PARTNER", map.get("LN_PARTNER"));
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
                    fnObj.gridDetailLeft.target.setValue(map.get("index"), "CD_MNGD", mngd);
                } else {
                    fnObj.gridDetailRight.target.setValue(map.get("index"), "NO_TAX", map.get("ADDPARAM"));
                    fnObj.gridDetailRight.target.setValue(map.get("index"), "AMT", map.get("AMT"));
                    /*for (var i = 0; i < fnObj.gridHeader.target.list.length; i++) {
                        if (fnObj.gridDetailRight.target.list[map.get("index")].NO_TPDOCU == fnObj.gridHeader.target.list[i].NO_TPDOCU) {
                            fnObj.gridHeader.target.setValue(i, "CD_PARTNER", map.get("CD_PARTNER"));
                            fnObj.gridHeader.target.setValue(i, "LN_PARTNER", map.get("LN_PARTNER"));
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
                    fnObj.gridDetailRight.target.setValue(map.get("index"), "CD_MNGD", mngd);
                }

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
                if (item.CD_BGACCT && item.CD_BUDGET && item.CD_ACCT) {
                    var list = grid.target.list;

                    var temp_AMT_tot = 0;
                    for (var i = 0; i < list.length; i++) {
                        if (list[i].CD_BUDGET == item.CD_BUDGET && list[i].CD_BGACCT == item.CD_BGACCT)
                            temp_AMT_tot += parseInt(uncomma(list[i].AMT));
                    }

                    var result = [];
                    axboot.ajax({
                        type: "POST",
                        url: ["apbucard", "acctBudgetAmt"],
                        async: false,
                        data: JSON.stringify({
                            CD_BGACCT: item.CD_BGACCT,
                            CD_BUDGET: item.CD_BUDGET,
                            DT_ACCT: $("#dtAcct").val().replace(/-/g, ""),
                            APPLY_AMT: temp_AMT_tot
                        }),
                        callback: function (res) {
                            result = res;
                            /*grid.target.setValue(item.__index, "AMT0", result.list[0].AMT0);
                            grid.target.setValue(item.__index, "AMT1", result.list[0].AMT1);*/
                            console.log("예산통제 팝업으로 보내는 데이터 : ", result);

                            var data = {
                                CD_BGACCT: item.CD_BGACCT,
                                CD_BUDGET: item.CD_BUDGET,
                                CD_ACCT: item.CD_ACCT,
                                AMT0: result.list[0].AMT0, //실행
                                AMT1: result.list[0].AMT1, //집행
                                AMT2: result.list[0].AMT2, //잔여
                                APPLY_AMT: temp_AMT_tot,       //신청
                                OVER_AMT: result.list[0].OVER_AMT //초과
                            };

                            $.openCommonPopup('budgetControl', "", '', '', data, 500, 380, _pop_top380);

                            /*for (var i = 0; i < list.length; i++) {
                                if (list[i].CD_BUDGET == item.CD_BUDGET && list[i].CD_BGACCT == item.CD_BGACCT) {
                                    if (result && result.list && result.list[i] && result.list[i].CONTROL_YN && result.list[i].CONTROL_YN == "Y") {
                                        grid.target.setValue(i, "OVER_AMT", result.list[0].OVER_AMT);
                                    }
                                    else{
                                        grid.target.setValue(i, "OVER_AMT", 0);
                                    }
                                }
                            }*/
                        }
                    });

                }
            }

            //관리항목필수여부,계정에 대한 관리항목 그리드에 세팅
            function setStMngd(CD_ACCT, drcr, gridindex) {
                axboot.ajax({
                    async:false,
                    type: "POST",
                    url: ["gldocum", "getMngd"],
                    data: JSON.stringify({
                        CD_ACCT: CD_ACCT
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
                return false;
            }

            //계정변경시 관리항목 클리어
            function clearMngd(drcr, gridindex) {
                if (drcr == "1") { //left차변
                    fnObj.gridDetailLeft.target.setValue(gridindex, "CD_MNGD", "");
                    for (var i = 1; i <= 8; i++) {
                        fnObj.gridDetailLeft.target.setValue(gridindex, "CD_MNGD" + i, "");
                        fnObj.gridDetailLeft.target.setValue(gridindex, "NM_MNGD" + i, "");
                    }
                } else { //right 대변
                    fnObj.gridDetailRight.target.setValue(gridindex, "CD_MNGD", "");
                    for (var i = 1; i <= 8; i++) {
                        fnObj.gridDetailRight.target.setValue(gridindex, "CD_MNGD" + i, "");
                        fnObj.gridDetailRight.target.setValue(gridindex, "NM_MNGD" + i, "");
                    }
                }
            }

            //관리항목자동세팅해줄값가져오기
            //사원코드,거래처코드,날짜,금액,키값명칭,키값
            function getAutoMngd(no_emp, cd_partner, date, AMT, keyvaluename, keyvalue, grid, index) {
                axboot.ajax({
                    type: "POST",
                    url: ["gldocum", "getAutoMngd"],
                    data: JSON.stringify({
                        NO_EMP: no_emp
                        , CD_PARTNER: cd_partner
                        , DATE: date
                        , AMT: AMT
                    }),
                    callback: function (res) {
                        if (nvl(grid) != '' && nvl(index) != ''){
                            var lmngd = "";
                            for (var k = 1; k <= 8; k++) {
                                if (grid.target.list[index]["CD_MNG" + k] == "A01" && grid.target.list[index][keyvaluename] == keyvalue) {
                                    grid.target.list[index]["CD_MNGD" + k] = res.map["A01"];
                                    grid.target.list[index]["NM_MNGD" + k] = res.map["N_A01"];
                                }
                                if (grid.target.list[index]["CD_MNG" + k] == "A02" && grid.target.list[index][keyvaluename] == keyvalue) {
                                    grid.target.list[index]["CD_MNGD" + k] = res.map["A02"];
                                    grid.target.list[index]["NM_MNGD" + k] = res.map["N_A02"];
                                }
                                if (grid.target.list[index]["CD_MNG" + k] == "A03" && grid.target.list[index][keyvaluename] == keyvalue) {
                                    grid.target.list[index]["CD_MNGD" + k] = res.map["A03"];
                                    grid.target.list[index]["NM_MNGD" + k] = res.map["N_A03"];
                                }
                                if (grid.target.list[index]["CD_MNG" + k] == "A04" && grid.target.list[index][keyvaluename] == keyvalue) {
                                    grid.target.list[index]["CD_MNGD" + k] = res.map["A04"];
                                    grid.target.list[index]["NM_MNGD" + k] = res.map["N_A04"];
                                }
                                if (grid.target.list[index]["CD_MNG" + k] == "A05" && grid.target.list[index][keyvaluename] == keyvalue) {
                                    grid.target.list[index]["CD_MNGD" + k] = res.map["A05"];
                                    grid.target.list[index]["NM_MNGD" + k] = res.map["N_A05"];
                                }
                                if (grid.target.list[index]["CD_MNG" + k] == "A06" && grid.target.list[index][keyvaluename] == keyvalue) {
                                    grid.target.list[index]["CD_MNGD" + k] = res.map["A06"];
                                    grid.target.list[index]["NM_MNGD" + k] = res.map["N_A06"];
                                }
                                if (grid.target.list[index]["CD_MNG" + k] == "B21" && grid.target.list[index][keyvaluename] == keyvalue) {
                                    grid.target.list[index]["CD_MNGD" + k] = res.map["B21"];
                                    grid.target.list[index]["NM_MNGD" + k] = res.map["B21"];
                                }
                                if (grid.target.list[index]["CD_MNG" + k] == "B23" && grid.target.list[index][keyvaluename] == keyvalue) {
                                    grid.target.list[index]["CD_MNGD" + k] = res.map["B23"];
                                    grid.target.list[index]["NM_MNGD" + k] = res.map["B23"];
                                }
                                if (grid.target.list[index]["CD_MNG" + k] == "C01" && grid.target.list[index][keyvaluename] == keyvalue) {
                                    grid.target.list[index]["CD_MNGD" + k] = res.map["C01"];
                                    grid.target.list[index]["NM_MNGD" + k] = res.map["C01"];
                                }
                                if (grid.target.list[index]["CD_MNG" + k] == "C05" && grid.target.list[index][keyvaluename] == keyvalue) {
                                    grid.target.list[index]["CD_MNGD" + k] = res.map["C05"];
                                    grid.target.list[index]["NM_MNGD" + k] = res.map["C05"];
                                }
                                if (grid.target.list[index]["CD_MNG" + k] == "C12" && grid.target.list[index][keyvaluename] == keyvalue) {
                                    grid.target.list[index]["CD_MNGD" + k] = res.map["C12"];
                                    grid.target.list[index]["NM_MNGD" + k] = res.map["C12"];
                                }
                                if (grid.target.list[index]["CD_MNG" + k] == "C15" && grid.target.list[index][keyvaluename] == keyvalue) {
                                    grid.target.list[index]["CD_MNGD" + k] = res.map["C15"];
                                    grid.target.list[index]["NM_MNGD" + k] = res.map["N_C15"];
                                }
                                if (grid.target.list[index]["CD_MNG" + k] == "C16" && grid.target.list[index][keyvaluename] == keyvalue) {
                                    grid.target.list[index]["CD_MNGD" + k] = res.map["C16"];
                                    grid.target.list[index]["NM_MNGD" + k] = res.map["C16"];
                                }
                                lmngd += nvl(grid.target.list[index]["NM_MNGD" + k], '');
                                if (k != 8) lmngd += "*";
                            }
                            grid.target.setValue(index, 'CD_MNGD', lmngd);
                        }else {
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
                                fnObj.gridDetailLeft.target.setValue(i, 'CD_MNGD', lmngd);
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
                                fnObj.gridDetailRight.target.setValue(i, "CD_MNGD", rmngd);
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
                            C05 과세표준액 AMT?
                            C12 수금일자 날짜
                            C14 세무구분?
                            C15 거래처계좌번호
                            */
                        }
                    }
                });
            }

            function setAMTline(model){

                var gridleft = fnObj.gridDetailLeft.target;
                var gridright = fnObj.gridDetailRight.target;
                var t_rowDatasleft = fnObj.gridDetailLeft.target.list;
                var t_rowDatasright = fnObj.gridDetailRight.target.list;

                if (t_rowDatasleft.length > 0){

                    var DrCnt = 0; // 차변계정
                    var CrCnt = 0; // 대변계정
                    var DrTaxCnt = 0;	//	차변부가세계정
                    var CrTaxCnt = 0;	//	대변부가세계정
                    var DifferenceNoTaxAMT = 0; //
                    var DifferenceTaxAMT = 0; //
                    var NoTaxChkVal = false;
                    var TaxChkVal = false;


                    for(var i =0;i<t_rowDatasleft.length;i++){

                        if (model.NO_TPDOCU == t_rowDatasleft[i].NO_TPDOCU ) {
                            if (tax_acct.indexOf(t_rowDatasleft[i].CD_ACCT) > -1){
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
                        DifferenceNoTaxAMT =  Number(AMT) - (Math.floor(Number((AMT) / DrCnt)) * DrCnt);
                        NoTaxChkVal = true;
                    }
                    if ((Math.floor(VAT / DrTaxCnt)) * DrTaxCnt != VAT){	// 차변부가세계정 갯 수만큼	나눈 후 절사했을 때 총합 금액이 같지않는다면
                        DifferenceTaxAMT =  Number(VAT) - (Math.floor(Number((VAT) / DrTaxCnt)) * DrTaxCnt);
                        TaxChkVal = true;
                    }

                    for(var i =0;i<t_rowDatasleft.length;i++){

                        if (model.NO_TPDOCU == t_rowDatasleft[i].NO_TPDOCU ) {
                            if (tax_acct.indexOf(t_rowDatasleft[i].CD_ACCT) > -1){
                                if(TaxChkVal){
                                    gridleft.setValue(i, 'AMT', Math.floor(VAT / DrTaxCnt) + DifferenceTaxAMT);
                                    TaxChkVal = false;
                                }else{
                                    gridleft.setValue(i, 'AMT', Math.floor(VAT / DrTaxCnt));
                                }
                            }else{
                                if(NoTaxChkVal){
                                    gridleft.setValue(i, 'AMT', Math.floor(AMT / DrCnt) + DifferenceNoTaxAMT);
                                    NoTaxChkVal = false;
                                }else{
                                    gridleft.setValue(i, 'AMT', Math.floor(AMT / DrCnt));
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
                    var DifferenceNoTaxAMT = 0; //
                    var DifferenceTaxAMT = 0; //
                    var NoTaxChkVal = false;
                    var TaxChkVal = false;

                    for(var i =0;i<t_rowDatasright.length;i++){

                        if (model.NO_TPDOCU == t_rowDatasright[i].NO_TPDOCU ) {
                            if (tax_acct.indexOf(t_rowDatasright[i].CD_ACCT) > -1){
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
                        DifferenceNoTaxAMT =  Number(AMT) - (Math.floor(Number((AMT) / DrCnt)) * DrCnt);
                        NoTaxChkVal = true;
                    }
                    if ((Math.floor(VAT / DrTaxCnt)) * DrTaxCnt != VAT){	// 차변부가세계정 갯 수만큼	나눈 후 절사했을 때 총합 금액이 같지않는다면
                        DifferenceTaxAMT =  Number(VAT) - (Math.floor(Number((VAT) / DrTaxCnt)) * DrTaxCnt);
                        TaxChkVal = true;
                    }

                    for(var i =0;i<t_rowDatasright.length;i++){

                        if (model.NO_TPDOCU == t_rowDatasright[i].NO_TPDOCU ) {
                            if (tax_acct.indexOf(t_rowDatasright[i].CD_ACCT) > -1){
                                if(TaxChkVal){
                                    gridright.setValue(i, 'AMT', Math.floor(VAT / DrTaxCnt) + DifferenceTaxAMT);
                                    TaxChkVal = false;
                                }else{
                                    gridright.setValue(i, 'AMT', Math.floor(VAT / DrTaxCnt));
                                }
                            }else{
                                if(NoTaxChkVal){
                                    gridright.setValue(i, 'AMT', Math.floor(AMT / DrCnt) + DifferenceNoTaxAMT);
                                    NoTaxChkVal = false;
                                }else{
                                    gridright.setValue(i, 'AMT', Math.floor(AMT / DrCnt));
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
                        if (nvl(gridH[i].AMT_LOCAL) != '' && nvl($("#dtAcct").val()).replace(/-/gi, "") != '' && nvl(gridH[i].CD_EXCH) != '')
                            fnObj.gridHeader.target.setValue(i, "AMT_SUPPLY", (parseInt(gridH[i].AMT_LOCAL) * parseInt(gridH[i].RT_EXCH)));
                    } else {
                        fnObj.gridHeader.target.setValue(i, "RT_EXCH", 0);
                    }
                    if (nvl(gridH[i].AMT_LOCAL) != '') {
                        fnObj.gridHeader.target.setValue(i, "AMT_SUPPLY", (parseInt(gridH[i].RT_EXCH) * parseInt(gridH[i].AMT_LOCAL)));
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

                $('#CD_DEPT [data-ax5select]').ax5select({
                    theme: 'primary',
                    onStateChanged: function (e) {
                        if (e.state == 'changeValue' || e.state == 'setValue') {
                            $("#CD_EMP").setClear();
                        }
                        $("#CD_EMP").setHelpParam(JSON.stringify({CD_DEPT: $("#CD_DEPT").getCodes()}));
                    }
                });

                $("#CD_DEPT").setPicker([{code: SCRIPT_SESSION.cdDept, text: SCRIPT_SESSION.nmDept}]);
                $("#CD_EMP").setPicker([{code: SCRIPT_SESSION.noEmp, text: SCRIPT_SESSION.nmEmp}]);
                $("#CD_EMP").setHelpParam(JSON.stringify({CD_DEPT : $("#CD_DEPT").getCodes()}));

                /*$("#cdEmp").setParam({
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
                })*/
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

                $("#CD_EMP").attr("HEIGHT",_pop_height);
                $("#CD_EMP").attr("TOP",_pop_top);
                $("#CD_DEPT").attr("HEIGHT",_pop_height);
                $("#CD_DEPT").attr("TOP",_pop_top);
               /* $("#cdDept").attr("HEIGHT", _pop_height);
                $("#cdDept").attr("TOP", _pop_top);
                $("#cdEmp").attr("HEIGHT", _pop_height);
                $("#cdEmp").attr("TOP", _pop_top);*/

                //데이터가 들어갈 실제높이
                var datarealheight = $("#ax-base-root").height() - $(".ax-base-title").height() - $("#pageheader").height();
                //타이틀을 뺀 상하단 그리드 합친높이
                var tempgridheight = datarealheight - $("#top_title").height() - $("#bottom_left_title").height() - $("#bottom_left_AMT").height();

                $("#top_grid").css("height", tempgridheight / 100 * 50);
                $("#bottom_left_grid").css("height", tempgridheight / 100 * 49);
                $("#bottom_right_grid").css("height", tempgridheight / 100 * 49);


                /*
                alert($("#ax-base-root").height()); // 컨텐츠영역높이
                ax-base-title //타이틀부분높이(class)
                ax-base-content //검색조건높이(class)
                 */
            }

            function isChecked(data) {

                var result = [];
                var length = 0;

                var chkBox = fnObj.gridHeader.target.list;

                for (var i = 0; i < chkBox.length; i++) {
                    if (chkBox[i].CHK == "Y") {
                        result.push(fnObj.gridHeader.target.list[i]);
                        length++;
                    }
                }
                return {
                    length: length,
                    result: result
                }
            }


            var cnt = 0;
            $(document).on('click', '#headerBox', function (caller) {
                var gridList = fnObj.gridHeader.target.list;
                if (cnt == 0) {
                    cnt++;
                    $("div [data-ax5grid='grid-header']").find("div #headerBox").attr("data-ax5grid-checked", true);
                    gridList.forEach(function (e, i) {
                        fnObj.gridHeader.target.setValue(i, "CHK", "Y");
                    });
                    $("#REMARK").val("[지출결의] " + nvl(gridList[0].REMARK) + " 외 " + (gridList.length - 1) + "건 ( " + SCRIPT_SESSION.nmEmp + ", " + ax5.util.date($("#dtAcct").val(), {"return": "MM/dd"}) + " )");
                    /*for (var i = 0 ; i < fnObj.gridDetailRight.target.list.length ; i ++){
                        fnObj.gridDetailRight.target.setValue(i, "CHK", "Y");
                    }
                    for (var i = 0 ; i < fnObj.gridDetailLeft.target.list.length ; i ++){
                        fnObj.gridDetailLeft.target.setValue(i, "CHK", "Y");
                    }*/
                } else {
                    cnt = 0;
                    $("div [data-ax5grid='grid-header']").find("div #headerBox").attr("data-ax5grid-checked", false);
                    gridList.forEach(function (e, i) {
                        fnObj.gridHeader.target.setValue(i, "CHK", "N");
                    });
                    $("#REMARK").val('');
                    /*for (var i = 0 ; i < fnObj.gridDetailRight.target.list.length ; i ++){
                        fnObj.gridDetailRight.target.setValue(i, "CHK", "N");
                    }
                    for (var i = 0 ; i < fnObj.gridDetailLeft.target.list.length ; i ++){
                        fnObj.gridDetailLeft.target.setValue(i, "CHK", "N");
                    }*/
                }
            });

            var leftcnt = 0;
            $(document).on('click', '#left_headerBox', function (caller) {
                var gridList = fnObj.gridDetailLeft.target.list;
                if (leftcnt == 0) {
                    leftcnt++;
                    $("div [data-ax5grid='grid-detail-left']").find("div #headerBox").attr("data-ax5grid-checked", true);
                    gridList.forEach(function (e, i) {
                        fnObj.gridDetailLeft.target.setValue(i, "CHK", "Y");
                    });
                } else {
                    leftcnt = 0;
                    $("div [data-ax5grid='grid-detail-left']").find("div #headerBox").attr("data-ax5grid-checked", false);
                    gridList.forEach(function (e, i) {
                        fnObj.gridDetailLeft.target.setValue(i, "CHK", "N");
                    });
                }
            });

            var rightcnt = 0;
            $(document).on('click', '#right_headerBox', function (caller) {
                var gridList = fnObj.gridDetailRight.target.list;
                if (rightcnt == 0) {
                    rightcnt++;
                    $("div [data-ax5grid='grid-detail-right']").find("div #headerBox").attr("data-ax5grid-checked", true);
                    gridList.forEach(function (e, i) {
                        fnObj.gridDetailRight.target.setValue(i, "CHK", "Y");
                    });
                } else {
                    rightcnt = 0;
                    $("div [data-ax5grid='grid-detail-right']").find("div #headerBox").attr("data-ax5grid-checked", false);
                    gridList.forEach(function (e, i) {
                        fnObj.gridDetailRight.target.setValue(i, "CHK", "N");
                    });
                }
            });

        </script>
   </jsp:attribute>
    <jsp:body>
        <div data-page-buttons="">
            <div class="button-warp">
                <button type="button" class="btn btn-reload" data-page-btn="reload" onclick="window.location.reload();"
                        style="width:80px;">
                    <i class="icon_reload"></i></button>

                <button type="button" class="btn btn-info" data-page-btn="new" style="width:80px;"><i
                        class="icon_new"></i>초기화
                </button>
                <button type="button" class="btn btn-info" data-page-btn="search" style="width:80px;"><i class="icon_search"></i><ax:lang
                        id="ax.admin.sample.modal.button.search"/></button>
                <button type="button" class="btn btn-info" id="BtnDocuCopy" data-page-btn="docucopy"
                        style="width:80px;"><i
                        class="icon_slip"></i>전표복사
                </button>
                <button type="button" class="btn btn-info" data-page-btn="imsisave" style="width:80px;"><i
                        class="icon_ok"></i>저장
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
                        <ax:td label="전표유형" width="350px">
                            <div id = "cdDocu" name=""cdDocu data-ax5select="cdDocu" data-ax5select-config='{}'></div>
                        </ax:td>
                        <%--<ax:td label='조회부서' width="350px">
                            <multipicker id="S_DEPT" HELP_ACTION="HELP_DEPT" HELP_URL="multiDept" BIND-CODE="CD_DEPT"
                                         BIND-TEXT="NM_DEPT"/>
                        </ax:td>
                        <ax:td label='조회사원' width="350px">
                            <multipicker id="S_NM_EMP" HELP_ACTION="HELP_MULTI_EMP" HELP_URL="multiEmp" BIND-CODE="NO_EMP"
                                         BIND-TEXT="NM_EMP"/>
                        </ax:td>--%>
                        <ax:td label='부서' width="400px">
                            <multipicker id="CD_DEPT" HELP_ACTION="HELP_DEPT" HELP_URL="multiDept"
                                         BIND-CODE="CD_DEPT"
                                         BIND-TEXT="NM_DEPT"/>
                        </ax:td>
                        <ax:td label='작성사원' width="400px">
                            <multipicker id="CD_EMP" HELP_ACTION="HELP_EMP" HELP_URL="multiEmp"
                                        BIND-CODE="NO_EMP"
                                        BIND-TEXT="NM_EMP"/>
                        </ax:td>
                       <%-- <ax:td label="조회부서" width="350px">
                            <codepicker id="cdDept" HELP_ACTION="HELP_DEPT" HELP_URL="dept" BIND-CODE="CD_DEPT"
                                        BIND-TEXT="NM_DEPT" HELP_DISABLED="false" SESSION/>
                        </ax:td>
                        <ax:td label="조회사원" width="350px">
                            <codepicker id="cdEmp" HELP_ACTION="HELP_EMP" HELP_URL="emp" BIND-CODE="NO_EMP"
                                        BIND-TEXT="NM_EMP" HELP_DISABLED="false" SESSION/>
                        </ax:td>--%>
                    </ax:tr>
                </ax:tbl>
            </ax:form>
        </div>

        <%-- 그리드 영역 시작 --%>
        <div style="width:100%;" style="overflow:auto;">
            <div class="ax-button-group" data-fit-height-aside="grid-header" id="top_title">
                <div class="right">




                    <button type="button" class="btn btn-small" id="BtnHeaderDelete" data-grid-header-btn="devare"
                            style="width:80px;float:right;"><i
                            class="icon_del"></i> <ax:lang id="ax.admin.delete"/></button>
                    <button type="button" class="btn btn-small" id="BtnHeaderAdd" data-grid-header-btn="add"
                            style="width:80px;float:right;"><i
                            class="icon_add"></i>
                        <ax:lang id="ax.admin.add"/></button>
                    <button type="button" class="btn btn-small" id="BtnHeaderExp" data-grid-header-btn="exp"
                            style="width:80px;float:right;"><i
                            class=""></i> 편익제공
                    </button>
                    <button type="button" class="btn btn-small" id="BtnHeaderFile" data-grid-header-btn="file"
                            style="width:80px;float:right;"><i
                            class=""></i> 파일업로드
                    </button>
                    <label style="float:left;line-height:25px;margin-left:12px;">회계일자</label>
                    <div class="input-group" style="width: 150px; float:left; margin-left: 3px" data-ax5picker="DT_ACCT">
                        <input type="text" class="form-control" style="background: #ffe0cf" placeholder="yyyy-mm-dd" id="dtAcct"
                               formatter="YYYYMMDD">
                        <span class="input-group-addon"><i class="cqc-calendar"></i></span>
                    </div>
                    <label style="float:left;line-height:25px;margin-left:12px;">적요</label>
                    <div class="input-group" style="width: 250px; float:left; margin-left: 3px">
                        <input id="REMARK" class="form-control" style="background: #ffe0cf;"/>
                    </div>



                </div>
            </div>
            <div data-ax5grid="grid-header"
                 data-ax5grid-config="{
                        showLineNumber : false,
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
                                showLineNumber : false,
                                lineNumberColumnWidth: 40,
                                rowSelectorColumnWidth: 27,
                             }"
                         id="bottom_left_grid"
                    ></div>
                    <div style="overflow:auto;min-height:34px;height:34px;max-height:34px;" id="bottom_left_AMT">
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
                                      style="text-align:right;letter-spacing: 1px;"
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
                                showLineNumber : false,
                                lineNumberColumnWidth: 40,
                                rowSelectorColumnWidth: 27,
                             }"
                         id="bottom_right_grid"
                    ></div>
                    <div style="overflow:auto;min-height:34px;height:34px;max-height:34px;" id="bottom_right_AMT">
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