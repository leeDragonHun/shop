<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    System.out.println("=====customerModifyCheck.jsp===============================");
    String errMsg = request.getParameter("errMsg");
%>
<!DOCTYPE html>
<html>
	<head>
	<meta charset="UTF-8">
	<title></title>
</head>
<body>
    <%
        if(errMsg != null){
    %>
            <%=errMsg %>
    <%
        }
    %>
    <form method="post" action="customerModifyCheckAction.jsp">
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