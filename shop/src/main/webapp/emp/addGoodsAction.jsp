<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.net.*"%>
<!-- Controller Layer -->
<%
    System.out.println("=====addGoodsAction.jsp=====================================");

    request.setCharacterEncoding("UTF-8");
    // 인증분기  : 세션변수 이름 - loginEmp
    if(session.getAttribute("loginEmp") == null) {
        response.sendRedirect("/shop/emp/empLoginForm.jsp");
        return;
    }
%>  
<!-- Model Layer -->
<%
    String category = request.getParameter("category");
    String empId = request.getParameter("empId");
    String moneyTitle = request.getParameter("moneyTitle");
    int moneyPrice = Integer.parseInt(request.getParameter("moneyPrice"));
    int moneyAmount = Integer.parseInt(request.getParameter("moneyAmount"));
    String moneyContent = request.getParameter("moneyContent");

    System.out.println("category : " + category); 
    System.out.println("empId : " + empId); 
    System.out.println("moneyTitle : " + moneyTitle); 
    System.out.println("moneyPrice : " + moneyPrice); 
    System.out.println("moneyAmount : " + moneyAmount); 
    System.out.println("moneyContent : " + moneyContent); 
    
    Class.forName("org.mariadb.jdbc.Driver");
    String sql = "insert into goods(category, emp_id, money_title, money_content, money_price, money_amount, update_date, create_date) values(?,?,?,?,?,?, now(), now())";
    Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/shop", "root", "java1234");
    PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1,category);
	stmt.setString(2,empId);
	stmt.setString(3,moneyTitle);
	stmt.setString(4,moneyContent);
	stmt.setInt(5, moneyPrice);
	stmt.setInt(6, moneyAmount);
    
    System.out.println("stmt확인 : " + stmt);
    
    int row = stmt.executeUpdate();
    
    
%>

<!-- Controller Layer -->
<%
    if(row == 1){
        response.sendRedirect("/shop/emp/goodsList.jsp");
    } else {
    	String errMsg = URLEncoder.encode("작성에 실패했습니다. 확인 후 다시 입력하세요.", "utf-8");
    	response.sendRedirect("/shop/emp/addGoodsForm.jsp?errMsg=" + errMsg);
        return;
    }
%>