<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>

<ax:set key="title" value="사용자 아이디 검색 도움창"/>
<ax:set key="page_desc" value="${PAGE_REMARK}"/>
<ax:set key="page_auto_height" value="true"/>

<ax:layout name="modal">
    <jsp:attribute name="script">
        <script type="text/javascript">
            fnObj.gridView01 = axboot.viewExtend(axboot.gridView, {
                initView: function () {
                    var _this = this;
                    var USER_SP       = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'MA00001');
                    this.target = axboot.gridBuilder({
                        showRowSelector: false,
                        frozenColumnIndex: 0,
                        target: $('[data-ax5grid="grid-view-01"]'),
                        columns: [
                            {key: "USER_ID", label: "아이디", width: 100, align: "center", editor: false},
                            {key: "USER_NM", label: "이름", width: 100, align: "center", editor: false},
                            {key: "USER_TP", label: "사용자유형", width: 100, align: "center", editor: false
                                ,formatter: function () {
                                    return $.changeTextValue(USER_SP, this.value)
                                }, hidden : true
                            },
                            //시스템쪽때문에 과거 키 유지
                            {key: "ID_USER", label: "사원아이디", width: 100, align: "center", editor: false, hidden: true},
                            {key: "NO_EMP", label: "사원번호", width: 100, align: "center", editor: false, hidden: true},
                            {key: "NM_EMP", label: "사원명", width: 150, align: "left", editor: false, hidden: true},
                            {key: "CD_DEPT", label: "부서코드", width: 120, align: "center", editor: false, hidden: true},
                            {key: "NM_DEPT", label: "부서명", width: 150, align: "left", editor: false, hidden: true},
                            {key: "CD_DUTY_RANK", label: "직급코드", width: 120, align: "center", editor: false, hidden: true},
                            {key: "NM_DUTY_RANK", label: "직급명", width: 100, align: "left", editor: false, hidden: true},
                            {key: "NO_EMAIL", label: "이메일", width: 120, align: "left", editor: false, hidden: true}
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
                <div data-ax5grid="grid-view-01" data-fit-height-content="grid-view-01" style="height: 300px;"></div>
            </ax:split-panel>
        </ax:split-layout>

    </jsp:body>
</ax:layout>