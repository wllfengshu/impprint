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


public class ModifyPswServlet extends HttpServlet {
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
		PrintWriter out = response.getWriter();
		String user = "";
		if(request.getParameter("telphone") != null){
			user = request.getParameter("telphone");
		}
		String numbercode = "";
		if(request.getParameter("numbercode") != null){
			numbercode = request.getParameter("numbercode");
		}
		String random="";
		if(SendMsgServlet.random != null){
			random = SendMsgServlet.random;
		}else {
			random = "no";
		}
		
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String result = null;
		try {
			con = Dbcp.getConnection();
			pstmt = con.prepareStatement("select * from users where user=?");
			pstmt.setString(1, user);
			rs = pstmt.executeQuery();
			boolean isTrue = false;
			if(rs.next()){
				if(numbercode.equals(random)){
					isTrue = true;
					result = "密码重置为：123456。登录后请修改密码";
				}else {
					result = "验证码错误";
				}
				
			}else {
				result = "该账号暂未注册";
			}
			Dbcp.closePreparedStatement(pstmt);
			
			if(isTrue){
				pstmt = con.prepareStatement("update users set password=? where user=?");
				pstmt.setString(1, DigestUtils.md5Hex("123456"));
				pstmt.setString(2, user);
				int r = pstmt.executeUpdate();
				if(r != 1){
					result = "找回密码失败，请重试";
				}
				
			}
			
			
		} catch (Exception e) {
			result = "发生未知错误，请重试";
			e.printStackTrace();
		}finally{
			Dbcp.closeConnection(con);
			Dbcp.closePreparedStatement(pstmt);
		}
		//request.setAttribute("result", result);
		//request.getRequestDispatcher("login/forget.jsp").forward(request, response);
		out.write(result);
		out.flush();
		out.close();
	}
}
