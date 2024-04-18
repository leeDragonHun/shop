<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.net.*"%>
<%@ page import="shop.dao.*" %>
<%
    System.out.println("=====addCategoryList.jsp====================================");

    // 인증분기  : 세션변수 이름 - loginEmp
    if(session.getAttribute("loginEmp") == null) {
        response.sendRedirect("/shop/emp/empLoginForm.jsp");
        return;
    }
    
    // 추가할 카테고리 이름 값 요청
	request.setCharacterEncoding("UTF-8");
    String categoryName = request.getParameter("categoryName");
    System.out.println("categoryName : " + categoryName);
    
    int row = EmpDAO.insertCategory(categoryName);
    
	// 추가성공하면 -> 
	if(row == 1){
		System.out.println("카테고리 추가 완료 : " + row);
		response.sendRedirect("/shop/emp/categoryList.jsp");
	} else {
		System.out.println("카테고리 추가 실패");
		response.sendRedirect("/shop/emp/categoryList.jsp?errMsg=카테고리추가실패");
	}
%>