<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="shop.dao.*" %>
<%@ page import="java.net.*"%>
<%
    System.out.println("=====addCustomerAction.jsp====================================");
    // 로그인 되어있으면(세션값 있으면) List로 가기
    if(session.getAttribute("loginEmp") != null){ 
        response.sendRedirect("/shop/emp/empList.jsp"); 
        return; // 종료
    }

    request.setCharacterEncoding("UTF-8");
    
    String id = request.getParameter("id");
    String pw = request.getParameter("pw");
    String name = request.getParameter("name");
    
    System.out.println("id : " + id);
    System.out.println("pw : " + pw);
    System.out.println("name : " + name);
    
    int addEmp = EmpDAO.addEmp(id, pw, name);
    
    if(addEmp >= 1){
        System.out.println("회원가입 완료");
        String msg = URLEncoder.encode("가입 승인 대기중입니다. 담당자 : 인사총무과/덤블도어 tel)010-1234-5678", "UTF-8");
        response.sendRedirect("/shop/emp/empLoginForm.jsp?msg="+msg);
    } else {
        System.out.println("회원가입 실패");
        String errMsg = URLEncoder.encode("가입에 실패 하였습니다.", "UTF-8");
        response.sendRedirect("/shop/emp/addEmpForm.jsp");
    }
    
%>