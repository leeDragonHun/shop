<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="shop.dao.GoodsDAO"%>
<%@ page import="java.net.*"%>
<%@ page import="java.util.*"%>
<!-- Model Layer -->
<%    
    System.out.println("=====orderList.jsp==========================================");
    // 로그인 인증 분기
    if(session.getAttribute("loginEmp") == null) {
    	String errMsg =  URLEncoder.encode("로그인을 먼저 해주세요.","utf-8");
        response.sendRedirect("/shop/emp/empLoginForm.jsp?&errMsg="+errMsg);
        return;
    }
    
    // 에러메시지 받기.
    String derrMsg = request.getParameter("derrMsg");
    
    // 결제 완료된 orders 데이터 출력
    ArrayList<HashMap<String, Object>> allCompletePayment = GoodsDAO.allCompletePayment();
    
    // 배송 완료된 orders 데이터 출력
    ArrayList<HashMap<String, Object>> allCompleteDelivery = GoodsDAO.allCompleteDelivery();
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
	<title>주문목록관리</title>
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
        <%
            if(derrMsg != null){
        %>
                <%=derrMsg %>
        <%
            }
        %>
        <h1>주문내역</h1>
            <table class="table table-dark">
            <h3>결제완료</h3>
                <tr>
                    <th>주문번호</th>
                    <th>상품이름</th>
                    <th>주문자ID</th>
                    <th>상품번호</th>
                    <th>주문갯수</th>
                    <th>주문상태</th>
                    <th>배송하기</th>
                    <th>바로가기</th>
                </tr>
            <%
                for(HashMap<String, Object> m : allCompletePayment){
            %>
                <tr>
                    <td><%=m.get("ordersNo") %></td>
                    <td><%=m.get("goodsTitle") %></td>
                    <td><%=m.get("cusId") %></td>
                    <td><%=m.get("goodsNo") %></td>
                    <td><%=m.get("ea") %></td>
                    <td><%=m.get("state") %></td>
                    <td><a class="btn btn-light" href="/shop/emp/startDelivery.jsp?ordersNo=<%=m.get("ordersNo")%>">배송처리</a></td>
                    <td><a class="btn btn-light" href="/shop/emp/empGoodsOne.jsp?goodsNo=<%=m.get("goodsNo") %>">이동</a></td>
                </tr>
            <%
                }
            %>
            </table>
        
            <table class="table table-dark">
            <h3>배송완료</h3>
                <tr>
                    <th>주문번호</th>
                    <th>상품이름</th>
                    <th>주문자ID</th>
                    <th>상품번호</th>
                    <th>주문갯수</th>
                    <th>주문상태</th>
                    <th>바로가기</th>
                </tr>
            <%
                for(HashMap<String, Object> m : allCompleteDelivery){
            %>
                <tr>
                    <td><%=m.get("ordersNo") %></td>
                    <td><%=m.get("goodsTitle") %></td>
                    <td><%=m.get("cusId") %></td>
                    <td><%=m.get("goodsNo") %></td>
                    <td><%=m.get("ea") %></td>
                    <td><%=m.get("state") %></td>
                    <td><a class="btn btn-light" href="/shop/emp/empGoodsOne.jsp?goodsNo=<%=m.get("goodsNo") %>">이동</a></td>
                </tr>
            <%
                }
            %>
            </table>
        <br> <br>
    </div>
    <jsp:include page="/emp/inc/footer.jsp"></jsp:include>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>