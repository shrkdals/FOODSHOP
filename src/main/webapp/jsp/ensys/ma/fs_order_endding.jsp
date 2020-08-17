<%@ page import="com.chequer.axboot.core.utils.MessageUtils" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>

<ax:set key="title" value="주문마감관리"/>
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
            var userCallBack;
            var afterIndex = 0;
            
          
            var fnObj = {}, CODE = {};
            var ACTIONS = axboot.actionExtend(fnObj, {
                //조회버튼
                PAGE_SEARCH: function (caller, act, data) {
                    axboot.ajax({
                        type: "POST",
                        url: ["OrderEndding", "search"],
                        data: JSON.stringify({
                            COMPANY_CD: SCRIPT_SESSION.cdCompany
                        }),
                        callback: function (res) {
                            caller.gridView01.clear();
                            if (res.list.length > 0) {
                                caller.gridView01.setData(res);
                                caller.gridView01.target.select(0);
                            }else{
								caller.gridView01.addRow();
			                    var lastIdx = nvl(caller.gridView01.target.list.length, caller.gridView01.lastRow());
			                    caller.gridView01.target.select(lastIdx - 1);
			                    caller.gridView01.target.focus(lastIdx - 1);

			                    caller.gridView01.target.setValue(lastIdx - 1, 'ORDER_YN', 'Y');
                            }
                        }
                    });
                },
                //저장버튼
                PAGE_SAVE: function (caller, act, data) {
                    var saveData = [].concat(caller.gridView01.getData("modified"));

                    var regExp = /[\{\}\[\]\/?.,;:|\)*~`!^\-_+<>@\#$%&\\\=\(\'\"]/gi;
                    
                    for (var i = 0 ; i < saveData.length ; i ++){
                        if (nvl(saveData[i].ORD_START_TIME) == ''){
                            qray.alert('주문가능시작시간을 입력해주십시오.');
                            return ;
                        }
                        if (nvl(saveData[i].ORD_END_TIME) == ''){
                            qray.alert('주문가능종료시간을 입력해주십시오.');
                            return ;
                        }
                        if (nvl(saveData[i].ORD_MSG) == ''){
                            qray.alert('알림메세지를 입력해주십시오.');
                            return ;
                        }
                        if (saveData[i].ORD_START_TIME.replace(regExp, "").length != 4){
                        	qray.alert('주문가능시작시간을 제대로 입력해주십시오.');
                            return ;
                        }
                        if (saveData[i].ORD_END_TIME.replace(regExp, "").length != 4){
                        	qray.alert('주문가능종료시간을 제대로 입력해주십시오.');
                            return ;
                        }
                    }
                    

                    saveData = saveData.concat(caller.gridView01.getData("deleted"));
                    qray.confirm({
                        msg: "저장하시겠습니까?"
                    }, function () {
                        if (this.key == "ok") {
                            axboot.ajax({
                                type: "POST",
                                url: ["OrderEndding", "save"],
                                data: JSON.stringify({
                                    saveData: saveData,
                                }),
                                callback: function (res) {
                                    qray.alert("저장 되었습니다.").then(function(){
                                        ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
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
                this.gridView01.initView();

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
                        // parentFlag:true,
                        // parentGrid: $(fnObj.gridView02),
                        // childrenGrid: [$(fnObj.gridView02),$(fnObj.gridView03)],
                        showRowSelector: true,
                        columns: [
                            {key: "COMPANY_CD", label: "회사코드", width: 150 , align: "center" ,hidden:true},
                            {key: "ORDER_YN", label: "마감기능여부", width: 100 , align: "center",
                                editor: {
                                    type: "checkbox", config: {height: 17, trueValue: 'Y', falseValue: 'N'}
                                },
                                formatter: function () {
                                    var CHK = this.item.ORDER_YN;
                                    if (nvl(CHK, 'N') == 'N') {
                                        return '<div class="columnBox" id="columnBox' + this.dindex + '" data-ax5grid-editor="checkbox" data-ax5grid-checked="false" data-ax5grid-column-selected="true" style="height:17px;width:17px;margin-top:2px;  onclick="javascript:alert(1);"></div>';
                                    } else {
                                        return '<div class="columnBox" id="columnBox' + this.dindex + '" data-ax5grid-editor="checkbox" data-ax5grid-checked="true" data-ax5grid-column-selected="true" style="height:17px;width:17px;margin-top:2px;  onclick="javascript:alert(1);"></div>';
                                    }
                                }
                            },
                            {key: "ORD_START_TIME", label: "주문가능시작시간", width: 150 , align: "center", 
                                editor:{
                                    type:"number",
                                    attributes: {
                                        'maxlength': 4,
                                        'data-maxlength': 4
                                    }
                                },
								formatter: function(){
									var regExp = /[\{\}\[\]\/?.,;:|\)*~`!^\-_+<>@\#$%&\\\=\(\'\"]/gi;
									var value = this.item.ORD_START_TIME + "";
									if (nvl(value) != ''){
										value = value.replace(regExp, '');
									}
									return value.replace(/(\d{2})(\d{2})/, '$1:$2')
								}
                            },
                            {key: "ORD_END_TIME", label: "주문가능종료시간", width: 150 , align: "center",
                            	editor:{
                                    type:"number",
                                    attributes: {
                                        'maxlength': 4,
                                        'data-maxlength': 4
                                    }
                                },
								formatter: function(){
									var regExp = /[\{\}\[\]\/?.,;:|\)*~`!^\-_+<>@\#$%&\\\=\(\'\"]/gi;
									var value = this.item.ORD_END_TIME + "";
									if (nvl(value) != ''){
										value = value.replace(regExp, '');
									}
									return value.replace(/(\d{2})(\d{2})/, '$1:$2')
								}
                            },
                            {key: "ORD_MSG", label: "알림메세지", width: "*" , align: "left",  editor:{type:"text"} },
                            {key: "INSERT_ID", label: "처리자아이디", width: 150 , align: "center", hidden:true },
                            {key: "INSERT_NM", label: "처리자", width: 150 , align: "center", editor:false },
                            {key: "INSERT_DT", label: "처리일자", width: 150 , align: "center", editor:false },
                            {key: "UPDATE_ID", label: "수정자아이디", width: 150 , align: "center", hidden:true },
                            {key: "UPDATE_NM", label: "수정자", width: 150 , align: "center", editor:false },
                            {key: "UPDATE_DT", label: "수정일자", width: 150 , align: "center", editor:false },
                        ],
                        body: {
                            onDataChanged: function () {

                            },
                            //444
                            onClick: function () {
                                var index = this.dindex;
                                if(afterIndex == index) {
                                    return false;
                                }

                                afterIndex = index;
                                this.self.select(this.dindex);

                            },
                            
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

            $(document).ready(function(){


            });

            //////////////////////////////////////
            //크기자동조정
            var _pop_top = 0;
            var _pop_height = 0;
            var _pop_height800 = 0;
            var _pop_top800 = 0;
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
                //타이틀을 뺀 상하단 그리드 합친높이
                var tempgridheight = datarealheight;

                $("#left_grid").css("height" ,(tempgridheight / 100 * 99));
                
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
        
        <%-- 그리드 영역 시작 --%>
        <div style="width:100%;overflow:hidden;">
            <div style="width:100%;overflow:hidden;">
                
                <div data-ax5grid="grid-view-01"
                     data-ax5grid-config="{  showLineNumber: true,showRowSelector: false, multipleSelect: false,lineNumberColumnWidth: 40,rowSelectorColumnWidth: 27, }"
                     id = "left_grid"
                     name="왼쪽그리드"
                ></div>

            </div>

        </div>


    </jsp:body>
</ax:layout>