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


public class ClearErrorServlet extends HttpServlet {
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
	
		String user = "";
		if(request.getParameter("user") != null){
			user = request.getParameter("user");
		}
		
		Connection con = null;
		PreparedStatement pstmt = null;
		String result = null;
		ResultSet rs = null;
		try {
			con = Dbcp.getConnection();
			pstmt = con.prepareStatement("select path from paths where user=? and finish=0");
			pstmt.setString(1, user);
			rs = pstmt.executeQuery();
			List<String> paths = new ArrayList<String>();
			while(rs.next()){
				paths.add(rs.getString("path"));
			}
			Dbcp.closePreparedStatement(pstmt);
			//删除服务器上对应文件
			String basePath = this.getServletContext().getRealPath("/") + "attached/";
			for(String s:paths){
				File f=new File(basePath+s);
				
				if(f.exists()){
					f.delete();
					
				}
			}
			//清楚paths表
			pstmt = con.prepareStatement("delete from paths where user=? and finish=0");
			pstmt.setString(1, user);
			pstmt.executeUpdate();
			
			
		} catch (Exception e) {
			//result = "修复失败";
			e.printStackTrace();
		}finally{
			Dbcp.closeConnection(con);
			Dbcp.closePreparedStatement(pstmt);
		}
		if(result == null){
			//result = "修复成功";
			
		}
		response.sendRedirect("printset");
		
	}
}
