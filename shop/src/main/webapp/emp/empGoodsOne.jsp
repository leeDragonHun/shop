<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.net.*"%>
<%@ page import="shop.dao.*" %>
<%
    System.out.println("=====empGoodsOne.jsp===========================================");
    
    // 로그인 인증 분기
    if(session.getAttribute("loginEmp") == null) {
    	response.sendRedirect("/shop/emp/empLoginForm.jsp");
    	return;
    }
    
    // customerGoodsList.jsp 에서 <a href>태그를 통해 get방식으로 goodsNo가 요청됨
    int goodsNo = Integer.parseInt(request.getParameter("goodsNo"));
    System.out.println("상품번호 : " + goodsNo);
    
    // GoodsDAO에서 goods의 DB 가져오기(where = goodsNo) 인것.
    ArrayList<HashMap<String, Object>> showGoods = GoodsDAO.showGoodsOne(goodsNo);
    System.out.println("showGoods : " + showGoods);
    
    // 해당 상품의 리뷰 목록 메서드
    ArrayList<HashMap<String, Object>> goodsOneReview = GoodsDAO.goodsOneReview(goodsNo);
    System.out.println("goodsOneReview : " + goodsOneReview);
    
    // 카테고리 선택 메뉴
    ArrayList<HashMap<String, Object>> categoryList = GoodsDAO.selectCategory(); 
    
    // 전체의 '갯수' 나타내기
    int allCnt = GoodsDAO.goodsListCnt("", "");
    System.out.println("allCount : " + allCnt); 
%>
<!DOCTYPE html>
<html>
	<head>
	<meta charset="UTF-8">
	<title></title>
    <link rel="shortcut icon" href="/shop/mindMap/d.ico" type="image/x-icon">
    <link rel="icon" href="/shop/mindMap/d.ico" type="image/x-icon">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link href="/shop/style.css" rel="stylesheet" type="text/css">
</head>
<style>
  .navbar-nav .nav-link,
  .navbar-toggler-icon {
    color: white; /* 텍스트 색상을 흰색으로 지정 */
  }
</style>
<body class="bg-dark text-white" >
    <div class="container">
    <!-- 메인메뉴 -->
       <nav class="navbar navbar-expand-lg bg-dark">
          <div class="container-fluid">
            <a class="navbar-brand" href="/shop/emp/goodsList.jsp?category=all&">
                <img src="/shop/mindMap/d.ico" alt="poterMore" width="30" height="24">
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
              <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarSupportedContent">
              <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                  <a class="nav-link active text-white" aria-current="page" href="/shop/emp/goodsList.jsp?category=all>">Poter More</a>
                </li>
                <li class="nav-item">
                  <a class="nav-link" href="/shop/emp/goodsList.jsp?category=all">
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
    <!-- 상품상세정보 -->
        <table class="table table-dark table-borderless">
        <%
            for(HashMap<String, Object> m : showGoods){
        %>
        <tr>
            <td rowspan="5"><img style="width:70%; height:auto;" alt="상품사진" src="/shop/upload/<%=(String)(m.get("filename")) %>" style="width:100%; height:100%;"></td>
            <td colspan="3"><h2><%=(String) (m.get("goodsTitle"))%></h2></td>
            <td></td>
            <td></td>
        </tr>
        
        <tr>
            <td></td>
            <td><h3>판매가</h3></td>
            <td><%=(Integer) (m.get("goodsPrice"))%></td>
            <td></td>
        </tr>
        
        <tr>
            <td></td>
            <td><h3>재고</h3></td>
            <td><%=(Integer) (m.get("goodsAmount")) %></td>
            <td></td>
        </tr>
        
        <tr>
            <td></td>
            <td><h3>주문수량</h3></td>
        <%
            }
        %>
            <td>
                <form method="post" action="/shop/customer/orderAction.jsp">
                    <input type="hidden" name="goodsNo" value="<%=goodsNo %>">
                    <%
                    for(HashMap<String, Object> m : showGoods){
                        if((Integer)(m.get("goodsAmount")) > 0){
                    %>
                    <input type="hidden" name="goodsAmount" value="<%=(Integer) (m.get("goodsAmount")) %>">
                    <input type="hidden" name="goodsTitle" value="<%=(String) (m.get("goodsTitle")) %>">
                    <select name="ea" class="form-select" aria-label="Default select example">
                    <%
                        for(int ea = 1; ea <= (Integer) (m.get("goodsAmount")); ea++){
                            int sum = (((Integer) (m.get("goodsPrice")))*ea);
                    %>
                             <option value="<%=ea%>"><%=ea%>개 : <%=sum %> 원</option>`
                    <%
                            }
                    %>
                    </select>
                    </td>
                    
                    <td>
                    <button type="submit" class="btn btn-light" disabled="disabled">구매하기</button>
                    <%        
                        }else{
                    %>
                    <button type="submit" disabled="disabled">품절</button>
                    <%        
                        }
                    }
                    %>
                </form>
            </td>
        </tr>
            <td></td>
            <td>
                <a class="btn btn-light" href="/shop/emp/modifyGoods.jsp?goodsNo=<%=goodsNo %>">수정</a>&nbsp;&nbsp;
                <a class="btn btn-light" href="/shop/emp/deleteGoods.jsp?goodsNo=<%=goodsNo %>">삭제</a>
            </td>
            <td></td>
            <td></td>
        <tr>
    </table>
    
    <hr>
    <h1>상품설명</h1>
    <table>
        <tr>
            <td colspan="3">
                <%
                    for(HashMap<String, Object> m : showGoods){
                %>
                        <%=(String) (m.get("goodsContent"))%></td>
                <%
                    }
                %>
            
            </td>
            <td>
            </td>
            <td></td>
        </tr>
    </table>
    <hr>

        <h1>리뷰</h1>
    <table class="table table-dark table-borderless">
        <tr>
            <th>작성자</th>
            <th>주문갯수</th>
            <th>내용</th>
            <th>별점</th>
        </tr>
        <%
            for(HashMap<String, Object> m : goodsOneReview){
        %>
        <tr>
            <td><%=(String) (m.get("cusId"))%></td>
            <td><%=(Integer) (m.get("ea"))%></td>
            <td><%=(String) (m.get("content"))%></td>
            <td>
        <%
            if( (Integer)(m.get("rating")) == 5){
        %>
                &#127775;&#127775;&#127775;&#127775;&#127775;
        <%
            }else if( (Integer)(m.get("rating")) == 4){
        %>
                &#127775;&#127775;&#127775;&#127775;
        <%
            }else if( (Integer)(m.get("rating")) == 3){
        %>
                &#127775;&#127775;&#127775;
        <%
            }else if( (Integer)(m.get("rating")) == 2){
        %>
                &#127775;&#127775;
        <%
            }else if( (Integer)(m.get("rating")) == 1){
        %>
                &#127775;
        <%
            }else if( (Integer)(m.get("rating")) == 0){
        %>
                &nbsp;
        <%
            }
        %>
            </td>
        </tr>
        <%
            }
        %>
    </table>
    </div>
    <jsp:include page="/emp/inc/footer.jsp"></jsp:include>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>    
</body>
</html>