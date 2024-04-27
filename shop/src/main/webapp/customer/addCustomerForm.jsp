<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="shop.dao.*" %>
<%
    System.out.println("=====addCustomerForm.jsp===================================");
    
    // 로그인 인증 분기
    if(session.getAttribute("loginCus")  != null) {
        response.sendRedirect("/shop/customer/customerGoodsList.jsp");
        return;
    }
    String id = null;

    // id요청
    id = request.getParameter("id");
    System.out.println("id : " + id);
    
    // 메시지 호출
    String errMsg = request.getParameter("errMsg");
    String msg = request.getParameter("msg");
    System.out.println("msg : " + msg); 
    
    // 카테고리 선택 메뉴
    ArrayList<HashMap<String, Object>> categoryList = GoodsDAO.selectCategory(); 
    System.out.println("categoryList : " + categoryList); 
    
    // 전체의 '갯수' 나타내기
    int allCnt = GoodsDAO.goodsListCnt("", "");
    System.out.println("allCount : " + allCnt); 
 %>
<!DOCTYPE html>
<html>
	<head>
	<meta charset="UTF-8">
	<title>회원가입</title>
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
    <table>
        <form method="post" action="/shop/customer/checkedIdAction.jsp">
            <tr>
                <td>아이디</td>
                <td><input class="form-control" type="text" name="id" placeholder="영문, 숫자만 입력하세요"  
                        <%
                            if(id != null){
                        %>
                                value="<%=id %>"
                        <%
                            }
                        %>
                    ></td>
                <td>
                    <button class="btn btn-light" type="submit">중복조회</button>
                    <%if(errMsg != null){%><%=errMsg %><%} %>
                    <%if(msg != null){%><%=msg %><%} %>
                </td>
            </tr>
        </form>
        
        <form method="post" action="/shop/customer/addCustomerAction.jsp">
            <input type="hidden" name="id"  
                <%
                    if(id != null){
                %>
                        value="<%=id %>"
                <%
                    }
                %>
            >
            <tr>
                <td>암호</td>
                <td><input class="form-control" type="password" name="pw" 
                    <%
                        if(errMsg != null){
                    %>
                            disabled
                    <%
                        }
                    %>
                ></td>
            </tr>
            <tr>
                <td>이름</td>
                <td><input class="form-control" type="text" name="name"
                    <%
                        if(errMsg != null){
                    %>
                            disabled
                    <%
                        }
                    %>                
                ></td>
            </tr>
            <tr>
                <td>생일</td>
                <td><input class="form-control" type="date" name="birth"                     
                    <%
                        if(errMsg != null){
                    %>
                            disabled
                    <%
                        }
                    %> ></td>
            </tr>
            <tr>
                <td>성별</td>
                <td>
                    <input type="radio" name="gender" value="남" checked 
                        <%
                            if(errMsg != null){
                        %>
                                disabled
                        <%
                            }
                        %>                     
                    >남 
                    <input type="radio" name="gender" value="여"                     
                        <%
                            if(errMsg != null){
                        %>
                                disabled
                        <%
                            }
                        %>
                    >여
                </td>
                <td></td>
            </tr>
            <tr>
                <td></td>
                <td>
                    <%
                        if(msg != null){
                    %>
                        <button class="btn btn-light" type="submit">회원가입</button>
                    <%
                        }
                    %>
                </td>
            </tr>
    </table>
    </form>
    <br>
    <jsp:include page="/customer/inc/footer.jsp"></jsp:include>
    </div>  
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>