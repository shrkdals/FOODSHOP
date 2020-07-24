<%@ page import="com.chequer.axboot.core.utils.MessageUtils" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>

<ax:set key="title" value="카테고리관리"/>
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
            var beforeIdx = 0;

            //분류코드
            var DATA_BRCODE     = getquerycode("getBrcode");
            //상위분류코드
            var DATA_PARENTBRCODE     = getquerycode("getParentBrcode");
            //검증상태
            var DATA_BRTYPE = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'MA00015');
            // YN
            var DATA_YN = [{value:'' , text:''},{value:'Y' , text:'Y'},{value:'N' , text:'N'}];



            //-----------------------------상단조회조건 시작 ------------------------------------

            //분류코드
            $("#S_BRCODE").ax5select({ options: DATA_BRCODE });

            //상위분류코드
            $("#S_PARENTBRCODE").ax5select({ options: DATA_PARENTBRCODE });

            //-----------------------------상단조회조건 종료 ------------------------------------


            var fnObj = {}, CODE = {};
            var ACTIONS = axboot.actionExtend(fnObj, {
                //조회버튼
                PAGE_SEARCH: function (caller, act, data) {
                    var param = {
                        COMPANY_CD : SCRIPT_SESSION.cdCompany //회사코드
                        , CG_CD : $('select[name="S_BRCODE"]').val() //분류코드
                        , PARENT_CG_CD : $('select[name="S_PARENTBRCODE"]').val() //상위분류코드
                    };
                    var list = $.DATA_SEARCH('Categorym','categorymSearchMain',param).list;
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
                //저장버튼
                PAGE_SAVE: function (caller, act, data) {
                    var grid = fnObj.gridView01.target.list;

                    for (var i = 0; i < grid.length; i++) {

                        if (nvl(grid[i].CG_CD) == '') {
                            qray.alert("분류코드는 필수입니다.");
                            return false;
                        }

                        if (nvl(grid[i].CG_NM) == '') {
                            qray.alert("분류명은 필수입니다.");
                            return false;
                        }

                        var n =0;
                        var m =0;
                        for (var k = 0; k < grid.length; k++) {
                            if(nvl(grid[i].CG_CD) == nvl(grid[k].CG_CD)){
                                n++;
                            }

                            if(nvl(grid[i].CG_CD) == nvl(grid[k].CG_CD)){
                                m++;
                            }
                        }

                        if(n > 1) {
                            qray.alert("중복되는 분류코드가 있습니다.");
                            return false;
                        }

                        if(m == 0){
                            qray.alert("등록되지않은 분류코드가 상위분류코드로 사용되었습니다.");
                            return false;
                        }
                    }


                    var itemH = [].concat(caller.gridView01.getData("modified"));
                    itemH = itemH.concat(caller.gridView01.getData("deleted"));

                    if(itemH.length == 0){
                        qray.alert('변경된 정보가 없습니다.');
                        return;
                    }

                    var data = {
                        delete : caller.gridView01.getData("deleted")
                        ,insert : caller.gridView01.getData("modified")
                    };

                    /*
                    var brandObject = {};
                    brandObject.brandData = data;
                    brandObject.fileData1 = $("#FILE1").saveData();//작1
                    brandObject.fileData2 = $("#FILE2").saveData();
                    brandObject.fileData3 = $("#FILE3").saveData();
                    */

                    axboot.ajax({
                        type: "PUT",
                        url: ["Categorym", "save"],
                        data: JSON.stringify(data),
                        callback: function (res) {
                            qray.alert("저장 되었습니다.");
                            ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                            caller.gridView01.target.select(afterIndex);
                            caller.gridView01.target.focus(afterIndex);

                        }
                    });
                },
                //그리드로우클릭
                ITEM_CLICK: function (caller, act, data) {
                    //그리드,우측컨트롤 동기화(setFormData) 컨트롤ID, 그리드컬럼명일치시킬것
                    //var selected = caller.gridView01.getData('selected')[0];
                    /*
                    if(nvl($('#CONTRACT_NO').val()) == ''){
                        Disabled()
                    }else{
                        Activation()
                    }
                    */
                    return false;
                },
                //상단추가버튼
                ITEM_ADD1: function (caller, act, data) {
                    caller.gridView01.addRow();
                    var lastIdx = nvl(caller.gridView01.target.list.length, caller.gridView01.lastRow());
                    caller.gridView01.target.select(lastIdx - 1);
                    caller.gridView01.target.focus(lastIdx - 1);
                    afterIndex  = lastIdx - 1;
                    caller.gridView01.target.setValue(lastIdx - 1, "FILE_YN", "Y");
                    caller.gridView01.target.setValue(lastIdx - 1, "SEE_YN", "Y");

                    ACTIONS.dispatch(ACTIONS.ITEM_CLICK);
                },
                ITEM_DEL1: function (caller, act, data) {

                    fnObj.gridView01.delRow("selected");

                }
            });
            // fnObj 기본 함수 스타트와 리사이즈
            fnObj.pageStart = function () {
                this.pageButtonView.initView();
                this.searchView.initView();
                this.gridView01.initView();
                ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
            };

            fnObj.beforeClose = {
                initView: function () {

                    var gridView01 = [].concat(fnObj.gridView01.getData("modified"));
                    gridView01 = gridView01.concat(fnObj.gridView01.getData("deleted"));

                },
                ok: function () {   //  저장하시겠습니까? yes
                    var result = ACTIONS.dispatch(ACTIONS.PAGE_SAVE);
                    return result;
                }
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

                        },
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
                        "newAdd": function () {
                            var chekVal;
                            $(fnObj.gridView01.target.list).each(function (i, e) {
                                if (e.__modified__) {
                                    chekVal = true;
                                }
                                if (e.__created__) {
                                    chekVal = true;
                                }
                            });

                            /*
                            if (chekVal) {
                                qray.alert("작업중인 데이터가 있습니다. 저장 후 진행하세요");
                                return;
                            }
                             */
                            ACTIONS.dispatch(ACTIONS.ITEM_ADD1);
                        }
                    });
                }
            });

            //== view 시작
            fnObj.searchView = axboot.viewExtend(axboot.searchView, {
                initView: function () {
                    this.target = $(document["searchView0"]);
                    this.target.attr("onsubmit", "return ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);");
                    this.NM_FIELD = $("#NM_FIELD");
                },
                getData: function () {
                    return {
                        P_NM_FIELD: this.NM_FIELD.val(),
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
                        target: $('[data-ax5grid="grid-view-01"]'),
                        // parentFlag:true,
                        // parentGrid: $(fnObj.gridView02),
                        // childrenGrid: [$(fnObj.gridView02),$(fnObj.gridView03)],
                        showRowSelector: true,
                        columns: [
                            {key: "COMPANY_CD", label: "회사코드", width: 150 , align: "left" , editor: {type: "text"},hidden:true}
                            ,{key: "CG_CD", label: "분류코드", width: 150   , align: "center" ,
                                editor: {type: "text"
                                    , disabled: function () {
                                        var IS_READ = fnObj.gridView01.target.getList()[this.dindex].IS_READ;
                                        if (nvl(IS_READ) == 'Y') {
                                            return true;
                                        } else {
                                            return false;
                                        }
                                    }
                                }
                            }
                            ,{key: "CG_NM", label: "분류명", width: 150   , align: "center" , editor: {type: "text"}}
                            ,{key: "DEPTH_TEXT", label: "분류명", width: 150, align: "left", editor: false}
                            ,{key: "PARENT_CG_CD", label: "상위분류코드", width: 150   , align: "center" ,
                                editor: {type: "text"
                                    , disabled: function () {
                                        var IS_READ = fnObj.gridView01.target.getList()[this.dindex].IS_READ;
                                        if (nvl(IS_READ) == 'Y') {
                                            return true;
                                        } else {
                                            return false;
                                        }
                                    }
                                }
                            }
                            /*
                            ,{key: "PARENT_CG_CD", label: "상위분류코드", width: 150   , align: "center" ,
                                formatter: function () {
                                    return $.changeTextValue(DATA_BRCODE, this.value)
                                }
                                , editor: {
                                    type: "select", config: {
                                        columnKeys: {
                                            optionValue: "value", optionText: "text"
                                        },
                                        options: DATA_BRCODE
                                    }, disabled: function () {
                                        return true;

                                    }
                                }
                            }
                            */
                            ,{key: "SORT", label: "정렬", width: 150, align: "center", editor: {type: "number"}}
                            ,{key: "LV", label: "레벨", width: 150, align: "center", editor: false}
                            ,{key: "LAST_YN", label: "최하위 여부", width: 150, align: "center",
                                formatter: function () {
                                    return $.changeTextValue(DATA_YN, this.value)
                                }
                                , editor: {
                                    type: "select", config: {
                                        columnKeys: {
                                            optionValue: "value", optionText: "text"
                                        },
                                        options: DATA_YN
                                    }, disabled: function () {
                                        return true;
                                    }
                                }
                            }
                            ,{key: "CG_SP", label: "분류유형", width: 150, align: "center",
                                formatter: function () {
                                    return $.changeTextValue(DATA_BRTYPE, this.value)
                                }
                                , editor: {
                                    type: "select", config: {
                                        columnKeys: {
                                            optionValue: "value", optionText: "text"
                                        },
                                        options: DATA_BRTYPE
                                    }, disabled: function () {
                                        //return true;
                                    }
                                }
                            }
                            ,{key: "FILE_YN", label: "파일여부", width: 150, align: "center",
                                formatter: function () {
                                    return $.changeTextValue(DATA_YN, this.value)
                                }
                                , editor: {
                                    type: "select", config: {
                                        columnKeys: {
                                            optionValue: "value", optionText: "text"
                                        },
                                        options: DATA_YN
                                    }, disabled: function () {
                                        //return true;
                                    }
                                }
                            }
                            ,{key: "SEE_YN", label: "노출여부", width: 150, align: "center",
                                formatter: function () {
                                    return $.changeTextValue(DATA_YN, this.value)
                                }
                                , editor: {
                                    type: "select", config: {
                                        columnKeys: {
                                            optionValue: "value", optionText: "text"
                                        },
                                        options: DATA_YN
                                    }, disabled: function () {
                                        //return true;
                                    }
                                }
                            }
                            ,{key: "IS_READ", label: "셀렉트해온데이터인지여부", width: 150, align: "center", editor: false,hidden: true}

                        ],

                        body: {
                            onDataChanged: function () {

                            },
                            //444
                            onClick: function () {
                                var index = this.dindex;
                                if(afterIndex == index){return false;}

                                /*
                                var data = [].concat(fnObj.gridView01.getData("modified"));

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
                                */
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
                            var chekVal;
                            $(fnObj.gridView01.target.list).each(function (i, e) {
                                if (e.__modified__) {
                                    chekVal = true;
                                }
                                if (e.__created__) {
                                    chekVal = true;
                                }
                            });

                            /*
                            if (chekVal) {
                                qray.alert("작업중인 데이터가 있습니다. 저장 후 진행하세요");
                                return;
                            }
                            */
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

                $("#ADM_PT_CD").on('dataBind', function (e) {
                    var itemH = fnObj.gridView01.getData('selected')[0];
                    fnObj.gridView01.target.setValue(itemH.__index , 'ADM_PT_CD', e.detail.PT_CD );
                    fnObj.gridView01.target.setValue(itemH.__index , 'ADM_PT_NM', e.detail.PT_NM );
                });

            });


            //분류코드,상위분류코드
            function getquerycode(SERVICENAME,ALL, FLAG1, FLAG2, FLAG3, CD_SYSDEF_ARRAY) {
                var codeInfo = [];
                axboot.ajax({
                    type: "POST",
                    url: ["Categorym", SERVICENAME],
                    data: JSON.stringify({COMPANY_CD: SCRIPT_SESSION.cdCompany}),
                    async: false,
                    callback: function (res) {
                        if (nvl(ALL, '') == '' || ALL == false || ALL == 'false' || ALL == 'FALSE') {  //  ALL 파라메터가 없거나 false이면 전체가 추가된다.
                            codeInfo.push({
                                CODE: '', VALUE: '', code: '', value: '', text: '', TEXT: ''
                            });
                        }
                        // console.log(" [ SELECT_COMMON_CODE - DATA :  ", res, " ] ")
                        res.list.forEach(function (n) {
                                if (nvl(FLAG1, '') != '' || nvl(FLAG2, '') != '' || nvl(FLAG3, '') != '') {
                                    if ((nvl(n.CD_FLAG1) != '' && n.CD_FLAG1 == FLAG1) ||
                                        (nvl(n.CD_FLAG2) != '' && n.CD_FLAG2 == FLAG2) ||
                                        (nvl(n.CD_FLAG3) != '' && n.CD_FLAG3 == FLAG3)) {

                                        if (nvl(CD_SYSDEF_ARRAY) != '' && CD_SYSDEF_ARRAY.length != 0) {
                                            for (var k = 0; k < CD_SYSDEF_ARRAY.length; k++) {
                                                if (CD_SYSDEF_ARRAY[k] == n.CD_SYSDEF) {
                                                    codeInfo.push({
                                                        CODE: n.CD_SYSDEF,
                                                        code: n.CD_SYSDEF,
                                                        value: n.CD_SYSDEF,
                                                        VALUE: n.CD_SYSDEF,
                                                        text: n.NM_SYSDEF,
                                                        TEXT: n.NM_SYSDEF,
                                                        CD_FLAG1: n.CD_FLAG1,
                                                        CD_FLAG2: n.CD_FLAG2,
                                                        CD_FLAG3: n.CD_FLAG3
                                                    });
                                                }
                                            }
                                        } else {
                                            codeInfo.push({
                                                CODE: n.CD_SYSDEF,
                                                code: n.CD_SYSDEF,
                                                value: n.CD_SYSDEF,
                                                VALUE: n.CD_SYSDEF,
                                                text: n.NM_SYSDEF,
                                                TEXT: n.NM_SYSDEF,
                                                CD_FLAG1: n.CD_FLAG1,
                                                CD_FLAG2: n.CD_FLAG2,
                                                CD_FLAG3: n.CD_FLAG3
                                            });
                                        }
                                    }
                                } else {
                                    if (nvl(CD_SYSDEF_ARRAY) != '' && CD_SYSDEF_ARRAY.length != 0) {
                                        for (var k = 0; k < CD_SYSDEF_ARRAY.length; k++) {
                                            if (CD_SYSDEF_ARRAY[k] == n.CD_SYSDEF) {
                                                codeInfo.push({
                                                    CODE: n.CD_SYSDEF,
                                                    code: n.CD_SYSDEF,
                                                    value: n.CD_SYSDEF,
                                                    VALUE: n.CD_SYSDEF,
                                                    text: n.NM_SYSDEF,
                                                    TEXT: n.NM_SYSDEF,
                                                    CD_FLAG1: n.CD_FLAG1,
                                                    CD_FLAG2: n.CD_FLAG2,
                                                    CD_FLAG3: n.CD_FLAG3
                                                });
                                            }
                                        }
                                    } else {
                                        codeInfo.push({
                                            CODE: n.CD_SYSDEF,
                                            code: n.CD_SYSDEF,
                                            value: n.CD_SYSDEF,
                                            VALUE: n.CD_SYSDEF,
                                            text: n.NM_SYSDEF,
                                            TEXT: n.NM_SYSDEF,
                                            CD_FLAG1: n.CD_FLAG1,
                                            CD_FLAG2: n.CD_FLAG2,
                                            CD_FLAG3: n.CD_FLAG3
                                        });
                                    }
                                }
                            }
                        );
                        // console.log(" [ SELECT_COMMON_CODE - RETURN :  ", codeInfo, " ] ")
                    }

                });

                return codeInfo;
            }

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
                } else {
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
                        <ax:td label='분류코드' width="350px">
                            <div id="S_BRCODE" name="S_BRCODE" data-ax5select="S_BRCODE"
                                 data-ax5select-config='{}' form-bind-type="selectBox"></div>
                        </ax:td>
                        <ax:td label='상위분류코드' width="350px">
                            <div id="S_PARENTBRCODE" name="S_PARENTBRCODE" data-ax5select="S_PARENTBRCODE"
                                 data-ax5select-config='{}' form-bind-type="selectBox"></div>
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