<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.net.*"%>
<%@ page import="shop.dao.*" %>
<!-- Model Layer -->
<%
    System.out.println("=====modifyGoods.jsp===========================================");

    // 인증분기  : 세션변수 이름 - loginEmp
    if(session.getAttribute("loginEmp") == null) {
        response.sendRedirect("/shop/emp/empLoginForm.jsp");
        return;
    }
    
    // goods_no int타입으로 요청
    int goodsNo = Integer.parseInt(request.getParameter("goodsNo"));
    System.out.println("상품번호 넘어온 값 : " + goodsNo);
    
    // 카테고리 리스트 불러오는 메서드
    ArrayList<HashMap<String, Object>> list = EmpDAO.categoryList();
    
    // GoodsDAO에서 goods의 DB 가져오기(where = goodsNo) 인것.
    ArrayList<HashMap<String, Object>> showGoods = GoodsDAO.showGoodsOne(goodsNo);
    System.out.println("showGoods : " + showGoods);
%>
<!-- Controller Layer -->
<%    
    // 전체의 '갯수' 나타내기
    int allCnt = GoodsDAO.goodsListCnt("", "");
    System.out.println("allCount : " + allCnt);  

    // 카테고리 선택 메뉴
    ArrayList<HashMap<String, Object>> categoryList = GoodsDAO.selectCategory(); 
%>
<!-- View Layer -->
<!DOCTYPE html>
<html>
	<head>
	<meta charset="UTF-8">
	<title>상품 수정</title>
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
    
    
    <!-- 상품수정폼 -->
    <div class="container">
        <h1>상품수정</h1>
        <form method="post" action="/shop/emp/modifyGoodsAction.jsp">
            <table class="table table-dark">
                <tr>
                    <th>상품번호</th>
                    <th>카테고리</th>
                    <th>상품이름</th>
                    <th>가격</th>
                    <th>재고</th>
                </tr>
                <%
                    for(HashMap<String, Object> m : showGoods){
                %>
                <tr>
                    <td>
                    <input class="form-control" type="text" name="goodsNo" value="<%=(Integer) (m.get("goodsNo"))%>">
                    </td>
                    <td>
                      <select class="form-control" name="category">
                        <%
                            for(HashMap c : list){
                        %>
                                <option value="<%=(String)(c.get("category"))%>"><%=c%></option>
                        <%       
                            }
                        %>
                        </select>
                    </td>
                    <td>
                        <input class="form-control" type="text" name="goodsTitle" value="<%=(String) (m.get("goodsTitle"))%>">
                    </td>
                    <td>
                        <input class="form-control" type="text" name="goodsPrice" value="<%=(Integer) (m.get("goodsPrice"))%>">
                    </td>
                    <td>
                        <input class="form-control" type="text" name="goodsAmount" value="<%=(Integer) (m.get("goodsAmount"))%>">
                    </td>
                </tr>
                <%
                    }
                %>
                <tr>
                    <th colspan="5">상품설명</th>
                    <th></th>
                    <th></th>
                    <th></th>
                    <th></th>
                </tr>
                <%
                    for(HashMap<String, Object> m : showGoods){
                %>
                <tr>
                    <td colspan="5">
                        <textarea class="form-control" rows="5" cols="50" name="goodsContent"><%=(String) (m.get("goodsContent"))%></textarea>
                    </td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                </tr>
                <%
                    }
                %>
                <tr>
                <td><button class="btn btn-light" type="submit">수정하기</button></td>
                </tr>
            </table>
            
        </form>
        <br> <br>
    </div>
    <jsp:include page="/emp/inc/footer.jsp"></jsp:include>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>    
</body>
</html>