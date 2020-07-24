<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>
<%@ page import="java.text.SimpleDateFormat" %>
<ax:set key="title" value="파일 브라우저"/>
<ax:set key="page_desc" value="${PAGE_REMARK}"/>
<ax:set key="page_auto_height" value="true"/>


<ax:layout name="base">
    <jsp:attribute name="script">

     <script type="text/javascript" src='/assets/js/common/fileBrowser.js'></script>
    </jsp:attribute>
    <jsp:attribute name="header">
        <h1 class="title">
            <i class="cqc-browser"></i>
            파일 브라우저
        </h1>
    </jsp:attribute>
    <jsp:body>
        <div data-page-buttons="">
            <div class="button-warp">
                <span style="margin-right: 25px">* 파일이 제대로 안 보일 경우 새로고침 눌러주십시오.</span>
                <button type="button" class="btn btn-reload" data-page-btn="reload" onclick="window.location.reload();">
                    <i class="icon_reload"></i></button>
                <button type="button" class="btn btn-info" data-page-btn="save" id="save"><i class="icon_save"></i>임시저장
                </button>
                <button type="button" class="btn btn-info" data-page-btn="delete" id="delete"><i class="icon_del"></i>삭제
                </button>
                <button type="button" class="btn btn-info" data-page-btn="close">닫기
                </button>

            </div>
        </div>

        <ax:split-layout name="ax1" orientation="vertical">
            <ax:split-panel width="*" style="padding-right: 10px;">

                <div data-ax5grid="grid-view-01" data-fit-height-content="grid-view-01" style="height: 300px;"></div>

                <div data-fit-height-aside="grid-view-01">
                    <div class="H10"></div>
                    <form name="uploadForm" method="POST" enctype="multipart/form-data">
                        <input type="hidden" name="targetId" value="${targetId}"/>
                        <input type="hidden" name="targetType" value="CKEDITOR"/>

                        <ax:tbl clazz="ax-search-tbl" minWidth="500px">
                            <ax:tr>
                                <ax:td label='파일업로드' width="100%" labelStyle="background: #616161;color: #fff;">
                                    <div class="input-group">
                                        <input type="file" id="files" name="upload" class="form-control"/>
                                        <span class="input-group-btn">
                                            <button type='button' name="Upload" class="btn btn-primary"
                                                    onclick="openPopup(document.getElementById('files'))"><i
                                                    class="cqc-upload"></i> 업로드</button>
                                        </span>
                                    </div>
                                    <!-- /input-group -->
                                </ax:td>
                            </ax:tr>
                        </ax:tbl>
                    </form>
                </div>

            </ax:split-panel>
            <ax:splitter></ax:splitter>
            <ax:split-panel width="400" style="padding-left: 10px;" id="split-panel-form" scroll="true">

                <ax:form name="formView01">
                    <div data-fit-height-aside="form-view-01">
                        <div class="ax-button-group">
                            <div class="left">
                                <h2>
                                    <i class="cqc-blackboard"></i>
                                    파일 뷰어 </h2>
                            </div>
                            <div class="right">

                            </div>
                        </div>

                        <ax:tbl clazz="ax-form-tbl">
                            <ax:tr labelWidth="80px">
                                <ax:td label="파일명" width="100%">
                                    <input type="text" data-ax-path="ORGN_FILE_NAME" id="ORGN_FILE_NAME"
                                           class="form-control"
                                           readonly value=""/>
                                </ax:td>
                            </ax:tr>
                            <ax:tr labelWidth="80px">
                                <ax:td label="파일확장자" width="100%">
                                    <input type="text" data-ax-path="FILE_EXT" id="FILE_EXT" class="form-control"
                                           readonly value=""/>
                                </ax:td>
                            </ax:tr>
                            <ax:tr labelWidth="80px">
                                <ax:td label="파일바이트" width="100%">
                                    <input type="text" data-ax-path="FILE_BYTE" id="FILE_BYTE" class="form-control"
                                           readonly value=""/>
                                </ax:td>
                            </ax:tr>
                            <ax:tr labelWidth="80px">
                                <ax:td label="파일사이즈" width="100%">
                                    <input type="text" data-ax-path="FILE_SIZE" id="FILE_SIZE" class="form-control"
                                           readonly value=""/>
                                </ax:td>
                            </ax:tr>
                        </ax:tbl>

                    </div>
                    <div class="H10"></div>
                    <div id="preview" class="content">

                    </div>
                    <%-- <div id="preview-target"></div>--%>
                </ax:form>

            </ax:split-panel>
        </ax:split-layout>

    </jsp:body>
</ax:layout>