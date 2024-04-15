<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="shop.dao.*" %>
<%
    System.out.println("=====addCustomerAction.jsp====================================");
    if(session.getAttribute("loginCus")  != null) {
        response.sendRedirect("/shop/customer/customerGoodsList.jsp");
        return;
    }

    request.setCharacterEncoding("UTF-8");
    
    String id = request.getParameter("id");
    String pw = request.getParameter("pw");
    String name = request.getParameter("name");
    String birth = request.getParameter("birth");
    String gender = request.getParameter("gender");
    
    System.out.println("id : " + id);
    System.out.println("pw : " + pw);
    System.out.println("name : " + name);
    System.out.println("birth : " + birth);
    System.out.println("gender : " + gender);
    
    Connection conn = DBHelper.getConnection();
    String sql = "INSERT INTO customer(cus_id, cus_pw, cus_name, birth, gender, update_date, create_date) VALUES(?, password(?), ?, ?, ?, NOW(), NOW())";
    PreparedStatement stmt = conn.prepareStatement(sql);
    
    stmt.setString(1,id);
    stmt.setString(2,pw);
    stmt.setString(3,name);
    stmt.setString(4,birth);
    stmt.setString(5,gender);
    System.out.println("stmt확인 : " + stmt);
    
    int row = stmt.executeUpdate();
    
    if(row >= 1){
        System.out.println("회원가입 완료");
        response.sendRedirect("/shop/customer/customerLoginForm.jsp");
    } else {
        System.out.println("회원가입 실패");
        response.sendRedirect("/shop/customer/addCustomerForm.jsp");
    }
    
    conn.close();
%>