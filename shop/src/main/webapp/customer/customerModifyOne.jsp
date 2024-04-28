<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.net.*"%>
<%@ page import="shop.dao.*" %>
<!-- Model Layer -->
<%
    System.out.println("=====customerModifyOne.jsp=================================");

    // 로그인 인증 분기
    if(session.getAttribute("loginCus") == null){
        String errMsg =  URLEncoder.encode("로그인을 먼저 해주세요.","utf-8");
        response.sendRedirect("/shop/customer/customerLoginForm.jsp?&errMsg="+errMsg);
        return;
    }
    
    // 로그인 정보 호출
    HashMap<String,Object> loginCus 
    = (HashMap<String,Object>)(session.getAttribute("loginCus"));
    
    // 로그인 ID 호출
    String cusId = (String)(loginCus.get("cus_id"));
    System.out.println("현재 로그인 사용자 : " + cusId);
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
	<title>회원정보수정</title>
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
<body class="bg-dark text-white" >
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
                  <jsp:include page="/customer/inc/customerMenu.jsp"></jsp:include>
              </form>
            </div>
          </div>
        </nav>
        <form method="post" action="/shop/customer/customerModifyOneAction.jsp">
        <table>
            <tr>
                <td>아이디</td>
                <td><%=cusId %></td>
            </tr>
            <tr>
                <td>비밀번호</td>
                <td>&nbsp;<input class="form-control" type="password" name="cusPw"></td>
            </tr>
            <tr>
                <td>이름</td>
                <td>&nbsp;<input class="form-control" type="text" name="cusName"></td>
            </tr>
            <tr>
                <td>생일</td>
                <td>&nbsp;<input class="form-control" type="date" name="cusBirth"></td>
            </tr>
            <tr>
                <td>성별</td>
                <td>
                    <input type="radio" name="gender" value="여" checked="checked">여자
                    <input type="radio" name="gender" value="남">남자
                </td>
            </tr>
            <tr>
                <td>주소</td>
                <td>
                    &nbsp;<textarea class="form-control" name="cusAddress" rows="2" cols="50"></textarea>
                </td>
            </tr>
            <tr>
                <td></td>
                <td><button class="btn btn-light" type="submit">수정하기</button></td>
            </tr>
        </table>
       
        </form>
        <br> <br>
    </div>
    <jsp:include page="/customer/inc/footer.jsp"></jsp:include>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>    
</body>
</html>