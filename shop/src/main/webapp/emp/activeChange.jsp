<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="shop.dao.*" %>
<%
    System.out.println("=====activeChange.jsp=======================================");

	//로그인 인증 분기
	if(session.getAttribute("loginEmp") == null){
		response.sendRedirect("/shop/emp/empLoginForm.jsp");
		return;
	}
	String empId = request.getParameter("empId");
	String active = request.getParameter("active");
	//디버깅
	System.out.println("empId : " + empId);
	System.out.println("active : " + active);
	
	if(active.equals("ON")){
		active = "OFF";
	} else {
		active = "ON";
	}
	int row = EmpDAO.change(active, empId);
/* 	String sql = "update emp set active = ? where emp_id = ?";
	Connection conn = DBHelper.getConnection();
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, active);
	stmt.setString(2, empId);
	System.out.println("stmt : " + stmt);
	row = stmt.executeUpdate(); */
	
	if(row == 1){
		//변경 성공
		System.out.println("변경 성공");
	} else {
		//변경 실패
		System.out.println("변경 실패");
	}
	
	response.sendRedirect("/shop/emp/empList.jsp");
%>