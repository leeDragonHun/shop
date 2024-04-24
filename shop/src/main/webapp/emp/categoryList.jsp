<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.net.*"%>
<%@ page import="shop.dao.*" %>
<!-- Controller Layer -->
<%
    System.out.println("=====categoryList.jsp========================================");
    // 인증분기  : 세션변수 이름 - loginEmp
    if(session.getAttribute("loginEmp") == null) {
        response.sendRedirect("/shop/emp/empLoginForm.jsp");
        return;
    }
    // DB연동
    Connection conn = DBHelper.getConnection();
%>
<!-- Model Layer -->
<%
    // 카테고리 선택 메뉴
    ArrayList<HashMap<String, Object>> list = EmpDAO.categoryList();
    
%>
<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
	<meta charset="UTF-8">
	<title>카테고리 관리</title>
    <link rel="shortcut icon" href="/shop/mindMap/d.ico" type="image/x-icon">
    <link rel="icon" href="/shop/mindMap/d.ico" type="image/x-icon">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link href="/shop/style.css" rel="stylesheet" type="text/css">    
</head>
<body>

    <!-- 메인메뉴 -->
    <div>
        <jsp:include page="/emp/inc/empMenu.jsp"></jsp:include>
    </div>
    
    <!-- 서브메뉴 카테고리별 상품리스트 -->
    <div>
        <%
            for(HashMap m : list) {
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
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>