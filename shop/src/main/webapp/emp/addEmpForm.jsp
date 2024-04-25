<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.*" %>
<%
    System.out.println("=====addEmpForm.jsp===================================");
   
    // 로그인 되어있으면(세션값 있으면) List로 가기
    if(session.getAttribute("loginEmp") != null){ 
        response.sendRedirect("/shop/emp/empList.jsp"); 
        return; // 종료
    }
    
    // id 변수 선언
    String id = null;

    // id 값 가져오기(중복체크페이지로 부터(checkedIdAction.jsp))
    id = request.getParameter("id");
    
    // id 값 디버깅
    System.out.println("id : " + id);
    
    // 메시지 변수들 선언(실패시, 성공시)
    String errMsg = request.getParameter("errMsg");
    String okMsg = request.getParameter("okMsg");
 %>
<!DOCTYPE html>
<html>
	<head>
	<meta charset="UTF-8">
	<title>회원가입</title>
    <link rel="shortcut icon" href="/shop/mindMap/d.ico" type="image/x-icon">
    <link rel="icon" href="/shop/mindMap/d.ico" type="image/x-icon">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link href="/shop/style.css" rel="stylesheet" type="text/css">    
</head>
<body>
    <table>
        <%
            if(errMsg != null){
        %>
                <%=errMsg %>
        <%
            }
        %>
        <%
            if(okMsg != null){
        %>
                <%=okMsg %>
        <%
            }
        %>
        <%
            if(id == null){
        %>
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
        <%
            }
        %>
        
        
        <form method="post" action="/shop/emp/addEmpAction.jsp">
            <%
                if(id != null){
            %>
                <tr>
                    <td>아이디</td>
                    <td>
                        <input type="text" name="id" 
                            <%
                                if(id != null){
                            %>
                                    value="<%=id %>"
                            <%
                                }
                            %>
                         readonly="readonly">
                    </td>
                </tr>
            <%
                }
            %>
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
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>        
</body>
</html>