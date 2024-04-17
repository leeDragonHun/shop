<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%@ page import="shop.dao.*" %>
<%
    System.out.println("=====modifyEmpActive2.jsp====================================");

    // 로그오프면(세션값이 없으면) 로그인 폼으로 가기
    if(session.getAttribute("loginEmp") == null){ 
        response.sendRedirect("/shop/emp/empLoginForm.jsp"); 
        return; // 종료
    }
    
    // 로그인 권한 부여할 직원 ID 받고 디버깅
    String retireEmp = null;
    if(retireEmp == null){ 
        response.sendRedirect("/shop/emp/empLoginForm.jsp"); 
        return; // 종료
    }
    retireEmp = request.getParameter("retireEmp");
    System.out.println("retireEmp : " + retireEmp);
    
    // DB연동 및 쿼리문 추가
/*     Connection conn = DBHelper.getConnection();
	PreparedStatement stmt = null;
	String sql = "UPDATE emp SET ACTIVE='OFF' WHERE emp_id = ? ";
    stmt = conn.prepareStatement(sql);
    stmt.setString(1,retireEmp);
    System.out.println("stmt : " + stmt); */
    
    int row = EmpDAO.onOff(retireEmp);
    
    // 완료시 다시 리스트로
    if(row == 1) {
        System.out.println("권한 해제 성공");
        // 받았던 loginId도 같이 보내기
        response.sendRedirect("/shop/emp/empList.jsp");
    } else {
        System.out.println("권한 해제 실패");      
    }
    // 자원반납
%>
