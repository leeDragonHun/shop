<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    System.out.println("=====empLoginAction.jsp=====================================");

    // 로그인 되어있으면(세션값 있으면) List로 가기
    String loginEmp = (String)session.getAttribute("loginEmp");
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
    
    
    //DB연동
    Class.forName("org.mariadb.jdbc.Driver");
    Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/shop","root","java1234");
    // ip, pw가 DB랑 일치하는 지, active가 ON 인지
    String sql = "SELECT emp_id empId FROM emp WHERE emp_id = ? AND emp_pw = password(?) AND active='ON'";
    PreparedStatement stmt = conn.prepareStatement(sql);
    stmt.setString(1,empId);
    stmt.setString(2,empPw);
    System.out.println("stmt : " + stmt);
    ResultSet rs = stmt.executeQuery();
    
    // 성공시 empList로 실패시 다시 empLoginForm으로
    if(rs.next()){
    	System.out.println("로그인 성공");
        session.setAttribute("loginEmp", rs.getString("empId"));
        response.sendRedirect("/shop/emp/empList.jsp?loginId="+empId);
    }else{
        System.out.println("로그인 실패");
        response.sendRedirect("/shop/emp/empLoginForm.jsp");
    }
    // 자원반납
    conn.close();

%>