<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>

<ax:set key="title" value="법인카드(예산,편익제거)"/>
<ax:set key="page_desc" value="${pageRemark}"/>
<ax:set key="page_auto_height" value="true"/>


<ax:layout name="base">
    <jsp:attribute name="script">
         <style>
             .red {
                 background: #ffe0cf !important;
             }
             .readonly {
                 background: #EEEEEE !important;
             }
         </style>
        <ax:script-lang key="ax.script"/>
        <script type="text/javascript">

            /************ 선행 스크립트 START ************/
            var picker = new ax5.ui.picker();
            var afterIndex = 0;
            var CodeData21 = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, "CZ_Q0021");
            var CodeData24 = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, "CZ_Q0024");
            var CodeData5 = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, "CZ_Q0005");
            var CodeData15 = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'CZ_Q0015', true, '003', '003');
            var CodeData14 = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'CZ_Q0014', true);
            var today = new Date();
            var dtF = ax5.util.date(today, {"return": "yyyy-MM-01"});
            // var dtF = ax5.util.date('20190801', {"return": "yyyy-MM-01"});
            var dtT = ax5.util.date(today, {"return": "yyyy-MM"}) + '-' + ax5.util.daysOfMonth(today.getFullYear(), today.getMonth());
            $("#tradeDateF").val(dtF);
            $("#tradeDateT").val(dtT);
            $("#st_draft").ax5select({
                options: CodeData5
            });
            $("#jobTp").ax5select({
                options: CodeData21
            });
            var tax_code_dr = ""; //차변 부가세 계정
            var tax_code_recept = ""; //접대비 계정

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
            // 개별 주석//
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
                }
            });

            $('window').ready(function () {
                $("#cdEmp").setPicker([{code: SCRIPT_SESSION.noEmp, text: SCRIPT_SESSION.nmEmp}]);
                $("#cdDept").setPicker([{code: SCRIPT_SESSION.cdDept, text: SCRIPT_SESSION.nmDept}]);
            });

            /************ 선행 스크립트 END ************/
            var modal = new ax5.ui.modal();
            var cnt1 = 0;
            var cnt2 = 0;
            var fnObj = {}, CODE = {};
            var ACTIONS = axboot.actionExtend(fnObj, {
                PAGE_SEARCH: function (caller, act, data) {
                    if(nvl($("#cdDept").getCodes()) == ''){
                        qray.alert("조회조건의 부서선택은 필수입니다.");
                        return false;
                    }
                    qray.loading.show("데이터 조회중입니다.");
                    fnObj.gridView01.read();
                    caller.gridView01.target.select(afterIndex);
                    caller.gridView01.target.focus(afterIndex);
                    qray.loading.hide();
                    // axboot.call({
                    //     type: "POST",
                    //     url: ["apbucardLv1", "getBucardLv1List"],
                    //     data: JSON.stringify(caller.searchView.getData()),
                    //     callback: function (res) {
                    //         caller.gridView01.setData(res);
                    //         caller.gridView01.target.select(afterIndex);
                    //     }
                    // }).done(function(){
                    //     qray.loading.hide();
                    // });
                    $("#heardChk").attr("checked", false);
                    return false;
                },
                PAGE_SAVE: function (caller, act, data) {
                    var bucardH = fnObj.gridView01.getDirtyData();
                    if (fnObj.gridView01.getDirtyDataCount() == 0) {
                        qray.alert("변경된 데이터가 없습니다.");
                        return false;
                    }
                    for(var i = 0; i < bucardH.updated.length; i++){
                        if(Number(bucardH.updated[i].ADMIN_AMT) != Number(bucardH.updated[i].VAT)+Number(bucardH.updated[i].AMT)){
                            qray.alert("사용금액과 입력금액이 동일하지 않습니다.");
                            return false;
                        }
                        if(nvl(bucardH.updated[i].CD_ACCT_CR) == ''){
                            qray.alert("대변계정 기본설정이 되어있지않습니다.");
                            return false;
                        }
                    }

                    axboot.call({
                        type: "PUT",
                        url: ["apbucardLv1", "allsave"],
                        data: JSON.stringify(bucardH),
                        callback: function (res) {
                        }
                    }).done(function(){
                        qray.alert("저장 되었습니다.").then(function(){
                            fnObj.gridView01.target.$.container.hidden.find('#copyData').remove();
                            ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                        })
                    });

                }
                , FORM_CLEAR: function (caller, act, data) {
                    qray.confirm({
                        msg: LANG("ax.script.form.clearconfirm")
                    }, function () {
                        if (this.key == "ok") {
                            caller.gridView01.clear();
                        }
                    });
                }
                , STATEMENT: function (caller, act, data) {
                    var param = [];
                    if (fnObj.gridView01.getDirtyDataCount() > 0) {
                        qray.alert("미저장된 데이터가 존재합니다.");
                        return false;
                    }

                    var checkList = isChecked(fnObj.gridView01.getData());
                    if(checkList.length == 0){
                        qray.alert("체크 된 데이터가 없습니다.");
                        return false;
                    }

                    for(var i = 0; i < checkList.length; i++) {
                        if (nvl(checkList[i].NO_DOCU) != '') {
                            qray.alert("이미 전표처리된 데이터가 존재합니다.");
                            return false;
                        }

                        if (checkList[i].CHK_BIZ_PURPOSE == 'Y') {
                            qray.alert("출장정산 데이터는 전표처리할 수 없습니다.");
                            return false;
                        }
                        checkList[i].CD_PC = $("#cdPc").attr("code");
                        checkList[i].TAX_CD = tax_code_dr;
                    }
                    for(var i = 0; i < checkList.length; i++){
                        axboot.ajax({
                            type: "PUT",
                            url: ["apbucardLv1", "statement"],
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
                    // if(cnt > 0){
                    //     qray.alert(cnt1 +"건의 전표가 처리되었습니다.\n" + cnt2+"건의 전표처리가 실패하였습니다.").then(function(){
                    //         ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                    //         //menuOpen(param)
                    //     })
                    // }else{
                    //     qray.alert("모든 전표처리가 완료되었습니다.").then(function(){
                    //         ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                    //         menuOpen(param)
                    //     })
                    // }
                    qray.alert(cnt1 +"건의 전표가 처리되었습니다.\n" + cnt2+"건의 전표처리가 실패하였습니다.").then(function(){
                        ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                        if(cnt1 > 0){
                            menuOpen(param)
                        }
                        cnt1 = 0;
                        cnt2 = 0;
                    })

                }

                , STATEMENTMULTI: function (caller, act, data) {
                    var param = [];
                    if (fnObj.gridView01.getDirtyDataCount() > 0) {
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
                        checkList[i].CD_PC = $("#cdPc").attr("code");
                    }
                    data = {list : checkList};
                    //일괄전표
                    userCallBack = function (e) {
                        modal.close({
                            callback : function(){
                                console.log(e);
                                if(e.YN == 'Y'){
                                    if(nvl(e.DT_ACCT_T) == ''){
                                        qray.alert("회계일자 선택은 필수입니다.");
                                        return false;
                                    }
                                    var nm_company = [];
                                    checkList.forEach(function(item, index){
                                        nm_company.push('법인카드_'+item.TRADE_PLACE)
                                    });
                                    data = {list : checkList , REMARK : nvl(e.REMARK,nm_company.join(" ,")), DT_ACCT_T : e.DT_ACCT_T, TAX_CD : tax_code_dr};
                                    axboot.ajax({
                                        type: "PUT",
                                        url: ["apbucardLv1", "statementMulti"],
                                        data: JSON.stringify(data),
                                        async: false,
                                        callback: function (res) {
                                            param.push({GROUP_NUMBER : res.map.GROUP_NUMBER, COMMENTS : e.REMARK});
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
                                                                $.openCustomPopup("Payment",'modalCallBack', '', param, '', 1400, 700)
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
                    var checkList = isCheckedTest(caller.gridView01.getData());

                    if(!checkList){
                        return false;
                    }
                    for(var i = 0; i < checkList.length; i++) {
                        checkList[i].GUBUN = '3';
                        checkList[i].NO_DOCU = nvl(checkList[i].NO_DOCU,'NO');
                        $.DATA_SEARCH("glDocuS", "docu_crud", checkList[i]);
                    }
                    qray.alert("전표취소 처리가 완료되었습니다.").then(function(){
                        ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                    })
                }
                ,DOCU_APPLY: function (caller, act, data) {
                    var data = caller.gridView01.getData();
                    var array = [];
                    var gr_no = [];

                    for (var i = 0; i < data.length; i++) {
                        if(nvl(data[i].NO_DOCU) == ''  && data[i].CHKED == true){
                            qray.alert("미처리 전표 데이터가 존재합니다.");
                            return false;
                        }
                        if (data[i].ST_ING == '01' && data[i].CHKED == true && nvl(data[i].IU_DOCUYN) == 'Y') {
                            array.push(data[i]);
                            gr_no.push(data[i].GROUP_NUMBER)
                        }
                        if(data[i].ST_ING != '01' && data[i].CHKED == true && nvl(data[i].IU_DOCUYN) == 'Y'){
                            qray.alert("미상신 데이터만 선택해야합니다.");
                            return false;
                        }
                        if(nvl(data[i].IU_DOCUYN) == 'N'  && data[i].CHKED == true){
                            qray.alert("IU전표가 존재하지 않는 데이터가 있습니다.");
                            return false;
                        }
                    }
                    if(array.length == 0){
                        qray.alert("체크된 데이터가 없습니다.");
                        return false;
                    }
                    var result = $.DATA_SEARCH("glDocuS","getSelectList",{NO_DOCU : '' , CD_COMPANY : SCRIPT_SESSION.cdCompany, GROUP_NUMBER : gr_no.join('|')});
                    for(var i = 0; i < result.list.length; i++){
                        if(nvl(result.list[i].NO_DRAFT) != ''){
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
                    $.openCustomPopup("Payment",'modalCallBack', '', array, '', 1400, 700)

                },
            });
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

            function isCheckedTest(data) {
                var array = [];

                for (var i = 0; i < data.length; i++) {
                    if (data[i].CHKED == true && nvl(data[i].IU_DOCUYN) == 'Y') {
                        if (data[i].ST_ING == '01' || data[i].ST_ING == '03') {
                            array.push(data[i])
                        } else {
                            qray.alert("상신 처리된 전표는 취소하실수 없습니다.");
                            return false;
                        }
                    }else if(data[i].CHKED == true && nvl(data[i].NO_DOCU) == ''){
                        qray.alert("전표 미처리 데이터는 취소하실수 없습니다.");
                        return false;
                    } else if (data[i].CHKED == true && nvl(data[i].IU_DOCUYN) == 'N') {
                        array.push(data[i])
                    }
                }
                if(array.length == 0){
                    qray.alert("체크된 데이터가 없습니다.");
                    return false;
                }
                return array;
            }
            // fnObj 기본 함수 스타트와 리사이즈
            fnObj.pageStart = function () {
                this.pageButtonView.initView();
                this.searchView.initView();
                this.gridView01.initView();
                ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                var tr = $(document).find('[data-ax5grid-panel-scroll="body"] table tbody').children();

                // var k = $(document).find('[data-ax5grid-panel-scroll="body"] table tbody tr').children().length
                // var col = $(document).find('[data-ax5grid-panel-scroll="body"] table tbody tr').children()
                for(var i = 0; i < tr.length; i++){
                    var td = tr.eq(i).children();
                    var ind = Number($(td.eq(j)[0]).attr('data-ax5grid-column-col'))+Number(11);
                    $(tr.eq(i)[0]).attr('data-ax5grid-column-col',ind);

                    for(var j = 0; j < td.length; j++){

                        var ind = Number($(td.eq(j)[0]).attr('data-ax5grid-column-col'))+Number(11);
                        $(td.eq(j)[0]).attr('data-ax5grid-column-col',ind)

                    }
                }

            };


            fnObj.pageResize = function () {

            };

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
                            ACTIONS.dispatch(ACTIONS.DOCU_APPLY);
                        },
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
                    return {
                        tradeDateF: $("#tradeDateF").val().replace(/-/g, ""),
                        tradeDateT: $("#tradeDateT").val().replace(/-/g, ""),
                        CD_PC: $("#cdPc").attr("code"),
                        CD_DEPT: $("#cdDept").getCodes(),
                        CD_EMP: $("#cdEmp").getCodes(),
                        ST_DRAFT: $("select[name='st_draft']").val(),
                        JOB_TP: $("select[name='jobTp']").val(),
                    }
                }
            });

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
                        showRowSelector: false,
                        // frozenColumnIndex: 13,
                        target: $('[data-ax5grid="grid-view-01"]'),
                        url : ["apbucardLv1", "getBucardLv1List"],
                        param : [fnObj.searchView,'getData'],
                        columns: [
                            {
                                key: "CHKED", label: "", width: 30, align: "center",
                                label:
                                    '<div id="headerBox" data-ax5grid-editor="checkbox" data-ax5grid-checked="false" data-ax5grid-column-selected="true" style="height:17px;width:17px;margin-top:2px;  onclick="javascript:alert(1);"></div>',
                                editor: {
                                    type: "checkbox", config: {height: 17, trueValue: true, falseValue: false}
                                }
                            },
                            {key: "BANK_CODE", label: "은행코드", width: 120, align: "left", editor: false, hidden: true
                                ,styleClass: function () {
                                    return "readonly";
                                }
                            },
                            {key: "TRADE_DATE", label: "승인일자", width: 100, align: "center", editor: false
                                ,formatter : function(){
                                    return $.changeDataFormat(this.value)
                                }
                                ,styleClass: function () {
                                    return "readonly";
                                }
                            },
                            {key: "TRADE_TIME", label: "승인시간", width: 90, align: "center", editor: false
                                ,formatter : function(){
                                    return $.changeDataFormat(this.value,"time")
                                }
                                ,styleClass: function () {
                                    return "readonly";
                                }
                            },
                            {key: "SEQ", label: "순번", width: 120, align: "center", editor: false, hidden: true},
                            {key: "ADMIN_GU", label: "취소여부", width: 80, align: "center", editor: false
                                ,styleClass: function () {
                                    return "readonly";
                                }
                            },
                            {key: "ACCT_NO", label: "카드번호", width: 140, align: "center", editor: false
                                ,formatter : function(){
                                    return $.changeDataFormat(this.value,"card")
                                }
                                ,styleClass: function () {
                                    return "readonly";
                                }
                            },
                            {key: "NM_CARD", label: "카드명", width: 120, align: "left", editor: false
                                ,styleClass: function () {
                                    return "readonly";
                                }
                            },
                            {key: "TRADE_PLACE", label: "가맹점명", width: 120, align: "left", editor: false
                                ,styleClass: function () {
                                    return "readonly";
                                }
                            },
                            {key: "CD_TRADE_PLACE", label: "가맹점 사업자번호", width: 120, align: "center", editor: false
                                ,
                                formatter: function () {
                                    return $.changeDataFormat(this.value,"company")
                                }
                                ,styleClass: function () {
                                    return "readonly";
                                }
                            },
                            {key: "ADMIN_AMT", label: "사용금액", width: 90, align: "right", editor: {type: "number"
                                    , disabled: function () {
                                        return true;
                                    }
                                }, formatter: "money"
                                ,styleClass: function () {
                                    return "readonly";
                                }
                            },
                            {key: "YN_DOCU", label: "전표처리", width: 70, align: "center", editor: false
                                ,styleClass: function () {
                                    return "readonly";
                                }
                            },
                            {key: "NO_DOCU", label: "전표번호", width: 120, align: "left", editor: false, hidden: false
                                ,styleClass: function () {
                                    return "readonly";
                                }
                            },
                            {key: "IU_DOCUYN", label: "IU상태", width: 50, align: "center", editor: false
                                ,styleClass: function () {
                                    return "readonly";
                                }
                            },
                            {key: "NM_DRAFT", label: "결재상태", width: 80, align: "center", editor: false
                                ,styleClass: function () {
                                    return "readonly";
                                }
                            },
                            // {key: "COMMENTS", label: "적요", width: 120, align: "left", editor: {type:"text"}},
                            {key: "NM_NOTE", label: "적요", width: 120, align: "left", editor: false, hidden: true},
                            {key: "CD_ACCT", label: "차변계정", width: 90, align: "left", editor: {type:"text"}, hidden: false
                                ,picker: {
                                    top: _pop_top,
                                    width: 600,
                                    height: _pop_height,
                                    url: "buAcctCode",
                                    action: ["customHelp", "CUSTOM_HELP_BUACCT"],//바로 바인딩될려면 선행 조회용 프로시저에 등록 해둬야함
                                    param: function () {
                                        return { TP_DRCR : '1' ,JOB_TP : '1' , CD_DEPT : fnObj.gridView01.getData('selected')[0].CD_DEPT}
                                    },
                                    callback: function (e) {
                                        var index = fnObj.gridView01.getData('selected')[0].__index;
                                        // fnObj.gridView01.target.updateRow({ CD_ACCT: e[0].CD_ACCT},index);
                                        fnObj.gridView01.target.setValue(index, "CD_ACCT", e[0].CD_ACCT);
                                        fnObj.gridView01.target.setValue(index, "NM_ACCT", e[0].NM_ACCT);
                                        fnObj.gridView01.target.setValue(index, "NM_DESC", e[0].NM_DESC);
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
                            {key: "NM_ACCT", label: "차변계정명", width: 90, align: "left", editor: false, hidden: false
                                ,styleClass: function () {
                                    return "readonly";
                                }
                            },
                            {key: "AMT", label: "금액", width: 80, align: "right",required: true
                                ,editor: {type: "number"}
                                , disabled: function () {
                                    var NO_DOCU = fnObj.gridView01.getData('selected')[0].NO_DOCU;
                                    if (nvl(NO_DOCU, '') != '') { return true; } else { return false;}
                                }

                                ,formatter: function () {
                                    return ax5.util.number(this.value, {"money": true});
                                }
                                ,styleClass: function () {
                                    return "red";
                                }
                            },
                            {key: "CD_TAX_ACCT", label: "부가세계정", width: 80, align: "left", editor: {type:"text"}, hidden: false
                                ,picker: {
                                    top: _pop_top,
                                    width: 600,
                                    height: _pop_height,
                                    url: "buAcctCode",
                                    action: ["customHelp", "CUSTOM_HELP_BUACCT"],
                                    param: function () {
                                        return { TP_DRCR : '1' ,JOB_TP : '1' , CD_DEPT : fnObj.gridView01.getData('selected')[0].CD_DEPT}
                                    },
                                    callback: function (e) {
                                        var index = fnObj.gridView01.getData('selected')[0].__index;
                                        if(tax_code_dr.indexOf(e[0].CD_ACCT) > -1){
                                            fnObj.gridView01.target.setValue(index, "CD_TAX_ACCT", e[0].CD_ACCT);
                                            fnObj.gridView01.target.setValue(index, "NM_TAX_ACCT", e[0].NM_ACCT);
                                        }else{
                                            qray.alert('부가세 계정이 아닙니다.');

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
                            {key: "NM_TAX_ACCT", label: "부가세계정명", width: 80, align: "left", editor: false, hidden: false
                                ,styleClass: function () {
                                    return "readonly";
                                }
                            },
                            {key: "TAX_GB",  label: "세무구분", width: 100, align: "left", editor: {
                                    type: "select", config: {
                                        columnKeys: {
                                            optionValue: "value", optionText: "text"
                                        },
                                        options: [{value:undefined,text:''}].concat(CodeData15)
                                    }
                                    , disabled: function () {
                                        if (nvl(this.item.NO_DOCU, '') != '' || tax_code_dr.indexOf(this.item.CD_TAX_ACCT) < 0) { return true; } else { return false;}
                                    }
                                }
                                ,formatter: function () {
                                    return $.changeTextValue([{value:'',text:''}].concat(CodeData15), this.value)
                                }, hidden: false
                            },
                            {key: "NON_TAX", label: "불공제구분", width: 100, align: "left", editor: {
                                    type: "select", config: {
                                        columnKeys: {
                                            optionValue: "value", optionText: "text"
                                        },
                                        options: [{value:undefined,text:''}].concat(CodeData14)
                                    }
                                    , disabled: function () {
                                        if (nvl(this.item.NO_DOCU, '') != '' || tax_code_dr.indexOf(this.item.CD_TAX_ACCT) < 0 || this.item.TAX_GB != '22') { return true; } else { return false;}
                                    }
                                },formatter: function () {
                                    return $.changeTextValue([{value:undefined,text:''}].concat(CodeData14), this.value)
                                }, hidden: false},
                            {key: "VAT", label: "부가세 금액", width: 80, align: "right"
                                ,editor: {type: "number"
                                    , disabled: function () {
                                        if (nvl(this.item.NO_DOCU, '') != '' || tax_code_dr.indexOf(this.item.CD_TAX_ACCT) < 0) { return true; } else { return false;}
                                    }
                                }
                                ,formatter: function () {
                                    return ax5.util.number(this.item.VAT, {"money": true});
                                }
                            },
                            {key: "CD_ACCT_CR", label: "대변계정", width: 80, align: "left", editor: {type:"text"}, hidden: false,
                                formatter:function(){
                                    var data = this.item.CD_ACCT_CR;
                                    return data;
                                }
                                ,styleClass: function () {
                                    return "red";
                                }
                                ,picker: {
                                    top: _pop_top,
                                    width: 600,
                                    height: _pop_height,
                                    url: "buAcctCode",
                                    action: ["customHelp", "CUSTOM_HELP_BUACCT"],
                                    param: function () {
                                        return { TP_DRCR : '2' ,JOB_TP : '1' }
                                    },
                                    callback: function (e) {
                                        var index = fnObj.gridView01.getData('selected')[0].__index;
                                        fnObj.gridView01.target.setValue(index, "CD_ACCT", e[0].CD_ACCT);
                                        fnObj.gridView01.target.setValue(index, "NM_ACCT", e[0].NM_ACCT);
                                        fnObj.gridView01.target.setValue(index, "NM_DESC", e[0].NM_DESC);
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
                            {key: "NM_ACCT_CR", label: "대변계정명", width: 80, align: "left", editor: false
                                ,styleClass: function () {
                                    return "readonly";
                                }
                            },
                            {key: "CHK_BIZ_PURPOSE", label: "출장여부", width: 120, align: "right", editor: false, hidden:true},
                            {key: "CD_CC", label: "코스트센터", width: 80, align: "center", editor: true, hidden : true
                                ,styleClass: function () {
                                    return "red";
                                }
                            },
                            {key: "NM_CC", label: "코스트센터명", width: 80, align: "left", editor: {type:"text"}, hidden: false
                                ,styleClass: function () {
                                    return "red";
                                }
                                ,picker: {
                                    top: _pop_top,
                                    width: 600,
                                    height: _pop_height,
                                    url: "cc",
                                    action: ["commonHelp", "HELP_CC"],
                                    callback: function (e) {
                                        var index = fnObj.gridView01.getData('selected')[0].__index;
                                        fnObj.gridView01.target.setValue(index, "CD_CC", e[0].CD_CC);
                                        fnObj.gridView01.target.setValue(index, "NM_CC", e[0].NM_CC);
                                        fnObj.gridView01.target.setValue(index, "CD_BUDGET", e[0].CD_BUDGET);
                                        fnObj.gridView01.target.setValue(index, "NM_BUDGET", e[0].NM_BUDGET);
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
                            // {key: "DT_ACCT", label: "회계일자", width: 90, align: "left", editor: {type:"text"}},
                            {key: "DT_DRAFT", label: "결재일자", width: 90, align: "center", editor: false
                                ,
                                formatter: function () {
                                    return $.changeDataFormat(this.value)
                                }
                                ,styleClass: function () {
                                    return "readonly";
                                }
                            },
                            {key: "NO_DRAFT", label: "결재번호", width: 120, align: "right", editor: false,hidden: true},
                            {key: "NM_DEPT", label: "사용부서", width: 120, align: "left", editor: false
                                ,styleClass: function () {
                                    return "readonly";
                                }
                            },
                            {key: "CD_DEPT", label: "사용부서코드", width: 120, align: "left", editor: false,hidden: true},
                            {key: "NM_USER", label: "사용자", width: 120, align: "left", editor: false
                                ,styleClass: function () {
                                    return "readonly";
                                }
                            },
                            {key: "NO_EMP", label: "사번", width: 120, align: "left", editor: false,hidden: true},
                            {key: "SUPPLY_AMT", label: "공급가액", width: 120, align: "left", editor: false, hidden: true},
                            {key: "VAT_AMT", label: "부가세액", width: 120, align: "left", editor: false, hidden: true},
                            {key: "CD_PARTNER", label: "거래처코드", width: 120, align: "left", editor: false
                                ,styleClass: function () {
                                    return "readonly";
                                }
                            },
                            {key: "TP_JOB", label: "업종", width: 120, align: "left", editor: false, hidden: false
                                ,styleClass: function () {
                                    return "readonly";
                                }
                            },
                            {key: "MERC_ADDR", label: "주소", width: 120, align: "left", editor: false, hidden: false
                                ,styleClass: function () {
                                    return "readonly";
                                }
                            },
                            {key: "GROUP_NUMBER", label: "그룹넘버", width: 120, align: "left", editor: false, hidden: true},
                            {key: "NM_TAX_DESC", label: "부가세적요", width: 120, align: "left", editor: false, hidden: true},
                            {key: "ST_ING", label: "결재상태코드", width: 120, align: "left", editor: false, hidden: true},
                            {key: "S_IDNO", label: "사업자번호", width: 120, align: "left", editor: false, hidden: true},
                        ],
                        body: {
                            onDataChanged: function () {
                                if (this.key == 'CD_TAX_ACCT') {
                                    fnObj.gridView01.target.setValue(this.dindex, "NO_TAX", undefined);
                                    fnObj.gridView01.target.setValue(this.dindex, "NON_TAX", undefined);
                                    fnObj.gridView01.target.setValue(this.dindex, "TAX_GB", undefined);
                                    fnObj.gridView01.target.setValue(this.dindex, "VAT", 0);
                                }
                                if (this.key == 'TAX_GB') {
                                    fnObj.gridView01.target.setValue(this.dindex, "NON_TAX", undefined);
                                }
                            },
                            onClick: function () {
                                this.self.select(this.dindex);
                                var index = this.dindex;
                                var selectH = fnObj.gridView01.getData('selected')[0];
                                if (nvl(selectH.NO_DOCU, '') != '') {
                                    return false;
                                }

                                // if (this.column.key == "CD_ACCT") {
                                //     userCallBack = function (e) {
                                //         if (e.length > 0) {
                                //             fnObj.gridView01.target.setValue(index, "CD_ACCT", e[0].CD_ACCT);
                                //             fnObj.gridView01.target.setValue(index, "NM_ACCT", e[0].NM_ACCT);
                                //             fnObj.gridView01.target.setValue(index, "NM_DESC", e[0].NM_DESC);
                                //             // fnObj.gridView01.target.updateRow({"CD_ACCT": e[0].CD_ACCT},index);
                                //             // fnObj.gridView01.target.updateRow({"NM_ACCT": e[0].NM_ACCT},index);
                                //             // fnObj.gridView01.target.updateRow({"NM_DESC": e[0].NM_DESC},index);
                                //         }
                                //         modal.close();
                                //     };
                                //     var initData = {TP_DRCR: '1', JOB_TP: '1'};
                                //     $.openCustomPopup("buAcctCode", "userCallBack", "CUSTOM_HELP_BUACCT", initData);
                                // }else if (this.column.key == "NM_CC") {
                                //     userCallBack = function (e) {
                                //         if (e.length > 0) {
                                //             fnObj.gridView01.target.setValue(index, "CD_CC", e[0].CD_CC);
                                //             fnObj.gridView01.target.setValue(index, "NM_CC", e[0].NM_CC);
                                //         }
                                //         modal.close();
                                //     };
                                //     $.openCommonPopup("cc", "userCallBack", "HELP_CC");
                                // }else if (this.column.key == "CD_TAX_ACCT") {
                                //     userCallBack = function (e) {
                                //         if (e.length > 0) {
                                //             fnObj.gridView01.target.setValue(index, "CD_TAX_ACCT", e[0].CD_ACCT);
                                //             fnObj.gridView01.target.setValue(index, "NM_TAX_ACCT", e[0].NM_ACCT);
                                //             fnObj.gridView01.target.setValue(index, "NM_TAX_DESC", e[0].NM_DESC);
                                //         }
                                //         modal.close();
                                //     };
                                //     var initData = {TP_DRCR: '1', JOB_TP: '1'};
                                //     $.openCustomPopup("buAcctCode", "userCallBack", "CUSTOM_HELP_BUACCT", initData);
                                // }else if (this.column.key == "CD_ACCT_CR") {
                                //     userCallBack = function (e) {
                                //         if (e.length > 0) {
                                //             fnObj.gridView01.target.setValue(index, "CD_ACCT_CR", e[0].CD_ACCT);
                                //             fnObj.gridView01.target.setValue(index, "NM_ACCT_CR", e[0].NM_ACCT);
                                //         }
                                //         modal.close();
                                //     };
                                //     var initData = {TP_DRCR: '2', JOB_TP: '1'};
                                //     $.openCustomPopup("buAcctCode", "userCallBack", "CUSTOM_HELP_BUACCT", initData);
                                // }
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
            function isChecked(data) {
                var array = [];
                for (var i = 0; i < data.length; i++) {
                    if (data[i].CHKED == true) {
                        array.push(data[i])
                    }
                }
                return array;
            }
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
            //크기자동조정
            var _pop_top = 0;
            var _pop_height = 0;
            var _pop_top_180 = 0;
            var _pop_top_380 = 0;
            var _pop_top_450 = 0;
            var _pop_width_1200 = 0;
            var _pop_height_800 = 0;
            var _pop_top_800 = 0;
            $(document).ready(function() {
                changesize();
            });
            $(window).resize(function(){
                changesize();
            });

            function changesize() {
                //전체영역높이
                var totheight = $("#ax-base-root").height();
                if (totheight > 550) {
                    $("#pgun").css("display", "");
                    _pop_width_1200 = 1200;
                } else {
                    $("#pgun").css("display", "none");
                    _pop_width_1200 = 1000;
                }

                if (totheight > 700) {
                    _pop_height = 600;
                    _pop_top = parseInt((totheight - _pop_height) / 2);
                    _pop_top_180 = parseInt((totheight - 180) / 2);
                    _pop_top_380 = parseInt((totheight - 380) / 2);
                    _pop_top_450 = parseInt((totheight - 450) / 2);
                    _pop_top_800 = parseInt((totheight - 800) / 2);
                    _pop_height_800 = 800;
                } else {
                    _pop_height = totheight / 10 * 8;
                    _pop_top = parseInt((totheight - _pop_height) / 2);
                    _pop_top_180 = parseInt((totheight - 180) / 2);
                    _pop_top_380 = parseInt((totheight - 380) / 2);
                    _pop_top_450 = parseInt((totheight - (totheight / 10 * 8)) / 2);
                    _pop_top_800 = parseInt((totheight - (totheight / 10 * 9.8)) / 2);
                    _pop_height_800 = totheight / 10 * 9.5;
                }
            }
        </script>
    </jsp:attribute>
    <jsp:body>

        <%--        <div id="loading"><img id="loading-image" src="/assets/css/images/common/loadingSpinner2.gif" alt="테스트테스트테스트테스트테스트테스트" /></div>--%>

        <div data-page-buttons="">
            <div class="button-warp">
                <button type="button" class="btn btn-reload" data-page-btn="reload"  style="width:80px" onclick="window.location.reload();">
                    <i class="icon_reload"></i></button>
                <button type="button" class="btn btn-info" data-page-btn="search" id="BtnSearch" style="width:80px"><i class="icon_search"></i><ax:lang
                        id="ax.admin.sample.modal.button.search"/></button>
                <button type="button" class="btn btn-info" data-page-btn="save" id="BtnSave" style="width:80px"><i class="icon_save"></i>저장</button>
                    <%--                <button type="button" class="btn btn-info" data-page-btn="docu" id="BtnDocu"><i class="icon_save"></i>건별전표처리</button>--%>
                <button type="button" class="btn btn-info" data-page-btn="docuMulti" id="BtnDocu2" style="width:80px"><i class="icon_ok"></i>전표처리</button>
                <button type="button" class="btn btn-info" data-page-btn="cancel" id="BtnCancel" style="width:80px"><i class="icon_reject"></i>전표취소</button>
                <button type="button" class="btn btn-info" data-page-btn="apply" style="width:80px;" style="width:80px"><i class="icon_ok"></i>결재요청</button>
            </div>
        </div>

        <div role="page-header">
            <ax:form name="searchView0">
                <ax:tbl clazz="ax-search-tb1" minWidth="400px">
                    <ax:tr>
                        <ax:td label='회계단위' width="300px">
                            <codepicker id="cdPc" HELP_ACTION="HELP_PC" HELP_URL="pc" BIND-CODE="CD_PC"
                                        BIND-TEXT="NM_PC" READONLY SESSION />
                        </ax:td>
                        <ax:td label='사용부서' width="350px">
                            <multipicker id="cdDept" HELP_ACTION="HELP_DEPT" HELP_URL="multiDept" BIND-CODE="CD_DEPT"
                                         BIND-TEXT="NM_DEPT"/>
                        </ax:td>
                        <ax:td label='카드매입일자' width="350px">
                            <div class="input-group" data-ax5picker="basic">
                                <input type="text" class="form-control" placeholder="yyyy-mm-dd" id="tradeDateF">
                                <span class="input-group-addon">~</span>
                                <input type="text" class="form-control" placeholder="yyyy-mm-dd" id="tradeDateT">
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
                        <ax:td label='업무구분' width="280px">
                            <div id="jobTp" name="jobTp" data-ax5select="jobTp" data-ax5select-config='{}'></div>
                        </ax:td>
                    </ax:tr>
                </ax:tbl>
            </ax:form>
            <div class="H10"></div>
        </div>

        <ax:split-layout name="ax1" orientation="vertical">
            <ax:split-panel width="600" style="padding-right: 10px;">
                <div data-ax5grid="grid-view-01"
                     data-fit-height-content="grid-view-01"
                     style="height: 300px;"
                     data-ax5grid-config="{  showLineNumber: true,showRowSelector: false, multipleSelect: false,lineNumberColumnWidth: 40,rowSelectorColumnWidth: 27, }"
                ></div>

            </ax:split-panel>
        </ax:split-layout>

    </jsp:body>
</ax:layout>