<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.net.*"%>
<%@ page import="shop.dao.*" %>
<%
    System.out.println("=====modifyGoodsAction.jsp==================================");

    // 로그인 인증 우회
    if(session.getAttribute("loginEmp") == null) {
        response.sendRedirect("/shop/emp/empLoginForm.jsp");
        return;
    }
    
    // 수정할 값 요청
    int goodsNo = Integer.parseInt(request.getParameter("goodsNo"));
    String category = request.getParameter("category");
    String goodsTitle = request.getParameter("goodsTitle");
    String goodsContent = request.getParameter("goodsContent");
    int goodsPrice = Integer.parseInt(request.getParameter("goodsPrice"));
    int goodsAmount = Integer.parseInt(request.getParameter("goodsAmount"));
    
    // 요청 값 디버깅
    System.out.println("상품번호 : " + goodsNo);
    System.out.println("카테고리 : " + category);
    System.out.println("상품이름 : " + goodsTitle);
    System.out.println("상품설명 : " + goodsContent);
    System.out.println("상품가격 : " + goodsPrice);
    System.out.println("상품재고 : " + goodsAmount);
    
    // 상품 상세내용 업데이트 메서드
    int modifyGoods = GoodsDAO.modifyGoods(goodsNo, category, goodsTitle, goodsContent, goodsPrice, goodsAmount);
    System.out.println("업데이트 성공 시 1반환, 실패시 0반환 : " + modifyGoods);
    
    // 성공/ 실패시 리스폰 분기문
    if(modifyGoods >= 1){
    	System.out.println("수정 성공");
    	response.sendRedirect("/shop/emp/goodsList.jsp");
    }else{
    	System.out.println("수정 실패");
    	response.sendRedirect("/shop/emp/goodsList.jsp?goodsNo="+goodsNo);
    }
%>
