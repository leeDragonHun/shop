<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.net.*"%>
<!-- Controller Layer -->
<%
    System.out.println("=====categoryList.jsp========================================");
    // 인증분기  : 세션변수 이름 - loginEmp
    if(session.getAttribute("loginEmp") == null) {
        response.sendRedirect("/shop/emp/empLoginForm.jsp");
        return;
    }
    // DB연동
    Class.forName("org.mariadb.jdbc.Driver");
    Connection conn = null;
    conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/shop", "root", "java1234");
%>
<!-- Model Layer -->
<%
    // 카테고리 선택 메뉴
    PreparedStatement stmt1 = null;
    ResultSet rs1 = null;
    String sql1 = "select category from category order by create_date asc";
    stmt1 = conn.prepareStatement(sql1);
    rs1 = stmt1.executeQuery();
    ArrayList<HashMap<String, Object>> categoryList =
            new ArrayList<HashMap<String, Object>>();
    while(rs1.next()) {
        HashMap<String, Object> m = new HashMap<String, Object>();
        m.put("category", rs1.getString("category"));
        categoryList.add(m);
    }
    System.out.println("categoryList : " + categoryList);
    
%>
<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
	<meta charset="UTF-8">
	<title>카테고리 관리</title>
</head>
<body>

    <!-- 메인메뉴 -->
    <div>
        <jsp:include page="/emp/inc/empMenu.jsp"></jsp:include>
    </div>
    
    <!-- 서브메뉴 카테고리별 상품리스트 -->
    <div>
        <%
            for(HashMap m : categoryList) {
        %>
                <a href="/shop/emp/goodsList.jsp?category=<%=(String)(m.get("category"))%>">
                    <%=(String)(m.get("category"))%>
                </a>    
        <%      
            }
        %>
    </div>
    <div>
        <form method="post" action="addCategoryList.jsp">
            카테고리 추가 : 
            <input type="text" name="categoryName" placeholder="추가할 이름을 입력하세요">
            <button type="submit">추가</button>
        </form>
        <form method="post" action="deleteCategoryList.jsp">
            카테고리 삭제 : 
            <input type="text" name="categoryName" placeholder="삭제할 이름을 입력하세요">
            <button type="submit">삭제</button>
        </form>
    </div>
</body>
</html>