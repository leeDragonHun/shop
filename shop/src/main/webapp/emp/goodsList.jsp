<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="shop.dao.*" %>
<!-- Controller Layer -->
<%
    System.out.println("=====goodsList.jsp==========================================");
    // 로그인 인증우회
    if(session.getAttribute("loginEmp") == null) {
    	response.sendRedirect("/shop/emp/empLoginForm.jsp");
    	return;
    }
    
    // DB연동
    Connection conn = DBHelper.getConnection();
    
    // category 값 요청
    String category = request.getParameter("category");
    System.out.println("category : " + category);
    if(category == null){
        response.sendRedirect("/shop/emp/goodsList.jsp?category=all");
        return;
    }
    
    // order 값 요청
    String order = request.getParameter("order");
    System.out.println("order : " + order);
    
    // searchWord 값 요청
    String searchWord = "";
    if(request.getParameter("searchWord") != null) {
        searchWord = request.getParameter("searchWord");
    }
    System.out.println("searchWord : " + searchWord);
    
    // 현재페이지 설정. 페이지 값 받아오기
    int currentPage = 1;
    if (request.getParameter("currentPage") != null) {
        currentPage = Integer.parseInt(request.getParameter("currentPage"));
    }
%>
<!-- Controller Layer -->
<%
    // 전체의 '갯수' 나타내기
    int allCnt = GoodsDAO.goodsListCnt("", "");
    System.out.println("allCount : " + allCnt);  

    // 카테고리 선택 메뉴
    ArrayList<HashMap<String, Object>> categoryList = GoodsDAO.selectCategory(); 
%>
  <!-- Model Layer -->
<%
        
    // 페이징-------------------------------------------------------------------------------------
    int rowPerPage = 15;
    if(request.getParameter("rowPerPage") != null) {
        rowPerPage = Integer.parseInt(request.getParameter("rowPerPage"));
    }
    System.out.println("rowPerPage : " + rowPerPage);
    int startRow = ((currentPage-1)*rowPerPage);
    
    // 전체줄 수(게시글) = 일단 0으로 선언하고. totalRowSql에 count(*)로 몇개인지에 따라 값이 정해짐
    int totalRow = GoodsDAO.goodsListCnt(category, searchWord);

    System.out.println("totalRow : " + totalRow);
    
    // 마지막 페이지는 전체줄수/한페이지에올줄수 예를들어 51페이지면 10으로 나누면 5가된다. 근데 한페이지에 10개씩 오려면 6페이지가 필요하니까 더하기 1을해준다. 그게 lastpage다
    int lastPage = totalRow / rowPerPage;
    if(totalRow%rowPerPage != 0) {
        lastPage = lastPage + 1;
    }
    System.out.println("lastPage : " + lastPage);
    // ---------------------------------------------------------------------------------------------


    // 조건에 맞는 굿즈리스트
    ArrayList<HashMap<String, Object>> goodsList = GoodsDAO.selectGoodsList(category, searchWord, order, startRow, rowPerPage);
    System.out.println("goodsList : " + goodsList); 
%>
<!-- View Layer -->
<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta charset="UTF-8">
    <title>상품관리</title>
    <link rel="shortcut icon" href="/shop/mindMap/d.ico" type="image/x-icon">
    <link rel="icon" href="/shop/mindMap/d.ico" type="image/x-icon"> 
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link href="/shop/style/style.css" rel="stylesheet" type="text/css">
</head>
<style>
  .carousel-item {
    height: 500px; /* 캐러셀의 높이를 고정시킵니다. 원하는 높이로 조정하세요. */
  }
  .carousel-item img {
    width: 100%; /* 이미지 너비를 항상 컨테이너의 100%로 설정 */
    height: 100%; /* 이미지 높이를 .carousel-item의 높이에 맞춥니다 */
    object-fit: cover; /* 이미지가 비율을 유지하면서 지정된 높이와 너비를 채우도록 설정 */
  }
  .navbar-nav .nav-link,
  .navbar-toggler-icon {
    color: white; /* 텍스트 색상을 흰색으로 지정 */
  }
</style>
<body class="bg-dark text-white">
    <div class="container">
    <!-- 메인메뉴 -->
       <nav class="navbar navbar-expand-lg bg-dark">
          <div class="container-fluid">
            <a class="navbar-brand" href="/shop/emp/goodsList.jsp?category=all&rowPerPage=<%=rowPerPage%>">
                <img src="/shop/mindMap/d.ico" alt="poterMore" width="30" height="24">
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
              <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarSupportedContent">
              <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                  <a class="nav-link active text-white" aria-current="page" href="/shop/emp/goodsList.jsp?category=all&rowPerPage=<%=rowPerPage%>">Poter More</a>
                </li>
                <li class="nav-item">
                  <a class="nav-link" href="/shop/emp/goodsList.jsp?category=all&rowPerPage=<%=rowPerPage%>">
                    All (<%=allCnt %>)
                  </a>
                </li>
                    <%
                        for(HashMap m : categoryList) {
                    %>
                            <li class="nav-item">
                                <a class="nav-link"  href="/shop/emp/goodsList.jsp?category=<%=(String)(m.get("category"))%>&rowPerPage=<%=rowPerPage%>">
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
    
    <!-- 캐러셀 -->
    <div id="carouselExampleCaptions" class="carousel slide container">
        <div class="carousel-indicators">
            <button type="button" data-bs-target="#carouselExampleCaptions" data-bs-slide-to="0" class="active" aria-current="true" aria-label="Slide 1"></button>
            <button type="button" data-bs-target="#carouselExampleCaptions" data-bs-slide-to="1" aria-label="Slide 2"></button>
            <button type="button" data-bs-target="#carouselExampleCaptions" data-bs-slide-to="2" aria-label="Slide 3"></button>
        </div>
        <div class="carousel-inner">
            <div class="carousel-item active">
            <img src="/shop/img/호그와트 교복 코스튬.jpeg" class="d-block w-100" alt="...">
            <div class="carousel-caption d-none d-md-block"></div>
            </div>
                <div class="carousel-item">
                <img src="/shop/img/님부스 2000 주니어 한정판.jpeg" class="d-block w-100" alt="...">
                <div class="carousel-caption d-none d-md-block"></div>
            </div>
            <div class="carousel-item">
                <img src="/shop/img/해리포터 지팡이.jpeg" class="d-block w-100" alt="...">
                <div class="carousel-caption d-none d-md-block"></div>
            </div>
        </div>
        <button class="carousel-control-prev" type="button" data-bs-target="#carouselExampleCaptions" data-bs-slide="prev">
            <span class="carousel-control-prev-icon" aria-hidden="true"></span>
            <span class="visually-hidden">Previous</span>
        </button>
        <button class="carousel-control-next" type="button" data-bs-target="#carouselExampleCaptions" data-bs-slide="next">
            <span class="carousel-control-next-icon" aria-hidden="true"></span>
            <span class="visually-hidden">Next</span>
        </button>
    </div>
    
    
    
    
	<!-- 서브메뉴 카테고리별 상품리스트 -->
	<div class="mt-3 container">
        <div style="float:left">
            <div>
               <table>
                   <tr>
                       <td>
                           <div style="float:left"><%=currentPage%> Page&nbsp;&nbsp;&nbsp;</div><%System.out.println("currentPage : " + currentPage);%>
                       </td>
                       <td>
                           <form method="post" action="/shop/emp/goodsList.jsp?searchWord=<%=searchWord %>&category=<%=category %>&rowPerPage=<%=rowPerPage%>">
                           <select name="order" class="form-select" aria-label="Default select example">
                               <option value="">오래된순</option>
                               <option value="new">최신순</option>
                               <option value="high">높은가격순</option>
                               <option value="low">낮은가격순</option>
                           </select>
                       </td>
                       <td>
                          <button type="submit" class="btn btn-light">설정</button>
                          </form>
                       </td>
                   </tr>
               </table>
            </div>
        </div>
        <!-- 한 페이지에 표시할 갯수 정하기 -->
        <div>
            <table>
            <form method="get" action="/shop/emp/goodsList.jsp">
                <input type="hidden" name="order" value="<%=order %>">
                <input type="hidden" name="searchWord" value="<%=searchWord %>">
                <input type="hidden" name="category" value="<%=category %>">
                <tr>
                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;표시할 상품 수</td>
                    <td>
                        <select name="rowPerPage" class="form-select" aria-label="Default select example">
                        <option value="1">1개</option>
                        <option value="2">2개</option>
                        <option value="3">3개</option>
                        <option value="4">4개</option>
                        <option value="5">5개</option>
                        <option value="10">10개</option>
                        <option value="15">15개</option>
                        <option value="20">20개</option>
                        </select>
                    </td>
                    <td><button type="submit" class="btn btn-light">보기</button></td>
                </tr>
            </form>
            </table>
        </div>
    </div>

    
    
    
    <div class="mt-3 container">
    <%
        for(HashMap<String, Object> m : goodsList){
    %>
            <div class="m-1 " style="width:19%; float:left">
                <table class="table table-dark table-borderless">
                    <tr>
                        <td colspan="2">
                            <a href="/shop/emp/empGoodsOne.jsp?goodsNo=<%=(String)(m.get("goodsNo"))%>">
                                <img alt="상품사진" src="/shop/upload/<%=(String)(m.get("filename")) %>" style="width:100%; height:100%;">
                            </a>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2"><%=(String) (m.get("goodsTitle"))%></td>
                    </tr>
                    <tr>
                        <td><%=(Integer) (m.get("goodsPrice"))%></td>
                        <td><%=(Integer) (m.get("goodsAmount"))%></td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <a class="btn btn-light" href="/shop/emp/modifyGoods.jsp?goodsNo=<%=(String) (m.get("goodsNo"))%>">수정</a>
                            <a class="btn btn-light" href="/shop/emp/deleteGoods.jsp?goodsNo=<%=(String) (m.get("goodsNo"))%>">삭제</a>
                        </td>
                    </tr>
                </table>
            </div>
    <%
        }
    %>  
        
    <!-- 페이징 버튼 -->
    <div style="clear: both; text-align:center;">
        <%
            if(searchWord == null || searchWord.equals("")){ // 검색어가 없을 때
                if(lastPage == 1){
        %>
                    <a class="btn btn-dark">&#60;&#60;</a>
                    <a class="btn btn-dark">&#60;</a>
                    <a class="btn btn-dark">&#62;</a>
                    <a class="btn btn-dark">&#62;&#62;</a>                        
        <%
                }else if(currentPage == 1) {/* 첫 페이지 화살표(이전과 처음 화살표 회색으로 비활성화) */
        %>
                    <a class="btn btn-dark">&#60;&#60;</a>
                    <a class="btn btn-dark">&#60;</a>
                    <a class="btn btn-light" href="/shop/emp/goodsList.jsp?category=<%=category %>&currentPage=<%=currentPage+1%>&order=<%=order %>&rowPerPage=<%=rowPerPage%>">&#62;</a>
                    <a class="btn btn-light" href="/shop/emp/goodsList.jsp?category=<%=category %>&currentPage=<%=lastPage%>&order=<%=order %>&rowPerPage=<%=rowPerPage%>">&#62;&#62;</a>
        <%      
                } else if(currentPage == lastPage) {/* 마지막 페이지 화살표(다음과 끝 화살표 회색으로 비활성화) */
        %>
                    <a class="btn btn-light" href="/shop/emp/goodsList.jsp?category=<%=category %>&currentPage=1&order=<%=order %>&rowPerPage=<%=rowPerPage%>">&#60;&#60;</a>
                    <a class="btn btn-light" href="/shop/emp/goodsList.jsp?category=<%=category %>&currentPage=<%=currentPage-1%>&order=<%=order %>&rowPerPage=<%=rowPerPage%>">&#60;</a>
                    <a class="btn btn-dark">&#62;</a>
                    <a class="btn btn-dark">&#62;&#62;</a>
        <%      
                } else { /* 2페이지 부터 마지막 바로 전페이지 까지 화살표 */
        %>
                    <a class="btn btn-light" href="/shop/emp/goodsList.jsp?category=<%=category %>&currentPage=1&order=<%=order %>&rowPerPage=<%=rowPerPage%>">&#60;&#60;</a>
                    <a class="btn btn-light" href="/shop/emp/goodsList.jsp?category=<%=category %>&currentPage=<%=currentPage-1%>&order=<%=order %>&rowPerPage=<%=rowPerPage%>">&#60;</a>
                    <a class="btn btn-light" href="/shop/emp/goodsList.jsp?category=<%=category %>&currentPage=<%=currentPage+1%>&order=<%=order %>&rowPerPage=<%=rowPerPage%>">&#62;</a>
                    <a class="btn btn-light" href="/shop/emp/goodsList.jsp?category=<%=category %>&currentPage=<%=lastPage%>&order=<%=order %>&rowPerPage=<%=rowPerPage%>">&#62;&#62;</a>
        <%
                }
            }else if(searchWord != null || !searchWord.equals("")){ // 검색어가 있을 때
                if(lastPage == 1){
        %>
                    <a class="btn btn-dark">&#60;&#60;</a>
                    <a class="btn btn-dark">&#60;</a>
                    <a class="btn btn-dark">&#62;</a>
                    <a class="btn btn-dark">&#62;&#62;</a>                        
        <%
                }else if(currentPage == 1) {/* 첫 페이지 화살표(이전과 처음 화살표 회색으로 비활성화) */
        %>
                    <a class="btn btn-dark">&#60;&#60;</a>
                    <a class="btn btn-dark">&#60;</a>
                    <a class="btn btn-light" href="/shop/emp/goodsList.jsp?searchWord=<%=searchWord %>&category=<%=category %>&currentPage=<%=currentPage+1%>&order=<%=order %>&rowPerPage=<%=rowPerPage%>">&#62;</a>
                    <a class="btn btn-light" href="/shop/emp/goodsList.jsp?searchWord=<%=searchWord %>&category=<%=category %>&currentPage=<%=lastPage%>&order=<%=order %>&rowPerPage=<%=rowPerPage%>">&#62;&#62;</a>
        <%      
                } else if(currentPage == lastPage) {/* 마지막 페이지 화살표(다음과 끝 화살표 회색으로 비활성화) */
        %>
                    <a class="btn btn-light" href="/shop/emp/goodsList.jsp?searchWord=<%=searchWord %>&category=<%=category %>&currentPage=1&order=<%=order %>&rowPerPage=<%=rowPerPage%>">&#60;&#60;</a>
                    <a class="btn btn-light" href="/shop/emp/goodsList.jsp?searchWord=<%=searchWord %>&category=<%=category %>&currentPage=<%=currentPage-1%>&order=<%=order %>&rowPerPage=<%=rowPerPage%>">&#60;</a>
                    <a class="btn btn-dark">&#62;</a>
                    <a class="btn btn-dark">&#62;&#62;</a>
        <%      
                } else { /* 2페이지 부터 마지막 바로 전페이지 까지 화살표 */
        %>
                    <a class="btn btn-light" href="/shop/emp/goodsList.jsp?searchWord=<%=searchWord %>&category=<%=category %>&currentPage=1&order=<%=order %>&rowPerPage=<%=rowPerPage%>">&#60;&#60;</a>
                    <a class="btn btn-light" href="/shop/emp/goodsList.jsp?searchWord=<%=searchWord %>&category=<%=category %>&currentPage=<%=currentPage-1%>&order=<%=order %>&rowPerPage=<%=rowPerPage%>">&#60;</a>
                    <a class="btn btn-light" href="/shop/emp/goodsList.jsp?searchWord=<%=searchWord %>&category=<%=category %>&currentPage=<%=currentPage+1%>&order=<%=order %>&rowPerPage=<%=rowPerPage%>">&#62;</a>
                    <a class="btn btn-light" href="/shop/emp/goodsList.jsp?searchWord=<%=searchWord %>&category=<%=category %>&currentPage=<%=lastPage%>&order=<%=order %>&rowPerPage=<%=rowPerPage%>">&#62;&#62;</a>
        <%                          
                }
            }
        %>              
        </div>
        <br>
        
        <table style="margin-left:auto; margin-right:auto;">
        <form mothod="get" action="/shop/emp/goodsList.jsp">
            <input type="hidden" name="order" value="<%=order %>">
            <input type="hidden" name="rowPerPage" value="<%=rowPerPage%>">
            <tr>
                <td>상품 검색</td>
                <td>
                    <select name="category" class="form-select" aria-label="Default select example">
                    <option value="all">전체</option>
                    <%
                        for(HashMap m : categoryList) {
                    %>
                            <option value="<%=(String)(m.get("category"))%>"><%=(String)(m.get("category"))%></option>
                    <%
                        }
                    %>
                    </select>
                </td>
                <td><input type="text" name="searchWord" class="form-control"></td>
                <td><button type="submit" class="btn btn-light">검색</button></td>
            </tr>
        </form>
        </table>
    </div>
    <jsp:include page="/emp/inc/footer.jsp"></jsp:include>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>