<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%
    System.out.println("=====empList.jsp============================================");
 
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
    
    // 직원 목록 조회
	PreparedStatement stmt = null;
	ResultSet rs = null;
	String sql = "SELECT emp_id empId, emp_name empName, emp_job empJob, hire_date hireDate FROM emp";
    stmt = conn.prepareStatement(sql);
    rs = stmt.executeQuery();
    
    // 직원 ID로 해당 직원의 emp_job 조회
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	String sql2 = "SELECT emp_job empJob FROM emp where emp_id =?";
    stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1,loginId);
	rs2 = stmt2.executeQuery();
    System.out.println("stmt2 : " + stmt2);
%>


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
            <td>입사날짜</td>
        </tr>
        <%
            while(rs.next()){
        %>
        <tr>
            <td><%=rs.getString("empId")%></td>
            <td><%=rs.getString("empName")%></td>
            <td><%=rs.getString("empJob")%></td>
            <td><%=rs.getString("hireDate")%></td>
        </tr>
        <%
        
            }
        %>
    </table>
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