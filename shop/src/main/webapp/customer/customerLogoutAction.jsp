<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    System.out.println("customerLogoutAction.jsp========================================================");

    //로그인 인증분기
    if(session.getAttribute("loginCus") == null){ 
        response.sendRedirect("/shop/customer/customerLoginForm.jsp"); 
        return; // 종료
    }

    // 세션값 비우기
	session.invalidate();
	response.sendRedirect("/shop/customer/customerLoginForm.jsp");
%>
