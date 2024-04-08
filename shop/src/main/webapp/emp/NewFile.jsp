<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
String sql2 = null;
String totalRowSql = null;
String category = "후플푸프";
String searchWord ="양말";
sql2 = "select goods_title goodsTitle, filename, goods_price goodsPrice, goods_amount goodsAmount from goods where 1=1 "; // 전체출력
if(category != null || !category.equals("all")){ // 카테고리출력
	sql2 += " and category = '" + category + "'";
}
if(searchWord != null || !searchWord.equals("")){
  sql2 += " and goods_title like '%"+searchWord+ "%'";   
}
sql2 += " order by update_date desc limit ?, ?";
%>