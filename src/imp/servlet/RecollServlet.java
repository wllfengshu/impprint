package imp.servlet;

import imp.dbcp.Dbcp;
import imp.unit.CreateMsgValidation;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.codec.digest.DigestUtils;

import sun.security.provider.MD5;

public class RecollServlet extends HttpServlet {
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
		String password = "";
		if(request.getParameter("telphone") != null){
			user = request.getParameter("telphone");
		}
		String numbercode = "";
		if(request.getParameter("numbercode") != null){
			numbercode = request.getParameter("numbercode");
		}
		
		if(request.getParameter("password") != null){
			password = request.getParameter("password");
		}
		String random="";
		if(SendMsgServlet.random != null){
			random = SendMsgServlet.random;
		}else {
			random = "no";
		}
		
		//System.out.println("*"+random);
		String result = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			if(numbercode.equals(random)){
				con = Dbcp.getConnection();
				pstmt = con.prepareStatement("select * from users where user=?");
				pstmt.setString(1, user);
				rs = pstmt.executeQuery();
				

				if(rs.next()){
					result = "该账号已存在";
				}else {
					Dbcp.closePreparedStatement(pstmt);
					pstmt = con.prepareStatement("insert into users(user,password,type) values(?,?,?)");
					pstmt.setString(1, user);
					pstmt.setString(2, DigestUtils.md5Hex(password));
					pstmt.setString(3, "user");
					pstmt.executeUpdate();
					
				}
			}else {
				result = "验证码错误";
			}

		} catch (Exception e) {
			result = "注册失败，请重试";
			e.printStackTrace();
		}finally{
			Dbcp.closeConnection(con);
			Dbcp.closePreparedStatement(pstmt);
		}
		if(result == null){
			result = "注册成功，请登录";
		}
		//request.setAttribute("result", result);
		//request.getRequestDispatcher("login/recoll.jsp").forward(request, response);
		out.write(result);
		out.flush();
		out.close();
	}

}
