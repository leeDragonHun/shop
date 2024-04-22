<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.net.*"%>
<%@ page import="shop.dao.*" %>
<%
    System.out.println("=====customerModifyOneAction.jsp============================");

    // 로그인 인증 분기
    if(session.getAttribute("loginCus") == null){
        String errMsg =  URLEncoder.encode("로그인을 먼저 해주세요.","utf-8");
        response.sendRedirect("/shop/customer/customerLoginForm.jsp?&errMsg="+errMsg);
        return;
    }
    
    // 로그인 정보 호출
    HashMap<String,Object> loginCus 
    = (HashMap<String,Object>)(session.getAttribute("loginCus"));
    // 로그인 ID 호출
    String cusId = (String)(loginCus.get("cus_id"));
    System.out.println("현재 로그인 사용자 : " + cusId);
    
    // 수정 값 요청
    String cusPw = request.getParameter("cusPw");
    String cusName = request.getParameter("cusName");
    String cusBirth = request.getParameter("cusBirth");
    String gender = request.getParameter("gender");
    String cusAddress = request.getParameter("cusAddress");
    
    // 수정 값 디버깅
    System.out.println("cusPW : " + cusPw);
    System.out.println("cusName : " + cusName);
    System.out.println("cusBirth : " + cusBirth);
    System.out.println("gender : " + gender);
    System.out.println("cusAddress : " + cusAddress);
    
    // 회원정보 업데이트 메서드
    int customerModify = CustomerDAO.customerModify(cusPw, cusName, cusBirth, gender, cusAddress, cusId);
    if(customerModify >= 1){
        System.out.println("회원정보 수정 완료");
        response.sendRedirect("/shop/customer/customerOne.jsp");
    } else {
        System.out.println("회원정보 수정 실패");
        String errMsg = URLEncoder.encode("수정 실패. 확인 후 다시 시도하세요.", "UTF-8");
        response.sendRedirect("/shop/customer/customerModifyOne.jsp?errMsg="+errMsg);
    }
%>