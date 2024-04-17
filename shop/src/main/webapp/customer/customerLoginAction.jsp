<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "java.util.*" %>
<%@ page import="shop.dao.*" %>
<%
    System.out.println("=====customerLoginAction.jsp=====================================");
    if(session.getAttribute("loginCus") != null) {
        response.sendRedirect("/shop/customer/customerGoodsList.jsp");
        return;
    }

    // id, pw 값 요청
    String cusId = null;
    String cusPw = null;
    cusId = request.getParameter("cusId");
    cusPw = request.getParameter("cusPw");
    System.out.println("cusId요청값 : " + cusId);
    System.out.println("cusPw요청값 : " + cusPw);
    
    
    HashMap<String, Object> loginCus = CustomerDAO.loginCus(cusId, cusPw);
    
    // 성공시 customerGoodsList.jsp로 실패시 다시 customerLoginForm 으로
    if(loginCus != null){
    	System.out.println("로그인 성공");
        
		session.setAttribute("loginCus", loginCus);
        
		HashMap<String, Object> m = (HashMap<String, Object>)(session.getAttribute("loginCus"));
		System.out.println((String)(m.get("cus_id"))); // 로그인 된 cusId
		System.out.println((String)(m.get("cus_name"))); // 로그인 된 cusName

		response.sendRedirect("/shop/customer/customerGoodsList.jsp");
    }else{
        System.out.println("로그인 실패");
        String errMsg = URLEncoder.encode("로그인 실패. 아이디와 비밀번호를 확인하세요.", "UTF-8");
        response.sendRedirect("/shop/customer/customerLoginForm.jsp?errMsg="+errMsg);
    }
    
    
    
    // id, pw가 db와 일치하는 지 확인
    /* String sql = "SELECT cus_id cusId, cus_pw cusPw FROM customer WHERE cus_id = ? AND cus_pw = PASSWORD(?)";
    Connection conn = DBHelper.getConnection();
    PreparedStatement stmt = conn.prepareStatement(sql);
    stmt.setString(1,id);
    stmt.setString(2,pw);
    System.out.println("stmt : " + stmt);
    ResultSet rs = stmt.executeQuery(); */
    
    // 요청한 id, pw 값을 customer db에 where로 조회해서 있으면 로그인 되게, 없으면 로그인 안 되게
    /* if(rs.next()){
        System.out.println("로그인 성공");
        HashMap<String,Object> loginCus = new HashMap<String, Object>();
        loginCus.put("cusId", rs.getString("cusId"));
        loginCus.put("cusPw", rs.getString("cusPw"));
        
        session.setAttribute("loginCus", loginCus);
        
        HashMap<String, Object> m = (HashMap<String, Object>)(session.getAttribute("loginCus"));
		System.out.println("로그인 한 id : " + (String)(m.get("cusId"))); // 로그인 된 Id
		System.out.println("로그인 한 pw : " + (String)(m.get("cusPw"))); // 로그인 된 Name
        
		response.sendRedirect("/shop/customer/customerGoodsList.jsp");
    }else{
        System.out.println("로그인 실패");
        String errMsg = URLEncoder.encode("로그인 실패. 아이디와 비밀번호를 확인하세요.", "UTF-8");
        response.sendRedirect("/shop/customer/customerLoginForm.jsp?errMsg="+errMsg);
    } */
%>