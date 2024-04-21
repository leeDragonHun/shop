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
	
	// 카테고리별 상품 갯수 메서드
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
	
	
	// 상품목록 보여주는 메서드(검색조건, 카테고리조건, 보여주기 순서, 페이징기능)
	public static ArrayList<HashMap<String, Object>> selectGoodsList(String category, String searchWord, String order, int startRow, int rowPerPage ) throws Exception {

		Connection conn = DBHelper.getConnection();
		String sql = "select goods_no goodsNo, goods_title goodsTitle, filename, goods_price goodsPrice, goods_amount goodsAmount"
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
			m.put("goodsNo", rs.getString("goodsNo"));
			m.put("goodsTitle", rs.getString("goodsTitle"));
			m.put("filename", rs.getString("filename"));
			m.put("goodsPrice", rs.getInt("goodsPrice"));
			m.put("goodsAmount", rs.getInt("goodsAmount"));
			goodsList.add(m);
		}
		conn.close();
		return goodsList;
	}
	
	// 카테고리 보여주는 메서드
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
	
	// 상품 상세보기 메서드
	public static ArrayList<HashMap<String, Object>> showGoodsOne(int goodsNo) throws Exception { 
		Connection conn = DBHelper.getConnection();
		String sql = "SELECT goods_no goodsNo, category, goods_title goodsTitle, filename, goods_content goodsContent, goods_price GoodsPrice, goods_amount goodsAmount"
				+ " FROM goods"
				+ " WHERE goods_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, goodsNo);
		ResultSet rs = stmt.executeQuery();
		
		ArrayList<HashMap<String, Object>> goodsOne = new ArrayList<HashMap<String, Object>>();
		while(rs.next()) {
			HashMap<String, Object> m = new HashMap<String, Object>();
			m.put("goodsNo", rs.getInt("goodsNo"));
			m.put("category", rs.getString("category"));
			m.put("goodsTitle", rs.getString("goodsTitle"));
			m.put("filename", rs.getString("filename"));
			m.put("goodsContent", rs.getString("goodsContent"));
			m.put("goodsPrice", rs.getInt("goodsPrice"));
			m.put("goodsAmount", rs.getInt("goodsAmount"));
			goodsOne.add(m);
		}
		conn.close();
		return goodsOne;
	}
	
	// 주문 메서드
	public static int goodsOrder(String goodsTitle, String cusId, int goodsNo, int ea) throws Exception {
		int row = 0;
		Connection conn = DBHelper.getConnection();
		String sql = "INSERT INTO orders(cus_id, goods_title, goods_no, ea)"
				+ " VALUES(?,?,?,?)";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, cusId);
		stmt.setString(2, goodsTitle);
		stmt.setInt(3, goodsNo);
		stmt.setInt(4, ea);
		row = stmt.executeUpdate();
		System.out.println(stmt);
		
		conn.close();
		return row;
	}
	
	// 재고 처리( 주문량1 이면 재고량-1)
	public static int AmountMinusEa(int AmountMinus, int goodsNo) throws Exception {
		int row = 0;
		Connection conn = DBHelper.getConnection();
		String sql = "UPDATE goods SET goods_amount=? WHERE goods_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, AmountMinus);
		stmt.setInt(2, goodsNo);
		row = stmt.executeUpdate();
		System.out.println(stmt);
		
		conn.close();
		return row;
	}
	
	// 결제완료 -> 배송완료
	public static int CompleteDelivery(int ordersNo) throws Exception {
		int row = 0;
		Connection conn = DBHelper.getConnection();
		String sql = "UPDATE orders SET state = '배송완료' WHERE orders_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, ordersNo);
		row = stmt.executeUpdate();
		System.out.println(stmt);
		conn.close();
		return row;
	}
	
	// 배송완료 -> 구매확정
	public static int CompleteBuy(int ordersNo) throws Exception {
		int row = 0;
		Connection conn = DBHelper.getConnection();
		String sql = "UPDATE orders SET state = '구매확정' WHERE orders_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, ordersNo);
		row = stmt.executeUpdate();
		System.out.println(stmt);
		conn.close();
		return row;
	}
	
	// 전체 배송완료 목록 출력
	public static ArrayList <HashMap<String, Object>> allCompleteDelivery() throws Exception {
		ArrayList <HashMap<String, Object>> list = new ArrayList <HashMap<String, Object>>();
		Connection conn = DBHelper.getConnection();
		String sql = "SELECT orders_no, goods_title, cus_id, goods_no, ea, state"
				+ " FROM orders"
				+ " WHERE state = '배송완료'";
		PreparedStatement stmt = conn.prepareStatement(sql);
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			HashMap<String, Object> m = new HashMap<String, Object>();
			m.put("ordersNo", rs.getInt("orders_no"));
			m.put("goodsTitle", rs.getString("goods_title"));
			m.put("cusId", rs.getString("cus_id"));
			m.put("goodsNo", rs.getInt("goods_no"));
			m.put("ea", rs.getInt("ea"));
			m.put("state", rs.getString("state"));
			list.add(m);
		}
		conn.close();
		return list;
	}
	
	// 전체 결제완료 목록 출력
	public static ArrayList <HashMap<String, Object>> allCompletePayment() throws Exception {
		ArrayList <HashMap<String, Object>> list = new ArrayList <HashMap<String, Object>>();
		Connection conn = DBHelper.getConnection();
		String sql = "SELECT orders_no, goods_title, cus_id, goods_no, ea, state"
				+ " FROM orders"
				+ " WHERE state = '결제완료'";
		PreparedStatement stmt = conn.prepareStatement(sql);
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			HashMap<String, Object> m = new HashMap<String, Object>();
			m.put("ordersNo", rs.getInt("orders_no"));
			m.put("goodsTitle", rs.getString("goods_title"));
			m.put("cusId", rs.getString("cus_id"));
			m.put("goodsNo", rs.getInt("goods_no"));
			m.put("ea", rs.getInt("ea"));
			m.put("state", rs.getString("state"));
			list.add(m);
		}
		conn.close();
		return list;
	}
	
	// 결제완료 목록 출력
	public static ArrayList <HashMap<String, Object>> CompletePayment(String cusId) throws Exception {
		ArrayList <HashMap<String, Object>> list = new ArrayList <HashMap<String, Object>>();
		Connection conn = DBHelper.getConnection();
		String sql = "SELECT orders_no, goods_title, goods_no, ea, state"
				+ " FROM orders"
				+ " WHERE cus_id = ? AND state = '결제완료'";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1,cusId);
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			HashMap<String, Object> m = new HashMap<String, Object>();
			m.put("ordersNo", rs.getInt("orders_no"));
			m.put("goodsTitle", rs.getString("goods_title"));
			m.put("goodsNo", rs.getInt("goods_no"));
			m.put("ea", rs.getInt("ea"));
			m.put("state", rs.getString("state"));
			list.add(m);
		}
		conn.close();
		return list;
	}
	
	// 배송완료 목록 출력
	public static ArrayList <HashMap<String, Object>> CompleteDelivery(String cusId) throws Exception {
		ArrayList <HashMap<String, Object>> list = new ArrayList <HashMap<String, Object>>();
		Connection conn = DBHelper.getConnection();
		String sql = "SELECT orders_no, goods_title, goods_no, ea, state"
				+ " FROM orders"
				+ " WHERE cus_id = ? AND state = '배송완료'";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1,cusId);
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			HashMap<String, Object> m = new HashMap<String, Object>();
			m.put("ordersNo", rs.getInt("orders_no"));
			m.put("goodsTitle", rs.getString("goods_title"));
			m.put("goodsNo", rs.getInt("goods_no"));
			m.put("ea", rs.getInt("ea"));
			m.put("state", rs.getString("state"));
			list.add(m);
		}
		conn.close();
		return list;
	}
	
	// 구매확정 목록 출력
	public static ArrayList <HashMap<String, Object>> CompleteBuy(String cusId) throws Exception {
		ArrayList <HashMap<String, Object>> list = new ArrayList <HashMap<String, Object>>();
		Connection conn = DBHelper.getConnection();
		String sql = "SELECT orders_no, goods_title, goods_no, ea, state"
				+ " FROM orders"
				+ " WHERE cus_id = ? AND state = '구매확정'";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1,cusId);
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			HashMap<String, Object> m = new HashMap<String, Object>();
			m.put("ordersNo", rs.getInt("orders_no"));
			m.put("goodsTitle", rs.getString("goods_title"));
			m.put("goodsNo", rs.getInt("goods_no"));
			m.put("ea", rs.getInt("ea"));
			m.put("state", rs.getString("state"));
			list.add(m);
		}
		conn.close();
		return list;
	}
	
	// 리뷰완료 목록 출력
	public static ArrayList <HashMap<String, Object>> CompleteReview(String cusId) throws Exception {
		ArrayList <HashMap<String, Object>> list = new ArrayList <HashMap<String, Object>>();
		Connection conn = DBHelper.getConnection();
		String sql = "SELECT orders_no, goods_title, goods_no, ea, state"
				+ " FROM orders"
				+ " WHERE cus_id = ? AND state = '리뷰완료'";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1,cusId);
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			HashMap<String, Object> m = new HashMap<String, Object>();
			m.put("ordersNo", rs.getInt("orders_no"));
			m.put("goodsTitle", rs.getString("goods_title"));
			m.put("goodsNo", rs.getInt("goods_no"));
			m.put("ea", rs.getInt("ea"));
			m.put("state", rs.getString("state"));
			list.add(m);
		}
		conn.close();
		return list;
	}
}




































