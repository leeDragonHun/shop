<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="shop.dao.*" %>
<%
    System.out.println("=====completeBuy.jsp==========================================");

    // 로그인 인증 분기
    if(session.getAttribute("loginCus") == null) {
        String errMsg =  URLEncoder.encode("로그인을 먼저 해주세요.","utf-8");
        response.sendRedirect("/shop/customer/customerLoginForm.jsp?&errMsg="+errMsg);
        return;
    }
    
    // 상품 번호 호출
    int ordersNo = Integer.parseInt(request.getParameter("ordersNo"));
    System.out.println("상품번호 : " + ordersNo);
    
    // 배송완료 -> 구매확정 처리 메서드
    int CompleteBuy = GoodsDAO.CompleteBuy(ordersNo);
    
    // 주문 목록으로 리스폰. 실패시 에러메시지를 담아서.
    if(CompleteBuy >= 1){
        System.out.println("구매확정완료");
        response.sendRedirect("/shop/customer/customerOne.jsp");
    }else{
        System.out.println("구매확정실패");
    	String berrMsg =  URLEncoder.encode("배송 실패 하였습니다. 담당자에게 문의하세요.","utf-8");
        response.sendRedirect("/shop/customer/customerOne.jsp?&berrMsg="+berrMsg);
    }
%>