package imp.servlet;

import imp.bean.FileMsg;
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


public class SaveSetServlet extends HttpServlet {
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
	
		FileMsg file = new FileMsg();
		file.setId(Integer.parseInt(request.getParameter("id")));
		file.setPage(Integer.parseInt(request.getParameter("page")));
		file.setFix(Integer.parseInt(request.getParameter("fix")));
		file.setColor(Integer.parseInt(request.getParameter("color")));
		file.setNumber(Integer.parseInt(request.getParameter("number")));
		file.setPptpage(Integer.parseInt(request.getParameter("pptpage")));
		file.setTotalPage(Integer.parseInt(request.getParameter("totalpage")));
		file.setMoney(Double.parseDouble(request.getParameter("money")));
		file.setOrdermoney(Double.parseDouble(request.getParameter("ordermoney")));
		file.setAd(Integer.parseInt(request.getParameter("ad")));
		
	//	System.out.println(file.getAd()+",");
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String result = null;
		try {
			con = Dbcp.getConnection();
			pstmt = con.prepareStatement("update paths set page=?,fix=?,color=?,number=?,pptpage=?,totalpage=?,money=?,ordermoney=?,ad=? where id=?");
			pstmt.setInt(1,file.getPage() );
			pstmt.setInt(2,file.getFix() );
			pstmt.setInt(3, file.getColor());
			pstmt.setInt(4, file.getNumber());
			pstmt.setInt(5, file.getPptpage());
			pstmt.setInt(6, file.getTotalPage());
			pstmt.setDouble(7, file.getMoney());
			pstmt.setDouble(8, file.getOrdermoney());
			pstmt.setInt(9, file.getAd());
			pstmt.setInt(10, file.getId());
			pstmt.executeUpdate();
			
			
		} catch (Exception e) {
		
			e.printStackTrace();
		}finally{
			Dbcp.closeConnection(con);
			Dbcp.closePreparedStatement(pstmt);
		}
		
		
	}
}
