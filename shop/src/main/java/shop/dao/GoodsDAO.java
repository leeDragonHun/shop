package shop.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;


public class GoodsDAO {
/*	public static ArrayList<HashMap<String, Object>> selectGoodsList( // 스타트로우랑 로우퍼페이지로 페이징하는 매소드의 DAO
					int startRow, int rowPerPage) throws Exception {
		ArrayList<HashMap<String, Object>> list =
				new ArrayList<HashMap<String, Object>>();
		
		Connection conn = DBHelper.getConnection();
		String sql = "select *"
				+ " from goods"
				+ " order by create_date desc"
				+ " limit ?, ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, startRow);
		stmt.setInt(2, rowPerPage);
		
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			HashMap<String, Object> m = new HashMap<String, Object>();
			m.put("startRow", rs.getString(startRow));
			m.put("rowPerPage", rs.getString(rowPerPage));
			list.add(m);
		}
		conn.close();
		return list;
	}*/
	//GoodsDAO.goodsList("","");
	
	public static int goodsListCnt(String category, String searchWord) throws Exception{
		System.out.println("카테고리:" + category);
		System.out.println("검색조건:" + searchWord);
		
		Connection conn = DBHelper.getConnection();
		String sql = "select count(*) as cnt"
				+ " from goods"
				+ " where 1=1";
		if(category!=null && !category.equals("") && !(category.equals("all"))) {
			sql += " and category ='"+category+"'";
		}
		if(searchWord != null && !searchWord.equals("")) {
			sql += " and goods_title like '%"+searchWord+"%'";
		}		
		PreparedStatement stmt = conn.prepareStatement(sql);
		ResultSet rs = stmt.executeQuery();
		rs.next();
		conn.close();
		return rs.getInt("cnt");
	}
	
	
	
	public static  ArrayList<HashMap<String, Object>> selectGoodsList(String category, String searchWord, String order, int startRow, int rowPerPage ) throws Exception {

		Connection conn = DBHelper.getConnection();
		String sql = "select goods_title goodsTitle, filename, goods_price goodsPrice, goods_amount goodsAmount"
				+ " from goods"
				+ " where 1=1";
		if(category!=null && !category.equals("") && !(category.equals("all"))) {
			sql += " and category ='"+category+"'";
		}
		if(searchWord != null && !searchWord.equals("")) {
			sql += " and goods_title like '%"+searchWord+"%'";
		}
		if(order != null && !order.equals("") && !order.equals("null")) {
			sql += " order by";
			if(order.equals("new")) {
				sql += " create_date desc";
			}else if(order.equals("high")) {
				sql += " goods_price desc";
			}else if(order.equals("low")) {
				sql += " goods_price asc";
			}
		}
		sql += " limit ?, ?";
		
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, startRow);
		stmt.setInt(2, rowPerPage);
		
		ResultSet rs = stmt.executeQuery();
		
		ArrayList<HashMap<String, Object>> goodsList = new ArrayList<HashMap<String, Object>>();
		while(rs.next()) {
			HashMap<String, Object> m = new HashMap<String, Object>();
			m.put("goodsTitle", rs.getString("goodsTitle"));
			m.put("filename", rs.getString("filename"));
			m.put("goodsPrice", rs.getInt("goodsPrice"));
			m.put("goodsAmount", rs.getInt("goodsAmount"));
			goodsList.add(m);
		}
		conn.close();
		return goodsList;
	}
	
	public static  ArrayList<HashMap<String, Object>> selectCategory() throws Exception {
		Connection conn = DBHelper.getConnection();
		String sql1 = "select category, count(*) cnt from goods group by category order by create_date asc";
		PreparedStatement stmt1 = conn.prepareStatement(sql1);
		ResultSet rs1 = stmt1.executeQuery();
		ArrayList<HashMap<String, Object>> categoryList =
				new ArrayList<HashMap<String, Object>>();
		while(rs1.next()) {
			HashMap<String, Object> m = new HashMap<String, Object>();
			m.put("category", rs1.getString("category"));
			m.put("cnt", rs1.getInt("cnt"));
			categoryList.add(m);
		}
		System.out.println("categoryList : " + categoryList);
		conn.close();
		return categoryList;
	}
	
}
