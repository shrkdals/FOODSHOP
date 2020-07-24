<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>

<ax:set key="title" value="매입세금계산서관리"/>
<ax:set key="page_desc" value="${pageRemark}"/>
<ax:set key="page_auto_height" value="true"/>


<ax:layout name="base">
    <jsp:attribute name="script">
        <ax:script-lang key="ax.script"/>
        <script type="text/javascript">
            /************ 선행 스크립트 START ************/
            var group = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, "CZ_Q0018");
            console.log(group);
            var picker = new ax5.ui.picker();
            var today = new Date();
            var dtF = ax5.util.date(today, {"return": "yyyy-MM-01"});
            var dtT = ax5.util.date(today, {"return": "yyyy-MM"}) + '-' + ax5.util.daysOfMonth(today.getFullYear(), today.getMonth());
            var dtNow = ax5.util.date(today, {"return": "yyyy-MM-dd"});
            var calenderModal = new ax5.ui.modal();
            function openCalenderModal(callBack, viewName, initData) {  //  관리항목 CALENDER 도움창오픈
                var map = new Map();
                map.set("modal", calenderModal);
                map.set("modalText", "calenderModal");
                map.set("viewName", viewName);

                $.openCommonUtils(callBack, map, 'calender',340,450,_pop_top450);
            }
            picker.bind({
                target: $('[data-ax5picker="basic"]'),
                direction: "top",
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

                            $("#YMD_WRITE_END").val(dtNow);
                            $("#YMD_WRITE_START").val(dtNow);
                            this.self.close();
                        }
                    },
                    thisMonth: {
                        label: "이번달", onClick: function () {
                            $("#YMD_WRITE_END").val(dtT);
                            $("#YMD_WRITE_START").val(dtF);
                            this.self.close();
                        }
                    },
                    ok: {label: "확인", theme: "default"}
                }
            });

            var tax_gb = [].concat($.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany,'CZ_Q0014'));
            tax_gb = tax_gb.concat($.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany,'CZ_Q0015'));
            tax_gb = tax_gb.concat($.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany,'CZ_Q0016'));

            $("#YMD_WRITE_START").val(getPastDate());
            $("#YMD_WRITE_END").val(getRecentDate());

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


            /************ 선행 스크립트 END ************/
            var modal = new ax5.ui.modal();
            var Grid1CallBack = function (e) {
                if (e.length > 0) {
                    fnObj.gridView01.target.setValue(selectIdx, "CD_ACCT", e[0].CD_ACCT);
                    fnObj.gridView01.target.setValue(selectIdx, "NM_ACCT", e[0].NM_ACCT);
                }
                modal.close();
            };

            var fnObj = {}, CODE = {};
            var ACTIONS = axboot.actionExtend(fnObj, {
                PAGE_SEARCH: function (caller, act, data) {
                    if(nvl($("#cdEmp").getCodes()) == '' && nvl($("#SELL_NO_BIZ").val()) == '' && nvl($("#NO_TAX").val()) == ''){
                        qray.alert("조회 조건이 불충분합니다.");
                        return;
                    }

                    axboot.ajax({
                        type: "POST",
                        url: ["apTaxBill", "getTaxBillList"],
                        // async : false,
                        data: JSON.stringify(
                            {
                                YMD_WRITE_START : $("#YMD_WRITE_START").val()
                                , YMD_WRITE_END:  $("#YMD_WRITE_END").val()
                                , NO_EMAIL : $("#cdEmp").getCodes()
                                , SELL_NO_BIZ : $("#SELL_NO_BIZ").val()
                                , NO_TAX : $("#NO_TAX").val()
                            }
                        ),
                        callback: function (res) {
                            caller.gridView01.clear();
                            // if(res.list.length > 0){
                                caller.gridView01.setData(res);
                            // }

                        }
                    });
                    //var result = $.DATA_SEARCH("apTaxBill", "getTaxBillList")
                    return false;
                },
                PARTNER_CREATE: function (caller, act, data) {
                    var createList = isChecked(caller.gridView01.getData("CHK"));

                    if (createList.length == 0) {
                        qray.alert("체크된 항목이 없습니다.");
                        return false;
                    }
                    if (createList.exist > 0) {
                        qray.alert("이미 등록된 거래처가 존재합니다.");
                        return false;
                    }

                    axboot.ajax({
                        type: "PUT",
                        url: ["apTaxBill", "partnerCreate"],
                        data: JSON.stringify({list: createList.result}),
                        callback: function (res) {
                            qray.alert("거래처 등록이 되었습니다.");
                            console.log("[ *** SAVE CALLBACK EVENT *** ]");
                            ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                        }
                    });
                },
                DOCU_CREATE: function (caller, act, data) {
                    var createList = isChecked(caller.gridView01.getData("CHK"));
                    var tax = [];
                    if (createList.length == 0) {
                        qray.alert("체크된 항목이 없습니다.");
                        return false;
                    }
                    if (createList.notExist > 0) {
                        qray.alert("미등록된 거래처가 존재합니다.");
                        return false;
                    }
                    for(var i = 0; i < createList.length; i++){
                        if(createList.result[i].NO_DOCU){
                            qray.alert("이미 전표처리된 데이터가 존재합니다.");
                            return false;
                        }
                        tax.push(createList.result[i].NO_TAX)
                    }
                    var result = $.DATA_SEARCH("apTaxBill","getSelectCheck",{ CD_COMPANY : SCRIPT_SESSION.cdCompany, NO_TAX : tax.join('|')});
                    if(result.map.YN == 'Y'){
                        qray.alert("이미 전표처리된 데이터가 존재합니다.");
                        return false;
                    }
                    userCallBack = function (e) {
                        modal.close({
                            callback : function(){
                                console.log(e);
                                if(e.YN == 'Y'){
                                    menuInfo = {menuId: "10505", id: "10505",  menuNm: "전표등록" ,name: "전표관리" , parentId : "5" , progNm: "회계전표등록", progPh: "/jsp/ensys/gl/p_cz_q_gl_docu_m.jsp"};
                                    sessionStorage.setItem("prevmenuid", "10502");
                                    parent.fnObj.tabView.urlSetData({RESULT : createList.result , DT_ACCT : e.DT_ACCT , REMARK : e.REMARK , CD_DOCU : e.DOCU_TP });
                                    try{
                                        parent.fnObj.tabView.close("10505")
                                    }catch(e){

                                    }
                                    parent.fnObj.tabView.open(menuInfo);
                                }
                            }
                        });
                    };
                    $.openCommonPopup('apTaxbillDocu', 'userCallBack', '', '', {RESULT : createList.result}, 600, 180,_pop_top180);


                }
            });

            // fnObj 기본 함수 스타트와 리사이즈
            fnObj.pageStart = function () {
                this.pageButtonView.initView();
                this.searchView.initView();
                this.gridView01.initView();

                ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
            };


            fnObj.pageResize = function () {

            };

            fnObj.pageButtonView = axboot.viewExtend({
                initView: function () {
                    axboot.buttonClick(this, "data-page-btn", {
                        "search": function () {
                            ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                        },
                        "docuCreateBtn": function () {
                            ACTIONS.dispatch(ACTIONS.DOCU_CREATE);
                        },
                        "partnerCreateBtn": function () {
                            ACTIONS.dispatch(ACTIONS.PARTNER_CREATE);
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
                    return {}
                }
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
                                key: "CHK", label: "", width: 60, align: "center",
                                editor: {
                                    type: "checkbox", config: {height: 17, trueValue: true, falseValue: false}
                                }
                            },
                            {key: "PUSAIV_YN", label: "전표발행유무", width: 90, align: "left", editor: false, sortable: true,},
                            {key: "NO_TAX", label: "승인번호", width: 150, align: "center", editor: false, sortable: true,},
                            {key: "NO_DOCU", label: "전표번호", width: 120, align: "right", editor: false, hidden: false, sortable: true,},
                            {
                                key: "DT_INEND", label: "지급요청일자", width: 100, align: "center", editor: false, sortable: true,
                                formatter: function () {
                                    if (this.value != undefined) {
                                        return this.value.replace(/(\d{4})(\d{2})(\d{2})/, '$1-$2-$3');
                                    }
                                }
                            },
                            {
                                key: "YMD_WRITE", label: "작성일자", width: 100, align: "center", editor: false, sortable: true,
                                formatter: function () {
                                    if (this.value != undefined) {
                                        return this.value.replace(/(\d{4})(\d{2})(\d{2})/, '$1-$2-$3');
                                    }
                                }
                            },
                            {key: "CD_PARTNER", label: "거래처코드", width: 100, align: "left", editor: false, sortable: true,},
                            {key: "SELL_NM_CORP", label: "거래처명", width: 180, align: "left", editor: false, sortable: true,},
                            {key: "SELL_NO_BIZ", label: "사업자등록번호", width: 120, align: "center", editor: false, sortable: true,},
                            {key: "PARTNER_YN", label: "거래처등록여부", width: 80, align: "center", editor: false, sortable: true,},
                            {key: "FG_VAT", label: "세무구분", width: 60, align: "left", editor: false, sortable: true
                                ,formatter: function () {
                                    return $.changeTextValue(tax_gb,this.value)
                                }
                            },
                            {key: "AM", label: "공급가액", width: 120, align: "right", editor: false, formatter: "money", sortable: true,},
                            {key: "AM_VAT", label: "부가세", width: 100, align: "right", editor: false, formatter: "money", sortable: true,},
                            {key: "AMT", label: "합계금액", width: 120, align: "right", editor: false, formatter: "money", sortable: true,},
                            {key: "BUY_DAM_EMAIL", label: "담당자E-MAIL", width: 180, align: "left", editor: false, sortable: true,},
                            {key: "NM_ITEM1", label: "품목명", width: 180, align: "left", editor: false, sortable: true,},
                            {key: "CD_COMPANY", label: "회사코드", width: 180, align: "right", editor: false, hidden: true},
                            {key: "SELL_NM_CEO", label: "거래처대표명", width: 180, align: "right", editor: false, hidden: true},
                            {key: "SELL_ADDR1", label: "주소", width: 180, align: "right", editor: false, hidden: true},
                            {key: "SELL_ADDR2", label: "주소2", width: 180, align: "right", editor: false, hidden: true},
                            {key: "DT_ACCT", label: "지급완료일자", width: 180, align: "right", editor: false, hidden: true}
                        ],
                        body: {
                            onClick: function () {
                                this.self.select(this.dindex);
                                if (this.colIndex == 1 && this.item.__created__ == true) {
                                    modal.open({
                                        width: 600,
                                        height: _pop_height,
                                        top: _pop_top,
                                        iframe: {
                                            method: "get",
                                            url: "../MaAcctCodeHelper.jsp",
                                            param: "callBack=Grid1CallBack&&TP_DRCR=1"
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
                                }
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
                var result = [];
                var exist = 0;
                var notExist = 0;
                var length = 0;
                for (var i = 0; i < data.length; i++) {
                    if (data[i].PARTNER_YN == '등록' && data[i].CHK) {
                        exist++;
                    }
                    if (data[i].PARTNER_YN == '미등록' && data[i].CHK) {
                        notExist++;
                    }
                    if (data[i].CHK) {
                        result.push(data[i]);
                        length++;
                    }
                }

                return {result: result, length: length, exist: exist, notExist: notExist};
            }

            $('document').ready(function () {
                var Idcnt = 0;
                for(var i = 0; i < group.length; i++){
                    if(group[i].text == SCRIPT_SESSION.idUser){
                        Idcnt++;
                    }
                }

                if(Idcnt == 0) {
                    $("#cdEmp").attr("HELP_DISABLED", true);
                    $("#cdEmp").setDisabled(true)
                    // $("#cdEmp").find("#multi a").attr("disabled", "disabled");
                    // $("#cdEmp").find("#multi i").attr("disabled", "disabled");
                }else{
                    $("#cdEmp").setDisabled(false)
                    // $("#cdEmp").find("#multi a").removeAttr("disabled");
                    // $("#cdEmp").find("#multi i").removeAttr("disabled");
                }

                // $("#cdEmp").keydown(function (e) {
                //     if (e.keyCode == '8' || e.keyCode == '16') {
                //         $("#cdEmp").val("");
                //         $("#cdEmp").attr({code: "", text: ""})
                //     }
                // })
            });
            $('window').ready(function () {
                $("#cdEmp").setPicker([{code: SCRIPT_SESSION.noEmp, text: SCRIPT_SESSION.nmEmp}]);
            });

            //////////////////////////////////////
            //크기자동조정
            var _pop_top = 0;
            var _pop_top180 = 0;
            var _pop_top450 = 0;
            var _pop_height = 0;
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
                    _pop_top = parseInt((totheight - _pop_height) / 2);
                    _pop_top180 = parseInt((totheight - 180) / 2);
                    _pop_top450 = parseInt((totheight - 450) / 2);
                }
                else{
                    _pop_height = totheight / 10 * 8;
                    _pop_top = parseInt((totheight - _pop_height) / 2);
                    _pop_top180 = parseInt((totheight - 180) / 2);
                    _pop_top450 = parseInt((totheight - (totheight / 10 * 9)) / 2);
                }

                $("#cdEmp").attr("HEIGHT",_pop_height);
                $("#cdEmp").attr("TOP",_pop_top);

                //데이터가 들어갈 실제높이
                var datarealheight = $("#ax-base-root").height() - $(".ax-base-title").height() - $("#pageheader").height();
                //타이틀을 뺀 상하단 그리드 합친높이
                //var tempgridheight = datarealheight - $("#top_title").height() - $("#bottom_left_title").height() - $("#bottom_left_amt").height();
                var tempgridheight = datarealheight;

                $("#top_grid").css("height",tempgridheight /100 * 99);

                /*
                alert($("#ax-base-root").height()); // 컨텐츠영역높이
                ax-base-title //타이틀부분높이(class)
                ax-base-content //검색조건높이(class)
                 */
            }

        </script>
    </jsp:attribute>
    <jsp:body>

<%--        <div id="loading"><img id="loading-image" src="/assets/css/images/common/loadingSpinner2.gif" alt="테스트테스트테스트테스트테스트테스트" /></div>--%>

        <div data-page-buttons="">
            <div class="button-warp">
                <span style="margin-right: 25px">* 편익분류 비용처리 건은 건별 전표생성만 가능합니다.</span>
                <button type="button" class="btn btn-reload" data-page-btn="reload" onclick="window.location.reload();" style="width:80px;">
                    <i class="icon_reload"></i></button>
                <button type="button" class="btn btn-info" data-page-btn="search" style="width:80px;"><i class="icon_search"></i><ax:lang
                        id="ax.admin.sample.modal.button.search"/></button>
                <button type="button" class="btn btn-info" data-page-btn="docuCreateBtn" style="width:100px;"><i class="icon_save"></i>가전표생성
                </button>
                <button type="button" class="btn btn-info" data-page-btn="partnerCreateBtn" style="width:100px;"><i class="icon_save"></i>거래처등록
                </button>
            </div>
        </div>

        <div role="page-header" id="pageheader">
            <ax:form name="searchView0">
                <ax:tbl clazz="ax-search-tb1" minWidth="500px">
                    <ax:tr>
                        <ax:td label='작성일자' width="400px">
                            <div class="input-group" data-ax5picker="basic">
                                <input type="text" class="form-control" placeholder="yyyy/mm/dd" id="YMD_WRITE_START" formatter="YYYYMMDD">
                                <span class="input-group-addon">~</span>
                                <input type="text" class="form-control" placeholder="yyyy/mm/dd" id="YMD_WRITE_END" formatter="YYYYMMDD">
                                <span class="input-group-addon"><i class="cqc-calendar"></i></span>
                            </div>
                        </ax:td>
                        <ax:td label='작성사원' width="350px">
                            <multipicker id="cdEmp" HELP_ACTION="HELP_MULTI_EMP" HELP_URL="multiEmp" BIND-CODE="NO_EMP"
                                         BIND-TEXT="NM_EMP"/>
<%--                            <codepicker id="cdEmp" HELP_ACTION="HELP_USER" HELP_URL="user" BIND-CODE="NO_EMP"--%>
<%--                                        BIND-TEXT="NM_EMP" READONLY SESSION />--%>
                        </ax:td>
                        <ax:td label='승인번호' width="350px">
                            <input type="text" class="form-control" id="NO_TAX">
                        </ax:td>
                        <ax:td label='거래처사업자번호' width="350px">
                            <input type="text" class="form-control" id="SELL_NO_BIZ">
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
        </div>

    </jsp:body>
</ax:layout>