<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%
    HashMap<String,Object> loginCus 
    = (HashMap<String,Object>)(session.getAttribute("loginCus"));
%>
<div>
    <span>아이디 : <%=(String)(loginCus.get("cus_id"))%></span>
    <span>이름 : <%=(String)(loginCus.get("cus_name"))%></span>
    <span><a href="/shop/customer/customerGoodsList.jsp">상품목록</a></span>
    <span><a href="/shop/customer/customerOne.jsp"><마이페이지></a></span>
    <span><a href="/shop/customer/customerLogoutAction.jsp">로그아웃</a></span>
</div>