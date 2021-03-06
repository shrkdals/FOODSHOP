<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>

<ax:set key="title" value="카테고리 검색 도움창"/>
<ax:set key="page_desc" value="${PAGE_REMARK}"/>
<ax:set key="page_auto_height" value="true"/>

<ax:layout name="modal">
    <jsp:attribute name="script">
        <script type="text/javascript">

      
        //검증상태
        var DATA_BRTYPE = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'MA00015');
        // YN
        var DATA_YN = [{value:'' , text:''},{value:'Y' , text:'Y'},{value:'N' , text:'N'}];
        
            fnObj.gridView01 = axboot.viewExtend(axboot.gridView, {
                initView: function () {
                    var _this = this;

                    this.target = axboot.gridBuilder({
                        showRowSelector: false,
                        frozenColumnIndex: 0,
                        target: $('[data-ax5grid="grid-view-01"]'),
                        columns: [
                        	{key: "COMPANY_CD", label: "회사코드", width: 150 , align: "left" , editor: {type: "text"},hidden:true}
                            ,{key: "CG_CD", label: "분류코드", width: 120   , align: "left" }
                            ,{key: "CG_NM", label: "분류명", width: 200   , align: "left" , editor: false}
                            ,{key: "COMMITION", label: "수수료", width: 100   , align: "right" , editor: false,
                            	formatter : function(){
                                	this.item.COMMITION = Number(nvl(this.value,0));
                                    return Number(nvl(this.value,0)) + '%'
                                }
                             }
                            ,{key: "DEPTH_TEXT", label: "분류명", width: 150, align: "left", editor: false, hidden:true}
                            ,{key: "PARENT_CG_CD", label: "상위분류코드", width: 150   , align: "center" , editor: false, hidden:true}
                            ,{key: "SORT", label: "정렬", width: 150, align: "center", editor: false, hidden:true}
                            ,{key: "LV", label: "레벨", width: 150, align: "center", editor: false, hidden:true}
                            ,{key: "LAST_YN", label: "최하위 여부", width: 150, align: "center", hidden:true,
                                formatter: function () {
                                    return $.changeTextValue(DATA_YN, this.value)
                                }
                            }
                            ,{key: "CG_SP", label: "분류유형", width: 100, align: "center", hidden:false,
                                formatter: function () {
                                    return $.changeTextValue(DATA_BRTYPE, this.value)
                                }
                            }
                            ,{key: "FILE_YN", label: "파일여부", width: 100, align: "center", hidden:false,
                                formatter: function () {
                                    return $.changeTextValue(DATA_YN, this.value)
                                }
                            }
                            ,{key: "SEE_YN", label: "노출여부", width: 100, align: "center", hidden:false,
                                formatter: function () {
                                    return $.changeTextValue(DATA_YN, this.value)
                                }
                            }
                        ],
                        body: {
                            onClick: function () {
                                this.self.select(this.dindex);
                            }
                            , onDBLClick: function () {
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
            });
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
                             카테고리 리스트 </h2>
                    </div>

                </div>
                <div data-ax5grid="grid-view-01" data-fit-height-content="grid-view-01" style="height: 300px;"></div>

            </ax:split-panel>
        </ax:split-layout>

    </jsp:body>
</ax:layout>