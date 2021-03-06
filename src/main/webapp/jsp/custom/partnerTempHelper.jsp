<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>

<ax:set key="title" value="거래처 검색 도움창"/>
<ax:set key="page_desc" value="${PAGE_REMARK}"/>
<ax:set key="page_auto_height" value="true"/>
<%--
       작성자 : 노강민
       작성일 : 20190724
       PARAMETER : 날짜 [ DT_ACCT_F : 시작년월, DT_ACCT_T : 종료년월]
       RETURN : 날짜에 해당하는 거래처TEMP 테이블 LIST
       CALL 방식 : $.openCustomPopup('partnerTemp', "PartnerTempCallBack", 'CUSTOM_HELP_PARTNER_TEMP', {
                        P_DT_ACCT_F: $해당시작년월값,
                        P_DT_ACCT_T: $해당종료년월값,
                        P_CD_EMP: $해당신청자
                    }, $해당검색어값);

       CALLBACK 방식:
       var PartnerTempCallBack = function (e) {   //  거래처TEMP
                if (e.length > 0) {
                    console.log(e[0]);
                }
                modal.close();
            };
--%>
<ax:layout name="modal">
    <jsp:attribute name="script">
        <script type="text/javascript">
            fnObj.gridView01 = axboot.viewExtend(axboot.gridView, {
                initView: function () {
                    var _this = this;

                    this.target = axboot.gridBuilder({
                        showRowSelector: false,
                        frozenColumnIndex: 0,
                        target: $('[data-ax5grid="grid-view-01"]'),
                        columns: [
                            {key: "CD_PARTNER", label: "거래처코드", width: 100, align: "center", editor: false},
                            {key: "LN_PARTNER", label: "거래처명", width: 200, align: "left", editor: false},
                            {key: "NM_CEO", label: "대표자명", width: 150, align: "center", editor: false},


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