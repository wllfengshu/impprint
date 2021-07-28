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


public class EditPswServlet extends HttpServlet {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		doPost(req, resp);
	}
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
	
		String user = null;
		if(request.getParameter("user") != null){
			user = request.getParameter("user");
		}
		
		String oldpassword = null;
		if(request.getParameter("oldpassword") != null){
			oldpassword = request.getParameter("oldpassword");
		}
		String password = null;
		if(request.getParameter("password") != null){
			password = request.getParameter("password");
		}
		//System.out.println("**"+oldpassword+","+password);
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String result = null;
		try {
			con = Dbcp.getConnection();
			pstmt = con.prepareStatement("select password from users where user=?");
			pstmt.setString(1, user);
			
			rs = pstmt.executeQuery();
			boolean err = false;
			if(rs.next()){
				if(!DigestUtils.md5Hex(oldpassword).equals(rs.getString(1))){
					result = "原始密码错误";
					err = true;
				}
			}
			Dbcp.closePreparedStatement(pstmt);
			if(!err){
				pstmt = con.prepareStatement("update users set password=? where user=?");
				pstmt.setString(1, DigestUtils.md5Hex(password));
				pstmt.setString(2, user);
				pstmt.executeUpdate();
			}
			
		} catch (Exception e) {
			result = "修改失败";
			e.printStackTrace();
		}finally{
			Dbcp.closeConnection(con);
			Dbcp.closePreparedStatement(pstmt);
		}
		if(result == null){
			result = "修改成功";
		}
		PrintWriter out = response.getWriter();
		out.print(result);
		out.flush();
		out.close();
	}
}
