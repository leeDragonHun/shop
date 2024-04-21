<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="shop.dao.*" %>
<%
    System.out.println("=====writeReviewAction.jsp==========================================");
    
    // 로그인 인증 분기
    if(session.getAttribute("loginCus") == null) {
        String errMsg =  URLEncoder.encode("로그인을 먼저 해주세요.","utf-8");
        response.sendRedirect("/shop/customer/customerLoginForm.jsp?&errMsg="+errMsg);
        return;
    }
    
    // 값 요청
    int ordersNo = Integer.parseInt(request.getParameter("ordersNo"));
    String cusId = request.getParameter("cusId");
    String goodsTitle = request.getParameter("goodsTitle");
    String content = request.getParameter("content");
    int rating = Integer.parseInt(request.getParameter("rating"));
    System.out.println("상품번호 : " + ordersNo);
    System.out.println("작성자 : " + cusId);
    System.out.println("상품이름 : " + goodsTitle);
    System.out.println("내용 : " + content);
    System.out.println("별점 : " + rating);
    
    // 리뷰 작성 메서드
    int writeReview = GoodsDAO.writeReview(ordersNo, cusId, goodsTitle, content, rating);
    // 리뷰작성 후 state를 구매확정->리뷰완료로 변경하는 메서드
    
    // 성공실패 리스폰 분기문
    if(writeReview >= 1){
        System.out.println("리뷰작성완료");
        GoodsDAO.CompleteReview(ordersNo);
        System.out.println("변경완료(구매확정->리뷰작성)");
        response.sendRedirect("/shop/customer/customerOne.jsp");
    }else{
        System.out.println("리뷰작성실패");
    	String rerrMsg =  URLEncoder.encode("리뷰작성 실패 하였습니다. 고객센터에 문의하세요.","utf-8");
        response.sendRedirect("/shop/customer/customerOne.jsp?&rerrMsg="+rerrMsg);
    }
    
%>