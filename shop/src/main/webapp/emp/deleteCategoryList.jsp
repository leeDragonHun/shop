<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.net.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*" %>
<%@ page import="java.nio.file.*" %>
<%@ page import="shop.dao.*" %>
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
    Connection conn = DBHelper.getConnection();    
    // 사용할 쿼리문 선언
    String sql = "DELETE FROM category WHERE category = ?";
    String sql2 = "SELECT filename FROM goods WHERE category= ?";
    
    // ?에 값 넣기
    PreparedStatement stmt = null;
    PreparedStatement stmt2 = null;
    ResultSet rs2 = null; 
    stmt = conn.prepareStatement(sql);
    stmt2 = conn.prepareStatement(sql2);
    stmt.setString(1, categoryName);
    stmt2.setString(1, categoryName);
    rs2 = stmt2.executeQuery();
    
	// 삭제할 값 디버깅
	System.out.println("삭제할 카테고리 이름 : " + stmt);
	System.out.println("삭제할 카테고리 DB의 사진 filename : " + stmt2);    
    
	String filePath = request.getServletContext().getRealPath("upload");
    while(rs2.next()){
    	rs2.getString("filename"); 
        File df = new File(filePath, rs2.getString("filename"));
    	System.out.println(rs2.getString("filename"));
        df.delete();
    }
    // 파일 삭제 API

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