<%@ page import="com.chequer.axboot.core.utils.MessageUtils" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>

<ax:set key="title" value="이벤트관리"/>
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
                        url: ["BANNER", "search"],
                        data: JSON.stringify({
                            KEYWORD: $("#KEYWORD").val()
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
                //저장버튼
                PAGE_SAVE: function (caller, act, data) {
                    var saveData = [].concat(caller.gridView01.getData("modified"));

                    for (var i = 0 ; i < saveData.length ; i ++){
                        if (nvl(saveData[i].BANNER_NM) == ''){
                            qray.alert('배너명을 입력해주십시오.');
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
                                url: ["BANNER", "save"],
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
                //상단추가버튼
                ITEM_ADD1: function (caller, act, data) {
                    caller.gridView01.addRow();
                    var lastIdx = nvl(caller.gridView01.target.list.length, caller.gridView01.lastRow());
                    caller.gridView01.target.select(lastIdx - 1);
                    caller.gridView01.target.focus(lastIdx - 1);
                    afterIndex  = lastIdx - 1;

                    caller.gridView01.target.setValue(lastIdx - 1, 'BANNER_CD', GET_NO('MA','08'));
                    caller.gridView01.target.setValue(lastIdx - 1, 'USE_YN', 'Y');

                },
                ITEM_DEL1: function (caller, act, data) {
                    fnObj.gridView01.delRow("selected");
                }
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
                            {key: "BANNER_CD", label: "배너코드", width: 150 , align: "center" , editor: false, sortable: true,},
                            {key: "BANNER_NM", label: "배너명", width: 150 , editor: {type: "text"}, align: "left",sortable: true,},
                            {key: "URL_LINK", label: "링크주소", width: "*" , editor: {type: "text"}, align: "left",sortable: true,},
                            {key: "USE_YN", label: "사용여부", width: 150 , align: "center", sortable: true,
                                editor: {
                                    type: "checkbox", config: {height: 17, trueValue: 'Y', falseValue: 'N'}
                                },
                                formatter: function () {
                                    var CHK = this.item.USE_YN;
                                    if (nvl(CHK, 'N') == 'N') {
                                        return '<div class="columnBox" id="columnBox' + this.dindex + '" data-ax5grid-editor="checkbox" data-ax5grid-checked="false" data-ax5grid-column-selected="true" style="height:17px;width:17px;margin-top:2px;  onclick="javascript:alert(1);"></div>';
                                    } else {
                                        return '<div class="columnBox" id="columnBox' + this.dindex + '" data-ax5grid-editor="checkbox" data-ax5grid-checked="true" data-ax5grid-column-selected="true" style="height:17px;width:17px;margin-top:2px;  onclick="javascript:alert(1);"></div>';
                                    }
                                }
                            },
                            {key: "FILE_NAME", label: "파일", width: 150 , align: "center" , editor: false, sortable: true,},
                            {key: "FILE", label: "이미지파일", width: 150 , align: "center" , editor: false, sortable: true, hidden:true},
                            {key: "INSERT_ID", label: "처리자아이디", width: 150 , align: "center" , editor: {type: "text"},hidden:true},
                            {key: "INSERT_DT", label: "처리일자", width: 150 , align: "center" , editor: {type: "text"},hidden:true},
                            {key: "UPDATE_ID", label: "변경자아이디", width: 150 , align: "center" , editor: {type: "text"},hidden:true},
                            {key: "UPDATE_DT", label: "변경일자", width: 150 , align: "center" , editor: {type: "text"},hidden:true},
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
                                ACTIONS.dispatch(ACTIONS.ITEM_CLICK, this.item);

                            },
                            onDBLClick: function () {
                                var column = this.column.key;
                                if (column == 'FILE_NAME'){
                                    var selected = fnObj.gridView01.getData('selected')[0];

                                    userCallBack = function (e) {
                                        e['TB_ID'] = 'FS_BANNER_M';
                                        e['CG_CD'] = 'BANNER00001';
                                        e['TB_KEY'] = selected.BANNER_CD;

                                        fnObj.gridView01.target.setValue(selected.__index, 'FILE_NAME', e.ORGN_FILE_NAME);
                                        fnObj.gridView01.target.list[selected.__index]['FILE'] = e;
                                    };


                                    var data = {
                                        TB_ID: 'FS_BANNER_M',
                                        CG_CD: 'BANNER00001',
                                        TB_KEY: selected['BANNER_CD'],
                                        FILE_PATH: 'banner',
                                        CALL_BACK: selected['FILE']
                                    }

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
                    axboot.buttonClick(this, "data-grid-view-01-btn", {
                        "delete": function () {
                            var beforeIdx = fnObj.gridView01.target.selectedDataIndexs[0];
                            var dataLen = fnObj.gridView01.target.getList().length;

                            if ((beforeIdx + 1) == dataLen) {
                                beforeIdx = beforeIdx - 1;
                            }
                            ACTIONS.dispatch(ACTIONS.ITEM_DEL1);
                            fnObj.gridView01.target.select(beforeIdx);
                            fnObj.gridView01.target.focus(beforeIdx);
                            ACTIONS.dispatch(ACTIONS.ITEM_CLICK);
                        },
                        "add": function () {
                            ACTIONS.dispatch(ACTIONS.ITEM_ADD1);
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

            function numberWithCommas(x , id) {
                x = x.replace(/[^0-9]/g,'');   // 입력값이 숫자가 아니면 공백
                x = x.replace(/,/g,'');          // ,값 공백처리
                $('#'+id).val(x.replace(/\B(?=(\d{3})+(?!\d))/g, ",")); // 정규식을 이용해서 3자리 마다 , 추가
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
                var datarealheight = $("#ax-base-root").height() - $(".ax-base-title").height() - $("#pageheader").height() - $("#tab_button_area").height() - $("#tab_area").height() - 20;
                //타이틀을 뺀 상하단 그리드 합친높이
                var tempgridheight = datarealheight - $("#left_title").height();

                $("#left_grid").css("height" ,(tempgridheight / 100 * 99));
                $("#tab1_grid").css("height" ,$("#tab_area").height() - 40);
                $("#tab2_grid").css("height" ,$("#tab_area").height() - 40);
                $("#right_content").css("height" ,(datarealheight / 100 * 99));
                //$("#right_grid").css("height", tempgridheight / 100 * 99);
                //console.log($("#QRAY_FORM").height(), 'qray', (tempgridheight / 100 * 99), '(tempgridheight / 100 * 99)' ,$('#binder-form').height(), '$(\'#binder-form\').height()')
                //$("#right_grid").css("height", (tempgridheight / 100 * 99) - $('#binder-form').height() - $('.ax-button-group').height());
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
                        <ax:td label='배너명' width="350px">
                            <div class="input-group" style="width:100%">
                                <input type="text" class="form-control" name="KEYWORD" id="KEYWORD"
                                       style="width:100%"/>
                            </div>
                        </ax:td>
                    </ax:tr>
                </ax:tbl>
            </ax:form>
        </div>

        <%-- 그리드 영역 시작 --%>
        <div style="width:100%;overflow:hidden;">
            <div style="width:100%;overflow:hidden;">
                <div class="ax-button-group" data-fit-height-aside="grid-view-01" id="left_title" name="왼쪽그리드타이틀">
                    <div class="left">
                        <h2>
                        </h2>
                            <%--
                            <h2>
                                <i class="icon_list"></i> 거래처리스트
                            </h2>
                            --%>
                    </div>
                    <div class="right">
                        <button type="button" class="btn btn-small" data-grid-view-01-btn="add" style="width:80px;"><i
                                class="icon_add"></i><ax:lang id="ax.admin.add"/></button>
                        <button type="button" class="btn btn-small" data-grid-view-01-btn="delete" style="width:80px;">
                            <i class="icon_del"></i> <ax:lang id="ax.admin.delete"/></button>
                    </div>
                </div>



                <div data-ax5grid="grid-view-01"
                     data-ax5grid-config="{  showLineNumber: true,showRowSelector: false, multipleSelect: false,lineNumberColumnWidth: 40,rowSelectorColumnWidth: 27, }"
                     id = "left_grid"
                     name="왼쪽그리드"
                ></div>

            </div>

        </div>


    </jsp:body>
</ax:layout>