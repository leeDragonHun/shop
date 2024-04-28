package shop.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;


public class GoodsDAO {

	// 카테고리별 상품 갯수 메서드
	public static int goodsListCnt(String category, String searchWord) throws Exception{
		System.out.println("카테고리:" + category);
		System.out.println("검색조건:" + searchWord);
		
		// DB 연결
		Connection conn = DBHelper.getConnection();
		
		// 상품의 갯수를 반환
		// 카테고리가 선택되었다면 해당 카테고리를 where절에 추가
		// 검색어가 있다면 해당 검색어를 where절에 추가
		// 조건마다 추가될 sql이 다르기 때문에 메인sql 끝에 where 1=1을 해주어 무조건 where절이 있는 상태로 통과되도록 만들어 주었음.
		String sql = "select count(*) as cnt"
				+ " from goods"
				+ " where 1=1";
		if(category!=null && !category.equals("") && !(category.equals("all"))) { // 카테고리 조건
			sql += " and category ='"+category+"'";
		}
		if(searchWord != null && !searchWord.equals("")) { // 검색 조건
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
		ArrayList<HashMap<String, Object>> goodsList = new ArrayList<HashMap<String, Object>>();
		
		// DB 연결
		Connection conn = DBHelper.getConnection();
		
		// 상품의 정보를 모두 반화하여 목록을 보여줄 쿼리
		// 카테고리, 검색, 보기순서 값이 있다면 메인sql에 추가 되도록 하였음.
		// 조건마다 추가될 sql이 다르기 때문에 메인sql 끝에 where 1=1을 해주어 무조건 where절이 있는 상태로 통과되도록 만들어 주었음.
		String sql = "select goods_no goodsNo, goods_title goodsTitle, filename, goods_price goodsPrice, goods_amount goodsAmount"
				+ " from goods"
				+ " where 1=1";
		if(category!=null && !category.equals("") && !(category.equals("all"))) { // 카테고리 조건
			sql += " and category ='"+category+"'";
		}
		if(searchWord != null && !searchWord.equals("")) { // 검색조건
			sql += " and goods_title like '%"+searchWord+"%'";
		}
		if(order != null && !order.equals("") && !order.equals("null")) {
			sql += " order by";
			if(order.equals("new")) { // 최신순
				sql += " create_date desc";
			}else if(order.equals("high")) { // 높은가격순
				sql += " goods_price desc";
			}else if(order.equals("low")) { // 낮은가격순
				sql += " goods_price asc";
			}
		}
		sql += " limit ?, ?";
		
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, startRow);
		stmt.setInt(2, rowPerPage);
		
		ResultSet rs = stmt.executeQuery();
		
		while(rs.next()) {
			HashMap<String, Object> m = new HashMap<String, Object>();
			m.put("goodsNo", rs.getString("goodsNo"));
			m.put("goodsTitle", rs.getString("goodsTitle"));
			m.put("filename", rs.getString("filename"));
			m.put("goodsPrice", rs.getInt("goodsPrice"));
			m.put("goodsAmount", rs.getInt("goodsAmount"));
			goodsList.add(m);
		}
		
		System.out.println("goodsList : " + goodsList);
		conn.close();
		return goodsList;
	}
	
	// 카테고리 보여주는 메서드
	public static  ArrayList<HashMap<String, Object>> selectCategory() throws Exception {
		ArrayList<HashMap<String, Object>> categoryList = new ArrayList<HashMap<String, Object>>();
		
		Connection conn = DBHelper.getConnection();
		// 이전 쿼리문 : String sql1 = "select category, count(*) cnt from goods group by category order by category desc";
		// '기타' 가 맨 뒤에 오게.
		String sql1 = "SELECT category, COUNT(*) AS cnt FROM goods GROUP BY category ORDER BY CASE WHEN category = '기타' THEN 1 ELSE 0 END, category DESC";
		PreparedStatement stmt1 = conn.prepareStatement(sql1);
		ResultSet rs1 = stmt1.executeQuery();
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
	
	// 상품 수정 메서드
	public static int modifyGoods(int goodsNo, String category, String goodsTitle, String goodsContent, int goodsPrice, int goodsAmount) throws Exception {
		int row = 0;
		
		// DB 연결
		Connection conn = DBHelper.getConnection();
		
		// 상품 번호를 불러와 해당 데이터의 정보를 업데이트 해주는 쿼리
		String sql = "UPDATE goods SET category=?, goods_title=?, goods_content=?, goods_price=?, goods_amount=? WHERE goods_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, category);
		stmt.setString(2, goodsTitle);
		stmt.setString(3, goodsContent);
		stmt.setInt(4, goodsPrice);
		stmt.setInt(5, goodsAmount);
		stmt.setInt(6, goodsNo);
		row = stmt.executeUpdate();
		
		System.out.println(stmt);
		conn.close();
		return row;
	}
	
	// 상품 삭제 메서드
	public static int deleteGoods(int goodsNo) throws Exception {
		int row = 0;
		
		// DB 연결
		Connection conn = DBHelper.getConnection();
		
		// 상품 번호를 받아 해당 데이터를 삭제 해주는 쿼리
		String sql = "DELETE FROM goods WHERE goods_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, goodsNo);
		row = stmt.executeUpdate();
		
		System.out.println(stmt);
		conn.close();
		return row;
	}
	
	// 상품 삭제 할 때 톰캣서버로 올린 사진 파일의 이름 반환
	public static ResultSet goodsDeleteImg(int goodsNo) throws Exception {
		// DB 연결
		Connection conn = DBHelper.getConnection();
		
		// 상품번호를 받아 해당 상품의 사진 이름을 반환해준다.
	    String sql = "SELECT filename FROM goods WHERE goods_no= ?";
	    PreparedStatement stmt = null;
	    stmt = conn.prepareStatement(sql);
	    stmt.setInt(1, goodsNo);
	    ResultSet dfn = stmt.executeQuery();
		return dfn;
	}
	
	// 리뷰작성 메서드
	public static int writeReview(int ordersNo, String cusId, String goodsTitle, String content, int rating) throws Exception {
		int row = 0;
		
		// DB 연결
		Connection conn = DBHelper.getConnection();
		
		// 주문 번호가 pk인 쿼리. 상품 리뷰 데이터가 추가되는 쿼리이다.
		String sql = "INSERT INTO review"
				+ " (orders_no, cus_id, goods_title, content, rating, update_date, create_date)"
				+ " VALUES(?,?,?,?,?, now(), NOW())";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, ordersNo);
		stmt.setString(2, cusId);
		stmt.setString(3, goodsTitle);
		stmt.setString(4, content);
		stmt.setInt(5, rating);
		row = stmt.executeUpdate();
		
		System.out.println(stmt);
		conn.close();
		return row;
	}
	
	// 주문 메서드
	public static int goodsOrder(String goodsTitle, String cusId, int goodsNo, int ea) throws Exception {
		int row = 0;
		
		// DB 연결
		Connection conn = DBHelper.getConnection();
		
		// 주문 테이블에 해당 내용 추가
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
		
		// DB 연결
		Connection conn = DBHelper.getConnection();
		
		// 받아온 상품번호의 데이터를 업데이트 한다.
		// 이미 form에서 재고량 -1 주문량이 계산 완료된 데이터가 넘어와서 그 값으로 업데이트를 해주는 방식이다.
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
		
		// DB 연결
		Connection conn = DBHelper.getConnection();
		
		// 주문번호 값을 받아 state를 배송완료로 업데이트 해준다.
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
		
		// DB 연결
		Connection conn = DBHelper.getConnection();
		
		// 주문번호 값을 받아 state를 구매확정으로 업데이트 해준다.
		String sql = "UPDATE orders SET state = '구매확정' WHERE orders_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, ordersNo);
		row = stmt.executeUpdate();
		
		System.out.println(stmt);
		conn.close();
		return row;
	}
	
	// 구매확정 -> 리뷰완료
	// void를 이용해 보았다. 반환값이 필요 없게.
	public static void CompleteReview(int ordersNo) throws Exception {
		
		// DB 연결
		Connection conn = DBHelper.getConnection();
		
		// 주문번호 값을 받아 state를 리뷰완료로 업데이트 해준다.
		String sql = "UPDATE orders SET state = '리뷰완료' WHERE orders_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, ordersNo);
		stmt.executeUpdate();
		
		System.out.println(stmt);
		conn.close();
	}
	
	// 배송완료 목록 출력
	public static ArrayList <HashMap<String, Object>> allCompleteDelivery() throws Exception {
		ArrayList <HashMap<String, Object>> list = new ArrayList <HashMap<String, Object>>();
		
		// DB 연결
		Connection conn = DBHelper.getConnection();
		
		//  '배송완료'된 목록만 출력하는 게 아니다
		// 리뷰완료상태와 구매확정 상태도 배송이 완료된 시점이기 때문에 
		// 아래와 같이 '배송완료' or '리뷰완료' or '구매확정'을 where절에 넣었다.
		String sql = "SELECT orders_no, goods_title, cus_id, goods_no, ea, state"
				+ " FROM orders"
				+ " WHERE state = '배송완료' or state = '리뷰완료' or state = '구매확정'";
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
		
		System.out.println(list);
		conn.close();
		return list;
	}
	
	// 전체 결제완료 목록 출력
	public static ArrayList <HashMap<String, Object>> allCompletePayment() throws Exception {
		ArrayList <HashMap<String, Object>> list = new ArrayList <HashMap<String, Object>>();
		
		// DB 연결
		Connection conn = DBHelper.getConnection();
		
		// 주문 목록 중 state가 '결제완료'인 데이터만 출력
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
		
		System.out.println(list);
		conn.close();
		return list;
	}
	
	// 고객용 해당 고객 아이디의 결제완료 목록 출력
	public static ArrayList <HashMap<String, Object>> CompletePayment(String cusId) throws Exception {
		ArrayList <HashMap<String, Object>> list = new ArrayList <HashMap<String, Object>>();
		
		// DB 연결
		Connection conn = DBHelper.getConnection();
		
		// 주문 목록 중 state가 '결제완료'인 데이터만 출력
		// cus_id 값을 받아 해당 고객의 결제완료 목록만 출력한다.
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
		
		System.out.println(list);
		conn.close();
		return list;
	}
	
	// 고객용 해당 고객 아이디의 배송완료 목록 출력
	public static ArrayList <HashMap<String, Object>> CompleteDelivery(String cusId) throws Exception {
		ArrayList <HashMap<String, Object>> list = new ArrayList <HashMap<String, Object>>();
		
		// DB 연결
		Connection conn = DBHelper.getConnection();
		
		// 주문 목록 중 state가 '배송완료'인 데이터만 출력
		// cus_id 값을 받아 해당 고객의 배송완료 목록만 출력한다.
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
		
		System.out.println(list);
		conn.close();
		return list;
	}
	
	// 고객용 해당 고객 아이디의 구매확정 목록 출력
	public static ArrayList <HashMap<String, Object>> CompleteBuy(String cusId) throws Exception {
		ArrayList <HashMap<String, Object>> list = new ArrayList <HashMap<String, Object>>();
		
		// DB 연결
		Connection conn = DBHelper.getConnection();
		
		// 주문 목록 중 state가 '구매확정'인 데이터만 출력
		// cus_id 값을 받아 해당 고객의 구매확정 목록만 출력한다.
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
		
		System.out.println(list);
		conn.close();
		return list;
	}
	
	// 해당 고객이 작성한 리뷰데이터를 반환
	public static ArrayList <HashMap<String, Object>> myReview(String cusId) throws Exception {
		ArrayList <HashMap<String, Object>> list = new ArrayList <HashMap<String, Object>>();
		
		// DB 연결
		Connection conn = DBHelper.getConnection();
		
		// cus_id를 받아 해당 고객이 작성한 리뷰데이터를 반환
		String sql = "SELECT goods_title, content, rating"
				+ " FROM review"
				+ " WHERE cus_id = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1,cusId);
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			HashMap<String, Object> m = new HashMap<String, Object>();
			m.put("goodsTitle", rs.getString("goods_title"));
			m.put("content", rs.getString("content"));
			m.put("rating", rs.getInt("rating"));
			list.add(m);
		}
		
		System.out.println(list);
		conn.close();
		return list;
	}
	
	// 해당 상품의 리뷰 출력
	public static ArrayList <HashMap<String, Object>> goodsOneReview(int goodsNo) throws Exception {
		ArrayList <HashMap<String, Object>> list = new ArrayList <HashMap<String, Object>>();
		
		// DB 연결
		Connection conn = DBHelper.getConnection();
		
		// 후기 데이터를 받을건데
		// 어떤 상품의 데이터를 받을건지 goods_no를 받고
		// 주문목록과 리뷰목록에서 주문번호가 같은 데이터를 join하여
		// 후기 내용을 반환한다.
		String sql = "SELECT review.cus_id, orders.ea, review.content, review.rating"
				+ " FROM review"
				+ " INNER JOIN orders ON review.orders_no = orders.orders_no"
				+ " WHERE orders.goods_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1,goodsNo);
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			HashMap<String, Object> m = new HashMap<String, Object>();
			m.put("cusId", rs.getString("review.cus_id"));
			m.put("ea", rs.getInt("orders.ea"));
			m.put("content", rs.getString("review.content"));
			m.put("rating", rs.getInt("review.rating"));
			list.add(m);
		}
		
		System.out.println(list);
		conn.close();
		return list;
	}
}