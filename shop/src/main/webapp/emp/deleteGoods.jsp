<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="shop.dao.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.nio.file.*" %>
<%@ page import="java.net.*"%>
<%
    System.out.println("=====deleteGoods.jsp========================================");

    // 인증분기	 : 세션변수 이름 - loginEmp
    if(session.getAttribute("loginEmp") == null) {
    	response.sendRedirect("/shop/emp/empLoginForm.jsp");
    	return;
    }
    
    // goods_no 요청
    int goodsNo = Integer.parseInt(request.getParameter("goodsNo"));
    System.out.println("상품번호 넘어온 값 : " + goodsNo);
    
    // 톰캣서버 올린 사진파일삭제 메서드
    ResultSet dfn = GoodsDAO.goodsDeleteImg(goodsNo);
	String filePath = request.getServletContext().getRealPath("upload");
    while(dfn.next()){
    	dfn.getString("filename"); 
        File df = new File(filePath, dfn.getString("filename"));
    	System.out.println(dfn.getString("filename"));
        df.delete();
    }
    
    // 삭제 성공하면 다시 리스트로. 
    int deleteGoods = GoodsDAO.deleteGoods(goodsNo);
    if(deleteGoods >= 1){
    	System.out.println("상품 삭제 완료");
    	response.sendRedirect("/shop/emp/empList.jsp");
    }else{
    	System.out.println("상품 삭제 실패");
    	response.sendRedirect("/shop/emp/empList.jsp");
    }
    
%>