<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>

<%
    // 직원 로그인 정보
	HashMap<String,Object> loginMember 
		= (HashMap<String,Object>)(session.getAttribute("loginEmp"));
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
    <li><a class="dropdown-item" href="/shop/emp/empOne.jsp">이름 : <%=(String)(loginMember.get("empName"))%></a></li>
    <li><a class="dropdown-item" href="/shop/emp/empOne.jsp">등급 : <%=(Integer)(loginMember.get("grade"))%></a></li>
    <li><hr class="dropdown-divider"></li>
    <li><a class="dropdown-item" href="/shop/emp/empList.jsp">사원목록</a></li>
    <li><a class="dropdown-item" href="/shop/emp/customerList.jsp">고객목록</a></li>
    <li><a class="dropdown-item" href="/shop/emp/categoryList.jsp">카테고리관리</a></li>
    <li><a class="dropdown-item" href="/shop/emp/addGoodsForm.jsp">상품등록</a></li>
    <li><a class="dropdown-item" href="/shop/emp/goodsList.jsp?category=all">상품목록</a></li>
    <li><a class="dropdown-item" href="/shop/emp/orderList.jsp">주문내역관리</a></li>
    <li><a class="dropdown-item" href="/shop/emp/empOne.jsp">마이페이지</a></li>
    <li><a class="dropdown-item" href="/shop/emp/logoutAction.jsp">로그아웃</a></li>
  </ul>
</li>