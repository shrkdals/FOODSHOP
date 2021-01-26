<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>

<ax:set key="title" value="전자서명 요청도움창"/>
<ax:set key="page_desc" value="${PAGE_REMARK}"/>
<ax:set key="page_auto_height" value="true"/>

<ax:layout name="base">
    <jsp:attribute name="script">
<%--        <script type="text/javascript" src="<c:url value='/assets/js/view/ensys/Helper_1.js' />"></script>--%>
        <script type="text/javascript">

            var param = ax5.util.param(ax5.info.urlUtil().param);
            var initData = parent.modal.modalConfig.sendData().initData;

            var fnObj = {};
            var ACTIONS = axboot.actionExtend(fnObj, {
                PAGE_CLOSE: function (caller, act, data) {
                    parent.modal.close();
                },
                PAGE_SEARCH: function (caller, act, data) {

                },
                ITEM_SELECT: function (caller, act, data) {

                }
            });

            // fnObj 기본 함수 스타트와 리사이즈
            fnObj.pageStart = function () {
                this.pageButtonView.initView();
                this.searchView.initView();

                // $("#RECEIVER_NAME").val('최웅석')
                // $("#RECEIVER_HP").val('01026514700')
                // $("#RECEIVER_BIRTH").val('19931104')

            };

            fnObj.pageResize = function () {

            };


            fnObj.pageButtonView = axboot.viewExtend({
                initView: function () {
                    axboot.buttonClick(this, "data-page-btn", {
                        "select": function () {
                            var RECEIVER_NAME = nvl($("#RECEIVER_NAME").val())
                            var RECEIVER_HP  = nvl($("#RECEIVER_HP").val()).replace(/-/g, "")
                            var RECEIVER_BIRTH  = nvl($("#RECEIVER_BIRTH").val()).replace(/-/g, "")

                            if(RECEIVER_NAME == ''){
                                qray.alert("전자서명 요청을 위해서 수신자명은은 필수입니다,")
                                return
                            }
                            if(RECEIVER_HP == ''){
                                qray.alert("전자서명 요청을 위해서 수신자 휴대전화는 필수입니다,")
                                return
                            }
                            if(RECEIVER_BIRTH == ''){
                                qray.alert("전자서명 요청을 위해서 수신자 생년월일은 필수입니다,")
                                return
                            }

                            var data = {
                                  RECEIVER_NAME : RECEIVER_NAME
                                , RECEIVER_HP: RECEIVER_HP
                                , RECEIVER_BIRTH : RECEIVER_BIRTH
                            };
                            parent[param.callBack](data);
                            parent.modal.close();
                        }
                    });

                    axboot.buttonClick(this, "data-page-btn", {
                        "close": function () {
                            parent.modal.close();
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
                },
                getData: function () {
                    return {

                    }
                }
            });
            var userCallBack;
            var openCalender = function (name) {
                userCallBack = function (e) {
                    console.log(e);
                    if (name == "calender") {
                        $("#RECEIVER_BIRTH").val(e.YYYY_MM_DD);
                        $("#RECEIVER_BIRTH").attr({"code": e.YYYYMMDD, "text": e.YYYYMMDD});
                    }
                    parent.calenderModal.close();
                };
                parent.openCalenderModal("userCallBack", this.name);
            };


        </script>
    </jsp:attribute>
    <jsp:body>

        <div data-page-buttons="">
            <div class="button-warp">
                <button type="button" class="btn btn-popup-default" data-page-btn="select"><i class="icon_ok"></i>요청
                </button>
                <button type="button" class="btn btn-popup-close" data-page-btn="close"><ax:lang
                        id="ax.admin.sample.modal.button.close"/></button>
            </div>
        </div>


        <div role="page-header">
            <ax:form name="searchView0">
                <ax:tbl clazz="ax-search-tbl" minWidth="500px">
                    <ax:tr>
                        <ax:td label='수신자명' width="400px">
                            <input type="text" class="form-control" name="RECEIVER_NAME" id="RECEIVER_NAME"  autocomplete="off"/>
                        </ax:td>
                        <ax:td label='수신자 휴대전화' width="400px">
                            <input type="text" class="form-control" name="RECEIVER_HP" id="RECEIVER_HP"  autocomplete="off"/>
                        </ax:td>
                        <ax:td label='수신자 생년월일' width="400px">
                            <div class="input-group">
                                <input type="text" class="form-control"   name="RECEIVER_BIRTH"  id="RECEIVER_BIRTH"/>
                                <span class="input-group-addon"><i class="cqc-magnifier"  style="cursor: pointer" onclick="openCalender('calender')"></i></span>
                            </div>
                        </ax:td>
                    </ax:tr>
                </ax:tbl>
            </ax:form>
            <div class="H10"></div>
        </div>


    </jsp:body>
</ax:layout>