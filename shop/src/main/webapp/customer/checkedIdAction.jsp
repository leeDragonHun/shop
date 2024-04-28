<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="shop.dao.*" %>
<%@ page import="java.net.*"%>
<%
    System.out.println("=====checkedIdAction.jsp====================================");
    
    //로그인 인증분기
    if(session.getAttribute("loginCus")  != null) {
        response.sendRedirect("/shop/customer/customerGoodsList.jsp");
        return;
    }
    
    // id 값 호출 후 디버깅
    String id = request.getParameter("id");
    System.out.println("id : " + id);
    
    // DB 연결
    Connection conn = DBHelper.getConnection();
    
    // 전부 DAO로 뺐지만 jsp에서 하는 방법도 연습용
    // 아이디 중복확인 쿼리
    String sql = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    sql = "SELECT cus_id FROM customer where cus_id = ?";
    stmt = conn.prepareStatement(sql);
    stmt.setString(1, id);
    rs = stmt.executeQuery();
    
    // 중복환인 결과 분기문
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