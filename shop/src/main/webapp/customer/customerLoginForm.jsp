<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    System.out.println("=====customerLoginForm.jsp==================================");
    if(session.getAttribute("loginCus") != null) {
        response.sendRedirect("/shop/customer/customerGoodsList.jsp");
        return;
    }
%>
<%
    String errMsg = request.getParameter("errMsg");
%>
<!DOCTYPE html>
<html>
	<head>
	<meta charset="UTF-8">
	<title>회원 로그인</title>
    <link rel="shortcut icon" href="/shop/mindMap/d.ico" type="image/x-icon">
    <link rel="icon" href="/shop/mindMap/d.ico" type="image/x-icon">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link href="/shop/style.css" rel="stylesheet" type="text/css">    
</head>
<body>
    <form method="post" action="/shop/customer/customerLoginAction.jsp">
        <table>
            <h1>회원 로그인</h1>
            <%
                if(errMsg != null){
            %>
                    <%=errMsg %>
            <%
                }
            %>
            <tr>
                <td>아이디</td>
                <td><input type="text" name="cusId" value="lyh"></td>
            </tr>
            <tr>
                <td>비밀번호</td>
                <td><input type="password" name="cusPw" value="1234"></td>
            </tr>
        </table>
        <button type="submit">로그인</button>
    </form>
    <a href="/shop/emp/empLoginForm.jsp">직원 로그인</a>
    <a href="/shop/customer/addCustomerForm.jsp">회원가입</a>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>    
</body>
</html>