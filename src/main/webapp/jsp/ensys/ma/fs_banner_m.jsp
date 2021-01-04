<%@ page import="com.chequer.axboot.core.utils.MessageUtils" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>

<ax:set key="title" value="배너관리"/>
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
                            caller.gridView01.setData(res);
                        	if(res.list.length < afterIndex ){
                                afterIndex = 0
                            }
                            caller.gridView01.target.select(afterIndex);
                            caller.gridView01.target.focus(afterIndex);
                            ACTIONS.dispatch(ACTIONS.ITEM_CLICK);
                        }
                    });
                },
                ITEM_CLICK: function(caller, act, data){
                    fnObj.gridView02.clear();
                    var selected = fnObj.gridView01.getData('selected')[0];
                    if (nvl(selected) == ''){
						return;
                    }
                	axboot.ajax({
                        type: "POST",
                        url: ["BANNER", "searchDtl"],
                        data: JSON.stringify({
                            BANNER_CD: selected.BANNER_CD
                        }),
                        callback: function (res) {
                            if (res.list.length > 0) {
                                caller.gridView02.setData(res);
                                caller.gridView02.target.select(0);

                               
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

                    var saveDataD = [].concat(caller.gridView02.getData("modified"));
                    for (var i = 0 ; i < saveDataD.length ; i++){
                        if (nvl(saveDataD[i].BANNER_NM) == ''){
                        	qray.alert('내부링크그리드에 배너명을 입력해주십시오.');
                            return ;
                        }
                    }
                    
                    saveData = saveData.concat(caller.gridView01.getData("deleted"));
                    saveDataD = saveDataD.concat(caller.gridView02.getData("deleted"));
                    if (saveData.length == 0 && saveDataD.length == 0){
						qray.alert('변경된 데이터가 없습니다.');
						return;
                    }
                    qray.confirm({
                        msg: "저장하시겠습니까?"
                    }, function () {
                        if (this.key == "ok") {
                            axboot.ajax({
                                type: "POST",
                                url: ["BANNER", "save"],
                                data: JSON.stringify({
                                    saveData: saveData,
                                    saveDataD: saveDataD
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
                	var selected = fnObj.gridView01.getData('selected')[0];

                    if (nvl(selected) == ''){
						qray.alert('선택된 데이터가 없습니다.');
						return;
                    }
                    fnObj.gridView01.delRow("selected");
                },
                ITEM_ADD2: function (caller, act, data){
                    var selected = fnObj.gridView01.getData('selected')[0];

                    if (nvl(selected) == ''){
						qray.alert('상단그리드에서 선택된 데이터가 없습니다.');
						return;
                    }
                    if (selected.URL_YN != 'Y'){
                    	qray.alert('내부링크여부가 체크되어있지않습니다.');
						return;
                    }
                	caller.gridView02.addRow();
                    var lastIdx = nvl(caller.gridView02.target.list.length, caller.gridView02.lastRow());
                    caller.gridView02.target.select(lastIdx - 1);
                    caller.gridView02.target.focus(lastIdx - 1);

                    caller.gridView02.target.setValue(lastIdx - 1, 'BANNER_CD', selected.BANNER_CD);
                    caller.gridView02.target.setValue(lastIdx - 1, 'SEQ', GET_NO('MA', '09'));
                    caller.gridView02.target.setValue(lastIdx - 1, 'USE_YN', 'Y');
                },
                ITEM_DEL2: function (caller, act, data) {
                	var selected = fnObj.gridView02.getData('selected')[0];

                    if (nvl(selected) == ''){
						qray.alert('선택된 데이터가 없습니다.');
						return;
                    }
                    fnObj.gridView02.delRow("selected");
                },
                ITEM_UP1: function(caller, act, data){
                    for (var i = 0 ; i < fnObj.gridView01.target.list.length ; i++){
                    	if (nvl(fnObj.gridView01.target.list[i].__created__) != ''){
                        	qray.alert('추가된 데이터가 존재합니다.<br>순서변경은 저장 후 진행해주십시오.');
    						return;
                        }
                    }
                	var selected = fnObj.gridView01.getData('selected')[0];
                	
                    if (nvl(selected) == ''){
						qray.alert('선택된 데이터가 없습니다.');
						return;
                    }
                    
                    if (selected.__index == 0){
						return;
                    }
                    var changeData = fnObj.gridView01.target.list[selected.__index - 1];

                    fnObj.gridView01.target.setValue(selected.__index, 'COMPANY_CD', changeData['COMPANY_CD']);
                    fnObj.gridView01.target.setValue(selected.__index, 'BANNER_CD', changeData['BANNER_CD']);
                    fnObj.gridView01.target.setValue(selected.__index, 'BANNER_NM', changeData['BANNER_NM']);
                    fnObj.gridView01.target.setValue(selected.__index, 'URL_YN', changeData['URL_YN']);
                    fnObj.gridView01.target.setValue(selected.__index, 'USE_YN', changeData['USE_YN']);
                    fnObj.gridView01.target.setValue(selected.__index, 'URL_LINK', changeData['URL_LINK']);
                    fnObj.gridView01.target.setValue(selected.__index, 'FILE_NAME', changeData['FILE_NAME']);
                    fnObj.gridView01.target.setValue(selected.__index, 'FILE', changeData['FILE']);
                    fnObj.gridView01.target.setValue(selected.__index, 'COMPANY_CD', changeData['COMPANY_CD']);

                    fnObj.gridView01.target.setValue(changeData.__index, 'COMPANY_CD', selected['COMPANY_CD']);
                    fnObj.gridView01.target.setValue(changeData.__index, 'BANNER_CD', selected['BANNER_CD']);
                    fnObj.gridView01.target.setValue(changeData.__index, 'BANNER_NM', selected['BANNER_NM']);
                    fnObj.gridView01.target.setValue(changeData.__index, 'URL_YN', selected['URL_YN']);
                    fnObj.gridView01.target.setValue(changeData.__index, 'USE_YN', selected['USE_YN']);
                    fnObj.gridView01.target.setValue(changeData.__index, 'URL_LINK', selected['URL_LINK']);
                    fnObj.gridView01.target.setValue(changeData.__index, 'FILE_NAME', selected['FILE_NAME']);
                    fnObj.gridView01.target.setValue(changeData.__index, 'FILE', selected['FILE']);
                    fnObj.gridView01.target.setValue(changeData.__index, 'COMPANY_CD', selected['COMPANY_CD']);
                    
                    afterIndex  = changeData.__index;
                    fnObj.gridView01.target.select(changeData.__index);
                },
                ITEM_DOWN1: function(caller, act, data){
                	for (var i = 0 ; i < fnObj.gridView01.target.list.length ; i++){
                    	if (nvl(fnObj.gridView01.target.list[i].__created__) != ''){
                        	qray.alert('추가된 데이터가 존재합니다.<br>순서변경은 저장 후 진행해주십시오.');
    						return;
                        }
                    }
                	var selected = fnObj.gridView01.getData('selected')[0];

                    if (nvl(selected) == ''){
						qray.alert('선택된 데이터가 없습니다.');
						return;
                    }
                    if (selected.__index == (fnObj.gridView01.target.list.length - 1)){
                    	console.log('(fnObj.gridView01.target.list.length - 1)' + '=' + 'selected.__index')
						return;
                    }

                    var changeData = fnObj.gridView01.target.list[selected.__index + 1];

                    fnObj.gridView01.target.setValue(selected.__index, 'COMPANY_CD', changeData['COMPANY_CD']);
                    fnObj.gridView01.target.setValue(selected.__index, 'BANNER_CD', changeData['BANNER_CD']);
                    fnObj.gridView01.target.setValue(selected.__index, 'BANNER_NM', changeData['BANNER_NM']);
                    fnObj.gridView01.target.setValue(selected.__index, 'URL_YN', changeData['URL_YN']);
                    fnObj.gridView01.target.setValue(selected.__index, 'USE_YN', changeData['USE_YN']);
                    fnObj.gridView01.target.setValue(selected.__index, 'URL_LINK', changeData['URL_LINK']);
                    fnObj.gridView01.target.setValue(selected.__index, 'FILE_NAME', changeData['FILE_NAME']);
                    fnObj.gridView01.target.setValue(selected.__index, 'FILE', changeData['FILE']);
                    fnObj.gridView01.target.setValue(selected.__index, 'COMPANY_CD', changeData['COMPANY_CD']);

                    fnObj.gridView01.target.setValue(changeData.__index, 'COMPANY_CD', selected['COMPANY_CD']);
                    fnObj.gridView01.target.setValue(changeData.__index, 'BANNER_CD', selected['BANNER_CD']);
                    fnObj.gridView01.target.setValue(changeData.__index, 'BANNER_NM', selected['BANNER_NM']);
                    fnObj.gridView01.target.setValue(changeData.__index, 'URL_YN', selected['URL_YN']);
                    fnObj.gridView01.target.setValue(changeData.__index, 'USE_YN', selected['USE_YN']);
                    fnObj.gridView01.target.setValue(changeData.__index, 'URL_LINK', selected['URL_LINK']);
                    fnObj.gridView01.target.setValue(changeData.__index, 'FILE_NAME', selected['FILE_NAME']);
                    fnObj.gridView01.target.setValue(changeData.__index, 'FILE', selected['FILE']);
                    fnObj.gridView01.target.setValue(changeData.__index, 'COMPANY_CD', selected['COMPANY_CD']);

                    afterIndex  = changeData.__index;
                    fnObj.gridView01.target.select(changeData.__index);
                },
                ITEM_UP2: function(caller, act, data){
                	for (var i = 0 ; i < fnObj.gridView02.target.list.length ; i++){
                    	if (nvl(fnObj.gridView02.target.list[i].__created__) != ''){
                        	qray.alert('추가된 데이터가 존재합니다.<br>순서변경은 저장 후 진행해주십시오.');
    						return;
                        }
                    }
                	var selected = fnObj.gridView02.getData('selected')[0];
                	
                    if (nvl(selected) == ''){
						qray.alert('선택된 데이터가 없습니다.');
						return;
                    }
                    if (selected.__index == 0){
						return;
                    }
                    var changeData = fnObj.gridView02.target.list[selected.__index - 1];

                          
                    fnObj.gridView02.target.setValue(selected.__index, 'COMPANY_CD', changeData['COMPANY_CD']);
                    fnObj.gridView02.target.setValue(selected.__index, 'BANNER_CD', changeData['BANNER_CD']);
                    fnObj.gridView02.target.setValue(selected.__index, 'BANNER_NM', changeData['BANNER_NM']);
                    fnObj.gridView02.target.setValue(selected.__index, 'SEQ', changeData['SEQ']);
                    fnObj.gridView02.target.setValue(selected.__index, 'USE_YN', changeData['USE_YN']);
                    fnObj.gridView02.target.setValue(selected.__index, 'FILE_NAME', changeData['FILE_NAME']);
                    fnObj.gridView02.target.setValue(selected.__index, 'FILE', changeData['FILE']);

                    fnObj.gridView02.target.setValue(changeData.__index, 'COMPANY_CD', selected['COMPANY_CD']);
                    fnObj.gridView02.target.setValue(changeData.__index, 'BANNER_CD', selected['BANNER_CD']);
                    fnObj.gridView02.target.setValue(changeData.__index, 'BANNER_NM', selected['BANNER_NM']);
                    fnObj.gridView02.target.setValue(changeData.__index, 'SEQ', selected['SEQ']);
                    fnObj.gridView02.target.setValue(changeData.__index, 'USE_YN', selected['USE_YN']);
                    fnObj.gridView02.target.setValue(changeData.__index, 'FILE_NAME', selected['FILE_NAME']);
                    fnObj.gridView02.target.setValue(changeData.__index, 'FILE', selected['FILE']);

                    fnObj.gridView02.target.select(changeData.__index);
                },
                ITEM_DOWN2: function(caller, act, data){
                	for (var i = 0 ; i < fnObj.gridView02.target.list.length ; i++){
                    	if (nvl(fnObj.gridView02.target.list[i].__created__) != ''){
                        	qray.alert('추가된 데이터가 존재합니다.<br>순서변경은 저장 후 진행해주십시오.');
    						return;
                        }
                    }
                	var selected = fnObj.gridView02.getData('selected')[0];

                    if (nvl(selected) == ''){
						qray.alert('선택된 데이터가 없습니다.');
						return;
                    }
                    if (selected.__index == (fnObj.gridView02.target.list.length - 1)){
                        console.log('(fnObj.gridView02.target.list.length - 1)' + '=' + 'selected.__index')
						return;
                    }

                    var changeData = fnObj.gridView02.target.list[selected.__index + 1];

                    fnObj.gridView02.target.setValue(selected.__index, 'COMPANY_CD', changeData['COMPANY_CD']);
                    fnObj.gridView02.target.setValue(selected.__index, 'BANNER_CD', changeData['BANNER_CD']);
                    fnObj.gridView02.target.setValue(selected.__index, 'BANNER_NM', changeData['BANNER_NM']);
                    fnObj.gridView02.target.setValue(selected.__index, 'SEQ', changeData['SEQ']);
                    fnObj.gridView02.target.setValue(selected.__index, 'USE_YN', changeData['USE_YN']);
                    fnObj.gridView02.target.setValue(selected.__index, 'FILE_NAME', changeData['FILE_NAME']);
                    fnObj.gridView02.target.setValue(selected.__index, 'FILE', changeData['FILE']);

                    fnObj.gridView02.target.setValue(changeData.__index, 'COMPANY_CD', selected['COMPANY_CD']);
                    fnObj.gridView02.target.setValue(changeData.__index, 'BANNER_CD', selected['BANNER_CD']);
                    fnObj.gridView02.target.setValue(changeData.__index, 'BANNER_NM', selected['BANNER_NM']);
                    fnObj.gridView02.target.setValue(changeData.__index, 'SEQ', selected['SEQ']);
                    fnObj.gridView02.target.setValue(changeData.__index, 'USE_YN', selected['USE_YN']);
                    fnObj.gridView02.target.setValue(changeData.__index, 'FILE_NAME', selected['FILE_NAME']);
                    fnObj.gridView02.target.setValue(changeData.__index, 'FILE', selected['FILE']);

                    fnObj.gridView02.target.select(changeData.__index);
                },
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
                        showRowSelector: true,
                        target: $('[data-ax5grid="grid-view-01"]'),
                        // parentFlag:true,
                        // parentGrid: $(fnObj.gridView02),
                        // childrenGrid: [$(fnObj.gridView02),$(fnObj.gridView03)],
                        showRowSelector: true,
                        columns: [ 
                            {key: "COMPANY_CD", label: "회사코드", width: 150 , align: "center" ,hidden:true},
                            {key: "SORT_SEQ", label: "배너순서", width: 100 , editor: {type: "number"}, align: "center",sortable: true,hidden:true},
                            {key: "BANNER_CD", label: "배너코드", width: 150 , align: "center" , editor: false, sortable: true,},
                            {key: "BANNER_NM", label: "배너명", width: 150 , editor: {type: "text"}, align: "left",sortable: true,},
                            {key: "URL_LINK", label: "링크주소", width: "*" , editor: {type: "text"}, align: "left",sortable: true,},
                            {key: "URL_YN", label: "내부링크여부", width: 100 , align: "center", sortable: true,
                                editor: {
                                    type: "checkbox", config: {height: 17, trueValue: 'Y', falseValue: 'N'},
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
                            {key: "USE_YN", label: "사용여부", width: 100 , align: "center", sortable: true,
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
                            	/* if (this.key == 'URL_YN'){
									if (this.value == 'Y'){
										fnObj.gridView01.target.setValue(this.dindex, 'URL_LINK', '');
									}else{
										for (var i = 0 ; i < fnObj.gridView02.target.list.length ; i++){
											fnObj.gridView02.delRow(i);
										}
									}
                               	} */
                            },
                            //444
                            onClick: function () {
                                var index = this.dindex;

                                if(afterIndex == index) {
                                    return false;
                                }
                                
                                var data = [].concat(fnObj.gridView02.getData("modified").concat(fnObj.gridView02.getData("deleted")));
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
	                                ACTIONS.dispatch(ACTIONS.ITEM_CLICK);
                                }

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
                    	"up": function(){
                       	 ACTIONS.dispatch(ACTIONS.ITEM_UP1);
                        },
                        "down": function(){
                       	 ACTIONS.dispatch(ACTIONS.ITEM_DOWN1);
                        },
                        "delete": function () {
                            var beforeIdx = fnObj.gridView01.target.selectedDataIndexs[0];
                            var dataLen = fnObj.gridView01.target.getList().length;

                            if ((beforeIdx + 1) == dataLen) {
                                beforeIdx = beforeIdx - 1;
                            }
                            ACTIONS.dispatch(ACTIONS.ITEM_DEL1);
                            afterIndex = beforeIdx;
                            fnObj.gridView01.target.select(beforeIdx);
                            fnObj.gridView01.target.focus(beforeIdx);
                            ACTIONS.dispatch(ACTIONS.ITEM_CLICK);
                            
                        },
                        "add": function () {
                        	var chekVal;
                            $(fnObj.gridView02.target.list).each(function (i, e) {
                                if (e.__modified__) {
                                    chekVal = true;
                                }
                                if (e.__created__) {
                                    chekVal = true;
                                }
                                if (e.__deleted__) {
                                    chekVal = true;
                                }
                            });


                            if (chekVal) {
                                qray.alert("작업중인 데이터가 있습니다. 저장 후 진행하세요");
                                return;
                            }
                            
                            ACTIONS.dispatch(ACTIONS.ITEM_ADD1);
                            ACTIONS.dispatch(ACTIONS.ITEM_CLICK);
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
                        showRowSelector: true,
                        target: $('[data-ax5grid="grid-view-02"]'),
                        // parentFlag:true,
                        // parentGrid: $(fnObj.gridView02),
                        // childrenGrid: [$(fnObj.gridView02),$(fnObj.gridView03)],
                        showRowSelector: true,
                        columns: [ 
                            {key: "COMPANY_CD", label: "회사코드", width: 150 , align: "center" ,hidden:true},
                            {key: "BANNER_CD", label: "배너코드", width: 150 , align: "center" , editor: false, sortable: true, hidden:true},
                            {key: "SEQ", label: "채번코드", width: 150 , align: "center" , editor: false, sortable: true, hidden:true},
                            {key: "BANNER_NM", label: "배너명", width: 200 , editor: {type: "text"}, align: "left",sortable: true,},
                            {key: "FILE_NAME", label: "파일", width: 150 , align: "center" , editor: false, sortable: true,},
                            {key: "FILE", label: "이미지파일", width: 150 , align: "center" , editor: false, sortable: true, hidden:true},
                            {key: "LINK_SEQ", label: "연결배너순서", width: 100 , editor: {type: "number"}, align: "center",sortable: true,hidden:true},
                            {key: "USE_YN", label: "사용여부", width: 100 , align: "center", sortable: true,
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
                                this.self.select(this.dindex);
                            },
                            onDBLClick: function () {
                                var column = this.column.key;
                                if (column == 'FILE_NAME'){
                                    var selected = fnObj.gridView02.getData('selected')[0];

                                    userCallBack = function (e) {
                                        e['TB_ID'] = 'FS_BANNER_D';
                                        e['CG_CD'] = 'BANNER00002';
                                        e['TB_KEY'] = selected.SEQ;

                                        fnObj.gridView01.target.setValue(selected.__index, 'FILE_NAME', e.ORGN_FILE_NAME);
                                        fnObj.gridView01.target.list[selected.__index]['FILE'] = e;
                                    };


                                    var data = {
                                        TB_ID: 'FS_BANNER_D',
                                        CG_CD: 'BANNER00002',
                                        TB_KEY: selected['SEQ'],
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
                    axboot.buttonClick(this, "data-grid-view-02-btn", {
                         "up": function(){
                        	 ACTIONS.dispatch(ACTIONS.ITEM_UP2);
                         },
                         "down": function(){
                        	 ACTIONS.dispatch(ACTIONS.ITEM_DOWN2);
                         },
                        "delete": function () {
                            var beforeIdx = fnObj.gridView02.target.selectedDataIndexs[0];
                            var dataLen = fnObj.gridView02.target.getList().length;

                            if ((beforeIdx + 1) == dataLen) {
                                beforeIdx = beforeIdx - 1;
                            }
                            ACTIONS.dispatch(ACTIONS.ITEM_DEL2);
                            fnObj.gridView02.target.select(beforeIdx);
                            fnObj.gridView02.target.focus(beforeIdx);
                            
                        },
                        "add": function () {
                            ACTIONS.dispatch(ACTIONS.ITEM_ADD2);
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
                var datarealheight = $("#ax-base-root").height() - $(".ax-base-title").height() - $("#pageheader").height();
                //타이틀을 뺀 상하단 그리드 합친높이
                var tempgridheight = datarealheight - $("#left_title").height();

                $("#left_grid").css("height" ,(tempgridheight / 100 * 99 - $('.ax-button-group').height() ) / 2 );
                $("#left_grid2").css("height", (tempgridheight / 100 * 99 - $('.ax-button-group').height()) / 2 );
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

        <div style="width:100%;overflow:hidden">
            <div style="width:99%;overflow:hidden;">
                <div class="ax-button-group" data-fit-height-aside="grid-view-01" id="left_title" name="왼쪽그리드타이틀">
                    <div class="left">
                    </div>
                    <div class="right">
                    <button type="button" class="btn btn-small" data-grid-view-01-btn="up" style="width:80px;"><i
                                class="icon_up"></i>  위로
                        </button>
                        <button type="button" class="btn btn-small" data-grid-view-01-btn="down" style="width:80px;"><i
                                class="icon_down"></i> 아래로
                        </button>
                        <button type="button" class="btn btn-small" data-grid-view-01-btn="add" style="width:80px;"><i
                        class="icon_add"></i>
                    		<ax:lang id="ax.admin.add"/></button>
                		<button type="button" class="btn btn-small" data-grid-view-01-btn="delete" style="width:80px;"><i
                        class="icon_del"></i>
                    <ax:lang id="ax.admin.delete"/></button>
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
                            <i class="icon_list"></i> 내부링크 리스트
                        </h2>
                    </div>
                    <div class="right">
                    	<button type="button" class="btn btn-small" data-grid-view-02-btn="up" style="width:80px;"><i
                                class="icon_up"></i> 위로
                        </button>
                        <button type="button" class="btn btn-small" data-grid-view-02-btn="down" style="width:80px;"><i
                                class="icon_down"></i> 아래로
                        </button>
                        <button type="button" class="btn btn-small" data-grid-view-02-btn="add" style="width:80px;"><i
                        class="icon_add"></i>
                    <ax:lang id="ax.admin.add"/></button>
                <button type="button" class="btn btn-small" data-grid-view-02-btn="delete" style="width:80px;"><i
                        class="icon_del"></i>
                    <ax:lang id="ax.admin.delete"/></button>
                    </div>
                </div>

                <div data-ax5grid="grid-view-02"
                     data-ax5grid-config="{  showLineNumber: true,showRowSelector: false, multipleSelect: false,lineNumberColumnWidth: 40,rowSelectorColumnWidth: 27, }"
                     id = "left_grid2"
                     name="왼쪽그리드"
                ></div>
            </div>



        </div>


    </jsp:body>
</ax:layout>