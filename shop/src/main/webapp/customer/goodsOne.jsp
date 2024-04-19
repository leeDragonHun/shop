<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="shop.dao.*" %>
<%
    System.out.println("=====goodsOne.jsp===========================================");
    
    // 로그인 인증 분기
    if(session.getAttribute("loginCus") == null){
        response.sendRedirect("/shop/customer/customerLoginForm.jsp");
        return;
    }
    
    // customerGoodsList.jsp 에서 <a href>태그를 통해 get방식으로 goodsNo가 요청됨
    int goodsNo = Integer.parseInt(request.getParameter("goodsNo"));
    System.out.println("goodsNo : " + goodsNo);
    
    // GoodsDAO에서 goods의 DB 가져오기(where = goodsNo) 인것.
    
    ArrayList<HashMap<String, Object>> showGoods = GoodsDAO.showGoodsOne(goodsNo);
    System.out.println("showGoods : " + showGoods);
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>상품 상세보기</title>
</head>
<body>
    <!-- 고객메뉴  -->
    <jsp:include page="/customer/inc/customerMenu.jsp"></jsp:include>
    
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
        <%
            }
        %>
    </table>
    <form method="post" action="/shop/customer/orderAction.jsp">
        <input type="hidden" name="goodsNo" value="<%=goodsNo %>">
        <button type="submit">구매하기</button>
    </form>

</body>
</html>