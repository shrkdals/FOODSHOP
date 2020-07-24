<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>

<ax:set key="title" value="아이디 찾기"/>
<ax:set key="page_desc" value="${PAGE_REMARK}"/>
<ax:set key="page_auto_height" value="true"/>


<ax:layout name="base">
    <jsp:attribute name="script">
        <script type="text/javascript">
            var messageDialog = new ax5.ui.dialog();


            var fnObj = {}, CODE = {};
            var ACTIONS = axboot.actionExtend(fnObj, {
                GO_EMAIL: function (caller, act, data) {
                    if (nvl($("#name").val()) == '') {
                        qray.alert('이름을 입력해주십시오.');
                        return false;
                    }
                    if (nvl($("#birth").val()) == '') {
                        qray.alert('생년월일을 입력해주십시오.');
                        return false;
                    }
                    if (nvl($("#email").val()) == '') {
                        qray.alert('이메일을 입력해주십시오.');
                        return false;
                    }
                    axboot.ajax({
                        method: "GET",
                        url: ["users", "findId"],
                        data: {
                            "P_NAME": $("#name").val(),
                            "P_BIRTH": $("#birth").val().replace(/\-/g, ''),
                            "P_EMAIL": $("#email").val(),
                        },
                        callback: function (res) {
                            if (res.list.length == 0) {
                                qray.alert('등록된 아이디가 없습니다.');
                            }

                            var html = "";
                            for (var i = 0; i < res.list.length; i++) {
                                if (i != 0) {
                                    html += " | ";
                                }
                                html += "<font color='#ff7f50'>" + res.list[i].ID_USER + "</font>";
                            }

                            qray.alert("아이디 <font color='#ff7f50'>" + res.list.length + "</font> 개 검색되었습니다. \n\n" + html);
                        }
                    });
                }
            });

            fnObj.pageStart = function () {
                this.pageButtonView.initView();

            };

            fnObj.pageButtonView = axboot.viewExtend({
                initView: function () {
                    axboot.buttonClick(this, "data-page-btn", {
                        "ok": function () {
                            ACTIONS.dispatch(ACTIONS.GO_EMAIL);
                        },
                        "return": function () {
                            window.location.href = '/jsp/login.jsp'
                        },

                    });
                }
            });

        </script>
    </jsp:attribute>

    <jsp:body>
        <div class="es_wrap" id="ax-frame-root">
        <!-- 상단 gnb -->
        <div class="header_wrap">
            <div class="header">


                <h1 class="logo"><a href="/jsp/login.jsp" style="cursor:pointer">logo <span>| 지출결의시스템 Expense Management System</span></a>
                </h1>
                <div class="gnb_wrap">

                </div>
            </div>

            <h1 class="title" style="padding: 25px;"><i class="cqc-browser"></i>아이디 찾기</h1>


        </div>

        <div class="lnb_wrap">
            <div class="lnb">
                    <%--<div class="lnb_arrowtop">
                    </div>--%>
                <div class="nav_wrap" style="overflow:hidden;">
                    <ul class="nav">
                        <li class="menu_4"><a href="/jsp/joinMember.jsp"><span>회원가입</span></a></li>
                        <li class="menu_7"><a href="/jsp/findId.jsp"><span>아이디 찾기</span></a></li>
                        <li class="menu_7"><a href="/jsp/findPw.jsp"><span>비밀번호 찾기</span></a></li>
                    </ul>
                </div>
                    <%--<div class="lnb_arrowbottom">
                    </div>--%>
            </div>
        </div>

        <div class="H10"></div>
        <div class="H10"></div>

        <div style="padding: 100px;">
            <div class="ax-button-group" data-fit-height-aside="grid-view-01">
                <div class="left">
                    <h2><i class="cqc-list"></i> 회원가입시 등록된 정보로 아이디를 찾을 수 있습니다.</h2>

                    <h3><font color="#ff8c00">* 외부 사용자일 경우 아이디 찾기 및 비밀번호 찾기를 이용할 수 없습니다. 관리자에게 문의하시기 바랍니다.</font></h3>
                </div>
            </div>
            <div class="H10"></div>
            <div class="H10"></div>

            <ax:tbl clazz="ax-search-tb2" minWidth="800px">
                <ax:tr>
                    <ax:td label='이름' width="400px">
                        <input type="text"
                               class="form-control"
                               data-ax-path="name"
                               name="name"
                               id="name"/>
                    </ax:td>
                </ax:tr>
                <ax:tr>
                    <ax:td label='생년월일' width="400px">
                        <input type="text"
                               class="form-control"
                               data-ax-path="birth"
                               name="birth"
                               id="birth" formatter="YYYYMMDD"/>
                    </ax:td>
                </ax:tr>
                <ax:tr>
                    <ax:td label='E-Mail' width="400px">
                        <input type="text"
                               class="form-control"
                               data-ax-path="email"
                               name="email"
                               id="email"/>
                    </ax:td>
                </ax:tr>
            </ax:tbl>
            <div class="H10"></div>

            <div class="ax-button-group" data-fit-height-aside="grid-view-01">
                <div class="left">
                    <h4><font color="#00ffff">*</font> 사원등록에 등록된 생년월일 E-mail을 통하여 아이디를 찾을 수 있습니다. </h4>
                    <h4><font color="#00ffff">*</font> 찾고자 하는 아이디가 사용자 정보등록의 사용자 구분이 내부일 경우에만 아이디찾기/비밀번호찾기 가 가능합니다.
                    </h4>
                </div>
            </div>

            <div align="center" style="margin-top: 55px;">
                <div class="button-warp">
                    <button type="button" class="btn btn-popup-default" data-page-btn="ok" style="width: 80px;">확인
                    </button>
                    <button type="button" class="btn btn-popup-default" data-page-btn="return" style="width: 80px;">취소
                    </button>
                </div>
            </div>
        </div>
    </jsp:body>
</ax:layout>