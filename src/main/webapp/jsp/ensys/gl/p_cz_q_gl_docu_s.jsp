<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>

<ax:set key="title" value="전표조회상신관리"/>
<ax:set key="page_desc" value="${pageRemark}"/>
<ax:set key="page_auto_height" value="true"/>



<ax:layout name="base">
    <jsp:attribute name="script">
        <ax:script-lang key="ax.script" />

        <script type="text/javascript" >
            var modal = new ax5.ui.modal();
            var FileBrowserModal = new ax5.ui.modal();
            var picker = new ax5.ui.picker();
            var confirmDialog = new ax5.ui.dialog();
            var menuParam = this.parent.fnObj.tabView.urlGetData();

            /* 오늘 날짜 :: 년 / 월 / 일 :: 구하기 시작 */
            var today = new Date();
            var dtF = ax5.util.date(today, {"return": "yyyy-MM-01"});
            var dtT = ax5.util.date(today, {"return": "yyyy-MM"}) + '-' + ax5.util.daysOfMonth(today.getFullYear(), today.getMonth());
            var dtNow = ax5.util.date(today, {"return": "yyyy-MM-dd"});
            var _urlGetData = this.parent.fnObj.tabView.urlGetData();    //  다른 메뉴에서 받아오는 파라메터
            /* 오늘 날짜 :: 년 / 월 / 일 :: 구하기 끝 */

            console.log(" [ *** 타메뉴에서 넘어오는 데이터 : " , menuParam , " *** ] ");
            confirmDialog.setConfig({
                title: "Confirm title",
                theme: "danger"
            });
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
                },
                btns: {
                    today: {
                        label: "오늘", onClick: function () {

                            $("#S_DT_START").val(dtNow);
                            $("#S_DT_END").val(dtNow);
                            this.self.close();
                        }
                    },
                    thisMonth: {
                        label: "이번달", onClick: function () {
                            $("#S_DT_END").val(dtT);
                            $("#S_DT_START").val(dtF);
                            this.self.close();
                        }
                    },
                    ok: {label: "확인", theme: "default"}
                }
            });

            $('document').ready(function () {
                $('[data-ax5layout]').ax5layout();
                $("#cdPc").keydown(function (e) {
                    if (e.keyCode == '8' || e.keyCode == '16') {
                        $("#cdPc").val("");
                        $("#cdPc").attr({code: "", text: ""})
                    }
                });
                $('#S_DEPT [data-ax5select]').ax5select({
                    theme: 'primary',
                    onStateChanged: function (e) {
                        $("#S_NM_EMP").setHelpParam(JSON.stringify({CD_DEPT : $("#S_DEPT").getCodes()}));
                    }
                });
            });

            $("#S_DT_START").val(getPastDate());
            $("#S_DT_END").val(getRecentDate());

            function getRecentDate() {
                var dt = new Date();
                var recentYear = dt.getFullYear();
                var recentMonth = dt.getMonth() + 1;
                var recentDay = dt.getDate();
                if (recentMonth < 10) recentMonth = "0" + recentMonth;
                if (recentDay < 10) recentDay = "0" + recentDay;
                return recentYear + "-" + recentMonth + "-" + recentDay;
            }

            function getPastDate() {
                var dt = new Date();
                var year = dt.getFullYear();
                var month = dt.getMonth() + 1;
                if (month < 10) month = "0" + month;
                return year + "-" + month + "-01";
            }

            var fnObj = {}, CODE = {};
            var ACTIONS = axboot.actionExtend(fnObj, {
                PAGE_SEARCH: function (caller, act, data) {
                    caller.gridView01.clear();
                    caller.gridView02.clear();
                    $.DATA_SEARCH("glDocuS","getMasterList",fnObj.searchView.getData(),caller.gridView01);
                    ACTIONS.dispatch(ACTIONS.ITEM_CLICK, '');
                    return false;
                },
                CANCEL: function (caller, act, data) {
                    var data = caller.gridView01.getData();
                    var checkList = [];
                    if(data.length == 0){
                        qray.alert("체크 된 데이터가 없습니다.");
                        return false;
                    }
                    for (var i = 0; i < data.length; i++) {
                        if (data[i].CHKED == true && nvl(data[i].IU_DOCUYN) == 'Y') {
                            if ((data[i].ST_ING == '01' || data[i].ST_ING == '03') && data[i].IU_ST == '미결') {
                                checkList.push(data[i])
                            }else{
                                if(data[i].ST_ING == '04' || data[i].IU_ST == '승인'){
                                    qray.alert("승인된 전표는 취소하실수 없습니다.");
                                    return false;
                                }else if(data[i].ST_ING == '02'){
                                    qray.alert("진행중인 전표는 취소하실수 없습니다.");
                                    return false;
                                }
                            }
                        }else if(data[i].CHKED == true && nvl(data[i].IU_DOCUYN) == 'N'){
                            checkList.push(data[i])
                        }
                    }
                    for(var i = 0; i < checkList.length; i++) {
                        checkList[i].GUBUN = '3';
                        checkList[i].NO_DOCU = nvl(checkList[i].NO_DOCU,'NO');
                        $.DATA_SEARCH("glDocuS", "docu_crud", checkList[i]);
                    }
                    qray.alert("전표취소 처리가 완료되었습니다.").then(function(){
                        ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                    });
                    return false;
                },
                TEST : function(caller, act, data){
                    var list = caller.gridView01.getData();
                    var checkList = [];

                    list.forEach(function (item,i) {
                        if(item.CHKED == true){
                            checkList.push(item)
                        }
                    });

                    qray.confirm({
                        msg: 'Confirm message',
                        btns: {
                            apply: {
                                label:'상신', onClick: function(key){
                                    var GroupNumber;
                                    var temp = [];
                                    var cnt1 = 0;
                                    var cnt2 = 0;
                                    var cnt3 = 0;
                                    for(var i = 0; i < checkList.length; i++){
                                        if(checkList[i].TP_GB == '07'){
                                            cnt1++
                                        }else if(checkList[i].BNFT_GB == '1'){
                                            cnt2++
                                        }else{
                                            cnt3++
                                        }
                                    }
                                    if(cnt1 > 0 && (cnt2 > 0 || cnt3++)){
                                        qray.alert("복리후생유형은 다른유형과 같이 상신할 수 없습니다.");
                                        return false;
                                    }
                                    if(cnt2 > 0 && (cnt1 > 0 || cnt3++)){
                                        qray.alert("편익분류 비용처리 건 상신은 편익분류 \n전표들끼리만 가능합니다.");
                                        return false;
                                    }
                                    for(var i = 0; i < checkList.length; i++){
                                        if(nvl(checkList[i].ST_ING) != '01'){
                                            qray.alert("미상신 전표만 선택해주십시오.");
                                            qray.close();
                                            return false;
                                        }
                                        checkList[i].GUBUN = '0';
                                        temp.push(checkList[i].GROUP_NUMBER)
                                    }
                                    GroupNumber = temp.join("|");
                                    var today = new Date();
                                    var day = ax5.util.date(today, {"return": "yyyy-MM-dd"});
                                    axboot.ajax({
                                        type: "POST",
                                        url: ["glDocuS" , "applyDocu"],
                                        data: JSON.stringify({GROUP_NUMBER : GroupNumber , DT_ACCT : day, USER_DRAFT : SCRIPT_SESSION.noEmp}),
                                        async : false,
                                        callback: function (res) {
                                        }
                                    });
                                    qray.close();
                                    qray.alert("완료");
                                    ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                                }
                            },
                            del: {
                                label:'승인', onClick: function(key){
                                    for(var i = 0; i < checkList.length; i++){
                                        console.log(checkList[i]);
                                        if(nvl(checkList[i].NO_DOCU) == ''){
                                            qray.alert("전표 미처리 데이터입니다.");
                                            qray.close();
                                            return false;
                                        }
                                        if(nvl(checkList[i].ST_ING) == '01'){
                                            qray.alert("미상신 전표는 승인하실수 없습니다.");
                                            qray.close();
                                            return false;
                                        }
                                        if(nvl(checkList[i].ST_ING) == '04'){
                                            qray.alert("승인 전표는 승인하실수 없습니다.");
                                            qray.close();
                                            return false;
                                        }
                                        checkList[i].GUBUN = '1';
                                        $.DATA_SEARCH("glDocuS","TEST",checkList[i]);
                                    }
                                    qray.close();
                                    qray.alert("완료");
                                    ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                                }
                            },
                            cancel1: {
                                label:'반려', onClick: function(key){
                                    for(var i = 0; i < checkList.length; i++){
                                        console.log(checkList[i]);
                                        if(nvl(checkList[i].NO_DOCU) == ''){
                                            qray.alert("전표 미처리 데이터입니다.");
                                            qray.close();
                                            return false;
                                        }
                                        if(nvl(checkList[i].ST_ING) == '01'){
                                            qray.alert("미상신 전표는 반려하실수 없습니다.");
                                            qray.close();
                                            return false;
                                        }
                                        if(nvl(checkList[i].ST_ING) == '04'){
                                            qray.alert("승인 전표는 반려하실수 없습니다.");
                                            qray.close();
                                            return false;
                                        }
                                        checkList[i].GUBUN = '2';
                                        $.DATA_SEARCH("glDocuS","TEST",checkList[i]);
                                        qray.close();
                                        qray.alert("완료")
                                    }
                                    ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                                }
                            },
                            // cancel2: {
                            //     label:'취소', onClick: function(key){
                            //         console.log(checkList);
                            //         for(var i = 0; i < checkList.length; i++) {
                            //             console.log(checkList[i]);
                            //             if(nvl(checkList[i].NO_DOCU) == ''){
                            //                 qray.alert("전표 미처리 데이터입니다.")
                            //                 confirmDialog.close();
                            //                 return false;
                            //             }
                            //             if(nvl(checkList[i].ST_ING) == '04'){
                            //                 qray.alert("승인 전표는 취소할수 없습니다.")
                            //                 confirmDialog.close();
                            //                 return false;
                            //             }
                            //             checkList[i].GUBUN = '3';
                            //             $.DATA_SEARCH("glDocuS", "TEST", checkList[i]);
                            //             confirmDialog.close();
                            //             qray.alert("완료")
                            //         }
                            //         ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                            //     }
                            // },
                            other: {
                                label:'닫기', onClick: function(key){
                                    qray.close();
                                }
                            }
                        }
                    }, function(){

                    });
                },
                DOCU_APPLY: function (caller, act, data) {
                    var data = caller.gridView01.getData();
                    var array = [];
                    var gr_no = [];
                    var cnt1 = 0;
                    var cnt2 = 0;
                    var cnt3 = 0;


                    for (var i = 0; i < data.length; i++) {
                        if ((data[i].ST_ING == '01' || data[i].ST_ING == '03') && data[i].CHKED == true && nvl(data[i].IU_DOCUYN) == 'Y') {
                            array.push(data[i]);
                            gr_no.push(data[i].GROUP_NUMBER)
                        }
                        if(data[i].ST_ING != '01' && data[i].ST_ING != '03' && data[i].CHKED == true && nvl(data[i].IU_DOCUYN) == 'Y' ){
                            qray.alert("미상신 데이터만 선택해야합니다.");
                            return false;
                        }
                        if(nvl(data[i].IU_DOCUYN) == 'N'  && data[i].CHKED == true){
                            qray.alert("IU전표가 존재하지 않는 데이터가 있습니다.");
                            return false;
                        }

                        if(data[i].IU_ST == '승인'  && data[i].CHKED == true){
                            qray.alert("IU에서 이미 승인된 전표가 존재합니다.");
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
                    for(var i = 0; i < array.length; i++){
                        if(array[i].TP_GB == '07'){
                            cnt1++
                        }else if(array[i].BNFT_GB == '1'){
                            cnt2++
                        }else{
                            cnt3++
                        }
                    }
                    if(cnt1 > 0 && (cnt2 > 0 || cnt3++)){
                        qray.alert("복리후생유형은 다른유형과 같이 상신할 수 없습니다.");
                        return false;
                    }
                    if(cnt2 > 0 && (cnt1 > 0 || cnt3++)){
                        qray.alert("편익분류 비용처리 건 상신은 편익분류 \n전표들끼리만 가능합니다.");
                        return false;
                    }

                    var bn_cnt = 0;
                    for(var i = 0; i < array.length; i++){
                        if(array[i].BNFT_GB == '1'){
                            bn_cnt++;
                            break;
                        }
                    }
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
                    if(bn_cnt > 0){
                        qray.alert("준법감시팀 결재선을 지정하여주십시오.").then(function(){
                            // gw(array)
                            $.openCustomPopup("Payment",'modalCallBack', '', array, '', _pop_width1400, _pop_height700,_pop_top700);
                        });
                    }else{
                        // gw(array)
                        $.openCustomPopup("Payment",'modalCallBack', '', array, '', _pop_width1400, _pop_height700,_pop_top700);
                    }




                },
                ITEM_CLICK: function (caller, act, data) {
                    if(caller.gridView01.getData('selected')[0] != undefined){
                        $.DATA_SEARCH("glDocuS" , "getDetailList" , caller.gridView01.getData('selected')[0] , caller.gridView02);
                    }
                    return false;
                },
                //상신취소
                APPLYCANCEL : function(caller, act, data){
                    var data = fnObj.gridView01.getData();
                    var array = [];
                    for (var i = 0; i < data.length; i++) {
                        if (data[i].CHKED == true) {
                            array.push(data[i])
                        }
                    }

                    for (var i = 0; i < array.length; i++) {
                        if (array[i].ST_ING == '01') {
                            qray.alert('미상신 데이터가 존재합니다.');
                            return
                        }else if (array[i].ST_ING == '04') {
                            qray.alert('승인 데이터가 존재합니다.');
                            return
                        }
                    }

                    $.DATA_SEARCH("glDocuS" , "applyCancel" , {list : array});
                }
            });

            function gw(param){
                var today = new Date();
                var day = ax5.util.date(today, {"return": "yyyy-MM-dd"});
                var gr_no = param.join('|');
                var no_draft;
                // var result = $.DATA_SEARCH("glDocuS" , "getNoDraft")
                // result = result.NO_DRAFT
                axboot.ajax({
                    type: "POST",
                    url: ["glDocuS" , "applyInsert"],
                    data: JSON.stringify({list : param , DT_ACCT : day, USER_DRAFT : SCRIPT_SESSION.noEmp}),
                    async : false,
                    callback: function (res) {
                        no_draft = res.map.NO_DRAFT
                    }
                });


                var paramData = {key :no_draft , empno  :SCRIPT_SESSION.noEmp , fmpf :'WF_LEGACY_EXPENSE_REPORT' , ver  :0};

                var win = window.open('https://groupware.nhamundi.com/WebSite/Approval/Forms/FormLinkForDouzone.aspx',paramData,'_blank');

                var interval = window.setInterval(function() {
                    try {
                        //상신 누르고 자동으로 닫혀도 CLOSED로 먹히기 때문에
                        if (win == null || win.closed) {
                            //cz_draft INSERT 한 데이터 삭제/ cz_docu에 no_draft 빈값으로 UPDATE
                            //무조건 태우기 - CZ_DOCU에 ST_ING가 그냥 껏을 때는 미상신이므로 미상신일 때만 지우기
                            axboot.ajax({
                                type: "POST",
                                url: ["glDocuS" , "applyUpdate"],
                                data: JSON.stringify({list : param , NO_DRAFT : no_draft}),
                                async : false,
                                callback: function (res) {
                                }
                            });
                            window.clearInterval(interval);
                            ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                        }
                    }
                    catch (e) {
                    }

                }, 100);


                // $.ajax({
                //     url: "https://www.devs.com/WebSite/Approval/Forms/FormLinkForDouzone.aspx",
                //     type: "POST",
                //     dataType: "JSON",
                //     data: JSON.stringify({key :gr_no,empno  :'1',fmpf  :'WF_LEGACY_EXPENSE_REPORT',ver  :0}),
                //     success: function(data){
                //
                //     },
                //     error: function (request, status, error){
                //     }
                // });

            }

            // fnObj 기본 함수 스타트와 리사이즈
            fnObj.pageStart = function () {
                this.pageButtonView.initView();
                this.searchView.initView();
                this.gridView01.initView();
                this.gridView02.initView();
                if(menuParam){
                    var result = $.DATA_SEARCH("glDocuS","getSelectList",{NO_DOCU : nvl(menuParam.NO_DOCU) , CD_COMPANY : SCRIPT_SESSION.cdCompany, GROUP_NUMBER : nvl(menuParam.GROUP_NUMBER)});
                    fnObj.gridView01.setData(result);
                    fnObj.gridView01.target.select(0);
                    ACTIONS.dispatch(ACTIONS.ITEM_CLICK, '');
                }else{
                    ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
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
                        "apply": function () {
                            ACTIONS.dispatch(ACTIONS.DOCU_APPLY);
                        },
                        "test": function () {
                            ACTIONS.dispatch(ACTIONS.TEST);
                        },
                        "cancel": function () {
                            ACTIONS.dispatch(ACTIONS.CANCEL);
                        },
                        "applyCancel": function () {
                            ACTIONS.dispatch(ACTIONS.APPLYCANCEL);
                        }
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
                         CD_COMPANY : SCRIPT_SESSION.cdCompany
                        ,CD_PC      : $("#cdPc").attr('code')
                        ,CD_DEPT    : $("#S_DEPT").getCodes()
                        ,DT_START   : $("#S_DT_START").val()
                        ,DT_END     : $("#S_DT_END").val()
                        ,TP_GB      : $("select[name='S_TP_GB']").val()
                        ,ST_ING     : $("select[name='S_ST_ING']").val()
                        ,BNFT_GB     : $("select[name='S_BNFT_GB']").val()
                        ,CD_EMP     : $("#S_NM_EMP").getCodes()
                        ,GROUP_NUMBER : ''
                    }
                }
            });
            var st_ing = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany,'CZ_Q0005');
            var tp_gb = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany,'CZ_Q0006');
            var bnft_gb = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany,'CZ_Q0024');
            $("#S_ST_ING").ax5select({
                options: st_ing
            });
            $("#S_TP_GB").ax5select({
                options: tp_gb
            });
            $("#S_BNFT_GB").ax5select({
                options: bnft_gb
            });


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
                        frozenColumnIndex: 0,
                        target: $('[data-ax5grid="grid-view-01"]'),
                        columns: [
                            {
                                key: "CHKED", label: "", width: 30, align: "center",
                                label:
                                '<div id="headerBox" data-ax5grid-editor="checkbox" data-ax5grid-checked="false" data-ax5grid-column-selected="true" style="height:17px;width:17px;margin-top:2px;  onclick="javascript:alert(1);"></div>',
                                editor: {
                                    type: "checkbox", config: {height: 17, trueValue: true, falseValue: false}
                                }
                            },
                            {key: "DT_ACCT",        label : "회계일자"      , width: 110, align: "center",sortable: true
                                ,formatter: function () {
                                    return $.changeDataFormat(this.value)
                                }
                            },
                            {key: "TP_GB",          label : "유형"        , width: 80, align: "center",sortable: true
                                ,formatter: function () {
                                    return $.changeTextValue(tp_gb,this.value)
                                }
                            },
                            {key: "BNFT_GB",        label : "편익구분"    , width: 80, align: "left",editor: false,sortable: true
                            ,formatter: function () {
                                    return $.changeTextValue(bnft_gb, this.value)
                                }
                            },
                            {key: "GROUP_NUMBER",   label : "상신번호"      , width: 150, align: "left",editor: false,hidden:true},
                            {key: "NO_DRAFT",       label : "품의번호"      , width: "*", align: "left",editor: false,sortable: true},
                            {key: "NO_DOCU",        label : "전표번호"      , width: "*", align: "left",editor: false,sortable: true},
                            {key: "ST_ING",         label : "진행상태"      , width: "*", align: "left",sortable: true
                                ,formatter: function () {
                                    return $.changeTextValue(st_ing,this.value)
                                }
                            },
                            {key: "IU_DOCUYN",      label : "IU전표여부"    , width: 80, align: "left",editor: false,hidden:true},
                            {key: "IU_ST",          label : "IU상태"        , width: 80, align: "left",editor: false,sortable: true},
                            {key: "NM_DEPT",        label : "작성부서"      , width: 150, align: "left",editor: false,sortable: true},
                            {key: "CD_DEPT",        label : "작성부서코드"  , width: 150, align: "left",editor: false,hidden:true},
                            {key: "NM_EMP",         label : "작성사원"      , width: 150, align: "left",editor: false,sortable: true},
                            {key: "CD_DEPT",        label : "작성사원코드"  , width: 150, align: "left",editor: false,hidden:true},
                            {key: "REMARK",         label : "품의내역"      , width: 150, align: "left",editor: false,sortable: true},
                            {key: "USER_DRAFT",     label : "기안자"      , width: 150, align: "left",editor: false,sortable: true},
                            {key: "AMT",            label : "금액"          , width: 150, align: "right",editor: false, formatter:"money",sortable: true},
                            {key: "FILE",            label : "파일"          , width: 80, align: "center", editor: false,
                                formatter: function(){
                                    return "<button type=\"button\" class=\"btn btn-small\" id=\"BtnHeaderFile\" data-grid-header-btn=\"file\"\n" +
                                        "                            style=\"width:60px;padding:0px;\"><i\n" +
                                        "                            class=\"\"></i> 파일";
                                }
                            },
                            {key: "CD_COMPANY",     label : "회사코드"      , width: 150, align: "center",editor: false,hidden:true},
                            {key: "CHK",            label : ""              , width: 150, align: "center",editor: false,hidden:true}
                        ],
                        body: {
                            onClick: function () {
                                this.self.select(this.dindex);
                                ACTIONS.dispatch(ACTIONS.ITEM_CLICK, this.item);

                                if (this.column.key == "FILE") {
                                    var data = this.item;
                                    modal.open({
                                        top: _pop_top,
                                        width: 1000,
                                        height: _pop_height,
                                        iframe: {
                                            method: "get",
                                            url: "../../common/fiDocuFileBrowser.jsp",
                                            param: "callBack=userCallBack"
                                        },
                                        sendData: {
                                            "P_BOARD_TYPE": 'DOCU', // [ 모듈_메뉴명_해당ID값
                                            "P_SEQ": data.NO_DOCU,
                                            "disabled" : 'true'
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
                            }
                        }
                    });

                    axboot.buttonClick(this, "data-grid-view-01-btn", {
                    });
                },
                getData: function (_type) {
                    var list = [];
                    var _list = this.target.getList(_type);
                    list = _list;

                    return list;
                },
                addRow: function () {
                    this.target.addRow({__created__: true}, "last");
                },
                lastRow:function(){
                    return ($("div [data-ax5grid='grid-view-01']").find( "div [data-ax5grid-panel='body'] table tr").length)
                }
            });


            /**
             * gridView02
             */
            fnObj.gridView02= axboot.viewExtend(axboot.gridView, {
                page: {
                    pageNumber: 0,
                    pageSize: 10
                },
                initView: function () {
                    var _this = this;

                    this.target = axboot.gridBuilder({
                        showRowSelector: true,
                        frozenColumnIndex: 0,
                        target: $('[data-ax5grid="grid-view-02"]'),
                        columns: [
                            {key: "GB",         label: "계정구분"   , width: 100, align: "center" , enable: false},
                            {key: "CD_GB",      label: "계정구분코드"   , width: 0, align: "center" , enable: false, hidden:true},
                            {key: "CD_ACCT",    label: "계정코드"   , width: 100, align: "center" , enable: false},
                            {key: "NM_ACCT",    label: "계정명"   , width: 130, align: "left" , enable: false},
                            {key: "AMT_DR",     label: "차변금액"   , width: 120, align: "right" , enable: false, formatter:"money"},
                            {key: "AMT_CR",     label: "대변금액"   , width: 120, align: "right" , enable: false, formatter:"money"},
                            {key: "REMARK",     label: "적요"   , width: "*", align: "left" , enable: false},
                            {key: "CD_MNGD",    label: "관리항목"   , width: "*", align: "left" , enable: false},
                            {key: "CD_MNG1",  hidden:true}, {key: "CD_MNG2",  hidden:true},
                            {key: "CD_MNG3",  hidden:true}, {key: "CD_MNG4",  hidden:true},
                            {key: "CD_MNG5",  hidden:true}, {key: "CD_MNG6",  hidden:true},
                            {key: "CD_MNG7",  hidden:true}, {key: "CD_MNG8",  hidden:true},
                            {key: "NM_MNG1",  hidden:true}, {key: "NM_MNG2",  hidden:true},
                            {key: "NM_MNG3",  hidden:true}, {key: "NM_MNG4",  hidden:true},
                            {key: "NM_MNG5",  hidden:true}, {key: "NM_MNG6",  hidden:true},
                            {key: "NM_MNG7",  hidden:true}, {key: "NM_MNG8",  hidden:true},
                            {key: "CD_MNGD1",  hidden:true}, {key: "CD_MNGD2",  hidden:true},
                            {key: "CD_MNGD3",  hidden:true}, {key: "CD_MNGD4",  hidden:true},
                            {key: "CD_MNGD5",  hidden:true}, {key: "CD_MNGD6",  hidden:true},
                            {key: "CD_MNGD7",  hidden:true}, {key: "CD_MNGD8",  hidden:true},
                            {key: "NM_MNGD1",  hidden:true}, {key: "NM_MNGD2",  hidden:true},
                            {key: "NM_MNGD3",  hidden:true}, {key: "NM_MNGD4",  hidden:true},
                            {key: "NM_MNGD5",  hidden:true}, {key: "NM_MNGD6",  hidden:true},
                            {key: "NM_MNGD7",  hidden:true}, {key: "NM_MNGD8",  hidden:true},
                        ],
                        footSum: [
                            [
                                {label: "", colspan: 3, align: "center"},
                                {key: "AMT_CR", collector: "sum", formatter: "money", align: "right"},
                                {key: "AMT_DR", collector: "sum", formatter: "money", align: "right"}
                            ]
                        ],
                        body: {
                            onClick: function (e) {
                                this.self.select(this.dindex);
                                if (this.colIndex == 6) {
                                    $.openCustomPopup('customMngdS', "userCallBack", 'CUSTOM_MNGD_PC', this.item ,'',900,330,_pop_top330);
                                }
                            }
                        }
                    });
                },
                lastRow:function(){
                    return ($("div [data-ax5grid='grid-view-02']").find( "div [data-ax5grid-panel='body'] table tr").length)
                }
            });





            var userCallBack ;
            var openPopup = function(name){
                if(name == "pc"){
                    userCallBack = function (e) {
                        if (e.length > 0) {
                            $("#cdPc").val(e[0].NM_PC);
                            $("#cdPc").attr({"code": e[0].CD_PC, "text": e[0].NM_PC});
                        }
                        modal.close();
                    };
                    $.openCustomPopup('customPc', "userCallBack", 'CUSTOM_HELP_PC', $("#cdPc").val() , {P_CD_COMPANY : SCRIPT_SESSION.cdCompany},600,_pop_height,_pop_top);
                }

            };
            function isCheckedTest(data) {
                var array = [];
                var cnt1 = 0;
                var cnt2 = 0;
                for (var i = 0; i < data.length; i++) {
                    if (data[i].CHKED == true && nvl(data[i].IU_DOCUYN) == 'Y') {
                        if (data[i].ST_ING == '01') {
                            array.push(data[i])
                        }else{
                            qray.alert("처리(상신/승인)된 전표는 취소하실수 없습니다.");
                            return false;
                        }
                        if(data[i].BNFT_GB == '1'){
                            cnt1++
                        }
                        if(data[i].BNFT_GB != '1'){
                            cnt2++
                        }
                    }else if(data[i].CHKED == true && nvl(data[i].IU_DOCUYN) == 'N'){
                        array.push(data[i])
                    }
                }
                if(cnt1 > 0 && cnt2 > 0){
                    qray.alert("편익분류 비용처리 건 상신은\n편익분류 전표들끼리만 가능합니다.");
                    return false;
                }
                if(array.length == 0){
                    qray.alert("체크된 데이터가 존재하지 않습니다.");
                    return false;
                }
                return array;
            }

            function isChecked(data) {
                var array = [];
                var cnt1 = 0;
                var cnt2 = 0;
                for (var i = 0; i < data.length; i++) {
                    if (data[i].ST_ING == '01' && data[i].CHKED == true) {
                        array.push(data[i])
                    }
                    if(data[i].ST_ING != '01' && data[i].CHKED == true){
                        qray.alert("미상신 데이터만 선택해야합니다.");
                        return false;
                    }
                    if(data[i].BNFT_GB == '1' && data[i].CHKED == true){
                        cnt1++
                    }
                    if(data[i].BNFT_GB != '1' && data[i].CHKED == true){
                        cnt2++
                    }
                }
                if(cnt1 > 0 && cnt2 > 0){
                    qray.alert("편익분류 비용처리 건 상신은\n편익분류 전표들끼리만 가능합니다.");
                    return false;
                }

                return array;
            }
            var cnt = 0;

            $(document).on('click', '#headerBox', function(caller) {
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
            $('window').ready(function () {
                $("#S_NM_EMP").setPicker([{code: SCRIPT_SESSION.noEmp, text: SCRIPT_SESSION.nmEmp}]);
                $("#S_DEPT").setPicker([{code: SCRIPT_SESSION.cdDept, text: SCRIPT_SESSION.nmDept}]);
            });


            //////////////////////////////////////
            //크기자동조정
            var _pop_top = 0;
            var _pop_top330 = 0;
            var _pop_top700 = 0;
            var _pop_width1400 = 0;
            var _pop_height = 0;
            var _pop_height700 = 0;
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
                    _pop_top = parseInt((totheight - _pop_height) / 2);
                    _pop_top330 = parseInt((totheight - 330) / 2);
                    _pop_top700 = parseInt((totheight - 700) / 2);
                    _pop_width1400 = 1400;
                }
                else{
                    _pop_height = totheight / 10 * 8;
                    _pop_height700 = totheight / 10 * 9;
                    _pop_top = parseInt((totheight - _pop_height) / 2);
                    _pop_top330 = parseInt((totheight - 330) / 2);
                    _pop_top700 = parseInt((totheight - _pop_height700) / 2);
                    _pop_width1400 = 900;
                }

                if(totheight < 550){
                    $("#pgun").css("display","none");
                }
                else{
                    $("#pgun").css("display","");
                }

                $("#S_NM_EMP").attr("HEIGHT",_pop_height);
                $("#S_NM_EMP").attr("TOP",_pop_top);
                $("#S_DEPT").attr("HEIGHT",_pop_height);
                $("#S_DEPT").attr("TOP",_pop_top);
                $("#cdPc").attr("HEIGHT",_pop_height);
                $("#cdPc").attr("TOP",_pop_top);

                //데이터가 들어갈 실제높이
                var datarealheight = $("#ax-base-root").height() - $(".ax-base-title").height() - $("#pageheader").height() - $("middle_area").height();
                //타이틀을 뺀 상하단 그리드 합친높이
                var tempgridheight = datarealheight;

                $("#top_grid").css("height",tempgridheight /100 * 50);
                $("#bottom_grid").css("height",tempgridheight /100 * 49);

                /*
                alert($("#ax-base-root").height()); // 컨텐츠영역높이
                ax-base-title //타이틀부분높이(class)
                ax-base-content //검색조건높이(class)
                 */
            }

            var publishRequestModal = new ax5.ui.modal();

            function openModal(name, action, callBack, viewName) {
                var map = new Map();
                map.set("modal", publishRequestModal);
                map.set("modalText", "publishRequestModal");
                map.set("action", action);
                map.set("keyword", "");
                map.set("viewName", viewName);

                $.openMuiltiPopup(name, callBack, map, 600, _pop_height, _pop_top);
            }
        </script>
    </jsp:attribute>
    <jsp:body>

        <div data-page-buttons="">
            <div class="button-warp">
                <span style="margin-right: 25px" id="pgun">* 편익분류 비용처리 건 상신은 편익분류 전표들끼리만 가능합니다.</span>
                <button type="button" class="btn btn-reload" data-page-btn="reload" onclick="window.location.reload();" style="width:80px;"><i class="icon_reload"></i></button>
                <button type="button" class="btn btn-info" data-page-btn="search" style="width:80px;"><i class="icon_search"></i><ax:lang id="ax.admin.sample.modal.button.search"/></button>
                <button type="button" class="btn btn-info" data-page-btn="apply" style="width:80px;"><i class="icon_ok"></i>결재요청</button>
<%--                <button type="button" class="btn btn-info" data-page-btn="test" style="width:120px;"><i class="icon_save"></i>상신/승인/반려/취소</button>--%>
                <button type="button" class="btn btn-info"  data-page-btn="applyCancel" style="width:80px;"><i class="icon_reject" ></i>상신취소</button>
                <button type="button" class="btn btn-info"  data-page-btn="cancel" style="width:80px;"><i class="icon_reject" ></i>전표취소</button>
            </div>
        </div>


        <div role="page-header" id="pageheader">
            <ax:form name="searchView0">
                <ax:tbl clazz="ax-search-tb1" >
                    <ax:tr>
                        <ax:td label='회계단위' width="350px">
                            <codepicker id="cdPc" HELP_ACTION="HELP_PC" HELP_URL="pc" BIND-CODE="CD_PC"
                                        BIND-TEXT="NM_PC" READONLY SESSION/>
                        </ax:td>
                        <ax:td label='작성부서' width="350px">
                            <multipicker id="S_DEPT" HELP_ACTION="HELP_DEPT" HELP_URL="multiDept" BIND-CODE="CD_DEPT"
                                         BIND-TEXT="NM_DEPT"/>
                        </ax:td>
                        <ax:td label='회계일자' width="350px">
                            <div class="input-group" data-ax5picker="basic">
                                <input type="text" class="form-control" placeholder="yyyy/mm/dd" id="S_DT_START" formatter="YYYYMMDD">
                                <span class="input-group-addon">~</span>
                                <input type="text" class="form-control" placeholder="yyyy/mm/dd" id="S_DT_END" formatter="YYYYMMDD">
                                <span class="input-group-addon"><i class="cqc-calendar"></i></span>
                            </div>
                        </ax:td>
                        <ax:td label="유형" width="350px">
                            <div id = "S_TP_GB" data-ax5select="S_TP_GB" data-ax5select-config='{}'></div>
                        </ax:td>
                        <ax:td label="편익구분" width="350px">
                            <div id = "S_BNFT_GB" data-ax5select="S_BNFT_GB" data-ax5select-config='{}'></div>
                        </ax:td>
                        <ax:td label='진행상태' width="350px">
                            <div id = "S_ST_ING" data-ax5select="S_ST_ING" data-ax5select-config='{}'></div>
                        </ax:td>
                        <ax:td label='작성사원' width="350px">
                            <multipicker id="S_NM_EMP" HELP_ACTION="HELP_MULTI_EMP" HELP_URL="multiEmp" BIND-CODE="NO_EMP"
                                         BIND-TEXT="NM_EMP"/>
                        </ax:td>
                    </ax:tr>
                </ax:tbl>
            </ax:form>
            <div class="H10"></div>
        </div>
        <div style="width:100%">
            <div data-ax5grid="grid-view-01"
                 data-ax5grid-config="{  showLineNumber: true,showRowSelector: false, multipleSelect: false,lineNumberColumnWidth: 40,rowSelectorColumnWidth: 27, }"
                 id = "top_grid"
            ></div>
            <div id="middle_area" style="min-height:5px;height:5px;">
            </div>
            <div data-ax5grid="grid-view-02"
                 data-ax5grid-config="{  showLineNumber: true,showRowSelector: false, multipleSelect: false,lineNumberColumnWidth: 40,rowSelectorColumnWidth: 27, }"
                 id = "bottom_grid"
            ></div>
        </div>

    </jsp:body>
</ax:layout>