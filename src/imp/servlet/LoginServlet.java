package imp.servlet;

import imp.dbcp.Dbcp;

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

public class LoginServlet extends HttpServlet {
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
		if(request.getParameter("password") != null){
			password = request.getParameter("password");
		}
		//System.out.println("*"+user+","+password);
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = Dbcp.getConnection();
			pstmt = con.prepareStatement("select * from users where user=?");
			pstmt.setString(1, user);
			
			rs = pstmt.executeQuery();
			
			String result = null;
			String type = null;
			boolean istrue = false;
			password = DigestUtils.md5Hex(password);
			if(rs.next()){
				if(password.equals(rs.getString("password"))){
					istrue = true;
					type = rs.getString("type");
				}else {
					result = "密码错误";
				}
				
			}else {
				result = "用户名不存在";
			}
			
			if(istrue){
				//System.out.println("yes");
				request.getSession().setAttribute("users", user);
				request.getSession().setAttribute("type", type);
				if(type.equals("user")){
					if(request.getSession().getAttribute("nousers") != null){
						request.getSession().removeAttribute("nousers");
					}
					out.write("user");
					//response.sendRedirect("index.jsp");
				}else if(type.equals("admin") || type.equals("root")){
					//System.out.println("type:"+type);
					//response.sendRedirect("waitorder");
					out.write("admin");
				}
				
				
				//request.getRequestDispatcher("index.jsp").forward(request, response);
				
			}else {
				
				//request.setAttribute("result", result);
				
				out.write(result);
				
				
				//request.getRequestDispatcher("login/login.jsp").forward(request, response);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			
			out.flush();
			out.close();
			Dbcp.closeConnection(con);
			Dbcp.closePreparedStatement(pstmt);
		}
		
	}

}
