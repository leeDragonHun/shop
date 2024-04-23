package shop.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;

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
	
	// id,pw확인(직원 개인정보수정 접근용)
	public static boolean idPwCheck(String empId, String pw) throws Exception {
		boolean check = false;
		Connection conn = DBHelper.getConnection(); 
		String sql = "select * FROM emp WHERE emp_id = ? and emp_pw = password(?)";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1,empId);
		stmt.setString(2,pw);
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			check = true;
		}
		conn.close();
		return check;
	}
	
	// 회원가입 액션
	public static int addEmp(String id, String pw, String name) throws Exception {
		int row = 0;
		Connection conn = DBHelper.getConnection();
		String sql = "insert into emp(emp_id, grade, emp_pw, emp_name, emp_job, hire_date, update_date, create_date)"
				+ " VALUES (?, '0', PASSWORD(?), ?, '사원', now(), now(), NOW())";

		 PreparedStatement stmt = conn.prepareStatement(sql);
		 stmt.setString(1, id);
		 stmt.setString(2, pw);
		 stmt.setString(3, name);
		 row = stmt.executeUpdate();
		 
		 conn.close();
		 return row;
	}
	
    // 직원 비밀번호 업데이트 메서드
	public static int empPwModify(String empId, String empPw) throws Exception {
		int row = 0;
		Connection conn = DBHelper.getConnection();
		String sql = "UPDATE emp SET emp_pw = PASSWORD(?) WHERE emp_id = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, empPw);
		stmt.setString(2, empId);
		row = stmt.executeUpdate();
		System.out.println(stmt);
		
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
		
		String sql = "select emp_id empId, emp_name empName, grade, emp_job empJob, hire_date hireDate FROM emp WHERE active = 'ON' and emp_id =? and emp_pw = password(?)";
		PreparedStatement stmt=conn.prepareStatement(sql);
		stmt.setString(1,empId);
		stmt.setString(2,empPw);
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			resultMap = new HashMap<String, Object>();
			resultMap.put("empId", rs.getString("empId"));
			resultMap.put("empName", rs.getString("empName"));
			resultMap.put("grade", rs.getInt("grade"));
			resultMap.put("empJob", rs.getString("empJob"));
			resultMap.put("hireDate", rs.getString("hireDate"));
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
	    conn.close();
	    return rs4;
		}
	
	// emp totalRow 구하기
	public static int totalRow() throws Exception {
		int totalRow = 0;
		Connection conn = DBHelper.getConnection();
	    String totalRowSql = "select count(*) from emp";
	    PreparedStatement totalRowStmt = conn.prepareStatement(totalRowSql);
	    ResultSet totalRowRs = totalRowStmt.executeQuery();
	    // 전체줄 수(게시글) = 일단 0으로 선언하고. totalRowSql에 count(*)로 몇개인지에 따라 값이 정해짐
		if(totalRowRs.next()) {
			totalRow = totalRowRs.getInt("count(*)");
		}
		System.out.println("totalRow : " + totalRow);
		conn.close();
		return totalRow;
	}
	
	// customer totalRow 구하기
	public static int cusTotalRow() throws Exception {
		int totalRow = 0;
		Connection conn = DBHelper.getConnection();
		String totalRowSql = "select count(*) from customer";
		PreparedStatement totalRowStmt = conn.prepareStatement(totalRowSql);
		ResultSet totalRowRs = totalRowStmt.executeQuery();
		// 전체줄 수(게시글) = 일단 0으로 선언하고. totalRowSql에 count(*)로 몇개인지에 따라 값이 정해짐
		if(totalRowRs.next()) {
			totalRow = totalRowRs.getInt("count(*)");
		}
		System.out.println(totalRow + " <-- totalRow");
		conn.close();
		return totalRow;
	}
	
	// 직원 목록 조회
	public static ArrayList<HashMap<String,Object>> list(int startRow, int rowPerPage) throws Exception{
		PreparedStatement stmt = null;
		ResultSet rs = null;
		Connection conn = DBHelper.getConnection();
		String sql = "SELECT emp_id empId, grade, emp_name empName, emp_job empJob, hire_date hireDate, active FROM emp order by emp_id asc limit ?, ?";
	    stmt = conn.prepareStatement(sql);
		stmt.setInt(1, startRow); // (현재페이지 -1)에서 곱하기 rowperPage를 해주면 n번째 페이지의 첫째로 오는 게시글의 순번 즉, 몇번째글인지 계산할 수 있다.
		stmt.setInt(2, rowPerPage); // 두번째 물음표에는 '그래서 몇개 보여줄지' 가 정해진다. 말그대로 rowperPage
	    rs = stmt.executeQuery();
	    
	    ArrayList<HashMap<String, Object>> list
	     = new ArrayList<HashMap<String, Object>>();
	    
	    // ResultSet -> ArrayList<HashMap<String, Object>>
	    while(rs.next()){
	    	HashMap<String, Object> m = new HashMap<String, Object>();
	        m.put("empId", rs.getString("empId"));
	        m.put("grade", rs.getString("grade"));
	        m.put("empName", rs.getString("empName"));
	        m.put("empJob", rs.getString("empJob"));
	        m.put("hireDate", rs.getString("hireDate"));
	        m.put("active", rs.getString("active"));
	        list.add(m);
	    }
	    conn.close();
		return list;
	}
	
	// 고객 목록 조회
	public static ArrayList<HashMap<String,Object>> cusList(int startRow, int rowPerPage) throws Exception{
		PreparedStatement stmt = null;
		ResultSet rs = null;
		Connection conn = DBHelper.getConnection();
		String sql = "SELECT cus_id cusId, cus_name cusName, birth, gender FROM customer order by create_date asc limit ?, ?";
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1, startRow); // (현재페이지 -1)에서 곱하기 rowperPage를 해주면 n번째 페이지의 첫째로 오는 게시글의 순번 즉, 몇번째글인지 계산할 수 있다.
		stmt.setInt(2, rowPerPage); // 두번째 물음표에는 '그래서 몇개 보여줄지' 가 정해진다. 말그대로 rowperPage
		rs = stmt.executeQuery();
		
		ArrayList<HashMap<String, Object>> list
		= new ArrayList<HashMap<String, Object>>();
		
		// ResultSet -> ArrayList<HashMap<String, Object>>
		while(rs.next()){
			HashMap<String, Object> m = new HashMap<String, Object>();
			m.put("cusId", rs.getString("cusId"));
			m.put("cusName", rs.getString("cusName"));
			m.put("birth", rs.getString("birth"));
			m.put("gender", rs.getString("gender"));
			list.add(m);
		}
		conn.close();
		return list;
	}
	
	// active권한 체인지(on->off, off->on) (a태그용)
	public static int change(String active, String empId) throws Exception {
		int row = 0;
		Connection conn = DBHelper.getConnection();
		String sql = "update emp set active = ? where emp_id = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, active);
		stmt.setString(2, empId);
		System.out.println("stmt : " + stmt);
		row = stmt.executeUpdate();
		conn.close();
		return row;
	}
	
	// active권한 off->on (input에 아이디 입력해서 바꾸는 용)
	public static int offOn(String requestEmp) throws Exception {
		int row = 0;
	    Connection conn = DBHelper.getConnection();
		PreparedStatement stmt = null;
		String sql = "UPDATE emp SET ACTIVE='ON' WHERE emp_id = ? ";
	    stmt = conn.prepareStatement(sql);
	    stmt.setString(1,requestEmp);
	    System.out.println("stmt : " + stmt);
	    row = stmt.executeUpdate();
	    conn.close();
	    return row;
	}
	
	// active권한 on->off (input에 아이디 입력해서 바꾸는 용)	
	public static int onOff(String retireEmp) throws Exception {
		int row = 0;
		Connection conn = DBHelper.getConnection();
		PreparedStatement stmt = null;
		String sql = "UPDATE emp SET ACTIVE='OFF' WHERE emp_id = ? ";
		stmt = conn.prepareStatement(sql);
		stmt.setString(1,retireEmp);
		System.out.println("stmt : " + stmt);
		row = stmt.executeUpdate();
		conn.close();
		return row;
	}
	
	// 카테고리 리스트 출력
	public static ArrayList<HashMap<String, Object>> categoryList() throws Exception {
		ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
	    PreparedStatement stmt1 = null;
	    ResultSet rs1 = null;
	    Connection conn = DBHelper.getConnection();
	    String sql1 = "select category from category order by create_date asc";
	    stmt1 = conn.prepareStatement(sql1);
	    rs1 = stmt1.executeQuery();
	    while(rs1.next()) {
	        HashMap<String, Object> m = new HashMap<String, Object>();
	        m.put("category", rs1.getString("category"));
	        list.add(m);
	    }
		return list;
	}
	
	// 카테고리 추가
	public static int insertCategory(String categoryName) throws Exception {
		int row = 0;
		Connection conn = DBHelper.getConnection();
		String sql = "INSERT INTO category(category) VALUES(?)";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, categoryName);
		row = stmt.executeUpdate();
		return row;
	}
	
	// 카테고리 삭제
	public static int deleteCategory(String categoryName) throws Exception {
		Connection conn = DBHelper.getConnection();
		String sql = "DELETE FROM category WHERE category = ?";
		PreparedStatement stmt = null;
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, categoryName);
		int row = stmt.executeUpdate();
		return row;
	}
	
	// 톰캣서버로 올린 파일 삭제
	public static ResultSet deleteFileName(String categoryName) throws Exception {
		Connection conn = DBHelper.getConnection();    
	    String sql2 = "SELECT filename FROM goods WHERE category= ?";
	    PreparedStatement stmt2 = null;
	    stmt2 = conn.prepareStatement(sql2);
	    stmt2.setString(1, categoryName);
	    ResultSet dfn = stmt2.executeQuery();
		return dfn;
	}
}




























