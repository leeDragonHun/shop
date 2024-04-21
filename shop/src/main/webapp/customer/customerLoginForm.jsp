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
	<title></title>
</head>
<body>
    <form method="post" action="/shop/customer/customerLoginAction.jsp">
        <table>
            <h1>고객 로그인</h1>
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
</body>
</html>