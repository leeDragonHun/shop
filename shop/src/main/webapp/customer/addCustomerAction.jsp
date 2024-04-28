<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="shop.dao.*" %>
<%
    System.out.println("=====addCustomerAction.jsp====================================");

    //로그인 인증분기
    if(session.getAttribute("loginCus")  != null) {
        response.sendRedirect("/shop/customer/customerGoodsList.jsp");
        return;
    }
    
    // 호출값 인코딩
    request.setCharacterEncoding("UTF-8");
    
    // 호출값들
    String id = request.getParameter("id");
    String pw = request.getParameter("pw");
    String name = request.getParameter("name");
    String birth = request.getParameter("birth");
    String gender = request.getParameter("gender");
    
    // 호출값 디버깅
    System.out.println("id : " + id);
    System.out.println("pw : " + pw);
    System.out.println("name : " + name);
    System.out.println("birth : " + birth);
    System.out.println("gender : " + gender);
    
    // 회원가입 메서드
    int row = CustomerDAO.insertCustomer(id, pw, name, birth, gender);
    
    // 회원가입 분기문
    if(row >= 1){
        System.out.println("회원가입 완료");
        response.sendRedirect("/shop/customer/customerLoginForm.jsp");
    } else {
        System.out.println("회원가입 실패");
        response.sendRedirect("/shop/customer/addCustomerForm.jsp");
    }
%>