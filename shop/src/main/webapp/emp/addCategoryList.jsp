<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.net.*"%>
<%@ page import="shop.dao.*" %>
<%
    System.out.println("=====addCategoryList.jsp====================================");

    //로그인 인증분기
    if(session.getAttribute("loginEmp") == null) {
        response.sendRedirect("/shop/emp/empLoginForm.jsp");
        return;
    }
    
    // 추가할 카테고리 이름 값 요청
	request.setCharacterEncoding("UTF-8");
    String categoryName = request.getParameter("categoryName");
    System.out.println("categoryName : " + categoryName);
    
    // 카테고리 추가 메서드
    int row = EmpDAO.insertCategory(categoryName);
    
	// 성공여부 분기문
	if(row == 1){
		System.out.println("카테고리 추가 완료 : " + row);
		response.sendRedirect("/shop/emp/categoryList.jsp");
	} else {
		System.out.println("카테고리 추가 실패");
		response.sendRedirect("/shop/emp/categoryList.jsp?errMsg=카테고리추가실패");
	}
%>