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


public class ChangeOrderServlet extends HttpServlet {
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
		if(request.getParameter("ordernum")!=null){
			ordernum = request.getParameter("ordernum");
		}
		int finish=0;
		if(request.getParameter("finish")!=null){
			finish = Integer.parseInt(request.getParameter("finish"));
		}
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String result = null;
		try {
			con = Dbcp.getConnection();
			
			pstmt = con.prepareStatement("update paths set finish=? where ordernum=?");
			pstmt.setInt(1, finish);
			pstmt.setString(2, ordernum);
			pstmt.executeUpdate();
			Dbcp.closePreparedStatement(pstmt);
			if(finish == 2){
				//发送短信通知
				pstmt = con.prepareStatement("select id from paths where ordernum=? limit 1");
				pstmt.setString(1, ordernum);
				rs = pstmt.executeQuery();
				int id = 0;
				if(rs.next()){
					id = rs.getInt(1);
				}
				Dbcp.closePreparedStatement(pstmt);
				pstmt = con.prepareStatement("select tel from waitprint where fileid=?");
				pstmt.setInt(1, id);
				rs = pstmt.executeQuery();
				String tel = null;
				if(rs.next()){
					tel = rs.getString(1);
				}
				SendMessage.send(tel, "orderok","no");
				request.getRequestDispatcher("waitorder").forward(request, response);
			}else if(finish == 3){
				//更新送达时间
				
				pstmt = con.prepareStatement("select id from paths where ordernum=?");
				pstmt.setString(1, ordernum);
				rs = pstmt.executeQuery();
				List<Integer> ids = new ArrayList<Integer>();
				while(rs.next()){
					ids.add(rs.getInt(1));
				}
				Dbcp.closePreparedStatement(pstmt);
				
				SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm");
				String time = df.format(new Date());
				for(Integer i:ids){
					pstmt = con.prepareStatement("update waitprint set arrivetime=? where fileid=?");
					pstmt.setString(1, time);
					pstmt.setInt(2, i);
					pstmt.executeUpdate();
					Dbcp.closePreparedStatement(pstmt);
				}
				
				request.getRequestDispatcher("sendfile").forward(request, response);
			}else if(finish == 4){
				//发送短信通知
				pstmt = con.prepareStatement("select id from paths where ordernum=? limit 1");
				pstmt.setString(1, ordernum);
				rs = pstmt.executeQuery();
				int id = 0;
				if(rs.next()){
					id = rs.getInt(1);
				}
				Dbcp.closePreparedStatement(pstmt);
				pstmt = con.prepareStatement("select tel from waitprint where fileid=?");
				pstmt.setInt(1, id);
				rs = pstmt.executeQuery();
				String tel = null;
				if(rs.next()){
					tel = rs.getString(1);
				}
				SendMessage.send(tel, "orderno",ordernum);
				request.getRequestDispatcher("waitorder").forward(request, response);
			}
			
		
		} catch (Exception e) {
		
			e.printStackTrace();
		}finally{
			Dbcp.closeConnection(con);
			Dbcp.closePreparedStatement(pstmt);
		}
		}
		
	
}
