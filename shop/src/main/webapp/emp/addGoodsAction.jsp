<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.net.*"%>
<%@ page import="java.io.*" %>
<%@ page import="java.nio.file.*" %>
<%@ page import="shop.dao.*" %>
<%
    System.out.println("=====addGoodsAction.jsp=====================================");
    
    // 호출값 인코딩
    request.setCharacterEncoding("UTF-8");
    
    // 로그인 인증 우회
    if(session.getAttribute("loginEmp") == null) {
        response.sendRedirect("/shop/emp/empLoginForm.jsp");
        return;
    }
    // 추가할 상품의 정보 호출
    String category = request.getParameter("category");
    String empId = request.getParameter("empId");
    String goodsTitle = request.getParameter("goodsTitle");
    String goodsImg = request.getParameter("goodsImg");
    int goodsPrice = Integer.parseInt(request.getParameter("goodsPrice"));
    int goodsAmount = Integer.parseInt(request.getParameter("goodsAmount"));
    String goodsContent = request.getParameter("goodsContent");
    Part part = request.getPart("goodsImg");
    String originalName = part.getSubmittedFileName();
    
    // 원본이름에서 확장자만 분리
    int dotIdx = originalName.lastIndexOf(".");
    String ext = originalName.substring(dotIdx); // .png
    System.out.println("dotIdx : " + dotIdx); // 디버깅
    
    UUID uuid = UUID.randomUUID();
    String filename = uuid.toString().replace("-", "");
    filename = filename + ext;

    // 호출 값 디버깅
    System.out.println("category : " + category); 
    System.out.println("empId : " + empId); 
    System.out.println("filename : " + filename); 
    System.out.println("goodsImg : " + goodsImg); 
    System.out.println("goodsPrice : " + goodsPrice); 
    System.out.println("goodsAmount : " + goodsAmount); 
    System.out.println("goodsContent : " + goodsContent); 
    
    // jsp에서의 쿼리실행문 연습
    // DB 연결
    Connection conn = DBHelper.getConnection();
    
    // goods 테이블에 데이터 추가
    String sql = "insert into goods(category, emp_id, goods_title, filename, goods_content, goods_price, goods_amount, update_date, create_date) values(?,?,?,?,?,?,?, now(), now())";
    PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1,category);
	stmt.setString(2,empId);
	stmt.setString(3,goodsTitle);
	stmt.setString(4,filename);
	stmt.setString(5,goodsContent);
	stmt.setInt(6, goodsPrice);
	stmt.setInt(7, goodsAmount);
    
    // 디버깅
    System.out.println("stmt확인 : " + stmt);
    int row = stmt.executeUpdate();
    
    // 사진 업로드 성공 분기문
    if(row == 1) { // insert 성공하면 파일업로드
        // part -> is -> os -> 빈파일
        // 1)
        InputStream is = part.getInputStream();
        // 3)+ 2)
        String filePath = request.getServletContext().getRealPath("upload");
        File f = new File(filePath, filename); // 빈파일
        OutputStream os = Files.newOutputStream(f.toPath()); // os + file
        is.transferTo(os);
        
        os.close();
        is.close();
    } else {
        String errMsg = URLEncoder.encode("작성에 실패했습니다. 확인 후 다시 입력하세요.", "utf-8");
        response.sendRedirect("/shop/emp/addGoodsForm.jsp?errMsg=" + errMsg);
        return;
    }
    
    // 추가상품 등록 성공 여부 분기문
    if(row == 1){
        response.sendRedirect("/shop/emp/goodsList.jsp?category=all");
    } else {
    	String errMsg = URLEncoder.encode("작성에 실패했습니다. 확인 후 다시 입력하세요.", "utf-8");
    	response.sendRedirect("/shop/emp/addGoodsForm.jsp?errMsg=" + errMsg);
        return;
    }
%>