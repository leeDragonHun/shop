<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@page import="shop.dao.*"%>
<%

    System.out.println("=====empPwModify.jsp============================");

    // 로그인 인증 분기
    if(session.getAttribute("loginEmp") == null) {
        String errMsg =  URLEncoder.encode("로그인을 먼저 해주세요.","utf-8");
        response.sendRedirect("/shop/emp/empLoginForm.jsp?&errMsg="+errMsg);
        return;
    }

    // 로그인 정보 호출
    HashMap<String, Object> loginEmp 
    = (HashMap<String, Object>)(session.getAttribute("loginEmp"));
    System.out.println(loginEmp);
    
    // 로그인 ID 호출
    String empId = (String)(loginEmp.get("empId"));
    System.out.println("현재 로그인 사용자 : " + empId);
%>
<!DOCTYPE html>
<html>
	<head>
	<meta charset="UTF-8">
	<title>직원 비밀번호 수정</title>
    <link rel="shortcut icon" href="/shop/mindMap/d.ico" type="image/x-icon">
    <link rel="icon" href="/shop/mindMap/d.ico" type="image/x-icon">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link href="/shop/style.css" rel="stylesheet" type="text/css">
</head>
<body>
    <!-- 메인메뉴 -->
    <div>
        <jsp:include page="/emp/inc/empMenu.jsp"></jsp:include>
    </div>
    
    <form method="post" action="/shop/emp/empPwModifyAction.jsp">
        <input type="hidden" name="empId" value="<%=empId %>">
        <table>
            <tr>
                <td>수정할 비밀번호</td>
                <td><input type="password" name="empPw"></td>
                <td><button type="submit">수정하기</button></td>
            </tr>
        </table>
    </form>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>    
</body>
</html>