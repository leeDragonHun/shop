<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="shop.dao.*" %>
<%
    System.out.println("=====startDelivery.jsp==========================================");

    // 로그인 인증 분기
    if(session.getAttribute("loginEmp") == null) {
    	String errMsg =  URLEncoder.encode("로그인을 먼저 해주세요.","utf-8");
        response.sendRedirect("/shop/emp/empLoginForm.jsp?&errMsg="+errMsg);
        return;
    }
    
    // 상품 번호 호출
    int ordersNo = Integer.parseInt(request.getParameter("ordersNo"));
    System.out.println("상품번호 : " + ordersNo);
    
    // 주문완료 -> 배송완료 처리 메서드
    int CompleteDelivery = GoodsDAO.CompleteDelivery(ordersNo);
    
    // 주문 목록으로 리스폰. 실패시 에러메시지를 담아서.
    if(CompleteDelivery >= 1){
        System.out.println("배송성공");
        response.sendRedirect("/shop/emp/orderList.jsp");
    }else{
        System.out.println("배송실패");
    	String derrMsg =  URLEncoder.encode("배송 실패 하였습니다. 담당자에게 문의하세요.","utf-8");
        response.sendRedirect("/shop/emp/orderList.jsp?&derrMsg="+derrMsg);
    }
%>
