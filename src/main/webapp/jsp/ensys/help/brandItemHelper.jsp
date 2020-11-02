<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>

<ax:set key="title" value="상품 도움창"/>
<ax:set key="page_desc" value="${PAGE_REMARK}"/>
<ax:set key="page_auto_height" value="true"/>

<ax:layout name="modal">
    <jsp:attribute name="script">
        <script type="text/javascript">
        	var param = ax5.util.param(ax5.info.urlUtil().param);
        	var initData;
        	if (param.modalName) {
        	    initData = nvl(eval("parent." + param.modalName + ".modalConfig.sendData().initData"), {});  // 부모로 부터 받은 Parameter Object
        	} else {
        	    initData = nvl(parent.modal.modalConfig.sendData().initData, {});  // 부모로 부터 받은 Parameter Object
        	}
        	
            var dl_ITEM_SP = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'MA00011');
            $("#ITEM_SP").ax5select({options: dl_ITEM_SP});

            if (initData.DISABLED){
        		$("#ITEM_SP").ax5select('setValue', initData.ITEM_SP);
        		$("#ITEM_SP").ax5select("disable");
        		$("#PT_CD").val(initData.PT_NM);
        		$("#PT_CD").attr('code', initData.PT_CD);
        		$("#PT_CD").attr('text', initData.PT_NM);
        		$("#PT_CD").attr('readonly', 'readonly');
            }
            
            fnObj.gridView01 = axboot.viewExtend(axboot.gridView, {
                initView: function () {
                    var _this = this;
                    this.target = axboot.gridBuilder({
                        showRowSelector: false,
                        frozenColumnIndex: 0,
                        target: $('[data-ax5grid="grid-view-01"]'),
                        columns: [
                            {key: "ITEM_CD", label: "상품코드", width: "*", align: "center", editor: false, sortable:true},
                            {key: "ITEM_NM", label: "상품명", width: "*", align: "left", editor: false, sortable:true},
                            {key: "ITEM_SP", label: "상품유형", width: "*", align: "left", editor: false,
                                formatter: function () {
                                    return $.changeTextValue(dl_ITEM_SP, this.value)
                                }, sortable:true
                            },
                            {key: "PT_NM", label: "제조사", width: "*", align: "left", editor: false, sortable:true},
                            {key: "PT_SP_NM", label: "제조사유형", width: "*", align: "left", editor: false, sortable:true},
                            {key: "SALE_COST", label: "상품원가", width: "*", align: "right", editor: false, hidden:true},
                            {key: "MAKE_PT_CD", label: "제조사코드", width: "*", align: "center", editor: false, hidden:true},
                            {key: "PT_SP", label: "제조사유형코드", width: "*", align: "center", editor: false, hidden:true},

                        ],
                        body: {
                            onClick: function () {
                                this.self.select(this.dindex);
                            }
                            ,
                            onDBLClick: function () {
                                ACTIONS.dispatch(ACTIONS.ITEM_SELECT);
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
            })

            var userCallback;
            function openPopup(){
                userCallback = function(e){
                    if (e.length > 0){
                        $("#PT_CD").attr('code', e[0].PT_CD);
                        $("#PT_CD").attr('text', e[0].PT_NM);
                        $("#PT_CD").val(e[0].PT_NM);
                    }
                }
				if (!initData.DISABLED){
             	   parent.openModal("brandPartner", "HELP_BRAND_PARTNER", "userCallback", this.name, {PT_SP: '03|04|05', KEYWORD : $("#PT_CD").val()});
                }
            }
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
                <ax:tbl clazz="ax-search-tbl" minWidth="600px">
                    <ax:tr>
                        <ax:td label='제조사' width="300px">
                            <div class="input-group" id="filemodal">
                                <input type="text" class="form-control" id="PT_CD" name="PT_CD" codepicker readonly>
                                <span class="input-group-addon" style="cursor: pointer" onclick="openPopup(this)"><i
                                        class="cqc-magnifier"></i></span>
                            </div>
                        </ax:td>
                        <ax:td label='상품유형' width="300px">
                            <div id="ITEM_SP" name="ITEM_SP" data-ax5select="ITEM_SP"
                                 data-ax5select-config='{}'></div>
                        </ax:td>
                        <ax:td label='검색어' width="500px">
                            <input type="text" class="form-control" name="KEYWORD" id="KEYWORD"/>
                        </ax:td>
                    </ax:tr>
                </ax:tbl>
            </ax:form>
            <div class="H10"></div>
        </div>

        <ax:split-layout name="ax1" orientation="horizontal">
            <ax:split-panel width="*" style="">
                <div data-ax5grid="grid-view-01" data-fit-height-content="grid-view-01" style="height: 300px;"></div>
            </ax:split-panel>
        </ax:split-layout>

    </jsp:body>
</ax:layout>