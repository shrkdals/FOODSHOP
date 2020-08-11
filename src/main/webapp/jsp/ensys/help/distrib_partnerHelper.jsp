<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>

<ax:set key="title" value="거래처 검색 도움창"/>
<ax:set key="page_desc" value="${PAGE_REMARK}"/>
<ax:set key="page_auto_height" value="true"/>

<ax:layout name="modal">
    <jsp:attribute name="script">
        <script type="text/javascript">
            fnObj.gridView01 = axboot.viewExtend(axboot.gridView, {
                initView: function () {
                    var _this = this;
                    var PT_SP = $.SELECT_COMMON_CODE(SCRIPT_SESSION.cdCompany, 'MA00002');
                    this.target = axboot.gridBuilder({
                        showRowSelector: false,
                        frozenColumnIndex: 0,
                        target: $('[data-ax5grid="grid-view-01"]'),
                        columns: [
                             {key: "COMPANY_CD", label: "회사코드", width: 150 , align: "left" , editor: {type: "text"},hidden:true}
                            ,{key: "PT_CD", label: "거래처코드", width: 150   , align: "center" , editor: false, sortable:true}
                            ,{key: "PT_SP", label: "거래처유형", width: 150   , align: "center" ,
                                formatter: function () {
                                    return $.changeTextValue(PT_SP, this.value)
                                }
                                , editor: false, sortable:true
                            }
                            ,{key: "PT_NM", label: "거래처 명", width: 150, align: "center", editor: false, sortable:true}
                            ,{key: "BIZ_NO", label: "사업자번호", width: 150, align: "center", editor: false
                                ,formatter: function () {
                                    return $.changeDataFormat( this.value , 'company')
                                }, sortable:true
                            }
                            ,{key: "OWNER_NM", label: "대표자명", width: 150, align: "center", editor: false, sortable:true}
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
                            거래처 리스트 </h2>
                    </div>

                </div>
                <div data-ax5grid="grid-view-01" data-fit-height-content="grid-view-01" style="height: 300px;"></div>

            </ax:split-panel>
        </ax:split-layout>

    </jsp:body>
</ax:layout>