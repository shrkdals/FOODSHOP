<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>

<ax:set key="title" value="거래처 검색 도움창"/>
<ax:set key="page_desc" value="${PAGE_REMARK}"/>
<ax:set key="page_auto_height" value="true"/>

<ax:layout name="base">
    <jsp:attribute name="script">

        <ax:script-lang key="ax.script"/>
        <script type="text/javascript">
            var param = ax5.util.param(ax5.info.urlUtil().param);
            var PT_SP = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'MA00002');
            var initData;
            if (param.modalName) {
                initData = eval("parent." + param.modalName + ".modalConfig.sendData()");  // 부모로 부터 받은 Parameter Object
            } else {
                initData = parent.modal.modalConfig.sendData();  // 부모로 부터 받은 Parameter Object
            }
            if(typeof initData.initData == 'object'){
                var sendData = initData.initData;
            }else{
                var sendData = JSON.parse(initData.initData);
            }


            if (sendData != null) {
                initData.CD_DEPT = sendData.CD_DEPT
            } else {
                initData.CD_DEPT = ''
            }
            initData.P_KEYWORD = $("#KEYWORD").val();

            var fnObj = {};
            var ACTIONS = axboot.actionExtend(fnObj, {
                PAGE_CLOSE: function (caller, act, data) {
                    parent.modal.close();
                },
                PAGE_SEARCH: function (caller, act, data) {
                    initData.P_KEYWORD = $("#KEYWORD").val();
                    initData.PT_SP = nvl(initData.initData.PT_SP)
                    var temp = isChecked(fnObj.gridView01.getData());

                    if(initData && initData['initData'] && nvl(initData['initData']['DEFAULT_VALUE']) != ''){
                        temp = temp.concat(initData.initData.DEFAULT_VALUE);
                        initData.initData.DEFAULT_VALUE = null
                    }

                    var data = $.DATA_SEARCH("commonHelp", "HELP_PARTNER", initData, fnObj.gridView01).list;

                    var chkArr = [];
                    var temp2 = [];
                    for (var i = 0; i < temp.length; i++) {
                        chkArr.push(temp[i].PT_CD);
                    }
                    chkArr = chkArr.join('|');

                    if(temp.length > 0){
                        for (var i = 0; i < data.length; i++) {
                            if (chkArr.indexOf(data[i].PT_CD) == -1) {
                                temp2.push(data[i])
                            }
                        }
                        fnObj.gridView01.setData(temp.concat(temp2))
                    }else{
                        fnObj.gridView01.setData(data)
                    }
                    return false;

                },
                ITEM_SELECT: function (caller, act, data) {
                    list = isChecked(fnObj.gridView01.getData());
                    if (list.length == 0) {
                        qray.alert("체크된 데이터가 없습니다.");
                        return false;
                    }

                    qray.confirm({
                        msg: "선택한 데이터가 많을 경우 \n 속도가 저하가 될 수 있습니다. \n 선택하시겠습니까 ?"
                    }, function () {
                        if (this.key == "ok") {
                            qray.loading.show("데이터 선택 중입니다.", 200).then(function () {
                                parent[param.callBack](list);
                                qray.loading.hide();
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

                ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
            };

            fnObj.pageResize = function () {

            };


            fnObj.pageButtonView = axboot.viewExtend({
                initView: function () {
                    axboot.buttonClick(this, "data-page-btn", {
                        "select": function () {
                            ACTIONS.dispatch(ACTIONS.ITEM_SELECT);
                        }
                    });

                    axboot.buttonClick(this, "data-page-btn", {
                        "close": function () {
                            ACTIONS.dispatch(ACTIONS.PAGE_CLOSE);
                        }
                    });

                    axboot.buttonClick(this, "data-page-btn", {
                        "search": function () {
                            ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                        }
                    });
                }
            });

            //== view 시작
            /**
             * searchView
             */
            fnObj.searchView = axboot.viewExtend(axboot.searchView, {
                initView: function () {
                    this.target = $(document["searchView0"]);
                    this.target.attr("onsubmit", "return ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);");
                    // this.KEYWORD = $("#KEYWORD");
                },
                getData: function () {
                    var components = document.getElementById('searchView0');
                    var columns = {};
                    for (var i = 0; i < components.length; i++) {
                        var columnName = components[i].getAttribute("name");
                        if (columnName != null) {
                            if (columnName.substring(0, 2) == 'P_') {       //  조회조건 중 ID값들에 'P_' 가 붙은 것이 있다면
                                columns[columnName] = components[i].value
                            } else {                                        //  조회조건 중 ID값들에 'P_' 가 안붙은 것이 있다면
                                columns["P_" + columnName] = components[i].value
                            }
                            console.log(JSON.stringify(columns));
                        }
                    }
                    return {
                        data: columns
                    }
                }
            });

            fnObj.gridView01 = axboot.viewExtend(axboot.gridView, {
                initView: function () {
                    var _this = this;
                    var USER_SP       = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'MA00001');
                    this.target = axboot.gridBuilder({
                        showRowSelector: false,
                        frozenColumnIndex: 0,
                        target: $('[data-ax5grid="grid-view-01"]'),
                        columns: [
                            {
                                key: "CHKED", label: "", width: 30, align: "center",
                                label:
                                    '<div id="headerBox" data-ax5grid-editor="checkbox" data-ax5grid-checked="false" data-ax5grid-column-selected="true" style="height:17px;width:17px;margin-top:2px;  onclick="javascript:alert(1);"></div>',
                                editor: {
                                    type: "checkbox", config: {height: 17, trueValue: true, falseValue: false}
                                }
                            }
                            ,{key: "COMPANY_CD", label: "회사코드", width: 150 , align: "left" , editor: {type: "text"},hidden:true}
                            ,{key: "PT_CD", label: "거래처코드", width: 150   , align: "center" , editor: false, sortable: true}
                            ,{key: "PT_SP", label: "거래처유형", width: 150   , align: "center" ,
                                formatter: function () {
                                    return $.changeTextValue(PT_SP, this.value)
                                }
                                , editor: false, sortable: true
                            }
                            ,{key: "PT_NM", label: "거래처 명", width: 150, align: "center", editor: false, sortable: true}
                            ,{key: "BIZ_NO", label: "사업자번호", width: 150, align: "center", editor: false
                                ,formatter: function () {
                                    return $.changeDataFormat( this.value , 'company')
                                }, sortable: true
                            }
                            ,{key: "OWNER_NM", label: "대표자명", width: 150, align: "center", editor: false, sortable: true}
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
                        ],
                        body: {
                            onClick: function () {
                                this.self.select(this.dindex);
                            }
                            ,
                            onDBLClick: function () {
                                // ACTIONS.dispatch(ACTIONS.ITEM_SELECT);
                            }
                        }
                    });

                },
                getData: function (_type) {
                    var list = [];
                    var _list = this.target.getList(_type);

                    if (_type == "modified" || _type == "deleted") {
                        list = ax5.util.filter(_list, function () {
                            delete this.deleted;
                            return this.key;
                        });
                    } else {
                        list = _list;
                    }
                    return list;
                }
            });

            function isChecked(data) {
                var array = [];
                for (var i = 0; i < data.length; i++) {
                    if (data[i].CHKED == true) {
                        array.push(data[i])
                    }
                }
                return array;
            }

            var cnt = 0;
            $(document).on('click', '#headerBox', function () {
                if (cnt == 0) {
                    $("div [data-ax5grid='grid-view-01']").find("div #headerBox").attr("data-ax5grid-checked", true);
                    cnt++;
                    var gridList = fnObj.gridView01.getData();
                    gridList.forEach(function (e, i) {
                        fnObj.gridView01.target.setValue(i, "CHKED", true);
                    });
                    $("div [data-ax5grid-editor='checkbox']").attr("data-ax5grid-checked", true)
                } else {
                    $("div [data-ax5grid='grid-view-01']").find("div #headerBox").attr("data-ax5grid-checked", false);
                    cnt = 0;
                    var gridList = fnObj.gridView01.getData();
                    gridList.forEach(function (e, i) {
                        fnObj.gridView01.target.setValue(i, "CHKED", false);
                    });
                    $("div [data-ax5grid-editor='checkbox']").attr("data-ax5grid-checked", false)
                }

            })
        </script>
    </jsp:attribute>
    <jsp:body>

        <div data-page-buttons="">
            <div class="button-warp">
                <button type="button" class="btn btn-popup-default" data-page-btn="search"><i
                        class="icon_search"></i><ax:lang id="ax.admin.sample.modal.button.search"/></button>
                <button type="button" class="btn btn-popup-default" data-page-btn="select"><i class="icon_ok"></i>선택
                </button>
                <button type="button" class="btn btn-popup-close" data-page-btn="close"><ax:lang
                        id="ax.admin.sample.modal.button.close"/></button>
            </div>
        </div>
        <div role="page-header">
            <ax:form name="searchView0">
                <ax:tbl clazz="ax-search-tbl" minWidth="500px">
                    <ax:tr>
                        <ax:td label='검색어' width="400px">
                            <input type="text" class="form-control" name="KEYWORD" id="KEYWORD"/>
                        </ax:td>
                    </ax:tr>
                </ax:tbl>
            </ax:form>
            <div class="H10"></div>
        </div>

        <ax:split-layout name="ax1" orientation="horizontal">
            <ax:split-panel width="*" style="">

                <!-- 목록 -->
                <div class="ax-button-group" data-fit-height-aside="grid-view-01">
                    <div class="left">
                        <h2><i class="cqc-list"></i>
                            사원 리스트 </h2>
                    </div>

                </div>
                <div data-ax5grid="grid-view-01" data-fit-height-content="grid-view-01" style="height: 300px;"></div>

            </ax:split-panel>
        </ax:split-layout>

    </jsp:body>
</ax:layout>