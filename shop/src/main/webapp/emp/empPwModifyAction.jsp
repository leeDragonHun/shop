<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.net.*"%>
<%@ page import="shop.dao.*" %>
<%
    System.out.println("=====empPwModifyAction.jsp============================");

    // 로그인 인증 분기
    if(session.getAttribute("loginEmp") == null) {
        String errMsg =  URLEncoder.encode("로그인을 먼저 해주세요.","utf-8");
        response.sendRedirect("/shop/emp/empLoginForm.jsp?&errMsg="+errMsg);
        return;
    }
    
    // where절에 쓸 id값 요청
    String empId = request.getParameter("empId");
    // update절 ? 값에 들어갈 pw값 요청
    String empPw = request.getParameter("empPw");
    
    // id, pw 디버깅
    System.out.println("empId : " + empId);
    System.out.println("empPw : " + empPw);
    
     // 회원정보 업데이트 메서드
    int empPwModify = EmpDAO.empPwModify(empId, empPw);
    if(empPwModify >= 1){
    	System.out.println("수정 성공");
    	response.sendRedirect("/shop/emp/empOne.jsp");
    } else{
    	System.out.println("수정 실패");
    	String errMsg = URLEncoder.encode("수정 실패. 확인 후 다시 시도하세요.", "UTF-8");
    	response.sendRedirect("/shop/emp/empPwModify.jsp?errMsg="+errMsg);
    }
    
%>
