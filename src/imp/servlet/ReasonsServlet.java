package imp.servlet;

import imp.bean.FileMsg;
import imp.dbcp.Dbcp;
import imp.unit.SendMessage;

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

import javax.enterprise.inject.New;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.codec.digest.DigestUtils;

import com.sun.org.apache.bcel.internal.generic.NEW;


public class ReasonsServlet extends HttpServlet {
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
	
		String ordernum="";
		if(request.getParameter("on")!=null){
			ordernum = request.getParameter("on");
		}
		String reason="";
		if(request.getParameter("reason")!=null){
			reason = request.getParameter("reason");
		}
		System.out.println(ordernum+","+reason);
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String result = null;
		try {
			con = Dbcp.getConnection();
			
			pstmt = con.prepareStatement("insert into reasons(ordernum,reason) values(?,?)");
			pstmt.setString(1, ordernum);
			pstmt.setString(2, reason );
			pstmt.executeUpdate();
			Dbcp.closePreparedStatement(pstmt);
			request.getRequestDispatcher("changeorder?ordernum="+ordernum+"&finish=4").forward(request, response);
		
		} catch (Exception e) {
		
			e.printStackTrace();
		}finally{
			Dbcp.closeConnection(con);
			Dbcp.closePreparedStatement(pstmt);
		}
		}
		
	
}
