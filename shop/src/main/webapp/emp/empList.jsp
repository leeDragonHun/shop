<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%@ page import="java.util.*" %>
<%@ page import="shop.dao.*" %>
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
    
    // DB 연동
    Connection conn = DBHelper.getConnection();
    
    /* Model Layer */
    // 현재 페이지를 1로 설정
    int currentPage = 1;
    System.out.println("currentPage : " + currentPage);
    if(request.getParameter("currentPage") != null) {
     currentPage = Integer.parseInt(request.getParameter("currentPage"));
    }
    
    int rowPerPage = 10;
    int startRow = (currentPage-1)*rowPerPage;

    // totalRow 구하는 매서드
    int totalRow = EmpDAO.totalRow();
    
    
    
    // 마지막 페이지는 전체줄수/한페이지에올줄수 예를들어 51페이지면 10으로 나누면 5가된다. 근데 한페이지에 10개씩 오려면 6페이지가 필요하니까 더하기 1을해준다. 그게 lastpage다
	int lastPage = totalRow / rowPerPage;
	if(totalRow%rowPerPage != 0) {
		lastPage = lastPage + 1;
	}
	System.out.println("lastPage : " + lastPage);
    
    // 직원목록조회
    ArrayList<HashMap<String,Object>> list = EmpDAO.list(startRow, rowPerPage);
    
%>
<!-- View Layer : 모델(ArrayList<HashMap<String, Object>>) 출력-->
<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
	<meta charset="UTF-8">
	<title>사원 관리</title>
    <link rel="shortcut icon" href="/shop/mindMap/d.ico" type="image/x-icon">
    <link rel="icon" href="/shop/mindMap/d.ico" type="image/x-icon">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link href="/shop/style.css" rel="stylesheet" type="text/css">    
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
            <td>아이디</td>
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
                    if(lastPage == 1){ // 페이지가 1페이지 밖에 없을 때
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
                        <a href="/shop/emp/empList.jsp?currentPage=<%=currentPage+1%>">&#62;</a>
                        <a href="/shop/emp/empList.jsp?currentPage=<%=lastPage%>">&#62;&#62;</a>
                <%      
                    } else if(currentPage == lastPage) {/* 마지막 페이지 화살표(다음과 끝 화살표 회색으로 비활성화) */
                %>
                        <a href="/shop/emp/empList.jsp?currentPage=1">&#60;&#60;</a>
                        <a href="/shop/emp/empList.jsp?currentPage=<%=currentPage-1%>">&#60;</a>
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
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>