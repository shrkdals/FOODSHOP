<%@ tag import="org.apache.commons.lang3.StringUtils" %>
<%@ tag language="java" pageEncoding="UTF-8" body-content="scriptless" %>
<%@ attribute name="MODE" %>
<%@ attribute name="id" %>
<%@ attribute name="name" %>
<%@ attribute name="BOARD_TYPE" %>
<%@ attribute name="SEQ" %>
<%@ attribute name="CallBack" %>
<%
    if (StringUtils.isEmpty(id)) {
        id = "FILE";
    }
    if (StringUtils.isEmpty(name)) {
        name = "FILE";
    }
    if (StringUtils.isEmpty(BOARD_TYPE)) {
        BOARD_TYPE = "";
    }
    if (StringUtils.isEmpty(CallBack)) {
        CallBack = "FileCallBack";
    }
    if (StringUtils.isEmpty(MODE)) {
        MODE = "2";
    }

%>
<div class="input-group">
    <input type="text" class="form-control" name="${name}" id="${id}"
           readonly/>
    <span class="input-group-addon"><i class="cqc-magnifier" style="cursor: pointer"
                                       onclick="openFile('FILE')"></i></span>
</div>

<%--
    MODE : 2 [ modal 안에 파일브라우저 ]
    1 ) 업무단 화면
    2 ) 업무단의 팝업창
    3 ) 업무단의 팝업창의 파일브라우저

     - 업무단 화면 var FileBrowserModal = new ax5.ui.modal(); 선언
     - 업무단의 팝업창 안에 <ax:file /> 태그를 선언
     - SEQ 넘겨주기.
--%>

<script type="text/javascript">

    var imsiFile = {};

    var saveData = function () {
        var formData = new FormData();

        if (Object.keys(imsiFile).length > 0) {
            if (nvl(imsiFile["files"]) != '' && imsiFile["files"].length > 0) {

                for (var i = 0; i < Object.keys(imsiFile["files"]).length; i++) {
                    var files = imsiFile["files"];
                    formData.append('files', files[Object.keys(files)[i]]);
                }
            } else {
                formData.append('files', null);
            }


            var delFile = {};
            if (nvl(imsiFile["delete"]) != '' && imsiFile["delete"].length > 0) {
                for (var i = 0; i < imsiFile["delete"].length; i++) {
                    if (imsiFile["delete"][i].__deleted__) {
                        formData.append("delFile", imsiFile["delete"][i].SEQ_FILE);
                    } else {
                        formData.append("delFile", '');
                    }
                }
            } else {
                formData.append("delFile", '');
            }
        }
        return formData;
    };

    var FileCallBack = function (e) {
        message('임시저장하였습니다.');

        imsiFile.files = e.files;
        imsiFile.gridData = e.gridData;
        imsiFile.delete = e.delete;

        var html = "";
        var chkVal;
        for (var i = 0; i < e.gridData.length; i++) {
            var list = e.gridData[i];
            if (i == 0) {
                html += list.ORGN_FILE_NAME
            } else {
                chkVal = true;
                break;
            }
        }
        if (chkVal) {
            html += ".. 외 " + (res.list.length - 1) + "개";
        }
        $("#${id}").val(html);
    };

    if ('${MODE}' == '1') {

        var FileBrowserModal = new ax5.ui.modal();
        var openFile = function () {
            var CallBack = 'FileCallBack';
            if (Object.keys(imsiFile).length > 0) {
                var data = {
                    "P_BOARD_TYPE": '${BOARD_TYPE}', // [ 모듈_메뉴명_해당ID값
                    "P_SEQ": '${SEQ}',
                    "imsiFile": imsiFile
                }
            } else {
                var data = {
                    "P_BOARD_TYPE": '${BOARD_TYPE}', // [ 모듈_메뉴명_해당ID값
                    "P_SEQ": '${SEQ}'
                }
            }

            $.openFileBrowser(CallBack, data, FileBrowserModal);
        }
    }

    if ('${MODE}' == '2') {

        parent["openFileModal"] = function (callBack, viewName, initData) {
            var map = new Map();
            map.set("modal", parent.FileBrowserModal);
            map.set("modalText", "FileBrowserModal");
            map.set("viewName", viewName);
            map.set("initData", initData);

            $.openCommonUtils(callBack, map, 'fileBrowser');
        };

        var openFile = function () {
            var CallBack = 'FileCallBack';
            if (Object.keys(imsiFile).length > 0) {
                var data = {
                    "P_BOARD_TYPE": '${BOARD_TYPE}', // [ 모듈_메뉴명_해당ID값
                    "P_SEQ": '${SEQ}',
                    "imsiFile": imsiFile
                }
            } else {
                var data = {
                    "P_BOARD_TYPE": '${BOARD_TYPE}', // [ 모듈_메뉴명_해당ID값
                    "P_SEQ": '${SEQ}'
                }
            }

            parent.openFileModal(CallBack, this.name, data);
        }
    }
</script>
