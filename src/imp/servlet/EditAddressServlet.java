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


public class EditAddressServlet extends HttpServlet {
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
	
		int id = 0;
		if(request.getParameter("id") != null){
			id = Integer.parseInt(request.getParameter("id"));
		}
		String address ="";
		if(request.getParameter("address") != null){
			address = request.getParameter("address");
		}	
		String user ="";
		if(request.getSession().getAttribute("users") != null){
			user = (String)request.getSession().getAttribute("users");
		}	
		
		Connection con = null;
		PreparedStatement pstmt = null;
		String result = null;
		try {
			con = Dbcp.getConnection();
			pstmt = con.prepareStatement("update useraddress set address=? where id=?");
			pstmt.setString(1, address);
			pstmt.setInt(2, id);
			pstmt.executeUpdate();
		
			
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
		//PrintWriter out = response.getWriter();
		//out.write(result);
		//out.close();
		request.getRequestDispatcher("usermenu?user="+user).forward(request, response);
	}
}
