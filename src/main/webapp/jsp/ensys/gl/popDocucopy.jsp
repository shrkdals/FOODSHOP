<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>

<ax:set key="title" value="전표복사"/>
<ax:set key="page_desc" value="${PAGE_REMARK}"/>
<ax:set key="page_auto_height" value="true"/>

<ax:layout name="base">
    <jsp:attribute name="script">

        <script type="text/javascript">

            var dialog = new ax5.ui.dialog();
            var param = ax5.util.param(ax5.info.urlUtil().param);
            var fnObj = {};

            var tp_gb = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'CZ_Q0006');
            var tp_gb_arr = [];
            for (var i = 0; i < tp_gb.length; i++) {
                if (tp_gb[i].CODE == '03') {        //  기타
                    tp_gb_arr.push(tp_gb[i]);
                }
            }
            $("#S_TP_GB").ax5select({
                options: tp_gb_arr
            });

            var data_cdDocu = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, "CZ_Q0002", true, 'Y');    //  전표유형 CD_FLAG1 : "Y" 인 경우만 가져오기.

            $("#S_CD_DOCU").ax5select({
                options: data_cdDocu
            });

            //기간 컨트롤
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

            //페이지시작(document.ready)
            fnObj.pageStart = function () {
                this.pageButtonView.initView();
                this.searchView.initView();
                this.gridMain.initView();
                $("#DT_ACCT_F").val(getPastDate());
                $("#DT_ACCT_T").val(getRecentDate());
                $("#ID_WRITE").val(SCRIPT_SESSION.nmEmp);
                $("#ID_WRITE").attr('code', SCRIPT_SESSION.noEmp);
                $("#ID_WRITE").attr('text', SCRIPT_SESSION.nmEmp);

                ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
            };

            //버튼이벤트
            fnObj.pageButtonView = axboot.viewExtend({
                initView: function () {

                    axboot.buttonClick(this, "data-page-btn", {
                        "select": function () {
                            ACTIONS.dispatch(ACTIONS.ITEM_SELECT);
                        },
                        "close": function () {
                            ACTIONS.dispatch(ACTIONS.PAGE_CLOSE);
                        },
                        "search": function () {
                            ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                        }
                    });
                }
            });

            fnObj.searchView = axboot.viewExtend(axboot.searchView, {       //  조회영역
                initView: function () {
                    this.target = $(document["searchView0"]);
                    this.target.attr("onsubmit", "return ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);");
                    this.DT_ACCT_F = $("#DT_ACCT_F");
                    this.DT_ACCT_T = $("#DT_ACCT_T");
                    this.ID_WRITE = $("#ID_WRITE");
                },
                getData: function () {
                    return {
                        P_DT_ACCT_F: this.DT_ACCT_F.val().replace(/-/g, ""),
                        P_DT_ACCT_T: this.DT_ACCT_T.val().replace(/-/g, ""),
                        P_ID_WRITE: this.ID_WRITE.attr('code'),
                        P_CD_DOCU: $("select[name='S_CD_DOCU']").val(),
                        P_TP_GB: $("select[name='S_TP_GB']").val()
                    }
                }
            });

            //페이지에서 사용하는 기본 변수 객체
            var ACTIONS = axboot.actionExtend(fnObj, {
                PAGE_SEARCH: function (caller, act, data) {
                    axboot.ajax({
                        type: "GET",
                        url: ["gldocum", "getDocuCopy"],
                        data: caller.searchView.getData(),
                        callback: function (res) {
                            caller.gridMain.setData(res);
                            caller.gridMain.target.select(0);
                            caller.gridMain.target.focus(0);
                        }
                    })
                },
                PAGE_CLOSE: function (caller, act, data) {
                    parent.modal.close();
                },
                ITEM_SELECT: function (caller, act, data) {
                    if (nvl(caller.gridMain.getData('selected')[0]) == '') {
                        qray.alert('선택된 데이터가 없습니다.');
                        return false;
                    }
                    parent[param.callBack](caller.gridMain.getData('selected')[0]);
                },
            });

            //그리드초기화
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
                        target: $('[data-ax5grid="grid-main"]'),
                        columns: [
                            {
                                key: "CD_COMPANY",
                                label: "회사코드",
                                width: 80,
                                align: "left",
                                editor: false,
                                hidden: true
                            },
                            {
                                key: "DT_ACCT",
                                label: "회계일자",
                                width: 80,
                                align: "center",
                                editor: false,
                                formatter: function () {
                                    return $.changeDataFormat(this.value)
                                }
                            },
                            {
                                key: "GROUP_NUMBER",
                                label: "상신번호",
                                width: 100,
                                align: "left",
                                editor: false
                            },
                            {
                                key: "NO_DOCU",
                                label: "전표번호",
                                width: 100,
                                align: "left",
                                editor: false
                            },
                            {
                                key: "ST_ING",
                                label: "진행상태 코드값",
                                width: 80,
                                align: "left",
                                editor: false,
                                hidden: true
                            },
                            {
                                key: "NM_ST_ING",
                                label: "상태",
                                width: 60,
                                align: "center",
                                editor: false
                            },
                            {
                                key: "CD_DEPT",
                                label: "부서코드",
                                width: 80,
                                align: "left",
                                editor: false,
                                hidden: true
                            },
                            {
                                key: "NM_DEPT",
                                label: "부서",
                                width: 100,
                                align: "left",
                                editor: false
                            },
                            {
                                key: "ID_WRITE",
                                label: "사원코드",
                                width: 80,
                                align: "left",
                                editor: false,
                                hidden: true
                            },
                            {
                                key: "NM_EMP",
                                label: "사원",
                                width: 80,
                                align: "center",
                                editor: false
                            },
                            {
                                key: "REMARK",
                                label: "품의내역",
                                width: "*",
                                align: "left",
                                editor: false
                            },
                            {
                                key: "AMT_TOT",
                                label: "금액",
                                width: 100,
                                align: "right",
                                editor: false,
                                formatter: "money"
                            },
                        ],
                        body: {
                            onClick: function () {
                                this.self.select(this.dindex);
                                var index = fnObj.gridMain.getData('selected')[0].__index;

                            },
                            onDBLClick: function () {
                                ACTIONS.dispatch(ACTIONS.ITEM_SELECT);
                            },
                            onDataChanged: function () {
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
                    return ($("div [data-ax5grid='grid-main']").find("div [data-ax5grid-panel='body'] table tr").length)
                }
            });

            var openPopup = function (name) {
                userCallBack = function (e) {
                    if (e.length > 0) {

                        $("#ID_WRITE").val(e[0].NM_EMP);
                        $("#ID_WRITE").attr({"code": e[0].NO_EMP, "text": e[0].NM_EMP});
                    }
                    parent.ParentModal.close();
                };

                parent.openModal2("emp", "HELP_EMP", "userCallBack", this.name);
            };

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

        </script>
    </jsp:attribute>
    <jsp:body>

        <div data-page-buttons="">
            <div class="button-warp">
                <button type="button" class="btn btn-info" data-page-btn="select">선택</button>
                <!--검색조회 버튼-->
                <button type="button" class="btn btn-info" data-page-btn="search"><i class="icon_search"></i><ax:lang
                        id="ax.admin.sample.modal.button.search"/></button>
                <!--닫기 버튼 -->
                <button type="button" class="btn btn-info" data-page-btn="close"><ax:lang
                        id="ax.admin.sample.modal.button.close"/></button>
            </div>
        </div>

        <div class="ax-button-group" data-fit-height-aside="grid-main">
            <ax:form name="searchView0">
                <ax:tbl clazz="ax-search-tb1" minWidth="800px">
                    <ax:tr>
                        <ax:td label="회계일자" width="350px">
                            <div class="input-group" data-ax5picker="basic">
                                <input type="text" class="form-control" placeholder="yyyy/mm/dd" formatter="YYYYMMDD"
                                       id="DT_ACCT_F">
                                <span class="input-group-addon">~</span>
                                <input type="text" class="form-control" placeholder="yyyy/mm/dd" formatter="YYYYMMDD"
                                       id="DT_ACCT_T">
                                <span class="input-group-addon"><i class="cqc-calendar"></i></span>
                            </div>
                        </ax:td>
                        <ax:td label="작성사원" width="350px">
                            <div class="input-group">
                                <input type="text" class="form-control" name="ID_WRITE" id="ID_WRITE" READONLY/>
                                <span class="input-group-addon"><i class="cqc-magnifier" style="cursor: pointer"
                                                                   onclick="openPopup('emp')"></i></span>
                            </div>
                        </ax:td>
                        <ax:td label="유형" width="350px">
                            <div id="S_TP_GB" data-ax5select="S_TP_GB" data-ax5select-config='{}'></div>
                        </ax:td>
                        <ax:td label="전표유형" width="350px">
                            <div id="S_CD_DOCU" data-ax5select="S_CD_DOCU" data-ax5select-config='{}'></div>
                        </ax:td>
                    </ax:tr>
                </ax:tbl>
            </ax:form>
            <div class="H10"></div>
        </div>

        <div role="page-content" data-ax5layout="ax1">
            <div data-ax5grid="grid-main"
                 data-fit-height-content="grid-main"
                 style=""
                 data-ax5grid-config="{  showLineNumber: true,showRowSelector: false, multipleSelect: false,lineNumberColumnWidth: 40,rowSelectorColumnWidth: 27, }">
            </div>
        </div>
    </jsp:body>
</ax:layout>


