<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>
<%@ page import="java.text.SimpleDateFormat" %>
<ax:set key="title" value="파일 브라우저"/>
<ax:set key="page_desc" value="${PAGE_REMARK}"/>
<ax:set key="page_auto_height" value="true"/>

<ax:layout name="base">
	<jsp:attribute name="script">
	<link rel="stylesheet" href="/assets/css/cropper.css">
	<script type="text/javascript" src='/assets/js/crop/cropper.js'></script>
     <script>
         var wwd = 1500;  //제한할이미지가로사이즈
         var hhd = 1500;  //제한할이미지세로사이즈
         var param = ax5.util.param(ax5.info.urlUtil().param);
         var cropper, orgnFile, cropFile;
         var returnValue = new Object();
         var initData = (param.modalName) ? eval("parent." + param.modalName + ".modalConfig.sendData") :
             (typeof parent.modal.modalConfig.sendData == 'function') ? parent.modal.modalConfig.sendData().initData : parent.modal.modalConfig.sendData.initData;


         var fnObj = {}, CODE = {};
         var ACTIONS = axboot.actionExtend(fnObj, {
             CALL_BACK: function(){
                 var FILE_PATH = axboot.getfileRoot() + "\\" + initData.CALL_BACK.FILE_PATH + "\\" + initData.CALL_BACK.FILE_NAME;
                 var ORGN_FILE_PATH = axboot.getfileRoot() + "\\" + initData.CALL_BACK.FILE_PATH + "\\original\\" + initData.CALL_BACK.FILE_NAME;
                 qray.loading.show("조회 중입니다");
                 axboot.call({
                     type: "POST",
                     url: ["commonfile", "FileRead"],
                     async: false,
                     data: JSON.stringify({
                         file: {
                             FILE_NAME: initData.CALL_BACK.FILE_NAME,
                             FILE_PATH: initData.CALL_BACK.FILE_PATH,
                             FILE_EXT: initData.CALL_BACK.FILE_EXT
                         }
                     }),
                     callback: function (e) {

                     }
                 }).done(function () {
                     axboot.ajax({
                         type: "POST",
                         url: ["commonfile", "FileRead"],
                         async: false,
                         data: JSON.stringify({
                             file: {
                                 FILE_NAME: "original/" + initData.CALL_BACK.FILE_NAME,
                                 FILE_PATH: initData.CALL_BACK.FILE_PATH,
                                 FILE_EXT: initData.CALL_BACK.FILE_EXT
                             }
                         }),
                         callback: function (e) {
                             qray.loading.hide();
                             $("#ORGN_FILE_NAME").val(initData.CALL_BACK.ORGN_FILE_NAME);
                             $("#FILE_EXT").val(initData.CALL_BACK.FILE_EXT);
                             $("#FILE_BYTE").val(initData.CALL_BACK.FILE_BYTE);
                             $("#FILE_SIZE").val(initData.CALL_BACK.FILE_SIZE);

                             $(".preview").append('<img src="' + ORGN_FILE_PATH + '" class="img-responsive"/>');
                             $(".img-preview").append('<img src="' + FILE_PATH + '" id="canvas_crop"/>');
                             changesize();
                         }
                     })

                 });
             },
             PAGE_SEARCH: function () {
                 axboot.ajax({
                     type: "POST",
                     url: ["commonfile", "getFileData"],
                     async: false,
                     data: JSON.stringify({
                         CG_CD: initData.CG_CD,
                         TB_KEY: initData.TB_KEY,
                         TB_ID: initData.TB_ID
                     }),
                     callback: function (res) {
                         if (nvl(res.list) != '') {
                             if (res.list.length > 0) {

                                 var data;
                                 for (var i = 0 ; i < res.list.length; i ++){
                                     if (!data) {
                                         data = res.list[i];
                                     };

                                     // data의 값과 현재 값을 비교해서 data값을 가장 큰 값으로 유지
                                     if (data.FILE_SEQ < res.list[i].FILE_SEQ) {
                                         data = res.list[i];
                                     }
                                 }

                                 $(".img-responsive").remove();
                                 $("#canvas_crop").remove();
                                 var FILE_PATH = axboot.getfileRoot() + "\\" + data.FILE_PATH + "\\" + data.FILE_NM;
                                 var ORGN_FILE_PATH = axboot.getfileRoot() + "\\" + data.FILE_PATH + "\\original\\" + data.FILE_NM;

                                 qray.loading.show("조회 중입니다");
                                 axboot.call({
                                     type: "POST",
                                     url: ["commonfile", "FileRead"],
                                     async: false,
                                     data: JSON.stringify({
                                         file: {
                                             FILE_NAME: data.FILE_NM,
                                             FILE_PATH: data.FILE_PATH,
                                             FILE_EXT: data.FILE_EXT
                                         }
                                     }),
                                     callback: function (e) {

                                     }
                                 }).done(function () {
                                     axboot.ajax({
                                         type: "POST",
                                         url: ["commonfile", "FileRead"],
                                         async: false,
                                         data: JSON.stringify({
                                             file: {
                                                 FILE_NAME: "original/" + data.FILE_NM,
                                                 FILE_PATH: data.FILE_PATH,
                                                 FILE_EXT: data.FILE_EXT
                                             }
                                         }),
                                         callback: function (e) {
                                             qray.loading.hide();

                                             $("#ORGN_FILE_NAME").val(data.ORGN_FILE_NM);
                                             $("#FILE_EXT").val(data.FILE_EXT);
                                             $("#FILE_BYTE").val(data.FILE_BYTE);
                                             $("#FILE_SIZE").val(data.FILE_SIZE);
                                             $(".preview").append('<img src="' + ORGN_FILE_PATH + '" class="img-responsive"/>');
                                             $(".img-preview").append('<img src="' + FILE_PATH + '" id="canvas_crop"/>');
                                             changesize();
                                         }
                                     })

                                 });

                             }
                         }
                     }
                 });
             },
             PAGE_SAVE: function () {
                 if (nvl(cropFile) == '' || nvl(orgnFile) == ''){
                     qray.alert('변경된 데이터가 없습니다.');
                     return false;
                 }

                 returnValue.FILE_PATH = initData.FILE_PATH;

                 console.log("orgnFile : ", orgnFile);
                 console.log("cropFile : ", cropFile);
                 console.log("returnValue : ", returnValue);

                 var formData = new FormData();
                 formData.append('orgnFile', orgnFile);
                 formData.append('cropFile', cropFile);
                 formData.append("fileName", new Blob([JSON.stringify(returnValue)], {type: "application/json"}));

                 $.ajax({
                     type: 'POST',
                     async: false,
                     enctype: 'multipart/form-data',
                     processData: false,
                     contentType: false,
                     cache: false,
                     timeout: 600000,
                     url: '/api/file/cropUpload',
                     data: formData,
                     success: function (result) {

                         if (param.viewName) {
                             parent.document.getElementsByName(param.viewName)[0].contentWindow[param.callBack](returnValue);
                             return;
                         }
                         parent[param.callBack](returnValue);
                         parent.modal.close();
                     }
                 });
             },
             FILE_LOAD: function () {
                 if ($("#inputImage")[0].files.length == 0) {
                     qray.alert('파일을 선택해주십시오.');
                     return false;
                 }
                 orgnFile = $("#inputImage")[0].files[0];
                 cropFile = $("#inputImage")[0].files[0];

                 var file_ext = validation(orgnFile.name);
                 var uuid_file_name = guid();
                 // 확장자 지정해주고 싶을 때
                 if (!((file_ext === 'jpg') || (file_ext === 'gif') || (file_ext === 'png'))) {
                     qray.alert('jpg, gif, png 확장자만 업로드 가능합니다.');
                     return true;
                 }

                 if (fnInputSpecialCharacterExcept(orgnFile.name)) {
                     qray.alert('파일명에 허용된 특수문자는<br> \'-\', \'_\', \'(\', \')\', \'[\', \']\', \'.\' 입니다.');
                     return false;
                 }

                 var reader = new FileReader();
                 reader.onload = function (img) {

                     document.uploadForm.sizeCheck.src = img.target.result;
                     var ImageWidth= 0, ImageHeight = 0
                     setTimeout(function(){
                         if (nvl(initData.SIZE_LIMIT) != ''){
                             ImageWidth = document.uploadForm.sizeCheck.width;
                             ImageHeight = document.uploadForm.sizeCheck.height;

                             if(ImageWidth != wwd){
                                 qray.alert('첨부한 이미지의 가로사이즈는 '+ ImageWidth +'px 입니다.<br>이미지의 해상도를 1500x1500 으로 맞춰주세요.');
                                 orgnFile = null;
                                 return false;
                             }

                             //이미지세로사이즈가지정한사이즈보다클때메세지와함께폼전송을중지합니다.
                             if(ImageHeight != hhd) {
                                 qray.alert('첨부한 이미지의 세로사이즈는 '+ ImageHeight +'px 입니다.<br>이미지의 해상도를 1500x1500 으로 맞춰주세요.');
                                 orgnFile = null;
                                 return false;
                             }
                         }
                         if ($(".img-responsive").length > 0) {
                             qray.confirm({
                                 msg: "이미 업로드된 이미지가 존재합니다.<br>변경하시겠습니까?"
                             }, function () {
                                 if (this.key == "ok") {
                                     $(".img-responsive").remove();
                                     $("#canvas_crop").remove();
                                     returnValue.FILE_NAME = uuid_file_name;
                                     returnValue.ORGN_FILE_NAME = orgnFile.name;
                                     returnValue.FILE_EXT = file_ext;
                                     returnValue.FILE_SIZE = orgnFile.size;
                                     returnValue.FILE_PATH = img.target.result;
                                     returnValue.FILE_BYTE = ax5.util.number(orgnFile.size, {"byte": true});
                                     $("#ORGN_FILE_NAME").val(returnValue.ORGN_FILE_NAME);
                                     $("#FILE_EXT").val(returnValue.FILE_EXT);
                                     $("#FILE_BYTE").val(returnValue.FILE_BYTE);
                                     $("#FILE_SIZE").val(returnValue.FILE_SIZE);

                                     $(".preview").append('<img src="' + returnValue.FILE_PATH + '" class="img-responsive"/>');
                                     $(".img-preview").append('<img id="canvas_crop" src="' + returnValue.FILE_PATH + '"></img>');
                                     $("#inputImage").val('');
                                     changesize();
                                 }
                             });
                         }else{
                             $("#canvas_crop").remove();
                             returnValue.FILE_NAME = uuid_file_name;
                             returnValue.ORGN_FILE_NAME = orgnFile.name;
                             returnValue.FILE_EXT = file_ext;
                             returnValue.FILE_SIZE = orgnFile.size;
                             returnValue.FILE_PATH = img.target.result;
                             returnValue.FILE_BYTE = ax5.util.number(orgnFile.size, {"byte": true});
                             $("#ORGN_FILE_NAME").val(returnValue.ORGN_FILE_NAME);
                             $("#FILE_EXT").val(returnValue.FILE_EXT);
                             $("#FILE_BYTE").val(returnValue.FILE_BYTE);
                             $("#FILE_SIZE").val(returnValue.FILE_SIZE);

                             $(".preview").append('<img src="' + returnValue.FILE_PATH + '" class="img-responsive"/>');
                             $(".img-preview").append('<img id="canvas_crop" src="' + returnValue.FILE_PATH + '"></img>');
                             $("#inputImage").val('');
                             changesize();
                         }
                     }, 300);
                 };
                 reader.readAsDataURL(orgnFile);
             },
             CROP_SHOW: function () {	//	자르기시작 (사각형 박스를 그려준다.)
                 $("#fileRegister").css('display', 'none');
                 $("#fileCropper").css('display', 'block');

                 var Cropper = window.Cropper;
                 var URL = window.URL || window.webkitURL;
                 var container = document.querySelector('.img-container');
                 var image = container.getElementsByTagName('img').item(0);

                 var options = {
                     aspectRatio: 1,
                     preview: '.spreview',
                     ready: function (e) {
                         console.log(e.type);
                     },
                     cropstart: function (e) {
                         console.log(e.type, e.detail.action);
                     },
                     cropmove: function (e) {

                     },
                     cropend: function (e) {
                         console.log(e.type, e.detail.action);
                     },
                     crop: function (e) {
                         var data = e.detail;

                         console.log(e.type);

                     },
                     zoom: function (e) {
                         console.log(e.type, e.detail.ratio);
                     }
                 };
                 cropper = new Cropper(image, options);
                 var originalImageURL = image.src;
                 var uploadedImageType = 'image/jpeg';
                 var uploadedImageURL;

                 document.body.onkeydown = function (event) {
                     var e = event || window.event;

                     if (!cropper || this.scrollTop > 300) {
                         return;
                     }

                     switch (e.keyCode) {
                         case 37:
                             e.preventDefault();
                             cropper.move(-1, 0);
                             break;

                         case 38:
                             e.preventDefault();
                             cropper.move(0, -1);
                             break;

                         case 39:
                             e.preventDefault();
                             cropper.move(1, 0);
                             break;

                         case 40:
                             e.preventDefault();
                             cropper.move(0, 1);
                             break;
                     }

                 };

             },

         });


         fnObj.pageButtonView = axboot.viewExtend({
             initView: function () {
                 axboot.buttonClick(this, "data-page-btn", {
                     "close": function () {
                         parent.modal.close();
                     },
                     "save": function () {
                         ACTIONS.dispatch(ACTIONS.PAGE_SAVE);
                     },
                     "crop": function () {
                         ACTIONS.dispatch(ACTIONS.CROP_SHOW);
                     },
                     "upload": function () {
                         ACTIONS.dispatch(ACTIONS.FILE_LOAD);
                     },
                     "cropClear": function () {
                         cropper.reset();
                     },
                     "rotation": function () {
                         cropper.rotate(45);
                     },
                     "reverse": function () {
                         if (cropper.imageData.scaleX == 1) {
                             cropper.scaleX(-1);
                         } else {
                             cropper.scaleX(1);
                         }

                     },
                     "cropOk": function () {
                         if ($("#canvas_crop").length > 0) {
                             qray.confirm({
                                 msg: "이미 편집된 이미지가 존재합니다.<br>변경하시겠습니까?"
                             }, function () {
                                 if (this.key == "ok") {

                                     $("#canvas_crop").remove();

                                     var cropGetData = cropper.getCropBoxData();
                                     var cropDataUrl = cropper.getCroppedCanvas().toDataURL('image/png')

                                     console.log(cropGetData);

                                     $(".img-preview").append("<canvas id='canvas_crop' width=" + cropGetData.width + " height=" + cropGetData.height + "></canvas>");

                                     var cropImg = new Image();
                                     cropImg.onload = function () {
                                         var cropCanvas = document.getElementById("canvas_crop");
                                         var ctx = cropCanvas.getContext("2d");
                                         ctx.drawImage(cropImg, 0, 0, cropGetData.width, cropGetData.height);
                                     };

                                     cropImg.src = cropDataUrl;

                                     var blobBin = atob(cropDataUrl.split(',')[1]);
                                     var array = [];
                                     for (var i = 0; i < blobBin.length; i++) {
                                         array.push(blobBin.charCodeAt(i));
                                     }
                                     cropFile = new Blob([new Uint8Array(array)], {type: 'image/png'});	// Blob 생성

                                     cropper.destroy();
                                     $("#fileRegister").css('display', 'block');
                                     $("#fileCropper").css('display', 'none');
                                 }
                             });
                         } else {
                             var cropGetData = cropper.getCropBoxData();
                             var cropDataUrl = cropper.getCroppedCanvas().toDataURL('image/png')

                             console.log(cropGetData);

                             $(".img-preview").append("<canvas id='canvas_crop' width=" + cropGetData.width + " height=" + cropGetData.height + "></canvas>");


                             var cropImg = new Image();
                             cropImg.onload = function () {
                                 var cropCanvas = document.getElementById("canvas_crop");
                                 var ctx = cropCanvas.getContext("2d");
                                 ctx.drawImage(cropImg, 0, 0, cropGetData.width, cropGetData.height);
                             };


                             cropImg.src = cropDataUrl;

                             var blobBin = atob(cropDataUrl.split(',')[1]);
                             var array = [];
                             for (var i = 0; i < blobBin.length; i++) {
                                 array.push(blobBin.charCodeAt(i));
                             }
                             cropFile = new Blob([new Uint8Array(array)], {type: 'image/png'});	// Blob 생성

                             cropper.destroy();
                             $("#fileRegister").css('display', 'block');
                             $("#fileCropper").css('display', 'none');
                         }
                         $("#canvas_crop").css('border', '1px solid rgb(216, 216, 216');
                         changesize();

                     },
                     "cropCancel": function () {
                         cropper.destroy();
                         $("#fileRegister").css('display', 'block');
                         $("#fileCropper").css('display', 'none');
                         changesize();

                     },


                 });
             }
         });


         fnObj.pageStart = function () {
             this.pageButtonView.initView();
             if (nvl(initData.SIZE_LIMIT) == ''){

             }
             if (nvl(initData.CALL_BACK) == ''){
                 ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
             }else{
                 ACTIONS.dispatch(ACTIONS.CALL_BACK);
             }
         };

         /*          $(document).ready(function(){

                     $("#resizePanel").attrchange({
                         trackValues: true,
                         callback: function (event) {
                             var div = $("#canvas_div").parents('[data-split-panel-wrap]');
                             var canvas_div_height = div[0].offsetHeight - $("#fileRegister").height() - 10;

                             $("#canvas_div").css('height', canvas_div_height);

                             var max_Height = $("#canvas_div").height();
                             var max_Width = $("#canvas_div").width();

                             $("#canvas").css('max-height', max_Height);
                             $("#canvas").css('max-width', max_Width);
                         }
                     });
                  }) */

         function validation(fileName) {
             fileName = fileName + "";
             var fileNameExtensionIndex = fileName.lastIndexOf('.') + 1;
             var fileNameExtension = fileName.toLowerCase().substring(
                 fileNameExtensionIndex, fileName.length);

             return fileNameExtension;
         }

         function guid() {
             function s4() {
                 return Math.floor((1 + Math.random()) * 0x10000).toString(16).substring(1);
             }

             return s4() + s4() + '-' + s4() + '-' + s4() + '-' +
                 s4() + '-' + s4() + s4() + s4();
         }

         function fnInputSpecialCharacterExcept(obj) {
             var special_pattern = /[`~!@#$%^&*|\\\'\";:\/?]/gi;
             if (special_pattern.test(obj) == true) {
                 return true;
             }
             return false;
         }

         $(document).ready(function(){
             changesize();
         })
         $(window).resize(function () {
             changesize();
         });

         var _pop_height = 0, _pop_top = 0;
         function changesize() {
             //전체영역높이
             var totheight = $("#ax-base-root").height();
             if (totheight > 700) {
                 _pop_height = 600;
                 _pop_top = parseInt((totheight - _pop_height) / 2);
             } else {
                 _pop_height = totheight / 10 * 8;
                 _pop_top = parseInt((totheight - _pop_height) / 2);
             }

             //데이터가 들어갈 실제높이
             var datarealheight = $("#ax-base-root").height() - $(".ax-base-title").height() - $("#fileRegister").height() - 20;
             var apprealheight = $("#split-panel-form").height() - $("#fileViewer").height() - $("#appImg").height() - $(".ax-form-tbl").height();
             $(".CanvasContainer").css("height", (datarealheight / 100 * 99));
             $(".col-md-9").css("height", (datarealheight / 100 * 99));
             $(".img-container").css("height", (datarealheight / 100 * 99));
             $(".preview").css("height", (datarealheight / 100 * 99));
             $(".img-responsive").css("height", (datarealheight / 100 * 99));
             $("#canvas_crop").css('height', (apprealheight / 100 * 99));
             $("#canvas_crop").css('max-height', 380);



         }
     </script>
     <style>
         /* #canvas {
             max-width: 750px; max-height: 600px;
         } */
         .preview {
             height: 750px;
             width: 600px;
         }

         .img-preview {
             height: 9rem;
             width: 16rem;
         }

         #canvas_crop {
             border: 1px solid rgb(216, 216, 216);
             width: 380px;
             height: 380px;
         }

     </style>
    </jsp:attribute>
    <jsp:body>
        <div data-page-buttons="">
            <div class="button-warp">
                <span style="margin-right: 25px">* 파일의 해상도를 1500 x 1500 맞춰주십시오.</span>
                <button type="button" class="btn btn-reload"
                        data-page-btn="reload" onclick="window.location.reload();">
                    <i class="icon_reload"></i>
                </button>
                <button type="button" class="btn btn-info"
                        data-page-btn="save" id="save">
                    <i class="icon_save"></i>임시저장
                </button>
                <button type="button" class="btn btn-info"
                        data-page-btn="crop" id="crop">
                    <i class="icon_del"></i>자르기
                </button>
                <button type="button" class="btn btn-info"
                        data-page-btn="close">닫기
                </button>

            </div>
        </div>

        <ax:split-layout name="ax1" orientation="vertical">
            <ax:split-panel width="*" id="resizePanel" style="padding-right: 10px;">
                <div class="CanvasContainer" style="border: 1px solid #D8D8D8;">
                    <div class="row">
                        <div class="col-md-9">
                            <!-- <h3>Demo:</h3> -->
                            <div class="img-container">
                                <div class="preview"></div>
                            </div>
                        </div>
                    </div>
                </div>
                <form name="uploadForm" method="POST" enctype="multipart/form-data">
                <div id="fileRegister">
                    <div class="H10"></div>
                        <input type="hidden" name="targetId" value="${targetId}"/>
                        <input type="hidden" name="targetType" value="CKEDITOR"/>
                        <ax:tbl clazz="ax-search-tbl" minWidth="500px">
                            <ax:tr>
                                <ax:td label='파일업로드' width="100%" labelStyle="background: #616161;color: #fff;">
                                    <div style="">
                                        <div class="input-group">
                                            <input type="file" id="inputImage" class="form-control"/>
                                            <span class="input-group-btn">
                                              <button type='button' name="Upload" data-page-btn="upload"
                                                      class="btn btn-primary">
                                                  <i class="cqc-upload"></i> 업로드</button>
                                          </span>
                                        </div>
                                    </div>
                                </ax:td>

                            </ax:tr>
                        </ax:tbl>

                </div>

                <div id="fileCropper" style="display: none;">
                    <div class="H10"></div>
                    <div class="button-warp">
                        <button type="button" class="btn btn-small" data-page-btn="cropClear" id="cropClear">초기화
                        </button>
                        <button type="button" class="btn btn-small" data-page-btn="rotation" id="rotation">회전</button>
                        <button type="button" class="btn btn-small" data-page-btn="reverse" id="reverse">좌우반전</button>
                        <button type="button" class="btn btn-small" data-page-btn="cropOk" id="cropOk"><i
                                class="icon_ok"></i>확인
                        </button>
                        <button type="button" class="btn btn-small" data-page-btn="cropCancel">취소</button>
                    </div>
                </div>

                <img border="0" name="sizeCheck" src='' style="visibility:hidden;">
                </form>
            </ax:split-panel>
            <ax:splitter></ax:splitter>
            <ax:split-panel width="400" style="padding-left: 10px;"
                            id="split-panel-form" scroll="true">

                <ax:form name="formView01">
                    <div data-fit-height-aside="form-view-01">
                        <div class="ax-button-group" id="fileViewer">
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
                                    <input type="text"
                                           data-ax-path="ORGN_FILE_NAME" id="ORGN_FILE_NAME"
                                           class="form-control" readonly value=""/>
                                </ax:td>
                            </ax:tr>
                            <ax:tr labelWidth="80px">
                                <ax:td label="파일확장자" width="100%">
                                    <input type="text"
                                           data-ax-path="FILE_EXT" id="FILE_EXT" class="form-control"
                                           readonly value=""/>
                                </ax:td>
                            </ax:tr>
                            <ax:tr labelWidth="80px">
                                <ax:td label="파일바이트" width="100%">
                                    <input type="text"
                                           data-ax-path="FILE_BYTE" id="FILE_BYTE" class="form-control"
                                           readonly value=""/>
                                </ax:td>
                            </ax:tr>
                            <ax:tr labelWidth="80px">
                                <ax:td label="파일사이즈" width="100%">
                                    <input type="text"
                                           data-ax-path="FILE_SIZE" id="FILE_SIZE" class="form-control"
                                           readonly value=""/>
                                </ax:td>
                            </ax:tr>
                        </ax:tbl>
                        <div class="ax-button-group" id="appImg">
                            <div class="left">
                                <h2>
                                    <i class="icon_list"></i>
                                    앱이미지
                                </h2>
                            </div>
                            <div class="right">

                            </div>
                        </div>
                        <div class="img-preview"></div>
                    </div>
                </ax:form>

            </ax:split-panel>
        </ax:split-layout>
    </jsp:body>
</ax:layout>