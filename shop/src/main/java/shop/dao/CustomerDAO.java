package shop.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;


public class CustomerDAO {
	// 로그인 메서드
	// 호출 : customerLoginAction.jsp
	// parma : String(id), String(pw)
	// return : HashMap(id, name)
	public static HashMap<String, Object> loginCus(String cusId, String cusPw)
			throws Exception {
		HashMap<String, Object> resultMap = null;
		
		// DB 접근
		Connection conn = DBHelper.getConnection(); 
		
		String sql = "select cus_id, cus_name FROM customer WHERE cus_id =? and cus_pw = password(?)";
		PreparedStatement stmt=conn.prepareStatement(sql);
		stmt.setString(1,cusId);
		stmt.setString(2,cusPw);
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
		resultMap = new HashMap<String, Object>();
		resultMap.put("cus_id", rs.getString("cus_id"));
		resultMap.put("cus_name", rs.getString("cus_name"));
		}
		conn.close();
		return resultMap;
	}
	
	// 회원가입 액션
	// 호출 : insertCustomerAction.jsp
	// param : customer ...
	// return : int(입력실패 0, 성공이면 1
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

}
