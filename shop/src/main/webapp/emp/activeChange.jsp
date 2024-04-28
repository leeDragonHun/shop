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
    
    // 직원 id, active 값 호출 후 디버깅
	String empId = request.getParameter("empId");
	String active = request.getParameter("active");
	System.out.println("empId : " + empId);
	System.out.println("active : " + active);
	
    // active 분기
    // active가 on 이면 off로 off 면 on으로 변경하여 메서드에 값 넣을 것임.
    // 변경된 값을 메서드에 줘서 업데이트 쿼리에 적용시키기 위함
	if(active.equals("ON")){
		active = "OFF";
	} else {
		active = "ON";
	}
	int row = EmpDAO.change(active, empId);
	
    // 변경 분기문
	if(row == 1){
		//변경 성공
		System.out.println("변경 성공");
	} else {
		//변경 실패
		System.out.println("변경 실패");
	}
	
	response.sendRedirect("/shop/emp/empList.jsp");
%>