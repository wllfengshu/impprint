package imp.servlet;

import imp.bean.FileMsg;
import imp.bean.WaitPrintFile;
import imp.dbcp.Dbcp;
import imp.unit.JudgeFileType;

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


public class OrderstateServlet extends HttpServlet {
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
		if(request.getSession().getAttribute("users") != null){
			user = (String)request.getSession().getAttribute("users");
		}else {
			user = (String)request.getSession().getAttribute("nousers");
		}
		//System.out.println("&"+user);	
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String result = null;
		try {
			con = Dbcp.getConnection();
			pstmt = con.prepareStatement("select distinct ordernum from paths where user=? and finish!=0 order by date desc");
			pstmt.setString(1, user);
			rs = pstmt.executeQuery();
			List<String> ordernumbers = new ArrayList<String>();
			while(rs.next()){
				
				ordernumbers.add(rs.getString("ordernum"));
			}
			Dbcp.closePreparedStatement(pstmt);
			
			for(String i:ordernumbers){
				System.out.println("for:"+i+","+user);
				pstmt = con.prepareStatement("select * from paths where user=? and ordernum=? order by date desc");
				pstmt.setString(1, user);
				pstmt.setString(2, i);
				rs = pstmt.executeQuery();
				List<WaitPrintFile> orders = new ArrayList<WaitPrintFile>();
				//double ordermoney = 0;
				while(rs.next()){
					WaitPrintFile file = new WaitPrintFile();
					file.setFileid(rs.getInt("id"));
					file.setName(rs.getString("name"));
					file.setPath(rs.getString("path"));
					file.setFinish(rs.getInt("finish"));
					file.setTime(rs.getString("date").substring(0,16));
					file.setPage(rs.getInt("page"));
					file.setFix(rs.getInt("fix"));
					file.setColor(rs.getInt("color"));
					file.setNumber(rs.getInt("number"));
					file.setMoney(rs.getDouble("money"));
					file.setAd(rs.getInt("ad"));
					file.setOrdermoney(Math.round(rs.getDouble("ordermoney")*10)/10.0);
					//ordermoney += file.getMoney();
					file.setType(JudgeFileType.getFileType(rs.getString("path")));
					file.setTotalPage(rs.getInt("totalpage"));
					orders.add(file);
				}
				Dbcp.closePreparedStatement(pstmt);
				for(WaitPrintFile f:orders){
					//f.setOrdermoney(ordermoney);
					pstmt = con.prepareStatement("select * from waitprint where fileid=?");
					pstmt.setInt(1, f.getFileid() );
					rs = pstmt.executeQuery();
					if(rs.next()){
						f.setTel(rs.getString("tel"));
						f.setAddress(rs.getString("address"));
						f.setArrivetime(rs.getString("arrivetime"));
						f.setMoreword(rs.getString("moreword"));
						f.setSudu(rs.getInt("sudu"));
					}
					Dbcp.closePreparedStatement(pstmt);
				}
				System.out.println("i:"+i+","+orders.size());
				request.setAttribute(i, orders);
			}
			request.setAttribute("ordernumbers", ordernumbers);
			
			
			request.getRequestDispatcher("ordermanger.jsp").forward(request, response);
			
		} catch (Exception e) {
			
			e.printStackTrace();
			request.setAttribute("err",e.toString() );
			request.getRequestDispatcher("error.jsp").forward(request, response);
		}finally{
			Dbcp.closeConnection(con);
			Dbcp.closePreparedStatement(pstmt);
		}
		
		
	}
}
