<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>

<ax:set key="title" value="채권채무상계처리"/>
<ax:set key="page_desc" value="${pageRemark}"/>
<ax:set key="page_auto_height" value="true"/>


<ax:layout name="base">
    <jsp:attribute name="script">
        <ax:script-lang key="ax.script"/>
        <style>
            .red {
                background: #ffe0cf !important;
            }
            .green{
                background: rgb(209, 255, 209) !important;
            }
            .gray{
                background: rgba( 0, 0, 0, 0.2 ) !important;
            }
        </style>

        <script type="text/javascript">
            /************ 선행 스크립트 START ************/
            var picker = new ax5.ui.picker();
            var mask = new ax5.ui.mask();
            picker.bind({
                target: $('[data-ax5picker="basic1"]'),
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

            picker.bind({
                target: $('[data-ax5picker="basic2"]'),
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

            picker.bind({
                target: $('[data-ax5picker="basic3"]'),
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

            $(document.body).ready(function () {
                $("#CD_ACCT1").setHelpParam(JSON.stringify({TP_DRCR: '2',BAN :'Y'}));
                $("#CD_ACCT2").setHelpParam(JSON.stringify({TP_DRCR: '1',BAN :'Y'}));
                $("#DT_START1").val(getPastDate());
                $("#DT_END1").val(getRecentDate());
                $("#DT_START2").val(getPastDate());
                $("#DT_END2").val(getRecentDate());
                $("#CD_MNG1").keydown(function (e) {
                    if (e.keyCode == '8' || e.keyCode == '16') {
                        $("#CD_MNG1").val("");
                        $("#CD_MNG1").attr({code: "", text: ""})
                    }
                });
                $("#CD_MNG2").keydown(function (e) {
                    if (e.keyCode == '8' || e.keyCode == '16') {
                        $("#CD_MNG2").val("");
                        $("#CD_MNG2").attr({code: "", text: ""})
                    }
                })
            });
            $('window').ready(function () {
                // var check = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany,'CZ_Q0013');
                // console.log(check)
                //
                // for(var i = 0; i < check.length; i++){
                //     if(SCRIPT_SESSION.noEmp != check[i].text){
                //         $("#codepicker [name='cdPartner1']").attr("HELP_DISABLED", "true")
                //         $("#codepicker [name='cdPartner2']").attr("HELP_DISABLED", "true")
                //     }
                // }
            });
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
                    // if(nvl($("#cdPartner2").attr("code")) == '' || nvl($("#cdPartner1").attr("code")) == ''){
                        // qray.alert("거래처 선택은 필수항목입니다.")
                        // return false;
                    // }
                    data1 = {
                         CD_ACCT :$("#CD_ACCT1").getCodes()
                        ,DT_START : $("#DT_START1").val().replace(/-/g, "")
                        ,DT_END : $("#DT_END1").val().replace(/-/g, "")
                        ,CD_MNG : $("#CD_MNG1").attr("code")
                        ,CD_MNGD : $("#CD_MNGD1").val()
                        ,CD_DEPT : $("#cdDept1").getCodes()
                        ,CD_PARTNER : $("#cdPartner1").attr("code")
                        ,TP_DRCR : '2'
                        ,NM_NOTE : $("#NM_NOTE1").val()
                    };
                    data2 = {
                        CD_ACCT :$("#CD_ACCT2").getCodes()
                        ,DT_START : $("#DT_START2").val().replace(/-/g, "")
                        ,DT_END : $("#DT_END2").val().replace(/-/g, "")
                        ,CD_MNG : $("#CD_MNG2").attr("code")
                        ,CD_MNGD : $("#CD_MNGD2").val()
                        ,CD_DEPT : $("#cdDept2").getCodes()
                        ,CD_PARTNER : $("#cdPartner2").attr("code")
                        ,TP_DRCR : '1'
                        ,NM_NOTE : $("#NM_NOTE2").val()
                    };
                    var result = $.DATA_SEARCH("apArnetting","selectList",data1);
                    caller.gridView01.target.setData(result);
                    result = $.DATA_SEARCH("apArnetting","selectList",data2);
                    caller.gridView02.target.setData(result)

                },
                SELECT_LIST: function (caller, act, data) {
                    var data1 = isChecked(fnObj.gridView01.getData());
                    var data2 = isChecked(fnObj.gridView02.getData());
                    if(data1.length == 0 && data2.length == 0){
                        qray.alert("선택된 데이터가 없습니다.");
                        return false;
                    }
                    data1.forEach(function(e, i){
                        caller.gridView03.addRow();
                        index = caller.gridView03.getData().length - 1;
                        caller.gridView03.target.select(index);
                        caller.gridView03.target.setValue(index, "NM_TP_DRCR", '1');
                        caller.gridView03.target.setValue(index, "NM_ACCT", e.NM_ACCT);
                        caller.gridView03.target.setValue(index, "DT_ACCT", e.DT_ACCT);
                        caller.gridView03.target.setValue(index, "NM_NOTE", e.NM_NOTE);
                        caller.gridView03.target.setValue(index, "AM_DOCU", e.AM_DOCU);
                        caller.gridView03.target.setValue(index, "AM_JAN", e.AM_JAN);
                        caller.gridView03.target.setValue(index, "AM_DR", 0);
                        caller.gridView03.target.setValue(index, "AM_CR", e.AM_JAN);
                        caller.gridView03.target.setValue(index, "JAN", 0);
                        caller.gridView03.target.setValue(index, "LN_PARTNER", e.LN_PARTNER);
                        caller.gridView03.target.setValue(index, "NO_DOCU", e.NO_DOCU);
                        caller.gridView03.target.setValue(index, "NM_MNGD1", e.NM_MNGD1);
                        caller.gridView03.target.setValue(index, "NM_MNGD2", e.NM_MNGD2);
                        caller.gridView03.target.setValue(index, "NO_DOLINE", e.NO_DOLINE);
                        caller.gridView03.target.setValue(index, "CD_ACCT", e.CD_ACCT);
                        // caller.gridView01.target.setValue(index, "", e.);

                    });
                    data2.forEach(function(e, i){
                        caller.gridView03.addRow();
                        index = caller.gridView03.getData().length - 1;
                        caller.gridView03.target.select(index);
                        caller.gridView03.target.setValue(index, "NM_TP_DRCR", '2');
                        caller.gridView03.target.setValue(index, "NM_ACCT", e.NM_ACCT);
                        caller.gridView03.target.setValue(index, "DT_ACCT", e.DT_ACCT);
                        caller.gridView03.target.setValue(index, "NM_NOTE", e.NM_NOTE);
                        caller.gridView03.target.setValue(index, "AM_DOCU", e.AM_DOCU);
                        caller.gridView03.target.setValue(index, "AM_JAN", e.AM_JAN);
                        caller.gridView03.target.setValue(index, "AM_DR", e.AM_JAN);
                        caller.gridView03.target.setValue(index, "AM_CR", 0);
                        caller.gridView03.target.setValue(index, "JAN", 0);
                        caller.gridView03.target.setValue(index, "LN_PARTNER", e.LN_PARTNER);
                        caller.gridView03.target.setValue(index, "NO_DOCU", e.NO_DOCU);
                        caller.gridView03.target.setValue(index, "NM_MNGD1", e.NM_MNGD1);
                        caller.gridView03.target.setValue(index, "NM_MNGD2", e.NM_MNGD2);
                        caller.gridView03.target.setValue(index, "NO_DOLINE", e.NO_DOLINE);
                        caller.gridView03.target.setValue(index, "CD_ACCT", e.CD_ACCT);
                        // caller.gridView01.target.setValue(index, "", e.);
                    });

                    var gridList = fnObj.gridView01.getData();
                    gridList.forEach(function(e, i){
                        fnObj.gridView01.target.setValue(i,"CHKED",false);
                    });
                    gridList = fnObj.gridView02.getData();
                    gridList.forEach(function(e, i){
                        fnObj.gridView02.target.setValue(i,"CHKED",false);
                    });
                },
                CANCEL: function (caller, act, data) {
                    var data3 = isChecked(fnObj.gridView03.getData());
                    for(var i = data3.length - 1 ; i >= 0; i--){
                        fnObj.gridView03.target.removeRow(data3[i].__index)
                    }
                },
                APPLY : function (caller, act, data) {
                    if(nvl($("#cdPc").attr("code")) == ''){
                        qray.alert("회계단위는 필수입니다.");
                        return false;
                    }
                    if(nvl($("#cdDept").attr("code")) ==''){
                        qray.alert("부서선택은 필수입니다.");
                        return false;
                    }
                    if(nvl($("#cdEmp").attr("code")) ==''){
                        qray.alert("사원선택은 필수입니다.");
                        return false;
                    }
                    if(nvl($("#DT_ACCT").val().replace(/-/g, "")) ==''){
                        qray.alert("회계일자는 필수입니다.");
                        return false;
                    }
                    if(nvl($("#REMARK").val()) ==''){
                        qray.alert("품의내역은 필수입니다.");
                        return false;
                    }



                    if($("#GAP").val() != 0){
                        qray.alert("차액이 존재합니다.");
                        return false;
                    }
                    var param = {
                         list : fnObj.gridView03.getData()
                        ,CD_PC : $("#cdPc").attr("code")
                        ,CD_DEPT : $("#cdDept").attr("code")
                        ,NO_EMP : $("#cdEmp").attr("code")
                        ,DT_ACCT : $("#DT_ACCT").val().replace(/-/g, "")
                        ,REMARK : $("#REMARK").val()
                    };
                    axboot.ajax({
                        type: "PUT",
                        url: ["apArnetting", "apply"],
                        data: JSON.stringify(param),
                        callback: function (res) {
                            qray.alert("저장 되었습니다.");
                            fnObj.gridView03.clear();
                            ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                        }
                    });

                }
            });
            // fnObj 기본 함수 스타트와 리사이즈
            fnObj.pageStart = function () {
                this.pageButtonView.initView();
                this.searchView.initView();
                this.gridView01.initView();
                this.gridView02.initView();
                this.gridView03.initView();
            };


            fnObj.pageResize = function () {

            };

            fnObj.pageButtonView = axboot.viewExtend({
                initView: function () {
                    axboot.buttonClick(this, "data-page-btn", {
                        "search": function () {
                            ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                        },
                        "select": function () {
                            ACTIONS.dispatch(ACTIONS.SELECT_LIST);
                        },
                        "cancel": function () {
                            ACTIONS.dispatch(ACTIONS.CANCEL);
                        },
                        "apply": function () {
                            ACTIONS.dispatch(ACTIONS.APPLY);
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
                                key: "CHKED",
                                label: '<div id="headerBox1" data-ax5grid-editor="checkbox" data-ax5grid-checked="false" data-ax5grid-column-selected="true" style="height:17px;width:17px;margin-top:2px;  onclick="javascript:alert(1);"></div>',
                                width: 60, align: "center",
                                editor: {
                                    type: "checkbox", config: {height: 17, trueValue: true, falseValue: false}
                                }
                            },
                            {key: "CD_ACCT", label: "계정코드", width: 120, align: "left", editor: false},
                            {key: "NM_ACCT", label: "계정명", width: 120, align: "left", editor: false},
                            {key: "DT_ACCT", label: "발생일자", width: 120, align: "left", editor: false},
                            {key: "NM_NOTE", label: "적요", width: 120, align: "left", editor: false},
                            {key: "AM_JAN", label: "잔액", width: 120, align: "right", editor: false},
                            {key: "AM_DOCU", label: "원인금액", width: 120, align: "right", editor: false},
                            {key: "LN_PARTNER", label: "거래처", width: 120, align: "left", editor: false},
                            {key: "NO_DOCU", label: "전표번호", width: 120, align: "left", editor: false},
                            {key: "NO_DOLINE", label: "순번", width: 120, align: "left", editor: false},
                            {key: "NM_MNGD1", label: "관리항목1", width: 120, align: "left", editor: false},
                            {key: "NM_MNGD2", label: "관리항목2", width: 120, align: "left", editor: false}

                        ],
                        body: {
                            onClick: function () {
                                this.self.select(this.dindex);
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
                        frozenColumnIndex: 0,
                        target: $('[data-ax5grid="grid-view-02"]'),
                        columns: [
                            {
                                key: "CHKED",
                                label: '<div id="headerBox2" data-ax5grid-editor="checkbox" data-ax5grid-checked="false" data-ax5grid-column-selected="true" style="height:17px;width:17px;margin-top:2px;  onclick="javascript:alert(1);"></div>',
                                width: 60, align: "center",
                                editor: {
                                    type: "checkbox", config: {height: 17, trueValue: true, falseValue: false}
                                }
                            },
                            {key: "CD_ACCT", label: "계정코드", width: 120, align: "left", editor: false},
                            {key: "NM_ACCT", label: "계정명", width: 120, align: "left", editor: false},
                            {key: "DT_ACCT", label: "발생일자", width: 120, align: "left", editor: false},
                            {key: "NM_NOTE", label: "적요", width: 120, align: "left", editor: false},
                            {key: "AM_JAN", label: "잔액", width: 120, align: "right", editor: false},
                            {key: "AM_DOCU", label: "원인금액", width: 120, align: "right", editor: false},
                            {key: "LN_PARTNER", label: "거래처", width: 120, align: "left", editor: false},
                            {key: "NO_DOCU", label: "전표번호", width: 120, align: "left", editor: false},
                            {key: "NO_DOLINE", label: "순번", width: 120, align: "left", editor: false},
                            {key: "NM_MNGD1", label: "관리항목1", width: 120, align: "left", editor: false},
                            {key: "NM_MNGD2", label: "관리항목2", width: 120, align: "left", editor: false}
                        ],
                        body: {
                            onClick: function () {
                                this.self.select(this.dindex);
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

            var code = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany,'CZ_Q0004');
            /**
             * gridView03
             */
            fnObj.gridView03 = axboot.viewExtend(axboot.gridView, {
                page: {
                    pageNumber: 0,
                    pageSize: 10
                },
                initView: function () {
                    var _this = this;

                    this.target = axboot.gridBuilder({
                        showRowSelector: true,
                        frozenColumnIndex: 0,
                        target: $('[data-ax5grid="grid-view-03"]'),
                        columns: [
                            {
                                key: "CHKED", label: '<div id="headerBox3" data-ax5grid-editor="checkbox" data-ax5grid-checked="false" data-ax5grid-column-selected="true" style="height:17px;width:17px;margin-top:2px;  onclick="javascript:alert(1);"></div>',
                                width: 60, align: "center",
                                editor: {
                                    type: "checkbox", config: {height: 17, trueValue: true, falseValue: false}
                                }
                            },
                            {key: "NO_DOCUBAN", label: "반제전표번호", width: 100, align: "left", editor: false},
                            {key: "NM_TP_DRCR", label: "구분", width: 100, align: "left", editor: false
                                ,formatter: function () {
                                    return $.changeTextValue(code, this.value)
                                }
                            },
                            {key: "CD_ACCT", label: "계정코드", width: 120, align: "left", editor: false},
                            {key: "NM_ACCT", label: "계정명", width: 100, align: "left", editor: false},
                            {key: "DT_ACCT", label: "발생일자", width: 100, align: "left", editor: false},
                            {key: "NM_NOTE", label: "적요", width: 100, align: "left", editor: false},
                            {key: "AM_DOCU", label: "원인금액", width: 100, align: "right", editor: false},
                            {key: "AM_JAN", label: "반제 전 잔액", width: 100, align: "right", editor: false},
                            {key: "AM_DR", label: "차변 반제금액", width: 100, align: "right"
                                ,styleClass: function () {
                                    // return (this.item.NM_TP_DRCR == '1') ? "gray" : "green";
                                    return 'red'
                                }
                                , editor: {type: "number"
                                    , disabled: function () {
                                        if(this.item.NM_TP_DRCR == '1'){
                                            return true;
                                        }else{
                                            return false;
                                        }
                                    }
                                },
                                formatter: "money"
                            },
                            {key: "AM_CR", label: "대변 반제금액", width: 100, align: "right"
                                ,styleClass: function () {
                                // return (this.item.NM_TP_DRCR == '1') ? "green" : "gray";
                                    return 'red'
                                }
                                , editor: {type: "number"
                                    , disabled: function () {
                                        if(this.item.NM_TP_DRCR == '1'){
                                            return false;
                                        }else{
                                            return true;
                                        }
                                    }
                                },
                                formatter: "money"
                            },
                            {key: "JAN", label: "반제 후 잔액", width: 100, align: "right", editor: false},
                            {key: "LN_PARTNER", label: "거래처", width: 100, align: "left", editor: false},
                            {key: "NO_DOCU", label: "전표번호", width: 100, align: "left", editor: false},
                            {key: "NM_MNGD1", label: "관리항목1", width: 100, align: "left", editor: false},
                            {key: "NM_MNGD2", label: "관리항목2", width: 100, align: "left", editor: false},
                            {key: "NO_DOLINE", label: "순번", width: 120, align: "left", editor: false},
                        ],
                        body: {
                            onClick: function () {
                                this.self.select(this.dindex);
                            }
                            ,onDataChanged : function(){
                                if(this.key == "AM_CR" || this.key == "AM_DR"){
                                    if(Number(this.value) > this.item.AM_JAN){
                                        qray.alert("금액을 초과하였습니다.");
                                        fnObj.gridView03.target.setValue(this.item.__index,this.key,this.item.AM_JAN);
                                        return false;
                                    }
                                    fnObj.gridView03.target.setValue(this.item.__index,"JAN",Number(this.item.AM_JAN) - Number(this.value))
                                }

                                //반제-금액
                                var list = fnObj.gridView03.getData();
                                var sum = 0;
                                list.forEach(function(e,i){
                                    sum += Number(e.AM_DR)-(e.AM_CR)
                                });
                                $("#GAP").val(sum)
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

            var userCallBack;
            var openPopup = function (name) {
                $.openCommonPopup(name, "userCallBack",  'HELP_USER', [], $("#NM_EMP").attr('TEXT'),600,_pop_height,_pop_top);
                if (name == "user") {
                    userCallBack = function (e) {
                        if (e.length > 0) {
                            $("#NM_EMP").val(e[0].NM_EMP);
                            console.log("CODE", e[0].NO_EMP, "TEXT", e[0].NM_EMP);
                            $("#NM_EMP").attr({"CODE": e[0].NO_EMP, "TEXT": e[0].NM_EMP});
                        }

                        modal.close();
                    };
                }

            };

            function isChecked(data) {
                var result = [];
                for (var i = 0; i < data.length; i++) {
                    if (data[i].CHKED) {
                        result.push(data[i])
                    }
                }
                return result;
            }

            $(document).on('click', '#headerBox1 ,#headerBox2 ,#headerBox3', function(e) {
                if($(this).attr("data-ax5grid-checked") == "false"){
                    if(this.id == "headerBox1"){
                        var gridList = fnObj.gridView01.getData();
                        gridList.forEach(function(e, i){
                            fnObj.gridView01.target.setValue(i,"CHKED",true);
                        });
                    }else if(this.id == "headerBox2"){
                        var gridList = fnObj.gridView02.getData();
                        gridList.forEach(function(e, i){
                            fnObj.gridView02.target.setValue(i,"CHKED",true);
                        });
                    }else{
                        var gridList = fnObj.gridView03.getData();
                        gridList.forEach(function(e, i){
                            fnObj.gridView03.target.setValue(i,"CHKED",true);
                        });
                    }
                    $(this).attr("data-ax5grid-checked",true)
                }else{
                    if(this.id == "headerBox1"){
                        var gridList = fnObj.gridView01.getData();
                        gridList.forEach(function(e, i){
                            fnObj.gridView01.target.setValue(i,"CHKED",false);
                        });
                    }else if(this.id == "headerBox2"){
                        var gridList = fnObj.gridView02.getData();
                        gridList.forEach(function(e, i){
                            fnObj.gridView02.target.setValue(i,"CHKED",false);
                        });
                    }else{
                        var gridList = fnObj.gridView03.getData();
                        gridList.forEach(function(e, i){
                            fnObj.gridView03.target.setValue(i,"CHKED",false);
                        });
                    }
                    $(this).attr("data-ax5grid-checked",false)
                }

            });

            //////////////////////////////////////
            //크기자동조정
            var _pop_top = 0;
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
                }
                else{
                    _pop_height = totheight / 10 * 8;
                    _pop_top = parseInt((totheight - _pop_height) / 2);
                }

                $("#cdPc").attr("HEIGHT",_pop_height);
                $("#cdPc").attr("TOP",_pop_top);
                $("#cdDept").attr("HEIGHT",_pop_height);
                $("#cdDept").attr("TOP",_pop_top);
                $("#cdEmp").attr("HEIGHT",_pop_height);
                $("#cdEmp").attr("TOP",_pop_top);
                $("#cdDept1").attr("HEIGHT",_pop_height);
                $("#cdDept1").attr("TOP",_pop_top);
                $("#cdPartner1").attr("HEIGHT",_pop_height);
                $("#cdPartner1").attr("TOP",_pop_top);
                $("#CD_ACCT1").attr("HEIGHT",_pop_height);
                $("#CD_ACCT1").attr("TOP",_pop_top);
                $("#cdDept2").attr("HEIGHT",_pop_height);
                $("#cdDept2").attr("TOP",_pop_top);
                $("#cdPartner2").attr("HEIGHT",_pop_height);
                $("#cdPartner2").attr("TOP",_pop_top);
                $("#CD_ACCT2").attr("HEIGHT",_pop_height);
                $("#CD_ACCT2").attr("TOP",_pop_top);

                if(totheight > 700){
                    $("#top_left_title_bottom").css("height","130px");
                    $("#top_right_title_bottom").css("height","130px");
                }
                else if(totheight > 550){
                    $("#top_left_title_bottom").css("height","100px");
                    $("#top_right_title_bottom").css("height","100px");
                }
                else {
                    $("#top_left_title_bottom").css("height","80px");
                    $("#top_right_title_bottom").css("height","80px");
                }

                //데이터가 들어갈 실제높이
                var datarealheight = $("#ax-base-root").height() - $(".ax-base-title").height() - $("#pageheader").height();
                //타이틀을 뺀 상하단 그리드 합친높이
                var tempgridheight = datarealheight - $("#top_left_title").height() - $("#middle_wrap").height()- $("#top_left_title_bottom").height();

                $("#grid-view-01").css("height",tempgridheight /100 * 45);
                $("#grid-view-02").css("height",tempgridheight /100 * 45);
                $("#grid-view-03").css("height",tempgridheight /100 * 54);


                /*
                alert($("#ax-base-root").height()); // 컨텐츠영역높이
                ax-base-title //타이틀부분높이(class)
                ax-base-content //검색조건높이(class)
                 */
            }

        </script>
    </jsp:attribute>
    <jsp:body>
        <style type="text/css">
            #test1 {
                height: 720px;
            }
            @media screen and (max-width : 1440px){
                #test1 {
                    height: 560px;
                }
            }
        </style>
        <div data-page-buttons="">
            <div class="button-warp">
                <button type="button" class="btn btn-reload" data-page-btn="reload" onclick="window.location.reload();" style="width:80px;">
                    <i class="icon_reload"></i></button>
                <button type="button" class="btn btn-info" data-page-btn="search" style="width:80px;"><i class="icon_search"></i><ax:lang
                        id="ax.admin.sample.modal.button.search"/></button>
                <button type="button" class="btn btn-info" data-page-btn="apply" style="width:80px;"><i class="icon_ok"></i>전표발행
                </button>
            </div>
        </div>

        <div role="page-header" style="height: 100%;" id="pageheader">
            <ax:form name="binder-form">
                <ax:tbl clazz="ax-search-tb1" minWidth="1000px">
                    <ax:tr>
                        <ax:td label='회계단위' width="300px">
                            <codepicker id="cdPc" HELP_ACTION="HELP_PC" HELP_URL="pc" BIND-CODE="CD_PC"
                                        BIND-TEXT="NM_PC" READONLY SESSION />
                        </ax:td>
                        <ax:td label='사용부서' width="300px">
                            <codepicker id="cdDept" HELP_ACTION="HELP_DEPT" HELP_URL="dept" BIND-CODE="CD_DEPT"
                                         BIND-TEXT="NM_DEPT" READONLY SESSION/>
                        </ax:td>
                        <ax:td label='사용자' width="250px">
                            <codepicker id="cdEmp" HELP_ACTION="HELP_USER" HELP_URL="user" BIND-CODE="NO_EMP"
                                         BIND-TEXT="NM_EMP" READONLY SESSION/>
                        </ax:td>
                        <ax:td label='회계일자' width="300px">
                            <div class="input-group" data-ax5picker="basic1">
                                <input type="text" class="form-control" placeholder="yyyy-mm-dd" id="DT_ACCT" autocomplete="off">
                            </div>
                        </ax:td>
                        <ax:td label='품의내역' width="450px">
                            <input type="text" class="form-control" id="REMARK">
                        </ax:td>
                    </ax:tr>
                </ax:tbl>
            </ax:form>
<%--            <div class="H10"></div>--%>
        </div>

        <div style="width:100%">
            <div id="top_wrap" style="overflow:hidden" name ="상단그리드부분전체">
                <div style="float:left;width:49%;">
                    <div class="ax-button-group" data-fit-height-aside="grid-view-01" id="top_left_title" name ="상단왼쪽제목">
                        <div class="left">
                            <h3>
                                <i class="icon_list"></i> 차변
                            </h3>
                        </div>
                    </div>
                    <div id="top_left_title_bottom" style="overflow:auto;">
                    <ax:form name="binder-form">
                        <ax:tbl clazz="ax-search-tb1">
                            <ax:tr>
                                <ax:td label='작성부서' width="350px">
                                    <multipicker id="cdDept1" HELP_ACTION="HELP_DEPT" HELP_URL="multiDept" BIND-CODE="CD_DEPT"
                                                 BIND-TEXT="NM_DEPT"/>
                                </ax:td>
                                <ax:td label='거래처' width="350px">
                                    <codepicker id="cdPartner1" name="cdPartner1" HELP_ACTION="HELP_PARTNER" HELP_URL="partner" BIND-CODE="CD_PARTNER"
                                                BIND-TEXT="LN_PARTNER" />
                                </ax:td>
                            </ax:tr>
                            <ax:tr>
                                <ax:td label='차변발생일자' width="350px">
                                    <div class="input-group" data-ax5picker="basic2">
                                        <input type="text" class="form-control" placeholder="yyyy-mm-dd" id="DT_START1" autocomplete="off">
                                        <span class="input-group-addon">~</span>
                                        <input type="text" class="form-control" placeholder="yyyy-mm-dd" id="DT_END1" autocomplete="off">
                                        <span class="input-group-addon"><i class="cqc-calendar"></i></span>
                                    </div>
                                </ax:td>
                                <ax:td label='차변계정' width="350px">
                                    <multipicker id="CD_ACCT1" HELP_ACTION="HELP_ACCT" HELP_URL="multiAcct" BIND-CODE="CD_ACCT"
                                                 BIND-TEXT="NM_ACCT"/>
                                </ax:td>
                            </ax:tr>
                            <%--                                <ax:tr>--%>
                            <%--                                    <ax:td label='관리항목' width="350px">--%>
                            <%--                                        <codepicker id="CD_MNG1" HELP_ACTION="HELP_DEPT" HELP_URL="dept" BIND-CODE="CD_DEPT"--%>
                            <%--                                                    BIND-TEXT="NM_DEPT" READONLY/>--%>
                            <%--                                    </ax:td>--%>
                            <%--                                    <ax:td label='관리내역' width="350px">--%>
                            <%--                                        <input type="text" class="form-control" id="CD_MNGD1">--%>
                            <%--                                    </ax:td>--%>
                            <%--                                </ax:tr>--%>
                            <ax:tr>
                                <ax:td label='적요' width="90%">
                                    <input type="text" class="form-control" id="NM_NOTE1">
                                </ax:td>
                            </ax:tr>
                        </ax:tbl>
                    </ax:form>
                    </div>
                    <div id = "grid-view-01" data-ax5grid="grid-view-01" name ="상단왼쪽그리드"
                         data-ax5grid-config="{  showLineNumber: true,showRowSelector: false, multipleSelect: false,lineNumberColumnWidth: 40,rowSelectorColumnWidth: 27 }"
                    >
                    </div>
                </div>
                <div style="float:right;width:50%;">
                    <div class="ax-button-group" data-fit-height-aside="grid-view-02"  id="top_right_title" name ="상단오른쪽제목">
                        <div class="left">
                            <h3>
                                <i class="icon_list"></i> 대변
                            </h3>
                        </div>
                    </div>
                    <div id="top_right_title_bottom" style="overflow:auto;">
                    <ax:form name="binder-form">
                        <ax:tbl clazz="ax-search-tb1">
                            <ax:tr>
                                <ax:td label='작성부서' width="350px">
                                    <multipicker id="cdDept2" HELP_ACTION="HELP_DEPT" HELP_URL="multiDept" BIND-CODE="CD_DEPT"
                                                 BIND-TEXT="NM_DEPT"/>
                                </ax:td>
                                <ax:td label='거래처' width="350px">
                                    <codepicker id="cdPartner2" name="cdPartner2" HELP_ACTION="HELP_PARTNER" HELP_URL="partner" BIND-CODE="CD_PARTNER"
                                                BIND-TEXT="LN_PARTNER" />
                                </ax:td>
                            </ax:tr>
                            <ax:tr>
                                <ax:td label='대변발생일자' width="350px">
                                    <div class="input-group" data-ax5picker="basic3">
                                        <input type="text" class="form-control" placeholder="yyyy-mm-dd" id="DT_START2" autocomplete="off">
                                        <span class="input-group-addon">~</span>
                                        <input type="text" class="form-control" placeholder="yyyy-mm-dd" id="DT_END2" autocomplete="off">
                                        <span class="input-group-addon"><i class="cqc-calendar"></i></span>
                                    </div>
                                </ax:td>
                                <ax:td label='대변계정' width="350px">
                                    <multipicker id="CD_ACCT2" HELP_ACTION="HELP_ACCT" HELP_URL="multiAcct" BIND-CODE="CD_ACCT"
                                                 BIND-TEXT="NM_ACCT"/>
                                </ax:td>
                            </ax:tr>
                            <%--                                <ax:tr>--%>
                            <%--                                    <ax:td label='관리항목' width="350px">--%>
                            <%--                                        <codepicker id="CD_MNG2" HELP_ACTION="HELP_DEPT" HELP_URL="dept" BIND-CODE="CD_DEPT"--%>
                            <%--                                                    BIND-TEXT="NM_DEPT" READONLY/>--%>
                            <%--                                    </ax:td>--%>
                            <%--                                    <ax:td label='관리내역' width="350px">--%>
                            <%--                                        <input type="text" class="form-control" id="CD_MNGD2">--%>
                            <%--                                    </ax:td>--%>
                            <%--                                </ax:tr>--%>
                            <ax:tr>
                                <ax:td label='적요' width="90%">
                                    <input type="text" class="form-control" id="NM_NOTE2">
                                </ax:td>
                            </ax:tr>
                        </ax:tbl>
                    </ax:form>
                    </div>
                    <div id = "grid-view-02" data-ax5grid="grid-view-02" name ="상단오른쪽쪽그리드"
                         data-ax5grid-config="{  showLineNumber: true,showRowSelector: false, multipleSelect: false,lineNumberColumnWidth: 40,rowSelectorColumnWidth: 27 }">
                    </div>
                </div>
            </div>
            <div id="middle_wrap" style="min-height:35px;height:35px;max-height:35px;overflow:auto;" name ="그리드사이중간영역">
                <div style="min-height:5px;height:5px;max-height:5px;">
                </div>
                <div>
                    <button type="button" class="btn btn-info" data-page-btn="select" style="width:80px;">발행선택
                    </button>
                    <button type="button" class="btn btn-info" data-page-btn="cancel" style="width:80px;">발행취소
                    </button>
                    차액 <input id="GAP" type="text" autocomplete="off" readonly="readonly" disabled="disabled"/>
                </div>
                <div style="min-height:5px;height:5px;max-height:5px;">
                </div>
            </div>
            <div id = "grid-view-03" data-ax5grid="grid-view-03" name ="하단그리드"
                 data-ax5grid-config="{  showLineNumber: true,showRowSelector: false, multipleSelect: false,lineNumberColumnWidth: 40,rowSelectorColumnWidth: 27 }">
            </div>
        </div>


    </jsp:body>
</ax:layout>