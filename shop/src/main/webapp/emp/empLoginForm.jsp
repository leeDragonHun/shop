<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    System.out.println("=====empLoginForm.jsp=======================================");

   // 로그인 되어있으면(세션값 있으면) List로 가기
    if(session.getAttribute("loginEmp") != null){ 
        response.sendRedirect("/shop/emp/empList.jsp"); 
        return; // 종료
    }

    // 에러메시지 받기.
    String errMsg = request.getParameter("errMsg");
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
	<title>로그인화면</title>
</head>
<body>
    <%
        if(errMsg != null){
    %>
            <%=errMsg %>
    <%
        }
    %>
    <h1>직원 로그인</h1>
    <form action="/shop/emp/empLoginAction.jsp" method="post">
    <table>
        <tr>
            <td>아이디</td>
            <td><input type="text" name="empId" value="admin"></td>
        </tr>
        <tr>
            <td>비밀번호</td>
            <td><input type="password" name="empPw" value="1234"></td>
        </tr>
    </table>
    <button type="submit">로그인</button>
    </form>
    <a href="/shop/customer/customerLoginForm.jsp">고객 로그인</a>
</body>
</html>