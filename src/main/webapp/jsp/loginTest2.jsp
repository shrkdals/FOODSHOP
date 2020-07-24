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


<%--
    사번만으로 로그인하는 사용자만의 로그인페이지, 만약 이 jsp의 파일명을 변경한다면 UserController 에서 setViewName 변경해줘야함.
--%>

<c:if test="${redirect!=null}">
    <c:redirect url="${redirect}"/>
</c:if>
<html>
<head>
    <title>로그인</title>

    <link href="/assets/css/reset.css" rel="stylesheet" type="text/css"/>
    <link href="/assets/css/login.css" rel="stylesheet" type="text/css"/>
    <link href="/assets/css/layout.css" rel="stylesheet" type="text/css"/>
    <script type="text/javascript" src="/assets/js/plugins.min.js"></script>
    <script type="text/javascript" src="/assets/js/axboot/dist/axboot.js"></script>
    <script type="text/javascript" src="/axboot.config.js"></script>
    <script type="text/javascript" src="/assets/js/common/common.js"></script>

    <script type="text/javascript">
        var CONTEXT_PATH = "";

        /*axboot.requireSession('${config.sessionCookie}');*/
        var fnObj = {
            pageStart: function () {

                if (localStorage.getItem("cdCompany") != null && localStorage.getItem("cdGroup") != null && localStorage.getItem("idUser") != null) {
                    $("#companyCode").val(localStorage.getItem("cdCompany"));
                    $("#userId").val(localStorage.getItem("idUser"));
                    $("#groupCode").val(localStorage.getItem("cdGroup"));
                    $("#idSave").prop("checked", true);
                }

                var list = [];
                if (nvl(${resultList}) != '') {

                    list = JSON.parse('${resultList}');
                    console.log(list);
                }
                if (list.length > 0) {
                    var obj = {};
                    for (var i = 0; i < list.length; i++) {
                        obj[eval(i)] = {
                            label: "회사코드 : [" + nvl(list[i].CD_COMPANY, '') + "] " + nvl(list[i].NM_COMPANY, '') + "<br>"
                                + "그룹코드 : [" + nvl(list[i].CD_GROUP, '') + "] " + nvl(list[i].NM_GROUP, '') + "<br>"
                                + "사용자ID : [" + nvl(list[i].ID_USER, '') + "] " + nvl(list[i].NM_USER, ''),
                            onClick: function (key) {

                                $("#companyCode").val(nvl(list[this.id].CD_COMPANY, ''));
                                $("#userId").val(nvl(list[this.id].ID_USER, ''));
                                $("#groupCode").val(nvl(list[this.id].CD_GROUP, ''));
                                qray.close();
                            },
                            style: {
                                "width": "350px",
                                "text-align": "left",
                                "line-height": "18px;"
                            }
                        };
                        if (i == (list.length - 1)) {
                            obj["other"] = {
                                label: '닫기', onClick: function (key) {
                                    qray.close();
                                },
                                style: {
                                    "width": "350px"
                                }
                            }
                        }
                    }

                    qray.setButtonAreaStyle({
                        width: "390px",
                        height: "300px",
                        overflow: "auto"
                    }).setBoxStyle({
                        width: "400px",
                        top: "250px"
                    }).confirm({
                        msg: '해당 사번이 복수 로그인 정보가 검색되었습니다.<br>선택 후 비밀번호를 입력해주셔야합니다.',
                        btns: obj
                    }, function () {

                    });
                    return false;
                }
                axboot.ajax({
                    method: "GET",
                    url: ["users", "chkPw"],
                    data: {
                        "cdCompany": $("#HcompanyCode").val(),
                        "idUser": $("#HuserId").val(),
                        "groupCode": $("#HgroupCode").val(),
                        "passWord": $("#Hpassword").val()
                    },
                    callback: function (res) {
                        if (res.map != null && res.map.PASS_WORD != null) {
                            axboot.ajax({
                                method: "POST",
                                url: "/api/login",
                                data: JSON.stringify({
                                    "cdCompany": $("#HcompanyCode").val(),
                                    "cdGroup": $("#HgroupCode").val(),
                                    "idUser": $("#HuserId").val(),
                                    "passWord": res.map.PASS_WORD
                                }),
                                callback: function (res) {
                                    if (res && res.error) {
                                        if (res.error.message == "Unauthorized") {
                                            qray.alert("로그인에 실패 하였습니다. 계정정보를 확인하세요");
                                        } else {
                                            alert(res.error.message);
                                        }
                                    } else {
                                        if ($("#idSave").is(":checked")) {
                                            localStorage.cdCompany = $("#companyCode").val();
                                            localStorage.cdGroup = $("#groupCode").val();
                                            localStorage.idUser = $("#userId").val()
                                        } else {
                                            localStorage.clear();
                                        }
                                        window.location = "/jsp/login.jsp";
                                    }
                                },
                                options: {
                                    nomask: false,
                                    apiType: "login"
                                }
                            });

                        }

                    }
                });
                return false;
            },
            login: function () {
                axboot.ajax({
                    method: "GET",
                    url: ["users", "chkPw"],
                    data: {
                        "cdCompany": $("#companyCode").val(),
                        "idUser": $("#userId").val(),
                        "groupCode": $("#groupCode").val(),
                        "passWord": $("#password").val()
                    },
                    callback: function (res) {
                        console.log(res);
                        if (res.map != null && res.map.PASS_WORD != null) {
                            axboot.ajax({
                                method: "POST",
                                url: "/api/login",
                                data: JSON.stringify({
                                    "cdCompany": $("#companyCode").val(),
                                    "cdGroup": $("#groupCode").val(),
                                    "idUser": $("#userId").val(),
                                    "passWord": res.map.PASS_WORD
                                }),
                                callback: function (res) {
                                    if (res && res.error) {
                                        if (res.error.message == "Unauthorized") {
                                            alert("로그인에 실패 하였습니다. 계정정보를 확인하세요");
                                        } else {
                                            alert(res.error.message);
                                        }

                                    } else {
                                        if ($("#idSave").is(":checked")) {
                                            localStorage.cdCompany = $("#companyCode").val();
                                            localStorage.cdGroup = $("#groupCode").val();
                                            localStorage.idUser = $("#userId").val()
                                        } else {
                                            localStorage.clear();
                                        }
                                        location.reload();
                                    }
                                },
                                options: {
                                    nomask: false,
                                    apiType: "login"
                                }
                            });

                        }

                    }
                });
                return false;
            }
        };
    </script>

</head>

<body>

<form name="login-form" class="register" method="post" action="/api/login" onsubmit="return fnObj.login();"
      autocomplete="off">
    <input type="hidden" id="HcompanyCode" name="HcompanyCode" value="${cdCompany}">
    <input type="hidden" id="HgroupCode" name="HgroupCode" value="${cdGroup}">
    <input type="hidden" id="HuserId" name="HuserId" value="${idUser}">
    <input type="hidden" id="Hpassword" name="Hpassword" value="${passWord}">

    <div class="login_wrapper">
        <span class="img">이미지</span>
        <span><input id="idSave" type="checkbox"/> 아이디저장</span>
        <div class="input_wrap">
            <p class="input company"><input id="companyCode" type="text" placeholder="회사코드" value="1000"></p>
            <p class="input group"><input id="groupCode" type="text" placeholder="그룹코드" value="WEB"></p>
            <p class="input"><input id="userId" type="text" placeholder="아이디를 입력하세요" value=""></p>
            <p class="input"><input id="password" type="password" placeholder="비밀번호를 입력하세요" value=""></p>
            <input type="submit" class="btn_login" title="로그인" alt="로그인" value="로그인">
        </div>

        <div class="link_wrap">


            <span class="idsrh"><a href="/jsp/loginTest.jsp">아이디 찾기</a></span><span class="pwsrh"><a
                href="/jsp/findPw.jsp"> 비밀번호 찾기</a></span>
        </div>
        <p class="copy">© 2019 E&Sys. All Rights Reserved.</p>
        <p style="font-size:14px;color:#008cff;min-height:10px;height:10px;margin-left:36px;">Q-Ray</p>
        <p class="logo" style="margin-bottom:10px;">지출결의 시스템 <em>로그인</em><span>Expense Management System</span></p>
    </div>
</form>
</body>
</html>