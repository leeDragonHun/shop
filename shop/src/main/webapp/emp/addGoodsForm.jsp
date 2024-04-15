<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.net.*"%>
<%@ page import="shop.dao.*" %>
<%
    System.out.println("=====addGoodsForm.jsp===========================================");
    // 인증분기  : 세션변수 이름 - loginEmp
    if(session.getAttribute("loginEmp") == null) {
        response.sendRedirect("/shop/emp/empLoginForm.jsp");
        return;
    }
    // DB연동
    Connection conn = DBHelper.getConnection();
    PreparedStatement stmt1 = null;
    ResultSet rs1 = null;
    
    String sql1 = "select category from category";
    stmt1 = conn.prepareStatement(sql1);
    rs1 = stmt1.executeQuery();
    // 선언
    ArrayList<String> categoryList =
            new ArrayList<String>();
    while(rs1.next()) {
        categoryList.add(rs1.getString("category"));
    }
    // 디버깅
    System.out.println("categoryList : " + categoryList);
    
    HashMap<String, Object> m = (HashMap<String, Object>)(session.getAttribute("loginEmp"));
    String empId = (String)m.get("empId");
    // 디버깅
    System.out.println(empId);
    
    String errMsg = request.getParameter("errMsg");

   
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title></title>
</head>
<body>
    <!-- 메인메뉴 -->
    <div>
        <jsp:include page="/emp/inc/empMenu.jsp"></jsp:include>
    </div>
     <%
     if(errMsg != null){
     %>
         <span><%=errMsg%></span>
     <%
     }
     %>
    
    <h1>상품등록</h1>
    <form method="post" action="/shop/emp/addGoodsAction.jsp"
        enctype="multipart/form-data">
        <div>
            카테고리 : 
            <select name="category">
                <%
                    for(String c : categoryList){
                %>
                        <option value="<%=c%>"><%=c%></option>
                <%       
                    }
                %>
            </select>
        </div>
        <div>
            작성자 : 
            <input type="text" name="empId" readonly="readonly" value="<%=empId %>">
        </div>
        <div>
            제목 : 
            <input type="text" name="goodsTitle">
        </div>
        <div>
            사진 : 
            <input type="file" name="goodsImg">
        </div>
        <div>
            가격 : 
            <input type="text" name="goodsPrice">
        </div>
        <div>
            재고 : 
            <input type="text" name="goodsAmount">
        </div>
        <div>
            내용 : 
            <textarea rows="5" cols="50" name="goodsContent"></textarea>
        </div>
        <button type="submit">상품등록</button>
    </form>

</body>
