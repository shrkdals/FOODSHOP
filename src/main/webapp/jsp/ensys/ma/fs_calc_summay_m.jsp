<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>

<ax:set key="title" value="정산관리"/>
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
            .warning {
                background: #ffe0cf !important;
            }
        </style>
        <script type="text/javascript">
        
        	var dl_ADJUST_SP_list = $.DATA_SEARCH('commition','getCommitionHList',{CD_COMPANY:SCRIPT_SESSION.cdCompany , KEYWORD : ''}).list;
        	var dl_ADJUST_SP = [{
        		CODE: '',
                code: '',
                value: '',
                VALUE: '',
                text: '',
                TEXT: ''
            }];
        	for (var i = 0 ; i < dl_ADJUST_SP_list.length ; i ++){
            	var n = dl_ADJUST_SP_list[i];
            	dl_ADJUST_SP.push({
                    CODE: n.COMT_CD,
                    code: n.COMT_CD,
                    value: n.COMT_CD,
                    VALUE: n.COMT_CD,
                    text: n.COMT_NM,
                    TEXT: n.COMT_NM
                });
           	}
        	var dl_PT_SP         = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'MA00002');
	        $("#PT_SP").ax5select({options: dl_PT_SP});
	        $("#ADJUST_SP").ax5select({options: dl_ADJUST_SP});
	        
        	$("#TRANS_YN").ax5select({options: [{value: '', text: ''}, {value: 'Y', text: 'Y'}, {value: 'N', text: 'N'}]})
            
            var fnObj = {}, CODE = {};
            var ACTIONS = axboot.actionExtend(fnObj, {
                PAGE_SEARCH: function (caller, act, data) {
                	axboot.ajax({
                        type: "POST",
                        url: ["calcSummary", "selectH"],
                        data: JSON.stringify({
                        	ADJUST_DT_ST: $('#ADJUST_DT').getStartDate().replace(/-/g, ""),
                         	ADJUST_DT_ED: $('#ADJUST_DT').getEndDate().replace(/-/g, ""),
                         	PT_NM: $("#PT_NM").val(),
                         	TRANS_YN : $('select[name="TRANS_YN"]').val(),
                         	ADJUST_SP: $('select[name="ADJUST_SP"]').val(),
                         	PT_SP: $('select[name="PT_SP"]').val(),
                        }),
                        callback: function (res) {
                            caller.gridView01.clear();
                            if (res.list.length > 0) {
                                caller.gridView01.setData(res);
                            }
                        }
                    });
                },
                ITEM_FUND_TRANSFER: function(caller, act, data){
					qray.confirm({
                        msg: "자금이체하시겠습니까?"
                    }, function () {
                        if (this.key == "ok") {
                        	var count = 0 ;
                        	var chkVal = false;
                            var grid = caller.gridView01.target.list;
                            var i = grid.length;
                            var listData = [];
                            while (i--) {
                                var data = caller.gridView01.target.list[i];
                                if (data.CHK == 'Y') {
                                    count++;
                                    listData.push(data);
                                    if (data.TRANS_YN == 'Y'){
                                    	chkVal = true;
                                    	break;
                                    }
                                    
                                }
                            }
                            i = null;

                            if (chkVal){
                            	qray.alert("이미 이체된 데이터가 존재합니다.");
                                return false;
                            }
                            if (count == 0) {
                                qray.alert("체크한 데이터가 없습니다.");
                                return false;
                            }

                            axboot.ajax({
                                type: "POST",
                                url: ["calcSummary", "FundTransfer"],
                                data: JSON.stringify({
                                	list : listData
                                }),
                                callback: function (res) {
                                    qray.alert('자금이체 되었습니다.').then(function(){
                                    	ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                                    })
                                }
                            });
                        }
                    });
                },
                ITEM_OK: function (caller, act, data){
                	qray.confirm({
                        msg: "확정하시겠습니까?"
                    }, function () {
                        if (this.key == "ok") {
                        	var count = 0 ;
                        	var chkVal = false;
                        	var listData = [];
                            var grid = caller.gridView01.target.list;
                            var i = grid.length;
                            while (i--) {
                                var data = caller.gridView01.target.list[i];
                                if (data.CHK == 'Y') {
                                    count++;
                                    listData.push(data);
                                    if (data.CP_YN == 'Y'){
                                    	chkVal = true;
                                    	break;
                                    }
                                }
                            }
                            i = null;
                            if (chkVal) {
                                qray.alert("이미 확정된 데이터가 존재합니다.");
                                return false;
                            }
                            if (count == 0) {
                                qray.alert("체크한 데이터가 없습니다.");
                                return false;
                            }

                            axboot.ajax({
                                type: "POST",
                                url: ["calcSummary", "approve"],
                                data: JSON.stringify({
                                	list: listData
                                }),
                                callback: function (res) {
                                    qray.alert('확정되었습니다.').then(function(){
                                    	ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                                    })
                                }
                            });
                        }
                    });
                }
            });
            // fnObj 기본 함수 스타트와 리사이즈
            fnObj.pageStart = function () {
                this.pageButtonView.initView();
                this.searchView.initView();
                this.gridView01.initView();
                // this.gridView02.initView();
                if (SCRIPT_SESSION.cdGroup != 'WEB03' && SCRIPT_SESSION.cdGroup != 'WEB04'){
					$("#btnOk").remove();
                }
				if (SCRIPT_SESSION.cdGroup != 'WEB01'){
					$("#btnFundTransfer").remove();
				}
                
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

            //== view 시작
            fnObj.searchView = axboot.viewExtend(axboot.searchView, {
                initView: function () {
                    this.target = $(document["searchView0"]);
                    this.target.attr("onsubmit", "return ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);");
                },
                getData: function () {
                    return {
                    }
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
                        frozenColumnIndex: 4,
                        target: $('[data-ax5grid="grid-view-01"]'),
                        columns: [
                        	{
                            key: "CHK", width: 40, align: "center", dirty:false,
                            label: '<div id="headerBox" data-ax5grid-editor="checkbox" data-ax5grid-checked="false" data-ax5grid-column-selected="true" style="height:17px;width:17px;margin-top:2px;  onclick="javascript:alert(1);"></div>',
                                editor: {
                                    type: "checkbox", config: {height: 17, trueValue: 'Y', falseValue: 'N'}
                                }
                            }
                            
                            ,{key: "COMPANY_CD"      , label: ""                , width: 150, align: "left" , sortabled:true ,  hidden:true , editor: false }
                            ,{key: "ADJUST_NO"       , label: "정산번호"        , width: 150, align: "left" , sortabled:true ,  hidden:true , editor: false }
                            ,{key: "ADJUST_DT"       , label: "정산일자"        , width: 120, align: "center" , sortabled:true ,  hidden:false , editor: false,
								formatter: function () {
                                    var returnValue = this.item.ADJUST_DT;
                                    if (nvl(this.item.ADJUST_DT, '') != '') {
                                        this.item.ADJUST_DT = this.item.ADJUST_DT.replace(/\-/g, '');
                                        returnValue = this.item.ADJUST_DT.replace(/(\d{4})(\d{2})(\d{2})/, '$1-$2-$3');
                                    }
                                    return returnValue;
                                }
	         				 }
                            ,{key: "ADJUST_PT_CD"    , label: "정산거래처코드"  , width: 150, align: "center" , sortabled:true ,  hidden:false , editor: false }
                            ,{key: "ADJUST_PT_NM"    , label: "정산거래처명"    , width: 150, align: "left" , sortabled:true ,  hidden:false , editor: false }
                            ,{key: "ADJUST_SP"       , label: "정산유형"        , width: 150, align: "left" , sortabled:true ,  hidden:false , editor: false,
                            	formatter: function () {
                                    return $.changeTextValue(dl_ADJUST_SP, this.value)
                                },
                             }
                            ,{key: "ADJUST_AMT"      , label: "정산금액"        , width: 120, align: "right" , sortabled:true ,  hidden:false , editor: false, formatter: "money" }
                            ,{key: "ADJUST_ACCUM_AMT"  , label: "정산누적금액"        , width: 120, align: "right" , sortabled:true ,  hidden:false , editor: false, formatter: "money",  }
                            ,{key: "CP_YN"           , label: "확정여부"        , width: 90, align: "center" , sortabled:true ,  hidden:false , editor: false }
                            ,{key: "TRANS_YN"        , label: "이체여부"        , width: 90, align: "center" , sortabled:true ,  hidden:false , editor: false,
                            	styleClass: function(){
									if (nvl(this.item.TRANS_DT,'') != ''){
	                                    var trans_dt = this.item.TRANS_DT;
	                                    var nowDate = ax5.util.date(today, {"return": "yyyyMMdd"});
	                                    console.log(nowDate);
	                                    if ( Number(trans_dt.replace(/\-/g, '')) <  nowDate){
	                                        if (nvl(this.item.TRANS_YN, 'N') == 'N'){
	                                    		return "warning";
	                                        }
	                                    }
	                                    
	                                }
								}
                             }
                            ,{key: "TRANS_DT"        , label: "이체일시"        , width: 120, align: "center" , sortabled:true ,  hidden:false , editor: false,
								formatter: function () {
                               		var returnValue = this.item.TRANS_DT;
                              	 	if (nvl(this.item.TRANS_DT, '') != '') {
	                                   	this.item.TRANS_DT = this.item.TRANS_DT.replace(/\-/g, '');
	                                   	returnValue = this.item.TRANS_DT.replace(/(\d{4})(\d{2})(\d{2})/, '$1-$2-$3');
                                    }
                                    return returnValue;
	      						 }
							}
	        				,{key: "PAYMENTS_DT"        , label: "지급일자"        , width: 120, align: "center" , sortabled:true ,  hidden:false , editor: false,
								formatter: function () {
                               		var returnValue = this.item.PAYMENTS_DT;
                               	 	if (nvl(this.item.PAYMENTS_DT, '') != '') {
                                      	this.item.PAYMENTS_DT = this.item.PAYMENTS_DT.replace(/\-/g, '');
                                      	returnValue = this.item.PAYMENTS_DT.replace(/(\d{4})(\d{2})(\d{2})/, '$1-$2-$3');
                                    }
                                    return returnValue;
		 						}
                            }
                            ,{key: "VIEW_ORDERLIST"  , label: "주문내역보기"        , width: 120, align: "center" , sortabled:true ,  hidden:false , editor: false,
                            	formatter: function () {
                                    return "[보기]";
                                },
                             }
                        ],
                        footSum: [
                            [
                                {label: "", colspan: 5, align: "center"},
                                {key: "ADJUST_AMT", collector: "sum", formatter: "money", align: "right"},
                                {key: "ADJUST_ACCUM_AMT", collector: "sum", formatter: "money", align: "right"}
                            ]
                        ],
                        body: {
                        	/* trStyleClass: function () {
                                if (nvl(this.item.TRANS_DT,'') != ''){
                                    var trans_dt = this.item.TRANS_DT;
                                    var nowDate = ax5.util.date(today, {"return": "yyyyMMdd"});
                                    console.log(nowDate);
                                    if ( Number(trans_dt.replace(/\-/g, '')) <  nowDate){
                                        if (nvl(this.item.TRANS_YN, 'N') == 'N'){
                                    		return "warning";
                                        }
                                    }
                                    
                                }
                            }, */
                        	mergeCells: ["ADJUST_DT", "ADJUST_PT_CD", "ADJUST_PT_NM"],
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
                                        height: _pop_height,
                                        top: _pop_top,
                                        iframe: {
                                            method: "get",
                                            url: "../help/calcItemHelper.jsp",
                                            param: "callBack=userCallBack"
                                        },
                                        sendData: function () {
                                            return {
                                                initData: {
                                                	ADJUST_DT: data.ADJUST_DT,
                                                	ADJUST_NO: data.ADJUST_NO,
                                                	JOIN_PT_CD: data.ADJUST_PT_CD,
                                                }
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
                        "ok": function () {
                            ACTIONS.dispatch(ACTIONS.ITEM_OK);
                        },
	    "FundTransfer": function(){
	         ACTIONS.dispatch(ACTIONS.ITEM_FUND_TRANSFER);
	    },
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

                            {key: "COMPANY_CD"         , label: ""              , width: 150, align: "left" , sortabled:true ,  hidden:true , editor: false }
                            ,{key: "MAKE_PT_CD"       , label:	"<span style=\"color:red;\"> * </span> 제조거래처코드"  , width: 150, align: "left" , sortabled:true ,  hidden:true, editor: false}
                            ,{key: "MAKE_PT_NM"       , label:	"<span style=\"color:red;\"> * </span>  제조거래처명"  , width: 150, align: "left" , sortabled:true ,  hidden:false , editor: false
                                ,picker: {
                                    top: _pop_top,
                                    width: 600,
                                    height: _pop_height,
                                    url: "partner",
                                    action: ["commonHelp", "HELP_PARTNER"],
                                    param: function () {
                                        return {PT_SP : '03'}
                                    },
                                    callback: function (e) {
                                        fnObj.gridView02.target.setValue(this.dindex, "MAKE_PT_CD", e[0].PT_CD);
                                        fnObj.gridView02.target.setValue(this.dindex, "MAKE_PT_NM", e[0].PT_NM);
                                    }
                                    ,disabled: function () {
                                        if(this.item.MAKE_VERIFY_YN == 'Y' && this.item.DISTRIB_VERIFY_YN == 'Y'){
                                            return true;
                                        }
                                    }
                                }
                            }
                            ,{key: "ITEM_CD"          , label: "<span style=\"color:red;\"> * </span> 상품코드"	      , width: 150, align: "left" , sortabled:true , required:true ,  hidden:true , editor: false }
                            ,{key: "ITEM_NM"          , label: "<span style=\"color:red;\"> * </span> 상품명"		  , width: 150, align: "left" , sortabled:true , required:true ,  hidden:false , editor: false
                                ,picker: {
                                    top: _pop_top,
                                    width: 600,
                                    height: _pop_height,
                                    url: "item",
                                    action: ["commonHelp", "HELP_ITEM"],
                                    param: function () {
                                        return {PT_SP : '03'}
                                    },
                                    callback: function (e) {
                                        fnObj.gridView02.target.setValue(this.dindex, "ITEM_CD", e[0].ITEM_CD);
                                        fnObj.gridView02.target.setValue(this.dindex, "ITEM_NM", e[0].ITEM_NM);
                                    }
                                    ,disabled: function () {
                                    }
                                }
                            }
                            ,{key: "DELI_SEQ"          , label: "배송순번"              , width: 150, align: "left" , sortabled:true ,  hidden:true , editor: false }
                            ,{key: "DELI_DTE"          , label: "배송일자"              , width: 150, align: "left" , sortabled:true ,  hidden:false , editor: {type:"date"} }
                            ,{key: "DELI_NUM"          , label: "<span style=\"color:red;\"> * </span> 배송수량"              , width: 150, align: "left" , required:true , sortabled:true ,  hidden:false , editor: {type:"number"} }
                            ,{key: "CCL_PRIOD_ST_DTE"  , label: "<span style=\"color:red;\"> * </span> 유통기간시작일"              , width: 150, align: "left" , required:true , sortabled:true ,  hidden:false , editor: {type:"date"} }
                            ,{key: "CCL_PRIOD_ED_DTE"  , label: "<span style=\"color:red;\"> * </span> 유통기간종료일"              , width: 150, align: "left" , required:true , sortabled:true ,  hidden:false , editor: {type:"date"} }
                            ,{key: "VERIFY_STAT"       , label: "검증상태"              , width: 150, align: "left" , sortabled:true ,  hidden:false
                                , editor: {
                                    type: "select", config: {
                                        columnKeys: {
                                            optionValue: "value", optionText: "text"
                                        },
                                        options: VERIFY_STAT
                                    }
                                    , disabled: function () {
                                    }
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

                /*
                alert($("#ax-base-root").height()); // 컨텐츠영역높이
                ax-base-title //타이틀부분높이(class)
                ax-base-content //검색조건높이(class)
                 */
            }

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
            </div>
        </div>

        <div role="page-header" id="pageheader">
            <ax:form name="searchView0">
                <ax:tbl clazz="ax-search-tb1" minWidth="500px">
                    <ax:tr>
                    	<ax:td label='정산일자' width="450px">
                            <datepicker id="ADJUST_DT"></datepicker>
                        </ax:td> 
                        <ax:td label='거래처유형' width="280px">
                            <div id="PT_SP" name="PT_SP" data-ax5select="PT_SP"
                                 data-ax5select-config='{}' form-bind-type="selectBox"></div>
                        </ax:td> 
                        <ax:td label="거래처명" width="280px">
                            <div class="input-group" style="width:100%">
                                <input type="text" class="form-control" name="PT_NM" id="PT_NM" style="width:100%"/>
                            </div>
                        </ax:td>
                    	<ax:td label='정산유형' width="280px">
                        	<div id="ADJUST_SP" name="ADJUST_SP" data-ax5select="ADJUST_SP"
                                 data-ax5select-config='{}' form-bind-type="selectBox"></div>
                        </ax:td>
                        <ax:td label='이체여부' width="200px">
                            <div id="TRANS_YN" name="TRANS_YN" data-ax5select="TRANS_YN"
                                 data-ax5select-config='{}' form-bind-type="selectBox"></div>
                        </ax:td>
                    </ax:tr>
                </ax:tbl>
            </ax:form>
        </div>
		<div class="H10"></div>
            <div style="width:99%;overflow:hidden;">
                <div class="ax-button-group" data-fit-height-aside="grid-view-01" id="left_title" name="왼쪽그리드타이틀">
                    <div class="left">
                        <h2>
                            <i class="icon_list"></i> 정산리스트
                        </h2>
                    </div>
                    <div class="right">
                    	<button type="button" class="btn btn-small" id="btnOk" data-grid-view-01-btn="ok" style="width:80px;">
                    	확정</button>
		<button type="button" class="btn btn-small" id="btnFundTransfer" data-grid-view-01-btn="FundTransfer" style="width:80px;">
                    	자금이체</button>
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