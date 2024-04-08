<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    System.out.println("===empOne.jsp===============================================");
%>
<!DOCTYPE html>
<html>
	<head>
	<meta charset="UTF-8">
	<title>empOne</title>
</head>
<body>
    <!-- 메인메뉴 -->
    <div>
        <jsp:include page="/emp/inc/empMenu.jsp"></jsp:include>
    </div>
    <h1>직원정보</h1>
    <table border="1">
        <tr>
            <th>아이디</th>
            <th>등급</th>
            <th>이름</th>
            <th>직책</th>
            <th>입사일</th>
        </tr>
        <tr>
            <td>ex</td>
            <td>ex</td>
            <td>ex</td>
            <td>ex</td>
            <td>ex</td>
        </tr>
    </table>
</body>
</html>