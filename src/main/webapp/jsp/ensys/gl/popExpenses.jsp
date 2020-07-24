<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>

<ax:set key="title" value="편익제공"/>
<ax:set key="page_desc" value="${PAGE_REMARK}"/>
<ax:set key="page_auto_height" value="true"/>

<ax:layout name="base">
    <jsp:attribute name="script">
        <script type="text/javascript">


            var getXmlHttpRequest = function () {
                if (window.ActiveXObject) {
                    try {
                        return new ActiveXObject("Msxml2.XMLHTTP");
                    } catch (e) {
                        try {
                            return new ActiveXObject("Microsoft.XMLHTTP");
                        } catch (e1) {
                            qray.alert('에러에러');
                        }
                    }
                } else if (window.XMLHttpRequest) {
                    return new XMLHttpRequest();
                } else {
                    qray.alert('에러에러');
                }
            };
            var dialog = new ax5.ui.dialog();
            var param = ax5.util.param(ax5.info.urlUtil().param);
            var fnObj = {};

            // var _NOTPDOCU = parent.modal.modalConfig.sendData().NOTPDOCU;   // 상단키값,그룹넘버대신임시로 테이블에 넣어놨다가 나중에 그룹넘버로 업데이트할예정
            var _DT_ACCT = parent.modal.modalConfig.sendData["DT_ACCT"];     //회계일자
            var _AMT = parent.modal.modalConfig.sendData["AMT"];              //금액
            var _benefitList = parent.modal.modalConfig.sendData["benefitList"];
            var _GROUP_NUMBER = parent.modal.modalConfig.sendData["GROUP_NUMBER"];
            console.log("_benefitList : ", _benefitList);
            var _CD_PARTNER = parent.modal.modalConfig.sendData["CD_PARTNER"];
            var _LN_PARTNER = parent.modal.modalConfig.sendData["LN_PARTNER"];

            //구분
            var CodeData2 = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, "CZ_Q0025", true);
            //편익제공유형(그리드컬럼에서 사용)
            var CodeData3 = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, "CZ_Q0027", true);
            //편익제공유형(상단조건에서사용)
            var CodeData27 = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, "CZ_Q0027", true);

            $("#BNFT_GB1").ax5select({
                options: CodeData27
            });

            //페이지시작(document.ready)
            fnObj.pageStart = function () {
                this.pageButtonView.initView();
                this.gridMain.initView();

                $("#AMTTXT").val(comma(_AMT));
                $("#CD_PARTNER").val(_LN_PARTNER);

                if (nvl(_benefitList) != '') {

                    var obj = {
                        list : _benefitList,
                        page : fnObj.gridMain.getPageData()
                    };
                    fnObj.gridMain.setData(obj);

                }else{
                    axboot.ajax({
                        type: "GET",
                        url: ["gldocum2", "getBenefit"],
                        data: {
                            GROUP_NUMBER : nvl(_GROUP_NUMBER)
                        },
                        async: false,
                        callback: function (res) {
                            console.log(res);
                            if (nvl(res.list) != ''){
                                if (res.list.length > 0){
                                    fnObj.gridMain.setData(res);
                                }
                            }
                        }
                    });
                }
            };

            //버튼이벤트
            fnObj.pageButtonView = axboot.viewExtend({
                initView: function () {

                    axboot.buttonClick(this, "data-page-btn", {
                        "close": function () {
                            ACTIONS.dispatch(ACTIONS.PAGE_CLOSE);
                        }
                    });

                    axboot.buttonClick(this, "data-page-btn", {
                        "download": function () {
                            ACTIONS.dispatch(ACTIONS.DOWNLOAD);
                        }
                    });

                    axboot.buttonClick(this, "data-page-btn", {
                        "upload": function () {
                            ACTIONS.dispatch(ACTIONS.UPLOAD);
                        }
                    });

                    axboot.buttonClick(this, "data-page-btn", {
                        "save": function () {
                            ACTIONS.dispatch(ACTIONS.PAGE_SAVE);
                        }
                    });
                }
            });

            //페이지에서 사용하는 기본 변수 객체
            var ACTIONS = axboot.actionExtend(fnObj, {
                UPLOAD: function (caller, act, data) {
                    var fileTag = document.createElement("INPUT");

                    $(fileTag).change(function () {

                        console.log("fileTag", this.files[0]);

                        var fileName = $(this).val();
                        fileName = fileName.slice(fileName.indexOf(".") + 1).toLowerCase();
                        if (fileName != "xls" && fileName != "xlsx") {
                            $(this).val("");
                            qray.alert("xls, xlsx 확장자의 파일만 사용 가능합니다.");
                            return false;
                        }

                        console.log();
                        var formData = new FormData();
                        formData.append('files', this.files[0]);

                        $.ajax({
                            type: 'POST',
                            async: false,
                            enctype: 'multipart/form-data',
                            processData: false,
                            contentType: false,
                            cache: false,
                            timeout: 600000,
                            url: '/api/commonutility/excelUpload',
                            data: formData,
                            success: function (result) {
                                console.log("result", result);
                                for (var i = 0; i < result.list.length; i++) {
                                    var obj = result.list[i];
                                    caller.gridMain.addRow();
                                    var lastIdx = nvl(fnObj.gridMain.target.list.length, fnObj.gridMain.lastRow());

                                    caller.gridMain.target.select(lastIdx - 1);
                                    caller.gridMain.target.focus(lastIdx - 1);

                                    caller.gridMain.target.setValue(lastIdx - 1, "GUBUN", '2');     //  법카 : '1', 기타전표 : '2'
                                    caller.gridMain.target.setValue(lastIdx - 1, "DT_START", _DT_ACCT);
                                    caller.gridMain.target.setValue(lastIdx - 1, "AMT_USE", obj.AMT_USE);
                                    caller.gridMain.target.setValue(lastIdx - 1, "CUST_SUMAMT", 0);
                                    caller.gridMain.target.setValue(lastIdx - 1, "TP_CUST_EMP", obj.TP_CUST_EMP);
                                    caller.gridMain.target.setValue(lastIdx - 1, "CD_CUST_EMP", obj.CD_CUST_EMP);
                                    caller.gridMain.target.setValue(lastIdx - 1, "NM_CUST", obj.NM_CUST);
                                    caller.gridMain.target.setValue(lastIdx - 1, "BNFT_SUP_TYPE", obj.BNFT_SUP_TYPE);
                                    caller.gridMain.target.setValue(lastIdx - 1, "CONT_CUST", obj.CONT_CUST);

                                    if (obj.TP_CUST_EMP == '1' && nvl(obj.CD_CUST_EMP) != '' && nvl(obj.CONT_CUST) != '') {
                                        var res = $.DATA_SEARCH("gldocum", "getBnftAmt", {
                                            CD_CUST_EMP: obj.CD_CUST_EMP,
                                            CONT_CUST: obj.CONT_CUST,
                                            DT_ACCT: _DT_ACCT

                                        });
                                        fnObj.gridMain.target.setValue(lastIdx - 1, "CUST_SUMAMT", res.map.AMT);
                                    }
                                }
                            }
                        });

                    });

                    fileTag.setAttribute("type", "file");
                    fileTag.setAttribute("id", "ExcelUploadFileTag");
                    fileTag.click();
                },
                DOWNLOAD: function (caller, act, data) {
                    var columns = caller.gridMain.target.columns;
                    var Arr = [];
                    for (var i = 0; i < columns.length; i++) {
                        if (JSON.stringify(Object.keys(columns[i])).indexOf('ExcelShow') > -1) {
                            if (columns[i]['ExcelShow'] == true) {
                                Arr.push(columns[i]);
                            }
                        }
                    }

                    var _url = '/api/commonutility/excelDown';
                    var _jsonData = JSON.stringify({
                        items: Arr
                    });


                    var xhr = getXmlHttpRequest();

                    xhr.open('POST', _url);
                    xhr.responseType = 'blob';
                    xhr.setRequestHeader('Content-type', 'application/json');
                    xhr.onreadystatechange = function () {
                        if (this.readyState == 4 && this.status == 200) {

                            console.log(this);
                            var _data = this.response;
                            var _blob = new Blob([_data], {type: 'data:application/vnd.ms-excel'});
                            var link = document.createElement('a');

                            if (window.navigator.msSaveBlob) { // IE

                                window.navigator.msSaveOrOpenBlob(_blob, "text.xlsx")

                            } else if (navigator.userAgent.search("Firefox") !== -1) { // Firefox
                                link.css({display: 'none'});
                                link.attr({
                                    href: 'data:attachment/csv;charset=utf-8,' + encodeURIComponent(_data),
                                    target: '_blank',
                                    download: "text.xlsx"
                                })[0].click();

                                link.remove();
                            } else { // Chrome
                                link.setAttribute("href", window.URL.createObjectURL(_blob));
                                link.setAttribute("download", "text.xlsx");
                                link.click();
                            }


                        }
                    };
                    xhr.send(_jsonData);
                }
                ,
                PAGE_CLOSE: function (caller, act, data) {
                    parent.modal.close();
                }
                ,
                ITEM_ADD3: function (caller, act, data) {

                    caller.gridMain.addRow();
                    var lastIdx = nvl(fnObj.gridMain.target.list.length, fnObj.gridMain.lastRow());

                    caller.gridMain.target.select(lastIdx - 1);
                    caller.gridMain.target.focus(lastIdx - 1);

                    caller.gridMain.target.setValue(lastIdx - 1, "GUBUN", '2');     //  법카 : '1', 기타전표 : '2'
                    caller.gridMain.target.setValue(lastIdx - 1, "DT_START", _DT_ACCT);
                    caller.gridMain.target.setValue(lastIdx - 1, "AMT_USE", 0);
                    caller.gridMain.target.setValue(lastIdx - 1, "CUST_SUMAMT", 0);
                    caller.gridMain.target.setValue(lastIdx - 1, "TP_CUST_EMP", '1');
                    caller.gridMain.target.setValue(lastIdx - 1, "CD_CUST_EMP", _CD_PARTNER);
                    caller.gridMain.target.setValue(lastIdx - 1, "NM_CUST", _LN_PARTNER);
                    caller.gridMain.target.setValue(lastIdx - 1, "BNFT_SUP_TYPE", $("select[name='BNFT_GB1']").val());
                }
                ,
                ITEM_DEL3: function (caller) {

                    var beforeIdx = caller.gridMain.target.selectedDataIndexs[0];
                    var dataLen = caller.gridMain.target.getList().length;

                    if ((beforeIdx + 1) == dataLen) {
                        beforeIdx = beforeIdx - 1;
                    }

                    caller.gridMain.delRow("selected");
                    if (beforeIdx > 0 || beforeIdx == 0) {
                        caller.gridMain.target.select(beforeIdx);
                    }
                }
                ,
                PAGE_SAVE: function (caller) {
                    //임시저장액션
                    var gridM = fnObj.gridMain.target.list;
                    var tempamtuse = 0;

                    for (var i = 0; i < gridM.length; i++) {
                        tempamtuse += Number(nvl(gridM[i].AMT_USE, 0));

                        if (nvl(gridM[i].CD_CUST_EMP) == '') {
                            qray.alert("고객/사원정보는 필수입니다.");
                            return false;
                        }
                        if (nvl(gridM[i].TP_CUST_EMP) == '1' && nvl(gridM[i].CONT_CUST) == '') { // TP_CUST_EMP 0 사원 1 고객
                            qray.alert("고객담당자 정보는 필수입니다.");
                            return false;
                        }
                    }

                    if (tempamtuse != _AMT) {
                        qray.alert('합계금액과 현재입력하신금액의 합이 다릅니다');
                        return false;
                    }

                    var obj = {};
                    obj.list = gridM;

                    parent[param.callBack](cloneObject(obj));

                }
                ,
                BNFT_BTN: function (caller, act, data) {

                    var num = $("#BNFT_NUM").val();
                    var rows = caller.gridMain.lastRow();
                    var len = Number(nvl(num, 0)) + Number(nvl(rows, 0));
                    var sum_amt = 0;
                    for (var i = rows; i < len; i++) {
                        if (i != len - 1 || len == 1) {
                            sum_amt += Math.floor(Number(_AMT) / len);
                            caller.gridMain.addRow();

                            caller.gridMain.target.setValue(i, "GUBUN", '2');     //  법카 : '1', 기타전표 : '2'
                            caller.gridMain.target.setValue(i, "BNFT_SUP_TYPE", $("select[name='BNFT_GB1']").val());
                            caller.gridMain.target.setValue(i, "AMT_USE", Math.floor(Number(_AMT) / len));
                            caller.gridMain.target.setValue(i, "DT_START", _DT_ACCT);
                            caller.gridMain.target.setValue(i, "CUST_SUMAMT", 0);
                            caller.gridMain.target.setValue(i, "TP_CUST_EMP", '1');
                            caller.gridMain.target.setValue(i, "CD_CUST_EMP", _CD_PARTNER);
                            caller.gridMain.target.setValue(i, "NM_CUST", _LN_PARTNER);
                        } else {
                            caller.gridMain.addRow();

                            caller.gridMain.target.setValue(i, "GUBUN", '2');     //  법카 : '1', 기타전표 : '2'
                            caller.gridMain.target.setValue(i, "BNFT_SUP_TYPE", $("select[name='BNFT_GB1']").val());
                            caller.gridMain.target.setValue(i, "AMT_USE", Number(_AMT) - sum_amt);
                            caller.gridMain.target.setValue(i, "DT_START", _DT_ACCT);
                            caller.gridMain.target.setValue(i, "CUST_SUMAMT", 0);
                            caller.gridMain.target.setValue(i, "TP_CUST_EMP", '1');
                            caller.gridMain.target.setValue(i, "CD_CUST_EMP", _CD_PARTNER);
                            caller.gridMain.target.setValue(i, "NM_CUST", _LN_PARTNER);
                        }
                    }
                }
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
                                key: "CD_COMPANY", label: "회사코드", width: 80, align: "left", editor: false, hidden: true,

                            },
                            {
                                key: "GUBUN", label: "출처구분", width: 80, align: "left", editor: false, hidden: true,

                            },
                            {
                                key: "DT_START", label: "발생일자", width: 80, align: "left", editor: false, hidden: true,

                            },
                            {
                                key: "SEQ_BNFT", label: "순번", width: 80, align: "left", editor: false, hidden: true,

                            },
                            {
                                key: "AC_NO_TPDOCU",
                                label: "",
                                width: 80,
                                align: "left",
                                editor: false,
                                hidden: true,

                            },
                            {
                                key: "AC_GROUP_NUMBER",
                                label: "그룹번호",
                                width: 80,
                                align: "left",
                                editor: false,
                                hidden: true,

                            },
                            {
                                key: "TP_CUST_EMP", label: "구분", width: 100, align: "center",
                                formatter: function () {
                                    return $.changeTextValue(CodeData2, this.value)
                                }
                                , editor: {
                                    type: "select", config: {
                                        columnKeys: {
                                            optionValue: "CODE", optionText: "TEXT"
                                        },
                                        options: CodeData2
                                    }
                                },
                                ExcelShow: true,
                                desc: "사원 : 0 \n고객 : 1"
                            },
                            {
                                key: "CD_CUST_EMP", label: "고객사", width: 120, align: "center", editor: false,
                                ExcelShow: true,
                                desc: "ㅋ"
                            },
                            {
                                key: "NM_CUST",
                                label: "고객명",
                                width: 120,
                                align: "left",
                                editor: false,
                                ExcelShow: true,
                            },
                            {
                                key: "CONT_CUST", label: "고객담당자", width: 120, align: "left", editor: {
                                    type: "text",
                                    disabled: function () {
                                        if (this.item.TP_CUST_EMP == '1') {
                                            return false;
                                        } else {
                                            return true;
                                        }
                                    }
                                }, ExcelShow: true

                            },
                            {
                                key: "BNFT_SUP_TYPE", label: "편익제공유형", width: 100, align: "center",
                                formatter: function () {
                                    return $.changeTextValue(CodeData3, this.value)
                                }
                                , editor: {
                                    type: "select", config: {
                                        columnKeys: {
                                            optionValue: "CODE", optionText: "TEXT"
                                        },
                                        options: CodeData3
                                    }
                                },
                                ExcelShow: true,
                            },
                            {
                                key: "AMT_USE",
                                label: "집행금액",
                                width: "*",
                                align: "right",
                                editor: {type: "text"},
                                formatter: "money",
                                ExcelShow: true,
                            },
                            {
                                key: "CUST_SUMAMT",
                                label: "편익누적금액",
                                width: 110,
                                align: "right",
                                editor: false,
                                formatter: "money",
                                hidden: true
                            }
                        ],
                        footSum: [
                            [
                                {label: "합계", colspan: 5, align: "center"},
                                {key: "AMT_USE", collector: "sum", formatter: "money", align: "right"}
                                //{key: "CUST_SUMAMT", collector: "sum", formatter: "money", align: "right"}
                            ]
                        ],
                        body: {
                            onClick: function () {
                                this.self.select(this.dindex);
                                var index = fnObj.gridMain.getData('selected')[0].__index;
                                //사원일때
                                if (this.column.key == "CD_CUST_EMP" && this.item.TP_CUST_EMP == '0') {
                                    openPopup("emp", index);
                                }
                                //고객일때
                                else if (this.column.key == "CD_CUST_EMP" && this.item.TP_CUST_EMP == '1') {
                                    openPopup("partner", index);
                                }
                            },
                            onDataChanged: function () {
                                if (this.key == 'TP_CUST_EMP') {
                                    if (this.value == '1') {
                                        fnObj.gridMain.target.setValue(this.dindex, "CD_CUST_EMP", _CD_PARTNER);
                                        fnObj.gridMain.target.setValue(this.dindex, "NM_CUST", _LN_PARTNER);
                                    } else {
                                        fnObj.gridMain.target.setValue(this.dindex, "CD_CUST_EMP", '');
                                        fnObj.gridMain.target.setValue(this.dindex, "NM_CUST", '');
                                        fnObj.gridMain.target.setValue(this.dindex, "CONT_CUST", '');
                                    }
                                }

                                /* 편익누적금액 숨기면서 현재부분도 주석처리함 20191028 이동관
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
                        }
                    });

                    axboot.buttonClick(this, "data-grid-main-btn", {
                        "add": function () { // 추가버튼
                            ACTIONS.dispatch(ACTIONS.ITEM_ADD3);
                        },
                        "delete": function () { //삭제버튼
                            ACTIONS.dispatch(ACTIONS.ITEM_DEL3);
                        },
                        "bnftBtn": function () { //배분버튼
                            ACTIONS.dispatch(ACTIONS.BNFT_BTN);
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

            var openPopup = function (var_name, var_index) {
                openpopup_userCallBack = function (e) {
                    if (e.length > 0) {

                        if (var_name.toUpperCase() == "EMP") {
                            fnObj.gridMain.target.setValue(var_index, "CD_CUST_EMP", e[0].NO_EMP);
                            fnObj.gridMain.target.setValue(var_index, "NM_CUST", e[0].NM_EMP);
                        } else if (var_name.toUpperCase() == "PARTNER") {
                            fnObj.gridMain.target.setValue(var_index, "CD_CUST_EMP", e[0].CD_PARTNER);
                            fnObj.gridMain.target.setValue(var_index, "NM_CUST", e[0].LN_PARTNER);
                        }
                    }
                    parent.ParentModal.close();
                };

                parent.openModal2(var_name, "HELP_" + var_name.toUpperCase(), "openpopup_userCallBack", this.name);
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

            function cloneObject(obj) {
                return JSON.parse(JSON.stringify(obj));
            }

        </script>
    </jsp:attribute>
    <jsp:body>

        <div data-page-buttons="">
            <div class="button-warp">
                    <%--<button type="button" class="btn btn-info" data-page-btn="download">양식다운로드</button>
                    <button type="button" class="btn btn-info" data-page-btn="upload">엑셀업로드</button>--%>
                        <button type="button" class="btn btn-reload" data-page-btn="reload" onclick="window.location.reload();"
                                style="width:80px;">
                            <i class="icon_reload"></i></button>
                <button type="button" class="btn btn-info" data-page-btn="save"><i class="icon_save"></i>임시저장</button>
                <button type="button" class="btn btn-info" data-page-btn="close"><ax:lang
                        id="ax.admin.sample.modal.button.close"/></button>
            </div>
        </div>

        <div id="colThree">
            <div class="ax-button-group" data-fit-height-aside="grid-main">
                <div class="left">

                </div>
                <div class="right">
                    <button type="button" class="btn btn-small" data-grid-main-btn="delete" id="ADD4"
                            style="float:right;margin-left:5px;"><i
                            class="icon_del"></i> <ax:lang id="ax.admin.delete"/></button>
                    <button type="button" class="btn btn-small" data-grid-main-btn="add" id="ADD3"
                            style="float:right;margin-left:30px;"><i
                            class="icon_add"></i> <ax:lang id="ax.admin.add"/></button>
                    <input id="AMTTXT" type="text"
                           style="width: 80px;height:24px;float:right;margin-left:5px;text-align:right" value="0"
                           disabled/>
                    <label style="float:right;margin-top:5px;margin-left:30px;">합계금액</label>
                    <button type="button" class="btn btn-small" data-grid-main-btn="bnftBtn" id="bnftBtn"
                            style="float:right;margin-left:5px;"><i
                            class="icon_add"></i> 배분
                    </button>
                    <input id="BNFT_NUM" type="number" style="width: 50px;height:24px;float:right;margin-left:5px;"
                           value="0" min="0"/>
                    <label style="float:right;margin-top:5px;margin-left:15px;">인원수</label>
                    <div style="width: 100px; float:right;margin-left:5px;" id="BNFT_GB1"
                         data-ax5select="BNFT_GB1" data-ax5select-config='{}'></div>
                    <label style="float:right;margin-top:5px; margin-left:15px;">편익제공유형</label>
                    <input id="CD_PARTNER" type="text" style="width: 87px;height:24px;float:right;margin-left:5px;"
                           disabled/>
                    <label style="float:right;margin-top:5px;">거래처</label>
                </div>
            </div>
            <div data-ax5grid="grid-main"
                 data-fit-height-content="grid-main"
                 style="height: 300px;"
                 data-ax5grid-config="{  showLineNumber: true,showRowSelector: false, multipleSelect: false,lineNumberColumnWidth: 40,rowSelectorColumnWidth: 27, }">
            </div>
        </div>

    </jsp:body>
</ax:layout>


