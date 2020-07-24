<%@ page import="com.chequer.axboot.core.utils.MessageUtils" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>

<ax:set key="title" value="글쓰기"/>
<ax:set key="page_desc" value="${pageRemark}"/>
<ax:set key="page_auto_height" value="true"/>


<ax:layout name="base">
    <jsp:attribute name="script">


        <ax:script-lang key="ax.script"/>
        <script type="text/javascript">
            var dl_BOARD_SP = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'MA00028', true);
            var param = ax5.util.param(ax5.info.urlUtil().param);
            var initData = parent.modal.modalConfig.sendData;
            var modal = new ax5.ui.modal();
            var BOARD_TYPE = nvl(initData["P_BOARD_TYPE"], '') != '' ? true : false;
            var SEQ = nvl(initData["P_SEQ"], '') != '' ? true : false;
            var CONTENTS = nvl(initData["P_CONTENTS"], '') != '' ? true : false;
            var TITLE = nvl(initData["P_TITLE"], '') != '' ? true : false;

            var fnObj = {}, CODE = {};
            var ACTIONS = axboot.actionExtend(fnObj, {

                PAGE_SAVE: function (caller, act, data) {
                    var DATA = {};
                    DATA.P_BOARD_TYPE = initData["P_BOARD_TYPE"];
                    DATA.P_TITLE = $("#TITLE").val();
                    DATA.P_CONTENTS = document.getElementById('CONTENTS').innerHTML;
                    DATA.P_SEQ = initData["P_SEQ"];
                    DATA.P_BOARD_SP = $('input[name="chk"]:checked').val();

                    var parameterData = {};
                    parameterData.bbsData = DATA;

                    qray.confirm({
                        msg: "저장하시겠습니까?"
                    }, function () {
                        if (this.key == "ok") {
                            qray.alert('아직 개발중입니다.');
                           /* axboot.ajax({
                                type: "POST",
                                url: ["Bbs", "write"],      // UP_CZ_Q_PARTNER_APP_S
                                data: JSON.stringify(parameterData),
                                callback: function (result) {
                                    parent[param.callBack](DATA);
                                    parent.modal.close();
                                }
                            });*/
                        }
                    })
                },
                PAGE_CLOSE: function (caller, act, data) {
                    parent.modal.close();        //  도움창 호출 시 axboot.modal.open() 했기때문.
                },
            });


            // fnObj 기본 함수 스타트와 리사이즈
            fnObj.pageStart = function () {
                this.pageButtonView.initView();

                if (CONTENTS) {
                    document.getElementById('CONTENTS').innerHTML = initData["P_CONTENTS"];
                }
                if (TITLE) {
                    $("#TITLE").val(initData["P_TITLE"])
                }
            };


            fnObj.pageButtonView = axboot.viewExtend({
                initView: function () {
                    axboot.buttonClick(this, "data-page-btn", {
                        "save": function () {
                            ACTIONS.dispatch(ACTIONS.PAGE_SAVE);
                        },
                        "close": function () {
                            ACTIONS.dispatch((ACTIONS.PAGE_CLOSE));
                        }
                    });
                }
            });

            function openPopup(){

            }

            function htmledit(excute, values) {
                if (values == null) {
                    document.execCommand(excute);
                } else {
                    document.execCommand(excute, "", values);
                }
            }
            for (var i = 0 ; i < dl_BOARD_SP.length; i++){
                $("#BORAD_SP").append(
                    "<input type='radio' style='margin-left:10px;' name='chk"+ i +"' id='chk"+ i +"' value='"+ dl_BOARD_SP[i].CODE +"'>" +
                    "<label for='chk"+ i +"' style='margin-top: 10px;'>"+ dl_BOARD_SP[i].TEXT +"</label>"
                )
            }
        </script>
    </jsp:attribute>
    <jsp:body>
        <style>
            .chk_BOARD_SP {
                margin-left: 10px;
            }

            i {
                font-style: italic;
            }

            html, body {
                margin: 0;
                padding: 0;
                width: 100%;
                height: 100%;
                font-size: 12px;
            }

            td {
                border: 1px solid #ddd;
            }


            #jb-container {
                padding: auto;
                margin: auto;
                width: 100%;
                height: 500px;
                border: 0px solid #eee;
            }

            #jb-header {
                margin-bottom: 20px;
            }

            #jb-content {
                width: 100%;
                height: 400px;
                min-height: 50px;
                max-height: 500px;
                border: 0px solid #eee;
            }

            .inputText {
                outline-style: none;
                border: 0px solid #eee;
            }

            input:disabled {
                background-color: #ffffff;
            }

            .noresize {
                outline-style: none;
                border: 1px solid #eee;
                resize: none; /* 사용자 임의 변경 불가 */
                width: 100%;
                height: 100%;
                overflow: auto;
            }

            .editor {
                margin: 0 auto 5px;
                height: 25px;
                border: 1px solid #eee;
            }

            .editor table {
                border: 0px;
            }

            .editor table tr {
                border: 0px;
            }

            .editor table td {
                border: 0px;
            }

            .editor button:first-child {
                width: 45px;
                height: 25px;
                border-radius: 3px;
                background: none;
                border: none;
                box-sizing: border-box;
                padding: 0;
                color: #a6a6a6;
                cursor: pointer;
                outline: none;
            }

            .editor button {
                width: 45px;
                height: 25px;
                border-radius: 3px;
                background: none;
                border-left: 1px solid #eee;
                box-sizing: border-box;
                padding: 0;
                color: #a6a6a6;
                cursor: pointer;
                outline: none;
            }

            .editor button:last-child {
                width: 45px;
                height: 25px;
                border-radius: 3px;
                background: none;
                border-right: 1px solid #eee;
                box-sizing: border-box;
                padding: 0;
                color: #a6a6a6;
                cursor: pointer;
                outline: none;
            }

            .editor select {
                width: 80px;
                height: 25px;
                border-radius: 3px;
                background: none;
                border: 1px solid #eee;
                box-sizing: border-box;
                padding: 0;
                color: #a6a6a6;
                cursor: pointer;
                outline: none;
            }
        </style>

        <div id="jb-container">
            <div id="jb-header">
                <table style="minWidth:800px;">
                    <tr>
                        <td style="background: #f6f6f6; width: 400px; text-align: center; letter-spacing: 2px;"><label
                                style="color: #656a6f;">제목</label>
                        </td>
                        <td style="padding: 10px;">
                            <input type="text" id="TITLE" class="inputText" style="width: 813px; height: 30px;">
                        </td>
                    </tr>
                    <tr>
                        <td style="background: #f6f6f6; width: 400px; text-align: center; letter-spacing: 2px;">
                            <label style="color: #656a6f;">게시판유형</label>
                        </td>
                        <td style="padding: 10px;text-indent: 5px;vertical-align: middle;" id="BORAD_SP">
                        </td>
                    </tr>
                    <tr>
                        <td style="background: #f6f6f6; width: 400px; text-align: center; letter-spacing: 2px;">
                            <label style="color: #656a6f;">알림대상자</label>
                        </td>
                        <td style="padding: 10px;">
                            <div class="input-group">
                                <input type="text" class="form-control" name="ID_USER" id="ID_USER" READONLY
                                       style="width: 788px; height: 30px;"/>
                                <span class="input-group-addon"><i class="cqc-magnifier" style="cursor: pointer"
                                                                   onclick="openPopup('ID_USER')"></i></span>
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
            <div id="jb-content">
                <div class="editor" for="CONTENTS">
                    <table>
                        <td>
                            <select onchange="htmledit('fontname',this.value);">
                                <option value="돋음">글꼴</option>
                                <option value="돋음">돋음</option>
                                <option value="굴림">굴림</option>
                                <option value="궁서">궁서</option>
                            </select>
                        </td>
                        <td>
                            <select onchange="htmledit('fontSize',this.value);">
                                <option value="2">크기</option>
                                <option value="2">2</option>
                                <option value="4">4</option>
                                <option value="6">6</option>
                                <option value="8">8</option>
                            </select>
                        </td>
                        <td style="padding-left: 10px;"><img src="/assets/images/editor/btn_n_bold.gif"
                                                             style="height: 25px;" onclick="htmledit('BOLD');">
                        </td>
                        <td><img src="/assets/images/editor/btn_n_underline.gif" style="height: 25px;"
                                 onclick="htmledit('underline');"></td>
                        <td><img src="/assets/images/editor/btn_n_Italic.gif" style="height: 25px;"
                                 onclick="htmledit('italic')"></td>

                        <td style="padding-left: 10px;"><img src="/assets/images/editor/btn_n_alignleft.gif"
                                                             style="height: 25px;" onclick="htmledit('justifyleft');">
                        </td>
                        <td><img src="/assets/images/editor/btn_n_aligncenter.gif" style="height: 25px;"
                                 onclick="htmledit('justifycenter');">
                        </td>
                        <td><img src="/assets/images/editor/btn_n_alignright.gif" style="height: 25px;"
                                 onclick="htmledit('justifyright');"></td>
                        <td><img src="/assets/images/editor/btn_n_alignjustify.gif" style="height: 25px;"
                                 onclick="htmledit('justify');">
                        </td>
                        </tr>
                    </table>
                </div>
                <table style="minWidth:800px;">
                    <tr>
                        <td style="background: #f6f6f6; width: 400px; text-align: center; letter-spacing: 2px;"><label
                                style="color: #656a6f;">내용</label>
                        </td>
                        <td style="padding: 10px;">
                            <div id="CONTENTS" name="CONTENTS" class="noresize" contenteditable="true"
                                 style="width: 813px; height: 300px; "/>
                        </td>
                    </tr>
                </table>

            </div>

            <div align="center" style="padding: 30px;">
                <button type="button" class="btn btn-info" data-page-btn="save">저장</button>
                <button type="button" class="btn btn-info" data-page-btn="close">취소</button>
            </div>
        </div>
    </jsp:body>
</ax:layout>