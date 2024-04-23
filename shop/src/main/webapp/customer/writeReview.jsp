<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="shop.dao.*" %>
<%
    System.out.println("=====writeReview.jsp==========================================");

    // 로그인 인증 분기
    if(session.getAttribute("loginCus") == null) {
        String errMsg =  URLEncoder.encode("로그인을 먼저 해주세요.","utf-8");
        response.sendRedirect("/shop/customer/customerLoginForm.jsp?&errMsg="+errMsg);
        return;
    }
    
    // 로그인 정보 호출
    HashMap<String,Object> loginCus 
    = (HashMap<String,Object>)(session.getAttribute("loginCus"));
    // 로그인 ID 호출
    String cusId = (String)(loginCus.get("cus_id"));
    System.out.println("현재 로그인 사용자 : " + cusId);
    
    // 상품 번호, 이름 호출
    int ordersNo = Integer.parseInt(request.getParameter("ordersNo"));
    System.out.println("상품번호 : " + ordersNo);
    String goodsTitle = request.getParameter("goodsTitle");
    System.out.println("상품이름 : " + goodsTitle);
%>
<!DOCTYPE html>
<html>
	<head>
	<meta charset="UTF-8">
	<title>리뷰작성</title>
    <link rel="shortcut icon" href="/shop/mindMap/d.ico" type="image/x-icon">
    <link rel="icon" href="/shop/mindMap/d.ico" type="image/x-icon">
</head>
<style>
.star-rating {
  display: flex;
  flex-direction: row-reverse;
  font-size: 2.25rem;
  line-height: 2.5rem;
  justify-content: space-around;
  padding: 0 0.2em;
  text-align: center;
  width: 5em;
}
 
.star-rating input {
  display: none;
}
 
.star-rating label {
  -webkit-text-fill-color: transparent; /* Will override color (regardless of order) */
  -webkit-text-stroke-width: 2.3px;
  -webkit-text-stroke-color: #2b2a29;
  cursor: pointer;
}
 
.star-rating :checked ~ label {
  -webkit-text-fill-color: gold;
}
 
.star-rating label:hover,
.star-rating label:hover ~ label {
  -webkit-text-fill-color: #fff58c;
}
</style>
<body>
    <!-- 고객메뉴  -->
    <jsp:include page="/customer/inc/customerMenu.jsp"></jsp:include>
    
    <h1>리뷰작성</h1>
    <form method="post" action="/shop/customer/writeReviewAction.jsp">
        <input type="hidden" name="ordersNo" value="<%=ordersNo %>">
        <input type="hidden" name="cusId" value="<%=cusId %>">
        <input type="hidden" name="goodsTitle" value="<%=goodsTitle %>">
        <textarea name="content" rows="10" cols="50" placeholder="리뷰를 입력하세요."></textarea>
        <div class="star-rating space-x-4 mx-auto">
        	<input type="radio" id="5-stars" name="rating" value="5" v-model="ratings"/>
        	<label for="5-stars" class="star pr-4">★</label>
        	<input type="radio" id="4-stars" name="rating" value="4" v-model="ratings"/>
        	<label for="4-stars" class="star">★</label>
        	<input type="radio" id="3-stars" name="rating" value="3" v-model="ratings"/>
        	<label for="3-stars" class="star">★</label>
        	<input type="radio" id="2-stars" name="rating" value="2" v-model="ratings"/>
        	<label for="2-stars" class="star">★</label>
        	<input type="radio" id="1-star" name="rating" value="1" v-model="ratings" />
        	<label for="1-star" class="star">★</label>
        </div>
        <div>
            <button type="submit">리뷰작성</button>
        </div>
    </form>
</body>
</html>