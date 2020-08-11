<%@ page import="com.chequer.axboot.core.utils.MessageUtils" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>

<ax:set key="title" value="약관관리"/>
<ax:set key="page_desc" value="${pageRemark}"/>
<ax:set key="page_auto_height" value="true"/>


<ax:layout name="base">
    <jsp:attribute name="script">
        <ax:script-lang key="ax.script"/>
        <style>
            .red {
                background: #ffe0cf !important;
            }
        </style>
        <script type="text/javascript">
        
            var change = false;
            var TERMS_CD = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'MA00037', true); // 약관유형
            $("#TERMS_CD").ax5select({
                options: TERMS_CD,
                onStateChanged: function (e) {
                    if (e.state == "changeValue") {
                    	change = false;
                    	ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                    }
                }
                
             });
            var CallBack1;
            var fnObj = {}, CODE = {};
            var ACTIONS = axboot.actionExtend(fnObj, {
                //조회버튼
                PAGE_SEARCH: function (caller, act, data) {
                    $("#CONTENTS").val('');
                    axboot.ajax({
                        type: "POST",
                        url: ["Terms", "select"],
                        data: JSON.stringify({
                        	TERMS_CD: $('select[name="TERMS_CD"]').val()
                        }),
                        callback: function (res) {
                            console.log(res);
                            if (nvl(res) != ''){
								if (nvl(res.list) != ''){
									if (res.list.length > 0){
										$("#CONTENTS").val(
											nvl(res.list[0].CONTENTS, '').replace(/(<br>|<br\/>|<br \/>)/g, '\r\n').replace(/(&rdquo;)/g, '"').replace(/(&ldquo;)/g, '"').replace(/(&rsquo;)/g, "'")
											.replace(/&nbsp;/gi, ' ').replace(/<p[^>]*>/g, '\r\n').replace(/<\/p>/g, '\r\n').replace(/&middot;/gi, '').replace(/&lsquo;/g, "‘").replace(/&lsquo;/gi, "‘").replace(/&lt;/g, "-")
											.replace(/&lt;/gi, "-").replace(/&gt/g, "").replace(/&gt/gi, "")
											);
									}
								}
                            }
                        }
                    });
                },
                PAGE_SAVE: function (caller, act, data) {
                	if (!change){
                		qray.alert('변경된 정보가 없습니다.');
                        return;
                    }

                    qray.confirm({
                        msg: "저장하시겠습니까?"
                    }, function () {
                        if (this.key == "ok") {
                            axboot.ajax({
                                type: "POST",
                                url: ["Terms", "save"],
                                data: JSON.stringify({
                                	TERMS_CD : $('select[name="TERMS_CD"]').val(),
                                	CONTENTS : $("#CONTENTS").val().replace(/(\n|\r\n)/g, '<br>')
                                }),
                                callback: function (res) {
                                    qray.alert("저장 되었습니다.").then(function () {
                                        ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                                        caller.gridView01.target.focus(afterIndex);
                                        caller.gridView01.target.select(afterIndex);

                                    });
                                }
                            });
                        }
                    });
                },
            });
            // fnObj 기본 함수 스타트와 리사이즈
            fnObj.pageStart = function () {
                this.pageButtonView.initView();
                
                ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
            };

            fnObj.pageButtonView = axboot.viewExtend({
                initView: function () {
                    axboot.buttonClick(this, "data-page-btn", {
                        "search": function () {
                            ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                        },
                        "save": function () {
                            ACTIONS.dispatch(ACTIONS.PAGE_SAVE);
                        },
                    });
                }
            });

            //////////////////////////////////////
            //크기자동조정
            var _pop_top = 0;
            var _pop_height = 0;
            var _pop_height800 = 0;
            var _pop_top800 = 0;
            $(window).resize(function () {
                changesize();
            });
            $(document).ready(function(){
            	changesize();
            })

            $("#CONTENTS").change(function () {
            	change = true;
                console.log(this.value.replace(/(\n|\r\n)/g, '<br>'));
                fnObj.gridView01.target.setValue(fnObj.gridView01.getData('selected')[0].__index, 'BRD_NOTICE', this.value.replace(/(\n|\r\n)/g, '<br>'));
            })

            function onlyNumber(input){
                $(input).val($(input).val().replace(/[^0-9]/gi,""));
            }

            function numberWithCommas(x, id) {
                x = x.replace(/[^0-9]/g, '');   // 입력값이 숫자가 아니면 공백
                x = x.replace(/,/g, '');          // ,값 공백처리
                $('#' + id).val(x.replace(/\B(?=(\d{3})+(?!\d))/g, ",")); // 정규식을 이용해서 3자리 마다 , 추가
            }

            function changesize() {
                //전체영역높이
                var totheight = $("#ax-base-root").height();
                if (totheight > 700) {
                    _pop_height = 600;
                    _pop_top = parseInt((totheight - _pop_height) / 2);
                    _pop_height800 = 800;
                    _pop_top800 = parseInt((totheight - 800) / 2);
                }
                else{
                    _pop_height800 = totheight / 10 * 9;
                    _pop_top800 = parseInt((totheight - _pop_height800) / 2);
                    _pop_height = totheight / 10 * 8;
                    _pop_top = parseInt((totheight - _pop_height) / 2);
                }

                //데이터가 들어갈 실제높이
                var datarealheight = $("#ax-base-root").height() - $(".ax-base-title").height() - $("#pageheader").height();
                $("#CONTENTS").css("height", (datarealheight / 100 * 99));
                $("#CONTENTS").css("width", '100%');
            }
        </script>
    </jsp:attribute>
    <jsp:body>
        <style>
            input[type="number"]::-webkit-outer-spin-button,
            input[type="number"]::-webkit-inner-spin-button {
                -webkit-appearance: none;
                margin: 0;
            }

            .TERMS_CD {
                width: 100%;
                resize: none;
                overflow-y: hidden; /* prevents scroll bar flash */
                padding: 1.1em; /* prevents text jump on Enter keypress */
                padding-bottom: 0.2em;
                line-height: 1.6;
                height: 100%;
                border: 1px solid #eee;
            }
        </style>
        <div data-page-buttons="">
            <div class="button-warp">
                <button type="button" class="btn btn-reload" data-page-btn="reload" style="width: 80px;"
                        onclick="window.location.reload();">
                    <i class="icon_reload"></i></button>
                <button type="button" class="btn btn-info" data-page-btn="search" style="width: 80px;"><i
                        class="icon_search"></i><ax:lang
                        id="ax.admin.sample.modal.button.search"/></button>
                <button type="button" class="btn btn-info" data-page-btn="save" id="save_btn" style="width: 80px;"><i
                        class="icon_save"></i>저장
                </button>

            </div>
        </div>
        <%-- 상단조회조건 --%>
        <div role="page-header" id="pageheader">
            <ax:form name="searchView0">
                <ax:tbl clazz="ax-search-tb1" minWidth="500px">
                    <ax:tr>
                        <ax:td label='약관유형' width="350px">
                            <div id="TERMS_CD" name="TERMS_CD" data-ax5select="TERMS_CD"
                                 data-ax5select-config='{}' form-bind-type="selectBox"></div>
                        </ax:td>
                    </ax:tr>
                </ax:tbl>
            </ax:form>
        </div>
        <%-- 그리드 영역 시작 --%>
        <div style="width:100%;overflow:hidden;">
            <textarea class="CONTENTS" id="CONTENTS"></textarea>
        </div>

    </jsp:body>
</ax:layout>