<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@page import="shop.dao.*"%>
<%
    System.out.println("=====empModifyCheckAction.jsp=========================");

    // 로그인 인증 분기
    if(session.getAttribute("loginEmp") == null) {
        String errMsg =  URLEncoder.encode("로그인을 먼저 해주세요.","utf-8");
        response.sendRedirect("/shop/emp/empLoginForm.jsp?&errMsg="+errMsg);
        return;
    }
    
    // 로그인 정보 호출
    HashMap<String, Object> loginEmp 
    = (HashMap<String, Object>)(session.getAttribute("loginEmp"));
    System.out.println(loginEmp);
    
    // 로그인 ID 호출
    String empId = (String)(loginEmp.get("empId"));
    System.out.println("현재 로그인 사용자 : " + empId);
    
    // 비밀번호 값 요청
    String pw = request.getParameter("pw");
    System.out.println("입력한 비밀번호 : " + pw);
    
    // 현재 로그인 ID의 pw가 요청받은 pw값과 일치하는 지 확인후 맞으면 개인정보수정페이지로 넘어가기
    boolean idPwCheck = EmpDAO.idPwCheck(empId, pw);
    System.out.println("idPwCheck : " + idPwCheck);
    if(idPwCheck){
        System.out.println("비밀번호 일치");
        response.sendRedirect("/shop/emp/empPwModify.jsp");
    }else{
    	System.out.println("비밀번호 불일치");
    	String errMsg = URLEncoder.encode("비밀번호가 일치하지 않습니다. 다시 확인해주세요.", "UTF-8");
        response.sendRedirect("/shop/emp/empModifyCheck.jsp?errMsg="+errMsg);
    }
%>