<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    System.out.println("customerLogoutAction.jsp========================================================");

    // 로그오프면(세션값이 없으면) 로그인 폼으로 가기
    if(session.getAttribute("loginCus") == null){ 
        response.sendRedirect("/shop/customer/customerLoginForm.jsp"); 
        return; // 종료
    }

	session.invalidate();
	response.sendRedirect("/shop/customer/customerLoginForm.jsp");
%>
