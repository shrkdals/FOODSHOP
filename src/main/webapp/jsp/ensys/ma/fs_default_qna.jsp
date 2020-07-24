<%@ page import="com.chequer.axboot.core.utils.MessageUtils" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>

<ax:set key="title" value="자주묻는질문"/>
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
            var today = new Date();
            var dtF = ax5.util.date(today, {"return": "yyyy-MM-01"});
            var dtT = ax5.util.date(today, {"return": "yyyy-MM"}) + '-' + ax5.util.daysOfMonth(today.getFullYear(), today.getMonth());
            var dtNow = ax5.util.date(today, {"return": "yyyy-MM-dd"});
            var dl_QNA_TYPE = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'MA00029');
            var CONDITION = [
                {value: "COM", text: "제목+내용"},
                {value: "SUB", text: "제목"},
                {value: "CON", text: "내용"},
                {value: "AUT", text: "작성자"}
            ];

            $("#QNA_TYPE").ax5select({options: dl_QNA_TYPE});
            $('#CONDITION').ax5select({options: CONDITION});

            var picker = new ax5.ui.picker();
            picker.bind({
                target: $('[data-ax5picker="basic"]'),
                direction: "auto",
                content: {
                    width: 270,
                    margin: 10,
                    type: 'date',
                    config: {
                        control: {
                            left: '<i class="cqc-chevron-left"></i>',
                            yearTmpl: '%s',
                            monthTmpl: '%s',
                            right: '<i class="cqc-chevron-right"></i>'
                        },
                        lang: {
                            yearTmpl: "%s년",
                            months: ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12'],
                            dayTmpl: "%s"
                        }
                    }
                },
                onStateChanged: function () {
                },
                btns: {
                    today: {
                        label: "오늘", onClick: function () {

                            $("#EVENT_ST_DTE").val(dtNow);
                            $("#EVENT_ED_DTE").val(dtNow);
                            this.self.close();
                        }
                    },
                    thisMonth: {
                        label: "이번달", onClick: function () {
                            $("#EVENT_ED_DTE").val(dtT);
                            $("#EVENT_ST_DTE").val(dtF);
                            this.self.close();
                        }
                    },
                    ok: {label: "확인", theme: "default"}
                }
            });
            var fnObj = {}, CODE = {};
            var ACTIONS = axboot.actionExtend(fnObj, {
                //조회버튼
                PAGE_SEARCH: function (caller, act, data) {
                    axboot.ajax({
                        type: "POST",
                        url: ["defaultQna", "search"],
                        data: JSON.stringify({
                            QNA_TYPE: $('[data-ax5select="QNA_TYPE"]').ax5select("getValue")[0].value,
                            CONDITION: $('[data-ax5select="CONDITION"]').ax5select("getValue")[0].value,
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
                    saveData = saveData.concat(caller.gridView01.getData("deleted"));
                    qray.confirm({
                        msg: "저장하시겠습니까?"
                    }, function () {
                        if (this.key == "ok") {
                            axboot.ajax({
                                type: "POST",
                                url: ["defaultQna", "save"],
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

                },
                ITEM_DEL1: function (caller, act, data) {
                    qray.confirm({
                        msg: "삭제 하시겠습니까?<br>삭제할 데이터가 많으면, 느려질 수 있습니다."
                    }, function () {
                        if (this.key == "ok") {

                        }
                    });
                    var beforeIdx = fnObj.gridView01.target.selectedDataIndexs[0];
                    var dataLen = fnObj.gridView01.target.getList().length;

                    if ((beforeIdx + 1) == dataLen) {
                        beforeIdx = beforeIdx - 1;
                    }

                    var count = 0 ;
                    var grid = caller.gridView01.target.list;
                    var i = grid.length;
                    while (i--) {
                        var data = caller.gridView01.target.list[i];
                        if (data.CHK == 'Y') {
                            fnObj.gridView01.delRow(i);
                            count++;
                        }
                    }
                    i = null;

                    if (count == 0) {
                        qray.alert("삭제할 데이터가 없습니다.");
                        return false;
                    }

                    if (beforeIdx > 0 || beforeIdx == 0) {
                        fnObj.gridView01.target.select(beforeIdx);
                    }
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
                            {
                                key: "CHK", width: 40, align: "center", dirty:false,
                                label: '<div id="headerBox" data-ax5grid-editor="checkbox" data-ax5grid-checked="false" data-ax5grid-column-selected="true" style="height:17px;width:17px;margin-top:2px;  onclick="javascript:alert(1);"></div>',
                                editor: {
                                    type: "checkbox", config: {height: 17, trueValue: 'Y', falseValue: 'N'}
                                }
                            },
                            {key: "COMPANY_CD", label: "회사코드", width: 150 , align: "center" ,hidden:true},
                            {key: "SEQ", label: "채번", width: 150 , editor: {type: "text"}, align: "left",sortable: true, hidden:true},
                            {key: "QNA_TYPE", label: "질문유형", width: 150 , align: "left" , sortable: true,
                                formatter: function () {
                                    return $.changeTextValue(dl_QNA_TYPE, this.value)
                                },
                                editor: {type: "select", config: {columnKeys: {optionValue: "value", optionText: "text"}, options: dl_QNA_TYPE},}
                            },
                            {key: "QUESTION", label: "질문", width: "*" , align: "left" ,sortable: true, editor: {type:"textarea"}},
                            {key: "ANSWER", label: "대답", width: "*" , align: "left" ,sortable: true, editor: {type:"textarea"}},
                            {key: "USER_NM", label: "처리자", width: 120 , align: "left" ,sortable: true,},
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
                    axboot.buttonClick(this, "data-grid-view-01-btn", {
                        "delete": function () {
                            ACTIONS.dispatch(ACTIONS.ITEM_DEL1);
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

            function isChecked(data) {
                var array = [];
                for (var i = 0; i < data.length; i++) {
                    if (data[i].CHK == 'Y') {
                        array.push(data[i])
                    }
                }
                return array;
            }

            var cnt = 0;
            $(document).on('click', '#headerBox', function(e) {
                if(cnt == 0){
                    $("div [data-ax5grid='grid-view-01']").find("div #headerBox").attr("data-ax5grid-checked",true);
                    cnt++;
                    var gridList = fnObj.gridView01.getData();
                    gridList.forEach(function(e, i){
                        fnObj.gridView01.target.setValue(i,"CHK",'Y');
                    });
                    $("div [data-ax5grid-editor='checkbox']").attr("data-ax5grid-checked",true)
                }else{
                    $("div [data-ax5grid='grid-view-01']").find("div #headerBox").attr("data-ax5grid-checked",false);
                    cnt = 0;
                    var gridList = fnObj.gridView01.getData();
                    gridList.forEach(function(e, i){
                        fnObj.gridView01.target.setValue(i,"CHK",'N');
                    });
                    $("div [data-ax5grid-editor='checkbox']").attr("data-ax5grid-checked",false)
                }

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
                        <ax:td label='질문유형' width="350px">
                            <div id="QNA_TYPE" name="QNA_TYPE" data-ax5select="QNA_TYPE"
                                 data-ax5select-config='{edit:false}'></div>
                        </ax:td>
                        <ax:td label='조회조건' width="350px">
                            <div id="CONDITION" name="CONDITION" data-ax5select="CONDITION"
                                 data-ax5select-config='{edit:false}'></div>
                        </ax:td>
                        <ax:td label='검색어' width="350px">
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