<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.net.*"%>
<%
    System.out.println("=====deleteCategoryList.jsp=================================");

    // 인증분기  : 세션변수 이름 - loginEmp
    if(session.getAttribute("loginEmp") == null) {
        response.sendRedirect("/shop/emp/empLoginForm.jsp");
        return;
    }
    
    // 삭제할 카테고리 이름 값 요청
    request.setCharacterEncoding("UTF-8");
    String categoryName = request.getParameter("categoryName");
    System.out.println("categoryName : " + categoryName);
    
    // DB연동
    Class.forName("org.mariadb.jdbc.Driver");
    Connection conn = null;
    conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/shop", "root", "java1234");
    
    // 사용할 쿼리문 선언
    String sql = "DELETE FROM category WHERE category = ?";
    
    // ?에 값 넣기
    PreparedStatement stmt = null;
    stmt = conn.prepareStatement(sql);
    stmt.setString(1, categoryName);
    
	// 삭제할 값 디버깅
	System.out.println("삭제할 카테고리 이름 : " + stmt);
    
	// 삭제성공여부
	int row = stmt.executeUpdate();
	
	// 삭제성공하면 -> 
	if(row == 1){
		System.out.println("카테고리 삭제 완료 : " + row);
		response.sendRedirect("/shop/emp/categoryList.jsp");
	} else {
		System.out.println("카테고리 삭제 실패");
		response.sendRedirect("/shop/emp/categoryList.jsp?errMsg=카테고리삭제실패");
	}
%>