<%@ page import="com.chequer.axboot.core.utils.HttpUtils" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<jsp:forward page="./jsp/login.jsp" />
<%

    System.out.println("#################################### Index #################################");

    Cookie[] getCookie = HttpUtils.getCurrentRequest().getCookies();
    if(getCookie != null){
        for(int i=0; i<getCookie.length; i++){
            Cookie c = getCookie[i];
            String name = c.getName(); // 쿠키 이름 가져오기
            String value = c.getValue(); // 쿠키 값 가져오기

            System.out.println("name : " + name);
            System.out.println("value : " + value);
        }
    }

%>