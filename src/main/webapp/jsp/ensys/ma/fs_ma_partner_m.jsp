<%@ page import="com.chequer.axboot.core.utils.MessageUtils" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>

<ax:set key="title" value="거래처계약관리"/>
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
            var beforeIdx = 0;
            var PT_SP         = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'MA00002');
            var CLOSING_TP    = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'MA00010');
            var TAX_SP        = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'MA00004');
            var COMT_SP       = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'MA00003');
            var CONTRACT_SP   = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'MA00012');
            var CONTRACT_STAT = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'MA00013');

            var YN_OP = [{value:'' , text:''},{value:'Y' , text:'Y'},{value:'N' , text:'N'}];

            var S_1 = $.DATA_SEARCH("BrandContract", 'S_1',{}).list;
            $("#S_1").ax5select({ options: [{value:'' , text:''}].concat(S_1) });

            $("#CONTRACT_SP").ax5select({
                options: CONTRACT_SP
            });
            $("#PT_SP").ax5select({
                options: PT_SP
            });
            $("#S_PT_SP").ax5select({
                options: PT_SP
            });
            $("#TAX_SP").ax5select({
                options: TAX_SP
            });
            $("#CLOSING_TP").ax5select({
                options: CLOSING_TP
            });

            $("#USE_YN").ax5select({
                options: YN_OP
            });

            $("#BRD_VERIFY_YN").ax5select({
                options: YN_OP
            });

            $("#S_CONTRACT").ax5select({
                options: CONTRACT_STAT
            });
            $("#CONTRACT_YN").ax5select({
                options: YN_OP
            });

            $('#CONTRACT_STAT').ax5select({
                options: CONTRACT_STAT,
                onStateChanged: function (e) {
                    if (e.state == "changeValue") {
                        if(e.value[0].value == '01' && SCRIPT_SESSION.cdGroup != 'WEB01'){
                            qray.alert('계약상태는 본사만 선택가능합니다. <br>[가계약 유형으로 대체됩니다.]')
                            $('[data-ax5select="CONTRACT_STAT"]').ax5select("setValue", '02');
                        }

                    }
                }
            });

            var CallBack1;
            var fnObj = {}, CODE = {};
            var ACTIONS = axboot.actionExtend(fnObj, {
                PAGE_SEARCH: function (caller, act, data) {
                    var param = {
                        SALES_PERSON_ID : $('#SALE_USER').getCodes()
                        , CONTRACT_YN : $('select[name="S_CONTRACT"]').val()
                        , PT_NM : $('#S_PT_NM').val()
                        , TEMP1 : $('select[name="S_PT_SP"]').val()
                        , TEMP2 : SCRIPT_SESSION.idUser
                        , TEMP3 : $('select[name="S_1"]').val()
                    };
                    var list = $.DATA_SEARCH('mapartnerm','getPartnerList',param).list;
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

                    var itemH = [].concat(caller.gridView01.getData("modified"));
                    itemH = itemH.concat(caller.gridView01.getData("deleted"));

                    for(var i = 0; i < itemH.length; i++){
                        if(nvl(itemH[i].__deleted__ , false) == false && nvl(itemH[i].CONTRACT_NO) == ''){
                            qray.alert('계약 번호는 필수입니다.')
                            return
                        }
                        if(nvl(itemH[i].CONTRACT_NO) != ''){
                            if(nvl(itemH[i].CONTRACT_SP) == ''){
                                qray.alert('계약유형은 필수입니다.')
                                return
                            }
                            if(nvl(itemH[i].CONTRACT_ST_DTE) == ''){
                                qray.alert('계약시작일은 필수입니다.')
                                return
                            }
                            if(nvl(itemH[i].CONTRACT_ED_DTE) == ''){
                                qray.alert('계약종료일은 필수입니다.')
                                return
                            }
                            if(nvl(itemH[i].CONTRACT_STAT) == ''){
                                qray.alert('계약상태는 필수입니다.')
                                return
                            }
                            if(nvl(itemH[i].PT_CONTRACT_PERSON) == ''){
                                qray.alert('거래처 계약담당자는 필수입니다.')
                                return
                            }
                            // if(nvl() == ''){
                            //     qray.alert('')
                            //     return
                            // }

                        }
                    }


                    if(itemH.length == 0){
                        qray.alert('변경된 정보가 없습니다.');
                        return;
                    }

                    var data = {
                        delete : caller.gridView01.getData("deleted")
                        ,insert : caller.gridView01.getData("modified")
                    };

                    qray.confirm({
                        msg: "저장하시겠습니까?"
                    }, function () {
                        if (this.key == "ok") {
                            axboot.ajax({
                                type: "PUT",
                                url: ["mapartnerm", "save"],
                                data: JSON.stringify(data),
                                callback: function (res) {
                                    qray.alert("저장 되었습니다.");
                                    ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                                    caller.gridView01.target.select(afterIndex);
                                    caller.gridView01.target.focus(afterIndex);

                                }
                            });
                        }
                    });
                },
                ITEM_CLICK: function (caller, act, data) {
                    var selected = caller.gridView01.getData('selected')[0];
                    if(SCRIPT_SESSION.cdGroup == 'WEB01'){
                        $('#MAIN_PT_CD').removeAttr('HELP_DISABLED')
                    }
                    // if(selected){
                    //     $('.QRAY_FORM').setFormData(selected);
                    // }
                    $('.QRAY_FORM').setFormData(selected);

                    if(nvl($('#CONTRACT_NO').val()) == ''){
                        Disabled()
                    }else{
                        Activation()
                    }
                    return false;
                },
                ITEM_ADD1: function (caller, act, data) {
                    var s1 = $('select[name="S_1"]').val()
                    // if(nvl(s1) == ''){
                    //     qray.alert('총판 선택이 선행되어야합니다.')
                    //     return;
                    // }
                    CallBack1 = function (e) {
                        var chkArr = [];
                        for (var i = 0; i < fnObj.gridView01.target.list.length; i++) {
                            chkArr.push(fnObj.gridView01.target.list[i].PT_CD);
                        }
                        chkArr = chkArr.join('|');

                        if (e.length > 0) {
                            for (var i = 0; i < e.length; i++) {
                                var item = e[i]
                                if (chkArr.indexOf(item.PT_CD) > -1) continue;
                                fnObj.gridView01.addRow();
                                var index = nvl(fnObj.gridView01.target.list.length, fnObj.gridView01.lastRow()) - 1;
                                caller.gridView01.target.select(index);
                                caller.gridView01.target.focus(index);
                                afterIndex = index
                                // for(var j = 0 ; j < Object.keys(item).length; j++){
                                //     var key = Object.keys(item)[j];
                                //     caller.gridView01.target.setValue(index, key, item[key]);
                                // }
                                var col = fnObj.gridView01.target.columns

                                col.forEach(function(data , i){
                                    var key = data.key

                                    if(nvl(item[key]) != ''){
                                        caller.gridView01.target.setValue(index, key, item[key]);
                                    }else{
                                        caller.gridView01.target.setValue(index, key, '');
                                    }
                                })

                                // fnObj.gridView02.target.setValue(item.__index, "SALES_PERSON_ID", SCRIPT_SESSION.idUser);
                                // fnObj.gridView02.target.setValue(item.__index, "SALES_PERSON_NM", SCRIPT_SESSION.nmUser);
                            }

                        }
                        modal.close();
                        ACTIONS.dispatch(ACTIONS.ITEM_CLICK,caller);
                    };
                    $.openCommonPopup("multiPartner2", "CallBack1", 'HELP_PARTNER3', '', {PT_CD : s1 }, 600, _pop_height, _pop_top);


                    ACTIONS.dispatch(ACTIONS.ITEM_CLICK);
                },

                ITEM_ADD2: function (caller, act, data) {

                    if (caller.gridView01.getData('selected').length == 0) {
                        qray.alert("선택된 거래처가 없습니다.");
                        return;
                    }

                    caller.gridView02.addRow();
                    var PT_CD = caller.gridView01.getData('selected')[0].PT_CD;
                    var lastIdx = nvl(caller.gridView02.target.list.length, caller.gridView02.lastRow());
                    caller.gridView02.target.select(lastIdx - 1);
                    caller.gridView02.target.focus(lastIdx - 1);
                    caller.gridView02.target.setValue(lastIdx - 1, "PT_CD", PT_CD);



                },
                ITEM_DEL1: function (caller, act, data) {

                    fnObj.gridView01.delRow("selected");

                }
                ,
                ITEM_DEL2: function (caller, act, data) {
                    caller.gridView02.delRow("selected");
                }
            });
            // fnObj 기본 함수 스타트와 리사이즈
            fnObj.pageStart = function () {
                this.pageButtonView.initView();
                this.searchView.initView();
                this.gridView01.initView();
                //this.gridView02.initView();

                if(SCRIPT_SESSION.cdGroup != 'WEB01'){
                    $('#add2').css('display','none')
                    $('#del2').css('display','none')
                }
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


                            if (chekVal) {
                                qray.alert("작업중인 데이터가 있습니다. 저장 후 진행하세요");
                                return;
                            }
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
                            ,{key: "PT_CD", label: "거래처코드", width: 150   , align: "center" , editor: false}
                            ,{key: "PT_SP", label: "거래처유형", width: 150   , align: "center" ,
                                formatter: function () {
                                    return $.changeTextValue(PT_SP, this.value)
                                }
                                , editor: {
                                    type: "select", config: {
                                        columnKeys: {
                                            optionValue: "value", optionText: "text"
                                        },
                                        options: PT_SP
                                    }, disabled: function () {
                                        return true;

                                    }
                                }
                            }
                            ,{key: "PT_NM", label: "거래처 명", width: 150, align: "center", editor: false}
                            ,{key: "BIZ_NO", label: "사업자번호", width: 150, align: "center", editor: false
                                ,formatter: function () {
                                    return $.changeDataFormat( this.value , 'company')
                                }
                            }
                            ,{key: "OWNER_NM", label: "대표자명", width: 150, align: "center", editor: false}
                            ,{key: "SIGN_NM", label: "간판명", width: 150, align: "center", editor: false ,hidden:true}
                            ,{key: "PT_TYPE", label: "거래처업종", width: 150, align: "center", editor: false ,hidden:true}
                            ,{key: "PT_COND", label: "거래처업태", width: 150, align: "center", editor: false ,hidden:true}
                            ,{key: "TEL_NO", label: "전화번호", width: 150, align: "center", editor: false ,hidden:true}
                            ,{key: "HP_NO", label: "휴대폰번호", width: 150, align: "center", editor: false ,hidden:true}
                            ,{key: "POST_NO", label: "우편번호", width: 150, align: "center", editor: false ,hidden:true}
                            ,{key: "PT_ADDR", label: "거래처 주소", width: 150, align: "center", editor: false ,hidden:true}
                            ,{key: "SYSDEF_ADDR", label: "상세주소", width: 150, align: "center", editor: false ,hidden:true}
                            ,{key: "FAX_NO", label: "팩스번호", width: 150, align: "center", editor: false ,hidden:true}
                            ,{key: "CLOSING_TP", label: "휴폐업구분", width: 150, align: "center", editor: false ,hidden:true}
                            ,{key: "USE_YN", label: "사용여부", width: 150, align: "center", editor: false ,hidden:true}
                            ,{key: "SALES_PERSON_ID", label: "영업담당자아이디", width: 150, align: "center", editor: false ,hidden:true}
                            ,{key: "SALES_PERSON_NM", label: "영업담당자명", width: 150, align: "center", editor: false ,hidden:true}
                            ,{key: "TAX_SP", label: "과세유형", width: 150, align: "center", editor: false ,hidden:true}
                            ,{key: "BRD_VERIFY_YN", label: "브랜드검증여부", width: 150, align: "center", editor: false ,hidden:true}
                            ,{key: "CONTRACT_YN", label: "계약여부", width: 150, align: "center", editor: false ,hidden:true}
                            ,{key: "LAT_CD", label: "위도코드", width: 150, align: "center", editor: false ,hidden:true}
                            ,{key: "LONG_CD", label: "경도코드", width: 150, align: "center", editor: false ,hidden:true}
                            ,{key: "DELI_AMT", label: "배송금액", width: 150, align: "center", editor: false ,hidden:true}
                            ,{key: "FREE_DELI_AMT", label: "무료배송금액", width: 150, align: "center", editor: false ,hidden:true}
                            ,{key: 'CONTRACT_NO'        , label: '계약 번호'          , width: 0 , align: "center" , editor: false  ,hidden:true}
                            ,{key: 'JOIN_PT_CD'         , label: '가맹 거래처 코드'   , width: 0 , align: "center" , editor: false  ,hidden:true}
                            ,{key: 'JOIN_PT_NM'         , label: '가맹 거래처명'      , width: 0 , align: "center" , editor: false  ,hidden:true}
                            ,{key: 'MAIN_PT_CD'         , label: '주체 거래처 코드'   , width: 0 , align: "center" , editor: false  ,hidden:true}
                            ,{key: 'MAIN_PT_NM'         , label: '주체 거래처명'      , width: 0 , align: "center" , editor: false  ,hidden:true}
                            ,{key: 'CONTRACT_SP'        , label: '계약 유형'          , width: 0 , align: "center" , editor: false  ,hidden:true}
                            ,{key: 'CONTRACT_ST_DTE'    , label: '계약 시작 일자'     , width: 0 , align: "center" , editor: false  ,hidden:true}
                            ,{key: 'CONTRACT_ED_DTE'    , label: '계약 종료 일자'     , width: 0 , align: "center" , editor: false  ,hidden:true}
                            ,{key: 'CONTRACT_STAT'      , label: '계약 상태'          , width: 0 , align: "center" , editor: false  ,hidden:true}
                            ,{key: 'PT_CONTRACT_PERSON' , label: '거래처 계약 담당자' , width: 0 , align: "center" , editor: false  ,hidden:true}
                            ,{key: 'PT_CONTRACT_PERSON_NM' , label: '거래처 계약 담당자' , width: 0 , align: "center" , editor: false  ,hidden:true}
                            ,{key: 'SALES_PERSON_ID2'    , label: '영업 담당자 아이디' , width: 0 , align: "center" , editor: false  ,hidden:true}
                            ,{key: 'SALES_PERSON_NM2'    , label: '영업 담당자 아이디' , width: 0 , align: "center" , editor: false  ,hidden:true}
                            ,{key: 'CD_AREA'    , label: '법정동코드' , width: 0 , align: "center" , editor: false  ,hidden:true}
                            ,{key: 'LV1_AREA_CD'    , label: '' , width: 0 , align: "center" , editor: false  ,hidden:true}
                            ,{key: 'LV2_AREA_CD'    , label: '' , width: 0 , align: "center" , editor: false  ,hidden:true}
                            ,{key: 'LV3_AREA_CD'    , label: '' , width: 0 , align: "center" , editor: false  ,hidden:true}
                            ,{key: 'LV4_AREA_CD'    , label: '' , width: 0 , align: "center" , editor: false  ,hidden:true}
                            ,{key: 'NO_EMAIL'    , label: '' , width: 0 , align: "center" , editor: false  ,hidden:true}
                            ,{key: 'NO_DEPOSIT'    , label: '' , width: 0 , align: "center" , editor: false  ,hidden:true}
                            ,{key: 'CD_BANK'    , label: '' , width: 0 , align: "center" , editor: false  ,hidden:true}
                            ,{key: 'NM_BANK'    , label: '' , width: 0 , align: "center" , editor: false  ,hidden:true}
                            ,{key: 'TAB_GRID2_OBJ'    , label: '' , width: 0 , align: "center" , editor: false  ,hidden:true}
                        ],

                        body: {
                            onDataChanged: function () {

                            },
                            //444
                            onClick: function () {
                                var index = this.dindex;
                                if(afterIndex == index){return false;}

                                var data = []
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


                            if (chekVal) {
                                qray.alert("작업중인 데이터가 있습니다. 저장 후 진행하세요");
                                return;
                            }
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
                $(".QRAY_FORM").find("[data-ax5select]").change(function () {
                    console.log("data-ax5select 변경", this);
                    var itemH = fnObj.gridView01.getData('selected')[0];
                    fnObj.gridView01.target.setValue(itemH.__index , this.id, $('select[name="' +this.id+ '"]').val() )
                });

                $(".QRAY_FORM").find("input").change(function () {
                    console.log("input 변경", this);
                    var itemH = fnObj.gridView01.getData('selected')[0];
                    fnObj.gridView01.target.setValue(itemH.__index , this.id, $('#'+this.id).val() )
                    // var itemH = fnObj.gridView01.getData('selected')[0]
                    // fnObj.gridView01.setData(itemH.__index , this.id, $('select[name="' +this.id+ '"]').val() )
                });

                $("#SALES_PERSON_ID").on('dataBind', function (e) {
                    var itemH = fnObj.gridView01.getData('selected')[0];
                    fnObj.gridView01.target.setValue(itemH.__index , 'SALES_PERSON_ID', e.detail.ID_USER )
                });
                $("#MAIN_PT_CD").on('dataBind', function (e) {
                    var itemH = fnObj.gridView01.getData('selected')[0];
                    fnObj.gridView01.target.setValue(itemH.__index , 'MAIN_PT_CD', e.detail.PT_CD )
                });
                $("#JOIN_PT_CD").on('dataBind', function (e) {
                    var itemH = fnObj.gridView01.getData('selected')[0];
                    fnObj.gridView01.target.setValue(itemH.__index , 'JOIN_PT_CD', e.detail.PT_CD )
                });
                $("#CD_BANK").on('dataBind', function (e) {
                    var itemH = fnObj.gridView01.getData('selected')[0];
                    fnObj.gridView01.target.setValue(itemH.__index , 'CD_BANK', e.detail.CD_BANK )
                    fnObj.gridView01.target.setValue(itemH.__index , 'NM_BANK', e.detail.NM_BANK )
                });
                $("#PT_CONTRACT_PERSON").on('dataBind', function (e) {
                    var itemH = fnObj.gridView01.getData('selected')[0];
                    fnObj.gridView01.target.setValue(itemH.__index , 'PT_CONTRACT_PERSON', e.detail.ID_USER )
                });


            });

            function post() {
                axboot.modal.open({
                    modalType: "ZIPCODE",
                    param: "",
                    header: {title: LANG("ax.script.address.finder.title")},
                    sendData: function () {
                        return {};
                    },
                    callback: function (data) {
                        $("#POST_NO").val(data.zipcode);
                        $("#PT_ADDR").val(data.zipcodeData.address);
                        if (fnObj.gridView01.getData('selected').length > 0) {
                            var selectIdx = fnObj.gridView01.getData('selected')[0].__index;
                            fnObj.gridView01.target.setValue(selectIdx, 'POST_NO', data.zipcode);
                            fnObj.gridView01.target.setValue(selectIdx, 'PT_ADDR', data.zipcodeData.address);
                            fnObj.gridView01.target.setValue(selectIdx, 'CD_AREA', data.zipcodeData.sigunguCode);
                            var geocoder;
                            try{
                                geocoder = new kakao.maps.services.Geocoder();
                                geocoder.addressSearch(data.zipcodeData.address,kakaoCallback)
                            }catch(e){
                                this.close();
                            }
                        }
                        this.close();
                    }
                });
            }

            var kakaoCallback = function(result, status){
                if (status === kakao.maps.services.Status.OK) {
                    var selectIdx = fnObj.gridView01.getData('selected')[0].__index;
                    fnObj.gridView01.target.setValue(selectIdx, 'LAT_CD', result[0].x);
                    fnObj.gridView01.target.setValue(selectIdx, 'LONG_CD', result[0].y);
                }
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

            $('.cqc-cog').click(function(){
                if(nvl($('#CONTRACT_NO').val()) == ''){

                    if($('#BIZ_NO').val() == ''){
                        qray.alert('계약시 사업자번호는 필수입니다.')
                        return;
                    }

                    var block = $.DATA_SEARCH('mapartnerm','checkBlock',{ BIZ_NO : $('#BIZ_NO').val()}).list;
                    if(block.length > 0){
                        qray.alert('해당 사업자 번호는 블랙리스트 대상입니다.')
                        return;
                    }
                    $('#CONTRACT_NO').val(GET_NO('MA','03'))
                    var itemH = fnObj.gridView01.getData('selected')[0]
                    fnObj.gridView01.target.setValue(itemH.__index , 'CONTRACT_NO',$('#CONTRACT_NO').val())
                    fnObj.gridView01.target.setValue(itemH.__index , 'CONTRACT_ST_DTE',ax5.util.date(today, {"return": "yyyy-MM-dd"}))
                    fnObj.gridView01.target.setValue(itemH.__index , 'CONTRACT_ED_DTE','9999-12-31')
                    Activation()
                }else{
                    // Disabled()
                }

            })
            function Disabled(){
                //$('#CONTRACT_NO').removeAttr('readonly')
                $("#CONTRACT_SP select").attr("disabled", "disabled");
                $("#CONTRACT_SP a").attr("disabled", "disabled");
                $("#CONTRACT_STAT select").attr("disabled", "disabled");
                $("#CONTRACT_STAT a").attr("disabled", "disabled");
                $('#JOIN_PT_CD').attr('HELP_DISABLED','true')
                $('#MAIN_PT_CD').attr('HELP_DISABLED','true')
                $('#PT_CONTRACT_PERSON').attr('HELP_DISABLED','true')
                $('#CONTRACT_ST_DTE').attr('readonly','readonly')
                $('#CONTRACT_ED_DTE').attr('readonly','readonly')
            }

            function Activation(){
                //$('#CONTRACT_NO').attr('readonly','readonly')
                $("#CONTRACT_SP select").removeAttr("disabled");
                $("#CONTRACT_SP a").removeAttr("disabled");
                $("#CONTRACT_STAT select").removeAttr("disabled");
                $("#CONTRACT_STAT a").removeAttr("disabled");
                // $('#JOIN_PT_CD').removeAttr('HELP_DISABLED')
                $('#MAIN_PT_CD').removeAttr('HELP_DISABLED')
                $('#PT_CONTRACT_PERSON').removeAttr('HELP_DISABLED')
                $('#CONTRACT_ST_DTE').removeAttr('readonly')
                $('#CONTRACT_ED_DTE').removeAttr('readonly')
            }

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
                var datarealheight = $("#ax-base-root").height() - $(".ax-base-title").height() - $("#pageheader").height();
                //타이틀을 뺀 상하단 그리드 합친높이
                var tempgridheight = datarealheight - $("#left_title").height() - $("#bottom_left_title").height() - $("#bottom_left_amt").height();

                $("#left_grid").css("height" ,(tempgridheight / 100 * 99));
                $("#right_content").css("height" ,( (datarealheight - $("#left_title").height()) / 100 * 99));

                $("#tab_area").css("height", (tempgridheight / 100 * 99) - 30);
                $("#tab2_grid").css("height", $("#tab_area").height() - $("#tab2_button").height() - 40);
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

        <div role="page-header" id="pageheader">
            <ax:form name="searchView0">
                <ax:tbl clazz="ax-search-tb1" minWidth="500px">
                    <ax:tr>
                        <ax:td label='총판' width="300px">
                            <div id="S_1" name="S_1" data-ax5select="S_1"
                                 data-ax5select-config='{}' form-bind-type="selectBox"></div>
                        </ax:td>
                        <ax:td label='거래처유형' width="350px">
                            <div id="S_PT_SP" name="S_PT_SP" data-ax5select="S_PT_SP"
                                 data-ax5select-config='{}' form-bind-type="selectBox"></div>
                        </ax:td>
                        <ax:td label="거래처명 검색" width="350px">
                            <div class="input-group" style="width:100%">
                                <input type="text" class="form-control" name="s_cd_partner" id="S_PT_NM" style="width:100%"/>
                            </div>
                        </ax:td>
                        <ax:td label='영업사원' width="350px">
                            <multipicker id="SALE_USER" HELP_ACTION="HELP_USER" HELP_URL="multiUser"
                                         BIND-CODE="ID_USER"
                                         BIND-TEXT="NM_EMP"/>
                        </ax:td>

                        <ax:td label='계약상태' width="200px">
                            <div id="S_CONTRACT" name="S_CONTRACT" data-ax5select="S_CONTRACT"
                                 data-ax5select-config='{}' form-bind-type="selectBox"></div>
                        </ax:td>
                    </ax:tr>
                </ax:tbl>
            </ax:form>
        </div>

        <%-- 그리드 영역 시작 --%>
        <div style="width:100%;overflow:hidden">
            <div style="width:49%;float:left;overflow:hidden;">
                <div class="ax-button-group" data-fit-height-aside="grid-view-01" id="left_title" name="왼쪽그리드타이틀">
                    <div class="left">
                        <h2>
                            <i class="icon_list"></i> 거래처리스트
                        </h2>
                    </div>
                    <div class="right">

                        <div style="float: right">
                            <button type="button" class="btn btn-small" data-grid-view-01-btn="add" style="width:80px;"><i
                                    class="icon_add"></i><ax:lang id="ax.admin.add"/></button>
                            <button type="button" class="btn btn-small" data-grid-view-01-btn="delete" style="width:80px;">
                                <i class="icon_del"></i> <ax:lang id="ax.admin.delete"/></button>
                        </div>
                    </div>
                </div>



                <div data-ax5grid="grid-view-01"
                     data-ax5grid-config="{  showLineNumber: true,showRowSelector: false, multipleSelect: false,lineNumberColumnWidth: 40,rowSelectorColumnWidth: 27, }"
                     id = "left_grid"
                     name="왼쪽그리드"
                ></div>
            </div>
            <div style="width:50%;float:right;overflow:hidden;">
                <div class="ax-button-group" id="right_title" name="오른쪽부분타이틀">
                    <div class="left">
                        <h2>
                            <i class="icon_list"></i> 상세정보
                        </h2>
                    </div>
                        <%--                    <div class="right">--%>
                        <%--                        <button type="button" class="btn btn-info" data-page-btn="newAdd" style="width: 80px;">--%>
                        <%--                            신규--%>
                        <%--                        </button>--%>
                        <%--                        <button type="button" class="btn btn-info" data-page-btn="delete" id="delete_btn"--%>
                        <%--                                style="width: 80px;">삭제--%>
                        <%--                        </button>--%>
                        <%--                    </div>--%>
                </div>
                <div id="right_content" style="overflow-y:auto;" name="오른쪽부분내용">
                    <div class="QRAY_FORM">

                        <ax:form name="binder-form">
                            <ax:tbl clazz="ax-search-tb2" minWidth="600px">
                                <ax:tr>
                                    <ax:td label='거래처코드' width="300px">
                                        <input type="text" class="form-control" data-ax-path="PT_CD" style="background: #ffe0cf;"
                                               name="PT_CD" id="PT_CD" form-bind-text = 'PT_CD' form-bind-type ='text' readonly/>
                                    </ax:td>
                                    <ax:td label='거래처유형' width="300px">
                                        <div id="PT_SP" name="PT_SP" data-ax5select="PT_SP"
                                             data-ax5select-config='{}' form-bind-type="selectBox"></div>
                                    </ax:td>
                                </ax:tr>
                                <ax:tr>
                                    <ax:td label='사업자명' width="300px">
                                        <input type="text" class="form-control" data-ax-path="PT_NM"
                                               name="PT_NM" id="PT_NM" form-bind-text = 'PT_NM' form-bind-type ='text'/>
                                    </ax:td>
                                    <ax:td label='간판명' width="300px">
                                        <input type="text" class="form-control" data-ax-path="SIGN_NM"
                                               name="SIGN_NM" id="SIGN_NM" form-bind-text = 'SIGN_NM' form-bind-type ='text'/>
                                    </ax:td>
                                </ax:tr>
                                <ax:tr>
                                    <ax:td label='대표자명' width="300px">
                                        <input type="text" class="form-control" data-ax-path="OWNER_NM" autocomplete="nope"
                                               name="OWNER_NM" id="OWNER_NM" form-bind-text = 'OWNER_NM' form-bind-type ='text'/>
                                    </ax:td>
                                    <ax:td label='사업자번호' width="300px">
                                        <input type="text" class="form-control" data-ax-path="BIZ_NO"
                                               name="BIZ_NO" id="BIZ_NO" form-bind-text = 'BIZ_NO' form-bind-type ='text' formatter="company" maxlength="12"/>
                                    </ax:td>
                                </ax:tr>

                                <ax:tr>
                                    <ax:td label='거래처업종' width="300px">
                                        <input type="text" class="form-control" data-ax-path="PT_TYPE"
                                               name="PT_TYPE" id="PT_TYPE" form-bind-text = 'PT_TYPE' form-bind-type ='text'/>
                                    </ax:td>
                                    <ax:td label='거래처업태' width="300px">
                                        <input type="text" class="form-control" data-ax-path="PT_COND"
                                               name="PT_COND" id="PT_COND" form-bind-text = 'PT_COND' form-bind-type ='text'/>
                                    </ax:td>
                                </ax:tr>
                                <ax:tr>
                                    <ax:td label='전화번호' width="300px">
                                        <input type="text" class="form-control" data-ax-path="TEL_NO"
                                               name="TEL_NO" id="TEL_NO" form-bind-text = 'TEL_NO' form-bind-type ='text' maxlength="13"/>
                                    </ax:td>
                                    <ax:td label='휴대폰번호' width="300px">
                                        <input type="text" class="form-control" data-ax-path="HP_NO"
                                               name="HP_NO" id="HP_NO" form-bind-text = 'HP_NO' form-bind-type ='text' formatter="tel" maxlength="13"/>
                                    </ax:td>
                                </ax:tr>
                                <ax:tr>
                                    <ax:td label='거래처 주소' width="600px">
                                        <input type="text" class="form-control_02" data-ax-path="POST_NO" style="width: 100px;" readonly="readonly"
                                               name="POST_NO" id="POST_NO" form-bind-text = 'POST_NO' form-bind-type ='post'/>
                                        <input type="text" class="form-control_02" data-ax-path="PT_ADDR" style="width: 200px" readonly="readonly"
                                               name="PT_ADDR" id="PT_ADDR" form-bind-text = 'PT_ADDR' form-bind-type ='text'/>
                                        <input type="button" class="form-control_02" id="btn_cd_partner"
                                               onclick="post()" value="우편번호 조회">
                                    </ax:td>

                                </ax:tr>
                                <ax:tr>
                                    <ax:td label='상세주소' width="300px">
                                        <input type="text" class="form-control" data-ax-path="SYSDEF_ADDR"
                                               name="SYSDEF_ADDR" id="SYSDEF_ADDR" form-bind-text = 'SYSDEF_ADDR' form-bind-type ='text'/>
                                    </ax:td>
                                    <ax:td label='팩스번호' width="300px">
                                        <input type="text" class="form-control" data-ax-path="FAX_NO"
                                               name="FAX_NO" id="FAX_NO" form-bind-text = 'FAX_NO' form-bind-type ='text'/>
                                    </ax:td>
                                </ax:tr>
                                <ax:tr>
                                    <ax:td label='계좌번호' width="300px">
                                        <input type="text" class="form-control" data-ax-path="NO_DEPOSIT"
                                               name="NO_DEPOSIT" id="NO_DEPOSIT" form-bind-text = 'NO_DEPOSIT' form-bind-type ='text'/>
                                    </ax:td>
                                    <ax:td label='계좌은행' width="300px">
                                        <codepicker id="CD_BANK" HELP_ACTION="HELP_BANK" HELP_URL="bank" BIND-CODE="CD_BANK"
                                                    BIND-TEXT="NM_BANK" READONLY
                                                    form-bind-type="codepicker" form-bind-text="NM_BANK" form-bind-code="CD_BANK"/>
                                    </ax:td>
                                </ax:tr>
                                <ax:tr>
                                    <ax:td label='배송금액' width="300px">
                                        <input type="text" class="form-control" data-ax-path="DELI_AMT" formatter ="money"
                                               name="DELI_AMT" id="DELI_AMT" form-bind-text = 'DELI_AMT' form-bind-type ='money' decimal-formatter="###.##"/>
                                    </ax:td>
                                    <ax:td label='무료배송금액' width="300px">
                                        <input type="text" class="form-control" data-ax-path="FREE_DELI_AMT" formatter ="money"
                                               name="FREE_DELI_AMT" id="FREE_DELI_AMT" form-bind-text = 'FREE_DELI_AMT' form-bind-type ='text'/>
                                    </ax:td>
                                </ax:tr>
                                <ax:tr>
                                    <ax:td label='휴폐업구분' width="300px">
                                        <div id="CLOSING_TP" name="CLOSING_TP" data-ax5select="CLOSING_TP"
                                             data-ax5select-config='{}' form-bind-type="selectBox"></div>
                                    </ax:td>
                                    <ax:td label='과세유형' width="300px">
                                        <div id="TAX_SP" name="TAX_SP" data-ax5select="TAX_SP"
                                             data-ax5select-config='{}' form-bind-type="selectBox"></div>
                                    </ax:td>
                                </ax:tr>
                                <ax:tr>
                                    <ax:td label='사용여부' width="300px">
                                        <div id="USE_YN" name="USE_YN" data-ax5select="USE_YN"
                                             data-ax5select-config='{}' form-bind-type="selectBox"></div>
                                    </ax:td>
                                    <ax:td label='브랜드검증여부' width="300px">
                                        <div id="BRD_VERIFY_YN" name="BRD_VERIFY_YN" data-ax5select="BRD_VERIFY_YN"
                                             data-ax5select-config='{}' form-bind-type="selectBox"></div>
                                    </ax:td>
                                    <%--                                <ax:td label='영업담당자아이디' width="300px">--%>
                                    <%--                                    <codepicker id="SALES_PERSON_ID" HELP_ACTION="HELP_USER" HELP_URL="user" BIND-CODE="USER_ID"--%>
                                    <%--                                                BIND-TEXT="USER_NM" READONLY--%>
                                    <%--                                                form-bind-type="codepicker" form-bind-text="SALES_PERSON_NM" form-bind-code="SALES_PERSON_ID"/>--%>
                                    <%--                                </ax:td>--%>
                                </ax:tr>
                                <%--                            <ax:tr>--%>
                                <%--                                <ax:td label='브랜드검증여부' width="300px">--%>
                                <%--                                    <div id="BRD_VERIFY_YN" name="BRD_VERIFY_YN" data-ax5select="BRD_VERIFY_YN"--%>
                                <%--                                         data-ax5select-config='{}' form-bind-type="selectBox"></div>--%>
                                <%--                                </ax:td>--%>
                                <%--                                <ax:td label='계약여부' width="300px">--%>
                                <%--                                    <div id="CONTRACT_YN" name="CONTRACT_YN" data-ax5select="CONTRACT_YN"--%>
                                <%--                                         data-ax5select-config='{}' form-bind-type="selectBox"></div>--%>
                                <%--                                </ax:td>--%>
                                <%--                            </ax:tr>--%>
                                <div class="ax-button-group">
                                    <div class="left">
                                        <h2>
                                            <i class="icon_list"></i> 계약관리
                                        </h2>
                                    </div>
                                </div>
                                <ax:tr>
                                    <ax:td label='계약번호' width="300px">
                                        <div class="input-group">
                                            <input type="text" class="form-control" data-ax-path="CONTRACT_NO"
                                                   name="CONTRACT_NO" id="CONTRACT_NO" form-bind-text = 'CONTRACT_NO' form-bind-type ='text' style="background: #ffe0cf;" readonly/>
                                            <span class="input-group-addon"><i class="cqc-cog"></i> </span>
                                        </div>

                                    </ax:td>
                                    <ax:td label='가맹 거래처코드' width="300px">
                                        <codepicker id="JOIN_PT_CD" HELP_ACTION="HELP_PARTNER" HELP_URL="partner" BIND-CODE="PT_CD"
                                                    BIND-TEXT="PT_NM" HELP_DISABLED="true" READONLY
                                                    form-bind-type="codepicker" form-bind-text="JOIN_PT_NM" form-bind-code="JOIN_PT_CD"/>
                                    </ax:td>
                                </ax:tr>
                                <ax:tr>
                                    <ax:td label='주체 거래처코드' width="300px">
                                        <codepicker id="MAIN_PT_CD" HELP_ACTION="HELP_PARTNER" HELP_URL="partner" BIND-CODE="PT_CD"
                                                    BIND-TEXT="PT_NM" HELP_DISABLED="true" READONLY
                                                    form-bind-type="codepicker" form-bind-text="MAIN_PT_NM" form-bind-code="MAIN_PT_CD"/>
                                    </ax:td>
                                    <ax:td label='계약유형' width="300px">
                                        <div id="CONTRACT_SP" name="CONTRACT_SP" data-ax5select="CONTRACT_SP"
                                             data-ax5select-config='{}' form-bind-type="selectBox"></div>
                                    </ax:td>
                                </ax:tr>
                                <ax:tr>
                                    <ax:td label='계약시작일자' width="300px">
                                        <input type="text" class="form-control" data-ax-path="CONTRACT_ST_DTE" maxlength="10"
                                               name="CONTRACT_ST_DTE" id="CONTRACT_ST_DTE" form-bind-text = 'CONTRACT_ST_DTE' formatter="YYYYMMDD" form-bind-type ='YYYYMMDD' />
                                    </ax:td>
                                    <ax:td label='계약종료일자' width="300px">
                                        <input type="text" class="form-control" data-ax-path="CONTRACT_ED_DTE" maxlength="10"
                                               name="CONTRACT_ED_DTE" id="CONTRACT_ED_DTE" form-bind-text = 'CONTRACT_ED_DTE' formatter="YYYYMMDD" form-bind-type ='YYYYMMDD' />
                                    </ax:td>
                                </ax:tr>
                                <ax:tr>
                                    <ax:td label='계약상태' width="300px">
                                        <div id="CONTRACT_STAT" name="CONTRACT_STAT" data-ax5select="CONTRACT_STAT"
                                             data-ax5select-config='{}' form-bind-type="selectBox"></div>
                                    </ax:td>
                                    <ax:td label='거래처계약담당자' width="300px">
                                        <codepicker id="PT_CONTRACT_PERSON" HELP_ACTION="HELP_USER2" HELP_URL="user" BIND-CODE="USER_ID"
                                                    BIND-TEXT="USER_NM" READONLY
                                                    form-bind-type="codepicker" form-bind-text="PT_CONTRACT_PERSON_NM" form-bind-code="PT_CONTRACT_PERSON"/>
                                    </ax:td>
                                </ax:tr>
                                <%--                            <ax:tr>--%>
                                <%--                                <ax:td label='영업담당자아이디' width="300px">--%>
                                <%--                                    <codepicker id="SALES_PERSON_ID2" HELP_ACTION="HELP_USER" HELP_URL="user" BIND-CODE="USER_ID"--%>
                                <%--                                                BIND-TEXT="USER_NM" READONLY--%>
                                <%--                                                form-bind-type="codepicker" form-bind-text="SALES_PERSON_NM2" form-bind-code="SALES_PERSON_ID2"/>--%>
                                <%--                                </ax:td>--%>
                                <%--                            </ax:tr>--%>


                            </ax:tbl>
                        </ax:form>

                    </div>
                </div>
            </div>
        </div>


    </jsp:body>
</ax:layout>