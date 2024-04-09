<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
	<meta charset="UTF-8">
	<title>addCustomerForm</title>
</head>
<body>
    <form method="post" action="/customer/checkedIdAction.jsp">
        <td>아이디</td>
        <td><input type="text" name="id"></td>
        <td><button type="submit">중복조회</button></td>
    </form><br>
    <form method="post" action="/customer/addCustomerAction.jsp">
        <table>
            <input type="hidden" value="<%=id %>">
            <tr>
                <td>암호</td>
                <td><input type="password" name="pw"></td>
            </tr>
            <tr>
                <td>이름</td>
                <td><input type="text" name="name"></td>
            </tr>
            <tr>
                <td>생일</td>
                <td><input type="date" name="birth"></td>
            </tr>
            <tr>
                <td>성별</td>
                <td><input type="radio" name="gender" value="남" checked>남 <input type="radio" name="gender" value="여">여</td>
                <td></td>
            </tr>
        </table>
        <button type="submit">회원가입</button>
    </form>
</body>
</html>