package shop.dao;

import java.io.FileReader;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Properties;

public class DBHelper {//DB연동해주는 DAO
	public static Connection getConnection() throws Exception {
		Class.forName("org.mariadb.jdbc.Driver");
		
		// 로컬 PC의 Properties파일 읽어 오기(mariaDB Id, Pw)
		FileReader fr = new FileReader("c:\\dev\\auth\\mariadb.properties");//역슬러시 못 쓰기 때문에역슬러시 두개를 써줘야함. 로컬에서는 역슬러시, 웹에서는 그냥슬래시
		Properties prop = new Properties(); 
		prop.load(fr);
		System.out.println(prop.getProperty("id"));
		System.out.println(prop.getProperty("pw"));
		String id = prop.getProperty("id");
		String pw = prop.getProperty("pw");
		Connection conn = DriverManager.getConnection(
				"jdbc:mariadb://127.0.0.1:3306/shop", id, pw);
		
		return conn;
	}
	
	public static void main(String[] args) throws Exception {
		DBHelper.getConnection();
		
	}
}