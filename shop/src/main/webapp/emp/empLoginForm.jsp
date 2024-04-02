<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    System.out.println("=====empLoginForm.jsp=======================================");

   // 로그인 되어있으면(세션값 있으면) List로 가기
    String loginEmp = (String)session.getAttribute("loginEmp");
    if(session.getAttribute("loginEmp") != null){ 
        response.sendRedirect("/shop/emp/empList.jsp"); 
        return; // 종료
    }
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>로그인화면</title>
</head>
<body>
    <h1>로그인</h1>
    <form action="/shop/emp/empLoginAction.jsp" method="post">
        empId : <input type="text" name="empId">
        empPw : <input type="password" name="empPw">
        <button type="submit">로그인</button>
    </form>
</body>
</html>