<%@ page import="com.chequer.axboot.core.utils.MessageUtils" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>

<ax:set key="title" value="법인카드전표등록"/>
<ax:set key="page_desc" value="${pageRemark}"/>
<ax:set key="page_auto_height" value="true"/>


<ax:layout name="base">
    <jsp:attribute name="script">카드거래내역
        <ax:script-lang key="ax.script"/>
        <%--        <script type="text/javascript" src="<c:url value='/assets/js/common/common2.js?v=<%=new SimpleDateFormat("yyyyMMddHH").format(System.currentTimeMillis())%>' />"></script>--%>
        <style>
            .red {
                background: #ffe0cf !important;
            }

        </style>

        <script type="text/javascript">
            /*************************************************************************개발자 정보*******************************************************************************/
            /*  개발자 : 오세진
            /*  개발일자 : 2019-07-24
            /*  개발메뉴  :법인카드전표등록
            /*  수정자   : 수정자 별로 하단지속적으로 이력관리 필요
            /*  수정일자 :
            /*  수정내용 :
            /*  수정자   :
            /*  수정일자 :
            /*  수정내용 :
            /*  수정자   :
            /*  수정일자 :
            /*  수정내용 :
            /***********************************************************************개발자 정보 끝*****************************************************************************/
            /************************************************************************* 초기화 *********************************************************************************/
            /* 1. 최초 바인딩 되는 처리
            // 2. 전역변수 지정
            // 3.  기본 함수 스타트와 리사이즈  */
            // $( window ).resize(function() {
            //     var winHeight = $(window).height();
            //     $("#scrollBody").attr("style","overflow-y :scroll;height:"+(winHeight-100)+"px;");
            // });


            $(document.body).ready(function () {
                // $("#cdEmp").onStatePicker("change",function(){
                //     alert("change")
                // })
                // $("#cdDept").onStatePicker("set",function(){
                //     $("#cdEmp").setHelpParam(JSON.stringify({CD_DEPT : $("#cdDept").getCodes()}));
                // })
                // $("#cdDept").onStatePicker("change",function(){
                //     $("#cdEmp").setHelpParam(JSON.stringify({CD_DEPT : $("#cdDept").getCodes()}));
                // })
                $('#cdDept [data-ax5select]').ax5select({
                    theme: 'primary',
                    onStateChanged: function (e) {
                        $("#cdEmp").setHelpParam(JSON.stringify({CD_DEPT : $("#cdDept").getCodes()}));
                    }
                });
            });
            // $("#tradeDateT").formatter('date')
            // $("#tradeDateF").formatter('date')
            var mask_M = new ax5.ui.mask();
            var modal_M = new ax5.ui.modal();
            var picker = new ax5.ui.picker();
            var checkedIdx = [];
            var myModel = new ax5.ui.binder();

            var tax_code_dr = ""; //차변 부가세 계정
            var tax_code_recept = ""; //접대비 계정

            var mo = new ax5.ui.modal();
            function openModal(name, action, callBack, viewName) {
                var map = new Map();
                map.set("modal", mo);
                map.set("modalText", "mo");
                map.set("action", action);
                map.set("keyword", "");
                map.set("viewName", viewName);
                $.openMuiltiPopup(name, callBack, map, 600, _pop_height, _pop_top);
            }

            axboot.ajax({
                type: "GET",
                url: ["gldocum", "getAcctcode"],
                data: "CD_RELATION=30",
                async: false,
                callback: function (res) {
                    tax_code_dr = res.map.CD_ACCT;
                }
            });

            axboot.ajax({
                type: "GET",
                url: ["gldocum", "getAcctcode"],
                data: "CD_RELATION=82",
                async: false,
                callback: function (res) {
                    tax_code_recept = res.map.CD_ACCT;
                }
            });
            var today = new Date();
            // var dtF = ax5.util.date(today, {"return": "yyyy-MM-01"});
            var dtF = ax5.util.date('20190801', {"return": "yyyy-MM-01"});
            var dtT = ax5.util.date(today, {"return": "yyyy-MM"}) + '-' + ax5.util.daysOfMonth(today.getFullYear(), today.getMonth());
            var dtNow = ax5.util.date(today, {"return": "yyyy-MM-dd"});
            picker.bind({
                target: $('[data-ax5picker="basic"]'),       //  발행일자
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

                            $("#tradeDateF").val(dtNow);
                            $("#tradeDateT").val(dtNow);
                            this.self.close();
                        }
                    },
                    thisMonth: {
                        label: "이번달", onClick: function () {
                            $("#tradeDateT").val(dtT);
                            $("#tradeDateF").val(dtF);
                            this.self.close();
                        }
                    },
                    ok: {label: "확인", theme: "default"}
                }
            });
            picker.bind({
                target: $('[data-ax5picker="basic2"]'),       //  발행일자
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
                    fnObj.gridView01.target.setValue(afterIndex, "DT_ACCT", $("#DT_ACCT").val().replace(/-/g, ""));
                },
                btns: {
                    today: {
                        label: "오늘", onClick: function () {
                            $("#DT_ACCT").val(dtNow);
                            this.self.close();
                        }
                    },
                    ok: {label: "확인", theme: "default"}
                }
            });
            picker.bind({
                target: $('[data-ax5picker="basic3"]'),       //  발행일자
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
                }
            });
            /******************************************************************************* 초기화 끝******************************************************************************/


            /*********************************************************************** 도움창 및 셀렉트박스 처리 *********************************************************************/
            // 1. 도움창 설정
            // 2. 셀렉트박스 설정
            // 3. CALLBACK 처리
            $("#NO_DOCU_TP").ax5select({
                options: [{value : '' , text : ''},{value : 'N' , text : '미처리'},{value : 'Y' , text : '처리'}]
            });

            /**
             * 결재상태 SELECT BOX SETTING
             * */
            var CodeData = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, "CZ_Q0005");

            $("#st_draft").ax5select({
                options: CodeData
            });

            /**
             * 업무구분 SELECT BOX SETTING
             * */
            var tempCode = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, "CZ_Q0021", true);
            var CodeData2 = tempCode;
            CodeData2 = CodeData2.sort(function(a, b) { // 오름차순
                return a['CD_FLAG1'] - b['CD_FLAG1'];
                // 13, 21, 25, 44
            });
            $("#job_tp").ax5select({
                options: [{code:'',value:'',text:''}].concat(CodeData2)
            });

            /*
            * CMS 전용 법인카드계정관리에서 설정한 업무 구분값만 보여지도록 수정
            * */

            var result = $.DATA_SEARCH('apbucardLv2','deptJobList',{CD_COMPANY : SCRIPT_SESSION.cdCompany , ID_USER : SCRIPT_SESSION.idUser, NO_EMP : SCRIPT_SESSION.noEmp}).list;
            result = result.sort(function(a, b) { // 오름차순
                return a['CD_FLAG1'] - b['CD_FLAG1'];
                // 13, 21, 25, 44
            });
            result.forEach(function(item,index){
                item.code = item.CD_SYSDEF;
                item.text = item.NM_SYSDEF;
                item.value = item.CD_SYSDEF
            });
            $("#jobTp").ax5select({
                options: [{code:'',value:'',text:''}].concat(result)
            });

            $("#JOB_TP").ax5select({
                options: [{code:'',value:'',text:''}].concat(result),
                onStateChanged: function (e) {
                    if(e.state == "changeValue"){
                        if(e.value[0].CODE == '3'){
                            qray.alert("출장경비는 지정할 수 없습니다.");
                            $('[data-ax5select="JOB_TP"]').ax5select("setValue", '');
                        }
                    }
                }
            });

            var CodeData15 = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'CZ_Q0015', true, '003', '003');

            var CodeData15 = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'CZ_Q0015', true, '003', '003');

            var CodeData14 = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'CZ_Q0014', true);

            var CodeData = $.getCommonCodeList(SCRIPT_SESSION.cdCompany, "CZ_Q0029");   // 사용목적

            var CodeData2 = $.getCommonCodeList(SCRIPT_SESSION.cdCompany, "CZ_Q0025");  // 구분 유형

            var CodeData3 = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, "CZ_Q0027");  // 편의제공유형

            var CodeData4 = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, "CZ_Q0021");  // 업무구분


            CodeData4 = CodeData4.sort(function(a, b) { // 오름차순
                return a['CD_FLAG1'] - b['CD_FLAG1'];
                // 13, 21, 25, 44
            });
            /********************************************************************** 도움창 및 셀렉트박스 처리 끝*******************************************************************/


            /*************************************************************************** 이벤트 처리 ******************************************************************************/
                // 1. 이벤트 처리(ACTION 처리 ) : 처리시 CONTROLLER, MAPPER 정의
                // 2. SEARCHVIEW, BUTTONVIEW 처리
            var tempD;
            myModel.onChange("*", function (n) {
                var selectIdx = fnObj.gridView01.getData('selected')[0].__index;
                fnObj.gridView01.target.setValue(selectIdx, n.el.name, n.value);
            });
            var modalCallBack;
            var cnt1 = 0; //전표처리 성공
            var cnt2 = 0; //전표처리 실패
            var afterIndex = 0;
            var fnObj = {}, CODE = {};
            var ACTIONS = axboot.actionExtend(fnObj, {
                //111
                PAGE_SEARCH: function (caller, act, data) {

                    if(nvl($("#cdDept").getCodes()) == ''){
                        qray.alert("조회조건의 부서선택은 필수입니다.");
                        return false;
                    }
                    caller.gridView02.clear();
                    qray.loading.show("데이터 조회중입니다.");
                    fnObj.gridView01.read();
                    caller.gridView01.target.select(afterIndex);
                    caller.gridView01.target.focus(afterIndex);
                    ACTIONS.dispatch(ACTIONS.ITEM_CLICK, caller.gridView01.getData()[0]);
                    qray.loading.hide();
                    $("#heardChk").attr("checked", false);

                    return false;
                },
                //222
                PAGE_SAVE: function (caller, act, data) {

                    var Hindex = fnObj.gridView01.getData("selected")[0].__index;
                    fnObj.gridView01.target.setValue(Hindex, "COMMENTS" ,$("#COMMENTS").val());
                    fnObj.gridView01.target.setValue(Hindex, "NM_NOTE" , $("#NM_NOTE").val());
                    fnObj.gridView01.target.setValue(Hindex,"CD_USERDEF1",$("#CD_USERDEF1").val().replace(/\-/g, ''));
                    fnObj.gridView01.target.setValue(Hindex,"DT_ACCT",$("#DT_ACCT").val().replace(/\-/g, ''));

                    var itemH = fnObj.gridView01.getData("selected")[0];
                    if (caller.gridView01.getDirtyDataCount() == 0 && caller.gridView02.getDirtyDataCount() == 0 && nvl(itemH.__modified__,false) == false) {
                        qray.alert("변경된 데이터가 없습니다.");
                        return false;
                    }


                    if(nvl(itemH.CD_USERDEF1) == ''){
                        qray.alert("만기일자는 필수값입니다.");
                        return false;
                    }
                    if(nvl(itemH.JOB_TP) == ''){
                        qray.alert("업무구분은 필수값입니다.");
                        return false;
                    }
                    //부가세 계정이 있는경우 법인카드 헤더 사업자번호를 기준으로 등록된 거래처가 있는지 체크함.
                    var dd = caller.gridView02.getData();
                    for(var i = 0; i < dd.length; i++){
                        if(tax_code_dr.indexOf(dd[i].CD_ACCT) > -1){
                            // var partnerList = $.DATA_SEARCH("commonHelp","HELP_PARTNER",{P_KEYWORD : itemH.CD_TRADE_PLACE});
                            if(dd[i].S_IDNO == ''){
                                qray.alert("부가세 계정에는 사업자등록이 되어있는 거래처가 필수입니다.");
                                return false;
                            }
                        }
                        if(nvl(dd[i].CD_BIZCAR) == '' && itemH.JOB_TP == '9'){
                            qray.alert("업무구분[업무용차량] 일 경우 차량선택은 필수입니다..");
                            return false;
                        }
                    }




                    if(itemH.CHK_BIZ_PURPOSE == 'Y'){
                        qray.alert("출장정산 데이터는 변경할 수 없습니다.");
                        return false;
                    }

                    if($(fnObj.gridView02).required()){
                        return false;
                    }

                    var sumD = 0;
                    var itemH = fnObj.gridView01.getDirtyData();
                    var itemD = [].concat(caller.gridView02.getDirtyData().updated).concat(caller.gridView02.getDirtyData().created);
                    var itemD2 = caller.gridView02.getDirtyData().updated.concat(caller.gridView02.getDirtyData().created);
                    for(var i = 0; i < itemD2.length; i++) {
                        if(tax_code_recept.indexOf(itemD2[i].CD_ACCT) > 0 && nvl(itemD2[i].NO_TAX) == ''){ //접대비항목이면서 저장이 안되어있을때
                            qray.alert("접대비 계정이 설정되어있지않습니다.");
                            return false;
                        }
                    }
                    for(var i = 0; i < itemD.length; i++){//불공 : 22
                        if(tax_code_dr.indexOf(itemD[i].CD_ACCT) > 0 && nvl(itemD[i].TAX_GB) == ''){ //부가세항목이면서 세무구분이 설정이 안되어있을때
                            qray.alert("부가세항목의 세무구분이 설정되어있지않습니다.");
                            return false;
                        }
                        //부가세항목이고 세무구분이 불공이면서 불공제구분 설정이 안되어있을때
                        if(tax_code_dr.indexOf(itemD[i].CD_ACCT) > 0 && itemD[i].TAX_GB == '22' && nvl(itemD[i].NON_TAX) == ''){
                            qray.alert("불공제구분이 설정되어있지않습니다.");
                            return false;
                        }
                        sumD += Number(nvl(itemD[i].AMT,0))
                    }

                    if(itemH.ADMIN_AMT != sumD){
                        // qray.alert("계정설정의 금액이 일치하지 않습니다.");
                        // return false;
                        // if(tempD.length == 0){
                        //     qray.alert("계정설정의 금액이 일치하지 않습니다.");
                        //     return false;
                        // }else if(tempD.length > 0 && itemD.length > 0){
                        //     qray.alert("계정설정의 금액이 일치하지 않습니다.");
                        //     return false;
                        // }
                    }
                    var hh = [].concat(caller.gridView01.getDirtyData().updated).concat(caller.gridView01.getDirtyData().created);
                    for(var i = 0; i < hh.length; i++){
                        if(nvl(hh[i].GROUP_NUMBER) != ''){
                            qray.alert("이미 처리된 데이터가 존재합니다.");
                            return false;
                        }
                    }

                    var data = {
                        listH: caller.gridView01.getDirtyData(),
                        listD: caller.gridView02.getDirtyData(),
                    };
                    validation(caller.gridView02.getDirtyData());
                    axboot.ajax({
                        type: "PUT",
                        url: ["apbucardLv2", "allsaveCMS"],
                        data: JSON.stringify(data),
                        callback: function (res) {
                            qray.alert("저장 되었습니다.").then(function(){
                                ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                            })
                        },
                        options : {
                            onError : function(err){
                                qray.alert(err.message)
                            }
                        }
                    })

                }
                , FORM_CLEAR: function (caller, act, data) {
                    qray.confirm({
                        msg: LANG("ax.script.form.clearconfirm")
                    }, function () {
                        if (this.key == "ok") {
                            caller.gridView02.clear();
                        }
                    });
                }
                //건별전표처리
                , STATEMENT: function (caller, act, data) {
                    var param = [];
                    if (caller.gridView01.getDirtyDataCount() > 0 || caller.gridView02.getDirtyDataCount() > 0 ) {
                        qray.alert("미저장된 데이터가 존재합니다.");
                        return false;
                    }

                    var checkList = isChecked(fnObj.gridView01.getData());
                    if(checkList.length == 0){
                        qray.alert("체크 된 데이터가 없습니다.");
                        return false;
                    }

                    for(var i = 0; i < checkList.length; i++){
                        if (nvl(checkList[i].NO_DOCU) != '') {
                            qray.alert("이미 전표처리된 데이터가 존재합니다.");
                            return false;
                        }

                        if(checkList[i].CHK_BIZ_PURPOSE == 'Y'){
                            qray.alert("출장정산 데이터는 전표처리할 수 없습니다.");
                            return false;
                        }

                        checkList[i].CD_PC = $("#cdPc").attr("code");
                        checkList[i].TAX_CD = tax_code_dr;
                    }
                    for(var i = 0; i < checkList.length; i++){
                        axboot.ajax({
                            type: "PUT",
                            url: ["apbucard", "statement"],
                            data: JSON.stringify(checkList[i]),
                            async: false,
                            callback: function (res) {
                                param.push(res.map.GROUP_NUMBER);
                                cnt1++
                            },
                            options : {
                                onError : function(err){
                                    cnt2++;
                                    qray.alert(err.message).then(function(){

                                    })
                                    // qray.alert(err.message)
                                    // return false;
                                }
                            }
                        });
                    }
                    qray.alert(cnt1 +"건의 전표가 처리되었습니다.\n" + cnt2+"건의 전표처리가 실패하였습니다.").then(function(){
                        ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                        if(cnt1 > 0){
                            menuOpen(param)
                        }
                        cnt1 = 0;
                        cnt2 = 0;
                    })

                }
                // 전표처리
                , STATEMENTMULTI: function (caller, act, data) {
                    var param = [];
                    if (caller.gridView01.getDirtyDataCount() > 0 || caller.gridView02.getDirtyDataCount() > 0 ) {
                        qray.alert("미저장된 데이터가 존재합니다.");
                        return false;
                    }

                    var checkList = isChecked(fnObj.gridView01.getData());

                    if (checkList.length == 0) {
                        qray.alert("체크 된 데이터가 없습니다.");
                        return false;
                    }

                    for(var i = 0; i < checkList.length; i++){
                        for(var j = i; j < checkList.length; j++){
                            if(nvl(checkList[j].JOB_TP) == ''){
                                qray.alert("업무구분은 필수 항목입니다.");
                                return false;
                            }
                            /*
                            if(checkList[i].JOB_TP != checkList[j].JOB_TP){
                                qray.alert("업무구분이 동일한 비용건만 전표처리가능합니다.");
                                return false;
                            }
                             */
                        }
                    }

                    for (var i = 0; i < checkList.length; i++) {
                        if (nvl(checkList[i].NO_DOCU) != '') {
                            qray.alert("이미 전표처리된 데이터가 존재합니다.");
                            return false;
                        }
                        if (checkList[i].CHK_BIZ_PURPOSE == 'Y') {
                            qray.alert("출장정산 데이터는 전표처리할 수 없습니다.");
                            return false;
                        }
                        checkList[i].CD_PC = $("#cdPc").attr("code");

                    }
                    data = {list : checkList};
                    //일괄전표
                    userCallBack = function (e) {
                        modal.close({
                            callback : function(){
                                if(e.YN == 'Y'){
                                    if(nvl(e.DT_ACCT_T) == ''){
                                        qray.alert("회계일자 선택은 필수입니다.");
                                        return false;
                                    }
                                    //마감월 체크로직
                                    var paramMonthCheck = {
                                        CD_COMPANY : SCRIPT_SESSION.cdCompany
                                        ,DT_ACCT    : e.DT_ACCT_T
                                        ,CD_DOCU    : "90"
                                        ,CD_DEPT    : SCRIPT_SESSION.CD_DEPT
                                        ,DT_WRITE   : ax5.util.date(new Date(), {"return": "yyyyMMdd"})
                                    };
                                    var result = $.DATA_SEARCH('commonutility','checkMagam',paramMonthCheck);
                                    if(result.map.CHECK_YN == 'Y'){
                                        qray.alert("회계월 마감 데이터가 존재합니다.");
                                        return false;
                                    }
                                    var nm_company = [];
                                    checkList.forEach(function(item, index){
                                        checkList[index].CD_COMPANY = SCRIPT_SESSION.cdCompany;
                                        nm_company.push('법인카드_'+item.TRADE_PLACE)

                                    });
                                    data = {list : checkList , REMARK : nvl(e.REMARK,nm_company.join(" ,")), DT_ACCT_T : e.DT_ACCT_T, TAX_CD : tax_code_dr};
                                    $.DATA_SEARCH('apbucardLv2','budgetCheck',{param:checkList , DT_ACCT_T : e.DT_ACCT_T});
                                    axboot.ajax({
                                        type: "PUT",
                                        url: ["apbucard", "statementMulti"],
                                        data: JSON.stringify(data),
                                        async: false,
                                        callback: function (res) {
                                            param.push({GROUP_NUMBER : res.map.GROUP_NUMBER , COMMENTS : e.REMARK , NO_DOCU : res.map.NO_DOCU});
                                            qray.alert("전표가 처리되었습니다.").then(function(){
                                                qray.confirm({
                                                    msg: '결재요청을 진행하시겠습니까?',
                                                    btns: {
                                                        apply: {
                                                            label:'예', onClick: function(key){
                                                                qray.close();
                                                                modalCallBack = function (e) {
                                                                    if(e){
                                                                        qray.alert("결재요청이 완료되었습니다.").then(function(){
                                                                            ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                                                                        })
                                                                    }else{
                                                                        qray.alert("결재요청이 취소되었습니다.").then(function(){
                                                                            ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                                                                        })
                                                                    }
                                                                };
                                                                gw(param)
                                                                // $.openCustomPopup("Payment",'modalCallBack', '', param, '', 1400, 700)
                                                            }
                                                        },
                                                        other: {
                                                            label:'아니오', onClick: function(key){
                                                                qray.close();
                                                                ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                                                            }
                                                        }
                                                    }
                                                }, function(){

                                                });
                                            })
                                        },
                                        options : {
                                            onError : function(err){
                                                qray.alert(err.message)
                                            }
                                        }
                                    });
                                }
                            }
                        });
                    };
                    $.openCommonPopup('bucardDocu', 'userCallBack', '', '', data, 600, 180,250);

                }

                , CANCEL : function (caller, act, data) {
                    var checkList = isCancelChecked(caller.gridView01.getData());
                    if(!checkList){
                        return false;
                    }
                    qray.confirm({
                        msg: "전표를 취소하시겠습니까?."
                        ,btns: {
                            ok: {
                                label:'확인', onClick: function(key){
                                    for(var i = 0; i < checkList.length; i++) {
                                        checkList[i].GUBUN = '3';
                                        checkList[i].NO_DOCU = nvl(checkList[i].NO_DOCU,'NO');
                                        $.DATA_SEARCH("glDocuS", "docu_crud", checkList[i]);
                                    }
                                    qray.close();
                                    qray.alert("전표취소 처리가 완료되었습니다.").then(function(){
                                        ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                                    })

                                }
                            },
                            cancel: {
                                label:'취소', onClick: function(key){
                                    qray.close();
                                }
                            }
                        }
                    });



                }
                , APPLY : function (caller, act, data) {
                    var data = isChecked(fnObj.gridView01.getData());
                    var array = [];
                    var gr_no = [];
                    var resultCode = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, "CZ_Q0061");
                    var docuF = resultCode[1].text;

                    for (var i = 0; i < data.length; i++) {
                        if(docuF == '1'){
                            if(nvl(data[i].NO_DOCU) == ''){
                                qray.alert("미처리 전표 데이터가 존재합니다.");
                                return false;
                            }
                            if ((data[i].ST_ING == '01' || data[i].ST_ING == '03') && nvl(data[i].NO_DOCU) != '') {
                            // if ((data[i].ST_ING == '01' || data[i].ST_ING == '03') && nvl(data[i].IU_DOCUYN) == 'Y' && nvl(data[i].IU_ST) == '1' ) {
                                array.push(data[i]);
                                gr_no.push(data[i].GROUP_NUMBER)
                            }
                            if(data[i].ST_ING != '01' && data[i].ST_ING != '03' && nvl(data[i].NO_DOCU) != ''){
                                qray.alert("미상신 데이터만 선택해야합니다.");
                                return false;
                            }
                            if(nvl(data[i].NO_DOCU) == '' && data[i].ST_ING != '01'){
                                qray.alert("IU전표가 존재하지 않는 데이터가 있습니다.");
                                return false;
                            }
                            if(nvl(data[i].IU_ST) == '2'){
                                qray.alert("IU에서 승인된 전표가 존재합니다.");
                                return false;
                            }
                        }else{
                            //가전표 결재요청시
                            if(data[i].ST_ING != '01' && data[i].ST_ING != '03'){
                                qray.alert("미상신 데이터만 선택해야합니다.");
                                return false;
                            }
                            if(nvl(data[i].NO_DOCU) == ''){
                                qray.alert("미처리 전표 데이터가 존재합니다.");
                                return false;
                            }
                            if ((data[i].ST_ING == '01' || data[i].ST_ING == '03') ) {
                                array.push(data[i]);
                                gr_no.push(data[i].GROUP_NUMBER)
                            }

                        }

                    }
                    if(array.length == 0){
                        qray.alert("체크된 데이터가 없습니다.");
                        return false;
                    }
                    var result = $.DATA_SEARCH("glDocuS","getSelectList",{NO_DOCU : '' , CD_COMPANY : SCRIPT_SESSION.cdCompany, GROUP_NUMBER : gr_no.join('|')});
                    for(var i = 0; i < result.list.length; i++){
                        if(nvl(result.list[i].ST_ING) != '01'){
                            qray.alert("이미 상신중인 데이터가 있습니다.");
                            return false;
                        }
                    }

                    modalCallBack = function (e) {
                        if(e){
                            qray.alert("결재요청이 완료되었습니다.").then(function(){
                                ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                            })
                        }else{
                            qray.alert("결재요청이 취소되었습니다.").then(function(){
                                // ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                            })
                        }
                    };
                    // gr_no.forEach(function(item,index){
                    //     if(item == gr_no[index+1]){
                    //         gr_no.splice(index,1)
                    //     }
                    // })
                    // var temp = array
                    // var cnt = 0;
                    // for(var i = 0; i < array.length; i++){
                    //     if(array[i].GROUP_NUMBER == array[i+1].GROUP_NUMBER ){
                    //         temp.splice(i+cnt,1)
                    //         cnt++;
                    //     }
                    // }
                    //$.openCustomPopup("Payment",'modalCallBack', '', array, '', 1400, 700)
                    var param = [];
                    array.forEach(function(item,index){
                        param.push({GROUP_NUMBER : item.GROUP_NUMBER ,  NO_DOCU : item.NO_DOCU});
                    });
                    gw(param)

                },
                //333
                ITEM_CLICK: function (caller, act, data) {
                    var item = caller.gridView01.getData('selected')[0];
                    if (!item) {
                        return false;
                    }
                    $("#COMMENTS").val(item.COMMENTS);
                    $("#NM_NOTE").val(item.NM_NOTE);
                    afterIndex = item.__index;
                    fnObj.gridView02.read();

                    if(nvl(item.DT_ACCT) == ''){
                        var dddd = String(new Date(item.TRADE_DATE.substring(0,4),item.TRADE_DATE.substring(4,6),0).getDate());
                        var dayy = item.TRADE_DATE.substring(0,4)+'-'+item.TRADE_DATE.substring(4,6)+'-'+dddd;
                        var vald = dayy.replace(/-/g, "");
                        $("#DT_ACCT").val(dayy);
                        // fnObj.gridView01.target.setValue(item.__index,"DT_ACCT",vald)
                    }else{
                        $("#DT_ACCT").val(ax5.util.date(item.DT_ACCT, {"return": "yyyy-MM-dd"}))
                    }

                    if(nvl(item.CD_USERDEF1) != ''){
                        $("#CD_USERDEF1").val(ax5.util.date(item.CD_USERDEF1, {"return": "yyyy-MM-dd"}));
                    }else{

                        var dtt = new Date();
                        var mont;
                        if(new Date().getDate() < 19){
                            mont = String(dtt.getMonth()+1);
                        }else{
                            mont = String(dtt.getMonth()+2);
                        }
                        if(mont < 10){
                            mont = '0'+mont
                        }
                        $("#CD_USERDEF1").val(ax5.util.date(String(dtt.getFullYear())+mont+'19', {"return": "yyyy-MM-dd"}));

                        // CMS전용 고객사 요청으로 승인일 기준 다음월의 19일을 만기일로 기본셋팅
                        var cmsM = Number(item.TRADE_DATE.substring(4,6))+1;
                        if(cmsM < 10){
                            cmsM = '0'+String(cmsM)
                        }else{
                            cmsM = String(cmsM)
                        }
                        var cmsFull =  item.TRADE_DATE.substring(0,4)+'-'+cmsM+'-'+'19';
                        $("#CD_USERDEF1").val(cmsFull);

                    }


                    $("#JOB_TP").ax5select("setValue", nvl(item.JOB_TP, ""), true);

                    myModel.setModel({
                        COMMENTS : item.COMMENTS
                        ,NM_NOTE : item.NM_NOTE
                    }, $(document["binder-form"]));

                    if($("#JOB_TP select[name='JOB_TP']").val() != ''){
                        addRowDefault = $.DATA_SEARCH('apbucard', 'acctAddRow', {
                            JOB_TP  : $("#JOB_TP select[name='JOB_TP']").val(),
                            CD_DEPT : fnObj.gridView01.getData('selected')[0].CD_DEPT
                        });
                    }

                    if (nvl(item.NO_DOCU) != '') {
                        checkDocu(true)
                    } else {
                        checkDocu(false)
                    }
                    // if (nvl(item.NO_DOCU) != '' || item.CHK_BIZ_PURPOSE == 'Y') {
                    //     BtnDisabled()
                    // }else{
                    //     BtnEnabled()
                    // }
                    // if(nvl(item.ST_ING) == '04'){
                    //     $("#BtnCancel").attr('disabled', true);
                    // }
                },
                ITEM_ADD1: function (caller, act, data) {

                },
                //11
                ITEM_ADD2: function (caller, act, data) {
                    var DataSource = caller.gridView02.getData();
                    if (caller.gridView01.getData('selected')[0].YN_DOCU == '처리') {
                        return false;
                    }
                    if (caller.gridView01.getData('selected').length == 0) {
                        qray.alert("법인카드 내역을 먼저 선택하세요.");
                        return false;
                    }
                    if ($("select[name='JOB_TP']").val() == undefined || $("select[name='JOB_TP']").val() == '') {
                        qray.alert("업무구분을 선택하여 주십시요.");
                        return false;
                    }
                    if ($("#DT_ACCT").val() == undefined || $("#DT_ACCT").val() == '') {
                        qray.alert("회계일자를 선택하여 주십시요.");
                        return false;
                    }

                    /*
                    if($(fnObj.gridView02).required()){
                        return false;
                    }
                     */

                    caller.gridView02.addRow();
                    var lastIdx =  nvl(caller.gridView02.target.list.length, caller.gridView02.lastRow());
                    // var lastIdx = caller.gridView02.lastRow();
                    caller.gridView02.target.select(lastIdx - 1);
                    var item = caller.gridView01.getData('selected')[0];

                    caller.gridView02.target.select(lastIdx - 1);
                    caller.gridView02.target.setValue(lastIdx - 1, "ACCT_NO", item.ACCT_NO);
                    caller.gridView02.target.setValue(lastIdx - 1, "BANK_CODE", item.BANK_CODE);
                    caller.gridView02.target.setValue(lastIdx - 1, "TRADE_DATE", item.TRADE_DATE);
                    caller.gridView02.target.setValue(lastIdx - 1, "TRADE_TIME", item.TRADE_TIME);
                    caller.gridView02.target.setValue(lastIdx - 1, "SEQ", item.SEQ);
                    caller.gridView02.target.setValue(lastIdx - 1, "NO_EMP", item.NO_EMP);
                    //caller.gridView02.target.setValue(lastIdx - 1, "S_IDNO", item.CD_TRADE_PLACE);
                    //caller.gridView02.target.setValue(lastIdx - 1, "CD_PARTNER", item.CD_PARTNER);
                    caller.gridView02.target.setValue(lastIdx - 1, "NM_USERDEF1", item.TRADE_PLACE);
                    caller.gridView02.target.setValue(lastIdx - 1, "CD_DEPT", item.CD_DEPT);
                    caller.gridView02.target.setValue(lastIdx - 1, "NM_DEPT", item.NM_DEPT);
                    console.log('>>',item);
                    // caller.gridView02.target.setValue(lastIdx - 1, "AMT", 0);
                    if(addRowDefault.list[1]){
                        fnObj.gridView02.target.setValue(lastIdx - 1, "NM_CC", addRowDefault.list[1].NM_CC);
                        fnObj.gridView02.target.setValue(lastIdx - 1, "CD_CC", addRowDefault.list[1].CD_CC);
                        fnObj.gridView02.target.setValue(lastIdx - 1, "CD_BUDGET", addRowDefault.list[1].CD_BUDGET);
                        fnObj.gridView02.target.setValue(lastIdx - 1, "NM_BUDGET", addRowDefault.list[1].NM_BUDGET);
                    }
                    if(addRowDefault.list[0]){
                        fnObj.gridView02.target.setValue(lastIdx - 1, "NM_ACCT_CR", addRowDefault.list[0].NM_ACCT);
                        fnObj.gridView02.target.setValue(lastIdx - 1, "CD_ACCT_CR", addRowDefault.list[0].CD_ACCT);
                    }
                    caller.gridView02.target.setValue(lastIdx - 1, "NO_EMP", item.NO_EMP);
                    caller.gridView02.target.setValue(lastIdx - 1, "NM_KOR", item.NM_USER);

                    //CMS 전용 START
                    var acctLink = $.DATA_SEARCH("apbucardLv2" , "acctLink",{CD_COMPANY : SCRIPT_SESSION.cdCompany , ACCT_NO : item.ACCT_NO , BANK_CODE : item.BANK_CODE}).map;
                    for (var i = 0; i < Object.keys(acctLink).length; i++) {
                        var key = Object.keys(acctLink)[i];
                        if(acctLink[key] == 'A06'){
                            var cd_mngd = acctLink['CD_MNGD'+String(key.charAt(key.length-1))];
                            var nm_mngd = acctLink['NM_MNGD'+String(key.charAt(key.length-1))];
                            caller.gridView02.target.setValue(lastIdx - 1, "CD_PARTNER", cd_mngd);
                            caller.gridView02.target.setValue(lastIdx - 1, "LN_PARTNER", nm_mngd);
                            var result = $.DATA_SEARCH("apbucardLv2" , "apbuPartner" , {CD_COMPANY : SCRIPT_SESSION.cdCompany , CD_PARTNER : cd_mngd}).map;
                            if(nvl(result.NO_COMPANY) != ''){
                                caller.gridView02.target.setValue(lastIdx - 1, "S_IDNO", result.NO_COMPANY);
                            }else{
                                caller.gridView02.target.setValue(lastIdx - 1, "S_IDNO", '');
                            }
                        }
                    }
                    var selectD = caller.gridView02.getData('selected')[0];

                    if(nvl(selectD.CD_PARTNER) == ''){
                        var result = $.DATA_SEARCH("apbucardLv2" , "apbuPartner",{CD_COMPANY : SCRIPT_SESSION.cdCompany , NO_COMPANY : item.CD_TRADE_PLACE}).map;
                        if(nvl(result.CD_PARTNER) != ''){
                            caller.gridView02.target.setValue(lastIdx - 1, "CD_PARTNER", result.CD_PARTNER);
                            caller.gridView02.target.setValue(lastIdx - 1, "LN_PARTNER", result.LN_PARTNER);
                            caller.gridView02.target.setValue(lastIdx - 1, "S_IDNO", result.NO_COMPANY);
                        }else{
                            caller.gridView02.target.setValue(lastIdx - 1, "CD_PARTNER", '');
                            caller.gridView02.target.setValue(lastIdx - 1, "S_IDNO", '');
                        }
                    }


                    //console.log(acctLink,' : acctLink')
                    //CMS 전용 END

                },

                ITEM_ADD3: function (caller, act, data) {
                },

                ITEM_DEL2: function (caller, act, data) {
                    caller.gridView02.delRow("selected");
                }
                ,
                ITEM_DEL3: function (caller, act, data) {
                }
                ,
                BNFT_BTN: function (caller, act, data) {
                }
                ,ACCTTEMP: function (caller, act, data) {
                    var param = [];
                    if (caller.gridView01.getDirtyDataCount() > 0 || caller.gridView02.getDirtyDataCount() > 0 ) {
                        qray.alert("미저장된 데이터가 존재합니다.");
                        return false;
                    }

                    var checkList = isChecked(fnObj.gridView01.getData());

                    if (checkList.length == 0) {
                        qray.alert("체크 된 데이터가 없습니다.");
                        return false;
                    }

                    for (var i = 0; i < checkList.length; i++) {
                        if (nvl(checkList[i].NO_DOCU) != '') {
                            qray.alert("이미 전표처리된 데이터가 존재합니다.");
                            return false;
                        }
                        if (checkList[i].CHK_BIZ_PURPOSE == 'Y') {
                            qray.alert("출장정산 데이터는 전표처리할 수 없습니다.");
                            return false;
                        }
                        checkList[i].CD_PC = $("#cdPc").attr("code");

                    }
                    data = {list : checkList};
                    $.openCommonPopup('bucardDocuAcctInsert', 'bathCallBack', '', '', data, 600, 550,150);
                }
            });
            var bathCallBack = function(e){
                if(e.YN == 'Y'){
                    ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                }else{
                }
            };
            function gw(param){
                var today = new Date();
                var day = ax5.util.date(today, {"return": "yyyy-MM-dd"});
                var temp = [];

                param.forEach(function(item,index){
                    temp.push({ GROUP_NUMBER : item.GROUP_NUMBER , NO_DOCU : item.NO_DOCU})
                });
                var unique = [];
                temp.forEach(function(item, index){
                    if(JSON.stringify(unique).indexOf(JSON.stringify(item)) < 0){
                        unique.push(item)
                    }
                });


                var no_draft;
                // var result = $.DATA_SEARCH("glDocuS" , "getNoDraft")
                // result = result.NO_DRAFT
                axboot.ajax({
                    type: "POST",
                    url: ["apbucardLv2" , "applyInsert"],
                    data: JSON.stringify({list : unique , DT_ACCT : day, USER_DRAFT : SCRIPT_SESSION.noEmp}),
                    async : false,
                    callback: function (res) {
                        no_draft = res.map.NO_DRAFT
                    }
                });

                var win = window.open('http://ep.cmsedu.co.kr/app/approval/integration?CD_COMPANY='+SCRIPT_SESSION.cdCompany+'&CD_FORM=WEB01&NO_KEY_GR='+ SCRIPT_SESSION.cdGroup +'-'+no_draft+'&NO_EMP='+SCRIPT_SESSION.noEmp,[],'_blank');


                var interval = window.setInterval(function() {
                    try {
                        //상신 누르고 자동으로 닫혀도 CLOSED로 먹히기 때문에
                        if (win == null || win.closed) {
                            //cz_draft INSERT 한 데이터 삭제/ cz_docu에 no_draft 빈값으로 UPDATE
                            //무조건 태우기 - CZ_DOCU에 ST_ING가 그냥 껏을 때는 미상신이므로 미상신일 때만 지우기
                            // axboot.ajax({
                            //     type: "POST",
                            //     url: ["apbucardLv2" , "applyUpdate"],
                            //     data: JSON.stringify({list : param , NO_DRAFT : no_draft}),
                            //     async : false,
                            //     callback: function (res) {
                            //     }
                            // });
                            window.clearInterval(interval);
                            ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                        }
                    }
                    catch (e) {
                    }

                }, 100);


            }

            function changeDataCheck(){
                var list = [].concat(fnObj.gridView02.getData("modified"));
                list = list.concat(fnObj.gridView02.getData("deleted"));
                return list.length;
            }
            fnObj.pageButtonView = axboot.viewExtend({
                initView: function () {
                    axboot.buttonClick(this, "data-page-btn", {
                        "search": function () {
                            ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                        },
                        "save": function () {
                            ACTIONS.dispatch(ACTIONS.PAGE_SAVE);
                        },
                        "docu": function () {
                            ACTIONS.dispatch(ACTIONS.STATEMENT);
                        },
                        "docuMulti": function () {
                            ACTIONS.dispatch(ACTIONS.STATEMENTMULTI);
                        },
                        "approval": function () {
                            ACTIONS.dispatch(ACTIONS.APPROVAL);
                        },
                        "cancel": function () {
                            ACTIONS.dispatch(ACTIONS.CANCEL);
                        },
                        "apply": function () {
                            ACTIONS.dispatch(ACTIONS.APPLY);
                        },
                        "acctTemp": function () {
                            ACTIONS.dispatch(ACTIONS.ACCTTEMP);
                        }
                        ,"excel": function () {
                            fnObj.gridView01.target.exportExcel('카드거래내역'+$('#tradeDateF').val().replace(/\-/g, '')+'_'+$('#tradeDateT').val().replace(/\-/g, '')+'.xls')
                        }
                    });
                }
            });

            //== view 시작
            fnObj.searchView = axboot.viewExtend(axboot.searchView, {
                initView: function () {
                    this.target = $(document["searchView0"]);
                    this.target.attr("onsubmit", "return ACTIONS.0" +
                        "+(ACTIONS.PAGE_SEARCH);");
                    this.tradeDateF = $("#tradeDateF");
                    this.tradeDateT = $("#tradeDateT");
                },
                getData: function () {
                    return {
                        tradeDateF: this.tradeDateF.val().replace(/-/g, ""),
                        tradeDateT: this.tradeDateT.val().replace(/-/g, ""),
                        CD_PC: $("#cdPc").attr("code"),
                        CD_DEPT: $("#cdDept").getCodes(),
                        CD_EMP: $("#cdEmp").getCodes(),
                        ST_DRAFT: $("select[name='st_draft']").val(),
                        JOB_TP: $("select[name='jobTp']").val(),
                        NO_DOCU_TP: $("select[name='NO_DOCU_TP']").val(),
                    }
                }
            });

            fnObj.pageStart = function () {
                this.pageButtonView.initView();
                this.searchView.initView();
                this.gridView01.initView();
                this.gridView02.initView();
                var today = new Date();
                var dtF = ax5.util.date(today, {"return": "yyyy-MM-01"});
                var dtT = ax5.util.date(today, {"return": "yyyy-MM-dd"});
                // var dtF = ax5.util.date('20190801', {"return": "yyyy-MM-01"});
                // var dtT = ax5.util.date(today, {"return": "yyyy-MM"}) + '-' + ax5.util.daysOfMonth(today.getFullYear(), today.getMonth());
                $("#tradeDateF").val(dtF);
                $("#tradeDateT").val(dtT);

            };

            var draftCallback = function (pram) {
                if (pram == "OK") {
                    qray.alert("결재요청 되었습니다.");
                    ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                }
            };

            /*************************************************************************** 이벤트 처리 끝****************************************************************************/


            /*************************************************************************** 사용자 함수 처리 ************************************************************************/
                // 사용자 함수 처리 및 CALLBACK 처리
            var userCallBack = function (e) {
                    if (e.length > 0) {
                        $("#nmEmp").val(e[0].NM_EMP);
                        $("#nmEmp").attr({"code": e[0].NO_EMP, "name": e[0].NM_EMP});
                    }
                    modal.close();
                };

            var deptCallBack = function (e) {
                if (e.length > 0) {
                    $("#cdDept").val(e[0].NM_DEPT);
                    $("#cdDept").attr({"code": e[0].CD_DEPT, "name": e[0].NM_DEPT});

                }
                modal.close();
            };
            var calenderModal = new ax5.ui.modal();
            function openCalenderModal(callBack, viewName, initData) {  //  관리항목 CALENDER 도움창오픈
                var map = new Map();
                map.set("modal", calenderModal);
                map.set("modalText", "calenderModal");
                map.set("viewName", viewName);

                $.openCommonUtils(callBack, map, 'calender',340,450,_pop_top450);
            }

            var publishRequestModal = new ax5.ui.modal();

            function openHelpModal(name, action, callBack, viewName, param) {
                var map = new Map();
                map.set("modal", publishRequestModal);
                map.set("modalText", "publishRequestModal");
                map.set("action", action);
                map.set("keyword", "");
                map.set("viewName", viewName);
                map.set("initData", param);

                $.openMuiltiPopup(name, callBack, map, 600, _pop_height, _pop_top);
            }
            // calllback 함수 끝//////////////////////////
            //11
            var addRowDefault;
            $(".ax-search-tb2").find("[data-ax5select]").change(function () {
                if (fnObj.gridView01.getData('selected').length == 0) {
                    qray.alert("선택된 카드사용건이 없습니다.");
                    return false;
                }
                if($("#JOB_TP select[name='JOB_TP']").val() != '') {
                    addRowDefault = $.DATA_SEARCH('apbucard', 'acctAddRow', {
                        JOB_TP: $("#JOB_TP select[name='JOB_TP']").val(),
                        CD_DEPT: fnObj.gridView01.getData('selected')[0].CD_DEPT
                    });
                }

                if (fnObj.gridView01.getData('selected').length > 0) {
                    var value = $("select[name=" + this.id + "]").val();
                    var selectIdx = fnObj.gridView01.getData('selected')[0].__index;
                    fnObj.gridView01.target.setValue(selectIdx, this.id, value);
                }

                for (var i = 0; i < fnObj.gridView02.getData().length; i++) {
                    if(addRowDefault.list[1]){
                        fnObj.gridView02.target.setValue(i, "NM_CC", addRowDefault.list[1].NM_CC);
                        fnObj.gridView02.target.setValue(i, "CD_CC", addRowDefault.list[1].CD_CC);
                        fnObj.gridView02.target.setValue(i, "CD_BUDGET", addRowDefault.list[1].CD_BUDGET);
                        fnObj.gridView02.target.setValue(i, "NM_BUDGET", addRowDefault.list[1].NM_BUDGET);
                    }
                    if(addRowDefault.list[0]){
                        fnObj.gridView02.target.setValue(i, "NM_ACCT_CR", addRowDefault.list[0].NM_ACCT);
                        fnObj.gridView02.target.setValue(i, "CD_ACCT_CR", addRowDefault.list[0].CD_ACCT);
                    }

                    fnObj.gridView02.target.setValue(i, "CD_ACCT", '');
                    fnObj.gridView02.target.setValue(i, "NM_ACCT", '');
                    fnObj.gridView02.target.setValue(i, "CD_BGACCT", '');
                    fnObj.gridView02.target.setValue(i, "NM_BGACCT", '');
                    fnObj.gridView02.target.setValue(i, "AMT", 0);
                }

            });

            function isChecked(data) {
                var array = [];
                for (var i = 0; i < data.length; i++) {
                    if (data[i].CHKED == true) {
                        array.push(data[i])
                    }
                }
                return array;
            }

            function isCancelChecked(data) {
                var result = [];
                // var chkBox = $("div .detailBox");
                // for (var i = 0; i < chkBox.length; i++) {
                //     if (chkBox[i].getAttribute('data-ax5grid-checked') == "true") {
                //         var index = chkBox[i].id.split("detailBox")[1];
                //         result.push(fnObj.gridView01.target.list[index]);
                //     }
                // }
                // for (var i = 0; i < chkBox.length; i++) {
                //     if (chkBox[i].getAttribute('data-ax5grid-checked') == "true") {
                //         var index = chkBox[i].id.split("detailBox")[1];
                //         result.push(fnObj.gridView01.target.list[index]);
                //     }
                // }
                var chkBox = data;
                for (var i = 0; i < chkBox.length; i++) {
                    if (data[i].CHKED == true) {
                        result.push(data[i])
                    }
                }
                if(result.length == 0){
                    qray.alert("체크된 데이터가 없습니다.");
                    return false;
                }
                var array = [];
                var resultCode = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, "CZ_Q0061");
                var docuF = resultCode[1].text;
                for (var i = 0; i < result.length; i++) {
                    if(docuF == '1'){
                        // IU 전표가 존재할때
                        if (nvl(result[i].IU_DOCUYN) != '') {
                            if (result[i].ST_ING == '01' || result[i].ST_ING == '03') {
                                array.push(result[i])
                            } else {
                                qray.alert("결재 처리된 전표는 취소하실수 없습니다.");
                                return false;
                            }
                        }else{
                            // IU 전표가 미존재할때
                            if(nvl(result[i].GROUP_NUMBER) == ''){
                                qray.alert("전표 미처리 데이터는 취소하실수 없습니다.");
                                return false;
                            }else {
                                array.push(result[i])
                            }
                        }
                    }else{
                        // IU 전표가 존재할때
                        if (nvl(result[i].IU_DOCUYN) != '') {
                            qray.alert("전표처리된 데이터는 취소하실수 없습니다.");
                            return false;
                        }else{
                            // IU 전표가 미존재할때
                            if(result[i].ST_ING == '02' ){
                                qray.alert("결재 진행중인 데이터는 취소하실수 없습니다.");
                                return false;
                            }else if(result[i].ST_ING == '04'){
                                qray.alert("결재승인 데이터는 취소하실수 없습니다.");
                                return false;
                            } else if(result[i].ST_ING != '04'){
                                qray.alert("전표 미처리 데이터는 취소하실수 없습니다.");
                                return false;
                            }else{
                                array.push(result[i])
                            }
                        }
                    }

                }
                return array;
            }

            // function isChecked(data) {
            //     var result = [];
            //     var length = 0;
            //     var chkBox = $("div .detailBox");
            //     for (var i = 0; i < chkBox.length; i++) {
            //         if (chkBox[i].getAttribute('data-ax5grid-checked') == "true") {
            //             var index = chkBox[i].id.split("detailBox")[1];
            //             result.push(fnObj.gridView01.target.list[index]);
            //             length++;
            //         }
            //     }
            //     return result;
            // }



            function checkDocu(value) {
                if (value) {
                    $("#JOB_TP select").attr("disabled", "disabled");
                    $("#JOB_TP a").attr("disabled", "disabled");
                } else {
                    $("#JOB_TP select").removeAttr("disabled");
                    $("#JOB_TP a").removeAttr("disabled");
                }
            }

            $('document').ready(function () {
                $("#cdPc").onStatePicker('change', function (e) {
                    $("#cdPc").attr('code', 'xxxxxxxx');
                    $("#cdPc").attr('text', e.value);
                });
                $("#CD_USERDEF1").change(function(){
                    var index = fnObj.gridView01.getData('selected')[0].__index;
                    fnObj.gridView01.target.setValue(index, "CD_USERDEF1", $("#CD_USERDEF1").val().replace(/-/g, ""));
                })
            });

            /***************** 사용자 함수 처리 끝***************************/

            /***************** 그리드 처리 ***************************/

                // 1. 그리드 처리 세팅 및 이벤트 처리
            var userCallBack;
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
                        target: $('[data-ax5grid="grid-view-01"]'),
                        // parentFlag:true,
                        // parentGrid: $(fnObj.gridView02),
                        childGrid: [$(fnObj.gridView02),$(fnObj.gridView03)],
                        childFlag:true,
                        url : ["apbucard", "getBucardList"],
                        param : [fnObj.searchView,'getData'],
                        showRowSelector: true,
                        columns: [
                            {
                                // key: "CHKED", label: "", width: 30, align: "center",
                                // label:
                                //     '<div id="headerBox" data-ax5grid-editor="checkbox" data-ax5grid-checked="false" data-ax5grid-column-selected="true" style="height:17px;width:17px;margin-top:2px;  onclick="javascript:alert(1);"></div>',
                                // formatter: function () {
                                //     return '<div class="detailBox" id="detailBox' + this.dindex + '" data-ax5grid-editor="checkbox" data-ax5grid-checked="false" data-ax5grid-column-selected="true" style="height:17px;width:17px;margin-top:2px;  onclick="javascript:alert(1);"></div>';
                                // }
                                key: "CHKED", label: "", width: 30, align: "center",
                                label:
                                    '<div id="headerBox" data-ax5grid-editor="checkbox" data-ax5grid-checked="false" data-ax5grid-column-selected="true" style="height:17px;width:17px;margin-top:2px;  onclick="javascript:alert(1);"></div>',
                                editor: {
                                    type: "checkbox", config: {height: 17, trueValue: true, falseValue: false}
                                }, dirty : false
                            },
                            {key: "BANK_CODE", label: "은행코드", width: 120, align: "left", editor: false, hidden: true },
                            {key: "TRADE_DATE", label: "승인일자", width: 100, align: "center", editor: false , sortable:true
                                ,formatter : function(){
                                    return $.changeDataFormat(this.value)
                                }
                            },
                            {key: "TRADE_TIME", label: "승인시간", width: 90, align: "center", editor: false, sortable:true,hidden:true
                                ,formatter : function(){
                                    return $.changeDataFormat(this.value,"time")
                                }
                            },
                            {key: "SEQ", label: "순번", width: 120, align: "center", editor: false, hidden: true},
                            {key: "ADMIN_GU", label: "취소여부", width: 80, align: "center", editor: false, required:true , sortable:true},
                            {key: "ACCT_NO", label: "카드번호", width: 140, align: "center", editor: false, sortable:true
                                ,formatter : function(){
                                    return $.changeDataFormat(this.value,"card")
                                }
                            },
                            {key: "TRADE_PLACE", label: "가맹점명", width: 120, align: "left", editor: false , sortable:true},
                            {key: "TP_JOB", label: "업종", width: 120, align: "left", editor: false, sortable:true , hidden:true},
                            {key: "ADMIN_AMT", label: "사용금액", width: 90, align: "right", sortable:true, editor: {type: "number"
                                    , disabled: function () {
                                        return true;
                                    }
                                }, formatter: "money"},
                            {key: "NM_NOTE", label: "적요", width: 120, align: "left", editor: false , sortable:true},
                            {key: "DT_DRAFT", label: "결재일자", width: 90, align: "center", sortable:true, editor: false
                                ,
                                formatter: function () {
                                    return $.changeDataFormat(this.value)
                                }
                            },
                            {key: "NM_DRAFT", label: "결재상태", width: 80, align: "center", editor: false, sortable:true},
                            {key: "YN_DOCU", label: "전표처리", width: 90, align: "center", editor: false, sortable:true},
                            {key: "IU_DOCUYN", label: "IU상태", width: 50, align: "center", editor: false
                                ,styleClass: function () {
                                    return "readonly";
                                }, sortable:true
                            },
                            {
                                key: "JOB_TP", label: "업무구분", width: 80, sortable:true, align: "center",
                                formatter: function () {
                                    return $.changeTextValue(CodeData4, this.value)
                                }
                                , editor: {
                                    type: "select", config: {
                                        columnKeys: {
                                            optionValue: "value", optionText: "text"
                                        },
                                        options: CodeData4
                                    }, disabled: function () {
                                        return true;
                                        // var NO_DOCU = fnObj.gridView01.getData('selected')[0].NO_DOCU;
                                        // if (nvl(NO_DOCU, '') != '') { return true; } else { return false;}
                                    }
                                },required:true
                            },
                            {key: "NO_DOCU", label: "전표번호", width: 120, align: "left", editor: false, hidden: false , sortable:true},
                            {key: "SUPPLY_AMT", label: "공급가액", width: 120, align: "right", editor: {type: "number"
                                    , disabled: function () {
                                        return true;
                                    }
                                }, formatter: "money", sortable:true, hidden:true
                            },
                            {key: "VAT_AMT", label: "부가세액", width: 120, align: "right", editor: {type: "number"
                                    , disabled: function () {
                                        return true;
                                    }
                                }, formatter: "money", sortable:true, hidden:true
                            },
                            {key: "NM_DEPT", label: "사용부서", width: 120, align: "left", editor: false, sortable:true},
                            {key: "NM_USER", label: "사용자", width: 120, align: "left", editor: false , sortable:true},
                            {key: "NM_CARD", label: "카드명", width: 120, align: "left", editor: false , sortable:true},
                            {key: "CD_PARTNER", label: "거래처코드", width: 120, align: "left", editor: false , sortable:true},
                            {key: "CD_TRADE_PLACE", label: "가맹점 사업자번호", width: 120, align: "center", editor: false , sortable:true, hidden:true
                                ,
                                formatter: function () {
                                    return $.changeDataFormat(this.value,"company")
                                }
                            },
                            {key: "MERC_ADDR", label: "주소", width: 120, align: "left", editor: false , sortable:true , hidden:true},
                            {key: "NO_DRAFT", label: "결재번호", width: 120, align: "right", editor: false,hidden: true},
                            {key: "CHK_BIZ_PURPOSE", label: "출장여부", width: 120, align: "right", editor: false, hidden:true},
                            {key: "CD_DEPT", label: "사용부서코드", width: 120, align: "left", editor: false,hidden: true},
                            {key: "NO_EMP", label: "사번", width: 120, align: "left", editor: false,hidden: true},
                            {key: "GROUP_NUMBER", label: "그룹넘버", width: 120, align: "left", editor: false, hidden: true},
                            {key: "COMMENTS", label: "사용내역", width: 120, align: "left", editor: false, hidden: true},
                            {key: "ST_ING", label: "결재상태코드", width: 120, align: "left", editor: false, hidden: true},
                            {key: "DT_ACCT", label: "회계일자", width: 120, align: "left", editor: false,hidden: true ,required:true },
                            {key: "CD_USERDEF1", label: "만기일자", width: 120, align: "left", editor: false,hidden: true},
                            {key: "uid", label: "", width: 10, align: "left", editor: false, hidden: true}
                        ],

                        body: {
                            trStyleClass: function () {
                                if (nvl(this.item.GROUP_NUMBER,'') != '' && nvl(this.item.NO_DOCU,'') == '') {
                                    return "red";

                                }
                            }
                            ,onDataChanged: function () {
                                if (this.key == "JOB_TP") {
                                    $("#JOB_TP").ax5select("setValue", nvl(this.value), true);
                                }
                            },
                            //444
                            onClick: function () {
                                var index = this.dindex;
                                if(afterIndex == index){return false;}
                                var data = fnObj.gridView02.getDirtyDataCount();

                                if(data > 0){
                                    qray.confirm({
                                        msg: "작업중인 데이터를 먼저 저장해주십시오."
                                        ,btns: {
                                            // ok: {
                                            //     label:'확인', onClick: function(key){
                                            //         fnObj.gridView01.target.select(index)
                                            //         ACTIONS.dispatch(ACTIONS.ITEM_CLICK, this.item);
                                            //         qray.close();
                                            //     }
                                            // },
                                            cancel: {
                                                label:'확인', onClick: function(key){
                                                    qray.close();
                                                }
                                            }
                                        }
                                    })
                                }else{
                                    this.self.select(this.dindex);
                                    ACTIONS.dispatch(ACTIONS.ITEM_CLICK, this.item);
                                }
                            }
                        },
                        onPageChange: function (pageNumber) {
                            _this.setPageData({pageNumber: pageNumber});
                            ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                        },
                        page: {
                            display: false,
                            statusDisplay: false
                        }
                    });
                },
                getData: function (_type) {
                    var list = [];
                    var _list = this.target.getList(_type);
                    list = _list;
                    return list;
                },
                getCheckData: function () {
                    var list = [];
                    $(this.target.getList()).each(function () {
                        if (this.s == "Y") {
                            list.push(this);
                        }
                    });
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
                        parentGrid: $(fnObj.gridView01),
                        parentFlag : true,
                        url : ["apbucard", "getBucardDetailList"],
                        param : [fnObj.gridView02,'selected'],
                        frozenColumnIndex: 0,
                        target: $('[data-ax5grid="grid-view-02"]'),
                        columns: [
                            {key: "NO_TAX", label: "", width: 80, align: "left", editor: false, hidden: true},
                            {key: "CD_COMPANY", label: "회사코드", width: 80, align: "left", editor: false, hidden: true},
                            {key: "ACCT_NO", label: "카드번호", width: 80, align: "left", editor: false, hidden: true},
                            {key: "BANK_CODE", label: "은행코드", width: 80, align: "left", editor: false, hidden: true},
                            {key: "TRADE_DATE", label: "매입일자", width: 80, align: "left", editor: false, hidden: true},
                            {key: "TRADE_TIME", label: "승인시간", width: 80, align: "left", editor: false, hidden: true},
                            {key: "SEQ", label: "순서", width: 80, align: "left", editor: false, hidden: true},
                            {key: "NO_ACCTLINE", label: "라인순서", width: 80, align: "left", editor: false, hidden: true},
                            {key: "CD_ACCT", label: "차변계정", width: 80, align: "left", editor: true, required: true ,hidden: false
                                ,picker: {
                                    top: _pop_top,
                                    width: 600,
                                    height: _pop_height,
                                    url: "buAcctCode",
                                    action: ["customHelp", "CUSTOM_HELP_BUACCT"],
                                    param: function () {
                                        return { TP_DRCR : '1' ,JOB_TP : $('select[name="JOB_TP"]').val() , CD_DEPT : fnObj.gridView02.getData('selected')[0].CD_DEPT}
                                    },
                                    callback: function (e) {
                                        var index = fnObj.gridView02.getData('selected')[0].__index;
                                        fnObj.gridView02.target.setValue(index, "CD_ACCT", e[0].CD_ACCT);
                                        fnObj.gridView02.target.setValue(index, "NM_ACCT", e[0].NM_ACCT);
                                       // fnObj.gridView02.target.setValue(index, "NM_DESC", e[0].NM_DESC);
                                    },
                                    disabled: function () {
                                        var itemH = fnObj.gridView01.getData("selected")[0];
                                        if(itemH.YN_DOCU == '처리'){
                                            return true;
                                        }else{
                                            return false;
                                        }
                                    }
                                }
                                ,styleClass: function () {
                                    return "red";
                                }
                            },
                            {key: "NM_ACCT", label: "차변계정명", width: 100, align: "left", editor: false, hidden: false},
                            {key: "TAX_GB",  label: "세무구분", width: 100, align: "left", editor: {
                                    type: "select", config: {
                                        columnKeys: {
                                            optionValue: "value", optionText: "text"
                                        },
                                        options: [{value:undefined,text:''}].concat(CodeData15)
                                    }
                                    , disabled: function () {
                                        var NO_DOCU = fnObj.gridView01.getData('selected')[0].NO_DOCU;
                                        if (nvl(NO_DOCU, '') != '' || tax_code_dr.indexOf(this.item.CD_ACCT) < 0) { return true; } else { return false;}
                                    }
                                }
                                ,formatter: function () {
                                    return $.changeTextValue([{value:'',text:''}].concat(CodeData15), this.value)
                                }, hidden: false},
                            {key: "NON_TAX", label: "불공제구분", width: 100, align: "left", editor: {
                                    type: "select", config: {
                                        columnKeys: {
                                            optionValue: "value", optionText: "text"
                                        },
                                        options: [{value:undefined,text:''}].concat(CodeData14)
                                    }
                                    , disabled: function () {
                                        var NO_DOCU = fnObj.gridView01.getData('selected')[0].NO_DOCU;
                                        if ( nvl(NO_DOCU, '') != '' || tax_code_dr.indexOf(this.item.CD_ACCT) < 0  || this.item.TAX_GB != '22') { return true; } else { return false;}
                                    }
                                },formatter: function () {
                                    return $.changeTextValue([{value:undefined,text:''}].concat(CodeData14), this.value)
                                }, hidden: false},
                            {key: "AMT", label: "금액", width: 80, align: "right"
                                ,editor: {type: "number"
                                    , disabled: function () {
                                        var NO_DOCU = fnObj.gridView01.getData('selected')[0].NO_DOCU;
                                        if (nvl(NO_DOCU, '') != '') { return true; } else { return false;}}
                                }
                                ,formatter: function () {
                                    return ax5.util.number(this.value, {"money": true});
                                }
                                ,styleClass: function () {
                                    return "red";
                                }
                            },
                            {key: "NM_DESC", label: "적요", width: 120, align: "left", editor: {type:"text"} ,required: true
                                ,styleClass: function () {
                                    return "red";
                                }
                                },
                            {key: "CD_CC", label: "코스트센터", width: 80, align: "center", editor: true, hidden : true
                                ,styleClass: function () {
                                    return "red";
                                }
                            },
                            {key: "NM_CC", label: "코스트센터명", width: 80, align: "left", editor: false, hidden: false,required: true
                                ,picker: {
                                    top: _pop_top,
                                    width: 600,
                                    height: _pop_height,
                                    url: "cc",
                                    action: ["commonHelp", "HELP_CC"],
                                    callback: function (e) {
                                        var index = fnObj.gridView02.getData('selected')[0].__index;
                                        fnObj.gridView02.target.setValue(index, "CD_CC", e[0].CD_CC);
                                        fnObj.gridView02.target.setValue(index, "NM_CC", e[0].NM_CC);
                                        fnObj.gridView02.target.setValue(index, "CD_BUDGET", e[0].CD_BUDGET);
                                        fnObj.gridView02.target.setValue(index, "NM_BUDGET", e[0].NM_BUDGET);
                                    },
                                    disabled: function () {
                                        var itemH = fnObj.gridView01.getData("selected")[0];
                                        if(itemH.YN_DOCU == '처리'){
                                            return true;
                                        }else{
                                            return false;
                                        }
                                    }
                                },styleClass: function () {
                                    return "red";
                                }
                            },
                            {key: "CD_ACCT_CR", label: "대변계정", width: 80, align: "left", editor: true, hidden: false, required: true
                                ,picker: {
                                    top: _pop_top,
                                    width: 600,
                                    height: _pop_height,
                                    url: "buAcctCode",
                                    action: ["customHelp", "CUSTOM_HELP_BUACCT"],
                                    param: function () {
                                        return { TP_DRCR : '2' ,JOB_TP : $('select[name="JOB_TP"]').val() }
                                    },
                                    callback: function (e) {
                                        console.log(e   ,'<<<<대변');
                                        var index = fnObj.gridView02.getData('selected')[0].__index;
                                        fnObj.gridView02.target.setValue(index, "CD_ACCT_CR", e[0].CD_ACCT);
                                        fnObj.gridView02.target.setValue(index, "NM_ACCT_CR", e[0].NM_ACCT);
                                    },
                                    disabled: function () {
                                        var itemH = fnObj.gridView01.getData("selected")[0];
                                        if(itemH.YN_DOCU == '처리'){
                                            return true;
                                        }else{
                                            return false;
                                        }
                                    }
                                }
                                ,styleClass: function () {
                                    return "red";
                                }
                            },
                            {key: "NM_ACCT_CR", label: "대변계정명", width: 80, align: "left", editor: false},
                            {key: "CD_BUDGET", label: "예산단위", width: 80, align: "left", editor: true , hidden: true},
                            {key: "NM_BUDGET", label: "예산단위명", width: 80, align: "left", editor: false
                                ,picker: {
                                    top: _pop_top,
                                    width: 600,
                                    height: _pop_height,
                                    url: "budget",
                                    action: ["commonHelp", "HELP_BUDGET"],
                                    param : function(){
                                        return {CD_DEPT : fnObj.gridView02.getData("selected")[0].CD_DEPT}
                                    },
                                    callback: function (e) {
                                        var index = fnObj.gridView02.getData('selected')[0].__index;
                                        fnObj.gridView02.target.setValue(index, "CD_BUDGET", e[0].CD_BUDGET);
                                        fnObj.gridView02.target.setValue(index, "NM_BUDGET", e[0].NM_BUDGET);

                                        fnObj.gridView02.target.setValue(index, "CD_CC", e[0].CD_CC);
                                        fnObj.gridView02.target.setValue(index, "NM_CC", e[0].NM_CC);
                                        var result = $.DATA_SEARCH("commonHelp", "HELP_BGACCT", { CD_ACCT : fnObj.gridView02.getData('selected')[0].CD_ACCT , CD_BUDGET : fnObj.gridView02.getData('selected')[0].CD_BUDGET}).list;
                                        if(result.length > 0){
                                            fnObj.gridView02.target.setValue(index, "CD_BGACCT", result[0].CD_BGACCT);
                                            fnObj.gridView02.target.setValue(index, "NM_BGACCT", result[0].NM_BGACCT);
                                        }else{
                                            fnObj.gridView02.target.setValue(index, "CD_BGACCT", '');
                                            fnObj.gridView02.target.setValue(index, "NM_BGACCT", '');
                                        }

                                    },
                                    disabled: function () {
                                        var itemH = fnObj.gridView01.getData("selected")[0];
                                        if(itemH.YN_DOCU == '처리'){
                                            return true;
                                        }else{
                                            return false;
                                        }
                                    }
                                }
                            },
                            {key: "CD_BGACCT", label: "예산계정", width: 80, align: "left", editor: true, hidden: true},
                            {key: "NM_BGACCT", label: "예산계정명", width: 80, align: "left", editor: false, hidden: false
                                ,picker: {
                                    top: _pop_top,
                                    width: 600,
                                    height: _pop_height,
                                    url: "bgAcct",
                                    action: ["commonHelp", "HELP_BGACCT"],
                                    param : function(){
                                        return { CD_ACCT : fnObj.gridView02.getData('selected')[0].CD_ACCT , CD_BUDGET : fnObj.gridView02.getData('selected')[0].CD_BUDGET}
                                    },
                                    callback: function (e) {
                                        var index = fnObj.gridView02.getData('selected')[0].__index;
                                        fnObj.gridView02.target.setValue(index, "CD_BGACCT", e[0].CD_BGACCT);
                                        fnObj.gridView02.target.setValue(index, "NM_BGACCT", e[0].NM_BGACCT);
                                    },
                                    disabled: function () {
                                        var itemH = fnObj.gridView01.getData("selected")[0];
                                        if(itemH.YN_DOCU == '처리'){
                                            return true;
                                        }else{
                                            return false;
                                        }
                                    }
                                }
                            },
                            {key: "CD_BIZCAR", label: "업무용승용차코드", width: 80, align: "left", editor: true, hidden: true},
                            {key: "NM_BIZCAR", label: "업무승용차명", width: 100, align: "left", editor: false, hidden: false
                                ,picker: {
                                    top: _pop_top,
                                    width: 600,
                                    height: _pop_height,
                                    url: "bizCar",
                                    action: ["commonHelp", "HELP_BIZCAR"],
                                    callback: function (e) {
                                        var index = fnObj.gridView02.getData('selected')[0].__index;
                                        fnObj.gridView02.target.setValue(index, "CD_BIZCAR", e[0].CD_BIZCAR);
                                        fnObj.gridView02.target.setValue(index, "NM_BIZCAR", e[0].NM_BIZCAR);
                                    },
                                    disabled: function () {
                                        var itemH = fnObj.gridView01.getData("selected")[0];
                                        if(itemH.YN_DOCU == '처리'){
                                            return true;
                                        }else{
                                            return false;
                                        }
                                    }
                                }
                            },
                            {key: "NO_EMP", label: "실사용자사번", width: 80, align: "left", editor: {type:"text"},required: true , hidden: true
                                ,picker: {
                                    top: _pop_top,
                                    width: 600,
                                    height: _pop_height,
                                    url: "user",
                                    action: ["commonHelp", "HELP_EMP"],
                                    param: function () {
                                        // return { P_CD_DEPT : fnObj.gridView02.getData('selected')[0].CD_CC }
                                    },
                                    callback: function (e) {
                                        var index = fnObj.gridView02.getData('selected')[0].__index;
                                        addRowDefault = $.DATA_SEARCH('apbucard', 'acctAddRow', {
                                            JOB_TP: $("#JOB_TP select[name='JOB_TP']").val(),
                                            CD_DEPT: e[0].CD_DEPT
                                        });
                                        var result = $.DATA_SEARCH('commonHelp','HELP_BUDGET',{CD_DEPT: nvl(e[0].CD_DEPT,'XXXXXX')});
                                        if(result.list.length > 0){
                                            fnObj.gridView02.target.setValue(index, "CD_BUDGET", nvl(result.list[0].CD_BUDGET,undefined));
                                            fnObj.gridView02.target.setValue(index, "NM_BUDGET", nvl(result.list[0].NM_BUDGET,undefined));
                                        }else{
                                            fnObj.gridView02.target.setValue(index, "CD_BUDGET", undefined);
                                            fnObj.gridView02.target.setValue(index, "NM_BUDGET", undefined);
                                        }
                                        if(addRowDefault.list[1]){
                                            fnObj.gridView02.target.setValue(index, "NM_CC", addRowDefault.list[1].NM_CC);
                                            fnObj.gridView02.target.setValue(index, "CD_CC", addRowDefault.list[1].CD_CC);
                                            // fnObj.gridView02.target.setValue(index, "CD_BUDGET", addRowDefault.list[1].CD_BUDGET);
                                            // fnObj.gridView02.target.setValue(index, "NM_BUDGET", addRowDefault.list[1].NM_BUDGET);
                                        }
                                        fnObj.gridView02.target.setValue(index, "NO_EMP", e[0].NO_EMP);
                                        fnObj.gridView02.target.setValue(index, "NM_KOR", e[0].NM_EMP);
                                        fnObj.gridView02.target.setValue(index, "CD_DEPT", e[0].CD_DEPT);
                                        fnObj.gridView02.target.setValue(index, "NM_DEPT", e[0].NM_DEPT)
                                        //
                                        // fnObj.gridView02.target.setValue(index, "NO_EMP", e[0].NO_EMP);
                                        // fnObj.gridView02.target.setValue(index, "NM_KOR", e[0].NM_EMP);
                                        // fnObj.gridView02.target.setValue(index, "CD_DEPT", e[0].CD_DEPT);
                                    },
                                    disabled: function () {
                                        var itemH = fnObj.gridView01.getData("selected")[0];
                                        if(itemH.YN_DOCU == '처리'){
                                            return true;
                                        }else{
                                            return false;
                                        }
                                    }
                                }
                                ,styleClass: function () {
                                    return "red";
                                }

                            },
                            {key: "NM_KOR", label: "실사용자명", width: 80, align: "left", editor: false, hidden: true},
                            {key: "DESTINATION", label: "행선지", width: 80, align: "left"
                                , editor: {type: "text"
                                    , disabled: function () {
                                        var NO_DOCU = fnObj.gridView01.getData('selected')[0].NO_DOCU;
                                        if (nvl(NO_DOCU, '') != '') { return true; } else { return false;}}
                                }, hidden: true},
                            {
                                key: "PURPOSE", label: "사용목적", width: 100, align: "left",
                                formatter: function () {
                                    return $.getComboText(CodeData, this.value)
                                }
                                , editor: {
                                    type: "select", config: {
                                        columnKeys: {
                                            optionValue: "CODE", optionText: "NAME"
                                        },
                                        options: CodeData
                                    }, disabled: function () {
                                        var NO_DOCU = fnObj.gridView01.getData('selected')[0].NO_DOCU;
                                        if (nvl(NO_DOCU, '') != '') { return true; } else { return false;}}
                                }, hidden: true
                            },
                            {key: "AMT0", label: "예산금액", width: 80, align: "right", editor: false, formatter: "money", hidden: true},
                            {key: "AMT1", label: "집행금액", width: 80, align: "right", editor: false   , formatter: "money", hidden: true},
                            {key: "CD_PARTNER", label: "거래처코드", width: 80, align: "right", editor: false , hidden : true},
                            {key: "LN_PARTNER", label: "거래처명", width: 80, align: "right", editor: false , hidden : true},
                            {key: "S_IDNO", label: "사업자번호", width: 80, align: "right", editor: false , hidden : true} ,
                            {key: "NM_USERDEF1", label: "가맹점명", width: 80, align: "right", editor: false , hidden : true},
                            {key: "CD_DEPT", label: "", width: 80, align: "right", editor: false, hidden: true},
                            {key: "NM_DEPT", label: "", width: 80, align: "right", editor: false, hidden: true},
                            {key: "IU_ST", label: "", width: 80, align: "right", editor: false, hidden: true},

                        ],
                        body: {
                            onClick: function () {

                                var itemH = fnObj.gridView01.getData("selected")[0];
                                if(itemH.YN_DOCU == '처리'){
                                    return false;
                                }
                                this.self.select(this.dindex);
                                var index = this.dindex;
                                // if (this.column.key == "CD_ACCT") {
                                //     userCallBack = function (e) {
                                //         if (e.length > 0) {
                                //             fnObj.gridView02.target.setValue(index, "CD_ACCT", e[0].CD_ACCT);
                                //             fnObj.gridView02.target.setValue(index, "NM_ACCT", e[0].NM_ACCT);
                                //             fnObj.gridView02.target.setValue(index, "NM_DESC", e[0].NM_DESC);
                                //             // fnObj.gridView02.target.setValue(actionRowIdxB, "AMT", 0);
                                //         }
                                //         modal.close();
                                //     };
                                //     var initData = {TP_DRCR: '1', JOB_TP: $('select[name="JOB_TP"]').val()};
                                //     $.openCustomPopup("buAcctCode", "userCallBack", "CUSTOM_HELP_BUACCT", initData,null,600,_pop_height,_pop_top);
                                //
                                // } else if (this.column.key == "NM_CC") {
                                //     userCallBack = function (e) {
                                //         if (e.length > 0) {
                                //             fnObj.gridView02.target.setValue(index, "CD_CC", e[0].CD_CC);
                                //             fnObj.gridView02.target.setValue(index, "NM_CC", e[0].NM_CC);
                                //             fnObj.gridView02.target.setValue(index, "CD_BUDGET", e[0].CD_BUDGET);
                                //             fnObj.gridView02.target.setValue(index, "NM_BUDGET", e[0].NM_BUDGET);
                                //         }
                                //         modal.close();
                                //     };
                                //     $.openCommonPopup("cc", "userCallBack", "HELP_CC",null,null,600,_pop_height,_pop_top);
                                //
                                // } else if (this.column.key == "CD_ACCT_CR") {
                                //     userCallBack = function (e) {
                                //         if (e.length > 0) {
                                //             fnObj.gridView02.target.setValue(index, "CD_ACCT_CR", e[0].CD_ACCT);
                                //             fnObj.gridView02.target.setValue(index, "NM_ACCT_CR", e[0].NM_ACCT);
                                //         }
                                //         modal.close();
                                //     };
                                //     var initData = {TP_DRCR: '2', JOB_TP: $('select[name="JOB_TP"]').val()};
                                //     $.openCustomPopup("buAcctCode", "userCallBack", "CUSTOM_HELP_BUACCT", initData,null,600,_pop_height,_pop_top);
                                // } else if (this.column.key == "NM_BUDGET") {
                                //     userCallBack = function (e) {
                                //         if (e.length > 0) {
                                //             fnObj.gridView02.target.setValue(index, "CD_BUDGET", e[0].CD_BUDGET);
                                //             fnObj.gridView02.target.setValue(index, "NM_BUDGET", e[0].NM_BUDGET);
                                //         }
                                //         modal.close();
                                //     };
                                //     var item = fnObj.gridView01.getData("selected")[0];
                                //     $.openCommonPopup("budget", "userCallBack", "HELP_BUDGET",item.CD_BUDGET,{CD_DEPT : item.CD_DEPT},600,_pop_height,_pop_top);
                                // } else if (this.column.key == "NM_KOR") {
                                //     userCallBack = function (e) {
                                //         if (e.length > 0) {
                                //             fnObj.gridView02.target.setValue(index, "NO_EMP", e[0].NO_EMP);
                                //             fnObj.gridView02.target.setValue(index, "NM_KOR", e[0].NM_EMP);
                                //         }
                                //         modal.close();
                                //     };
                                //     $.openCommonPopup("user", "userCallBack", "HELP_USER",null,null,600,_pop_height,_pop_top);
                                // } else if (this.column.key == "NM_BGACCT") {
                                //     userCallBack = function (e) {
                                //         if (e.length > 0) {
                                //             fnObj.gridView02.target.setValue(index, "CD_BGACCT", e[0].CD_BGACCT);
                                //             fnObj.gridView02.target.setValue(index, "NM_BGACCT", e[0].NM_BGACCT);
                                //         }
                                //         modal.close();
                                //     };
                                //
                                //     $.openCommonPopup("bgAcct", "userCallBack", "HELP_BGACCT",'',{ CD_ACCT : fnObj.gridView02.getData('selected')[0].CD_ACCT},600,_pop_height,_pop_top);
                                // } else if (this.column.key == "NM_BIZCAR") {
                                //     userCallBack = function (e) {
                                //         if (e.length > 0) {
                                //             fnObj.gridView02.target.setValue(index, "CD_BIZCAR", e[0].CD_BIZCAR);
                                //             fnObj.gridView02.target.setValue(index, "NM_BIZCAR", e[0].NM_BIZCAR);
                                //         }
                                //         modal.close();
                                //     };
                                //     $.openCommonPopup("bizCar", "userCallBack", "HELP_BIZCAR",null,null,600,_pop_height,_pop_top);
                                // }

                                //접대비
                                if (this.column.key == 'AMT' && tax_code_recept.indexOf(this.item.CD_ACCT) > 0) {
                                    var data = fnObj.gridView01.getData('selected')[0];
                                    var initData = {
                                        CD_ACCT: this.item.CD_ACCT,
                                        NM_ACCT: this.item.NM_ACCT,
                                        DT_ACCT: $("#DT_ACCT").val().replace(/-/g, ""),
                                        CD_DEPT: this.item.CD_DEPT,
                                        NM_DEPT: this.item.NM_DEPT,
                                        CD_EMP: this.item.NO_EMP,
                                        NM_EMP: this.item.NM_KOR,
                                        ACCT_NO: data.ACCT_NO,
                                        NM_CARD: data.NM_CARD,
                                        TPDRCR: '1',
                                        index: this.dindex,
                                        ADDPARAM: nvl(this.item.NO_TAX, ""),
                                        GUBUN: '1',
                                        BC_ACCT_NO: data.ACCT_NO,
                                        BC_BANK_CODE: data.BANK_CODE,
                                        BC_TRADE_DATE: data.TRADE_DATE,
                                        BC_TRADE_TIME: data.TRADE_TIME,
                                        BC_SEQ: data.SEQ,
                                        BC_NO_ACCTLINE: this.dindex + 1,
                                        AMT : this.item.AMT
                                    };
                                    console.log("접대비 팝업으로 보내는 데이터 : ", initData);
                                    initDatas = function (caller, act, data) {  //  자식창에 넘겨줄 데이터
                                        return {
                                            "initData": initData
                                        };
                                    };
                                    modal.open({
                                        width: 900,
                                        height: _pop_height700,
                                        top:_pop_top700,
                                        iframe: {
                                            method: "get",
                                            url: "../../custom/receptHelper.jsp",
                                            param: "callBack=vatCallBack"
                                        },
                                        sendData: initDatas,
                                        onStateChanged: function () {
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
                            },
                            onDataChanged: function () {
                                //11
                                if (this.key == 'CD_ACCT') {
                                    var data = $.DATA_SEARCH('apbucard', 'bgacctSetting', {
                                        CD_ACCT: this.item.CD_ACCT,
                                        CD_BUDGET: this.item.CD_BUDGET
                                    });
                                    if (data.list.length > 0) {
                                        fnObj.gridView02.target.setValue(this.dindex, "NM_BGACCT", data.list[0].NM_BGACCT);
                                        fnObj.gridView02.target.setValue(this.dindex, "CD_BGACCT", data.list[0].CD_BGACCT);
                                    } else {
                                        fnObj.gridView02.target.setValue(this.dindex, "NM_BGACCT", '');
                                        fnObj.gridView02.target.setValue(this.dindex, "CD_BGACCT", '');
                                    }
                                    fnObj.gridView02.target.setValue(this.dindex, "NO_TAX", undefined);
                                    fnObj.gridView02.target.setValue(this.dindex, "NON_TAX", undefined);
                                    fnObj.gridView02.target.setValue(this.dindex, "TAX_GB", undefined);
                                }
                                if (this.key == 'TAX_GB') {
                                    fnObj.gridView02.target.setValue(this.dindex, "NON_TAX", undefined);
                                }
                                //예산통제 팝업
                                if (this.key == 'AMT' || this.key == 'CD_ACCT') {
                                    if (this.item.CD_BGACCT && this.item.CD_BUDGET && this.item.CD_ACCT && this.item.AMT) {
                                        // if (this.key == 'AMT') {
                                        var self = this.item;
                                        var ListD = fnObj.gridView02.getData();
                                        var sum_amt = 0;
                                        for (var i = 0; i < ListD.length; i++) {
                                            if (ListD[i].CD_BGACCT == self.CD_BGACCT && ListD[i].CD_BUDGET == self.CD_BUDGET && ListD[i].CD_ACCT == self.CD_ACCT) {
                                                sum_amt += Number(ListD[i].AMT)
                                            }
                                        }
                                        var result = $.DATA_SEARCH('apbucard', 'acctBudgetAmt', {
                                            CD_BGACCT: self.CD_BGACCT,
                                            CD_BUDGET: self.CD_BUDGET,
                                            DT_ACCT: $("#DT_ACCT").val().replace(/-/g, ""),
                                            APPLY_AMT: sum_amt
                                        });
                                        console.log(result, '<<<<<<<<<<<<<<<<<< 예산 IU 통제');
                                        if (result) {
                                            if (result.list[0].POPUP_YN == 'N') {
                                                return false;
                                            }
                                        }

                                        /* 공통코드 예산팝업 제어
                                        var chk1 = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, "CZ_Q0020");
                                        if(chk1[1].text == 'N'){
                                            return false;
                                        }
                                         */
                                        fnObj.gridView02.target.setValue(this.dindex, "AMT0", result.list[0].AMT0);
                                        fnObj.gridView02.target.setValue(this.dindex, "AMT1", result.list[0].AMT1);
                                        console.log("예산통제 팝업으로 보내는 데이터 : ", result);
                                        var data = {
                                            CD_BGACCT: this.item.CD_BGACCT,
                                            CD_BUDGET: this.item.CD_BUDGET,
                                            CD_ACCT: this.item.CD_ACCT,
                                            AMT0: result.list[0].AMT0, //실행
                                            AMT1: result.list[0].AMT1, //집행
                                            AMT2: result.list[0].AMT2, //잔여
                                            APPLY_AMT: sum_amt,       //신청
                                            OVER_AMT: result.list[0].OVER_AMT //초과
                                        };
                                        $.openCommonPopup('budgetControl', "", '', '', data, 500, 380, _pop_top380);
                                        // }
                                    }
                                }
                            }
                        },
                        onPageChange: function (pageNumber) {
                            _this.setPageData({pageNumber: pageNumber});
                            ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                        },
                        page: {
                            display: false,
                            statusDisplay: false
                        }
                    });

                    axboot.buttonClick(this, "data-grid-view-02-btn", {
                        "add": function () {
                            ACTIONS.dispatch(ACTIONS.ITEM_ADD2);
                        },
                        "cardsplit": function () {
                            $.openCustomPopup("splitBucard", "", "CUSTOM_HELP_BIZTRIP_BUCARD", [], '', _pop_width1200, _pop_height800,_pop_top800);
                        },
                        "delete": function () {
                            var beforeIdx = fnObj.gridView02.target.selectedDataIndexs[0];
                            var dataLen = fnObj.gridView02.target.getList().length;

                            if ((beforeIdx + 1) == dataLen) {
                                beforeIdx = beforeIdx - 1;
                            }

                            ACTIONS.dispatch(ACTIONS.ITEM_DEL2);
                            if (beforeIdx > 0 || beforeIdx == 0) {
                                fnObj.gridView02.target.select(beforeIdx);
                                selectRow2 = beforeIdx;
                            }
                        }
                    });

                    axboot.buttonClick(this, "data-grid-view-03-btn", {
                        "add": function () {

                        },
                        "delete": function () {

                        },
                        "bnftBtn": function () {

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
                    if(fnObj.gridView02.target.list.length == 0){
                        this.target.addRow({__created__: true, AMT:fnObj.gridView01.getData('selected')[0].ADMIN_AMT}, "last");
                    }else{
                        this.target.addRow({__created__: true , AMT:0}, "last");
                    }

                },
                lastRow: function () {
                    return ($("div [data-ax5grid='grid-view-02']").find("div [data-ax5grid-panel='body'] table tr").length)
                },
                selected : function(){
                    return fnObj.gridView01.getData('selected')[0]
                }
            });

            function vatCallBack(map) {
                console.log(map);
                fnObj.gridView02.target.setValue(map.get("index"), "NO_TAX", map.get("ADDPARAM"));
                fnObj.gridView02.target.setValue(map.get("index"), "AMT", map.get("AMT"))
            }

            //미처리전표일때
            function BtnDisabled() {
                // $("#BtnSearch").attr('disabled', true);
                $("#BtnSave").attr('disabled', true);
                $("#BtnDocu").attr('disabled', true);
                $("#BtnDocu2").attr('disabled', true);
                // $("#BtnCancel").attr('disabled', false);

                $("#ADD1").attr('disabled', true);
                $("#ADD2").attr('disabled', true);
            }
            //전표처리된 데이터일때
            function BtnEnabled() {
                // $("#BtnSearch").attr('disabled', false);
                $("#BtnSave").attr('disabled', false);
                $("#BtnDocu").attr('disabled', false);
                $("#BtnDocu2").attr('disabled', false);
                // $("#BtnCancel").attr('disabled', true);

                $("#ADD1").attr('disabled', false);
                $("#ADD2").attr('disabled', false);
            }
            /***************** 그리드 처리 끝***************************/
            $('window').ready(function () {
                $("#cdEmp").setPicker([{code: SCRIPT_SESSION.noEmp, text: SCRIPT_SESSION.nmEmp}]);
                $("#cdDept").setPicker([{code: SCRIPT_SESSION.cdDept, text: SCRIPT_SESSION.nmDept}]);
            });

            function menuOpen(item){
                var param = item.join("|");
                parent.fnObj.tabView.urlSetData({GROUP_NUMBER : param});
                menuInfo = {menuId: "10506", id: "10506",  menuNm: "전표조회상신관리" ,name: "전표관리" , parentId : "5" , progNm: "전표조회", progPh: "/jsp/ensys/gl/p_cz_q_gl_docu_s.jsp"};
                try{
                    parent.fnObj.tabView.close("10506");
                }catch(e){

                }
                parent.fnObj.tabView.open(menuInfo);
            }

            function validation(paramData){
                var self = fnObj.gridView02;
                var config = self.target.columns;
                var requiredList = [];
                var data = paramData;
                config.forEach(function (item, index) {
                    if (nvl(item.required, false)) {
                        requiredList.push(item)
                    }
                });
                console.log(requiredList);
                for (var i = 0; i < data.length; i++) {
                    for (var j = 0; j < requiredList.length; j++) {
                        if (data[i][requiredList[j].key] == undefined || data[i][requiredList[j].key] == null || data[i][requiredList[j].key] == '') {
                            qray.alert(requiredList[j].label + " 는(은) 필수항목입니다.");
                            return true;
                        }
                    }
                }

            }
            var cnt = 0;
            $(document).on('click', '#headerBox', function(e) {
                if(cnt == 0){
                    $("div [data-ax5grid='grid-view-01']").find("div #headerBox").attr("data-ax5grid-checked",true);
                    cnt++;
                    var gridList = fnObj.gridView01.getData();
                    gridList.forEach(function(e, i){
                        fnObj.gridView01.target.setValue(i,"CHKED",true);
                    });
                    $("div [data-ax5grid-editor='checkbox']").attr("data-ax5grid-checked",true)
                }else{
                    $("div [data-ax5grid='grid-view-01']").find("div #headerBox").attr("data-ax5grid-checked",false);
                    cnt = 0;
                    var gridList = fnObj.gridView01.getData();
                    gridList.forEach(function(e, i){
                        fnObj.gridView01.target.setValue(i,"CHKED",false);
                    });
                    $("div [data-ax5grid-editor='checkbox']").attr("data-ax5grid-checked",false)
                }

            });

            // var cnt = 0;
            // $(document).on('click', '#headerBox', function (caller) {
            //     var gridList = fnObj.gridView01.target.list;
            //
            //     if (cnt == 0) {
            //         cnt++;
            //
            //         $("div [data-ax5grid='grid-view-01']").find("div #headerBox").attr("data-ax5grid-checked", true);
            //
            //         $("div .detailBox").attr("data-ax5grid-checked", true);
            //
            //     } else {
            //         cnt = 0;
            //
            //         $("div [data-ax5grid='grid-view-01']").find("div #headerBox").attr("data-ax5grid-checked", false);
            //
            //         $("div .detailBox").attr("data-ax5grid-checked", false);
            //
            //     }
            //
            // });

            var detailCnt = 0;
            $(document).on('click', '.detailBox', function (caller) {
                var chk = ($(this).attr("data-ax5grid-checked") == 'true') ? true : false;

                if (chk) {
                    $(this).attr("data-ax5grid-checked", false);
                } else {
                    $(this).attr("data-ax5grid-checked", true);
                }
            });

            //////////////////////////////////////
            //크기자동조정
            var _pop_top = 0;
            var _pop_top180 = 0;
            var _pop_top380 = 0;
            var _pop_top450 = 0;
            var _pop_top700 = 0;
            var _pop_top800 = 0;
            var _pop_width1200 = 0;
            var _pop_height = 0;
            var _pop_height700 = 0;
            var _pop_height800 = 0;
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
                    _pop_height700 = 700;
                    _pop_height800 = 800;
                    _pop_top = parseInt((totheight - _pop_height) / 2);
                    _pop_top180 = parseInt((totheight - 180) / 2);
                    _pop_top380 = parseInt((totheight - 380) / 2);
                    _pop_top450 = parseInt((totheight - 450) / 2);
                    _pop_top700 = parseInt((totheight - 700) / 2);
                    _pop_top800 = parseInt((totheight - 800) / 2);
                    _pop_width1200 = 1200;
                }
                else{
                    _pop_height = totheight / 10 * 8;
                    _pop_height700 = totheight / 10 * 9;
                    _pop_height800 = totheight / 10 * 9;
                    _pop_top = parseInt((totheight - _pop_height) / 2);
                    _pop_top180 = parseInt((totheight - 180) / 2);
                    _pop_top380 = parseInt((totheight - 380) / 2);
                    _pop_top450 = parseInt((totheight - 450) / 2);
                    _pop_top700 = parseInt((totheight - _pop_height700) / 2);
                    _pop_top800 = parseInt((totheight - _pop_height800) / 2);
                    _pop_width1200 = 900;
                }

                if(totheight < 550){
                    $("#pgun").css("display","none");
                }
                else{
                    $("#pgun").css("display","");
                }

                $("#cdPc").attr("HEIGHT",_pop_height);
                $("#cdPc").attr("TOP",_pop_top);
                $("#cdDept").attr("HEIGHT",_pop_height);
                $("#cdDept").attr("TOP",_pop_top);
                $("#cdEmp").attr("HEIGHT",_pop_height);
                $("#cdEmp").attr("TOP",_pop_top);

                //데이터가 들어갈 실제높이
                var datarealheight = $("#ax-base-root").height() - $(".ax-base-title").height() - $("#pageheader").height();
                //타이틀을 뺀 상하단 그리드 합친높이
                var tempgridheight = datarealheight - $("#middle_wrap").height() - $("#top_title").height() - $("#bottom_title").height();

                $("#top_grid").css("height",tempgridheight /100 * 60);
                $("#bottom_grid").css("height",tempgridheight /100 * 39);

                /*
                alert($("#ax-base-root").height()); // 컨텐츠영역높이
                ax-base-title //타이틀부분높이(class)
                ax-base-content //검색조건높이(class)
                 */
            }

            $('#next1').click(function(){
                var tt = new Date();
                var y = tt.getFullYear();
                var m = tt.getMonth()-1;
                var d = tt.getDate();
                if(m < 10){
                    m = '0'+String(m)
                }
                var ld = String(new Date(y,m,0).getDate());

                var last = y+'-'+m+'-'+ld;

                var dtF = ax5.util.date();
                var dtT = ax5.util.date();

                $("#tradeDateF").val(y+'-'+m+'-'+'01');
                $("#tradeDateT").val(last);
            });

            $('#next2').click(function(){
                var tt = new Date();
                var y = tt.getFullYear();
                var m = tt.getMonth();
                var d = tt.getDate();
                if(m < 10){
                    m = '0'+String(m)
                }
                var ld = String(new Date(y,m,0).getDate());

                var last = y+'-'+m+'-'+ld;

                var dtF = ax5.util.date();
                var dtT = ax5.util.date();

                $("#tradeDateF").val(y+'-'+m+'-'+'01');
                $("#tradeDateT").val(last);
            })
        </script>

    </jsp:attribute>
    <jsp:body>
        <div data-page-buttons="">
            <div class="button-warp">
                <button type="button" class="btn btn-reload" data-page-btn="reload" onclick="window.location.reload();" style="width:80px;">
                    <i class="icon_reload"></i></button>
                <button type="button" class="btn btn-info" data-page-btn="search" id="BtnSearch" style="width:80px;"><i
                        class="icon_search"></i><ax:lang
                        id="ax.admin.sample.modal.button.search"/></button>
                <button type="button" class="btn btn-info" data-page-btn="save" id="BtnSave" style="width:80px;"><i class="icon_save"></i>저장
                </button>
                    <%--                <button type="button" class="btn btn-info" data-page-btn="docu" id="BtnDocu" style="width:120px;"><i class="icon_ok"></i>건별전표처리--%>
                    <%--                </button>--%>
                <button type="button" class="btn btn-info" data-page-btn="docuMulti" id="BtnDocu2" style="width:80px;"><i
                        class="icon_ok"></i>전표처리
                </button>
                <button type="button" class="btn btn-info" data-page-btn="cancel" id="BtnCancel" style="width:80px"><i class="icon_reject"></i>전표취소</button>
                <button type="button" class="btn btn-info" data-page-btn="apply" style="width:80px;" style="width:80px"><i class="icon_ok"></i>결재요청</button>
<%--                <button type="button" class="btn btn-info" data-grid-view-02-btn="cardsplit" id="CARDSPLIT"><i--%>
<%--                        class="icon_add"></i> <ax:lang id="ax.admin.cardSplit"/></button>--%>
                    <%--                <button type="button" class="btn btn-info" data-page-btn="cancel" id="BtnCancel"><i--%>
                    <%--                        class="icon_slip"></i>전표취소--%>
                    <%--                </button>--%>
            </div>
        </div>
        <style>
            .testtest{
                width: 1%;
                white-space: nowrap;
                vertical-align: middle;
                padding: 3px 6px;
                font-size: 12px;
                font-weight: normal;
                line-height: 1;
                color: #555555;
                text-align: center;
                background-color: #eeeeee;
                border: 1px solid #ccc;
                display: table-cell;
            }
        </style>
        <div role="page-header" id="pageheader">
            <ax:form name="binder-form">
                <ax:tbl clazz="ax-search-tb1" minWidth="400px">
                    <ax:tr>
                        <ax:td label='회계단위' width="300px">
                            <codepicker id="cdPc" HELP_ACTION="HELP_PC" HELP_URL="pc" BIND-CODE="CD_PC"
                                        BIND-TEXT="NM_PC" HELP_DISABLED="true" SESSION/>
                        </ax:td>
                        <ax:td label='사용부서' width="350px">
                            <multipicker id="cdDept" HELP_ACTION="HELP_DEPT" HELP_URL="multiDept"
                                         BIND-CODE="CD_DEPT"
                                         BIND-TEXT="NM_DEPT"/>
                        </ax:td>
                        <ax:td label='카드승인일자' width="450px">

                            <div class="input-group" data-ax5picker="basic">
                                <span class="testtest" id="next1"><<</span>
                                <span class="testtest" id="next2"><</span>
                                <input type="text" class="form-control" placeholder="yyyy-mm-dd" formatter="YYYYMMDD" id="tradeDateF">
                                <span class="input-group-addon">~</span>
                                <input type="text" class="form-control" placeholder="yyyy-mm-dd" id="tradeDateT" formatter="YYYYMMDD">
                                <span class="input-group-addon"><i class="cqc-calendar"></i> </span>
                            </div>
                        </ax:td>

                        <ax:td label='사용자' width="300px">
                            <multipicker id="cdEmp" HELP_ACTION="HELP_MULTI_EMP" HELP_URL="multiEmp" BIND-CODE="NO_EMP"
                                         BIND-TEXT="NM_EMP"/>
                        </ax:td>

                        <ax:td label='결재상태' width="280px">
                            <div id="st_draft" data-ax5select="st_draft" data-ax5select-config='{}'></div>
                        </ax:td>
                        <ax:td label='업무구분' width="300px">
                            <div id="jobTp" name="jobTp" data-ax5select="jobTp" data-ax5select-config='{}'></div>
                        </ax:td>
                        <ax:td label='전표처리구분' width="325px">
                            <div id="NO_DOCU_TP" name="NO_DOCU_TP" data-ax5select="NO_DOCU_TP" data-ax5select-config='{}'></div>
                        </ax:td>
                    </ax:tr>
                </ax:tbl>
            </ax:form>
            <div style="min-height:5px;height:5px;">
            </div>
        </div>


        <div>
            <div id="top_wrap">
                <div class="ax-button-group" data-fit-height-aside="grid-view-01" style="min-height:30px;height:30px;" id="top_title" name="상단그리드타이틀">
                    <div class="left">
                        <h2>
                            <i class="icon_list"></i> 카드거래내역
                        </h2>
                    </div>
                    <div class="right">
                        <button type="button" class="btn btn-info" data-page-btn="acctTemp" id="acctTemp" style="width:100px; margin-right: 5px;"><i class="icon_save"></i>계정일괄등록
                            <button type="button" class="btn btn-info" data-page-btn="excel" id="excel" style="width:120px;"><i class="icon_save"></i>거래내역엑셀다운
                    </div>
                </div>
                <div data-ax5grid="grid-view-01"
                     data-ax5grid-config="{  showLineNumber: true,showRowSelector: false, multipleSelect: false,lineNumberColumnWidth: 40,rowSelectorColumnWidth: 27,  singleSelect: false, header:{selector : true}}"
                     id ="top_grid"
                     name="상단그리드"
                >
                </div>
            </div>
            <div id="middle_wrap">
                <div style="min-height:5px;height:5px;"></div>
                <ax:tbl clazz="ax-search-tb2" minWidth="400px">
                    <ax:tr>
                        <ax:td label='업무구분' width="250px" >
                            <div id="JOB_TP" name="JOB_TP" data-ax5select="JOB_TP" data-ax5select-config='{}'></div>
                        </ax:td>
                        <ax:td label='회계일자' width="250px" >
                            <div class="input-group" data-ax5picker="basic2">
                                <input type="text" class="form-control" placeholder="yyyy-mm-dd" id="DT_ACCT" formatter="YYYYMMDD">
                                <span class="input-group-addon"><i class="cqc-calendar"></i></span>
                            </div>
                        </ax:td>
                        <ax:td label='적요' width="400px" >
                            <input type="text" class="form-control W250" name="COMMENTS" id="COMMENTS"/>
                        </ax:td>
                        <ax:td label='만기일자' width="250px" >
                            <div class="input-group" data-ax5picker="basic3">
                                <input type="text" class="form-control" placeholder="yyyy-mm-dd" id="CD_USERDEF1" formatter="YYYYMMDD">
                                <span class="input-group-addon"><i class="cqc-calendar"></i></span>
                            </div>
                        </ax:td>
                    </ax:tr>
                </ax:tbl>
                <div style="min-height:5px;height:5px;"></div>
            </div>
            <div id="bottom_wrap">
                <div class="ax-button-group" data-fit-height-aside="grid-view-02" id="bottom_title" name="하단그리드타이틀">
                    <div class="left">
                        <h2>
                            <i class="icon_list"></i> 계정설정
                        </h2>
                    </div>
                    <div class="right">
                        <button type="button" class="btn btn-small" data-grid-view-02-btn="add" id="ADD1"><i
                                class="icon_add"></i> <ax:lang id="ax.admin.add"/></button>
                        <button type="button" class="btn btn-small" data-grid-view-02-btn="delete"
                                id="ADD2"><i
                                class="icon_del"></i> <ax:lang id="ax.admin.delete"/></button>
                    </div>
                </div>
                <div data-ax5grid="grid-view-02"
                     data-ax5grid-config="{  showLineNumber: true,showRowSelector: false, multipleSelect: false,lineNumberColumnWidth: 40,rowSelectorColumnWidth: 27, }"
                     id="bottom_grid"
                     name ="하단그리드"
                >
                </div>
            </div>
        </div>

    </jsp:body>
</ax:layout>