<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="shop.dao.*" %>
<!-- Controller Layer -->
<%
    System.out.println("=====customerList.jsp=======================================");
    // 로그오프면(세션값이 없으면) 로그인 폼으로 가기
    if(session.getAttribute("loginEmp") == null){ 
        response.sendRedirect("/shop/emp/empLoginForm.jsp"); 
        return; // 종료
    }

    // 로그인한 사람의 id, name, grade의 값이 배열로 들어옴
        HashMap<String,Object> loginMember 
        = (HashMap<String,Object>)(session.getAttribute("loginEmp"));
    
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
    int totalRow = EmpDAO.cusTotalRow();
    
    
    
    // 마지막 페이지는 전체줄수/한페이지에올줄수 예를들어 51페이지면 10으로 나누면 5가된다. 근데 한페이지에 10개씩 오려면 6페이지가 필요하니까 더하기 1을해준다. 그게 lastpage다
	int lastPage = totalRow / rowPerPage;
	if(totalRow%rowPerPage != 0) {
		lastPage = lastPage + 1;
	}
	System.out.println(lastPage + " <-- lastPage");
    
    // 고객목록조회
    ArrayList<HashMap<String, Object>> list = EmpDAO.cusList(startRow, rowPerPage); 
%>
<!DOCTYPE html>
<html>
	<head>
    <meta name="viewport" content="width=device-width, initial-scale=1">    
	<meta charset="UTF-8">
	<title>고객 목록</title>
    <link rel="shortcut icon" href="/shop/mindMap/d.ico" type="image/x-icon">
    <link rel="icon" href="/shop/mindMap/d.ico" type="image/x-icon">
</head>
<body>
    <!-- 공통메뉴 -->
    <jsp:include page="/emp/inc/empMenu.jsp"></jsp:include>
    
    <!-- 고객 목록 -->
    <h1>고객 목록</h1>
    <table border="1">
        <tr>
            <th>아이디</th>
            <th>이름</th>
            <th>생일</th>
            <th>성별</th>
        </tr>
        <%
            for(HashMap<String, Object> m : list){
        %>
            <tr>
                <td><%= (String)(m.get("cusId")) %></td>
                <td><%= (String)(m.get("cusName")) %></td>
                <td><%= (String)(m.get("birth")) %></td>
                <td><%= (String)(m.get("gender")) %></td>
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
                <a href="/shop/emp/customerList.jsp?currentPage=<%=currentPage+1%>">&#62;</a>
                <a href="/shop/emp/customerList.jsp?currentPage=<%=lastPage%>">&#62;&#62;</a>
        <%      
            } else if(currentPage == lastPage) {/* 마지막 페이지 화살표(다음과 끝 화살표 회색으로 비활성화) */
        %>
                <a href="/shop/emp/customerList.jsp?currentPage=1">&#60;&#60;</a>
                <a href="/shop/emp/customerList.jsp?currentPage=<%=currentPage-1%>">&#60;</>
                <a>&#62;</a>
                <a>&#62;&#62;</a>
        <%      
            } else { /* 2페이지 부터 마지막 바로 전페이지 까지 화살표 */
        %>
                <a href="/shop/emp/customerList.jsp?currentPage=1">&#60;&#60;</a>
                <a href="/shop/emp/customerList.jsp?currentPage=<%=currentPage-1%>">&#60;</a>
                <a href="/shop/emp/customerList.jsp?currentPage=<%=currentPage+1%>">&#62;</a>
                <a href="/shop/emp/customerList.jsp?currentPage=<%=lastPage%>">&#62;&#62;</a>
        <%                          
            }
        %>              
    </div>                      
    <!-- end -->
</body>
</html>