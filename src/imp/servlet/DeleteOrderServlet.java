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


public class DeleteOrderServlet extends HttpServlet {
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
	
		String ordernum = "";
		if(request.getParameter("ordernum") != null){
			ordernum = request.getParameter("ordernum");
		}
		String fp = "";
		if(request.getParameter("fp") != null){
			fp = request.getParameter("fp");
		}
		//System.out.println("&"+fp);
		Connection con = null;
		PreparedStatement pstmt = null;
		String result = null;
		ResultSet rs = null;
		try {
			con = Dbcp.getConnection();
			List<String> paths = new ArrayList<String>();
			pstmt = con.prepareStatement("select path from paths where ordernum=?");
			pstmt.setString(1, ordernum);
			rs = pstmt.executeQuery();
			while(rs.next()){
				paths.add(rs.getString(1));
			}
			Dbcp.closePreparedStatement(pstmt);
			
			pstmt = con.prepareStatement("delete from paths where ordernum=?");
			pstmt.setString(1, ordernum);
			pstmt.executeUpdate();
			Dbcp.closePreparedStatement(pstmt);
			
			//删除服务器上对应文件
			String basePath = this.getServletContext().getRealPath("/") + "orders/"+ordernum + "/";
			for(String s:paths){
				File f=new File(basePath+s);
				
				if(f.exists()){
					f.delete();
					
				}
			}
			File file = new File(basePath);
			if(file.list().length == 0){
				file.delete();
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
