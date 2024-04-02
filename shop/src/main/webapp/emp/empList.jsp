<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%@ page import="java.util.*" %>
<%
    System.out.println("=====empList.jsp============================================");

    /*  Controller Layer */
    // 로그오프면(세션값이 없으면) 로그인 폼으로 가기
    String loginEmp = (String)session.getAttribute("loginEmp");
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
    
    // 직원 목록 조회
	PreparedStatement stmt = null;
	ResultSet rs = null;
	String sql = "SELECT emp_id empId, emp_name empName, emp_job empJob, hire_date hireDate, active FROM emp order by hire_date desc limit ?, ?";
    stmt = conn.prepareStatement(sql);
	stmt.setInt(1, startRow);
	stmt.setInt(2, rowPerPage);
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
    <a href="/shop/emp/logoutAction.jsp">로그아웃</a>
    
    
    
    <!-- 직원 목록 -->
    <h1>직원 목록</h1>
    <table border="1">
        <tr>
            <td>ID</td>
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
            <td><%=(String) (m.get("empName"))%></td>
            <td><%=(String) (m.get("empJob"))%></td>
            <td><%=(String) (m.get("hireDate"))%></td>
            <td><%=(String) (m.get("active"))%></td>
        </tr>
        <%
            }
        %>
    </table>
    
    
    
    <!-- 팀장만 보이는 Form(로그인 권한 부여)  -->
<%    
    while(rs2.next()){
        // 2번째 쿼리로 불러온 현재 로그인 아이디의 emp_job
        String empJob = rs2.getString("empJob");
        System.out.println("현재 아이디의 emp_job : " + empJob);
        
        // "팀장"일 때만 보여지는 폼(로그인 권한 관리폼)
        if(empJob.equals("팀장")){
         %>
            <form mothod="post" action="/shop/emp/modifyEmpActive.jsp">
                <table>
                    <tr>
                        <td>권한 부여할 직원 아이디</td>
                        <td><input type ="text" name = "requestEmp"></td>
                        <input type="hidden" name="loginId" value="<%= loginId %>">
                        <td><button type="submit">권한 부여</button></td>
                    </tr>
                </table>
            </form>
            
            <form mothod="post" action="/shop/emp/modifyEmpActive2.jsp">
                <table>
                    <tr>
                        <td>권한 해제할 직원 아이디</td>
                        <td><input type ="text" name = "retireEmp"></td>
                        <input type="hidden" name="loginId" value="<%= loginId %>">
                        <td><button type="submit">권한 해제</button></td>
                    </tr>
                </table>
            </form>
         <%   
        }
    }
// 자원반납
conn.close();
%>
</body>
</html>