<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.*" %>
<%
    System.out.println("=====addEmpForm.jsp===================================");
   
// 로그인 되어있으면(세션값 있으면) List로 가기
    if(session.getAttribute("loginEmp") != null){ 
        response.sendRedirect("/shop/emp/empList.jsp"); 
        return; // 종료
    }

    String id = null;

    
    id = request.getParameter("id");
    String errMsg = request.getParameter("errMsg");
    String okMsg = request.getParameter("okMsg");
    System.out.println("id : " + id);
 %>
<!DOCTYPE html>
<html>
	<head>
	<meta charset="UTF-8">
	<title>회원가입</title>
    <link rel="shortcut icon" href="/shop/mindMap/d.ico" type="image/x-icon">
    <link rel="icon" href="/shop/mindMap/d.ico" type="image/x-icon">
</head>
<body>
    <table>
        <form method="post" action="/shop/emp/checkedIdAction.jsp">
            <tr>
                <td>아이디</td>
                <td><input type="text" name="id" placeholder="영문, 숫자만 입력하세요"  
                        <%
                            if(id != null){
                        %>
                                value="<%=id %>"
                        <%
                            }
                        %>
                    ></td>
                <td>
                    <button type="submit">중복조회</button>
                    <%if(errMsg != null){%><%=errMsg %><%} %>
                    <%if(okMsg != null){%><%=okMsg %><%} %>
                </td>
            </tr>
        </form>
        
        <form method="post" action="/shop/emp/addEmpAction.jsp">
            <input type="hidden" name="id" 
                <%
                    if(id != null){
                %>
                        value="<%=id %>"
                <%
                    }
                %>
            >
            <tr>
                <td>암호</td>
                <td><input type="password" name="pw" 
                    <%
                        if(errMsg != null){
                    %>
                            disabled
                    <%
                        }
                    %>
                ></td>
            </tr>
            <tr>
                <td>이름</td>
                <td><input type="text" name="name"
                    <%
                        if(errMsg != null){
                    %>
                            disabled
                    <%
                        }
                    %>                
                ></td>
            </tr>
         </table>
            <%
                if(okMsg != null){
            %>
                <button type="submit">회원가입</button>
            <%
                }
            %>
        </form>
</body>
</html>