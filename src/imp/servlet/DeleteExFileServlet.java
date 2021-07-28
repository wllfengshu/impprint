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


public class DeleteExFileServlet extends HttpServlet {
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
	
		Integer id = 0;
		if(request.getParameter("id") != null){
			id = Integer.parseInt(request.getParameter("id"));
		}
		String path = "";
		if(request.getParameter("path") != null){
			path = new String(request.getParameter("path").getBytes("ISO8859_1"),"utf-8").toString();
		}
		Connection con = null;
		PreparedStatement pstmt = null;
		
		ResultSet rs = null;
		try {
			con = Dbcp.getConnection();
			
			pstmt = con.prepareStatement("delete from expaths where id=?");
			pstmt.setInt(1, id);
			pstmt.executeUpdate();
			Dbcp.closePreparedStatement(pstmt);
			
			//删除服务器上对应文件
			String basePath = this.getServletContext().getRealPath("/") + "exattached/";
			
				File f=new File(basePath+path);
				
				if(f.exists()){
					f.delete();
				}
			
			
		} catch (Exception e) {
			
			e.printStackTrace();
		}finally{
			Dbcp.closeConnection(con);
			Dbcp.closePreparedStatement(pstmt);
		}
		
		response.sendRedirect("exfiles");
	}
}
