package shop.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;


public class CustomerDAO {
	
	// 로그인 메서드
	public static HashMap<String, Object> loginCus(String cusId, String cusPw)
			throws Exception {
		HashMap<String, Object> resultMap = null;
		
		// DB 접근
		Connection conn = DBHelper.getConnection(); 
		
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
		conn.close();
		return resultMap;
	}
	
	// 회원 탈퇴 메서드
	public static void customerDelete(String cusId) throws Exception {
		Connection conn = DBHelper.getConnection();
		String sql = "DELETE FROM customer WHERE cus_id = ?";
		PreparedStatement stmt=conn.prepareStatement(sql);
		stmt.setString(1,cusId);
		stmt.executeUpdate();
		conn.close();
	}
	
	// 회원 정보 불러오기
	public static ArrayList<HashMap<String, Object>> cusInfo(String cusId) throws Exception {
		ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
		Connection conn = DBHelper.getConnection();
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
		conn.close();
		return list;
	}
	
	// id,pw확인(개인정보수정 접근용)
	public static boolean idPwCheck(String cusId, String pw) throws Exception {
		boolean check = false;
		Connection conn = DBHelper.getConnection(); 
		String sql = "select * FROM customer WHERE cus_id = ? and cus_pw = password(?)";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1,cusId);
		stmt.setString(2,pw);
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			check = true;
		}
		conn.close();
		return check;
	}
	
	// 회원가입 액션
	public static int insertCustomer(String id, String pw, String name, String birth, String gender) throws Exception {
		int row = 0;
		Connection conn = DBHelper.getConnection();
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
		 
		 conn.close();
		 return row;
	}
	
    // 회원정보 업데이트 메서드
	public static int customerModify(String cusPw, String cusName, String cusBirth, String gender, String cusAddress, String cusId) throws Exception {
		int row = 0;
		Connection conn = DBHelper.getConnection();
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