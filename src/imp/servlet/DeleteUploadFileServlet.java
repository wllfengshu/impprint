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

import com.sun.crypto.provider.RSACipher;


public class DeleteUploadFileServlet extends HttpServlet {
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
		String fp = "";
		if(request.getParameter("fp") != null){
			fp = request.getParameter("fp");
		}
		
		Connection con = null;
		PreparedStatement pstmt = null;
		String result = null;
		ResultSet rs = null;
		String filepath = null;
		try {
			con = Dbcp.getConnection();
			pstmt = con.prepareStatement("select path from paths where id=?");
			pstmt.setInt(1, id);
			rs = pstmt.executeQuery();
			if(rs.next()){
				filepath = rs.getString(1);
			}
			Dbcp.closePreparedStatement(pstmt);
			
			pstmt = con.prepareStatement("delete from paths where id=?");
			pstmt.setInt(1, id);
			pstmt.executeUpdate();
			
			
			
			//删除服务器上对应文件
			String basePath = this.getServletContext().getRealPath("/") + "attached/";
			File f=new File(basePath+filepath);
		
			if(f.exists()){
				f.delete();
			}
			
		} catch (Exception e) {
			result = "删除失败";
			e.printStackTrace();
		}finally{
			Dbcp.closeConnection(con);
			Dbcp.closePreparedStatement(pstmt);
		}
		if(result == null){
			result = "删除成功";
			
		}
		/*if(fp.equals("print")){
			request.getRequestDispatcher("printset").forward(request, response);
		}else if(fp.equals("waitorder")){
			request.getRequestDispatcher("waitorder").forward(request, response);
		}else if(fp.equals("ordermanger")){
			request.getRequestDispatcher("orderstate").forward(request, response);
		}*/
	//	request.getRequestDispatcher("printset").forward(request, response);
		//PrintWriter out = response.getWriter();
		//out.write(result);
		//out.close();
		//request.getRequestDispatcher("usermenu?user="+user).forward(request, response);
	}
}
