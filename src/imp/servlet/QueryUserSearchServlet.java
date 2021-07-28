package imp.servlet;

import imp.bean.FileMsg;
import imp.bean.Order;
import imp.bean.Pagination;
import imp.bean.UserOrder;
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

import javax.enterprise.inject.New;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.codec.digest.DigestUtils;

import com.sun.org.apache.bcel.internal.generic.NEW;


public class QueryUserSearchServlet extends HttpServlet {
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
		
		String query = null;
		if(request.getParameter("query") != null){
			query = request.getParameter("query");
		}
		
		List<String> order = new ArrayList<String>();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String result = null;
		try{
			con = Dbcp.getConnection();
			List<String> orders = new ArrayList<String>();
			if(query != null && query.length() == 11){//手机号
				request.setAttribute("tel", query);
				pstmt = con.prepareStatement("select * from waitprint where tel = ?");
				pstmt.setString(1, query);
				rs = pstmt.executeQuery();
				List<Integer> fileIds = new ArrayList<Integer>();
				while(rs.next()){
					fileIds.add(Integer.parseInt(rs.getString("fileid")));
				}
				Dbcp.closePreparedStatement(pstmt);
				String invalue = "";
				
				for(int i = 0;i <fileIds.size();i++){
					if(i == fileIds.size() - 1){
						invalue += fileIds.get(i);
					}else {
						invalue += fileIds.get(i) + ",";
					}
				}
				
				pstmt = con.prepareStatement("select distinct ordernum from paths where finish=3 and id in("+invalue+")");
				rs = pstmt.executeQuery();
				
				while(rs.next()){
					orders.add(rs.getString("ordernum"));
				}
				
			}else {//订单号
				
				orders.add(query);
			}
			
			for(String i:orders){
				
				pstmt = con.prepareStatement("select * from paths where ordernum = ? order by date asc");
				pstmt.setString(1, i);
				rs = pstmt.executeQuery();
				List<FileMsg> files = new ArrayList<FileMsg>();
				while(rs.next()){
					FileMsg file = new FileMsg();
					file.setName(rs.getString("name"));
					file.setPath(rs.getString("path"));
					file.setPage(rs.getInt("page"));
					file.setFix(rs.getInt("fix"));
					file.setColor(rs.getInt("color"));
					file.setNumber(rs.getInt("number"));
					file.setMoney(rs.getDouble("money"));
					file.setOrdermoney(Math.round(rs.getDouble("ordermoney")*10)/10.0);
					file.setType(JudgeFileType.getFileType(rs.getString("path")));
					file.setAd(rs.getInt("ad"));
					file.setTotalPage(rs.getInt("totalpage"));
					files.add(file);
				}
				order.add(i);
				request.setAttribute(i, files);
			}
			
			
			request.setAttribute("order", order);
			request.getRequestDispatcher("admin/userdetail.jsp").forward(request, response);
		} catch (Exception e) {
		
			e.printStackTrace();
		}finally{
			Dbcp.closeConnection(con);
			Dbcp.closePreparedStatement(pstmt);
		}
	
		}
		
	
}
