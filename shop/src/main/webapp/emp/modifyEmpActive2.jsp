<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%
    System.out.println("=====modifyEmpActive2.jsp====================================");

    // 로그오프면(세션값이 없으면) 로그인 폼으로 가기
    String loginEmp = (String)session.getAttribute("loginEmp");
    if(session.getAttribute("loginEmp") == null){ 
        response.sendRedirect("/shop/emp/empLoginForm.jsp"); 
        return; // 종료
    }
    
    // loginId 값 받기
    String loginId = null;
    loginId = request.getParameter("loginId");
    System.out.println("loginId : " + loginId);
    
    // 로그인 권한 부여할 직원 ID 받고 디버깅
    String retireEmp = null;
    retireEmp = request.getParameter("retireEmp");
    System.out.println("retireEmp : " + retireEmp);
    
    // DB연동 및 쿼리문 추가
	Connection conn = null;
	PreparedStatement stmt = null;
    Class.forName("org.mariadb.jdbc.Driver");
	conn = DriverManager.getConnection(
			"jdbc:mariadb://127.0.0.1:3306/shop", "root", "java1234");
	String sql = "UPDATE emp SET ACTIVE='OFF' WHERE emp_id = ? ";
    stmt = conn.prepareStatement(sql);
    stmt.setString(1,retireEmp);
    System.out.println("stmt : " + stmt);
    
    // 완료시 다시 리스트로
    int row = stmt.executeUpdate();
    if(row == 1) {
        System.out.println("권한 해제 성공");
        // 받았던 loginId도 같이 보내기
        response.sendRedirect("/shop/emp/empList.jsp?loginId="+loginId);
    } else {
        System.out.println("권한 해제 실패");      
    }
    // 자원반납
    conn.close();
%>