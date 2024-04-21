<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="shop.dao.GoodsDAO"%>
<%@ page import="java.net.*"%>
<%@ page import="java.util.*"%>
<%
    System.out.println("=====customerOne.jsp========================================");

    // 로그인 인증 분기
    if(session.getAttribute("loginCus") == null) {
    	String errMsg =  URLEncoder.encode("로그인을 먼저 해주세요.","utf-8");
        response.sendRedirect("/shop/customer/customerLoginForm.jsp?&errMsg="+errMsg);
        return;
    }
    
    // 에러메시지 받기.
    String berrMsg = request.getParameter("berrMsg");
    
    // 로그인 정보 호출
    HashMap<String,Object> loginCus 
    = (HashMap<String,Object>)(session.getAttribute("loginCus"));
    // 로그인 ID 호출
    String cusId = (String)(loginCus.get("cus_id"));
    System.out.println("현재 로그인 사용자 : " + cusId);
    
    // 결제 완료된 orders 데이터 출력
    ArrayList<HashMap<String, Object>> CompletePayment = GoodsDAO.CompletePayment(cusId);
    // 배송 완료된 orders 데이터 출력
    ArrayList<HashMap<String, Object>> CompleteDelivery = GoodsDAO.CompleteDelivery(cusId);
    // 구매 확정된 orders 데이터 출력
    ArrayList<HashMap<String, Object>> CompleteBuy = GoodsDAO.CompleteBuy(cusId);
    // 리뷰 완료된 orders 데이터 출력
    ArrayList<HashMap<String, Object>> CompleteReview = GoodsDAO.CompleteReview(cusId);
%>
<!DOCTYPE html>
<html>
	<head>
	<meta charset="UTF-8">
	<title>customerOne</title>
</head>
<body>
    <!-- 고객메뉴  -->
    <jsp:include page="/customer/inc/customerMenu.jsp"></jsp:include>
    
    <%
        if(berrMsg != null){
    %>
            <%=berrMsg %>
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
                <th>상품번호</th>
                <th>주문갯수</th>
                <th>주문상태</th>
            </tr>
        <%
            for(HashMap<String, Object> m : CompletePayment){
        %>
            <tr>
                <td><%=m.get("ordersNo") %></td>
                <td><%=m.get("goodsTitle") %></td>
                <td><%=m.get("goodsNo") %></td>
                <td><%=m.get("ea") %></td>
                <td><%=m.get("state") %></td>
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
                <th>상품번호</th>
                <th>주문갯수</th>
                <th>주문상태</th>
                <th>확정하기</th>
            </tr>
        <%
            for(HashMap<String, Object> m : CompleteDelivery){
        %>
            <tr>
                <td><%=m.get("ordersNo") %></td>
                <td><%=m.get("goodsTitle") %></td>
                <td><%=m.get("goodsNo") %></td>
                <td><%=m.get("ea") %></td>
                <td><%=m.get("state") %></td>
                <td><a href="/shop/customer/completeBuy.jsp?ordersNo=<%=m.get("ordersNo") %>">구매확정</a></td>
            </tr>
        <%
            }
        %>
        </table>
    </fieldset>
    <fieldset>
        <legend>구매확정</legend>
                <table border="1">
            <tr>
                <th>주문번호</th>
                <th>상품이름</th>
                <th>상품번호</th>
                <th>주문갯수</th>
                <th>주문상태</th>
                <th>리뷰작성</th>
            </tr>
        <%
            for(HashMap<String, Object> m : CompleteBuy){
        %>
            <tr>
                <td><%=m.get("ordersNo") %></td>
                <td><%=m.get("goodsTitle") %></td>
                <td><%=m.get("goodsNo") %></td>
                <td><%=m.get("ea") %></td>
                <td><%=m.get("state") %></td>
                <td><a href="/shop/customer/writeReview.jsp?ordersNo=<%=m.get("ordersNo") %>">작성하기</a></td>
            </tr>
        <%
            }
        %>
        </table>
    </fieldset>
    <fieldset>
        <legend>리뷰관리</legend>
                <table border="1">
            <tr>
                <th>주문번호</th>
                <th>상품이름</th>
                <th>상품번호</th>
                <th>주문갯수</th>
                <th>주문상태</th>
            </tr>
        <%
            for(HashMap<String, Object> m : CompleteReview){
        %>
            <tr>
                <td><%=m.get("ordersNo") %></td>
                <td><%=m.get("goodsTitle") %></td>
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