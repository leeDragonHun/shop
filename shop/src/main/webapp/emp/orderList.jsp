<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="shop.dao.GoodsDAO"%>
<%@ page import="java.net.*"%>
<%@ page import="java.util.*"%>
<%    
    System.out.println("=====orderList.jsp==========================================");
    // 로그인 인증 분기
    if(session.getAttribute("loginEmp") == null) {
    	String errMsg =  URLEncoder.encode("로그인을 먼저 해주세요.","utf-8");
        response.sendRedirect("/shop/emp/empLoginForm.jsp?&errMsg="+errMsg);
        return;
    }
    
    // 에러메시지 받기.
    String derrMsg = request.getParameter("derrMsg");
    
    // 결제 완료된 orders 데이터 출력
    ArrayList<HashMap<String, Object>> allCompletePayment = GoodsDAO.allCompletePayment();
    
    // 배송 완료된 orders 데이터 출력
    ArrayList<HashMap<String, Object>> allCompleteDelivery = GoodsDAO.allCompleteDelivery();
%>
<!DOCTYPE html>
<html>
	<head>
	<meta charset="UTF-8">
	<title>주문목록관리</title>
    <link rel="shortcut icon" href="/shop/mindMap/d.ico" type="image/x-icon">
    <link rel="icon" href="/shop/mindMap/d.ico" type="image/x-icon">    
</head>
<body>
    <!-- emp 메뉴 -->
    <jsp:include page="/emp/inc/empMenu.jsp"></jsp:include>

    <%
        if(derrMsg != null){
    %>
            <%=derrMsg %>
    <%
        }
    %>
    <h1>주문내역</h1>
    <fieldset>
        <legend>결제완료</legend>
        <table border="1">
            <tr>
                <th>주문번호</th>
                <th>상품이름</th>
                <th>주문자ID</th>
                <th>상품번호</th>
                <th>주문갯수</th>
                <th>주문상태</th>
                <th>배송하기</th>
            </tr>
        <%
            for(HashMap<String, Object> m : allCompletePayment){
        %>
            <tr>
                <td><%=m.get("ordersNo") %></td>
                <td><%=m.get("goodsTitle") %></td>
                <td><%=m.get("cusId") %></td>
                <td><%=m.get("goodsNo") %></td>
                <td><%=m.get("ea") %></td>
                <td><%=m.get("state") %></td>
                <td><a href="/shop/emp/startDelivery.jsp?ordersNo=<%=m.get("ordersNo")%>">배송처리</a></td>
            </tr>
        <%
            }
        %>
        </table>
    </fieldset>
    
    <fieldset>
        <legend>배송완료</legend>
        <table border="1">
            <tr>
                <th>주문번호</th>
                <th>상품이름</th>
                <th>주문자ID</th>
                <th>상품번호</th>
                <th>주문갯수</th>
                <th>주문상태</th>
            </tr>
        <%
            for(HashMap<String, Object> m : allCompleteDelivery){
        %>
            <tr>
                <td><%=m.get("ordersNo") %></td>
                <td><%=m.get("goodsTitle") %></td>
                <td><%=m.get("cusId") %></td>
                <td><%=m.get("goodsNo") %></td>
                <td><%=m.get("ea") %></td>
                <td><%=m.get("state") %></td>
            </tr>
        <%
            }
        %>
        </table>
    </fieldset>
</body>
</html>