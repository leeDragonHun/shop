<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="shop.dao.*" %>
<!-- Model Layer -->
<%
    System.out.println("=====customerLoginForm.jsp==================================");

    //로그인 인증분기
    if(session.getAttribute("loginCus") != null) {
        response.sendRedirect("/shop/customer/customerGoodsList.jsp");
        return;
    }
    //메시지 호출
    String errMsg = request.getParameter("errMsg");
%>
<!-- Controller Layer -->
<%
    // 카테고리 선택 메뉴
    ArrayList<HashMap<String, Object>> categoryList = GoodsDAO.selectCategory(); 
    System.out.println("categoryList : " + categoryList); 
    
    // 전체의 '갯수' 나타내기
    int allCnt = GoodsDAO.goodsListCnt("", "");
    System.out.println("allCount : " + allCnt); 
%>
<!-- View Layer -->
<!DOCTYPE html>
<html>
	<head>
	<meta charset="UTF-8">
	<title>회원 로그인</title>
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
    <div class="container">
    <!-- 네비게이션 바-->
        <nav class="navbar navbar-expand-lg bg-dark">
          <div class="container-fluid">
            <a class="navbar-brand" href="/shop/customer/customerGoodsList.jsp?">
                <img src="/shop/mindMap/d.ico" alt="poterMore" width="30" height="24">
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
              <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarSupportedContent">
              <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                  <a class="nav-link active text-white" aria-current="page" href="/shop/customer/customerGoodsList.jsp?">Poter More</a>
                </li>
                <li class="nav-item">
                  <a class="nav-link" href="/shop/customer/customerGoodsList.jsp?">
                    All (<%=allCnt %>)
                  </a>
                </li>
                    <%
                        for(HashMap m : categoryList) {
                    %>
                            <li class="nav-item">
                                <a class="nav-link"  href="/shop/customer/customerGoodsList.jsp">
                                    <%=(String)(m.get("category"))%>  (<%=(Integer)(m.get("cnt"))%>)
                                </a>
                            </li>
                    <%      
                        }
                    %>
              </ul>
              <form class="d-flex text-outline-dark" role="search">
                  <!-- 고객메뉴  -->
                  <%-- <jsp:include page="/customer/inc/customerMenu.jsp"></jsp:include> --%>
              </form>
            </div>
          </div>
        </nav>
        
        <form method="post" action="/shop/customer/customerLoginAction.jsp">
            <table>
                <h1>Poter More 회원 로그인</h1>
                <br>
                <%
                    if(errMsg != null){
                %>
                        <%=errMsg %>
                <%
                    }
                %>
                <tr>
                    <td>아이디</td>
                    <td><input class="form-control" type="text" name="cusId" value="lyh"></td>
                </tr>
                <tr>
                    <td>비밀번호</td>
                    <td><input class="form-control" type="password" name="cusPw" value="1234"></td>
                </tr>
                <tr>
                    <td></td>
                    <td>
                        <button class="btn btn-light" type="submit">로그인</button>
                        <a class="btn btn-light" href="/shop/customer/addCustomerForm.jsp">회원가입</a>
                        <a class="btn btn-light" href="/shop/emp/empLoginForm.jsp">직원 로그인</a>
                    </td>
                </tr>
            </table>
        </form>
        <br> <br>
    </div>    
    <jsp:include page="/customer/inc/footer.jsp"></jsp:include>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>    
</body>
</html>