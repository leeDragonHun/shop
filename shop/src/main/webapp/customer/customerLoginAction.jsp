<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "java.util.*" %>
<%@ page import="shop.dao.*" %>
<%
    System.out.println("=====customerLoginAction.jsp=====================================");

    //로그인 인증분기
    if(session.getAttribute("loginCus") != null) {
        response.sendRedirect("/shop/customer/customerGoodsList.jsp");
        return;
    }

    // id, pw 값 요청 후 디버깅
    String cusId = null;
    String cusPw = null;
    cusId = request.getParameter("cusId");
    cusPw = request.getParameter("cusPw");
    System.out.println("cusId요청값 : " + cusId);
    System.out.println("cusPw요청값 : " + cusPw);
    
    // 로그인 시키기
    HashMap<String, Object> loginCus = CustomerDAO.loginCus(cusId, cusPw);
    
    // 로그인 분기
    // 성공 시 세션 부여
    if(loginCus != null){
    	System.out.println("로그인 성공");
        
		session.setAttribute("loginCus", loginCus);
        
		HashMap<String, Object> m = (HashMap<String, Object>)(session.getAttribute("loginCus"));
		System.out.println((String)(m.get("cus_id"))); // 로그인 된 cusId
		System.out.println((String)(m.get("cus_name"))); // 로그인 된 cusName

		response.sendRedirect("/shop/customer/customerGoodsList.jsp");
    }else{
        System.out.println("로그인 실패");
        String errMsg = URLEncoder.encode("로그인 실패. 아이디와 비밀번호를 확인하세요.", "UTF-8");
        response.sendRedirect("/shop/customer/customerLoginForm.jsp?errMsg="+errMsg);
    }
%>