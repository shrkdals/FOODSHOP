<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta http-equiv="Content-Script-Type" content="text/javascript" />
    <meta http-equiv="Content-Style-Type" content="text/css" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<link href="/assets/css/style.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="http://code.jquery.com/jquery-latest.js"></script>
 
</head>

<body>
<script> $(document).ready(function() { $("input:checkbox").on('click', function() { if ( $(this).prop('checked') ) { $(this).parent().addClass("selected"); } else { $(this).parent().removeClass("selected"); } }); }); </script>
<!-- 메인 이미지 -->
        <div class="content_main">
            <div class="main_wrap">
                <div class="top"></div>
            </div>
        </div>
</body>
</html>
