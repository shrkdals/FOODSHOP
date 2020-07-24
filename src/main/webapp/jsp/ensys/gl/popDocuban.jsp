<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>

<ax:set key="title" value="반제처리"/>
<ax:set key="page_desc" value="${PAGE_REMARK}"/>
<ax:set key="page_auto_height" value="true"/>

<ax:layout name="base">
    <jsp:attribute name="script">

        <script type="text/javascript">
            // parent.modal.modalConfig.sendData
            var _CD_ACCT = parent.modal.modalConfig.sendData["CD_ACCT"];
            var _NM_ACCT = parent.modal.modalConfig.sendData["NM_ACCT"];
            var _DRCR = parent.modal.modalConfig.sendData["DRCR"];
            var _CALLBACKGRID = parent.modal.modalConfig.sendData["CALLBACKGRID"];

            var param = ax5.util.param(ax5.info.urlUtil().param);

            $(document).ready(function () {
                $("#ID_BAN1").keydown(function (e) {
                    if (e.keyCode == '46' || e.keyCode == '8') {
                        $("#ID_BAN1").attr('text', '');
                        $("#ID_BAN1").attr('code', '');
                        $("#ID_BAN1").val('');
                    }
                });

                $("#ID_BAN2").keydown(function (e) {
                    if (e.keyCode == '46' || e.keyCode == '8') {
                        $("#ID_BAN2").attr('text', '');
                        $("#ID_BAN2").attr('code', '');
                        $("#ID_BAN2").val('');
                    }
                })
            });

            //페이지시작(document.ready)
            var fnObj = {};
            fnObj.pageStart = function () {
                this.pageButtonView.initView();
                this.gridMain.initView(); //그리드초기화
                this.gridDetail.initView(); //그리드초기화

                $("#dtAcctT").val(dtNow);
                $("#dtAcctF").val(dtF);
                $("#NM_ACCT").val("(" + _CD_ACCT + ") " + _NM_ACCT);
                //select 박스 기본값세팅(콤보박스)
                $('[data-ax5select="cbo_gubun"]').ax5select("setValue", "1");
                //도움창기본값세팅
                $("#ID_BAN1").val("거래처");
                $("#ID_BAN1").attr({"code": "A06", "text": "거래처"});
            };

            //드랍다운값초기화
            $("#cbo_gubun").ax5select({
                options: [{value : '' , text : ''},{value : '1' , text : '미완료'},{value : '2' , text : '완료'}]
            });

            //달력컨트롤초기화
            var today = new Date();
            var preYear = today.getFullYear() - 1;
            var dtF = ax5.util.date(today, {"return": preYear + "-MM-01"});
            var dtT = ax5.util.date(today, {"return": "yyyy-MM"}) + '-' + ax5.util.daysOfMonth(today.getFullYear(), today.getMonth());
            var dtNow = ax5.util.date(today, {"return": "yyyy-MM-dd"});
            var userCallBack;

            var picker1 = new ax5.ui.picker();
            picker1.bind({
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

                            $("#dtAcctT").val(dtNow);
                            $("#dtAcctF").val(dtNow);
                            this.self.close();
                        }
                    },
                    thisMonth: {
                        label: "이번달", onClick: function () {
                            $("#dtAcctT").val(dtT);
                            $("#dtAcctF").val(dtF);
                            this.self.close();
                        }
                    },
                    ok: {label: "확인", theme: "default"}
                }
            });

            var picker2 = new ax5.ui.picker();
            picker2.bind({
                target: $('[data-ax5picker="DT_END"]'),
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

                            $("#dtEndT").val(dtNow);
                            $("#dtEndF").val(dtNow);
                            this.self.close();
                        }
                    },
                    thisMonth: {
                        label: "이번달", onClick: function () {
                            $("#dtEndT").val(dtT);
                            $("#dtEndF").val(dtF);
                            this.self.close();
                        }
                    },
                    ok: {label: "확인", theme: "default"}
                }
            });

            //버튼이벤트
            fnObj.pageButtonView = axboot.viewExtend({
                initView: function () {

                    axboot.buttonClick(this, "data-page-btn", {
                        "jansearch": function () {
                            ACTIONS.dispatch(ACTIONS.PAGE_SEARCH_JAN);
                        },
                        "search": function () {
                            ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                        },
                        "fifoban": function () {
                            ACTIONS.dispatch(ACTIONS.FIFO_BAN);
                        },
                        "ban": function () {
                            ACTIONS.dispatch(ACTIONS.BAN);
                        },
                        "close": function () {
                            ACTIONS.dispatch(ACTIONS.PAGE_CLOSE);
                        }
                    });
                }
            });


            //페이지에서 사용하는 기본 변수 객체
            var ACTIONS = axboot.actionExtend(fnObj, {
                PAGE_CLOSE: function (caller, act, data) { //닫기버튼
                    parent.modal.close();
                },
                PAGE_SEARCH_JAN: function (caller, act, data) { //반제잔액조회버튼
                    openPopup('banjan');
                },
                PAGE_SEARCH: function (caller, act, data) { //조회버튼
                    if(nvl($("#ID_BAN2").attr("code"),"") == ""){
                        qray.alert("반제내역은 필수항목입니다");
                        return;
                    }

                    caller.gridMain.clear();
                    caller.gridDetail.clear();
                   var result =  $.DATA_SEARCH("gldocum","getBanList",
                        {
                            CD_ACCT:_CD_ACCT
                            ,CD_PC : SCRIPT_SESSION.cdPc
                            ,DT_ACCT_F:$("#dtAcctF").val().replace(/-/g,'')
                            ,DT_ACCT_T:$("#dtAcctT").val().replace(/-/g,'')
                            ,ST_BAN:$('[data-ax5select="cbo_gubun"]').ax5select("getValue")[0].value
                            ,CD_MNG: $("#ID_BAN1").attr("code")
                            ,DT_EMD_F:$("#dtEndF").val().replace(/-/g,'')
                            ,DT_EMD_T:$("#dtEndT").val().replace(/-/g,'')
                            ,NM_ACCT:_NM_ACCT
                            ,CD_MNG2:$("#ID_BAN2").attr("code")
                            ,KEY:"" //$("#S_TEXT").val()
                            ,GRID_TYPE:"1"
                        });
                   //외부에서 받아온 객체와 비교해서 금액을 빼고 바인딩해줘야한다 (openModalbanfifo 에서사용)
                   if(_CALLBACKGRID){
                       var temparr = [];
                       for(var i =0;i<result.list.length;i++){
                            for(var k =0;k<_CALLBACKGRID.length;k++){
                                if(_CALLBACKGRID[k].NO_BDOCU == result.list[i].NO_BDOCU && _CALLBACKGRID[k].NO_BDOLINE == result.list[i].NO_BDOLINE){
                                    result.list[i].AM_JAN = result.list[i].AM_JAN - _CALLBACKGRID[k].AM_JAN;
                                    result.list[i].AM_BAN = _CALLBACKGRID[k].AM_BAN;
                                }
                            }
                       }
                       for(var i =0;i<result.list.length;i++) {
                           if (result.list[i].AM_JAN != 0)
                               temparr.push(result.list[i]);
                       }
                       result.list = temparr;
                       fnObj.gridMain.setData(result);
                   }
                   else{
                       fnObj.gridMain.setData(result);
                   }

                    ACTIONS.dispatch(ACTIONS.ITEM_CLICK, '');
                    sumamt();
                    return false;
                },
                ITEM_CLICK: function (caller, act, data) { //하단그리드검색용
                    caller.gridDetail.clear();
                    var m_nodocu = "";
                    if(!fnObj.gridMain.getData("selected") || fnObj.gridMain.getData("selected").length == 0  || !fnObj.gridMain.getData("selected")[0]["NO_DOCU"])
                        m_nodocu = "";
                    else
                        m_nodocu =fnObj.gridMain.getData("selected")[0]["NO_DOCU"];

                    $.DATA_SEARCH("gldocum","getBanList",
                        {
                            CD_ACCT:_CD_ACCT
                            ,CD_PC : SCRIPT_SESSION.cdPc
                            ,DT_ACCT_F:$("#dtAcctF").val().replace(/-/g,'')
                            ,DT_ACCT_T:$("#dtAcctT").val().replace(/-/g,'')
                            ,ST_BAN:$('[data-ax5select="cbo_gubun"]').ax5select("getValue")[0].value
                            ,CD_MNG: $("#ID_BAN1").attr("code")
                            ,DT_EMD_F:$("#dtEndF").val().replace(/-/g,'')
                            ,DT_EMD_T:$("#dtEndT").val().replace(/-/g,'')
                            ,NM_ACCT:_NM_ACCT
                            ,CD_MNG2:$("#ID_BAN2").attr("code")
                            ,KEY: m_nodocu//$("#S_TEXT").val()
                            ,GRID_TYPE:"2"
                        }
                        ,caller.gridDetail);
                    return false;
                },
                FIFO_BAN: function (caller, act, data) { //FIFO반제버튼
                    var checkList = isChecked(fnObj.gridMain.getData());

                    if(checkList.length == 0){
                        qray.alert("선택된항목이 없습니다.");
                        return;
                    }

                    openPopup('banfifo');

                    return false;
                },
                BAN: function (caller, act, data) { //반제버튼
                    var checkList = isChecked(fnObj.gridMain.getData());

                    if(checkList.length == 0){
                        qray.alert("선택된항목이 없습니다.");
                        return;
                    }

                    //부모창의 콜백호출 ( openModalbanfifo)
                    parent[param.callBack](checkList,_DRCR);
                    //parent.modal.close();

                }
            });

            //상단그리드초기화
            fnObj.gridMain = axboot.viewExtend(axboot.gridView, {
                page: {
                    pageNumber: 0,
                    pageSize: 10
                },
                initView: function () {
                    var _this = this;

                    this.target = axboot.gridBuilder({
                        showRowSelector: true,
                        frozenColumnIndex: 0,
                        target: $('[data-ax5grid="gridMain"]'),
                        columns: [
                            {
                                key: "CHKED", label: "", width: 30, align: "center",
                                label:
                                    '<div id="headerBox" data-ax5grid-editor="checkbox" data-ax5grid-checked="false" data-ax5grid-column-selected="true" style="height:17px;width:17px;margin-top:2px;  onclick="javascript:alert(1);"></div>',
                                editor: {
                                    type: "checkbox", config: {height: 17, trueValue: true, falseValue: false}
                                }
                            },
                            {key: "CD_COMPANY",label: "회사코드",width: 80,align: "left",editor: false,hidden: true},
                            {key: "DT_ACCT",label: "회계일자",width: 80,align: "center",editor: false,
                                formatter: function () {
                                    return $.changeDataFormat(this.value)
                                }
                            },
                            {key: "NO_ACCT",label: "회계번호",width: 60,align: "center",editor: false},
                            {key: "NO_DOCU",label: "전표번호",width: 120,align: "center",editor: false},
                            {key: "NO_DOLINE",label: "라인번호",width: 60,align: "center",editor: false},
                            {key: "CD_PARTNER",label: "거래처코드",width: 80,align: "center",editor: false},
                            {key: "LN_PARTNER",label: "거래처명",width: 150,align: "left",editor: false},
                            {key: "BAN_MNG",label: "반제항목",width: 120,align: "center",editor: false, hidden:true},

                            {key: "AM_DOCU",label: "전표금액",width: 110,align: "right",editor: false,formatter:"money"},
                            {key: "AM_BAN",label: "반제금액",width: 110,align: "right",editor: false,formatter:"money"},
                            {key: "AM_JAN",label: "잔액",width: 110,align: "right",editor: false,formatter:"money"},
                            {key: "NM_NOTE",label: "적요",width: 250,align: "left",editor: false},
                            {key: "DT_END",label: "만기일자",width: 80,align: "center",editor: false,
                                formatter: function () {
                                    return $.changeDataFormat(this.value)
                                }
                            },
                            {key: "NM_DEPT",label: "부서명",width: 150,align: "left",editor: false},
                            {key: "CD_MNG",label: "관리항목",width: 120,align: "center",editor: false},
                            {key: "NM_WDEPT",label: "작성부서",width: 150,align: "left",editor: false},
                            {key: "NM_EXCH",label: "환종",width: 80,align: "center",editor: false},
                            {key: "AM_EX",label: "외화금액",width: 150,align: "right",editor: false,formatter:"money"},
                            {key: "AM_EXBAN",label: "반제외화금액",width: 150,align: "right",editor: false,formatter:"money"},
                            {key: "AM_JEX",label: "외화미상환잔액",width: 150,align: "right",editor: false,formatter:"money"}
                        ],
                        body: {
                            onClick: function () {
                                this.self.select(this.dindex);
                                var index = fnObj.gridMain.getData('selected')[0].__index;
                                ACTIONS.dispatch(ACTIONS.ITEM_CLICK);
                                sumamt();
                            },
                            onDBLClick: function () {
                                ACTIONS.dispatch(ACTIONS.ITEM_SELECT);
                            },
                            onDataChanged: function () {
                                sumamt();
                                /*
                                if (this.key == "TP_CUST_EMP" && this.item.TP_CUST_EMP) {
                                    // var index = fnObj.gridMain.getData('selected')[0].__index;
                                    fnObj.gridMain.target.setValue(this.dindex, "CD_CUST_EMP", '');
                                    fnObj.gridMain.target.setValue(this.dindex, "NM_CUST", '');
                                }

                                if (this.item.TP_CUST_EMP == '1' && nvl(this.item.CD_CUST_EMP) != '' && nvl(this.item.CONT_CUST) != '') {
                                    var index = fnObj.gridMain.getData('selected')[0].__index;
                                    var result = $.DATA_SEARCH("gldocum", "getBnftAmt", {
                                        CD_CUST_EMP: this.item.CD_CUST_EMP,
                                        CONT_CUST: this.item.CONT_CUST,
                                        DT_ACCT: _DT_ACCT

                                    });
                                    fnObj.gridMain.target.setValue(index, "CUST_SUMAMT", result.map.AMT);
                                }
                                */
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
                    return ($("div [data-ax5grid='gridMain']").find("div [data-ax5grid-panel='body'] table tr").length)
                }
            });

            //하단초기화
            fnObj.gridDetail = axboot.viewExtend(axboot.gridView, {
                page: {
                    pageNumber: 0,
                    pageSize: 10
                },
                initView: function () {
                    var _this = this;

                    this.target = axboot.gridBuilder({
                        showRowSelector: true,
                        frozenColumnIndex: 0,
                        target: $('[data-ax5grid="bottom_grid"]'),
                        columns: [
                            {key: "NM_DEPT",label: "부서명",width: 150,align: "left",editor: false},
                            {key: "DT_ACCT",label: "회계일자",width: 80,align: "center",editor: false,
                                formatter: function () {
                                    return $.changeDataFormat(this.value)
                                }
                            },
                            {key: "NO_DOCU",label: "전표번호",width: 150,align: "center",editor: false},
                            {key: "NO_DOLINE",label: "라인번호",width: 80,align: "center",editor: false},
                            {key: "AM_DOCU",label: "원화금액",width: 150,align: "right",editor: false,formatter:"money"},
                            {key: "AM_EX",label: "외화금액",width: 150,align: "right",editor: false,formatter:"money"},

                        ],
                        body: {
                            onClick: function () {
                                this.self.select(this.dindex);
                                //ACTIONS.dispatch(ACTIONS.ITEM_CLICK, this.item);
                            },
                            onDBLClick: function () {
                                //ACTIONS.dispatch(ACTIONS.ITEM_SELECT);
                            },
                            onDataChanged: function () {
                                /*
                                if (this.key == "TP_CUST_EMP" && this.item.TP_CUST_EMP) {
                                    // var index = fnObj.gridMain.getData('selected')[0].__index;
                                    fnObj.gridDetail.target.setValue(this.dindex, "CD_CUST_EMP", '');
                                    fnObj.gridDetail.target.setValue(this.dindex, "NM_CUST", '');
                                }

                                if (this.item.TP_CUST_EMP == '1' && nvl(this.item.CD_CUST_EMP) != '' && nvl(this.item.CONT_CUST) != '') {
                                    var index = fnObj.gridDetail.getData('selected')[0].__index;
                                    var result = $.DATA_SEARCH("gldocum", "getBnftAmt", {
                                        CD_CUST_EMP: this.item.CD_CUST_EMP,
                                        CONT_CUST: this.item.CONT_CUST,
                                        DT_ACCT: _DT_ACCT

                                    });
                                    fnObj.gridDetail.target.setValue(index, "CUST_SUMAMT", result.map.AMT);
                                }
                                */
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
                    return ($("div [data-ax5grid='bottom_grid']").find("div [data-ax5grid-panel='body'] table tr").length)
                }
            });

            //도움창 오픈
            var openPopup = function (name) {
                if(name == "banH") {
                    userCallBack = function (e) {
                        if (e.length > 0) {

                            $("#ID_BAN1").val(e[0].NM_MNG);
                            $("#ID_BAN1").attr({"code": e[0].CD_MNG, "text": e[0].NM_MNG});
                            $("#ID_BAN2").val("");
                            $("#ID_BAN2").attr({"code": "", "text": ""});
                        }
                    };

                    parent.openModal2("BanH", "HELP_BAN_HELP", "userCallBack", this.name,{ POPFLAG: "HEADER"});
                }
                else if(name == "banD"){
                    userCallBack = function (e) {
                        if (e.length > 0) {
                            if($("#ID_BAN1").attr("code") == "A01"){  //귀속사업장
                                $("#ID_BAN2").val(e[0].NM_BIZAREA);
                                $("#ID_BAN2").attr({"code": e[0].CD_BIZAREA, "text": e[0].NM_BIZAREA});
                            }
                            else if($("#ID_BAN1").attr("code") == "A02") { //코스트센타
                                $("#ID_BAN2").val(e[0].NM_CC);
                                $("#ID_BAN2").attr({"code": e[0].CD_CC, "text": e[0].NM_CC});
                            }
                            else if($("#ID_BAN1").attr("code") == "A03") { // 부서
                                $("#ID_BAN2").val(e[0].NM_DEPT);
                                $("#ID_BAN2").attr({"code": e[0].CD_DEPT, "text": e[0].NM_DEPT});
                            }
                            else if($("#ID_BAN1").attr("code") == "A04") {// 사원
                                $("#ID_BAN2").val(e[0].NM_KOR);
                                $("#ID_BAN2").attr({"code": e[0].NO_EMP, "text": e[0].NM_KOR});
                            }
                            else if($("#ID_BAN1").attr("code") == "A05") {// 프로젝트
                                $("#ID_BAN2").val(e[0].LN_PARTNER);
                                $("#ID_BAN2").attr({"code": e[0].CD_PARTNER, "text": e[0].LN_PARTNER});
                            }
                            else if($("#ID_BAN1").attr("code") == "A06") {// 거래처
                                $("#ID_BAN2").val(e[0].LN_PARTNER);
                                $("#ID_BAN2").attr({"code": e[0].CD_PARTNER, "text": e[0].LN_PARTNER});
                            }
                            else if($("#ID_BAN1").attr("code") == "A07") {// 예적금계좌
                                $("#ID_BAN2").val(e[0].NM_DEPOSIT);
                                $("#ID_BAN2").attr({"code": e[0].CD_DEPOSIT, "text": e[0].NM_DEPOSIT});
                            }
                            else if($("#ID_BAN1").attr("code") == "A08") {// 신용카드
                                $("#ID_BAN2").val(e[0].NM_CARD);
                                $("#ID_BAN2").attr({"code": e[0].NO_CARD, "text": e[0].NM_CARD});
                            }
                            else if($("#ID_BAN1").attr("code") == "A09") {// 금융기관
                                $("#ID_BAN2").val(e[0].LN_PARTNER);
                                $("#ID_BAN2").attr({"code": e[0].CD_PARTNER, "text": e[0].LN_PARTNER});
                            }
                            else if($("#ID_BAN1").attr("code") == "A10") {// 품목
                                $("#ID_BAN2").val(e[0].NM_ITEM);
                                $("#ID_BAN2").attr({"code": e[0].CD_ITEM, "text": e[0].NM_ITEM});
                            }
                        }
                    };

                    if($("#ID_BAN1").attr("code") == "A01")  //귀속사업장
                        parent.openModal2("BanD", "HELP_BAN_HELP", "userCallBack", this.name,{ POPFLAG: "A01"});
                    else if($("#ID_BAN1").attr("code") == "A02") //코스트센타
                        parent.openModal2("BanD", "HELP_BAN_HELP", "userCallBack", this.name,{ POPFLAG: "A02"});
                    else if($("#ID_BAN1").attr("code") == "A03") // 부서
                        parent.openModal2("BanD", "HELP_BAN_HELP", "userCallBack", this.name,{ POPFLAG: "A03"});
                    else if($("#ID_BAN1").attr("code") == "A04") // 사원
                        parent.openModal2("BanD", "HELP_BAN_HELP", "userCallBack", this.name,{ POPFLAG: "A04"});
                    else if($("#ID_BAN1").attr("code") == "A05") // 프로젝트
                        parent.openModal2("BanD", "HELP_BAN_HELP", "userCallBack", this.name,{ POPFLAG: "A05"});
                    else if($("#ID_BAN1").attr("code") == "A06") // 거래처
                        parent.openModal2("BanD", "HELP_BAN_HELP", "userCallBack", this.name,{ POPFLAG: "A06"});
                    else if($("#ID_BAN1").attr("code") == "A07") // 예적금계좌
                        parent.openModal2("BanD", "HELP_BAN_HELP", "userCallBack", this.name,{ POPFLAG: "A07"});
                    else if($("#ID_BAN1").attr("code") == "A08") // 신용카드
                        parent.openModal2("BanD", "HELP_BAN_HELP", "userCallBack", this.name,{ POPFLAG: "A08"});
                    else if($("#ID_BAN1").attr("code") == "A09") // 금융기관
                        parent.openModal2("BanD", "HELP_BAN_HELP", "userCallBack", this.name,{ POPFLAG: "A09"});
                    else if($("#ID_BAN1").attr("code") == "A10") // 품목
                        parent.openModal2("BanD", "HELP_BAN_HELP", "userCallBack", this.name,{ POPFLAG: "A10"});
                }
                else if(name == "banjan"){
                    userCallBack = function (e) {
                    };
                    parent.openModalban("BanJan", "HELP_BAN_HELP", "userCallBack", this.name,
                        { POPFLAG: "JAN"
                            , ID_BAN1_CODE: $("#ID_BAN1").attr("code")
                            , ID_BAN1_TEXT: $("#ID_BAN1").attr("text")
                            , ID_BAN2_CODE: $("#ID_BAN2").attr("code")
                            , ID_BAN2_TEXT: $("#ID_BAN2").attr("text") });

                }
                else if(name == "banfifo"){
                    //이도움창콜백은 p_cz_q_gl_docu_ban 에 있음
                    parent.openModalbanfifo("BanFifo", "HELP_BAN_HELP", "userCallBackbanfifo", this.name,
                        {
                            POPFLAG: "JANFIFO"
                            ,GRIDDATA: isChecked(fnObj.gridMain.getData())
                            ,SELECTAMT: uncomma($("#SELECT_AMT").val())
                            ,DRCR:_DRCR
                        });

                }
            };

            var cnt = 0;
            $(document).on('click', '#headerBox', function(e) {
                if(cnt == 0){
                    $("div [data-ax5grid='gridMain']").find("div #headerBox").attr("data-ax5grid-checked",true);
                    cnt++;
                    var gridList = fnObj.gridMain.getData();
                    gridList.forEach(function(e, i){
                        fnObj.gridMain.target.setValue(i,"CHKED",true);
                    });
                    $("div [data-ax5grid-editor='checkbox']").attr("data-ax5grid-checked",true)
                }else{
                    $("div [data-ax5grid='gridMain']").find("div #headerBox").attr("data-ax5grid-checked",false);
                    cnt = 0;
                    var gridList = fnObj.gridMain.getData();
                    gridList.forEach(function(e, i){
                        fnObj.gridMain.target.setValue(i,"CHKED",false);
                    });
                    $("div [data-ax5grid-editor='checkbox']").attr("data-ax5grid-checked",false)
                }
            });

            //체크박스체크했는지 확인하는함수
            function isChecked(data) {
                var array = [];
                for (var i = 0; i < data.length; i++) {
                    if (data[i].CHKED == true) {
                        array.push(data[i])
                    }
                }
                return array;
            }

            //그리드중앙합계에 사용하기위한함수
            function sumamt() {
                var gridM = fnObj.gridMain.target.list;
                var temp_am_docu = 0;
                var temp_am_ban = 0;
                var temp_am_jan = 0;
                var temp_check_am = 0;

                var checkList = isChecked(fnObj.gridMain.getData());

                for (var i = 0; i < checkList.length; i++) {
                    temp_check_am += Number(checkList[i]["AM_JAN"]);
                }

                for (var i = 0; i < gridM.length; i++) {
                    temp_am_docu += Number(gridM[i].AM_DOCU);
                    temp_am_ban += Number(gridM[i].AM_BAN);
                    temp_am_jan += Number(gridM[i].AM_JAN);
                }

                $("#DOCU_AMT").val(comma(temp_am_docu)); //전표금액
                $("#BAN_AMT").val(comma(temp_am_ban)); //반제금액
                $("#REMAIN_AMT").val(comma(temp_am_jan)); //잔액
                $("#SELECT_AMT").val(comma(temp_check_am)); //선택금액
            }

            //////////////////////////////////////
            //크기자동조정
            var _pop_top = 0;
            var _pop_top800 = 0;
            var _pop_width1400 = 0;
            var _pop_height = 0;
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
                    _pop_height800 = 800;
                    _pop_top = parseInt((totheight - _pop_height) / 2);
                    _pop_top800 = parseInt((totheight - 800) / 2);
                    _pop_width1400 = 1400;
                }
                else{
                    _pop_height = totheight / 10 * 8;
                    _pop_height800 = totheight / 10 * 9;
                    _pop_top = parseInt((totheight - _pop_height) / 2);
                    _pop_top800 = parseInt((totheight - _pop_height800) / 2);
                    _pop_width1400 = 900;
                }

                $("#cdEmp").attr("HEIGHT",_pop_height);
                $("#cdEmp").attr("TOP",_pop_top);

                //데이터가 들어갈 실제높이
                var datarealheight = $("#ax-base-root").height() - $(".ax-base-title").height() - $("#pageheader").height();
                //타이틀을 뺀 상하단 그리드 합친높이
                var tempgridheight = datarealheight - $("#middle_wrap").height() - $("#middle_top").height() - $("#middle_bottom").height();

                $("#gridMain").css("height",tempgridheight /100 * 49);
                $("#bottom_grid").css("height",tempgridheight /100 * 50);

                /*
                alert($("#ax-base-root").height()); // 컨텐츠영역높이
                ax-base-title //타이틀부분높이(class)
                ax-base-content //검색조건높이(class)
                 */
            }
        </script>
        <style>
            .stable_title{ font-size:12px; font-weight:700;color:#232323;width:90px;text-align:right;padding-right:7px;height:35px;line-height:35px;}
            .stable_content{ width:270px;}
            .bottomlabel{
                width:80px;
                background:#e9e9e9;
                float:left;
                min-height:32px;
                height:32px;
                line-height:32px;
                font-size:12px;
                font-weight:700;
                text-align:center;
            }
            .bottominput {
                width: 160px;
                float: left;
                padding-top: 3px;
                margin-left: 5px;
                margin-right: 5px;
            }
        </style>
    </jsp:attribute>
    <jsp:body>

        <div data-page-buttons="">
            <div class="button-warp">
                <button type="button" class="btn btn-info" data-page-btn="jansearch" style="width:100px;">반제잔액조회</button>
                <button type="button" class="btn btn-info" data-page-btn="search"  style="width:80px;">조회</button>
                <button type="button" class="btn btn-info" data-page-btn="fifoban"  style="width:80px;">FIFO반제</button>
                <button type="button" class="btn btn-info" data-page-btn="ban"  style="width:80px;">반제처리</button>
                <button type="button" class="btn btn-info" data-page-btn="close"  style="width:80px;">닫기</button>
            </div>
        </div>

        <div class="ax-button-group" data-fit-height-aside="grid-main" id="pageheader">
            <form name ="searchView0">
                <table style="background:#f7f8fa;border:2px solid #d2deec;width:100%;">
                    <tr>
                        <td class="stable_title">
                            계정
                        </td>
                        <td class="stable_content">
                            <input type="text" class="form-control" id="NM_ACCT" READONLY/>
                        </td>
                        <td class="stable_title">
                            회계일자
                        </td>
                        <td class="stable_content">
                            <div class="input-group" data-ax5picker="DT_ACCT">
                                <input type="text" class="form-control" placeholder="yyyy-mm-dd" id="dtAcctF">
                                <span class="input-group-addon">~</span>
                                <input type="text" class="form-control" placeholder="yyyy-mm-dd" id="dtAcctT">
                                <span class="input-group-addon"><i class="cqc-calendar"></i></span>
                            </div>
                        </td>
                        <td class="stable_title">
                            구분
                        </td>
                        <td class="stable_content">
                            <div id="cbo_gubun" name="cbo_gubun" data-ax5select="cbo_gubun" data-ax5select-config='{}'></div>
                        </td>
                        <td style="width:50px;">
                        </td>
                    </tr>
                    <tr style="border-top:1px solid #d2deec">
                        <td class="stable_title">
                            반제항목
                        </td>
                        <td class="stable_content">
                            <div class="input-group">
                                <input type="text" class="form-control" name="ID_WRITE" id="ID_BAN1" READONLY/>
                                <span class="input-group-addon" <%--onclick="openPopup('banH')" style="cursor: pointer"--%>><i class="cqc-magnifier"></i></span>
                            </div>
                        </td>
                        <td class="stable_title">
                            반제내역
                        </td>
                        <td class="stable_content">
                            <div class="input-group">
                                <input type="text" class="form-control" name="ID_WRITE" id="ID_BAN2" style="background:#ffe4e4" READONLY/>
                                <span class="input-group-addon" onclick="openPopup('banD')" style="cursor: pointer"><i class="cqc-magnifier"></i></span>
                            </div>
                        </td>
                        <td class="stable_title">
                            만기일자
                        </td>
                        <td class="stable_content">
                            <div class="input-group" data-ax5picker="DT_END">
                                <input type="text" class="form-control" placeholder="yyyy-mm-dd" id="dtEndF">
                                <span class="input-group-addon">~</span>
                                <input type="text" class="form-control" placeholder="yyyy-mm-dd" id="dtEndT">
                                <span class="input-group-addon"><i class="cqc-calendar"></i></span>
                            </div>
                        </td>
                        <td style="width:50px;">
                        </td>
                    </tr>
                        <%--
                        <tr style="border-top:1px solid #d2deec">
                            <td class="stable_title">
                                검색
                            </td>
                            <td colspan="5">
                                <input type="text" class="form-control" id="S_TEXT"/>
                            </td>
                            <td>
                            </td>
                        </tr>
                        --%>
                </table>
            </form>
            <div class="H10"></div>
        </div>

        <div style="width:100%;overflow:auto;">
            <div data-ax5grid="gridMain"
                 data-ax5grid-config="{  showLineNumber: true,showRowSelector: false, multipleSelect: false,lineNumberColumnWidth: 40,rowSelectorColumnWidth: 27, }"
                 id ="gridMain"
            >
            </div>
            <div style="width:100%;min-height:5px;height:5px;" id="middle_top">
            </div>
            <div style="width:100%;min-height:34px;height:34px;overflow:auto;max-height:34px;" id="middle_wrap">
                <ax:form name="binder-form">
                    <div class="ax-button-group" data-fit-height-aside="grid-detail"
                         style="border:1px solid #d2deec;background:#ffffff;min-height:32px;height:32px;">
                        <div class="bottomlabel">
                            전표금액
                        </div>
                        <div class="bottominput">
                            <input type="text" class="form-control" name="DOCU_AMT"
                                   id="DOCU_AMT" data-ax-path="DOCU_AMT" readonly/>
                        </div>
                        <div class="bottomlabel">
                            반제금액
                        </div>
                        <div class="bottominput">
                            <input type="text" class="form-control" name="BAN_AMT"
                                   id="BAN_AMT" data-ax-path="BAN_AMT" readonly/>
                        </div>
                        <div class="bottomlabel">
                            잔액
                        </div>
                        <div class="bottominput">
                            <input type="text" class="form-control" name="REMAIN_AMT"
                                   id="REMAIN_AMT" data-ax-path="REMAIN_AMT" readonly/>
                        </div>
                        <div class="bottomlabel">
                            선택금액
                        </div>
                        <div class="bottominput">
                            <input type="text" class="form-control" name="SELECT_AMT"
                                   id="SELECT_AMT" data-ax-path="SELECT_AMT" readonly/>
                        </div>
                    </div>
                </ax:form>
            </div>
            <div style="width:100%;min-height:5px;height:5px;" id="middle_bottom">
            </div>
            <div data-ax5grid="bottom_grid"
                 data-ax5grid-config="{  showLineNumber: true,showRowSelector: false, multipleSelect: false,lineNumberColumnWidth: 40,rowSelectorColumnWidth: 27, }"
                 id ="bottom_grid"
            >
            </div>
        </div>
    </jsp:body>
</ax:layout>


