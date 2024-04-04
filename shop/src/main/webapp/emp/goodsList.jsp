<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<!-- Controller Layer -->
<%
    System.out.println("=====goodsList.jsp==========================================");
	// 인증분기	 : 세션변수 이름 - loginEmp
	if(session.getAttribute("loginEmp") == null) {
		response.sendRedirect("/shop/emp/empLoginForm.jsp");
		return;
	}
    
    // DB연동
	Class.forName("org.mariadb.jdbc.Driver");
	String category = request.getParameter("category");
	Connection conn = null;
	PreparedStatement stmt1 = null;
	ResultSet rs1 = null;
	conn = DriverManager.getConnection(
			"jdbc:mariadb://127.0.0.1:3306/shop", "root", "java1234");
    
    
%>

<!-- Model Layer -->
<%
	
    // 카테고리 선택 메뉴
	String sql1 = "select category, count(*) cnt from goods group by category order by category asc";
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
	// 페이징	
	int rowPerPage = 10; // 전체 아이템 수
	int startRow = ((currentPage-1)*rowPerPage);
    
    // all과 카테고리 분기문
    String sql2 = null;
    String totalRowSql = null;
    if(category == null || category.equals("all")){
        sql2 = "select money_title moneyTitle, money_price moneyPrice, money_amount moneyAmount from goods order by update_date desc limit ?, ?"; // 전체출력
        totalRowSql = "select count(*) from goods";
    }else{
        sql2 = "select money_title moneyTitle, money_price moneyPrice, money_amount moneyAmount from goods where category = '" + category + "' order by update_date desc limit ?, ?"; // 카테고리별 출력
        totalRowSql = "select count(*) from goods where category = '" + category + "'";
    }
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
	System.out.println(totalRow + " <-- totalRow");
    
   // 마지막 페이지는 전체줄수/한페이지에올줄수 예를들어 51페이지면 10으로 나누면 5가된다. 근데 한페이지에 10개씩 오려면 6페이지가 필요하니까 더하기 1을해준다. 그게 lastpage다
	int lastPage = totalRow / rowPerPage;
	if(totalRow%rowPerPage != 0) {
		lastPage = lastPage + 1;
	}
	System.out.println(lastPage + " <-- lastPage");
    //---------------------------------------------------------------------------------------------
    
    ArrayList<HashMap<String, Object>> moneyList = new ArrayList<HashMap<String, Object>>();
	while(rs2.next()) {
		HashMap<String, Object> m2 = new HashMap<String, Object>();
		m2.put("moneyTitle", rs2.getString("moneyTitle"));
		m2.put("moneyPrice", rs2.getInt("moneyPrice"));
		m2.put("moneyAmount", rs2.getInt("moneyAmount"));
		moneyList.add(m2);
	}
	System.out.println("moneyList : " + moneyList);

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
	<meta charset="UTF-8">
	<title>goodsList</title>
</head>
<body>

	<!-- 메인메뉴 -->
	<div>
		<jsp:include page="/emp/inc/empMenu.jsp"></jsp:include>
	</div>
	
	<div>
		<a href="/shop/emp/addGoodsForm.jsp">상품등록</a>	
	</div>
	<!-- 서브메뉴 카테고리별 상품리스트 -->
	<div>
		<a href="/shop/emp/goodsList.jsp?category=all">
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
				<a href="/shop/emp/goodsList.jsp?category=<%=(String)(m.get("category"))%>">
					<%=(String)(m.get("category"))%>  (<%=(Integer)(m.get("cnt"))%>)
				</a>	
		<%		
			}
		%>
        <div><%=currentPage%> Page</div>
        <table border="1">
            <tr>
                <td>제목</td>
                <td>가격</td>
                <td>재고</td>
            </tr>
        <%
                for(HashMap<String, Object> m2 : moneyList){
        %>
                    <tr>
                        <td><%=(String) (m2.get("moneyTitle"))%></td>
                        <td><%=(Integer) (m2.get("moneyPrice"))%></td>
                        <td><%=(Integer) (m2.get("moneyAmount"))%></td>
                    </tr>
        <%
                }
        %>    
        </table>
        <!-- 페이징 버튼 -->
        <div>
                <%
                    if(currentPage == 1) {/* 첫 페이지 화살표(이전과 처음 화살표 회색으로 비활성화) */
                %>
                            <a>&#60;&#60;</a>
                            <a>&#60;</a>
                            <a href="/shop/emp/goodsList.jsp?currentPage=<%=currentPage+1%>">&#62;</a>
                            <a href="/shop/emp/goodsList.jsp?currentPage=<%=lastPage%>">&#62;&#62;</a>
                <%      
                    } else if(currentPage == lastPage) {/* 마지막 페이지 화살표(다음과 끝 화살표 회색으로 비활성화) */
                %>
                            <a href="/shop/emp/goodsList.jsp?currentPage=1">&#60;&#60;</a>
                            <a href="/shop/emp/goodsList.jsp?currentPage=<%=currentPage-1%>">&#60;</a>
                            <a>&#62;</a>
                            <a>&#62;&#62;</a>
                <%      
                    } else { /* 2페이지 부터 마지막 바로 전페이지 까지 화살표 */
                %>
                            <a href="/shop/emp/goodsList.jsp?currentPage=1">&#60;&#60;</a>
                            <a href="/shop/emp/goodsList.jsp?currentPage=<%=currentPage-1%>">&#60;</a>
                            <a href="/shop/emp/goodsList.jsp?currentPage=<%=currentPage+1%>">&#62;</a>
                            <a href="/shop/emp/goodsList.jsp?currentPage=<%=lastPage%>">&#62;&#62;</a>
                <%                          
                    }
                %>              
        </div>
	</div>
</body>
</html>






















