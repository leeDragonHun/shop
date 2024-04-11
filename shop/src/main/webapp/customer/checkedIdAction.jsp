<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.net.URLEncoder"%>
<%@ include file="/emp/inc/jdbc.jsp"%>
<%
    System.out.println("=====checkedIdAction.jsp====================================");

    if(session.getAttribute("loginCus")  != null) {
        response.sendRedirect("/shop/customer/customerGoodsList.jsp");
        return;
    }
    String id = request.getParameter("id");
    System.out.println("id : " + id);
    
    
    
    String sql = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    sql = "SELECT cus_id FROM customer where cus_id = ?";
    stmt = conn.prepareStatement(sql);
    stmt.setString(1, id);
    rs = stmt.executeQuery();
    
    if(rs.next()){
        String errMsg = URLEncoder.encode("아이디가 중복됩니다.", "UTF-8");
    	response.sendRedirect("/shop/customer/addCustomerForm.jsp?errMsg="+errMsg);
    	conn.close();
    } else {
    	String okMsg = URLEncoder.encode("사용가능한 아이디 입니다.", "UTF-8");
    	response.sendRedirect("/shop/customer/addCustomerForm.jsp?okMsg="+okMsg+"&id="+id);
    	conn.close();
    }
%>