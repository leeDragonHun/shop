<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="shop.dao.*" %>
<%@ page import="java.net.*" %>
<!-- Controller Layer -->
<%
    System.out.println("=====customerGoodsList.jsp==========================================");
	// 인증분기	 : 세션변수 이름 - loginCus
	if(session.getAttribute("loginCus") == null) {
		String errMsg =  URLEncoder.encode("로그인을 먼저 해주세요.","utf-8");
        response.sendRedirect("/shop/customer/customerLoginForm.jsp?&errMsg="+errMsg);
		return;
	}
    
    //  에러메시지 호출
	String errMsg = request.getParameter("errMsg");
    
    // DB연동
    Connection conn = DBHelper.getConnection();
    
    // category 값 요청
	String category = request.getParameter("category");
    System.out.println("category : " + category);
    if(category == null){
    	response.sendRedirect("/shop/customer/customerGoodsList.jsp?category=all");
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
  <!-- Model Layer -->
<%
    // 전체의 '갯수' 나타내기
    int allCnt = GoodsDAO.goodsListCnt("", "");
    System.out.println("allCount : " + allCnt);  

    // 카테고리 선택 메뉴
    ArrayList<HashMap<String, Object>> categoryList = GoodsDAO.selectCategory(); 
        
	// 페이징-------------------------------------------------------------------------------------
    int rowPerPage = 5;
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
	<title>상품목록</title>
    <link rel="shortcut icon" href="/shop/mindMap/d.ico" type="image/x-icon">
    <link rel="icon" href="/shop/mindMap/d.ico" type="image/x-icon">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link href="/shop/style.css" rel="stylesheet" type="text/css">    
</head>
<style>

</style>
<body>
    <!-- 주문 실패시 에러 메시지 -->
    <%
        if(errMsg != null){
    %>
            <%=errMsg %>
    <%
        }
    %>
    <nav class="navbar navbar-expand-lg bg-body-tertiary">
      <div class="container-fluid">
        <a class="navbar-brand" href="#">
            <img src="/shop/mindMap/d.ico" alt="poterMore" width="30" height="24">
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
          <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarSupportedContent">
          <ul class="navbar-nav me-auto mb-2 mb-lg-0">
            <li class="nav-item">
              <a class="nav-link active" aria-current="page" href="/shop/customer/customerGoodsList.jsp?category=all&rowPerPage=5">Poter More</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="/shop/customer/customerGoodsList.jsp?category=all&rowPerPage=<%=rowPerPage%>">
                All (<%=allCnt %>)
              </a>
            </li>
                <%
                    for(HashMap m : categoryList) {
                %>
                        <li class="nav-item">
                            <a class="nav-link"  href="/shop/customer/customerGoodsList.jsp?category=<%=(String)(m.get("category"))%>&rowPerPage=<%=rowPerPage%>">
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

	<!-- 서브메뉴 카테고리별 상품리스트 -->
	
        <div style="float:left">
            <div>
               <table>
                   <tr>
                       <td>
                           <div style="float:left"><%=currentPage%> Page</div><%System.out.println("currentPage : " + currentPage);%>
                       </td>
                       <td>
                           <form method="post" action="/shop/customer/customerGoodsList.jsp?searchWord=<%=searchWord %>&category=<%=category %>&rowPerPage=<%=rowPerPage%>">
                           <select name="order" class="form-select" aria-label="Default select example">
                               <option value="">오래된순</option>
                               <option value="new">최신순</option>
                               <option value="high">높은가격순</option>
                               <option value="low">낮은가격순</option>
                           </select>
                       </td>
                       <td>
                          <button type="submit" class="btn btn-outline-dark">설정</button>
                          </form>
                       </td>
                   </tr>
               </table>
            </div>
        </div>
        
        <!-- 한 페이지에 표시할 갯수 정하기 -->
        <div>
            <table>
            <form method="get" action="/shop/customer/customerGoodsList.jsp">
                <input type="hidden" name="order" value="<%=order %>">
                <input type="hidden" name="searchWord" value="<%=searchWord %>">
                <input type="hidden" name="category" value="<%=category %>">
                <tr>
                    <td>표시할 상품 수 </td>
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
                    <td><button type="submit" class="btn btn-outline-dark">보기</button></td>
                </tr>
            </form>
            </table>
        </div>

        
        
        
        
        <%
                for(HashMap<String, Object> m : goodsList){
        %>
                	<div class="m-1 " style="width:19%; float:left">
                        <table class="table table-bordered">
                            <tr>
                                <td colspan="2">
                                    <a href="/shop/customer/goodsOne.jsp?goodsNo=<%=(String)(m.get("goodsNo"))%>">
                                        <img alt="상품사진" src="/shop/upload/<%=(String)(m.get("filename")) %>" style="width:100%; height:100%;">
                                    </a>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2"><%=(String) (m.get("goodsTitle"))%></td>
                            </tr>
                            <tr>
                                <td><%=(Integer) (m.get("goodsPrice"))%></td>
                                <td>
                                <%
                                    if((Integer) (m.get("goodsAmount")) == 0){
                                %>
                                    품절
                                <%
                                    }else{
                                %>
                                        <%=(Integer) (m.get("goodsAmount")) %>
                                <%
                                    }
                                %>
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
                    	<a class="btn btn-outline-dark">&#60;&#60;</a>
                        <a class="btn btn-outline-dark">&#60;</a>
                        <a class="btn btn-outline-dark">&#62;</a>
                        <a class="btn btn-outline-dark">&#62;&#62;</a>                        
            <%
                    }else if(currentPage == 1) {/* 첫 페이지 화살표(이전과 처음 화살표 회색으로 비활성화) */
            %>
                        <a class="btn btn-outline-dark">&#60;&#60;</a>
                        <a class="btn btn-outline-dark">&#60;</a>
                        <a class="btn btn-outline-dark" href="/shop/customer/customerGoodsList.jsp?category=<%=category %>&currentPage=<%=currentPage+1%>&order=<%=order %>&rowPerPage=<%=rowPerPage%>">&#62;</a>
                        <a class="btn btn-outline-dark" href="/shop/customer/customerGoodsList.jsp?category=<%=category %>&currentPage=<%=lastPage%>&order=<%=order %>&rowPerPage=<%=rowPerPage%>">&#62;&#62;</a>
            <%      
                    } else if(currentPage == lastPage) {/* 마지막 페이지 화살표(다음과 끝 화살표 회색으로 비활성화) */
            %>
                        <a class="btn btn-outline-dark" href="/shop/customer/customerGoodsList.jsp?category=<%=category %>&currentPage=1&order=<%=order %>&rowPerPage=<%=rowPerPage%>">&#60;&#60;</a>
                        <a class="btn btn-outline-dark" href="/shop/customer/customerGoodsList.jsp?category=<%=category %>&currentPage=<%=currentPage-1%>&order=<%=order %>&rowPerPage=<%=rowPerPage%>">&#60;</a>
                        <a class="btn btn-outline-dark">&#62;</a>
                        <a class="btn btn-outline-dark">&#62;&#62;</a>
            <%      
                    } else { /* 2페이지 부터 마지막 바로 전페이지 까지 화살표 */
            %>
                        <a class="btn btn-outline-dark" href="/shop/customer/customerGoodsList.jsp?category=<%=category %>&currentPage=1&order=<%=order %>&rowPerPage=<%=rowPerPage%>">&#60;&#60;</a>
                        <a class="btn btn-outline-dark" href="/shop/customer/customerGoodsList.jsp?category=<%=category %>&currentPage=<%=currentPage-1%>&order=<%=order %>&rowPerPage=<%=rowPerPage%>">&#60;</a>
                        <a class="btn btn-outline-dark" href="/shop/customer/customerGoodsList.jsp?category=<%=category %>&currentPage=<%=currentPage+1%>&order=<%=order %>&rowPerPage=<%=rowPerPage%>">&#62;</a>
                        <a class="btn btn-outline-dark" href="/shop/customer/customerGoodsList.jsp?category=<%=category %>&currentPage=<%=lastPage%>&order=<%=order %>&rowPerPage=<%=rowPerPage%>">&#62;&#62;</a>
            <%
                    }
                }else if(searchWord != null || !searchWord.equals("")){ // 검색어가 있을 때
                    if(lastPage == 1){
            %>
                        <a class="btn btn-outline-dark">&#60;&#60;</a>
                        <a class="btn btn-outline-dark">&#60;</a>
                        <a class="btn btn-outline-dark">&#62;</a>
                        <a class="btn btn-outline-dark">&#62;&#62;</a>                        
            <%
                    }else if(currentPage == 1) {/* 첫 페이지 화살표(이전과 처음 화살표 회색으로 비활성화) */
            %>
                        <a class="btn btn-outline-dark">&#60;&#60;</a>
                        <a class="btn btn-outline-dark">&#60;</a>
                        <a class="btn btn-outline-dark" href="/shop/customer/customerGoodsList.jsp?searchWord=<%=searchWord %>&category=<%=category %>&currentPage=<%=currentPage+1%>&order=<%=order %>&rowPerPage=<%=rowPerPage%>">&#62;</a>
                        <a class="btn btn-outline-dark" href="/shop/customer/customerGoodsList.jsp?searchWord=<%=searchWord %>&category=<%=category %>&currentPage=<%=lastPage%>&order=<%=order %>&rowPerPage=<%=rowPerPage%>">&#62;&#62;</a>
            <%      
                    } else if(currentPage == lastPage) {/* 마지막 페이지 화살표(다음과 끝 화살표 회색으로 비활성화) */
            %>
                        <a class="btn btn-outline-dark" href="/shop/customer/customerGoodsList.jsp?searchWord=<%=searchWord %>&category=<%=category %>&currentPage=1&order=<%=order %>&rowPerPage=<%=rowPerPage%>">&#60;&#60;</a>
                        <a class="btn btn-outline-dark" href="/shop/customer/customerGoodsList.jsp?searchWord=<%=searchWord %>&category=<%=category %>&currentPage=<%=currentPage-1%>&order=<%=order %>&rowPerPage=<%=rowPerPage%>">&#60;</a>
                        <a class="btn btn-outline-dark">&#62;</a>
                        <a class="btn btn-outline-dark">&#62;&#62;</a>
            <%      
                    } else { /* 2페이지 부터 마지막 바로 전페이지 까지 화살표 */
            %>
                        <a class="btn btn-outline-dark" href="/shop/customer/customerGoodsList.jsp?searchWord=<%=searchWord %>&category=<%=category %>&currentPage=1&order=<%=order %>&rowPerPage=<%=rowPerPage%>">&#60;&#60;</a>
                        <a class="btn btn-outline-dark" href="/shop/customer/customerGoodsList.jsp?searchWord=<%=searchWord %>&category=<%=category %>&currentPage=<%=currentPage-1%>&order=<%=order %>&rowPerPage=<%=rowPerPage%>">&#60;</a>
                        <a class="btn btn-outline-dark" href="/shop/customer/customerGoodsList.jsp?searchWord=<%=searchWord %>&category=<%=category %>&currentPage=<%=currentPage+1%>&order=<%=order %>&rowPerPage=<%=rowPerPage%>">&#62;</a>
                        <a class="btn btn-outline-dark" href="/shop/customer/customerGoodsList.jsp?searchWord=<%=searchWord %>&category=<%=category %>&currentPage=<%=lastPage%>&order=<%=order %>&rowPerPage=<%=rowPerPage%>">&#62;&#62;</a>
            <%                          
                    }
                }
            %>              
        </div>
	<br>
    
    <table style="margin-left:auto; margin-right:auto;">
    <form mothod="get" action="/shop/customer/customerGoodsList.jsp">
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
            <td><button type="submit" class="btn btn-outline-dark">검색</button></td>
        </tr>
    </form>
    </table>
        
        
        
        
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>    
</body>
</html>