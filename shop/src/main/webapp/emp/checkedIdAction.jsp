<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="shop.dao.*" %>
<%@ page import="java.net.URLEncoder"%>
<%
    System.out.println("=====checkedIdAction.jsp====================================");

    // 로그인 되어있으면(세션값 있으면) List로 가기
    if(session.getAttribute("loginEmp") != null){ 
        response.sendRedirect("/shop/emp/empList.jsp"); 
        return; // 종료
    }
    
    // id 값 호출
    String id = request.getParameter("id");
    System.out.println("id : " + id);
    
    // DB 연결
    Connection conn = DBHelper.getConnection();
    
    // 선언문
    String sql = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    
    // 아이디 중복확인
    sql = "SELECT emp_id FROM emp where emp_id = ?";
    stmt = conn.prepareStatement(sql);
    stmt.setString(1, id);
    rs = stmt.executeQuery();
    System.out.println(stmt);
    
    // 아이디 중복 확인 분기문
    if(rs.next()){
        String errMsg = URLEncoder.encode("아이디가 중복됩니다.", "UTF-8");
    	response.sendRedirect("/shop/emp/addEmpForm.jsp?errMsg="+errMsg);
    	conn.close();
    } else {
    	String okMsg = URLEncoder.encode("사용가능한 아이디 입니다.", "UTF-8");
    	response.sendRedirect("/shop/emp/addEmpForm.jsp?okMsg="+okMsg+"&id="+id);
    	conn.close();
    }
%>