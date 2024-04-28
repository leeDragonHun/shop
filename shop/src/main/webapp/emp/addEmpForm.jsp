<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.*" %>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="shop.dao.*" %>
<!-- Model Layer -->
<%
    System.out.println("=====addEmpForm.jsp===================================");
   
    // 로그인 되어있으면(세션값 있으면) List로 가기
    if(session.getAttribute("loginEmp") != null){ 
        response.sendRedirect("/shop/emp/empList.jsp"); 
        return; // 종료
    }
    
    // id 변수 선언
    String id = null;

    // id 값 가져오기(중복체크페이지로 부터(checkedIdAction.jsp))
    id = request.getParameter("id");
    
    // id 값 디버깅
    System.out.println("id : " + id);
    
    // 메시지 변수들 선언(실패시, 성공시)
    String errMsg = request.getParameter("errMsg");
    String okMsg = request.getParameter("okMsg");
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
	<title>회원가입</title>
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
    <!-- 메인메뉴 -->
       <nav class="navbar navbar-expand-lg bg-dark">
          <div class="container-fluid">
            <a class="navbar-brand" href="/shop/emp/goodsList.jsp">
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
            </div>
          </div>
        </nav>
    </div>

    <!-- 아이디 중복확인 폼 -->
    <!-- 중복확인 후 확인된 id값을 아래 회원가입 폼으로 넘긴다 -->
    <div class="container">    
        <table>
            <%
                if(id == null){
            %>
                    <form method="post" action="/shop/emp/checkedIdAction.jsp">
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
                                <%if(okMsg != null){%><%=okMsg %><%} %>
                            </td>
                        </tr>
                    </form>
            <%
                }
            %>
            
            <!-- 회원 가입 폼 -->
            <form method="post" action="/shop/emp/addEmpAction.jsp">
                <h1>직원 회원가입</h1>
                <%
                    if(id != null){
                %>
                    <tr>
                        <td>아이디</td>
                        <td>
                            <input class="form-control" type="text" name="id" 
                                <%
                                    if(id != null){
                                %>
                                        value="<%=id %>"
                                <%
                                    }
                                %>
                             readonly="readonly">
                        </td>
                        <td>
                            <%
                                if(okMsg != null){
                            %>
                                    <%=okMsg %>
                            <%
                                }
                            %>
                        </td>
                    </tr>
                <%
                    }
                %>
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
                    <td></td>
                    <td>
                        <%
                            if(okMsg != null){
                        %>
                            <button class="btn btn-light" type="submit">회원가입</button>
                        <%
                            }
                        %>
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