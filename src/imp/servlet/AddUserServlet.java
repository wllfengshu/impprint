package imp.servlet;

import imp.dbcp.Dbcp;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.codec.digest.DigestUtils;


public class AddUserServlet extends HttpServlet {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		
	}
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		 //request.setCharacterEncoding("utf-8");
		 //  response.setContentType("text/html;charset=utf-8");
		 
		String user = null;
		if(request.getParameter("newuser") != null){
			user = request.getParameter("newuser");
		}
		String password = null;
		if(request.getParameter("defaultpsw") != null){
			password = request.getParameter("defaultpsw");
		}
				
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String result = null;
		try {
			con = Dbcp.getConnection();
			pstmt = con.prepareStatement("insert into users(user,password,type) values(?,?,?)");
			pstmt.setString(1, user);
			pstmt.setString(2, DigestUtils.md5Hex(password));
			pstmt.setString(3, "admin");
			pstmt.executeUpdate();
		
			
		} catch (Exception e) {
			result = "添加子账号失败";
			e.printStackTrace();
		}finally{
			Dbcp.closeConnection(con);
			Dbcp.closePreparedStatement(pstmt);
		}
		if(result == null){
			result = "添加子账号成功";
		}
		PrintWriter out = response.getWriter();
		out.print(result);
		
	}
}
