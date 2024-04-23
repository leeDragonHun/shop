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
  <!-- Model Layer -->
<%
    // 전체의 '갯수' 나타내기
    int allCnt = GoodsDAO.goodsListCnt("", "");
    System.out.println("allCount : " + allCnt);  

    // 카테고리 선택 메뉴
    ArrayList<HashMap<String, Object>> categoryList = GoodsDAO.selectCategory(); 
        
    // 페이징-------------------------------------------------------------------------------------
    int rowPerPage = 4;
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
</head>
<body>
    <!-- 메인메뉴 -->
    <div>
        <jsp:include page="/emp/inc/empMenu.jsp"></jsp:include>
    </div>
    
    <!-- 서브메뉴 카테고리별 상품리스트 -->
    <div>
        <a href="/shop/emp/goodsList.jsp?category=all&rowPerPage=<%=rowPerPage%>">

            전체 (<%=allCnt %>)
            
        </a>
        
        <%
            for(HashMap m : categoryList) {
        %>
                <a href="/shop/emp/goodsList.jsp?category=<%=(String)(m.get("category"))%>&rowPerPage=<%=rowPerPage%>">
                    <%=(String)(m.get("category"))%>  (<%=(Integer)(m.get("cnt"))%>)
                </a>
        <%      
            }
        %>
    <br>
        <div>
           <a><%=currentPage%> Page</a>
           <%System.out.println("currentPage : " + currentPage);%>
           <form method="post" action="/shop/emp/goodsList.jsp?searchWord=<%=searchWord %>&category=<%=category %>&rowPerPage=<%=rowPerPage%>">
               <select name="order">
                   <option value="">오래된순</option>
                   <option value="new">최신순</option>
                   <option value="high">높은가격순</option>
                   <option value="low">낮은가격순</option>
               </select>
               <button type="submit">설정</button>
           </form>
        </div>
        <%
                for(HashMap<String, Object> m : goodsList){
        %>
                    <div style="width:20%; float:left">
                        <table border="1" width="90%" height="90%">
                            <tr>
                                <td colspan="2">
                                    <img alt="상품사진" src="/shop/upload/<%=(String)(m.get("filename")) %>" style="width:100%; height:100%;">
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
                                <td><a href="/shop/emp/modifyGoods.jsp?goodsNo=<%=(String) (m.get("goodsNo"))%>">수정</a></td>
                                <td><a href="/shop/emp/deleteGoods.jsp?goodsNo=<%=(String) (m.get("goodsNo"))%>">삭제</a></td>
                            </tr>
                        </table>
                    </div>
        <%
                }
        %>  
        
        
          
        <!-- 한 페이지에 표시할 갯수 정하기 -->
        <div style="clear:left">
            <form method="get" action="/shop/emp/goodsList.jsp">
                <input type="hidden" name="order" value="<%=order %>">
                <input type="hidden" name="searchWord" value="<%=searchWord %>">
                <input type="hidden" name="category" value="<%=category %>">
                표시할 상품 수 : 
                <select name="rowPerPage">
                    <option value="1">1</option>
                    <option value="2">2</option>
                    <option value="3">3</option>
                    <option value="4">4</option>
                    <option value="5">5</option>
                    <option value="10">10</option>
                    <option value="15">15</option>
                    <option value="20">20</option>
                </select>
                <button type="submit">개 보기</button>
            </form>
        </div>
        
        
        
        <!-- 페이징 버튼 -->
        <div>
            <%
                if(searchWord == null || searchWord.equals("")){ // 검색어가 없을 때
                    if(lastPage == 1){
            %>
                        <a>&#60;&#60;</a>
                        <a>&#60;</a>
                        <a>&#62;</a>
                        <a>&#62;&#62;</a>                        
            <%
                    }else if(currentPage == 1) {/* 첫 페이지 화살표(이전과 처음 화살표 회색으로 비활성화) */
            %>
                        <a>&#60;&#60;</a>
                        <a>&#60;</a>
                        <a href="/shop/emp/goodsList.jsp?category=<%=category %>&currentPage=<%=currentPage+1%>&order=<%=order %>&rowPerPage=<%=rowPerPage%>">&#62;</a>
                        <a href="/shop/emp/goodsList.jsp?category=<%=category %>&currentPage=<%=lastPage%>&order=<%=order %>&rowPerPage=<%=rowPerPage%>">&#62;&#62;</a>
            <%      
                    } else if(currentPage == lastPage) {/* 마지막 페이지 화살표(다음과 끝 화살표 회색으로 비활성화) */
            %>
                        <a href="/shop/emp/goodsList.jsp?category=<%=category %>&currentPage=1&order=<%=order %>&rowPerPage=<%=rowPerPage%>">&#60;&#60;</a>
                        <a href="/shop/emp/goodsList.jsp?category=<%=category %>&currentPage=<%=currentPage-1%>&order=<%=order %>&rowPerPage=<%=rowPerPage%>">&#60;</a>
                        <a>&#62;</a>
                        <a>&#62;&#62;</a>
            <%      
                    } else { /* 2페이지 부터 마지막 바로 전페이지 까지 화살표 */
            %>
                        <a href="/shop/emp/goodsList.jsp?category=<%=category %>&currentPage=1&order=<%=order %>&rowPerPage=<%=rowPerPage%>">&#60;&#60;</a>
                        <a href="/shop/emp/goodsList.jsp?category=<%=category %>&currentPage=<%=currentPage-1%>&order=<%=order %>&rowPerPage=<%=rowPerPage%>">&#60;</a>
                        <a href="/shop/emp/goodsList.jsp?category=<%=category %>&currentPage=<%=currentPage+1%>&order=<%=order %>&rowPerPage=<%=rowPerPage%>">&#62;</a>
                        <a href="/shop/emp/goodsList.jsp?category=<%=category %>&currentPage=<%=lastPage%>&order=<%=order %>&rowPerPage=<%=rowPerPage%>">&#62;&#62;</a>
            <%
                    }
                }else if(searchWord != null || !searchWord.equals("")){ // 검색어가 있을 때
                    if(lastPage == 1){
            %>
                        <a>&#60;&#60;</a>
                        <a>&#60;</a>
                        <a>&#62;</a>
                        <a>&#62;&#62;</a>                        
            <%
                    }else if(currentPage == 1) {/* 첫 페이지 화살표(이전과 처음 화살표 회색으로 비활성화) */
            %>
                        <a>&#60;&#60;</a>
                        <a>&#60;</a>
                        <a href="/shop/emp/goodsList.jsp?searchWord=<%=searchWord %>&category=<%=category %>&currentPage=<%=currentPage+1%>&order=<%=order %>&rowPerPage=<%=rowPerPage%>">&#62;</a>
                        <a href="/shop/emp/goodsList.jsp?searchWord=<%=searchWord %>&category=<%=category %>&currentPage=<%=lastPage%>&order=<%=order %>&rowPerPage=<%=rowPerPage%>">&#62;&#62;</a>
            <%      
                    } else if(currentPage == lastPage) {/* 마지막 페이지 화살표(다음과 끝 화살표 회색으로 비활성화) */
            %>
                        <a href="/shop/emp/goodsList.jsp?searchWord=<%=searchWord %>&category=<%=category %>&currentPage=1&order=<%=order %>&rowPerPage=<%=rowPerPage%>">&#60;&#60;</a>
                        <a href="/shop/emp/goodsList.jsp?searchWord=<%=searchWord %>&category=<%=category %>&currentPage=<%=currentPage-1%>&order=<%=order %>&rowPerPage=<%=rowPerPage%>">&#60;</a>
                        <a>&#62;</a>
                        <a>&#62;&#62;</a>
            <%      
                    } else { /* 2페이지 부터 마지막 바로 전페이지 까지 화살표 */
            %>
                        <a href="/shop/emp/goodsList.jsp?searchWord=<%=searchWord %>&category=<%=category %>&currentPage=1&order=<%=order %>&rowPerPage=<%=rowPerPage%>">&#60;&#60;</a>
                        <a href="/shop/emp/goodsList.jsp?searchWord=<%=searchWord %>&category=<%=category %>&currentPage=<%=currentPage-1%>&order=<%=order %>&rowPerPage=<%=rowPerPage%>">&#60;</a>
                        <a href="/shop/emp/goodsList.jsp?searchWord=<%=searchWord %>&category=<%=category %>&currentPage=<%=currentPage+1%>&order=<%=order %>&rowPerPage=<%=rowPerPage%>">&#62;</a>
                        <a href="/shop/emp/goodsList.jsp?searchWord=<%=searchWord %>&category=<%=category %>&currentPage=<%=lastPage%>&order=<%=order %>&rowPerPage=<%=rowPerPage%>">&#62;&#62;</a>
            <%                          
                    }
                }
            %>              
        </div>
    </div>
    <form mothod="get" action="/shop/emp/goodsList.jsp">
        상품 검색 : 
        <input type="hidden" name="order" value="<%=order %>">
        <input type="hidden" name="rowPerPage" value="<%=rowPerPage%>">
        <select name="category">
            <option value="all">전체</option>
            <%
                for(HashMap m : categoryList) {
            %>
                    <option value="<%=(String)(m.get("category"))%>"><%=(String)(m.get("category"))%></option>
            <%
                }
            %>
        </select>
        <input type="text" name="searchWord">
        <button type="submit">검색</button>
    </form>
    <a href="/shop/emp/addGoodsForm.jsp">상품등록</a>
</body>
</html>