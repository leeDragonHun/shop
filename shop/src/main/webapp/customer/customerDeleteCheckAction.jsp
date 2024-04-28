<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@page import="shop.dao.*"%>
<%
    System.out.println("=====customerDeleteCheckAction.jsp=========================");

    // 로그인 인증 분기
    if(session.getAttribute("loginCus") == null) {
        String errMsg =  URLEncoder.encode("로그인을 먼저 해주세요.","utf-8");
        response.sendRedirect("/shop/customer/customerLoginForm.jsp?&errMsg="+errMsg);
        return;
    }

    // 로그인 정보 호출
    HashMap<String,Object> loginCus 
    = (HashMap<String,Object>)(session.getAttribute("loginCus"));
    
    // 로그인 ID 호출 후 디버깅
    String cusId = (String)(loginCus.get("cus_id"));
    System.out.println("현재 로그인 사용자 : " + cusId);
    
    // 비밀번호 값 요청 후 디버깅
    String pw = request.getParameter("pw");
    System.out.println("입력한 비밀번호 : " + pw);
    
    // 현재 로그인 ID의 pw가 요청받은 pw값과 일치하는 지 확인후 맞으면 개인정보수정페이지로 넘어가기
    boolean idPwCheck = CustomerDAO.idPwCheck(cusId, pw);
    System.out.println("idPwCheck : " + idPwCheck);
    if(idPwCheck){
        System.out.println("비밀번호 일치");
        // 회원 탈퇴 메서드(customer DB에서 해당 id 삭제)
        CustomerDAO.customerDelete(cusId);
    	session.invalidate();
        System.out.println("탈퇴완료");
        response.sendRedirect("/shop/customer/customerLoginForm.jsp");
    }else{
    	System.out.println("비밀번호 불일치");
    	String errMsg = URLEncoder.encode("비밀번호가 일치하지 않습니다. 다시 확인해주세요.", "UTF-8");
        response.sendRedirect("/shop/customer/customerDeleteCheck.jsp&errMsg="+errMsg);
    }
%>