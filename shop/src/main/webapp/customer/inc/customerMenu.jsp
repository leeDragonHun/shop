<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%
    // 고객 로그인 정보
    HashMap<String,Object> loginCus 
    = (HashMap<String,Object>)(session.getAttribute("loginCus"));
%>
<!-- 네비게이션 바 -->
<!-- 네비게이션 바 리스트 스타일 변경 -->
<style>
    li { list-style-type : none }
</style>
<li class="nav-item dropdown">
  <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
    마이페이지
  </a>
  <ul class="dropdown-menu">
    <li><a class="dropdown-item" href="/shop/customer/customerOne.jsp">아이디 : <%=(String)(loginCus.get("cus_id"))%></a></li>
    <li><a class="dropdown-item" href="/shop/customer/customerOne.jsp">이름 : <%=(String)(loginCus.get("cus_name"))%></a></li>
    <li><hr class="dropdown-divider"></li>
    <li><a class="dropdown-item" href="/shop/customer/customerGoodsList.jsp">상품목록</a></li>
    <li><a class="dropdown-item" href="/shop/customer/customerOne.jsp">마이페이지</a></li>
    <li><a class="dropdown-item" href="/shop/customer/customerLogoutAction.jsp">로그아웃</a></li>
  </ul>
</li>