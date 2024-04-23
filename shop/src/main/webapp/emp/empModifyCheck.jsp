<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@page import="shop.dao.*"%>
<%
    System.out.println("=====empModifyCheck.jsp=====================================");
    String errMsg = request.getParameter("errMsg");
    
    // 로그인 인증 분기
    if(session.getAttribute("loginEmp") == null) {
        errMsg =  URLEncoder.encode("로그인을 먼저 해주세요.","utf-8");
        response.sendRedirect("/shop/emp/empLoginForm.jsp?&errMsg="+errMsg);
        return;
    }
%>
<!DOCTYPE html>
<html>
	<head>
	<meta charset="UTF-8">
	<title>비밀번호 변경</title>
    <link rel="shortcut icon" href="/shop/mindMap/d.ico" type="image/x-icon">
    <link rel="icon" href="/shop/mindMap/d.ico" type="image/x-icon">
</head>
<body>
    <!-- 메인메뉴 -->
    <div>
        <jsp:include page="/emp/inc/empMenu.jsp"></jsp:include>
    </div>
    <%
        if(errMsg != null){
    %>
            <%=errMsg %>
    <%
        }
    %>
    
    <form method="post" action="empModifyCheckAction.jsp">
    <table>
        <tr>
            <td>현재 비밀번호 확인</td>
            <td><input type="password" name="pw"></td>
            <td><button type="submit">인증</button></td>
        </tr>
    </table>
    </form>
</body>
</html>