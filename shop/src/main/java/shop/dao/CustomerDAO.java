package shop.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;

// 고객 파트 DAO
public class CustomerDAO {
	
	// 로그인 메서드
	public static HashMap<String, Object> loginCus(String cusId, String cusPw) throws Exception {
		HashMap<String, Object> resultMap = null;
		
		// DB 연결
		Connection conn = DBHelper.getConnection(); 
		
		// 로그인 id와 pw가 일치하는 데이터가 있으면 HashMap을 통해 해당 데이터의 정보를 반환하는 쿼리
		String sql = "select * FROM customer WHERE cus_id =? and cus_pw = password(?)";
		PreparedStatement stmt=conn.prepareStatement(sql);
		stmt.setString(1,cusId);
		stmt.setString(2,cusPw);
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
		resultMap = new HashMap<String, Object>();
		resultMap.put("cus_id", rs.getString("cus_id"));
		resultMap.put("cus_name", rs.getString("cus_name"));
		resultMap.put("birth", rs.getString("birth"));
		resultMap.put("gender", rs.getString("gender"));
		resultMap.put("address", rs.getString("address"));
		}
		
		System.out.println(stmt);
		conn.close();
		return resultMap;
	}
	
	// 회원 탈퇴 메서드(void이용 반환값은 없고 결과만 처리)
	public static void customerDelete(String cusId) throws Exception {

		// DB 연결
		Connection conn = DBHelper.getConnection();
		
		// cus_id를 받아 해당하는 데이터 삭제하는 쿼리
		String sql = "DELETE FROM customer WHERE cus_id = ?";
		PreparedStatement stmt=conn.prepareStatement(sql);
		stmt.setString(1,cusId);
		stmt.executeUpdate();
		
		System.out.println(stmt);
		conn.close();
	}
	
	// 회원 정보 불러오기
	public static ArrayList<HashMap<String, Object>> cusInfo(String cusId) throws Exception {
		ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
		
		// DB 연결
		Connection conn = DBHelper.getConnection();
		
		// cus_id값을 받아 해당하는 데이터의 정보를 반환하는 쿼리
		String sql = "select * FROM customer WHERE cus_id =?";
		PreparedStatement stmt=conn.prepareStatement(sql);
		stmt.setString(1,cusId);
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			HashMap<String, Object> m = new HashMap<String, Object>();
			m = new HashMap<String, Object>();
			m.put("cus_id", rs.getString("cus_id"));
			m.put("cus_name", rs.getString("cus_name"));
			m.put("birth", rs.getString("birth"));
			m.put("gender", rs.getString("gender"));
			m.put("address", rs.getString("address"));
			list.add(m);
		}
		
		System.out.println(stmt);
		conn.close();
		return list;
	}
	
	// id,pw확인(개인정보수정 접근용)
	public static boolean idPwCheck(String cusId, String pw) throws Exception {
		boolean check = false;
		
		// DB 연결
		Connection conn = DBHelper.getConnection(); 
		
		// id,pw값을 받아 맞는지 체크하여 boolean타입 반환
		String sql = "select * FROM customer WHERE cus_id = ? and cus_pw = password(?)";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1,cusId);
		stmt.setString(2,pw);
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			check = true;
		}
		
		System.out.println(stmt);
		conn.close();
		return check;
	}
	
	// 회원가입 액션
	public static int insertCustomer(String id, String pw, String name, String birth, String gender) throws Exception {
		int row = 0;
		
		// DB 연결
		Connection conn = DBHelper.getConnection();
		
		// 회원가입 form에서 받아낸 회원가입할 정보들을 아래 쿼리에 넣어 customer테이블에 데이터 추가(즉, 회원가입)
		String sql = "insert into customer("
				+ "cus_id, cus_pw, cus_name, birth, gender,"
				+ " update_date, create_date) values ("
				+ "?,PASSWORD(?),?,?,?,now(),now())";

		 PreparedStatement stmt = conn.prepareStatement(sql);
		 stmt.setString(1, id);
		 stmt.setString(2, pw);
		 stmt.setString(3, name);
		 stmt.setString(4, birth);
		 stmt.setString(5, gender);
		 row = stmt.executeUpdate();
		 
		 System.out.println(stmt);
		 conn.close();
		 return row;
	}
	
    // 회원정보 업데이트 메서드
	public static int customerModify(String cusPw, String cusName, String cusBirth, String gender, String cusAddress, String cusId) throws Exception {
		int row = 0;
		
		// DB 연결
		Connection conn = DBHelper.getConnection();
		
		// where절에 us_id를 받아 해당하는 데이터에 정보들을 업데이트할 쿼리 
		String sql = "UPDATE customer SET cus_pw = PASSWORD(?), cus_name = ?, birth = ?, gender = ?, address = ? WHERE cus_id = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, cusPw);
		stmt.setString(2, cusName);
		stmt.setString(3, cusBirth);
		stmt.setString(4, gender);
		stmt.setString(5, cusAddress);
		stmt.setString(6, cusId);
		row = stmt.executeUpdate();
		
		System.out.println(stmt);		
		conn.close();
		return row;
	}

}