<%@ page import="com.chequer.axboot.core.utils.MessageUtils" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>

<ax:set key="title" value="브랜드계약현황"/>
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
            var afterIndex = 0;
            var selectRow2 = 0;
            
            var MAIN_PT_CD = $.DATA_SEARCH("BrandContract", 'S_1',{}).list;

            $('#MAIN_PT_CD').ax5select({
                options: [{value:'' , text:''}].concat(MAIN_PT_CD),
                onStateChanged: function (e) {
                    if (e.state == "changeValue") {
                        $('#ALL_PT').attr('HELP_PARAM', JSON.stringify({PT_CD : $('select[name="S_1"]').val()}))

                    }
                }
            });
            
            var fnObj = {}, CODE = {};
            var ACTIONS = axboot.actionExtend(fnObj, {
                PAGE_SEARCH: function (caller, act, data) {
                	 axboot.ajax({
                         type: "POST",
                         url: ["brandContractStatus", "select"],
                         data: JSON.stringify({
                        	 MAIN_PT_CD : $('select[name="MAIN_PT_CD"]').val(),
                        	 JOIN_PT_CD : $("#JOIN_PT_CD").val()
                         }),
                         callback: function (res) {
                         	selectRow = 0;
                             caller.gridView01.setData(res);
                             caller.gridView01.target.select(0);
                             ACTIONS.dispatch(ACTIONS.ITEM_CLICK);
                         }
                     });
                },
                ITEM_CLICK: function (caller, act, data) {
                	caller.gridView02.clear();
                	var selected = caller.gridView01.getData('selected')[0];
                	if (nvl(selected) == '') return;

                	axboot.ajax({
                        type: "POST",
                        url: ["brandContractStatus", "selectDtl"],
                        data: JSON.stringify({
                        	JOIN_PT_CD : selected.JOIN_PT_CD
                        }),
                        callback: function (res) {
                            caller.gridView02.setData(res);
                            caller.gridView02.target.select(0);
                        }
                    });
                },
            });
            
            // fnObj 기본 함수 스타트와 리사이즈
            fnObj.pageStart = function () {
                this.pageButtonView.initView();
                this.gridView01.initView();
                this.gridView02.initView();
                
                ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
            };

            fnObj.pageResize = function () {

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
                        	{key: "MAIN_PT_CD", label: "총판코드", width: 150   , align: "center" , editor: false, hidden:true},
                        	{key: "MAIN_PT_NM", label: "총판명", width: 100   , align: "left" , editor: false, sortable: true},
                        	{key: "JOIN_PT_CD", label: "가맹점코드", width: 150   , align: "center" , editor: false, hidden:true},
                        	{key: "JOIN_PT_NM", label: "가맹점명", width: 120   , align: "left" , editor: false, sortable: true},
                        	{key: "BIZ_NO", label: "사업자번호", width: 95   , align: "center" , editor: false, sortable: true,
                        		formatter: function () {
                                    return $.changeDataFormat( this.value , 'company')
                                }
                            },
                        	{key: "TEL_NO", label: "전화번호", width: 100   , align: "left" , editor: false, sortable: true},
                        	{key: "OWNER_NM", label: "대표자", width: 90   , align: "left" , editor: false, sortable: true},
                        	{key: "SIGN_NM", label: "간판명", width: 120   , align: "left" , editor: false, sortable: true},
                        ],
                        body: {
                            onDataChanged: function () {
                                console.log("z");
                            },
                            onClick: function () {
                                var index = this.dindex;
                                if(afterIndex == index){return false;}
                                
                                afterIndex = index;
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
                        	{key: "BRD_CD", label: "브랜드코드", width: 150   , align: "center" , editor: false, sortable: true},
                        	{key: "BRD_NM", label: "브랜드명", width: 150   , align: "left" , editor: false, sortable: true},
                        	{key: "CONTRACT_ST_DTE", label: "계약시작일자", width: 150   , align: "center" , editor: false, sortable: true,
                        		formatter: function () {
                                    return $.changeDataFormat(this.value)
                                }
                            },
                        	{key: "SALES_PERSON_ID", label: "계약담당자아이디", width: 150   , align: "center" , editor: false, sortable: true},
                        	{key: "SALES_PERSON_NM", label: "계약담당자", width: 150   , align: "left" , editor: false, sortable: true}
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

                $("#JOIN_PT_CD").focus();
                $("#JOIN_PT_CD").keydown(function (e) {
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

                $("#left_grid").css("height" ,tempgridheight / 100 * 99 - $('.ax-button-group').height()  );
                $("#right_grid").css("height", tempgridheight / 100 * 99 - $('.ax-button-group').height() );
                /*
                alert($("#ax-base-root").height()); // 컨텐츠영역높이
                ax-base-title //타이틀부분높이(class)
                ax-base-content //검색조건높이(class)
                 */
            }
        </script>
    </jsp:attribute>
    <jsp:body>
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
                        <ax:td label='총판' width="350px">
                            <div id="MAIN_PT_CD" name="MAIN_PT_CD" data-ax5select="MAIN_PT_CD"
                                 data-ax5select-config='{}' form-bind-type="selectBox"></div>
                        </ax:td>
                        <ax:td label='가맹점' width="350px">
                            <div class="input-group" style="width:100%">
                                <input type="text" class="form-control" name="JOIN_PT_CD" id="JOIN_PT_CD"
                                       style="width:100%"/>
                            </div>
                        </ax:td>
                    </ax:tr>
                </ax:tbl>
            </ax:form>
        </div>

        <%-- 그리드 영역 시작 --%>
        <div style="width:100%;overflow:hidden">
            <div style="width:40%;overflow:hidden;float:left;">
                <div class="ax-button-group" data-fit-height-aside="grid-view-01" id="left_title" name="왼쪽그리드타이틀">
                    <div class="left">
                        <h2>
                            <i class="icon_list"></i> 가맹점리스트
                        </h2>
                    </div>
                </div>

                <div data-ax5grid="grid-view-01"
                     data-ax5grid-config="{  showLineNumber: true,showRowSelector: false, multipleSelect: false,lineNumberColumnWidth: 40,rowSelectorColumnWidth: 27, }"
                     id = "left_grid"
                ></div>

            </div>

            <div style="width:59%;overflow:hidden;float:right;">
                <div class="ax-button-group" data-fit-height-aside="grid-view-02" id="left_title2" name="왼쪽그리드타이틀">
                    <div class="left">
                        <h2>
                            <i class="icon_list"></i> 브랜드리스트
                        </h2>
                    </div>
                    <div class="right" style="width:350px">
                    </div>

                </div>

                <div data-ax5grid="grid-view-02"
                     data-ax5grid-config="{  showLineNumber: true,showRowSelector: false, multipleSelect: false,lineNumberColumnWidth: 40,rowSelectorColumnWidth: 27, }"
                     id = "right_grid"
                ></div>
            </div>

            </div>
        </div>

    </jsp:body>
</ax:layout>