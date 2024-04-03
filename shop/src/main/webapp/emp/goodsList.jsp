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
%>

<!-- Model Layer -->
<%
	Class.forName("org.mariadb.jdbc.Driver");
	String category = request.getParameter("category");
	Connection conn = null;
	PreparedStatement stmt1 = null;
	ResultSet rs1 = null;
	conn = DriverManager.getConnection(
			"jdbc:mariadb://127.0.0.1:3306/shop", "root", "java1234");
	
	String sql1 = "select category, count(*) cnt from goods group by category order by category asc";
	stmt1 = conn.prepareStatement(sql1);
	rs1 = stmt1.executeQuery();
    // 선언
	ArrayList<HashMap<String, Object>> categoryList =
			new ArrayList<HashMap<String, Object>>();
	while(rs1.next()) {
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("category", rs1.getString("category"));
		m.put("cnt", rs1.getInt("cnt"));
		categoryList.add(m);
	}
	// 디버깅
	System.out.println("categoryList : " + categoryList);
    
    // 카테고리별 리스트 뽑기
    String sql2 = "select money_no moneyNo, emp_id empId, money_title moneyTitle, money_content moneyContent, money_price moneyPrice, money_amount moneyAmount, update_date updateDate, create_date createDate from goods where category = ? order by update_date desc";
	PreparedStatement stmt2 = null;
    stmt2 = conn.prepareStatement(sql2);
    stmt2.setString(1,category);
    ResultSet rs2 = null;
    rs2 = stmt2.executeQuery();
    
    ArrayList<HashMap<String, Object>> moneyList =
			new ArrayList<HashMap<String, Object>>();
	while(rs2.next()) {
		HashMap<String, Object> m2 = new HashMap<String, Object>();
		m2.put("moneyNo", rs2.getInt("moneyNo"));
		m2.put("empId", rs2.getString("empId"));
		m2.put("moneyTitle", rs2.getString("moneyTitle"));
		m2.put("moneyContent", rs2.getString("moneyContent"));
		m2.put("moneyPrice", rs2.getInt("moneyPrice"));
		m2.put("moneyAmount", rs2.getInt("moneyAmount"));
		m2.put("updateDate", rs2.getString("updateDate"));
		m2.put("createDate", rs2.getString("createDate"));
		moneyList.add(m2);
	}
	// 디버깅
	System.out.println("moneyList : " + moneyList);
    
    // 전체 리스트 뽑기
    String sql3 = "select money_no moneyNo, emp_id empId, money_title moneyTitle, money_content moneyContent, money_price moneyPrice, money_amount moneyAmount, update_date updateDate, create_date createDate from goods order by update_date desc";
	PreparedStatement stmt3 = null;
    stmt3 = conn.prepareStatement(sql3);
    ResultSet rs3 = null;
    rs3 = stmt3.executeQuery();
    
    ArrayList<HashMap<String, Object>> moneyAllList =
			new ArrayList<HashMap<String, Object>>();
	while(rs3.next()) {
		HashMap<String, Object> m3 = new HashMap<String, Object>();
		m3.put("moneyNo", rs3.getInt("moneyNo"));
		m3.put("empId", rs3.getString("empId"));
		m3.put("moneyTitle", rs3.getString("moneyTitle"));
		m3.put("moneyContent", rs3.getString("moneyContent"));
		m3.put("moneyPrice", rs3.getInt("moneyPrice"));
		m3.put("moneyAmount", rs3.getInt("moneyAmount"));
		m3.put("updateDate", rs3.getString("updateDate"));
		m3.put("createDate", rs3.getString("createDate"));
		moneyAllList.add(m3);
	}
	// 디버깅
	System.out.println("moneyAllList : " + moneyAllList);
    
    // 전체 카테고리 갯수 나타내기
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
        <table border="1">
            <tr>
                <td>상품번호</td>
                <td>작성자</td>
                <td>제목</td>
                <td>내용</td>
                <td>가격</td>
                <td>재고</td>
                <td>업데이트 시간</td>
                <td>작성된 시간</td>
            </tr>
        <%
            if(category == null || category.equals("all")){
                for(HashMap<String, Object> m3 : moneyAllList) {
        %>
                <tr>
                    <td><%=(Integer) (m3.get("moneyNo"))%></td>
                    <td><%=(String) (m3.get("empId"))%></td>
                    <td><%=(String) (m3.get("moneyTitle"))%></td>
                    <td><%=(String) (m3.get("moneyContent"))%></td>
                    <td><%=(Integer) (m3.get("moneyPrice"))%></td>
                    <td><%=(Integer) (m3.get("moneyAmount"))%></td>
                    <td><%=(String) (m3.get("updateDate"))%></td>
                    <td><%=(String) (m3.get("createDate"))%></td>
                </tr>
        <%
                }
            }else{
                for(HashMap<String, Object> m2 : moneyList){
        %>
                <tr>
                    <td><%=(Integer) (m2.get("moneyNo"))%></td>
                    <td><%=(String) (m2.get("empId"))%></td>
                    <td><%=(String) (m2.get("moneyTitle"))%></td>
                    <td><%=(String) (m2.get("moneyContent"))%></td>
                    <td><%=(Integer) (m2.get("moneyPrice"))%></td>
                    <td><%=(Integer) (m2.get("moneyAmount"))%></td>
                    <td><%=(String) (m2.get("updateDate"))%></td>
                    <td><%=(String) (m2.get("createDate"))%></td>
                </tr>
        <%
                }
	       }
        %>    
        </table>
	</div>
</body>
</html>






















