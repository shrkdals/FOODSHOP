<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<%-- 사번만으로 자동로그인, 협력사측에 전달해야할 FORM --%>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
<script>
    $(document).ready(function () {
        $("#ok").click(function () {
            var theForm = document.myform;
            theForm.method = "POST";
            theForm.target = "_blank";
            theForm.action = "http://" + window.location.hostname + ":" + window.location.port + "/api/v1/users/ensysLoginChk";

            theForm.submit();
        });
    })
</script>
<body>
<div align="center" style="margin-top: 55px;">
    <div>
        <form name="myform" id="myform" action="" target="popup_window"
              METHOD="POST">
            <input type="text" id="NO_EMP" name="NO_EMP" value="">

            <button  id="ok" style="width: 80px;">지출결의</button>

        </form>

    </div>
</div>
</body>
</html>
