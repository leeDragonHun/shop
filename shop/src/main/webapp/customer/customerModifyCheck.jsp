<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    System.out.println("=====customerModifyCheck.jsp===============================");
    String errMsg = request.getParameter("errMsg");
%>
<!DOCTYPE html>
<html>
	<head>
	<meta charset="UTF-8">
	<title>비밀번호 확인</title>
    <link rel="shortcut icon" href="/shop/mindMap/d.ico" type="image/x-icon">
    <link rel="icon" href="/shop/mindMap/d.ico" type="image/x-icon">   
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link href="/shop/style.css" rel="stylesheet" type="text/css">     
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
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>    
</body>
</html>