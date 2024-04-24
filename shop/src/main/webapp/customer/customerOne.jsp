<%@page import="shop.dao.CustomerDAO"%>
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
    String rerrMsg = request.getParameter("rerrMsg");
    
    // 로그인 정보 호출
    HashMap<String,Object> loginCus = (HashMap<String,Object>)(session.getAttribute("loginCus"));
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
    ArrayList<HashMap<String, Object>> myReview = GoodsDAO.myReview(cusId);
    
    // 회원 정보 불러오기
    ArrayList<HashMap<String, Object>> cusInfo = CustomerDAO.cusInfo(cusId);
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>고객 마이페이지</title>
    <link rel="shortcut icon" href="/shop/mindMap/d.ico" type="image/x-icon">
    <link rel="icon" href="/shop/mindMap/d.ico" type="image/x-icon">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link href="/shop/style.css" rel="stylesheet" type="text/css">    
</head>
<body>
    <!-- 고객메뉴  -->
    <jsp:include page="/customer/inc/customerMenu.jsp"></jsp:include>
    
    <!-- 구매확정 실패 에러메시지 -->
    <%
        if(berrMsg != null){
    %>
            <%=berrMsg %>
    <%
        }
    %>
    <!-- 리뷰작성 실패 에러메시지 -->
    <%
        if(rerrMsg != null){
    %>
            <%=rerrMsg %>
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
                <th>상태</th>
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
                <th>상태</th>
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
                <th>상태</th>
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
                <td><a href="/shop/customer/writeReview.jsp?ordersNo=<%=m.get("ordersNo") %>&goodsTitle=<%=m.get("goodsTitle") %>">작성하기</a></td>
            </tr>
        <%
            }
        %>
        </table>
    </fieldset>
    <fieldset>
        <legend>내가 쓴 리뷰관리</legend>
            <table border="1">
            <tr>
                <th>상품이름</th>
                <th>내용</th>
                <th>별점</th>
            </tr>
        <%
            for(HashMap<String, Object> m : myReview){
        %>
            <tr>
                <td><%=m.get("goodsTitle") %></td>
                <td><%=m.get("content") %></td>
                <td><%=m.get("rating") %></td>
            </tr>
        <%
            }
        %>
        </table>
    </fieldset>
    <fieldset>
        <legend>회원정보</legend>
        <table border="1">
        <tr>
            <th>아이디</th>
            <th>이름</t>
            <th>생년월일</th>
            <th>성별</th>
            <th>주소</th>
        </tr>
        <%
            for(HashMap<String, Object> m : cusInfo){
        %>
        <tr>
            <td><%=m.get("cus_id") %></td>
            <td><%=m.get("cus_name") %></td>
            <td><%=m.get("birth") %></td>
            <td><%=m.get("gender") %></td>
            <td><%=m.get("address") %></td>
        </tr>
        <%
            }
        %>
        </table>
    </fieldset>
    <a href="/shop/customer/customerModifyCheck.jsp">회원정보수정</a>
    <a href="/shop/customer/customerDeleteCheck.jsp">회원 탈퇴</a>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>    
</body>
</html>