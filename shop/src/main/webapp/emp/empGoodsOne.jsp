<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.net.*"%>
<%@ page import="shop.dao.*" %>
<%
    System.out.println("=====empGoodsOne.jsp===========================================");
    
    // 로그인 인증 분기
    if(session.getAttribute("loginEmp") == null) {
    	response.sendRedirect("/shop/emp/empLoginForm.jsp");
    	return;
    }
    
    // customerGoodsList.jsp 에서 <a href>태그를 통해 get방식으로 goodsNo가 요청됨
    int goodsNo = Integer.parseInt(request.getParameter("goodsNo"));
    System.out.println("상품번호 : " + goodsNo);
    
    // GoodsDAO에서 goods의 DB 가져오기(where = goodsNo) 인것.
    ArrayList<HashMap<String, Object>> showGoods = GoodsDAO.showGoodsOne(goodsNo);
    System.out.println("showGoods : " + showGoods);
    
    // 해당 상품의 리뷰 목록 메서드
    ArrayList<HashMap<String, Object>> goodsOneReview = GoodsDAO.goodsOneReview(goodsNo);
    System.out.println("goodsOneReview : " + goodsOneReview);
%>
<!DOCTYPE html>
<html>
	<head>
	<meta charset="UTF-8">
	<title></title>
</head>
<body>
    <!-- 메인메뉴 -->
    <div>
        <jsp:include page="/emp/inc/empMenu.jsp"></jsp:include>
    </div>
    <!-- 상품상세정보 -->
    <h1>상품 상세보기</h1>
    <table border="1">
        <tr>
            <th>상품번호</th>
            <th>카테고리</th>
            <th>상품이름</th>
            <th>상품사진</th>
            <th>상품설명</th>
            <th>가격</th>
            <th>재고</th>
        </tr>
        <%
            for(HashMap<String, Object> m : showGoods){
        %>
        <tr>
            <td><%=(Integer) (m.get("goodsNo"))%></td>
            <td><%=(String) (m.get("category"))%></td>
            <td><%=(String) (m.get("goodsTitle"))%></td>
            <td>
               <img alt="상품사진" src="/shop/upload/<%=(String)(m.get("filename")) %>" style="width:100%; height:100%;">
            </td>
            <td><%=(String) (m.get("goodsContent"))%></td>
            <td><%=(Integer) (m.get("goodsPrice"))%></td>
            <td><%=(Integer) (m.get("goodsAmount"))%></td>
        </tr>
        <tr>
            <td><a href="/shop/emp/modifyGoods.jsp?goodsNo=<%=(Integer) (m.get("goodsNo"))%>">수정</a></td>
            <td><a href="/shop/emp/deleteGoods.jsp?goodsNo=<%=(Integer) (m.get("goodsNo"))%>">삭제</a></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
        </tr>
        <%
            }
        %>
    </table>

    <h1>리뷰</h1>
    <table border="1">
        <tr>
            <th>작성자</th>
            <th>주문갯수</th>
            <th>내용</th>
            <th>별점</th>
        </tr>
        <%
            for(HashMap<String, Object> m : goodsOneReview){
        %>
        <tr>
            <td><%=(String) (m.get("cusId"))%></td>
            <td><%=(Integer) (m.get("ea"))%></td>
            <td><%=(String) (m.get("content"))%></td>
            <td>
        <%
            if( (Integer)(m.get("rating")) == 5){
        %>
                ★★★★★
        <%
            }else if( (Integer)(m.get("rating")) == 4){
        %>
                ★★★★☆
        <%
            }else if( (Integer)(m.get("rating")) == 3){
        %>
                ★★★☆☆
        <%
            }else if( (Integer)(m.get("rating")) == 2){
        %>
                ★★☆☆☆
        <%
            }else if( (Integer)(m.get("rating")) == 1){
        %>
                ★☆☆☆☆
        <%
            }else if( (Integer)(m.get("rating")) == 0){
        %>
                ☆☆☆☆☆
        <%
            }
        %>
            </td>
        </tr>
        <%
            }
        %>
    </table>
</body>
</html>