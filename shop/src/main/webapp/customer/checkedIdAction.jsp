<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="shop.dao.*" %>
<%@ page import="java.net.*"%>
<%
    System.out.println("=====checkedIdAction.jsp====================================");
    
    // 로그인이 되어 있으면 리스트로 이동
    if(session.getAttribute("loginCus")  != null) {
        response.sendRedirect("/shop/customer/customerGoodsList.jsp");
        return;
    }
    String id = request.getParameter("id");
    System.out.println("id : " + id);
    
    Connection conn = DBHelper.getConnection();
    
    String sql = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    sql = "SELECT cus_id FROM customer where cus_id = ?";
    stmt = conn.prepareStatement(sql);
    stmt.setString(1, id);
    rs = stmt.executeQuery();
    
    if(rs.next()){
        String msg = URLEncoder.encode("아이디가 중복됩니다.", "UTF-8");
    	response.sendRedirect("/shop/customer/addCustomerForm.jsp?msg="+msg);
    	conn.close();
    } else {
    	String msg = URLEncoder.encode("사용가능한 아이디 입니다.", "UTF-8");
    	response.sendRedirect("/shop/customer/addCustomerForm.jsp?msg="+msg+"&id="+id);
    	conn.close();
    }
%>