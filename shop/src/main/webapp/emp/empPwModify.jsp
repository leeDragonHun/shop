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
</body>
</html>