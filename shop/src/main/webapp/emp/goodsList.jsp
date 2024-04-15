<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="shop.dao.*" %>
<!-- Controller Layer -->
<%
    System.out.println("=====goodsList.jsp==========================================");
	// 인증분기	 : 세션변수 이름 - loginEmp
	if(session.getAttribute("loginEmp") == null) {
		response.sendRedirect("/shop/emp/empLoginForm.jsp");
		return;
	}
    
    // 카테고리 값 요청
	String category = request.getParameter("category");
    if(category == null){
    	response.sendRedirect("/shop/emp/goodsList.jsp?category=all");
		return;
    }
    
    //order 값 요청
    String order = request.getParameter("order");
    System.out.println("order : " + order);
    
    // DB연동
    Connection conn = DBHelper.getConnection();
    
    // 검색어 값 요청
    String searchWord = "";
    if(request.getParameter("searchWord") != null) {
    	searchWord = request.getParameter("searchWord");
    }
    System.out.println("searchWord : " + searchWord);
    
    // 카테고리 값 요청
    System.out.println("category : " + category);
%>
<!-- Model Layer -->
<%
    // 카테고리 선택 메뉴
	PreparedStatement stmt1 = null;
	ResultSet rs1 = null;
	String sql1 = "select category, count(*) cnt from goods group by category order by create_date asc";
	stmt1 = conn.prepareStatement(sql1);
	rs1 = stmt1.executeQuery();
	ArrayList<HashMap<String, Object>> categoryList =
			new ArrayList<HashMap<String, Object>>();
	while(rs1.next()) {
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("category", rs1.getString("category"));
		m.put("cnt", rs1.getInt("cnt"));
		categoryList.add(m);
	}
	System.out.println("categoryList : " + categoryList);
    
    // 현재페이지 설정. 페이지 값 받아오기
    int currentPage = 1;
    if (request.getParameter("currentPage") != null) {
        currentPage = Integer.parseInt(request.getParameter("currentPage"));
    }
    
	// 페이징------------
    int rowPerPage = 4;
    if(request.getParameter("rowPerPage") != null) {
		rowPerPage = Integer.parseInt(request.getParameter("rowPerPage"));
	}
	
    // 전체 아이템 수
    System.out.println("rowPerPage : " + rowPerPage);
	int startRow = ((currentPage-1)*rowPerPage);
    
    // sql2 정해지는 분기문
    String sql2 = null;
    String totalRowSql = null;
    
    // 전체에 관한거
    if((searchWord != null && !searchWord.equals("")) && category.equals("all")){
        System.out.println("검색어가 있고 카테고리가 all");
    	sql2 = "select goods_title goodsTitle, filename, goods_price goodsPrice, goods_amount goodsAmount from goods where goods_title like '%"+searchWord+ "%'";
        if(order != null && order.equals("new")){
            sql2 += " order by create_date desc";
        }else if(order != null && order.equals("high")){
            sql2 += " order by goods_price desc";
        }else if(order != null && order.equals("low")){
            sql2 += " order by goods_price asc";
        }
        sql2 += " limit ?, ?"; 
    	totalRowSql = "select count(*) from goods where goods_title like '%"+searchWord+ "%'";
	}else if((searchWord == null || searchWord.equals("")) && category.equals("all")){
		System.out.println("검색어가 없고 카테고리가 all");
		sql2 = "select goods_title goodsTitle, filename, goods_price goodsPrice, goods_amount goodsAmount from goods";
        if(order != null && order.equals("new")){
            sql2 += " order by create_date desc";
        }else if(order != null && order.equals("high")){
            sql2 += " order by goods_price desc";
        }else if(order != null && order.equals("low")){
            sql2 += " order by goods_price asc";
        }
		sql2 += " limit ?, ?";
        totalRowSql = "select count(*) from goods";
    }
    
    // 카테고리 값 있을 때(all 아니고 다른 값 있을 때)
    if((searchWord != null && !searchWord.equals("")) && !category.equals("all")){
    	System.out.println("검색어가 있고 카테고리가 선택됨");
    	sql2 = "select goods_title goodsTitle, filename, goods_price goodsPrice, goods_amount goodsAmount from goods where category = '"+category+"' and goods_title like '%"+searchWord+ "%'";
        if(order != null && order.equals("new")){
            sql2 += " order by create_date desc";
        }else if(order != null && order.equals("high")){
            sql2 += " order by goods_price desc";
        }else if(order != null && order.equals("low")){
            sql2 += " order by goods_price asc";
        }
    	sql2 += " limit ?, ?";
    	totalRowSql = "select count(*) from goods where category = '" + category + "' and goods_title like '%"+searchWord+ "%'";
	}else if((searchWord == null || searchWord.equals(""))&& !category.equals("all")){
		System.out.println("검색어가 없고 카테고리가 선택됨");
		sql2 = "select goods_title goodsTitle, filename, goods_price goodsPrice, goods_amount goodsAmount from goods where category = '"+category+"' and goods_title like '%"+searchWord+ "%'";
        if(order != null && order.equals("new")){
            sql2 += " order by create_date desc";
        }else if(order != null && order.equals("high")){
            sql2 += " order by goods_price desc";
        }else if(order != null && order.equals("low")){
            sql2 += " order by goods_price asc";
        }
		sql2 += " limit ?, ?";
        totalRowSql = "select count(*) from goods";
    }
    
    System.out.println("sql2 : " + sql2);
    System.out.println("totalRowSql : " + totalRowSql);
    
	PreparedStatement stmt2 = null;
    stmt2 = conn.prepareStatement(sql2);
	stmt2.setInt(1,startRow);
	stmt2.setInt(2,rowPerPage);
    ResultSet rs2 = null;
    rs2 = stmt2.executeQuery();
        
    // totalRow 를 구하는 SQL 및 dB연동-----------------------------------------------------------
   PreparedStatement totalRowStmt = null;
   ResultSet totalRowRs = null;
   totalRowStmt = conn.prepareStatement(totalRowSql);
   totalRowRs = totalRowStmt.executeQuery();
   
   // 전체줄 수(게시글) = 일단 0으로 선언하고. totalRowSql에 count(*)로 몇개인지에 따라 값이 정해짐
  	int totalRow = 0;
	if(totalRowRs.next()) {
		totalRow = totalRowRs.getInt("count(*)");
	}
	System.out.println("totalRow : " + totalRow);
    
   // 마지막 페이지는 전체줄수/한페이지에올줄수 예를들어 51페이지면 10으로 나누면 5가된다. 근데 한페이지에 10개씩 오려면 6페이지가 필요하니까 더하기 1을해준다. 그게 lastpage다
	int lastPage = totalRow / rowPerPage;
	if(totalRow%rowPerPage != 0) {
		lastPage = lastPage + 1;
	}
	System.out.println("lastPage : " + lastPage);
    //---------------------------------------------------------------------------------------------
    
    // 굿즈리스트 값입력
    ArrayList<HashMap<String, Object>> goodsList = new ArrayList<HashMap<String, Object>>();
	while(rs2.next()) {
		HashMap<String, Object> m2 = new HashMap<String, Object>();
		m2.put("goodsTitle", rs2.getString("goodsTitle"));
		m2.put("filename", rs2.getString("filename"));
		m2.put("goodsPrice", rs2.getInt("goodsPrice"));
		m2.put("goodsAmount", rs2.getInt("goodsAmount"));
		goodsList.add(m2);
	}
	System.out.println("goodsList : " + goodsList);

	// 전체의 '갯수' 나타내기
    String sql4 = "SELECT COUNT(*) cnt FROM goods";
	PreparedStatement stmt4 = null;
    ResultSet rs4 = null;
    stmt4 = conn.prepareStatement(sql4);
    rs4 = stmt4.executeQuery();
%>
<!-- View Layer -->
<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
	<meta charset="UTF-8">
	<title>상품관리</title>
</head>
<body>

	<!-- 메인메뉴 -->
	<div>
		<jsp:include page="/emp/inc/empMenu.jsp"></jsp:include>
	</div>
	
	<!-- 서브메뉴 카테고리별 상품리스트 -->
	<div>
		<a href="/shop/emp/goodsList.jsp?category=all&rowPerPage=<%=rowPerPage%>">
            전체
            <%
                while(rs4.next()){
            %>
                    (<%=rs4.getInt("cnt") %>)
            <%
                }
            %>
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
                for(HashMap<String, Object> m2 : goodsList){
        %>
                	<div style="width:20%; float:left">
                        <table border="1" width="90%" height="90%">
                            <tr>
                                <td colspan="2">
                                    <img alt="상품사진" src="/shop/upload/<%=(String)(m2.get("filename")) %>" style="width:100%; height:100%;">
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2"><%=(String) (m2.get("goodsTitle"))%></td>
                            </tr>
                            <tr>
                                <td><%=(Integer) (m2.get("goodsPrice"))%></td>
                                <td><%=(Integer) (m2.get("goodsAmount"))%></td>
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