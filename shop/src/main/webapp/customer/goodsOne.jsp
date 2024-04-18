<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    System.out.println("=====goodsOne.jsp===========================================");
    
    // 로그인 인증 분기
    if(session.getAttribute("loginCus") == null){
        response.sendRedirect("/shop/customer/customerLoginForm.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
	<head>
	<meta charset="UTF-8">
	<title></title>
</head>
<body>

</body>
</html>