<%@ page import="com.chequer.axboot.core.utils.MessageUtils" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>

<ax:set key="title" value="관할구역관리"/>
<ax:set key="page_desc" value="${pageRemark}"/>
<ax:set key="page_auto_height" value="true"/>



<ax:layout name="base">
    <jsp:attribute name="script">
        <ax:script-lang key="ax.script"/>
        <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=316c9b07bf0cad06b4e37ab2f364f29f&libraries=services"></script>
        <style>
            .red {
                background: #ffe0cf !important;
            }
        </style>


        <script type="text/javascript">
            var afterIndex = 0;
            var selectRow2 = 0;
            var selectRow3 = 0;
            var beforeIdx = 0;

            var ITEM_SP = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'MA00011');
            var DELI_STAT = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'MA00017');

            var YN_OP = [{value:'' , text:''},{value:'Y' , text:'Y'},{value:'N' , text:'N'}];




            // $("#S_CONTRACT").ax5select({
            //     options: YN_OP
            // });
            var UserCallBack
            var modal = new ax5.ui.modal();
            var selectRow2 = 0;

            var fnObj = {}, CODE = {};
            var ACTIONS = axboot.actionExtend(fnObj, {
                PAGE_SEARCH: function (caller, act, data) {
                    var param = {

                    };
                    var list = $.DATA_SEARCH('order','selectH',param).list;
                    fnObj.gridView01.target.setData(list);
                    if(list.length < afterIndex ){
                        afterIndex = 0
                    }
                    caller.gridView01.target.select(afterIndex);
                    caller.gridView01.target.focus(afterIndex);
                    ACTIONS.dispatch(ACTIONS.ITEM_CLICK,caller);
                    selectRow2 = 0;

                    return false;
                },
                PAGE_SAVE: function (caller, act, data) {

                    // $.DATA_SEARCH('area','test',{}).list;
                    // return
                    var itemH = [].concat(caller.gridView01.getData("modified"));
                    itemH = itemH.concat(caller.gridView01.getData("deleted"));
                    itemH = itemH.concat(caller.gridView02.getData("modified"));
                    itemH = itemH.concat(caller.gridView02.getData("deleted"));
                    itemH = itemH.concat(caller.gridView03.getData("modified"));
                    itemH = itemH.concat(caller.gridView03.getData("deleted"));

                    if(itemH.length == 0){
                        qray.alert('변경된 정보가 없습니다.');
                        return;
                    }
                    if(caller.gridView02.requirement()){
                        return false;
                    }
                    if(caller.gridView03.requirement()){
                        return false;
                    }
                    var data = {
                         delete1 : caller.gridView01.getData("deleted")
                        ,insert1 : caller.gridView01.getData("modified")
                        ,delete2 : caller.gridView02.getData("deleted")
                        ,insert2 : caller.gridView02.getData("modified")
                        ,delete3 : caller.gridView03.getData("deleted")
                        ,insert3 : caller.gridView03.getData("modified")
                    };

                    axboot.ajax({
                        type: "POST",
                        url: ["area", "save"],
                        data: JSON.stringify(data),
                        callback: function (res) {
                            qray.alert("저장 되었습니다.");
                            ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                            caller.gridView01.target.select(afterIndex);
                            caller.gridView01.target.focus(afterIndex);

                        }
                    });
                },
                ITEM_CLICK: function (caller, act, data) {
                    var selected = caller.gridView01.getData('selected')[0];
                    var list2 = $.DATA_SEARCH('order','selectD',nvl(selected,{}));
                    fnObj.gridView02.target.setData(list2);

                }


            });
            // fnObj 기본 함수 스타트와 리사이즈
            fnObj.pageStart = function () {
                this.pageButtonView.initView();
                this.searchView.initView();
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
                        "save": function () {
                            ACTIONS.dispatch(ACTIONS.PAGE_SAVE);
                        },
                        "excel": function () {

                        }
                    });
                }
            });

            //== view 시작
            fnObj.searchView = axboot.viewExtend(axboot.searchView, {
                initView: function () {
                    this.target = $(document["searchView0"]);
                    this.target.attr("onsubmit", "return ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);");
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
                             {key: "COMPANY_CD", label: "회사코드", width: 150 , align: "left" , editor: {type: "text"},hidden:true}
                            ,{key: "JOIN_PT_CD"         , label: "가맹점거래처코드"           , width: 150     , align: "center"   , editor: false  ,sortable:true}
                            ,{key: "JOIN_PT_NM"         , label: "가맹점거래처명"             , width: 150     , align: "center"   , editor: false  ,sortable:true}
                            ,{key: "ORDER_CD"           , label: "주문코드"                   , width: 150     , align: "center"   , editor: false  ,sortable:true}
                            ,{key: "ORDER_DTE"          , label: "주문일자"                   , width: 150     , align: "center"   , editor: false  ,sortable:true}
                            ,{key: "ORDER_AMT"          , label: "주문금액"                   , width: 150     , align: "center"   , editor: false  ,sortable:true}
                            ,{key: "DISC_AMT"           , label: "할인금액"                   , width: 150     , align: "center"   , editor: false  ,sortable:true}
                            ,{key: "DELI_AMT"           , label: "배송금액"                   , width: 150     , align: "center"   , editor: false  ,sortable:true}
                            ,{key: "PAYM_AMT"           , label: "결제금액"                   , width: 150     , align: "center"   , editor: false  ,sortable:true}
                            ,{key: "BUYER_NM"           , label: "구매자명"                   , width: 150     , align: "center"   , editor: false  ,sortable:true}
                            ,{key: "BUYER_HP"           , label: "구매자 휴대폰"              , width: 150     , align: "center"   , editor: false  ,sortable:true}
                            ,{key: "BUYER_POST_NO"      , label: "구매자 우편번호"            , width: 150     , align: "center"   , editor: false  ,sortable:true}
                            ,{key: "BUYER_ADDR"         , label: "구매자 주소"                , width: 150     , align: "center"   , editor: false  ,sortable:true}
                            ,{key: "BUYER_SYSDEF_ADDR"  , label: "구매자 상세주소"            , width: 150     , align: "center"   , editor: false  ,sortable:true}
                            ,{key: "DELI_REQ"           , label: "배송요청"                   , width: 150     , align: "center"   , editor: false  ,sortable:true}
                            ,{key: "PAYM_METHOD"        , label: "결제방법"                   , width: 150     , align: "center"   , editor: false  ,sortable:true}
                            ,{key: "ORDER_STAT"         , label: "주문상태"                   , width: 150     , align: "center"   , editor: false  ,sortable:true}
                            ,{key: "TERMS_AGREE_YN"     , label: "약관동의여부"               , width: 150     , align: "center"   , editor: false  ,sortable:true}
                        ],

                        body: {
                            onDataChanged: function () {

                            },
                            //444
                            onClick: function () {
                                var index = this.dindex;
                                if(afterIndex == index){return false;}

                                var data = [].concat(fnObj.gridView02.getData("modified"));
                                data = data.concat(fnObj.gridView02.getData("deleted"))
                                data = data.concat(fnObj.gridView03.getData("modified"));
                                data = data.concat(fnObj.gridView03.getData("deleted"));

                                if(data.length > 0){
                                    qray.confirm({
                                        msg: "작업중인 데이터를 먼저 저장해주십시오."
                                        ,btns: {
                                            cancel: {
                                                label:'확인', onClick: function(key){
                                                    qray.close();
                                                }
                                            }
                                        }
                                    })
                                }else{
                                    afterIndex = index;
                                    this.self.select(this.dindex);
                                    ACTIONS.dispatch(ACTIONS.ITEM_CLICK, this.item);
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
                             {key: "COMPANY_CD"       , label: "", width: 150, align: "left", editor: {type: "text"} ,hidden:true}
                            , {key: "JOIN_PT_CD"         , label: "가맹점거래처코드"           , width: 150     , align: "center"   , sortable: true  , editor: false , hidden:true}
                            , {key: "JOIN_PT_NM"         , label: "가맹점거래처명"             , width: 150     , align: "center"   , sortable: true  , editor: false}
                            , {key: "ORDER_CD"           , label: "주문코드"                   , width: 150     , align: "center"   , sortable: true  , editor: false}
                            , {key: "ORDER_SEQ"          , label: "주문일자"                   , width: 150     , align: "center"   , sortable: true  , editor: false}
                            , {key: "ITEM_SP"            , label: "상품유형"                   , width: 150     , align: "center"   , sortable: true  , editor: false
                                ,formatter: function () {
                                    return $.changeTextValue(ITEM_SP, this.value)
                                }
                            }
                            , {key: "ITEM_CD"            , label: "상품코드"                   , width: 150     , align: "center"   , sortable: true  , editor: false}
                            , {key: "DISC_AMT"           , label: "할인금액"                   , width: 150     , align: "center"   , sortable: true  , editor: false}
                            , {key: "PAYM_AMT"           , label: "결제금액"                   , width: 150     , align: "center"   , sortable: true  , editor: false}
                            , {key: "DELI_STAT"          , label: "배송상태"                   , width: 150     , align: "center"   , sortable: true  , editor: false
                                , formatter: function () {
                                    return $.changeTextValue(DELI_STAT, this.value)
                                }
                            }
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

                    axboot.buttonClick(this, "data-grid-view-02-btn", {
                        "add": function () {
                            ACTIONS.dispatch(ACTIONS.ITEM_ADD2);
                        },
                        "delete": function () {

                            var beforeIdx = this.target.selectedDataIndexs[0];
                            var dataLen = this.target.getList().length;

                            if ((beforeIdx + 1) == dataLen) {
                                beforeIdx = beforeIdx - 1;
                            }

                            var item = fnObj.gridView02.getData('selected')[0]

                            ACTIONS.dispatch(ACTIONS.ITEM_DEL2);
                            if (beforeIdx > 0 || beforeIdx == 0) {
                                this.target.select(beforeIdx);
                                selectRow2 = beforeIdx;
                            }

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
                /*
                alert($("#ax-base-root").height()); // 컨텐츠영역높이
                ax-base-title //타이틀부분높이(class)
                ax-base-content //검색조건높이(class)
                 */
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
<%--                <button type="button" class="btn btn-info" data-page-btn="save" id="save_btn" style="width: 80px;"><i--%>
<%--                        class="icon_save"></i>저장--%>
<%--                </button>--%>

            </div>
        </div>

        <div role="page-header" id="pageheader">
            <ax:form name="searchView0">
                <ax:tbl clazz="ax-search-tb1" minWidth="500px">
                    <ax:tr>

                    </ax:tr>
                </ax:tbl>
            </ax:form>
        </div>

        <%-- 그리드 영역 시작 --%>
        <div style="width:100%;overflow:hidden">
            <div style="width:99%;overflow:hidden;">
                <div class="ax-button-group" data-fit-height-aside="grid-view-01" id="left_title" name="왼쪽그리드타이틀">
                    <div class="left">
                        <h2>
                            <i class="icon_list"></i> 주문리스트
                        </h2>
                    </div>
                </div>

                <div data-ax5grid="grid-view-01"
                     data-ax5grid-config="{  showLineNumber: true,showRowSelector: false, multipleSelect: false,lineNumberColumnWidth: 40,rowSelectorColumnWidth: 27, }"
                     id = "left_grid"
                     name="왼쪽그리드"
                ></div>

                <div class="ax-button-group" data-fit-height-aside="grid-view-02" id="left_title2" name="왼쪽그리드타이틀">
                    <div class="left">
                        <h2>
                            <i class="icon_list"></i> 주문상세
                        </h2>
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