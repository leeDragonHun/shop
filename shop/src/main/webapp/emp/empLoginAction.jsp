<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "shop.dao.*" %>
<%
    System.out.println("=====empLoginAction.jsp=====================================");

    // 로그인 되어있으면(세션값 있으면) List로 가기
    if(session.getAttribute("loginEmp") != null){ 
        response.sendRedirect("/shop/emp/empList.jsp"); 
        return; // 종료
    }
%>
<%
    // id, pw 요청
    String empId = null;
    String empPw = null;
    empId = request.getParameter("empId");
    empPw = request.getParameter("empPw");
    // id, pw 디버깅
    System.out.println("empId : " + empId);
    System.out.println("empPw : " + empPw);
    
    HashMap<String, Object> loginEmp = EmpDAO.loginEmp(empId, empPw);
    
    // 성공시 empList로 실패시 다시 empLoginForm으로
    if(loginEmp != null){
    	System.out.println("로그인 성공");
        
		session.setAttribute("loginEmp", loginEmp);
        
		HashMap<String, Object> m = (HashMap<String, Object>)(session.getAttribute("loginEmp"));
		System.out.println((String)(m.get("empId"))); // 로그인 된 empId
		System.out.println((String)(m.get("empName"))); // 로그인 된 empName
		System.out.println((Integer)(m.get("grade"))); // 로그인 된 grade

		response.sendRedirect("/shop/emp/empList.jsp");
    }else{
        System.out.println("로그인 실패");
        response.sendRedirect("/shop/emp/empLoginForm.jsp");
    }
    // 자원반납
%>