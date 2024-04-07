<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>

<%
	HashMap<String,Object> loginMember 
		= (HashMap<String,Object>)(session.getAttribute("loginEmp"));
	
%>
<div>
    <span>아이디 : <%=(String)(loginMember.get("empId"))%></span>
    <span>등급 : <%=(Integer)(loginMember.get("grade"))%></span>
    <span>
        이름 : 
        <a href="/shop/emp/empOne.jsp">
            <%=(String)(loginMember.get("empName"))%>
        </a>
    </span>
	<span><a href="/shop/emp/empList.jsp">사원관리</a></span>
	<span><a href="/shop/emp/categoryList.jsp">카테고리관리</a></span>
	<span><a href="/shop/emp/goodsList.jsp?category=all">상품관리</a></span>
    <span><a href="/shop/emp/logoutAction.jsp">로그아웃</a></span>
</div>
