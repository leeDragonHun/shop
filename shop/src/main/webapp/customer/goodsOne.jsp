<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.net.*"%>
<%@ page import="shop.dao.*" %>
<%
    System.out.println("=====goodsOne.jsp===========================================");
    
    // 로그인 인증 분기
    if(session.getAttribute("loginCus") == null){
    	String errMsg =  URLEncoder.encode("로그인을 먼저 해주세요.","utf-8");
        response.sendRedirect("/shop/customer/customerLoginForm.jsp?&errMsg="+errMsg);
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
    <!-- 재고가 있을때만 주문활성화, 재고가 없으면 품절표시 -->
    <form method="post" action="/shop/customer/orderAction.jsp">
        <input type="hidden" name="goodsNo" value="<%=goodsNo %>">
        <%
        for(HashMap<String, Object> m : showGoods){
            if((Integer)(m.get("goodsAmount")) > 0){
        %>
        <input type="hidden" name="goodsAmount" value="<%=(Integer) (m.get("goodsAmount")) %>">
        <input type="hidden" name="goodsTitle" value="<%=(String) (m.get("goodsTitle")) %>">
        <select name="ea">
        <%
        	for(int ea = 1; ea <= (Integer) (m.get("goodsAmount")); ea++){
        %>
                 <option value="<%=ea%>"><%=ea%></option>
        <%
        		}
        %>
        </select>
        <button type="submit">구매하기</button>
        <%        
            }else{
        %>
        <button type="submit" disabled="disabled">품절</button>
        <%        
            }
        }
        %>
    </form>
</body>
</html>