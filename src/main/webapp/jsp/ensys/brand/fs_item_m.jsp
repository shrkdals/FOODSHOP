<%@ page import="com.chequer.axboot.core.utils.MessageUtils" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>

<ax:set key="title" value="상품마스터"/>
<ax:set key="page_desc" value="${pageRemark}"/>
<ax:set key="page_auto_height" value="true"/>



<ax:layout name="base">
    <jsp:attribute name="script">
        <ax:script-lang key="ax.script"/>
        <style>
        	.red {
        		color: red;
        	}
        	.black {
        		color: black;
        	}
        </style>
        <script type="text/javascript">

            var selectIndex = 0;
            var dl_ITEM_UNIT   = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'MA00008');   // 상품단위
            var dl_KEEP_METHOD = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'MA00009');   // 보관방법
            var dl_TAX_TP      = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'MA00025');   // 과세구분
            var dl_ITEM_SP     = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'MA00011');   // 상품유형

            var fnObj = {}, CODE = {};
            var ACTIONS = axboot.actionExtend(fnObj, {
                PAGE_SEARCH: function (caller, act, data) {
                    axboot.ajax({
                        type: "POST",
                        url: ["itemM", "search"],
                        data: JSON.stringify({
                            ITEM_NM: $("#ITEM_NM").val(),
                            MAKE_PT_CD: $("#MAKE_PT_CD").attr('code')
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
                PAGE_SAVE: function (caller, act, data) {
                    var saveData = [].concat(caller.gridView01.getData("modified"));

                    for (var i = 0 ; i < saveData.length ; i ++){
                        if (nvl(saveData[i].ITEM_NM) == ''){
                            qray.alert('상품명을 입력해주십시오.');
                            return ;
                        }
                        if (saveData[i].SALE_SUPPLY_COST + saveData[i].SALE_SURTAX != saveData[i].SALE_COST){
                        	qray.alert((i + 1) + '번째 줄<br>판매공급단가, 판매부가세의 합이 <br>판매단가와 다릅니다.');
                            return ;
                        }
                        if (saveData[i].ITEM_SUPPLY_COST + saveData[i].ITEM_SURTAX != saveData[i].ITEM_COST){
                        	qray.alert((i + 1) + '번째 줄<br>상품공급단가, 상품부가세의 합이 <br>상품단가와 다릅니다.');
                            return ;
                        }
                    }

                    saveData = saveData.concat(caller.gridView01.getData("deleted"));

                    qray.confirm({
                        msg: "저장하시겠습니까?"
                    }, function () {
                        if (this.key == "ok") {

                            qray.loading.show('저장 중입니다.').then(function () {
                                axboot.ajax({
                                    type: "POST",
                                    url: ["itemM", "save"],
                                    data: JSON.stringify({
                                        saveData: saveData
                                    }),
                                    callback: function (res) {
                                        qray.loading.hide();

                                        qray.alert("저장 되었습니다.").then(function(){
                                            ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                                            caller.gridView01.target.select(selectIndex);
                                            caller.gridView01.target.focus(selectIndex);
                                        });
                                    }
                                });
                            })
                        }
                    });



                },
                ITEM_DELETE: function(caller, act, data){
                    qray.confirm({
                        msg: "<h4>정말 삭제하시겠습니까?</h4><br>선택한 데이터가 많을 경우<br>속도저하가 될 수 있습니다."
                    }, function () {
                        if (this.key == "ok") {

                            qray.loading.show('삭제중입니다.').then(function(){
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

                                qray.loading.hide();
                            })
                        }
                    });
                },
                ITEM_ADD: function(caller, act, data){
                    caller.gridView01.addRow();
                    var lastIdx = nvl(caller.gridView01.target.list.length, caller.gridView01.lastRow());
                    selectIndex = lastIdx - 1;
                    caller.gridView01.target.select(lastIdx - 1);
                    caller.gridView01.target.focus(lastIdx - 1);


                }
            });
            // fnObj 기본 함수 스타트와 리사이즈
            fnObj.pageStart = function () {
                this.pageButtonView.initView();
                this.gridView01.initView();

                if(SCRIPT_SESSION.cdGroup != 'WEB01'){
                    $('#MAKE_PT_CD').attr('HELP_DISABLED','true')
                    $('#MAKE_PT_CD').attr('readonly','readonly')
                }

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
                        "excel": function () {

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
                                {
                                key: "CHK", width: 40, align: "center", dirty:false,
                                label: '<div id="headerBox" data-ax5grid-editor="checkbox" data-ax5grid-checked="false" data-ax5grid-column-selected="true" style="height:17px;width:17px;margin-top:2px;  onclick="javascript:alert(1);"></div>',
                                    editor: {
                                        type: "checkbox", config: {height: 17, trueValue: 'Y', falseValue: 'N'}
                                    }
                                }
                            , {key: "COMPANY_CD", label: "사업장코드"  , width: 125     , align: "center"   , editor: false  ,sortable:true , hidden:true}
                            , {key: "ITEM_CD", label: "상품코드"	 , width: 125     , alin: "center"   , editor: false  ,sortable:true}
                            , {key: "ITEM_NM", label: "상품명"	 , width: 150     , align: "left"   , editor: {type: "text"}  ,sortable:true }
                            , {key: "ITEM_UNIT", label: "상품단위", width: 80     , align: "center" ,sortable:true,
                                formatter: function () {
                                    return $.changeTextValue(dl_ITEM_UNIT, this.value)
                                },
                                editor: {type: "select", config: {columnKeys: {optionValue: "value", optionText: "text"}, options: dl_ITEM_UNIT},}
                            }
                            , {key: "BOX_NUM" , label: "박스수량"	, width: 100     , align: "right"   , sortable:true,
                                editor: {type: "number",}
                            }
                            , {key: "ITEM_WT" , label: "상품중량"	, width: 100     , align: "right", editor: {type: "text",}, sortable:true}
                            , {key: "TAX_TP" , label: "과세구분"	, width: 80     , align: "center", sortable:true,
                                formatter: function () {
                                    return $.changeTextValue(dl_TAX_TP, this.value)
                                }, 
                                editor: {type: "select", config: {columnKeys: {optionValue: "value", optionText: "text"}, options: dl_TAX_TP}}
                            }
                            , {key: "ITEM_SUPPLY_COST" , label: "상품공급단가"	, width: 120     , align: "right", sortable:true,
                                editor: {type: "number",},
                                formatter: function() {
                                    if (nvl(this.item.ITEM_SUPPLY_COST) == '') {
                                        this.item.ITEM_SUPPLY_COST = 0;
                                    }
                                    this.item.ITEM_SUPPLY_COST = Number(this.item.ITEM_SUPPLY_COST);
                                    return comma(this.item.ITEM_SUPPLY_COST);
                                },
                                styleClass: function () {
                                    if (this.item.ITEM_SUPPLY_COST + this.item.ITEM_SURTAX != this.item.ITEM_COST){
                                    	return "red";
                                    }
                                },
                            }
                            , {key: "ITEM_SURTAX" , label: "상품부가세"	, width: 120     , align: "right", sortable:true,
                                editor: {type: "number",},
                                formatter: function() {
                                    if (nvl(this.item.ITEM_SURTAX) == '') {
                                        this.item.ITEM_SURTAX = 0;
                                    }
                                    this.item.ITEM_SURTAX = Number(this.item.ITEM_SURTAX);
                                    return comma(this.item.ITEM_SURTAX);
                                },
                                styleClass: function () {
                                    if (this.item.ITEM_SUPPLY_COST + this.item.ITEM_SURTAX != this.item.ITEM_COST){
                                    	return "red";
                                    }
                                },
                            }
                            , {key: "ITEM_COST" , label: "상품단가"	, width: 120, align: "right", sortable:true,
                                editor: {type: "number",},
                                formatter: function() {
                                    if (nvl(this.item.ITEM_COST) == '') {
                                        this.item.ITEM_COST = 0;
                                    }
                                    this.item.ITEM_COST = Number(this.item.ITEM_COST);
                                    return comma(this.item.ITEM_COST);
                                },
                                styleClass: function () {
                                    if (this.item.ITEM_SUPPLY_COST + this.item.ITEM_SURTAX != this.item.ITEM_COST){
                                    	return "red";
                                    }
                                },
                            }

                            , {key: "SALE_SUPPLY_COST" , label: "판매공급단가"	, width: 120     , align: "right", sortable:true,
                                editor: {type: "number",},
                                formatter: function() {
                                    if (nvl(this.item.SALE_SUPPLY_COST) == '') {
                                        this.item.SALE_SUPPLY_COST = 0;
                                    }
                                    this.item.SALE_SUPPLY_COST = Number(this.item.SALE_SUPPLY_COST);
                                    return comma(this.item.SALE_SUPPLY_COST);
                                },
                                styleClass: function () {
                                    if (this.item.SALE_SUPPLY_COST + this.item.SALE_SURTAX != this.item.SALE_COST){
                                    	return "red";
                                    }
                                },
                            }
                            , {key: "SALE_SURTAX" , label: "판매부가세"	, width: 120     , align: "right", sortable:true,
                                editor: {type: "number",},
                                formatter: function() {
                                    if (nvl(this.item.SALE_SURTAX) == '') {
                                        this.item.SALE_SURTAX = 0;
                                    }
                                    this.item.SALE_SURTAX = Number(this.item.SALE_SURTAX);
                                    return comma(this.item.SALE_SURTAX);
                                },
                                styleClass: function () {
                                    if (this.item.SALE_SUPPLY_COST + this.item.SALE_SURTAX != this.item.SALE_COST){
                                    	return "red";
                                    }
                                },
                            }
                            , {key: "SALE_COST" , label: "판매단가"	, width: 120     , align: "right", sortable:true,
                                editor: {type: "number",},
                                formatter: function() {
                                    if (nvl(this.item.SALE_COST) == '') {
                                        this.item.SALE_COST = 0;
                                    }
                                    this.item.SALE_COST = Number(this.item.SALE_COST);
                                    return comma(this.item.SALE_COST);
                                },
                                styleClass: function () {
                                    if (this.item.SALE_SUPPLY_COST + this.item.SALE_SURTAX != this.item.SALE_COST){
                                    	return "red";
                                    }
                                },
                                
                            }
                            , {key: "SURTAX_YN" , label: "부가세여부"	, width: 80     , align: "center", sortable:true, hidden:true,
                                editor: {
                                    type: "checkbox", config: {height: 17, trueValue: 'Y', falseValue: 'N'}
                                },
                                formatter: function () {
                                    var CHK = this.item.SURTAX_YN;
                                    if (nvl(CHK, 'N') == 'N'){
                                        return '<div class="columnBox" id="columnBox' + this.dindex + '" data-ax5grid-editor="checkbox" data-ax5grid-checked="false" data-ax5grid-column-selected="true" style="height:17px;width:17px;margin-top:2px;  onclick="javascript:alert(1);"></div>';
                                    }else{
                                        return '<div class="columnBox" id="columnBox' + this.dindex + '" data-ax5grid-editor="checkbox" data-ax5grid-checked="true" data-ax5grid-column-selected="true" style="height:17px;width:17px;margin-top:2px;  onclick="javascript:alert(1);"></div>';
                                    }
                                }
                            }
                            , {key: "CCL_PRIOD_ST_DTE" , label: "유통기간시작일자"	, width: 120, align: "center", sortable:true, hidden:true,
                                editor: {type: "date", config: {separator: "-"}},
                                formatter: function () {
                                    var returnValue = this.item.CCL_PRIOD_ST_DTE;
                                    if (nvl(this.item.CCL_PRIOD_ST_DTE, '') != '') {
                                        this.item.CCL_PRIOD_ST_DTE = this.item.CCL_PRIOD_ST_DTE.replace(/\-/g, '');
                                        returnValue = $.changeDataFormat(this.item.CCL_PRIOD_ST_DTE, 'YYYYMMDD');
                                    }
                                    return returnValue;
                                }
                            }
                            , {key: "CCL_PRIOD_ED_DTE" , label: "유통기간종료일자", width: 120, align: "center", sortable:true,hidden:true,
                                editor: {type: "date", config: {separator: "-"}},
                                formatter: function () {
                                    var returnValue = this.item.CCL_PRIOD_ED_DTE;
                                    if (nvl(this.item.CCL_PRIOD_ED_DTE, '') != '') {
                                        this.item.CCL_PRIOD_ED_DTE = this.item.CCL_PRIOD_ED_DTE.replace(/\-/g, '');
                                        returnValue = $.changeDataFormat(this.item.CCL_PRIOD_ED_DTE, 'YYYYMMDD');
                                    }
                                    return returnValue;
                                }
                            }
                            , {key: "KEEP_METHOD" , label: "보관방법"	, width: 80     , align: "center", sortable:true,
                                formatter: function () {
                                    return $.changeTextValue(dl_KEEP_METHOD, this.value)
                                },
                                editor: {type: "select", config: {columnKeys: {optionValue: "value", optionText: "text"}, options: dl_KEEP_METHOD}}
                            }
                            , {key: "ORIGIN_NM" , label: "원산지명"	, width: 100     , align: "left"   , editor: {type: "text",}  ,sortable:true}
                            , {key: "MAKE_PT_CD" , label: "제조거래처코드"	, width: 130     , align: "center"   , editor: false  ,sortable:true,
                                picker: function(){
                                    return {
                                        top: _pop_top,
                                        width: 600,
                                        height: _pop_height,
                                        url: "brandPartner",
                                        action: ["commonHelp", "HELP_BRAND_PARTNER"],
                                        callback: function (e) {
                                            var itemH = fnObj.gridView01.getData('selected')[0];
                                            var index = itemH.__index;
                                            fnObj.gridView01.target.setValue(index, "MAKE_PT_CD", e[0].PT_CD);
                                            fnObj.gridView01.target.setValue(index, "MAKE_PT_NM", e[0].PT_NM);
                                        },
                                    }
                                }
                            }
                            , {key: "MAKE_PT_NM" , label: "제조거래처"	, width: 150     , align: "left"   , editor: false  ,sortable:true}
                            , {key: "ITEM_SP" , label: "상품유형"	, width: 120, align: "center", sortable:true,
                                formatter: function () {
                                    return $.changeTextValue(dl_ITEM_SP, this.value)
                                },
                                editor: {type: "select", config: {columnKeys: {optionValue: "value", optionText: "text"}, options: dl_ITEM_SP}}
                            }
                            , {key: "DISTRIB_AMT_YN" , label: "물류사지정금액여부"	, width: 120     , align: "center"   , editor: false  ,sortable:true, hidden: false,
                            	editor: {
                                    type: "checkbox", config: {height: 17, trueValue: 'Y', falseValue: 'N'}
                                },
                                formatter: function () {
                                    var CHK = this.item.SURTAX_YN;
                                    if (nvl(CHK, 'N') == 'N'){
                                        return '<div class="columnBox" id="columnBox' + this.dindex + '" data-ax5grid-editor="checkbox" data-ax5grid-checked="false" data-ax5grid-column-selected="true" style="height:17px;width:17px;margin-top:2px;  onclick="javascript:alert(1);"></div>';
                                    }else{
                                        return '<div class="columnBox" id="columnBox' + this.dindex + '" data-ax5grid-editor="checkbox" data-ax5grid-checked="true" data-ax5grid-column-selected="true" style="height:17px;width:17px;margin-top:2px;  onclick="javascript:alert(1);"></div>';
                                    }
                                }
                              }
                            , {key: "INSERT_ID" , label: ""	, width: 150     , align: "center"   , editor: false  ,sortable:true, hidden: true}
                            , {key: "INSERT_DT" , label: ""	, width: 150     , align: "center"   , editor: false  ,sortable:true, hidden: true}
                            , {key: "UPDATE_ID" , label: ""	, width: 150     , align: "center"   , editor: false  ,sortable:true, hidden: true}
                            , {key: "UPDATE_DT" , label: ""	, width: 150     , align: "center"   , editor: false  ,sortable:true, hidden: true}
                            , {key: "ITEM_BIGO", label: "상품설명", width: 150 , align: "center" , editor: {type:"text"}, sortable: true}
                            , {key: "FILE_NAME", label: "파일", width: 150 , align: "center" , editor: false, sortable: true}
                            , {key: "FILE", label: "이미지파일", width: 150 , align: "center" , editor: false, sortable: true, hidden:true}

                        ],

                        body: {
                            onDataChanged: function () {
                                var column = this.key;
                                var data = this.item;
                                var idx = this.dindex;

                                /*
                                if (column == 'SALE_SURTAX'){
                                    var amt = Number(nvl(data.SALE_SUPPLY_COST, 0));
                                    var vat = Number(nvl(data.SALE_SURTAX, 0));
                                    fnObj.gridView01.target.setValue(idx, 'SALE_COST', amt + vat);
                                }
                                if (column == 'SALE_SUPPLY_COST'){
                                var amt = Number(nvl(data.SALE_SUPPLY_COST, 0));
                                var vat = Number(nvl(data.SALE_SURTAX, 0));
                                fnObj.gridView01.target.setValue(idx, 'SALE_COST', amt + vat);
                           		}
                                if (column == 'ITEM_SUPPLY_COST'){
                                    var amt = Number(nvl(data.ITEM_SUPPLY_COST, 0));
                                    var vat = Number(nvl(data.ITEM_SURTAX, 0));
                                    fnObj.gridView01.target.setValue(idx, 'ITEM_COST', amt + vat);
                                }
                                if (column == 'ITEM_SURTAX'){
                                    var amt = Number(nvl(data.ITEM_SUPPLY_COST, 0));
                                    var vat = Number(nvl(data.ITEM_SURTAX, 0));
                                    fnObj.gridView01.target.setValue(idx, 'ITEM_COST', amt + vat);
                                }*/
                                /*if (column == 'ITEM_SURTAX'){
                                    if (data.ITEM_SURTAX != 0){
                                        fnObj.gridView01.target.setValue(idx, 'TAX_TP', '01');
                                    }else{
                                        fnObj.gridView01.target.setValue(idx, 'TAX_TP', '02');
                                    }
                                    fnObj.gridView01.target.setValue(idx, 'ITEM_SUPPLY_COST', Number(data.ITEM_COST) - data.ITEM_SURTAX);
                                }*/
                                /* if (column == 'SALE_SURTAX'){
                                    if (data.SALE_SURTAX != 0){
                                        fnObj.gridView01.target.setValue(idx, 'TAX_TP', '01');
                                    }else{
                                        fnObj.gridView01.target.setValue(idx, 'TAX_TP', '02');
                                    }
                                    fnObj.gridView01.target.setValue(idx, 'SALE_SUPPLY_COST', Number(data.SALE_COST) - data.SALE_SURTAX);
                                } */
                                
                                
                                if (column == 'SALE_SURTAX'){
                                	var colindex_SALE_COST = fnObj.gridView01.target.$target.find('[data-ax5grid-column-key="SALE_COST"]').attr('data-ax5grid-column-col');
                                    var hasBorder_SALE_COST = fnObj.gridView01.target.$target.find('[data-ax5grid-column-col="' + colindex_SALE_COST + '"][data-ax5grid-data-index="' + idx + '"]');
                                    var colindex_SALE_SUPPLY_COST = fnObj.gridView01.target.$target.find('[data-ax5grid-column-key="SALE_SUPPLY_COST"]').attr('data-ax5grid-column-col');
                                    var hasBorder_SALE_SUPPLY_COST = fnObj.gridView01.target.$target.find('[data-ax5grid-column-col="' + colindex_SALE_SUPPLY_COST + '"][data-ax5grid-data-index="' + idx + '"]');
                                    var colindex_SALE_SURTAX = fnObj.gridView01.target.$target.find('[data-ax5grid-column-key="SALE_SURTAX"]').attr('data-ax5grid-column-col');
                                    var hasBorder_SALE_SURTAX = fnObj.gridView01.target.$target.find('[data-ax5grid-column-col="' + colindex_SALE_SURTAX + '"][data-ax5grid-data-index="' + idx + '"]');

                                    if (this.item.SALE_SUPPLY_COST + this.item.SALE_SURTAX != this.item.SALE_COST){
                                    	hasBorder_SALE_COST.addClass('red');
                                    	hasBorder_SALE_SUPPLY_COST.addClass('red');
                                    	hasBorder_SALE_SURTAX.addClass('red');
                                    }else{
                                    	hasBorder_SALE_COST.addClass('black');
                                    	hasBorder_SALE_SUPPLY_COST.addClass('black');
                                    	hasBorder_SALE_SURTAX.addClass('black');
                                    }
                                }
                                if (column == 'SALE_SUPPLY_COST'){
                                	var colindex_SALE_COST = fnObj.gridView01.target.$target.find('[data-ax5grid-column-key="SALE_COST"]').attr('data-ax5grid-column-col');
                                    var hasBorder_SALE_COST = fnObj.gridView01.target.$target.find('[data-ax5grid-column-col="' + colindex_SALE_COST + '"][data-ax5grid-data-index="' + idx + '"]');
                                    var colindex_SALE_SUPPLY_COST = fnObj.gridView01.target.$target.find('[data-ax5grid-column-key="SALE_SUPPLY_COST"]').attr('data-ax5grid-column-col');
                                    var hasBorder_SALE_SUPPLY_COST = fnObj.gridView01.target.$target.find('[data-ax5grid-column-col="' + colindex_SALE_SUPPLY_COST + '"][data-ax5grid-data-index="' + idx + '"]');
                                    var colindex_SALE_SURTAX = fnObj.gridView01.target.$target.find('[data-ax5grid-column-key="SALE_SURTAX"]').attr('data-ax5grid-column-col');
                                    var hasBorder_SALE_SURTAX = fnObj.gridView01.target.$target.find('[data-ax5grid-column-col="' + colindex_SALE_SURTAX + '"][data-ax5grid-data-index="' + idx + '"]');

                                    if (this.item.SALE_SUPPLY_COST + this.item.SALE_SURTAX != this.item.SALE_COST){
                                    	hasBorder_SALE_COST.addClass('red');
                                    	hasBorder_SALE_SUPPLY_COST.addClass('red');
                                    	hasBorder_SALE_SURTAX.addClass('red');
                                    }else{
                                    	hasBorder_SALE_COST.addClass('black');
                                    	hasBorder_SALE_SUPPLY_COST.addClass('black');
                                    	hasBorder_SALE_SURTAX.addClass('black');
                                    }
                                }
                                if (column == 'ITEM_SUPPLY_COST'){
                                	var colindex_ITEM_COST = fnObj.gridView01.target.$target.find('[data-ax5grid-column-key="ITEM_COST"]').attr('data-ax5grid-column-col');
                                    var hasBorder_ITEM_COST = fnObj.gridView01.target.$target.find('[data-ax5grid-column-col="' + colindex_ITEM_COST + '"][data-ax5grid-data-index="' + idx + '"]');
                                    var colindex_ITEM_SUPPLY_COST = fnObj.gridView01.target.$target.find('[data-ax5grid-column-key="ITEM_SUPPLY_COST"]').attr('data-ax5grid-column-col');
                                    var hasBorder_ITEM_SUPPLY_COST = fnObj.gridView01.target.$target.find('[data-ax5grid-column-col="' + colindex_ITEM_SUPPLY_COST + '"][data-ax5grid-data-index="' + idx + '"]');
                                    var colindex_ITEM_SURTAX = fnObj.gridView01.target.$target.find('[data-ax5grid-column-key="ITEM_SURTAX"]').attr('data-ax5grid-column-col');
                                    var hasBorder_ITEM_SURTAX = fnObj.gridView01.target.$target.find('[data-ax5grid-column-col="' + colindex_ITEM_SURTAX + '"][data-ax5grid-data-index="' + idx + '"]');

                                    if (this.item.ITEM_SUPPLY_COST + this.item.ITEM_SURTAX != this.item.ITEM_COST){
                                    	hasBorder_ITEM_COST.addClass('red');
                                    	hasBorder_ITEM_SUPPLY_COST.addClass('red');
                                    	hasBorder_ITEM_SURTAX.addClass('red');
                                    }else{
                                    	hasBorder_ITEM_COST.addClass('black');
                                    	hasBorder_ITEM_SUPPLY_COST.addClass('black');
                                    	hasBorder_ITEM_SURTAX.addClass('black');
                                    }
                                }
                                if (column == 'ITEM_SURTAX'){
                                	var colindex_ITEM_COST = fnObj.gridView01.target.$target.find('[data-ax5grid-column-key="ITEM_COST"]').attr('data-ax5grid-column-col');
                                    var hasBorder_ITEM_COST = fnObj.gridView01.target.$target.find('[data-ax5grid-column-col="' + colindex_ITEM_COST + '"][data-ax5grid-data-index="' + idx + '"]');
                                    var colindex_ITEM_SUPPLY_COST = fnObj.gridView01.target.$target.find('[data-ax5grid-column-key="ITEM_SUPPLY_COST"]').attr('data-ax5grid-column-col');
                                    var hasBorder_ITEM_SUPPLY_COST = fnObj.gridView01.target.$target.find('[data-ax5grid-column-col="' + colindex_ITEM_SUPPLY_COST + '"][data-ax5grid-data-index="' + idx + '"]');
                                    var colindex_ITEM_SURTAX = fnObj.gridView01.target.$target.find('[data-ax5grid-column-key="ITEM_SURTAX"]').attr('data-ax5grid-column-col');
                                    var hasBorder_ITEM_SURTAX = fnObj.gridView01.target.$target.find('[data-ax5grid-column-col="' + colindex_ITEM_SURTAX + '"][data-ax5grid-data-index="' + idx + '"]');

                                    if (this.item.ITEM_SUPPLY_COST + this.item.ITEM_SURTAX != this.item.ITEM_COST){
                                    	hasBorder_ITEM_COST.addClass('red');
                                    	hasBorder_ITEM_SUPPLY_COST.addClass('red');
                                    	hasBorder_ITEM_SURTAX.addClass('red');
                                    }else{
                                    	hasBorder_ITEM_COST.addClass('black');
                                    	hasBorder_ITEM_SUPPLY_COST.addClass('black');
                                    	hasBorder_ITEM_SURTAX.addClass('black');
                                    }
                                }
                                if (column == 'ITEM_COST'){
                                	var supplyAmt = 0, vatAmt = 0;
                                	
                                    if (data.TAX_TP == '01'){	//	과세
                                    	supplyAmt = Math.round(Number(data.ITEM_COST) * 10 / 11);
                                        vatAmt = Math.round((Number(data.ITEM_COST) - supplyAmt));
                                    } else{
                                    	supplyAmt = data.ITEM_COST;
                                    	vatAmt = 0;
                                    }	
                                    fnObj.gridView01.target.setValue(idx, 'ITEM_SUPPLY_COST', supplyAmt);
                                    fnObj.gridView01.target.setValue(idx, 'ITEM_SURTAX', vatAmt);
                                }
                                if (column == 'SALE_COST'){
                                	var supplyAmt = 0, vatAmt = 0;
                                	
                                    if (data.TAX_TP == '01'){	//	과세
                                    	supplyAmt = Math.round(Number(data.SALE_COST) * 10 / 11);
                                        vatAmt = Math.round((Number(data.SALE_COST) - supplyAmt));
                                    } else{
                                    	supplyAmt = data.SALE_COST;
                                    	vatAmt = 0;
                                    }	
                                    fnObj.gridView01.target.setValue(idx, 'SALE_SUPPLY_COST', supplyAmt);
                                    fnObj.gridView01.target.setValue(idx, 'SALE_SURTAX', vatAmt);
                                }
                            },
                            onClick: function () {
                                var data = this.item;
                                var column = this.column.key;
                                /*if (column == 'SURTAX_YN'){
                                    if (nvl(data, 'N') == 'N'){
                                        fnObj.gridView01.target.setValue(data.__index, column, 'Y');
                                    }else{
                                        fnObj.gridView01.target.setValue(data.__index, column, 'N');
                                    }
                                }*/

                                selectIndex = this.dindex;
                                this.self.select(this.dindex);
                            },
                            onDBLClick: function () {
                                var column = this.column.key;
                                if (column == 'FILE_NAME'){
                                    var selected = fnObj.gridView01.getData('selected')[0];

                                    userCallBack = function (e) {
                                        e['TB_ID'] = 'FS_ITEM_M';
                                        e['CG_CD'] = 'ITEM';
                                        e['TB_KEY'] = selected.ITEM_CD;

                                        fnObj.gridView01.target.setValue(selected.__index, 'FILE_NAME', e.ORGN_FILE_NAME);
                                        fnObj.gridView01.target.list[selected.__index]['FILE'] = e;
                                    };


                                    var data = {
                                        TB_ID: 'FS_ITEM_M',
                                        CG_CD: 'ITEM',
                                        TB_KEY: selected['ITEM_CD'],
                                        FILE_PATH: 'item',
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
                        },
                    });
                    axboot.buttonClick(this, "data-grid-view-01-btn", {
                        "add": function () {
                            ACTIONS.dispatch(ACTIONS.ITEM_ADD);
                        },
                        "delete": function(){
                            ACTIONS.dispatch(ACTIONS.ITEM_DELETE);
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
            //  크기자동조정
            var _pop_top = 0;
            var _pop_height = 0;
            var _pop_height800 = 0;
            var _pop_top800 = 0;
            $(document).ready(function () {
                changesize();

                $("#ITEM_NM").focus();
                $("#ITEM_NM").keydown(function (e) {
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
        <style>
            .preview {
                height: 750px;
                width: 600px;
            }

            .img-preview {
                height: 9rem;
                width: 16rem;
            }

            #canvas_crop {
                border: 1px solid rgb(216, 216, 216)
            }
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
                        <ax:td label='제조거래처' width="350px">

                            <codepicker id="MAKE_PT_CD" HELP_ACTION="HELP_BRAND_PARTNER" HELP_URL="brandPartner"
                                         BIND-CODE="PT_CD"
                                         BIND-TEXT="PT_NM"/>
                        </ax:td>
                        <ax:td label='상품명' width="350px">
                            <div class="input-group" style="width:100%">
                                <input type="text" class="form-control" name="ITEM_NM" id="ITEM_NM"
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