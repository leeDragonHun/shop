<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.net.*"%>
<%@ page import="shop.dao.*" %>
<%
    System.out.println("=====modifyGoods.jsp===========================================");
    // 인증분기  : 세션변수 이름 - loginEmp
    if(session.getAttribute("loginEmp") == null) {
        response.sendRedirect("/shop/emp/empLoginForm.jsp");
        return;
    }
    
    // goods_no int타입으로 요청
    int goodsNo = Integer.parseInt(request.getParameter("goodsNo"));
    System.out.println("상품번호 넘어온 값 : " + goodsNo);
    
    // 카테고리 리스트 불러오는 메서드
    ArrayList<HashMap<String, Object>> list = EmpDAO.categoryList();
    
    // GoodsDAO에서 goods의 DB 가져오기(where = goodsNo) 인것.
    ArrayList<HashMap<String, Object>> showGoods = GoodsDAO.showGoodsOne(goodsNo);
    System.out.println("showGoods : " + showGoods);
%>
<!DOCTYPE html>
<html>
	<head>
	<meta charset="UTF-8">
	<title>상품 수정</title>
    <link rel="shortcut icon" href="/shop/mindMap/d.ico" type="image/x-icon">
    <link rel="icon" href="/shop/mindMap/d.ico" type="image/x-icon">
</head>
<body>
    <!-- 메인메뉴 -->
    <div>
        <jsp:include page="/emp/inc/empMenu.jsp"></jsp:include>
    </div>
    <h1>상품수정</h1>
    <form method="post" action="/shop/emp/modifyGoodsAction.jsp">
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
            <td>
            <input type="text" name="goodsNo" value="<%=(Integer) (m.get("goodsNo"))%>">
            </td>
            <td>
              <select name="category">
                <%
                    for(HashMap c : list){
                %>
                        <option value="<%=(String)(c.get("category"))%>"><%=c%></option>
                <%       
                    }
                %>
                </select>
            </td>
            <td>
            <input type="text" name="goodsTitle" value="<%=(String) (m.get("goodsTitle"))%>">
            </td>
            <td>
                <img alt="상품사진" src="/shop/upload/<%=(String)(m.get("filename")) %>" style="width:100%; height:100%;">
            </td>
            <td>
                <textarea rows="5" cols="50" name="goodsContent"><%=(String) (m.get("goodsContent"))%></textarea>
            </td>
            <td>
                <input type="text" name="goodsPrice" value="<%=(Integer) (m.get("goodsPrice"))%>">
            </td>
            <td>
                <input type="text" name="goodsAmount" value="<%=(Integer) (m.get("goodsAmount"))%>">
            </td>
        </tr>
        <%
            }
        %>
        </table>
        <button type="submit">수정하기</button>
    </form>
</body>
</html>