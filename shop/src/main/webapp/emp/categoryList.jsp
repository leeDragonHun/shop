<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.net.*"%>
<%@ page import="shop.dao.*" %>
<!-- Model Layer -->
<%
    System.out.println("=====categoryList.jsp========================================");
    // 인증분기  : 세션변수 이름 - loginEmp
    if(session.getAttribute("loginEmp") == null) {
        response.sendRedirect("/shop/emp/empLoginForm.jsp");
        return;
    }
    // DB연동
    Connection conn = DBHelper.getConnection();

    // 카테고리 메뉴
    ArrayList<HashMap<String, Object>> list = EmpDAO.categoryList();
%>
<!-- Controller Layer -->
<%
    // 카테고리 선택 메뉴(네비게이션 바 용도)
    ArrayList<HashMap<String, Object>> categoryList = GoodsDAO.selectCategory(); 
    
    // 전체의 '갯수' 나타내기
    int allCnt = GoodsDAO.goodsListCnt("", "");
    System.out.println("allCount : " + allCnt);
%>
<!-- View Layer -->
<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
	<meta charset="UTF-8">
	<title>카테고리 관리</title>
    <link rel="shortcut icon" href="/shop/mindMap/d.ico" type="image/x-icon">
    <link rel="icon" href="/shop/mindMap/d.ico" type="image/x-icon">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link href="/shop/style/style.css" rel="stylesheet" type="text/css">
</head>
<style>
  .navbar-nav .nav-link,
  .navbar-toggler-icon {
    color: white; /* 텍스트 색상을 흰색으로 지정 */
  }
</style>
<body class="bg-dark text-white">
    <!-- 메인메뉴 -->
    <div class="container">
       <nav class="navbar navbar-expand-lg bg-dark">
          <div class="container-fluid">
            <a class="navbar-brand" href="/shop/emp/goodsList.jsp?">
                <img src="/shop/mindMap/d.ico" alt="poterMore" width="30" height="24">
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
              <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarSupportedContent">
              <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                  <a class="nav-link active text-white" aria-current="page" href="/shop/emp/goodsList.jsp">Poter More</a>
                </li>
                <li class="nav-item">
                  <a class="nav-link" href="/shop/emp/goodsList.jsp">
                    All (<%=allCnt %>)
                  </a>
                </li>
                    <%
                        for(HashMap m : categoryList) {
                    %>
                            <li class="nav-item">
                                <a class="nav-link"  href="/shop/emp/goodsList.jsp?category=<%=(String)(m.get("category"))%>">
                                    <%=(String)(m.get("category"))%>  (<%=(Integer)(m.get("cnt"))%>)
                                </a>
                            </li>
                    <%      
                        }
                    %>
              </ul>
              <form class="d-flex text-outline-dark" role="search">
                  <!-- 고객메뉴  -->
                  <jsp:include page="/emp/inc/empMenu.jsp"></jsp:include>
              </form>
            </div>
          </div>
        </nav>
    </div>

    <div class="container">
    <br> <br>
        <!-- 서브메뉴 카테고리별 상품리스트 -->
        <!-- 네비게이션 바 에는 count값과 같이 올라가기 때문에
        카테고리를 만들었어도 상품이 등록되지 않으면 네비게이션 바에는 등록되지 않는다.-->
        <table>
            <tr>
                <td>현재 카테고리 목록&nbsp;&nbsp;</td>
                <td colspan="2">
                <%
                    for(HashMap m : list) {
                %>
                        <a class="btn btn-light" href="/shop/emp/goodsList.jsp?category=<%=(String)(m.get("category"))%>">
                            <%=(String)(m.get("category"))%>
                        </a>
                <%
                    }
                %>
                
                </td>
                <td></td>
            </tr>
            <form method="post" action="addCategoryList.jsp">
                <tr>
                    <td>카테고리 추가&nbsp;&nbsp;</td>
                    <td>
                        <input class="form-control" type="text" name="categoryName">
                    </td>
                    <td>
                        &nbsp;&nbsp;
                    </td>
                    <td>
                        <button class="btn btn-light" type="submit">추가</button>
                    </td>
                </tr>
            </form>
            <form method="post" action="deleteCategoryList.jsp">
                <tr>
                    <td>카테고리 삭제&nbsp;&nbsp;</td>
                    <td>
                        <input class="form-control" type="text" name="categoryName">
                    </td>
                    <td>
                        &nbsp;&nbsp;
                    </td>
                    <td>
                        <button class="btn btn-light" type="submit">삭제</button>
                    </td>
                </tr>
            </form>
        </table>
    <br> <br>
    </div>
    <jsp:include page="/emp/inc/footer.jsp"></jsp:include>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>