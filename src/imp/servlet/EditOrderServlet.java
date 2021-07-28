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


public class EditOrderServlet extends HttpServlet {
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
	
		String ordernum = null;
		if(request.getParameter("ordernum") != null){
			ordernum = request.getParameter("ordernum");
		}
		
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String result = null;
		try {
			con = Dbcp.getConnection();
			pstmt = con.prepareStatement("select id from paths where ordernum=?");
			pstmt.setString(1, ordernum);
			rs = pstmt.executeQuery();
			List<Integer> ids = new ArrayList<Integer>();
			while(rs.next()){
				ids.add(rs.getInt("id"));
				
			}
			
			Dbcp.closePreparedStatement(pstmt);
			
			for(Integer i:ids){
				pstmt = con.prepareStatement("update paths set finish=0 where id=?");
				pstmt.setInt(1, i);
				pstmt.executeUpdate();
				Dbcp.closePreparedStatement(pstmt);
				
				pstmt = con.prepareStatement("delete from waitprint where fileid=?");
				pstmt.setInt(1, i);
				pstmt.executeUpdate();
				Dbcp.closePreparedStatement(pstmt);
			}
			
			response.sendRedirect("printset");
		} catch (Exception e) {
			
			e.printStackTrace();
		}finally{
			Dbcp.closeConnection(con);
			Dbcp.closePreparedStatement(pstmt);
		}
		
	}
}
