<%@ page import="com.ensys.sample.domain.init.DatabaseInitService" %>
<%@ page import="com.chequer.axboot.core.context.AppContextManager" %>
<%@ page import="com.ensys.sample.utils.SessionUtils" %>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>
<%
    //boolean initialized = AppContextManager.getBean(DatabaseInitService.class).initialized();

    String lastNavigatedPage = null;

    if (SessionUtils.isLoggedIn()) {
        lastNavigatedPage = "/jsp/main.jsp";
    }

//    if (initialized) {
    request.setAttribute("redirect", lastNavigatedPage);
//    } else {
//        request.setAttribute("redirect", "/setup");
//    }
%>

<c:if test="${redirect!=null}">
    <c:redirect url="${redirect}" />
</c:if>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>로그인</title>
    <meta http-equiv="Content-Script-Type" content="text/javascript" />
    <meta http-equiv="Content-Style-Type" content="text/css" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <!--    <link href="/assets/ensys/css/style.css" rel="stylesheet" type="text/css"/>-->
    <link href="/assets/css/reset.css" rel="stylesheet" type="text/css" />
    <link href="/assets/css/login.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/assets/js/plugins.min.js"></script>
    <script type="text/javascript" src="/assets/js/axboot/dist/axboot.js"></script>
    <script type="text/javascript" src="/axboot.config.js"></script>
    <script type="text/javascript" src="<c:url value='/assets/js/axboot/dist/good-words.js' />"></script>
    <script type="text/javascript">
        var CONTEXT_PATH = "";
        var SCRIPT_SESSION = (function(json) {
            return json;
        })({
            "userCd": null,
            "userNm": null,
            "locale": null,
            "timeZone": null,
            "dateFormat": null,
            "login": false,
            "details": {},
            "dateTimeFormat": "null null",
            "timeFormat": null
        });
    </script>
    <script type="text/javascript">
        axboot.requireSession('${config.sessionCookie}');
        var fnObj = {
            pageStart: function() {

                $("#good_words").html(goodWords.get());
            },
            login: function() {
                axboot.ajax({
                    method: "POST",
                    url: "/api/login",
                    data: JSON.stringify({
                        "cdCompany": $("#companyCode").val(),
                        "cdGroup": $("#groupCode").val(),
                        "idUser": $("#userId").val(),
                        "passWord": $("#password").val()
                    }),
                    callback: function(res) {
                        if (res && res.error) {
                            if (res.error.message == "Unauthorized") {
                                alert("로그인에 실패 하였습니다. 계정정보를 확인하세요");
                            } else {
                                alert(res.error.message);
                            }

                        } else {
                            location.reload();
                        }
                    },
                    options: {
                        nomask: false,
                        apiType: "login"
                    }
                });
                return false;
            }
        };
    </script>

</head>

<body>
    <form name="login-form" class="register" method="post" action="/api/login" onsubmit="return fnObj.login();" autocomplete="off">
        <div class="login_wrapper">
            <span class="img">이미지</span>
            <span><input type="checkbox" /> 아이디저장</span>
            <div class="input_wrap">
                <p class="input company"><input id="companyCode" type="text" placeholder="회사코드" value="1000"></p>
                <p class="input group"><input id="groupCode" type="text" placeholder="그룹코드" value="WEB"></p>
                <p class="input"><input id="userId" type="text" placeholder="아이디를 입력하세요" value="050010"></p>
                <p class="input"><input id="password" type="password" placeholder="비밀번호를 입력하세요" value="DnPAysmjQ2e92wV5bfJdjA=="></p>
                <input type="submit" class="btn_login" title="로그인" alt="로그인" value="로그인">
            </div>

            <div class="link_wrap">
                <span class="idsrh"><a href="#n">아이디 찾기</a></span><span class="pwsrh"><a href="#n"> 비밀번호 찾기</a></span>
            </div>
            <p class="copy">© 2019 EnSys. All Rights Reserved.</p>
            <p class="logo">Q-Ray지출결의 시스템 <em>로그인</em><span>Expense Management System</span></p>
        </div>
    </form>
</body>
</html>