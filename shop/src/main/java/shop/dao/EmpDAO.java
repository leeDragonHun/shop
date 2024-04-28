package shop.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;

// emp 테이블을 CRUD하는 STATIC 메서드의 컨테이너
public class EmpDAO {
	
	// id, pw확인(직원 개인정보수정 접근용)
	public static boolean idPwCheck(String empId, String pw) throws Exception {
		boolean check = false;
		
		// DB 연결
		Connection conn = DBHelper.getConnection();
		
		// id,pw값 받아 boolean 으로 반환
		String sql = "select * FROM emp WHERE emp_id = ? and emp_pw = password(?)";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1,empId);
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
	public static int addEmp(String id, String pw, String name) throws Exception {
		int row = 0;
		
		// DB 연결
		Connection conn = DBHelper.getConnection();
		
		// 회원가입 form에서 받아낸 회원가입할 정보들을 아래 쿼리에 넣어 emp테이블에 데이터 추가(즉, 회원가입)
		// 처음 가입시 active가 off로 되기 때문에 팀장이 로그인하여 on으로 바꾸어 줘야 로그인가능
		// 처음 가입시 사원 부여.
		String sql = "insert into emp(emp_id, grade, emp_pw, emp_name, emp_job, hire_date, update_date, create_date)"
				+ " VALUES (?, '0', PASSWORD(?), ?, '사원', now(), now(), NOW())";

		 PreparedStatement stmt = conn.prepareStatement(sql);
		 stmt.setString(1, id);
		 stmt.setString(2, pw);
		 stmt.setString(3, name);
		 row = stmt.executeUpdate();
		 
		 System.out.println(stmt);
		 conn.close();
		 return row;
	}
	
    // 직원 비밀번호 업데이트 메서드
	public static int empPwModify(String empId, String empPw) throws Exception {
		int row = 0;
		
		// DB 연결
		Connection conn = DBHelper.getConnection();
		
		// emp_id를 받아 where절에 채우고 변경할 pw를 업데이트문의 password(?) 에 채워 비밀번호 변경
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
	public static HashMap<String, Object> loginEmp(String empId, String empPw) throws Exception {
		HashMap<String, Object> resultMap = null;
		
		// DB 연결
		Connection conn = DBHelper.getConnection(); 
		
		// emp_id와 pw를 받는다. 추가로 where에 active가 ON인 것도 추가하여 로그인 가능하게 한다.
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
		
		System.out.println(stmt);
		conn.close();
		return resultMap;
	}
	
	// 전체 갯수 표시
	public static ResultSet allCnt() throws Exception {
		ResultSet rs4 = null;
	    PreparedStatement stmt4 = null;
	    int count = 0;
	    
	    // DB 연결
	    Connection conn = DBHelper.getConnection();
	    
        // 굿즈 전체의 '갯수' 나타내기
        String sql4 = "SELECT COUNT(*) cnt FROM goods";
        stmt4 = conn.prepareStatement(sql4);
        rs4 = stmt4.executeQuery();
        
        System.out.println(stmt4);
	    conn.close();
	    return rs4;
		}
	
	// emp totalRow 구하기
	public static int totalRow() throws Exception {
		int totalRow = 0;
		
		// DB 연결
		Connection conn = DBHelper.getConnection();
	    String totalRowSql = "select count(*) from emp";
	    PreparedStatement totalRowStmt = conn.prepareStatement(totalRowSql);
	    ResultSet totalRowRs = totalRowStmt.executeQuery();
	    
	    // jsp 페이지에서 일단 전체줄 수(게시글) = 0으로 선언하고, 
	    // totalRowSql에 count(*)로 몇개인지에 따라 값이 정해진다.
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
		
		// DB 연결
		Connection conn = DBHelper.getConnection();
		
		// jsp 페이지에서 일단 고객수 = 0으로 선언하고, 
	    // totalRowSql에 count(*)로 몇개인지에 따라 값이 정해진다.
		String totalRowSql = "select count(*) from customer";
		PreparedStatement totalRowStmt = conn.prepareStatement(totalRowSql);
		ResultSet totalRowRs = totalRowStmt.executeQuery();
		if(totalRowRs.next()) {
			totalRow = totalRowRs.getInt("count(*)");
		}
		
		System.out.println("totalRow : " + totalRow);
		conn.close();
		return totalRow;
	}
	
	// 직원 목록 조회
	public static ArrayList<HashMap<String,Object>> list(int startRow, int rowPerPage) throws Exception{
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		// DB 연결
		Connection conn = DBHelper.getConnection();
		
		// 이미 정해진 startRow와 rowPerPage를 받아와 limit에 시작과 몇개를 반환할지 정해주는 쿼리
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
	    
	    System.out.println(stmt);
	    conn.close();
		return list;
	}
	
	// 고객 목록 조회
	public static ArrayList<HashMap<String,Object>> cusList(int startRow, int rowPerPage) throws Exception{
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		// DB 연결
		Connection conn = DBHelper.getConnection();
		
		// 이미 정해진 startRow와 rowPerPage를 받아와 limit에 시작과 몇개를 반환할지 정해주는 쿼리
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
		
		System.out.println(stmt);
		conn.close();
		return list;
	}
	
	// active권한 체인지(on->off, off->on) (a태그용)
	public static int change(String active, String empId) throws Exception {
		int row = 0;
		
		// DB 연결
		Connection conn = DBHelper.getConnection();
		
		// id를 받아서 어떤 id데이터를 업데이트할 것인지 정하고
		// active값을 받아서 최종 on으로 업데이트 하는지 off로하는지 정하는 쿼리
		String sql = "update emp set active = ? where emp_id = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, active);
		stmt.setString(2, empId);
		row = stmt.executeUpdate();
		
		System.out.println(stmt);
		conn.close();
		return row;
	}
	
	// active권한 off->on (input에 아이디 입력해서 바꾸는 용)
	public static int offOn(String requestEmp) throws Exception {
		int row = 0;
		
		// DB 연결
	    Connection conn = DBHelper.getConnection();
	    
	    // id를 받아서 해당 데이터의 active를 ON으로 변경해줌
		String sql = "UPDATE emp SET ACTIVE='ON' WHERE emp_id = ? ";
		PreparedStatement stmt = null;
	    stmt = conn.prepareStatement(sql);
	    stmt.setString(1,requestEmp);
	    row = stmt.executeUpdate();
	    
	    System.out.println(stmt);
	    conn.close();
	    return row;
	}
	
	// active권한 on->off (input에 아이디 입력해서 바꾸는 용)	
	public static int onOff(String retireEmp) throws Exception {
		int row = 0;
		
		// DB 연결
		Connection conn = DBHelper.getConnection();
		
		// id를 받아서 해당 데이터의 active를 OFF으로 변경해줌
		String sql = "UPDATE emp SET ACTIVE='OFF' WHERE emp_id = ? ";
		PreparedStatement stmt = null;
		stmt = conn.prepareStatement(sql);
		stmt.setString(1,retireEmp);
		row = stmt.executeUpdate();
		
		System.out.println(stmt);
		conn.close();
		return row;
	}
	
	// 카테고리 리스트 출력
	public static ArrayList<HashMap<String, Object>> categoryList() throws Exception {
		ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
	    PreparedStatement stmt1 = null;
	    ResultSet rs1 = null;
	    
	    // DB 연결
	    Connection conn = DBHelper.getConnection();
	    
	    // 카테고리 리스트가 보이게
	    //  '기타' 가 맨 뒤에 오게 순서 변경
	    String sql1 = "SELECT category FROM category GROUP BY category ORDER BY CASE WHEN category = '기타' THEN 1 ELSE 0 END, category DESC";
	    stmt1 = conn.prepareStatement(sql1);
	    rs1 = stmt1.executeQuery();
	    while(rs1.next()) {
	        HashMap<String, Object> m = new HashMap<String, Object>();
	        m.put("category", rs1.getString("category"));
	        list.add(m);
	    }
	    
	    System.out.println(stmt1);
	    conn.close();
		return list;
	}
	
	// 카테고리 추가
	public static int insertCategory(String categoryName) throws Exception {
		int row = 0;
		
		// DB 연결
		Connection conn = DBHelper.getConnection();
		
		// 카테고리 칼럼 추가하는 쿼리
		String sql = "INSERT INTO category(category) VALUES(?)";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, categoryName);
		row = stmt.executeUpdate();
		
		System.out.println(stmt);
	    conn.close();
		return row;
	}
	
	// 카테고리 삭제
	public static int deleteCategory(String categoryName) throws Exception {
		int row = 0;
		
		// DB 연결
		Connection conn = DBHelper.getConnection();
		
		// 카테고리 칼럼 삭제하는 쿼리
		String sql = "DELETE FROM category WHERE category = ?";
		PreparedStatement stmt = null;
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, categoryName);
		row = stmt.executeUpdate();
		
		System.out.println(stmt);
	    conn.close();
		return row;
	}
	
	// 카테고리 삭제시 해당 카테고리에 올려진 goods의 톰캣업로드 사진파일의 이름을 반환해주는 메서드
	public static ResultSet deleteFileName(String categoryName) throws Exception {
		// DB 연결
		Connection conn = DBHelper.getConnection();
		
		// 카테고리에 따라 해당 굿즈의 사진파일이름을 반환.
	    String sql2 = "SELECT filename FROM goods WHERE category= ?";
	    PreparedStatement stmt2 = null;
	    stmt2 = conn.prepareStatement(sql2);
	    stmt2.setString(1, categoryName);
	    ResultSet dfn = stmt2.executeQuery();
	    
	    System.out.println(stmt2);
	    conn.close();
		return dfn;
	}
}