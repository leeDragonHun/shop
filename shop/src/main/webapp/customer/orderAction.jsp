<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="shop.dao.*" %>
<%@ page import="java.util.*"%>
<%@ page import="java.net.*"%>
<%
    System.out.println("=====orderAction.jsp==================================");
    // 로그인 인증 분기
    if(session.getAttribute("loginCus") == null) {
        response.sendRedirect("/shop/customer/customerGoodsList.jsp");
        return;
    }
    
    // 로그인 정보 호출
        HashMap<String,Object> loginCus 
    = (HashMap<String,Object>)(session.getAttribute("loginCus"));
    // 주문자 ID 호출
    String cusId = (String)(loginCus.get("cus_id"));
    System.out.println("cusId : " + cusId);
    
    // 주문한 상품의 번호, 갯수 요청
    int goodsNo = Integer.parseInt(request.getParameter("goodsNo"));
    int goodsAmount = Integer.parseInt(request.getParameter("goodsAmount"));
    int ea = Integer.parseInt(request.getParameter("ea"));
    System.out.println("재고 : " + goodsAmount);
    System.out.println("상품번호 : " + goodsNo);
    System.out.println("주문갯수 : " + ea);
    
    // 주문 메서드
    int order = GoodsDAO.goodsOrder(cusId, goodsNo, ea); 
    
    // 재고 - 주문 갯수 값 구하고 재고 업데이트
    int AmountMinus = goodsAmount-ea;
    System.out.println("재고-주문갯수 : " + AmountMinus);
    // 이 액션 페이지에서 디버깅 하기위해 굳이 변수에 담음
    int AmountProcess = GoodsDAO.AmountMinusEa(AmountMinus, goodsNo);
    if(AmountProcess >= 1){
    	System.out.println("재고처리완료");
    }else {
        System.out.println("재고처리실패");
    }
    
    // 주문 완료 분기문
    if(order >= 1){
        System.out.println("주문완료");
        response.sendRedirect("/shop/customer/customerOne.jsp");
    }else {
    	System.out.println("주문실패");
    	String errMsg = URLEncoder.encode("주문 실패", "UTF-8");
    	response.sendRedirect("/shop/customer/customerGoodsList.jsp?errMsg="+errMsg);
    }
%>