<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    System.out.println("=====customerDeleteCheck.jsp===============================");
    String errMsg = request.getParameter("errMsg");
%>
<!DOCTYPE html>
<html>
	<head>
	<meta charset="UTF-8">
	<title>비밀번호 확인</title>
    <link rel="shortcut icon" href="/shop/mindMap/d.ico" type="image/x-icon">
    <link rel="icon" href="/shop/mindMap/d.ico" type="image/x-icon">
</head>
<body>
    <%
        if(errMsg != null){
    %>
            <%=errMsg %>
    <%
        }
    %>
    <form method="post" action="customerDeleteCheckAction.jsp">
    <table>
        <tr>
            <td>비밀번호</td>
            <td><input type="password" name="pw"></td>
            <td><button type="submit">인증</button></td>
        </tr>
    </table>
    </form>
</body>
</html>