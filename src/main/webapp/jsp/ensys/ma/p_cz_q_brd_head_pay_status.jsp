<%@ page import="com.chequer.axboot.core.utils.MessageUtils" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>

<ax:set key="title" value="브랜드본사 지급현황"/>
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
			//	BrdHeadPayStatus
            var fnObj = {}, CODE = {};
            var ACTIONS = axboot.actionExtend(fnObj, {
                PAGE_SEARCH: function (caller, act, data) {
                	axboot.ajax({
                        type: "POST",
                        url: ["BrdHeadPayStatus", "select"],
                        data: JSON.stringify({
                            KEYWORD: $("#KEYWORD").val(),
                        }),
                        callback: function (res) {
							console.log(res);
							fnObj.gridView01.setData(res);
							if (res.list.length > 0 ){
								fnObj.gridView01.target.select(0);
							}
							
							ACTIONS.dispatch(ACTIONS.ITEM_CLICK);
                        }
                	});
                },
                ITEM_CLICK : function (caller, act, data) {
                    var selected = nvl(fnObj.gridView01.getData('selected')[0], {});
                    
                	axboot.ajax({
                        type: "POST",
                        url: ["BrdHeadPayStatus", "selectDtl"],
                        data: JSON.stringify({
                            PT_CD: selected.PT_CD,
                        }),
                        callback: function (res) {
							console.log(res);
							fnObj.gridView02.setData(res);
                        }
                	});
                }
            });
            // fnObj 기본 함수 스타트와 리사이즈
            fnObj.pageStart = function () {
                this.pageButtonView.initView();
                this.gridView01.initView();
                this.gridView02.initView();
                
                ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
            };


            fnObj.pageButtonView = axboot.viewExtend({
                initView: function () {
                    axboot.buttonClick(this, "data-page-btn", {
                        "search": function () {
                            ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                        },
                    });
                }
            });


            /**
             * gridView01
             */
            fnObj.gridView01 = axboot.viewExtend(axboot.gridView, {
                page: {
                    pageNumber: 0,
                    pageSize: 10
                },
                initView: function () {
                    var _this = this;

                    this.target = axboot.gridBuilder({
                        showRowSelector: true,
                        target: $('[data-ax5grid="grid-view-01"]'),
                        showRowSelector: true,
                        columns: [
                             {key: "PT_CD", 		label: "거래처코드", 	width: 150 , align: "center", sortable: true,},
                             {key: "PT_NM", 		label: "거래처명", 		width: 130 , align: "left", sortable: true,},
                             {key: "BIZ_NO", 		label: "사업자번호",	width: 120 , align: "left",
								formatter:function(){
									if (nvl(this.item.BIZ_NO) == ''){
										return '';
									}else{
										return this.item.BIZ_NO.replace(/(\d{3})(\d{2})(\d{4})/, '$1-$2-$3')
									}
								}, sortable: true,
                             },
                             {key: "OWNER_NM", 		label: "대표자명", 		width: 100 , align: "left", sortable: true,},
                             {key: "HP_NO", 		label: "휴대폰번호", 	width: 120 , align: "left", sortable: true,},
                             {key: "CD_BANK", 		label: "계좌은행", 		width: 120 , align: "center", hidden:true},
                             {key: "NM_BANK", 		label: "계좌은행", 		width: 120 , align: "left", sortable: true,},
                             {key: "NO_DEPOSIT", 	label: "계좌번호", 		width: 120 , align: "left", sortable: true,},
                             {key: "CONTRACT_CNT", 	label: "가맹계약건수", 	width: 100 , align: "center", sortable: true,},
                             {key: "TOT_AMT", 		label: "총금액", 		width: 120 , align: "right", formatter:"money", sortable: true,},
                             {key: "PAY_AMT", 		label: "지급금액", 		width: 120 , align: "right", formatter:"money", sortable: true,},
                             {key: "JAN_AMT", 		label: "잔액", 			width: 120 , align: "right", formatter:"money", sortable: true,},
                        ],
                        body: { 
                            onDataChanged: function () {

                            },
                            onClick: function () {
                                var index = this.dindex;

                                this.self.select(this.dindex);
                                ACTIONS.dispatch(ACTIONS.ITEM_CLICK, this.item);
                                
                            }
                        },
                        onPageChange: function (pageNumber) {
                            _this.setPageData({pageNumber: pageNumber});
                            ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                        },
                        page: {
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
                    return ($("div [data-ax5grid='grid-view-01']").find("div [data-ax5grid-panel='body'] table tr").length)
                }
                , sort: function () {
                }

            });


            /**
             * gridView02
             */
             fnObj.gridView02 = axboot.viewExtend(axboot.gridView, {
                 page: {
                     pageNumber: 0,
                     pageSize: 10
                 },
                 initView: function () {
                     var _this = this;

                     this.target = axboot.gridBuilder({
                         showRowSelector: true,
                         frozenColumnIndex: 0,
                         target: $('[data-ax5grid="grid-view-02"]'),
                         columns: [
                        	 {key: "PT_CD", 			label: "가맹점거래처코드", 	width: 150 , align: "center", sortable: true,},
                        	 {key: "PT_NM", 			label: "가맹점명", 			width: 120, align: "left", sortable: true,},
                        	 {key: "BUY_YN", 			label: "구매여부", 			width: 80 , align: "center", sortable: true,},
                        	 {key: "ORDER_CD", 			label: "주문코드", 			width: 150 , align: "center", hidden:true},
                        	 {key: "ORDER_DTE", 		label: "주문일자", 			width: 120 , align: "left", sortable: true,},
                        	 {key: "ORDER_AMT", 		label: "주문금액", 			width: 120 , align: "right", formatter:"money", sortable: true,},
                        	 {key: "PAYM_AMT", 			label: "결제금액", 			width: 120 , align: "right", formatter:"money", sortable: true,},
                        	 {key: "BUYER_NM", 			label: "구매자명", 			width: 100 , align: "left", sortable: true,},
                        	 {key: "BUYER_HP", 			label: "구매자휴대폰", 		width: 120 , align: "left", sortable: true,},
                        	 {key: "BUYER_POST_NO", 	label: "우편번호", 			width: 100 , align: "left", sortable: true,},
                        	 {key: "BUYER_ADDR", 		label: "주소", 				width: 150 , align: "left", sortable: true,},
                        	 {key: "BUYER_SYSDEF_ADDR", label: "상세주소", 			width: 150 , align: "left", sortable: true,},
                         ], 
                         body: {
                             onClick: function () {
                                 var data = this.item;           //  선택한 ROW의 ITEM들
                                 var column = this.column.key;   //  컬럼 KEY명
                                 var idx = this.dindex;          //  선택한 ROW의 INDEX

                                 selectRow2 = idx;
                                 this.self.select(selectRow2);
                             }
                         },
                         onPageChange: function (pageNumber) {
                             _this.setPageData({pageNumber: pageNumber});
                             ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                         },
                         page: {
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
                    return ($("div [data-ax5grid='grid-view-02']").find("div [data-ax5grid-panel='body'] table tr").length)
                }
            });


            //////////////////////////////////////
            //크기자동조정
            var _pop_top = 0;
            var _pop_height = 0;
            $(document).ready(function () {
                changesize();
                
                $("#KEYWORD").focus();
                $("#KEYWORD").keydown(function (e) {
                    if (e.keyCode == '13') {
                        ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                    }
                });

            });
            $(window).resize(function () {
                changesize();
            });


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
                var datarealheight = $("#ax-base-root").height() - $(".ax-base-title").height() - $("#pageheader").height();
                //타이틀을 뺀 상하단 그리드 합친높이
                var tempgridheight = datarealheight - $("#left_title").height() - $("#bottom_left_title").height() - $("#bottom_left_amt").height();

                $("#left_grid").css("height" ,(tempgridheight / 100 * 99 - $('.ax-button-group').height() ) / 2 );
                $("#left_grid2").css("height", (tempgridheight / 100 * 99 - $('.ax-button-group').height()) / 2 );

            }



        </script>
    </jsp:attribute>
    <jsp:body>
        <style>

            .form-control_02[readonly] {
                background-color: #eeeeee;
                opacity: 1
            }

            input[type="number"]::-webkit-outer-spin-button,
            input[type="number"]::-webkit-inner-spin-button {
                -webkit-appearance: none;
                margin: 0;
            }

            .form-control_02 {
                height: 25px;
                padding: 3px 6px;
                font-size: 12px;
                line-height: 1.42857;
                color: #555555;
                background-color: #fff;
                background-image: none;
                border: 1px solid #ccc;
                -webkit-transition: border-color ease-in-out 0.15s, box-shadow ease-in-out 0.15s;
                -o-transition: border-color ease-in-out 0.15s, box-shadow ease-in-out 0.15s;
                transition: border-color ease-in-out 0.15s, box-shadow ease-in-out 0.15s;
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
               
            </div>
        </div>

        <div role="page-header" id="pageheader">
            <ax:form name="searchView0">
                <ax:tbl clazz="ax-search-tb1" minWidth="500px">
                    <ax:tr>
                        <ax:td label='브랜드본사' width="450px">
                        		<input type="text" id="KEYWORD" name="KEYWORD" class="form-control">
                        </ax:td>
                    </ax:tr>
                </ax:tbl>
            </ax:form>
        </div>
        <%-- 그리드 영역 시작 --%>
        <div style="width:100%;overflow:hidden">
            <div style="width:99%;overflow:hidden;">
                <div class="ax-button-group" data-fit-height-aside="grid-view-01" id="left_title" name="왼쪽그리드타이틀">
                    <div class="left">
                       
                    </div>
                    <div class="right">
                        
                    </div>

                </div>

                <div data-ax5grid="grid-view-01"
                     data-ax5grid-config="{  showLineNumber: true,showRowSelector: false, multipleSelect: false,lineNumberColumnWidth: 40,rowSelectorColumnWidth: 27, }"
                     id = "left_grid"
                     name="왼쪽그리드"
                ></div>

                <div class="ax-button-group" data-fit-height-aside="grid-view-02" id="left_title2" name="왼쪽그리드타이틀">
                    <div class="left">
                        
                    </div>
                    <div class="right">
                        
                    </div>
                </div>

                <div data-ax5grid="grid-view-02"
                     data-ax5grid-config="{  showLineNumber: true,showRowSelector: false, multipleSelect: false,lineNumberColumnWidth: 40,rowSelectorColumnWidth: 27, }"
                     id = "left_grid2"
                     name="왼쪽그리드"
                ></div>
            </div>



            </div>
        </div>


    </jsp:body>
</ax:layout>