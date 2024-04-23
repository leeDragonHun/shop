<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%@ page import="java.util.*" %>
<%@ page import="shop.dao.*" %>
<%
    System.out.println("===empOne.jsp===============================================");

    // 로그인 인증 분기
    if(session.getAttribute("loginEmp") == null) {
        String errMsg =  URLEncoder.encode("로그인을 먼저 해주세요.","utf-8");
        response.sendRedirect("/shop/emp/empLoginForm.jsp?&errMsg="+errMsg);
        return;
    }
    
    // loginEmp
    HashMap<String, Object> m = (HashMap<String, Object>)(session.getAttribute("loginEmp"));
    System.out.println(m);
%>
<!DOCTYPE html>
<html>
	<head>
	<meta charset="UTF-8">
	<title>직원 마이페이지</title>
    <link rel="shortcut icon" href="/shop/mindMap/d.ico" type="image/x-icon">
    <link rel="icon" href="/shop/mindMap/d.ico" type="image/x-icon">    
</head>
<body>
    <!-- 메인메뉴 -->
    <div>
        <jsp:include page="/emp/inc/empMenu.jsp"></jsp:include>
    </div>
    <h1>나의 정보</h1>
    <table border="1">
        <tr>
            <th>아이디</th>
            <th>등급</th>
            <th>이름</th>
            <th>직책</th>
            <th>입사일</th>
        </tr>
        <tr>
            <tr>
                <td><%= m.get("empId") %></td>
                <td><%= m.get("grade") %></td>
                <td><%= m.get("empName") %></td>
                <td><%= m.get("empJob") %></td>
                <td><%= m.get("hireDate") %></td>
            </tr>
        </tr>
        <tr>
            <td colspan="5">직원 정보는 개인이 수정 불가합니다. 인사과에 문의하세요.</td>
        </tr>
    </table>
    <a href="/shop/emp/empModifyCheck.jsp">비밀번호 수정</a>
</body>
</html>