<%@ page import="com.chequer.axboot.core.utils.MessageUtils" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>

<ax:set key="title" value="공지사항"/>
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
            
            var dl_BOARD_SP = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'MA00028');
            var CONDITION = [
                {value: "COM", text: "제목+내용"},
                {value: "SUB", text: "제목"},
                {value: "CON", text: "내용"},
                {value: "AUT", text: "작성자"}
            ];

            $("#BOARD_SP").ax5select({options: dl_BOARD_SP});
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
                        url: ["Bbs", "select"],
                        data: JSON.stringify({
                            BOARD_TYPE: 'notice',
                            BOARD_SP: $('[data-ax5select="BOARD_SP"]').ax5select("getValue")[0].value,
                            CONDITION: $('[data-ax5select="CONDITION"]').ax5select("getValue")[0].value,
                            KEYWORD: $("#KEYWORD").val()
                        }),
                        callback: function (res) {
                            caller.gridView01.clear();
                            caller.gridView02.clear();
                            fnObj.gridView01.target.setData(res.list);
                            
                            if (res.list.length <= afterIndex) {
                            	afterIndex = 0
                            }
                            fnObj.gridView01.target.select(afterIndex);
                            
                            ACTIONS.dispatch(ACTIONS.ITEM_CLICK);
                        }
                    });
                },
                ITEM_CLICK: function (caller, act, data) {
                	caller.gridView02.clear();
                    var selected = fnObj.gridView01.getData('selected')[0];

                    if (nvl(selected) == ''){
						return;
                    }
                    
                    axboot.ajax({
                        type: "POST",
                        url: ["Bbs", "selectDtl"],
                        data: JSON.stringify({
                            BOARD_TYPE: selected.BOARD_TYPE,
                            SEQ: selected.SEQ
                            
                        }),
                        callback: function (res) {
                            if (res.list.length > 0) {
                                caller.gridView02.setData(res);
                            }
                        }
                    });
                },
                //저장버튼
                PAGE_SAVE: function (caller, act, data) {
                    var saveData = [].concat(caller.gridView01.getData("modified"));
                    saveData = saveData.concat(caller.gridView01.getData("deleted"));

                    if (saveData.length == 0){
						qray.alert('변경된 데이터가 존재하지않습니다.');
						return;
                    }
                    
                    qray.confirm({
                        msg: "저장하시겠습니까?"
                    }, function () {
                        if (this.key == "ok") {
                            
                            axboot.ajax({
                                type: "PUT",
                                url: ["Bbs", "save"],
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
                SMS_MESSAGE: function(caller, act, data){
                	var saveData = [].concat(caller.gridView01.getData("modified"));
                    saveData = saveData.concat(caller.gridView01.getData("deleted"));
                    if (saveData.length > 0){
						qray.alert('변경된 데이터가 존재합니다.<br>저장 후 진행해주십시오');
						return;
                    }
                    
                	var data = caller.gridView01.getData('selected')[0];
                	if (nvl(data) == ''){
						qray.alert('선택된 데이터가 없습니다.');
						return;
                    }
                	/* if (data.BOARD_SP != '02'){
						qray.alert('게시판유형이 알림인 데이터만<br>문자메세지를 보낼 수 있습니다.');
						return true;
					} */
                	if (nvl(data.TITLE) == ''){
						qray.alert('제목을 입력해주십시오.');
						return true;
					}
                	if (nvl(data.CONTENTS) == ''){
						qray.alert('내용을 입력해주십시오.');
						return true;
					}
                	userCallBack = function(e){
                    	modal.close();
                   
                		var strTelList = [], user_id = [], SUBJECT = "", DATE = "", CONTENT = "", BOARD_TYPE = "", SEQ = "", BOARD_SP = "";
                	
	                	qray.confirm({
	                        msg: "문자메세지를 보내시겠습니까?"
	                    }, function () {
	                        if (this.key == "ok") {
		                        
								for (var i = 0 ; i < e.length ; i ++){
									strTelList.push(e[i].HP_NO);
									user_id.push({
										USER_ID : e[i].USER_ID
									})
								}
								SEQ = data.SEQ;
								BOARD_TYPE = data.BOARD_TYPE;
	                          	SUBJECT = data.TITLE;
	                          	CONTENT = data.CONTENTS;
	                          	BOARD_SP = data.BOARD_SP;
	                          	
	                            axboot.ajax({
	                                type: "POST",
	                                url: ["common", "SendMessage"],
	                                data: JSON.stringify({
	                                	strTelList : strTelList,
	                                	SUBJECT : SUBJECT,
	                                	DATE : DATE,
	                                	CONTENT : CONTENT
	                                }),
	                                callback: function (res) {
	                                    console.log(res);
	                                    var msg = res.map.MSG;
                                    	axboot.ajax({
                                            type: "PUT",
                                            url: ["Bbs", "saveNotice"],
                                            data: JSON.stringify({
                                            	USER_ID: user_id,
                                            	BOARD_TYPE : BOARD_TYPE,
                                            	BOARD_SP   : BOARD_SP,
                                            	SEQ        : SEQ
                                            }),
                                            callback: function (res) {
                                            	qray.alert(msg).then(function(){
                                                    ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                                                });
                                            }
                                        });
	                                }
	                            });
	                            
	                        }
	                    });
                	}
                	
                	$.openCommonPopup("multiUserNotice", "userCallBack", 'HELP_USER_NOTICE', '', {PT_SP : '06' }, 600, _pop_height, _pop_top);
						
                },
                //상단추가버튼
                ITEM_ADD1: function (caller, act, data) {
                    caller.gridView01.addRow();
                    var lastIdx = nvl(caller.gridView01.target.list.length, caller.gridView01.lastRow());
                    caller.gridView01.target.select(lastIdx - 1);
                    caller.gridView01.target.focus(lastIdx - 1);
                    afterIndex  = lastIdx - 1;

                    caller.gridView01.target.setValue(lastIdx - 1,'BOARD_TYPE', 'notice');
                    caller.gridView01.target.setValue(lastIdx - 1,'HIT', 0);

                    caller.gridView02.clear();

                },
                ITEM_DEL1: function (caller, act, data) {
                	var data = caller.gridView01.getData('selected')[0];
                	if (nvl(data) == ''){
						qray.alert('선택된 데이터가 없습니다.');
						return;
                    }
                    
                    qray.confirm({
                        msg: "삭제 하시겠습니까?"
                    }, function () {
                        if (this.key == "ok") {
                        	var beforeIdx = fnObj.gridView01.target.selectedDataIndexs[0];
                            var dataLen = fnObj.gridView01.target.getList().length;

                            if ((beforeIdx + 1) == dataLen) {
                                beforeIdx = beforeIdx - 1;
                            }

                            fnObj.gridView01.delRow('selected');

                            if (beforeIdx > 0 || beforeIdx == 0) {
                                fnObj.gridView01.target.select(beforeIdx);
                                afterIndex = beforeIdx;
                            }
                            ACTIONS.dispatch(ACTIONS.ITEM_CLICK);
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
                        showLineNumber: true,
                        showRowSelector: false,
                        multipleSelect: false,
                        lineNumberColumnWidth: 40,
                        rowSelectorColumnWidth: 27,
                        target: $('[data-ax5grid="grid-view-01"]'),
                        columns: [
                            {key: "COMPANY_CD", label: "회사코드", width: 150 , align: "center" ,hidden:true},
                            {key: "BOARD_TYPE", label: "게시판타입", width: 100 , editor: {type: "text"}, align: "left",sortable: true, hidden:true},
                            {key: "SEQ", label: "채번", width: 150 , editor: {type: "text"}, align: "left",sortable: true, hidden:true},
                            {key: "BOARD_SP", label: "게시판유형", width: 100 , align: "center" , sortable: true,
                                formatter: function () {
                                    return $.changeTextValue(dl_BOARD_SP, this.value)
                                },
                                editor: {type: "select", config: {columnKeys: {optionValue: "value", optionText: "text"}, options: dl_BOARD_SP},}
                            },
                            {key: "TITLE", label: "제목", width: 220, align: "left" ,sortable: true, editor: {type:"textarea"}},
                            {key: "CONTENTS", label: "내용", width: "*" , align: "left" ,sortable: true, editor: {type:"textarea"}},
                            {key: "HP_NO", label: "전화번호", width: "*" , align: "left" ,sortable: true, hidden:true, },
                           /*  {key: "ID_USER", label: "알림대상자", width: 120 , align: "left" ,sortable: true,
                            	picker: {
                                    top: _pop_top,
                                    width: 600,
                                    height: _pop_height,
                                    url: "multiUserNotice",
                                    action: ["commonHelp", "HELP_USER_NOTICE"],
                                  	param: function () {
                                      	return {
                                      		PT_SP : '06'
                                        }
                                  	},
                                  	disabled: function () {
										if (this.item.BOARD_SP != '02'){
											qray.alert('게시판유형이 알림인 데이터만<br>알림대상자를 넣을 수 있습니다.');
											return true;
										}else{
											return false;
										}
                                  	},
                                    callback: function (e) {
                                        if (e.length > 0){
											if (e.length  == 1){
												fnObj.gridView01.target.setValue(this.dindex, 'ID_USER', e[0].ID_USER);
											}else{
												fnObj.gridView01.target.setValue(this.dindex, 'ID_USER', e[0].ID_USER + " 외 " + (e.length - 1));
												var hp_no = [];
												for (var i = 0 ; i < e.length ; i ++){
													hp_no.push(e[i].HP_NO);
												}
												fnObj.gridView01.target.list[this.dindex]['HP_NO'] = hp_no;
											}
                                        }
                                        
                                        modal.close();
                                    }
                            	}
                            }, */
                            {key: "USER_NM", label: "처리자", width: 120 , align: "left" ,sortable: true, hidden:true},
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
                                ACTIONS.dispatch(ACTIONS.ITEM_CLICK);
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
                        },
                        "sms": function(){
                        	ACTIONS.dispatch(ACTIONS.SMS_MESSAGE);
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

            fnObj.gridView02 = axboot.viewExtend(axboot.gridView, {
                page: {
                    pageNumber: 0,
                    pageSize: 10
                },
                initView: function () {
                    var _this = this;

                    this.target = axboot.gridBuilder({
                    	showLineNumber: false,
                        showRowSelector: false,
                        multipleSelect: false,
                        lineNumberColumnWidth: 40,
                        rowSelectorColumnWidth: 27,
                        target: $('[data-ax5grid="grid-view-02"]'),
                        columns: [
                            {key: "COMPANY_CD", label: "회사코드", width: 150 , align: "center" ,hidden:true},
                            {key: "BOARD_TYPE", label: "게시판타입", width: 100 , editor: {type: "text"}, align: "left",sortable: true, hidden:true},
                            {key: "BOARD_SP", label: "채번", width: 150 , editor: {type: "text"}, align: "left",sortable: true, hidden:true},
                            {key: "SEQ", label: "채번", width: 150 , editor: {type: "text"}, align: "left",sortable: true, hidden:true},
                            {key: "NOTICE_SEQ", label: "채번", width: 150 , editor: {type: "text"}, align: "left",sortable: true, hidden:true},
                            {key: "USER_ID", label: "알림대상자 아이디", width: 120 , align: "left" ,sortable: true},
                            {key: "USER_NM", label: "알림대상자", width: 120 , align: "left" ,sortable: true},
                            {key: "DTS_INSERT", label: "알림일자", width: 150 , align: "center" , editor: false, sortable: true,},
                            {key: "INSERT_ID", label: "처리자아이디", width: 150 , align: "center" , editor: {type: "text"},hidden:true},
                            {key: "UPDATE_ID", label: "변경자아이디", width: 150 , align: "center" , editor: {type: "text"},hidden:true},
                            {key: "UPDATE_DT", label: "변경일자", width: 150 , align: "center" , editor: {type: "text"},hidden:true},
                        ],
                        body: {
                            onDataChanged: function () {

                            },
                            //444
                            onClick: function () {
                               
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
                    return ($("div [data-ax5grid='grid-view-02']").find("div [data-ax5grid-panel='body'] table tr").length)
                }
                , sort: function () {
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

                $("#left_grid").css("height" ,tempgridheight / 100 * 99  );
                $("#right_grid").css("height", tempgridheight / 100 * 99  );
                //$("#right_grid").css("height", tempgridheight / 100 * 99);
                //console.log($("#QRAY_FORM").height(), 'qray', (tempgridheight / 100 * 99), '(tempgridheight / 100 * 99)' ,$('#binder-form').height(), '$(\'#binder-form\').height()')
                //$("#right_grid").css("height", (tempgridheight / 100 * 99) - $('#binder-form').height() - $('.ax-button-group').height());
                /*
                alert($("#ax-base-root").height()); // 컨텐츠영역높이
                ax-base-title //타이틀부분높이(class)
                ax-base-content //검색조건높이(class)
                 */
            }

            $("#test").click(function(){
                var path;
            	var promptDialog = new ax5.ui.dialog();
                promptDialog.setConfig({
                    title: "XXX",
                    theme: "danger"
                });
                promptDialog.prompt({
                    title: "Confirm Title",
                    msg: 'Confirm message'
                }, function () {
                    console.log(this);
                    if (this.key == 'ok'){
                    	path = this.input.value

                    	axboot.ajax({
                            type: "POST",
                            url: ["commonfile", "fileClear"],
                            data : JSON.stringify({
        						path : path
                            }),
                            callback: function (res) {
                                qray.alert("ok");
                                return;
                            }
                    	});
                    }
                    // {key: "ok", value: [User Input Data]}
                });
                
            	
            })
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
                        <ax:td label='게시판유형' width="350px">
                            <div id="BOARD_SP" name="BOARD_SP" data-ax5select="BOARD_SP"
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
        <div style="width:100%;overflow:hidden">
            <div style="width:71%;overflow:hidden;float:left;">
                <div class="ax-button-group" data-fit-height-aside="grid-view-01" id="left_title" name="왼쪽그리드타이틀">
                    <div class="left">
                    </div>
                    <div class="right">
                    	<!-- <button type="button" class="btn btn-small" id="test" style="width:80px;">테스트</button> -->
                        <button type="button" class="btn btn-small" data-grid-view-01-btn="add" style="width:80px;"><i
                                class="icon_add"></i><ax:lang id="ax.admin.add"/></button>
                        <button type="button" class="btn btn-small" data-grid-view-01-btn="delete" style="width:80px;">
                            <i class="icon_del"></i> <ax:lang id="ax.admin.delete"/></button>
                            <button type="button" class="btn btn-small" data-grid-view-01-btn="sms" style="width:80px;">문자메세지</button>
                    </div>
                </div>

                <div data-ax5grid="grid-view-01"
                     data-ax5grid-config="{  }"
                     id = "left_grid"
                ></div>

            </div>

            <div style="width:28%;overflow:hidden;float:right;">
                <div class="ax-button-group" data-fit-height-aside="grid-view-02" id="left_title2" name="왼쪽그리드타이틀">
                    <div class="left">
                        <h2>
                            <i class="icon_list"></i> 알림리스트
                        </h2>
                    </div>
                </div>

                <div data-ax5grid="grid-view-02"
                     data-ax5grid-config="{  }"
                     id = "right_grid"
                ></div>
            </div>

            </div>
        </div>


    </jsp:body>
</ax:layout>
