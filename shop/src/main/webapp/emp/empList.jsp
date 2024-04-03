<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%@ page import="java.util.*" %>
<%
    System.out.println("=====empList.jsp============================================");

    /*  Controller Layer */
    // 로그오프면(세션값이 없으면) 로그인 폼으로 가기
    if(session.getAttribute("loginEmp") == null){ 
        response.sendRedirect("/shop/emp/empLoginForm.jsp"); 
        return; // 종료
    }
    
    // 로그인 사용자 ID가 get방식으로 들어옴
    String loginId = null;
    loginId = request.getParameter("loginId");
    System.out.println("loginId : " + loginId);

    // DB 연동
    Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/shop", "root", "java1234");
    
    /* Model Layer */
    // 현재 페이지를 1로 설정
    int currentPage = 1;
    System.out.println("currentPage : " + currentPage);
    if(request.getParameter("currentPage") != null) {
     currentPage = Integer.parseInt(request.getParameter("currentPage"));
    }
    
    int rowPerPage = 10;
    int startRow = (currentPage-1)*rowPerPage;
    
     // totalRow 를 구하는 SQL 및 dB연동 
    String totalRowSql = "select count(*) from emp";
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
    
    // 직원 목록 조회
	PreparedStatement stmt = null;
	ResultSet rs = null;
	String sql = "SELECT emp_id empId, grade, emp_name empName, emp_job empJob, hire_date hireDate, active FROM emp order by hire_date desc limit ?, ?";
    stmt = conn.prepareStatement(sql);
	stmt.setInt(1, startRow); // (현재페이지 -1)에서 곱하기 rowperPage를 해주면 n번째 페이지의 첫째로 오는 게시글의 순번 즉, 몇번째글인지 계산할 수 있다.
	stmt.setInt(2, rowPerPage); // 두번째 물음표에는 '그래서 몇개 보여줄지' 가 정해진다. 말그대로 rowperPage
    rs = stmt.executeQuery();
    
    // 특수한 형태의 자료구조(RDBMS:mariadb)를 여태껏 사용하였음
    // -> API사용(JDBC API) 하여 자료구조(ResultSet) 취득하였었음
    // -> 이제는 일반화된 자료구조(ArrayList<HashMap>)로 변경할것임 -> 이렇게 모델을 취득
    // ----JDBC API 종속된 자료구조 모델 ResultSet -> 기본 API 자료구조(ArrayList) 로변경
    ArrayList<HashMap<String, Object>> list
     = new ArrayList<HashMap<String, Object>>();
    
    // ResultSet -> ArrayList<HashMap<String, Object>>
    while(rs.next()){
    	HashMap<String, Object> m = new HashMap<String, Object>();
        m.put("empId", rs.getString("empId"));
        m.put("grade", rs.getString("grade"));
        m.put("empName", rs.getString("empName"));
        m.put("empJob", rs.getString("empJob"));
        m.put("hireDate", rs.getString("hireDate"));
        m.put("active", rs.getString("active"));
        list.add(m);
    }
    // JDBC API 사용이 끝났다면 DB자원들을 해지-----
    
    // 직원 ID로 해당 직원의 emp_job 조회
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	String sql2 = "SELECT emp_job empJob FROM emp where emp_id =?";
    stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1,loginId);
	rs2 = stmt2.executeQuery();
    System.out.println("stmt2 : " + stmt2);
%>
<!-- View Layer : 모델(ArrayList<HashMap<String, Object>>) 출력-->
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title></title>
</head>
<body>
    <!-- empMenu.jsp include : 주체(서버) vs redirect(주체:클라이언트) 어디 있는 거 불러올 수 있는-->
    <!-- 주의사항으로는 주체가 서버이기 때문에 include할때는 절대주소로 사용 ./ 이런거 x -->
    <jsp:include page="/emp/inc/empMenu.jsp"></jsp:include>

    <!-- 직원 목록 -->
    <h1>직원 목록</h1>
    <div><%=currentPage%> 페이지</div>
    <table border="1">
        <tr>
            <td>ID</td>
            <td>등급</td>
            <td>이름</td>
            <td>직책</td>
            <td>고용날짜</td>
            <td>권한</td>
        </tr>
        <%
            
            for(HashMap<String, Object> m : list){
        %>
        <tr>
            <td><%=(String) (m.get("empId"))%></td>
            <td><%=(String) (m.get("grade"))%></td>
            <td><%=(String) (m.get("empName"))%></td>
            <td><%=(String) (m.get("empJob"))%></td>
            <td><%=(String) (m.get("hireDate"))%></td>
            <td>
                <%=(String) (m.get("active"))%>
                <%
                     HashMap<String, Object> sm = (HashMap<String, Object>)(session.getAttribute("loginEmp"));
                     if((Integer)(sm.get("grade")) > 0) {
                %>
                <a href="/shop/emp/activeChange.jsp?empId=<%=(String)(m.get("empId")) %>&active=<%=(String)(m.get("active"))%>">변경</a>
                <%
                    }
                %>
            </td>
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
                                <a href="/shop/emp/empList.jsp?currentPage=<%=currentPage+1%>">&#62;</a>
                                <a href="/shop/emp/empList.jsp?currentPage=<%=lastPage%>">&#62;&#62;</a>
                    <%      
                        } else if(currentPage == lastPage) {/* 마지막 페이지 화살표(다음과 끝 화살표 회색으로 비활성화) */
                    %>
                                <a href="/shop/emp/empList.jsp?currentPage=1">&#60;&#60;</a>
                                <a href="/shop/emp/empListcurrentPage=<%=currentPage-1%>">&#60;</a>
                                <a>&#62;</a>
                                <a>&#62;&#62;</a>
                    <%      
                        } else { /* 2페이지 부터 마지막 바로 전페이지 까지 화살표 */
                    %>
                                <a href="/shop/emp/empList.jsp?currentPage=1">&#60;&#60;</a>
                                <a href="/shop/emp/empList.jsp?currentPage=<%=currentPage-1%>">&#60;</a>
                                <a href="/shop/emp/empList.jsp?currentPage=<%=currentPage+1%>">&#62;</a>
                                <a href="/shop/emp/empList.jsp?currentPage=<%=lastPage%>">&#62;&#62;</a>
                    <%                          
                        }
                    %>              
            </div>                      
            <!-- end -->
    
    <!-- 팀장만 보이는 Form(로그인 권한 부여)  -->
        <%    
        // "팀장"일 때만 보여지는 폼(로그인 권한 관리폼)
        HashMap<String, Object> m = (HashMap<String, Object>)(session.getAttribute("loginEmp"));
        if((Integer)(m.get("grade")) > 0) {
         %>
            <div>아래는 팀장만 보이는 화면입니다.</div>
            <form mothod="post" action="/shop/emp/modifyEmpActive.jsp">
                <table>
                    <tr>
                        <td>로그인 권한 부여할 직원 아이디</td>
                        <td><input type ="text" name = "requestEmp"></td>
                        <input type="hidden" name="loginId" value="<%= loginId %>">
                        <td><button type="submit">권한 부여</button></td>
                    </tr>
                </table>
            </form>
            
            <form mothod="post" action="/shop/emp/modifyEmpActive2.jsp">
                <table>
                    <tr>
                        <td>로그인 권한 해제할 직원 아이디</td>
                        <td><input type ="text" name = "retireEmp"></td>
                        <input type="hidden" name="loginId" value="<%= loginId %>">
                        <td><button type="submit">권한 해제</button></td>
                    </tr>
                </table>
            </form>
         <%   
        }

    // 자원반납
    conn.close();
%>
</body>
</html>