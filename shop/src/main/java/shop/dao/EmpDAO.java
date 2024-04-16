package shop.dao;

import java.sql.*;
import java.util.*;

// emp 테이블을 CRUD하는 STATIC 메서드의 컨테이너
public class EmpDAO {
	public static int insertEmp(String empId, 
									String empPw, String empName, String empJob)
			throws Exception {
		int row = 0;
		// DB 접근
		Connection conn = DBHelper.getConnection(); 
		
		String sql = "insert ... ?, ?, ?,?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, empId);
		stmt.setString(2, empPw);
		stmt.setString(3, empName);
		stmt.setString(4, empJob);
		
		row = stmt.executeUpdate();
		
		conn.close();
		return row;
	}
	
	
	// HashMap<String, Object> : null이면 로그인실패, 아니면 성공
	// String empId, String empPw : 로그인폼에서 사용자가 입력한 id/pw
	
	// 호출코드 HashMap<String, Object> m = EmpDAO.empLogin("admin", "1234");
	// EMP로그인시 사용할 dao
	public static HashMap<String, Object> loginEmp(String empId, String empPw)
													throws Exception {
		HashMap<String, Object> resultMap = null;
		
		// DB 접근
		Connection conn = DBHelper.getConnection(); 
		
		String sql = "select emp_id empId, emp_name empName, grade FROM emp WHERE active = 'ON' and emp_id =? and emp_pw = password(?)";
		PreparedStatement stmt=conn.prepareStatement(sql);
		stmt.setString(1,empId);
		stmt.setString(2,empPw);
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			resultMap = new HashMap<String, Object>();
			resultMap.put("empId", rs.getString("empId"));
			resultMap.put("empName", rs.getString("empName"));
			resultMap.put("grade", rs.getInt("grade"));
		}
		conn.close();
		return resultMap;
	}
	
	// 전체 갯수 표시
	public static ResultSet allCnt() throws Exception {
	    PreparedStatement stmt4 = null;
	    ResultSet rs4 = null;
	    Connection conn = DBHelper.getConnection();
	    int count = 0;
        // 전체의 '갯수' 나타내기
        String sql4 = "SELECT COUNT(*) cnt FROM goods";
        stmt4 = conn.prepareStatement(sql4);
        rs4 = stmt4.executeQuery();
//        while (rs4.next()) {
//            count = rs4.getInt("cnt");
//        }
	    conn.close();
	    return rs4;
		}
	
}




























