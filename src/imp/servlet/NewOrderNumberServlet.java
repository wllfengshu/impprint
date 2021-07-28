package imp.servlet;

import imp.dbcp.Dbcp;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class NewOrderNumberServlet extends HttpServlet{

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		doPost(req, resp);
	}
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = Dbcp.getConnection();
			pstmt = con.prepareStatement("select distinct ordernum from paths where finish=1 order by date desc");
			rs = pstmt.executeQuery();
			int newordernumber = 0;
			
			while(rs.next()){
				newordernumber++;
			}
			PrintWriter out = resp.getWriter();
			out.print(newordernumber);
			//System.out.println("num:"+newordernumber);
			out.flush();
			out.close();
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			Dbcp.closePreparedStatement(pstmt);
			Dbcp.closeConnection(con);
		
		}
	}
}
