<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    System.out.println("=====addCustomerForm.jsp===================================");
    if(session.getAttribute("loginCus")  != null) {
        response.sendRedirect("/shop/customer/customerGoodsList.jsp");
        return;
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
	<title>addCustomerForm</title>
</head>
<body>
    <table>
        <form method="post" action="/shop/customer/checkedIdAction.jsp">
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
        
        <form method="post" action="/shop/customer/addCustomerAction.jsp">
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
            <tr>
                <td>생일</td>
                <td><input type="date" name="birth"                     
                    <%
                        if(errMsg != null){
                    %>
                            disabled
                    <%
                        }
                    %> ></td>
            </tr>
            <tr>
                <td>성별</td>
                <td>
                    <input type="radio" name="gender" value="남" checked 
                        <%
                            if(errMsg != null){
                        %>
                                disabled
                        <%
                            }
                        %>                     
                    >남 
                    <input type="radio" name="gender" value="여"                     
                        <%
                            if(errMsg != null){
                        %>
                                disabled
                        <%
                            }
                        %>
                    >여
                </td>
                <td></td>
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