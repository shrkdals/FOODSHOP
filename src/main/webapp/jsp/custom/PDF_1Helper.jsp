<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>

<ax:set key="title" value="거래명세서"/>
<ax:set key="page_desc" value="${PAGE_REMARK}"/>
<ax:set key="page_auto_height" value="true"/>
<ax:layout name="modal">
    <jsp:attribute name="script">
        <link href="/assets/css/PDF_1.css?ver3" rel="stylesheet" type="text/css"/>
        <script type="text/javascript">
            console.log(parent.modal.modalConfig.sendData().initData)
            var listLen = 0
            var html2canvasHeight = 0;
            var html2canvasWidth = 0;
            var doc;

            var REMARK_SAVE_OBJ = {}
            var ACTIONS = axboot.actionExtend(fnObj, {
                PAGE_SEARCH: function (caller, act, data) {

                    var param = parent.modal.modalConfig.sendData().initData
                    var today = new Date();
                    var dtNow = ax5.util.date(today, {"return": "yyyy-MM-dd"});

                    var list = $.DATA_SEARCH("order", "pdf",{TYPE:'01' , COMPANY_CD : SCRIPT_SESSION.cdCompany , ORDER_CD : param.ORDER_CD , TEMP1 : SCRIPT_SESSION.idUser }).list
                    listLen = list.length
                    var  ORDER_CD = ''
                        ,ORDER_DT = ''
                        ,DELI_REQ = ''
                        ,PT_NM  = '' ,BIZ_NO  = '' ,OWNER_NM  = '' ,TEL_NO  = '' ,FAX_NO  = '' ,ADDR  = '', PT_TYPE = '', PT_COND = ''        // 공급자 필드
                        ,PT_NM2 = '' ,BIZ_NO2 = '' ,OWNER_NM2 = '' ,TEL_NO2 = '' ,FAX_NO2 = '' ,ADDR2 = '', SIGN_NM2 = '', PT_TYPE2 = '', PT_COND2 = ''  // 공급받는자 필드
                        ,ORDER_ITEM = ''
                        ,REMARK = ''
                        ,SUM_SELECT_NUM = 0
                        ,SUM_SALE_COST = 0
                        ,SUM_ORDER_AMT = 0
                        ,SUM_ORDER_VAT = 0
                        ,SUM_OREDER_SPPLUY = 0
                    if(list.length > 0){
                          PT_NM  = nvl(list[0].PT_NM)   , BIZ_NO  = nvl(list[0].BIZ_NO)   , OWNER_NM  = nvl(list[0].OWNER_NM)
                        , TEL_NO  = nvl(list[0].TEL_NO) , FAX_NO  = nvl(list[0].FAX_NO)   , ADDR      = nvl(list[0].ADDR), PT_TYPE = nvl(list[0].PT_TYPE), PT_COND = nvl(list[0].PT_COND)

                        , PT_NM2   = nvl(list[0].PT_NM2)  , BIZ_NO2  = nvl(list[0].BIZ_NO2) , OWNER_NM2  = nvl(list[0].OWNER_NM2), SIGN_NM2 = nvl(list[0].SIGN_NM2)
                        , TEL_NO2  = nvl(list[0].TEL_NO2) , FAX_NO2  = nvl(list[0].FAX_NO2) , ADDR2      = nvl(list[0].ADDR2) , PT_TYPE2 = nvl(list[0].PT_TYPE2), PT_COND2 = nvl(list[0].PT_COND2)
                        , REMARK = nvl(list[0].REMARK)
                        , ORDER_CD = nvl(list[0].ORDER_CD)
                        , DELI_REQ = nvl(list[0].DELI_REQ)
                    }else{
                        $('#TBODY1').append('<span> 상품리스트가 존재하지 않습니다. </span>')
                        return;
                    }
                    REMARK_SAVE_OBJ.ORDER_CD = list[0].ORDER_CD
                    REMARK_SAVE_OBJ.JOIN_PT_CD = list[0].JOIN_PT_CD
                    REMARK_SAVE_OBJ.REMARK = list[0].REMARK

                    var HeaderHtml = ''
                    HeaderHtml += '<table cellpadding="0" cellspacing="0" width="650px" summary="거래명세서 내역" style="width : 100%;">'
                        + '<caption class="hidden">거래명세서 내역</caption>'
                        + '<tbody>'
                        +'<tr>'
                        +'<td>'
                        +'<table width="100%" border="0" cellspacing="1" cellpadding="0" class="popup_print_tbl2" summary="거래명세서 상세내역 인쇄하기">'
                        +'<caption class="hidden">거래명세서 상세내역</caption>'
                        +'<tbody>'
                        +'<tr>'
                        +'<td colspan="12">'
                        +'<div style="margin:7px 10px 7px 30px;"><span style="font-size:18px;font-weight:bold;">거래명세서</span>'
                        +'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'
                        +'<span id="T1"> 발행일 :'+ dtNow +'&nbsp;&nbsp;</span>'
                        +'<span id="T2"> 주문번호 : ' + ORDER_CD + '&nbsp;&nbsp;</span>'
                        +'<span style="font-size:13px;color:#FF0000;font-weight:bold;">(보관용)</span></div>'
                        +'</td>'
                        +'</tr>'
                        +'<tr>'
                        +'<th rowspan="4" width="20px">공<br>급<br>자<br></th>'
                        +'<td width="40px" style="text-align:center;">사업자<br>번호</td>'
                        +'<td colspan="3" width="265px">'
                        +'<span id="T3" style="font-weight:bold;" > ' + $.changeDataFormat(BIZ_NO,'company') + ' </span>'
                        +'<span id="T4">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;☎ ' + TEL_NO + '</span>'
                        +'</td>'
                        +'<th rowspan="4" width="20px">공<br>급<br>받<br>는<br>자</th>'
                        +'<td width="40px" style="text-align:center;">사업자<br>번호</td>'
                        +'<td colspan="5" width="265px">'
                        +'<span id="T3" style="font-weight:bold;" > ' + $.changeDataFormat(BIZ_NO2,'company') + ' </span>'
                        +'<span id="T4">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;☎ ' + TEL_NO2 + '</span>'
                        +'</td>'
                        +'</tr>'
                        +'<tr>'
                        +'<td style="text-align:center;">상호</td>'
                        +'<td width="100px" style="font-weight:bold;" id="T7"><input type="text" style="width:100%; border:none" value= "' + PT_NM + '"/></td>'
                        +'<td width="40px" style="text-align:center;" id="T8">대표</td>'
                        +'<td><input type="text" style="width:100%; border:none" value= "' + OWNER_NM + '"/></td>'
                        +'<td style="text-align:center;">상호</td>'
                        +'<td width="100px" style="font-weight:bold;" id="T7"><input type="text" style="width:100%; border:none" value= "' + PT_NM2 + '"/></td>'
                        +'<td width="60px" style="text-align:center;">간판명</td>'
                        +'<td width="150px"><input type="text" style="width:100%; border:none" value= "' + SIGN_NM2 + '"/></td>'
                        +'<td width="40px" style="text-align:center;" id="T8">대표</td>'
                        +'<td><input type="text" style="width:100%; border:none" value= "' + OWNER_NM2 + '"/></td>'
                        +'</tr>'
                        +'<tr>'
                        +'<td style="text-align:center;">주소</td>'
                        +'<td colspan="3" id="T11"> <input type="text" style="width:100%; border:none" value= "' + ADDR + '"/>  </td>'
                        +'<td style="text-align:center;">주소</td>'
                        +'<td colspan="5" id="T12"><input type="text" style="width:100%; border:none" value= "' + ADDR2 + '"/></td>'
                        +'</tr>'
                        +'<tr>'
                        +'<td style="text-align:center;">종목</td>'
                        +'<td id="T13"> <input type="text" style="width:100%; border:none" value= "' + PT_TYPE + '"/> </td>'
                        +'<td width="40px" style="text-align:center;">업태</td>'
                        +'<td id="T14"> <input type="text" style="width:100%; border:none" value= "' + PT_COND + '"/> </td>'
                        +'<td style="text-align:center;">종목</td>'
                        +'<td id="T15" colspan="2"> <input type="text" style="width:100%; border:none" value= "' + PT_TYPE2 + '"/> </td>'
                        +'<td width="40px" style="text-align:center;">업태</td>'
                        +'<td id="T16" colspan="2"> <input type="text" style="width:100%; border:none" value= "' + PT_COND2 + '"/> </td>'
                        +'</tr>'
                        +'<tr>'
                        +'<th rowspan="4" width="20px">배<br>송<br>요<br>청<br></th>'
                        +'<td colspan="4"><textarea style="width: 100%;resize: none;overflow-y: hidden; padding-bottom: 0.2em;line-height: 1.6;height: 100%;border:0px;">'+ DELI_REQ +'</textarea></td>'
                       
                        +'<th rowspan="4" width="20px">비<br>고</th>'
                        +'<td colspan="6"><textarea id="REMARK" style="width: 100%;resize: none;overflow-y: hidden; padding-bottom: 0.2em;line-height: 1.6;height: 100%;border:0px; ">' + REMARK + '</textarea></td>'
                        + '</tr>'
                        +'</tbody>'
                        +'</table>'
                        +'</td>'
                        +'</tr>'
                        +'<tr>'
                        +'<td>'
                        +'<table width="100%" border="0" cellspacing="1" cellpadding="0" class="popup_print_tbl2" summary="거래명세서 상세내역">'
                        +'<caption class="hidden">거래명세서 상세내역</caption>'
                        +'<colgroup>'
                        +'<col width="10px">'
                        //+'<col width="80px">'
                        +'<col>'
                        +'<col width="60px">'
                        +'<col width="50px">'
                        +'<col width="50px">'
                        +'<col width="80px">'
                        +'<col width="50px">'
                        +'<col width="60px">'
                        +'<col width="70px">'
                        +'<col width="70px">'
                        +'</colgroup>'
                        +'<thead>'
                        +'<tr>'
                        +'<th style="width:10px;">No</th>'
                        //+'<th style="width:100px;">제조사</th>'
                        +'<th>품명</th>'
                        +'<th style="width:50px;">상품중량</th>'
                        +'<th style="width:50px;">박스수량</th>'
                        +'<th style="width:50px;">출고단위</th>'
                        +'<th style="width:50px;">출고수량</th>'
                        +'<th style="width:80px;">단가</th>'
                        +'<th style="width:80px;">금액</th>'
                        +'<th style="width:80px;">공급가액</th>'
                        +'<th style="width:80px;">세액</th>'
                        +'<th style="width:50px;">원산지</th>'
                        +'</tr>'
                        +'</thead>'
                        +'<tbody>';
                    var MiddleHtml = ''
                       list.forEach(function(item, index){
                           MiddleHtml +='<tr>'
                               +'<td style="text-align:center">' + (Number(index) + 1) + '</td>'
                               //+'<td>' + nvl(item.MAKE_PT_NM) + '</td>'
                               +'<td>' + nvl(item.ORDER_ITEM) + '</td>'
                               +'<td style="text-align:left">' + nvl(item.ITEM_WT) + '</td>'
                               +'<td style="text-align:right">' + nvl(item.BOX_NUM) + '</td>'
                               +'<td style="text-align:left">' + nvl(item.ITEM_UNIT) + '</td>'
                               +'<td style="text-align:right">' + nvl(item.SELECT_NUM) + '</td>'
                               +'<td style="text-align:right">' + comma(item.SALE_COST) + '</td>'
                               +'<td style="text-align:right">' + comma(item.ORDER_AMT) + '</td>'
                               +'<td style="text-align:right">' + comma(item.OREDER_SPPLUY) + '</td>'
                               +'<td style="text-align:right">' + comma(item.ORDER_VAT) + '</td>'
                               +'<td style="text-align:left">' + nvl(item.ORIGIN_NM) + '</td>'
                               +'</tr>'

                               ,SUM_SELECT_NUM += Number(item.SELECT_NUM)
                               ,SUM_SALE_COST += Number(item.SALE_COST)
                               ,SUM_ORDER_AMT += Number(item.ORDER_AMT)
                               ,SUM_ORDER_VAT += Number(item.ORDER_VAT)
                               ,SUM_OREDER_SPPLUY += Number(item.OREDER_SPPLUY)
                       })
                        
                    MiddleHtml
                        //+='<td style="text-align:center; background:#ffe0cf"  colspan="6" > 합계 </td>'
                        +='<td style="text-align:center; background:#ffe0cf"  colspan="5" > 합계 </td>'
                        +'<td style="text-align:right">' + comma(SUM_SELECT_NUM) + '</td>'
                        //+'<td style="text-align:right">' + comma(SUM_SALE_COST) + '</td>'
                        +'<td style="text-align:right"></td>'
                        +'<td style="text-align:right">' + comma(SUM_ORDER_AMT) + '</td>'
                        +'<td style="text-align:right">' + comma(SUM_OREDER_SPPLUY) + '</td>'
                        +'<td style="text-align:right">' + comma(SUM_ORDER_VAT) + '</td>'
                        +'<td style="text-align:right"></td>'
                        +'</tr>'
                        +'</tbody>'
                        +'</table>'
                        +'</td>'
                    /*
                    MiddleHtml +='</tbody>'
                        +'</table>'
                        +'</td>'
                        +'</tr>'
                        +'<tr>'
                        +'<td>'
                        +'<table width="100%" border="0" cellspacing="1" cellpadding="0" class="popup_print_tbl3" summary="거래명세서 상세내역 합계">'
                        +'<caption class="hidden">거래명세서 상세내역 합계</caption>'
                        +'<tbody>'
                        +'<tr>'
                        +'<td width="50px">주문액</td>'
                        +'<td width="100px" style="font-weight:bold">' + comma(SUM_SALE_COST) + '</td>'
                        +'<td width="60px">공급가액</td>'
                        +'<td width="70px">' + comma(SUM_SALE_COST) + '</td>'
                        +'<td width="50px">부가세</td>'
                        +'<td width="70px">' + comma(SUM_ORDER_VAT) + '</td>'
                        +'<td width="50px">담당자</td>'
                        +'<td width="70px" style="text-align:left"></td>'
                        +'<td width="50px">인수자</td>'
                        +'<td width="70px" style="text-align:left">&nbsp;</td>'
                        +'</tr>'
                        +'</tbody>'
                        +'</table>'
                        +'</td>'
                        +'</tr>'
                        +'</tbody>'
                        +'</table>'

                     */
                        $('#TBODY1').append(HeaderHtml+ "<div style='padding:2px;'></div>" + MiddleHtml)
                }
                , PDF_PRINT : function (caller, act, data) {
                	if (window.navigator.msSaveBlob) { // IE
                        doc.save(fileName);
                    } else { // Chrome
                        window.open(doc.output('bloburl'));
                    }
                }
                , SAVE : function (caller, act, data) {
                    REMARK_SAVE_OBJ.REMARK = $('#REMARK').val()
                    REMARK_SAVE_OBJ.LOGIN_ID = SCRIPT_SESSION.idUser
                    qray.confirm({
                        msg: "저장하시겠습니까?"
                    }, function () {
                        if (this.key == "ok") {
                            axboot.ajax({
                                type: "POST",
                                url: ["order", "REMARK_SAVE"],
                                data: JSON.stringify(REMARK_SAVE_OBJ),
                                callback: function (res) {
                                    qray.alert("비고 저장이 완료되었습니다.");
                                },
                                options: {
                                    onError : function(err){
                                        var temp = err.message.split('FOODSHOP');

                                        if(temp.length == 1){
                                            err.message = temp[0]
                                        }else{
                                            err.message = temp[1]
                                        }

                                        qray.alert(err.message)
                                    }
                                }
                            });
                        }
                    });

                }

            })
            // fnObj 기본 함수 스타트와 리사이즈
            fnObj.pageStart = function () {
            	$('.button-warp').css('display','none');
                this.pageButtonView.initView();
                ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                setTimeout(function () {
	                html2canvasHeight = $(".ax-base-title").height() + $("#TBODY1").height() + (5 * listLen);
	                html2canvasWidth = $(document).width();
	                doc = new jsPDF('l', 'mm', [297, 210]);
	                var myOffscreenEl = document.body;
	                
	                html2canvas(myOffscreenEl,{}).then(function(canvas) {
	                	var imgData = canvas.toDataURL('image/png');
	                	
	                	for (var i = 0 ; i < 2 ; i ++){
							if (i == 1){
								doc.addPage();
							}
		                    var imgWidth = 297;
		                    var pageHeight = imgWidth / 1.414;  // 출력 페이지 세로 길이 계산 A4 기준
		                    var imgHeight = canvas.height * imgWidth / canvas.width;
		                    var heightLeft = imgHeight;
		                    var position = 0;
		
		                    doc.addImage(imgData, 'PNG', 0, position, imgWidth, imgHeight);
		                    heightLeft -= pageHeight;
		
		                    while (heightLeft >= 0) {
		                        position = heightLeft - imgHeight;
		                        doc.addPage();
		                        doc.addImage(imgData, 'PNG', 0, position, imgWidth, imgHeight);
		                        heightLeft -= pageHeight;
		                    }
		               	}
	                    $('.button-warp').css('display','')
	                })
                }, 1000);
            };
            fnObj.pageResize = function () {

            };

            fnObj.pageButtonView = axboot.viewExtend({
                initView: function () {
                    axboot.buttonClick(this, "data-page-btn", {
                        "print": function () {
                            ACTIONS.dispatch(ACTIONS.PDF_PRINT);
                        },
                        "close": function () {
                            parent.modal.close();
                        }
                        ,"save": function () {
                            ACTIONS.dispatch(ACTIONS.SAVE);
                        }
                    });
                }
            });
        </script>
    </jsp:attribute>
    <jsp:body>
    <div id="myOffscreenEl">
        <div data-page-buttons="">
            <div class="button-warp">
                <button type="button" class="btn btn-reload" data-page-btn="reload" style="width: 50px;"
                        onclick="window.location.reload();">
                    <i class="icon_reload"></i></button>
                <button type="button" class="btn btn-popup-default" data-page-btn="save" style="width:80px;margin-right: 3px;"><i class="icon_ok"></i>비고 저장</button>
                <button type="button" class="btn btn-popup-default" data-page-btn="print"><i class="icon_ok"></i>인쇄
                </button>
                <button type="button" class="btn btn-popup-close" data-page-btn="close">닫기</button>
            </div>
        </div>
        <div role="page-content" data-ax5layout="ax1" style="overflow-x: hidden;">
                <div id="TBODY1" >
                </div>
        </div>


<%--        <div class="H10"></div>--%>
<%--        <div class="H10"></div>--%>


<%--        <div id="TBODY2">--%>

     </div>
    </jsp:body>
</ax:layout>