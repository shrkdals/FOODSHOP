<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>

<ax:set key="title" value="비밀번호 변경"/>
<ax:set key="page_desc" value="${PAGE_REMARK}"/>
<ax:set key="page_auto_height" value="true"/>


<ax:layout name="base">
    <jsp:attribute name="script">
        <script type="text/javascript">
            var MsgDialog = new ax5.ui.dialog();

            var fnObj = {}, CODE = {};
            var ACTIONS = axboot.actionExtend(fnObj, {
                PAGE_SAVE: function (caller, act, data) {
                    var PASS_WORD1 = $("#PASS_WORD1").val();
                    var PASS_WORD2 = $("#PASS_WORD2").val();

                    if (nvl(PASS_WORD1) == '') {
                        qray.alert('비밀번호를 입력해주세요.');
                        return false;
                    }
                    if (nvl(PASS_WORD2) == '') {
                        qray.alert('비밀번호를 입력해주세요.');
                        return false;
                    }
                    if (PASS_WORD1 != PASS_WORD2) {
                        qray.alert('비밀번호가 서로 틀립니다.');
                        return false;
                    }
                    axboot.ajax({
                        method: "PUT",
                        url: ["users", "passwordModify"],
                        data: JSON.stringify({
                            PASS_WORD1: PASS_WORD1,
                            PASS_WORD2: PASS_WORD2,
                        }),
                        callback: function (res) {
                            MsgDialog.alert({
                                title: "알림",
                                msg: "비밀번호가 변경됐습니다.",
                                onStateChanged: function () {
                                    if (this.state === "open") {
                                        mask.open();
                                    } else if (this.state === "close") {
                                        mask.close();
                                        parent.modal.close();
                                    }
                                }
                            });
                        }
                    });
                }
            });

            fnObj.pageStart = function () {
                this.pageButtonView.initView();

                $("#ID_USER").val(SCRIPT_SESSION.idUser);
            };

            fnObj.pageButtonView = axboot.viewExtend({
                initView: function () {
                    axboot.buttonClick(this, "data-page-btn", {
                        "ok": function () {
                            ACTIONS.dispatch(ACTIONS.PAGE_SAVE);
                        },
                        "cancel": function () {
                            parent.modal.close();
                        }
                    });
                }
            });

        </script>
    </jsp:attribute>
    <jsp:body>
        <div data-page-buttons="">
            <div class="button-warp">
                <button type="button" class="btn btn-popup-default" data-page-btn="ok" style="width: 80px;">변경
                </button>
                <button type="button" class="btn btn-popup-default" data-page-btn="cancel" style="width: 80px;">다음에 변경
                </button>
            </div>
        </div>

        <div class="H10"></div>
        <div class="H10"></div>


        <ax:tbl clazz="ax-search-tb2" minWidth="800px">
            <ax:tr>
                <ax:td label='회원아이디' width="400px">
                    <input type="text"
                           class="form-control"
                           data-ax-path="ID_USER"
                           name="ID_USER"
                           id="ID_USER" readonly/>
                </ax:td>
            </ax:tr>
            <ax:tr>
                <ax:td label='비밀번호' width="400px">
                    <input type="password"
                           class="form-control"
                           data-ax-path="PASS_WORD1"
                           name="PASS_WORD1"
                           id="PASS_WORD1"/>
                </ax:td>
            </ax:tr>
            <ax:tr>
                <ax:td label='비밀번호 확인' width="400px">
                    <input type="password"
                           class="form-control"
                           data-ax-path="PASS_WORD2"
                           name="PASS_WORD2"
                           id="PASS_WORD2"/>
                </ax:td>
            </ax:tr>
        </ax:tbl>
        <div class="H10"></div>
        <div class="H10"></div>

        <div class="ax-button-group" data-fit-height-aside="grid-view-01">
            <div class="left">
                <h4><font color="#00ffff">*</font> 비밀번호 찾기를 통한 비밀번호 초기화가 이뤄졌습니다. </h4>
                <h4><font color="#00ffff">*</font> 임시 비밀번호를 변경해주십시오.</h4>
            </div>
        </div>
    </jsp:body>
</ax:layout>