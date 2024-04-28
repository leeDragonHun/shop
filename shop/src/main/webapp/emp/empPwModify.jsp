<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@page import="shop.dao.*"%>
<!-- Model Layer -->
<%
    System.out.println("=====empPwModify.jsp============================");

    // 로그인 인증 분기
    if(session.getAttribute("loginEmp") == null) {
        String errMsg =  URLEncoder.encode("로그인을 먼저 해주세요.","utf-8");
        response.sendRedirect("/shop/emp/empLoginForm.jsp?&errMsg="+errMsg);
        return;
    }

    // 로그인 정보 호출
    HashMap<String, Object> loginEmp 
    = (HashMap<String, Object>)(session.getAttribute("loginEmp"));
    System.out.println(loginEmp);
    
    // 로그인 ID 호출
    String empId = (String)(loginEmp.get("empId"));
    System.out.println("현재 로그인 사용자 : " + empId);
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
	<title>직원 비밀번호 수정</title>
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
                        for(HashMap z : categoryList) {
                    %>
                            <li class="nav-item">
                                <a class="nav-link"  href="/shop/customer/customerGoodsList.jsp">
                                    <%=(String)(z.get("category"))%>  (<%=(Integer)(z.get("cnt"))%>)
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
        
        <br>
        
        <form method="post" action="/shop/emp/empPwModifyAction.jsp">
            <input type="hidden" name="empId" value="<%=empId %>">
            <table class="table table-dark">
                <tr>
                    <td>수정할 비밀번호</td>
                </tr>
                <tr>
                    <td><input class="form-control" type="password" name="empPw" style="width:200px"></td>
                </tr>
                <tr>
                    <td><button class="btn btn-light" type="submit">수정</button></td>
                </tr>
            </table>
        </form>
        <br> <br>
    </div>
    <jsp:include page="/customer/inc/footer.jsp"></jsp:include> 
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>    
</body>
</html>