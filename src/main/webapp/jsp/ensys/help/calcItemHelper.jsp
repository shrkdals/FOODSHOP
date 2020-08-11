<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>

<ax:set key="title" value="주문내역"/>
<ax:set key="page_desc" value="${pageRemark}"/>
<ax:set key="page_auto_height" value="true"/>


<ax:layout name="base">
    <jsp:attribute name="script">


        <ax:script-lang key="ax.script"/>
        <style>
            .red {
                background: #ffe0cf !important;
            }

            .readonly {
                background: #EEEEEE !important;
            }
        </style>
        <script type="text/javascript">

	        var dl_ITEM_UNIT   = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'MA00008');   // 출고단위
	        var dl_ITEM_SP     = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'MA00011');
        
        	var param = ax5.util.param(ax5.info.urlUtil().param);
        	var initData = parent.modal.modalConfig.sendData().initData;
            var fnObj = {}, CODE = {};
            var ACTIONS = axboot.actionExtend(fnObj, {
                PAGE_SEARCH: function (caller, act, data) {
                	axboot.ajax({
                        type: "POST",
                        url: ["calcSummary", "selectPop"],
                        data: JSON.stringify({
                        	ADJUST_DT: initData.ADJUST_DT,
                        	ADJUST_NO: initData.ADJUST_NO,
                        	JOIN_PT_CD: initData.JOIN_PT_CD,
                        }),
                        callback: function (res) {
                            caller.gridView01.clear();
                            if (res.list.length > 0) {
                                caller.gridView01.setData(res);
                                caller.gridView01.target.select(0);
                            }
                        }
                    });
                },
            });
            // fnObj 기본 함수 스타트와 리사이즈
            fnObj.pageStart = function () {
                this.pageButtonView.initView();
                this.gridView01.initView();

                ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
            };

            fnObj.pageButtonView = axboot.viewExtend({
                initView: function () {
                    axboot.buttonClick(this, "data-page-btn", {
                        "search": function () {
                            ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                        },
                        "close": function(){
                        	parent.modal.close();
                         }
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
                        frozenColumnIndex: 3,
                        target: $('[data-ax5grid="grid-view-01"]'),
                        columns: [
                            {key: "COMPANY_CD"      , label: ""                , width: 150, align: "left" , sortabled:true ,  hidden:true , editor: false }
                            ,{key: "ADJUST_NO"       , label: "정산번호"        , width: 150, align: "left" , sortabled:true ,  hidden:true , editor: false }
                            ,{key: "JOIN_PT_CD"    , label: "정산거래처코드"  , width: 150, align: "center" , sortabled:true ,  hidden:true , editor: false }
                            ,{key: "JOIN_PT_NM"    , label: "정산거래처명"    , width: 150, align: "left" , sortabled:true ,  hidden:true , editor: false }
                            ,{key: "ADJUST_DTE"    , label: "정산일자"        , width: 100, align: "center" , sortabled:true ,  hidden:false , editor: false }
                            ,{key: "ITEM_CD"       , label: "상품코드"        , width: 120, align: "center" , sortabled:true ,  hidden:false , editor: false}
                            ,{key: "ITEM_NM"       , label: "상품명"        , width: 150, align: "left" , sortabled:true ,  hidden:false , editor: false}
                            ,{key: "ITEM_WT"       , label: "상품중량"        , width: 120, align: "left" , sortabled:true ,  hidden:false , editor: false}
                            ,{key: "ITEM_SP"       , label: "상품유형"        , width: 120, align: "left" , sortabled:true ,  hidden:false , editor: false,
                            	formatter: function () {
	                                return $.changeTextValue(dl_ITEM_SP, this.value)
	                            },
                             }
                            ,{key: "ITEM_UNIT"       , label: "출고단위"        , width: 120, align: "left" , sortabled:true ,  hidden:false , editor: false,
	                            formatter: function () {
	                                return $.changeTextValue(dl_ITEM_UNIT, this.value)
	                            },
                             }
	                        ,{key: "BOX_NUM"      , label: "박스수량"        , width: 90, align: "right" , sortabled:true ,  hidden:false , editor: false }
	                        ,{key: "SELECT_NUM"      , label: "출고수량"        , width: 90, align: "right" , sortabled:true ,  hidden:false , editor: false }
                            ,{key: "ADJUST_AMT"      , label: "정산금액"        , width: 120, align: "right" , sortabled:true ,  hidden:false , editor: false,
                                formatter: "money"
                             }
                        
                        ],
                        footSum: [
                            [
                                {label: "", colspan: 7, align: "center"},
                                {key: "ADJUST_AMT", collector: "sum", formatter: "money", align: "right"}
                            ]
                        ],
                        body: {
                            onDataChanged: function () {

                            },
                            //444
                            onClick: function () {
                                var index = this.dindex;
                                var data = this.item;
                                
                                //if(afterIndex == index){return false;}

                                if (this.column.key == 'VIEW_ORDERLIST'){
                                	modal.open({
                                        width: 1100,
                                        height: _pop_height800,
                                        top: _pop_top800,
                                        iframe: {
                                            method: "get",
                                            url: "../../common/FileCanvas.jsp",
                                            param: "callBack=userCallBack"
                                        },
                                        sendData: function () {
                                            return {
                                                initData: data
                                            }
                                        },
                                        onStateChanged: function () {
                                            if (this.state === "open") {
                                                mask.open({
                                                    content: '<h1><i class="fa fa-spinner fa-spin"></i> Loading</h1>'
                                                });
                                            } else if (this.state === "close") {
                                                mask.close();
                                            }
                                        }
                                    }, function () {

                                    });
                                }

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
                getCheckData: function () {
                    var list = [];
                    $(this.target.getList()).each(function () {
                        if (this.s == "Y") {
                            list.push(this);
                        }
                    });
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


            //////////////////////////////////////
            //크기자동조정
            var _pop_top = 0;
            var _pop_height = 0;
            $(document).ready(function () {
                changesize();

                $("#PT_NM").focus();
                $("#PT_NM").keydown(function (e) {
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

                $("#left_grid").css("height" ,(tempgridheight / 100 * 99 - $('.ax-button-group').height() ) );
                $("#left_grid2").css("height", (tempgridheight / 100 * 99 - $('.ax-button-group').height()) / 2 );

            }

        </script>
    </jsp:attribute>
    <jsp:body>

        <div data-page-buttons="">
            <div class="button-warp">
                <button type="button" class="btn btn-reload" data-page-btn="reload"
                        onclick="window.location.reload();" style="width:80px;">
                    <i class="icon_reload"></i></button>
                <button type="button" class="btn btn-info" data-page-btn="search" style="width:80px;"><i
                        class="icon_search"></i><ax:lang
                        id="ax.admin.sample.modal.button.search"/>
                </button>
                <button type="button" class="btn btn-popup-close" data-page-btn="close">닫기</button>
            </div>
        </div>

        <div role="page-header" id="pageheader">
            <%-- <ax:form name="searchView0">
                <ax:tbl clazz="ax-search-tb1" minWidth="500px">
                    <ax:tr>
                    	<ax:td label='정산일자' width="450px">
                            <datepicker id="ADJUST_DT"></datepicker>
                        </ax:td> 
                    	<ax:td label='정산유형' width="350px">
                        	<div id="ADJUST_SP" name="ADJUST_SP" data-ax5select="ADJUST_SP"
                                 data-ax5select-config='{}' form-bind-type="selectBox"></div>
                        </ax:td>
                        <ax:td label='거래처유형' width="350px">
                            <div id="PT_SP" name="PT_SP" data-ax5select="PT_SP"
                                 data-ax5select-config='{}' form-bind-type="selectBox"></div>
                        </ax:td>
                        <ax:td label="거래처명" width="350px">
                            <div class="input-group" style="width:100%">
                                <input type="text" class="form-control" name="PT_NM" id="PT_NM" style="width:100%"/>
                            </div>
                        </ax:td>
                        <ax:td label='이체여부' width="350px">
                            <div id="TRANS_YN" name="TRANS_YN" data-ax5select="TRANS_YN"
                                 data-ax5select-config='{}' form-bind-type="selectBox"></div>
                        </ax:td>
                    </ax:tr>
                </ax:tbl>
            </ax:form> --%>
        </div>
		<div class="H10"></div>
            <div style="width:99%;overflow:hidden;">
                <div class="ax-button-group" data-fit-height-aside="grid-view-01" id="left_title" name="왼쪽그리드타이틀">
                    <div class="left">
                        <h2>
                            <i class="icon_list"></i> 리스트
                        </h2>
                    </div>
                    <div class="right">
                    </div>
                </div>

                <div data-ax5grid="grid-view-01"
                     data-ax5grid-config="{  showLineNumber: true,showRowSelector: false, multipleSelect: false,lineNumberColumnWidth: 40,rowSelectorColumnWidth: 27, }"
                     id = "left_grid"
                     name="왼쪽그리드"
                ></div>
            </div>



    </jsp:body>
</ax:layout>