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
	<title>직원 로그인</title>
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
    <h1>직원 로그인</h1>
    <form action="/shop/emp/empLoginAction.jsp" method="post">
    <table>
        <tr>
            <td>아이디</td>
            <td><input type="text" name="empId"></td>
        </tr>
        <tr>
            <td>비밀번호</td>
            <td><input type="password" name="empPw"></td>
        </tr>
    </table>
    <button type="submit">로그인</button>
    </form>
    <a href="/shop/customer/customerLoginForm.jsp">회원 로그인</a>
    <a href="/shop/emp/addEmpForm.jsp">직원 가입</a>
</body>
</html>