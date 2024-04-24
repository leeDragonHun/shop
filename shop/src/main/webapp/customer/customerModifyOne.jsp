<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.net.*"%>
<%@ page import="shop.dao.*" %>
<%
    System.out.println("=====customerModifyOne.jsp=================================");

    // 로그인 인증 분기
    if(session.getAttribute("loginCus") == null){
        String errMsg =  URLEncoder.encode("로그인을 먼저 해주세요.","utf-8");
        response.sendRedirect("/shop/customer/customerLoginForm.jsp?&errMsg="+errMsg);
        return;
    }
    
    // 로그인 정보 호출
    HashMap<String,Object> loginCus 
    = (HashMap<String,Object>)(session.getAttribute("loginCus"));
    // 로그인 ID 호출
    String cusId = (String)(loginCus.get("cus_id"));
    System.out.println("현재 로그인 사용자 : " + cusId);
%>
<!DOCTYPE html>
<html>
	<head>
	<meta charset="UTF-8">
	<title>회원정보수정</title>
    <link rel="shortcut icon" href="/shop/mindMap/d.ico" type="image/x-icon">
    <link rel="icon" href="/shop/mindMap/d.ico" type="image/x-icon">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link href="/shop/style.css" rel="stylesheet" type="text/css">    
</head>
<body>
    <form method="post" action="/shop/customer/customerModifyOneAction.jsp">
    <table>
        <tr>
            <td>아이디</td>
            <td><%=cusId %></td>
        </tr>
        <tr>
            <td>비밀번호</td>
            <td><input type="password" name="cusPw"></td>
        </tr>
        <tr>
            <td>이름</td>
            <td><input type="text" name="cusName"></td>
        </tr>
        <tr>
            <td>생일</td>
            <td><input type="date" name="cusBirth"></td>
        </tr>
        <tr>
            <td>성별</td>
            <td>
                <input type="radio" name="gender" value="여" checked="checked">여자
                <input type="radio" name="gender" value="남">남자
            </td>
        </tr>
        <tr>
            <td>주소</td>
            <td>
                <textarea name="cusAddress" rows="2" cols="50"></textarea>
            </td>
        </tr>
        <tr><td><button type="submit">수정하기</button></td></tr>
    </table>
    </form>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>    
</body>
</html>