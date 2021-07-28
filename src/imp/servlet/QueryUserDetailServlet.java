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
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.List;

import javax.enterprise.inject.New;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.codec.digest.DigestUtils;

import com.sun.org.apache.bcel.internal.generic.NEW;


public class QueryUserDetailServlet extends HttpServlet {
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
		
		String orderNums = null;
		if(request.getParameter("orderNums") != null){
			orderNums = request.getParameter("orderNums");
		}
		String tel = null;
		if(request.getParameter("tel") != null){
			tel = request.getParameter("tel");
		}
		String[] ordernum = orderNums.split("-");
		List<String> order = new ArrayList<String>();
		
		
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String result = null;
		try{
			con = Dbcp.getConnection();
		
			for(int i = 0;i < ordernum.length;i++){
				
				pstmt = con.prepareStatement("select * from paths where ordernum = ? order by date asc");
				pstmt.setString(1, ordernum[i]);
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
					file.setDiscount(Double.parseDouble(rs.getString("discount")));
					files.add(file);
				}
				order.add(ordernum[i]);
				request.setAttribute(ordernum[i], files);
			}
			
			request.setAttribute("tel", tel);
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
