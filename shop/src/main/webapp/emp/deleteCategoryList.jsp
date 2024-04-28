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
    
    // 톰캣서버 올린 사진파일삭제 메서드
    ResultSet dfn = EmpDAO.deleteFileName(categoryName);
	String filePath = request.getServletContext().getRealPath("upload");
    while(dfn.next()){
    	dfn.getString("filename"); 
        File df = new File(filePath, dfn.getString("filename"));
    	System.out.println(dfn.getString("filename"));
        df.delete();
    }

    // 삭제 매서드
	int row = EmpDAO.deleteCategory(categoryName);
	
	// 삭제성공하면 -> 
	if(row == 1){
		System.out.println("카테고리 삭제 완료 : " + row);
		response.sendRedirect("/shop/emp/categoryList.jsp");
	} else {
		System.out.println("카테고리 삭제 실패");
		response.sendRedirect("/shop/emp/categoryList.jsp?errMsg=카테고리삭제실패");
	}
%>