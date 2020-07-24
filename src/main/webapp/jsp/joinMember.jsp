<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>

<ax:set key="title" value="회원가입"/>
<ax:set key="page_desc" value="${PAGE_REMARK}"/>
<ax:set key="page_auto_height" value="true"/>


<ax:layout name="base">
    <jsp:attribute name="script">

        <script type="text/javascript">
            var messageDialog = new ax5.ui.dialog();

            var fnObj = {}, CODE = {};
            var ACTIONS = axboot.actionExtend(fnObj, {
                GO_JOIN: function (caller, act, data) {
                    if (nvl($("#id_user").val()) == ''){
                        qray.alert('아이디를 입력해주십시오.');
                        return false;
                    }
                    if (nvl($("#name").val()) == ''){
                        qray.alert('이름을 입력해주십시오.');
                        return false;
                    }
                    // if (nvl($("#tel").val()) == ''){
                    //     qray.alert('전화번호를 입력해주십시오.');
                    //     return false;
                    // }
                    // if (nvl($("#email").val()) == ''){
                    //     qray.alert('이메일을 입력해주십시오.');
                    //     return false;
                    // }
                    if (nvl($("#pwd").val()) == ''){
                        qray.alert('비밀번호를 입력해주십시오.');
                        return false;
                    }
                    if($('#pwd2').val() != $('#pwd').val()){
                        qray.alert('비밀번호가 동일하지 않습니다.');
                        return false;
                    }
                    axboot.ajax({
                        method: "GET",
                        url: ["users", "join"],
                        // url: ["apbucard", "allsave"],
                        data: {
                            "P_ID_USER": $("#id_user").val(),
                            "P_NAME": $("#name").val(),
                            "P_TEL": $("#tel").val().replace(/\-/g, ''),
                            "P_USER_TP": $("select[name='user_tp']").val(),
                            // "P_USER_TP": '1',
                            "P_TOK": $("#tok").val(),
                            "P_PWD": $("#pwd").val(),
                            "CD_COMPANY" : '1000'
                        },
                        callback: function (res) {
                            qray.alert("회원가입이 완료되었습니다.").then(function(){
                                window.location.href = '/jsp/login.jsp';
                            })
                        },
                        options : {
                            onError : function(err){
                                qray.alert(err.message)
                            }
                        }
                    })

                }
            });

            fnObj.pageStart = function () {
                this.pageButtonView.initView();
                $('[data-ax-td-label="pwdCheck"]').css("background","white");
                $('[data-ax-td-label="pwdCheck"]').css("text-align","left");
                $('[data-ax-td-label="pwdCheck"]').css("width","500px")
            };

            fnObj.pageButtonView = axboot.viewExtend({
                initView: function () {
                    axboot.buttonClick(this, "data-page-btn", {
                        "ok": function () {
                            ACTIONS.dispatch(ACTIONS.GO_JOIN);
                        },
                        "return": function () {
                            window.location.href = '/jsp/login.jsp'
                        },

                    });
                }
            });

            $('#pwd2 , #pwd').keyup(function(){
                if($('#pwd2').val() != $('#pwd').val() || ($('#pwd').val() == '' || $('#pwd2').val() == '')){
                    $('[data-ax-td-label="pwdCheck"]').find('span').remove();
                    $('[data-ax-td-label="pwdCheck"]').append('<span style="color:red">비밀번호가 동일하지 않습니다.</span>')
                }else{
                    $('[data-ax-td-label="pwdCheck"]').find('span').remove();
                    $('[data-ax-td-label="pwdCheck"]').append('<span style="color:limegreen">비밀번호가 동일합니다.</span>')
                }
            });


            var LOGIN_SELECT_COMMON_CODE = function (CD_COMPANY, CD_FIELD, ALL, FLAG1, FLAG2, FLAG3, CD_SYSDEF_ARRAY) {
                var codeInfo = [];
                axboot.ajax({
                    type: "POST",
                    url: ["commonutility", "tempMethod"],
                    data: JSON.stringify({CD_COMPANY: CD_COMPANY, CD_FIELD: CD_FIELD}),
                    async: false,
                    callback: function (res) {
                        if (res.list.length == 0) {
                            return false;
                        }
                        if (nvl(ALL, '') == '' || ALL == false || ALL == 'false' || ALL == 'FALSE') {  //  ALL 파라메터가 없거나 false이면 전체가 추가된다.
                            codeInfo.push({
                                CODE: '', VALUE: '', code: '', value: '', text: '', TEXT: ''
                            });
                        }
                        // console.log(" [ SELECT_COMMON_CODE - DATA :  ", res, " ] ")
                        res.list.forEach(function (n) {
                                if (nvl(FLAG1, '') != '' || nvl(FLAG2, '') != '' || nvl(FLAG3, '') != '') {
                                    if ((nvl(n.CD_FLAG1) != '' && n.CD_FLAG1 == FLAG1) ||
                                        (nvl(n.CD_FLAG2) != '' && n.CD_FLAG2 == FLAG2) ||
                                        (nvl(n.CD_FLAG3) != '' && n.CD_FLAG3 == FLAG3)) {

                                        if (nvl(CD_SYSDEF_ARRAY) != '' && CD_SYSDEF_ARRAY.length != 0) {
                                            for (var k = 0; k < CD_SYSDEF_ARRAY.length; k++) {
                                                if (CD_SYSDEF_ARRAY[k] == n.CD_SYSDEF) {
                                                    codeInfo.push({
                                                        CODE: n.CD_SYSDEF,
                                                        code: n.CD_SYSDEF,
                                                        value: n.CD_SYSDEF,
                                                        VALUE: n.CD_SYSDEF,
                                                        text: n.NM_SYSDEF,
                                                        TEXT: n.NM_SYSDEF,
                                                        CD_FLAG1: n.CD_FLAG1,
                                                        CD_FLAG2: n.CD_FLAG2,
                                                        CD_FLAG3: n.CD_FLAG3
                                                    });
                                                }
                                            }
                                        } else {
                                            codeInfo.push({
                                                CODE: n.CD_SYSDEF,
                                                code: n.CD_SYSDEF,
                                                value: n.CD_SYSDEF,
                                                VALUE: n.CD_SYSDEF,
                                                text: n.NM_SYSDEF,
                                                TEXT: n.NM_SYSDEF,
                                                CD_FLAG1: n.CD_FLAG1,
                                                CD_FLAG2: n.CD_FLAG2,
                                                CD_FLAG3: n.CD_FLAG3
                                            });
                                        }
                                    }
                                } else {
                                    if (nvl(CD_SYSDEF_ARRAY) != '' && CD_SYSDEF_ARRAY.length != 0) {
                                        for (var k = 0; k < CD_SYSDEF_ARRAY.length; k++) {
                                            if (CD_SYSDEF_ARRAY[k] == n.CD_SYSDEF) {
                                                codeInfo.push({
                                                    CODE: n.CD_SYSDEF,
                                                    code: n.CD_SYSDEF,
                                                    value: n.CD_SYSDEF,
                                                    VALUE: n.CD_SYSDEF,
                                                    text: n.NM_SYSDEF,
                                                    TEXT: n.NM_SYSDEF,
                                                    CD_FLAG1: n.CD_FLAG1,
                                                    CD_FLAG2: n.CD_FLAG2,
                                                    CD_FLAG3: n.CD_FLAG3
                                                });
                                            }
                                        }
                                    } else {
                                        codeInfo.push({
                                            CODE: n.CD_SYSDEF,
                                            code: n.CD_SYSDEF,
                                            value: n.CD_SYSDEF,
                                            VALUE: n.CD_SYSDEF,
                                            text: n.NM_SYSDEF,
                                            TEXT: n.NM_SYSDEF,
                                            CD_FLAG1: n.CD_FLAG1,
                                            CD_FLAG2: n.CD_FLAG2,
                                            CD_FLAG3: n.CD_FLAG3
                                        });
                                    }
                                }
                            }
                        );
                        // console.log(" [ SELECT_COMMON_CODE - RETURN :  ", codeInfo, " ] ")
                    }

                });
                return codeInfo;
            }
            var code = LOGIN_SELECT_COMMON_CODE('1000' ,'MA00001')
            $("#user_tp").ax5select({
                options: code
            });

        </script>
    </jsp:attribute>
    <jsp:body>

        <div class="es_wrap" id="ax-frame-root">
        <!-- 상단 gnb -->
        <div class="header_wrap">
            <div class="header">

                <h1 class="logo"><a href="/jsp/login.jsp" style="cursor:pointer">logo <span>|</span></a>
                </h1>
                <div class="gnb_wrap">
                </div>
            </div>
            <h1 class="title" style="padding: 25px;"><i class="cqc-browser"></i>회원가입</h1>
        </div>

        <%--<div class="lnb">
            <ul class="nav">
                <li class="menu_4"><a href="/jsp/findId.jsp"><span>아이디 찾기</span></a></li>
                <li class="menu_7"><a href="/jsp/findPw.jsp"><span>비밀번호 찾기</span></a></li>
            </ul>
        </div>--%>

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
                    <h2><i class="cqc-list"></i> 회원가입 후 관리자에게 문의하여 그룹등록이 필요합니다.</h2>

                    <h3><font color="#ff8c00">* 외부 사용자일 경우 회원가입후 서비스를 이용할 수 없습니다. 관리자에게 문의하시기 바랍니다.</font></h3>
                </div>
            </div>
            <div class="H10"></div>
            <div class="H10"></div>

            <ax:tbl clazz="ax-search-tb2" minWidth="800px">
                <ax:tr>
                    <ax:td label='<span style="color:red">*</span> 로그인 구분' width="400px">
                        <div id="user_tp" data-ax5select="user_tp" data-ax5select-config='{}'></div>
                    </ax:td>
                </ax:tr>
                <ax:tr>
                    <ax:td label='<span style="color:red">*</span> 아이디' width="400px">

                        <input type="text"
                               class="form-control"
                               data-ax-path="id_user"
                               name="id_user"
                               id="id_user"
                               placeholder="아이디를 입력해주세요."/>
                    </ax:td>
                </ax:tr>
                <ax:tr>
                    <ax:td label='<span style="color:red">*</span> 이름' width="400px">
                        <input type="text"
                               class="form-control"
                               data-ax-path="name"
                               name="name"
                               id="name"
                               placeholder="이름을 입력해주세요."/>
                    </ax:td>
                </ax:tr>
                <ax:tr>
                    <ax:td label='<span style="color:red">*</span> 비밀번호' width="400px">
                        <input type="password"
                               class="form-control"
                               data-ax-path="pwd"
                               name="pwd"
                               id="pwd"
                               placeholder="비밀번호를 입력해주세요."/>
                    </ax:td>
                </ax:tr>
                <ax:tr>
                    <ax:td label='<span style="color:red">*</span> 비밀번호 확인' width="400px">
                        <input type="password"
                               class="form-control"
                               data-ax-path="pwd2"
                               name="pwd2"
                               id="pwd2"
                               placeholder="동일한 비밀번호를 입력해주세요."/>
                    </ax:td>

                    <ax:td id = 'pwdCheck' label=' ' style="backgroun-color:white; text-align: left;" width="600px">
                    </ax:td>

                </ax:tr>
<%--                <ax:tr>--%>
<%--                    <ax:td label='생년월일' width="400px">--%>
<%--                        <input type="text"--%>
<%--                               class="form-control"--%>
<%--                               data-ax-path="birth"--%>
<%--                               name="birth"--%>
<%--                               id="birth" formatter="YYYYMMDD"/>--%>
<%--                    </ax:td>--%>
<%--                </ax:tr>--%>
                <ax:tr>
                    <ax:td label='휴대폰번호' width="400px">
                        <input type="text"
                               class="form-control"
                               data-ax-path="tel"
                               name="tel"
                               id="tel"
                               formatter="tel"
                               placeholder="휴대폰 번호를 입력해주세요."/>
                    </ax:td>
                </ax:tr>
                <ax:tr>
                    <ax:td label='카카오톡 아이디' width="400px">
                        <input type="text"
                               class="form-control"
                               data-ax-path="tok"
                               name="tok"
                               id="tok"
                               placeholder="카카오톡 아이디를 입력해주세요."/>
                    </ax:td>
                </ax:tr>
            </ax:tbl>
            <div class="H10"></div>

            <div class="ax-button-group" data-fit-height-aside="grid-view-01">
                <div class="left">
                    <h4><font color="#00ffff">*</font> 사원등록에 등록된 생년월일 E-mail을 통하여 아이디를 찾을 수 있습니다. </h4>
                    <h4><font color="#00ffff">*</font> 찾고자 하는 아이디가 사용자 정보등록의 사용자 구분이 내부일 경우에만 아이디찾기/비밀번호찾기 가 가능합니다.
                    </h4>
                    <h4><font color="#00ffff">*</font> 해당 정보가 일치하는 경우 등록된 E-mail로 변경된 비밀번호가 전송됩니다. </h4>
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