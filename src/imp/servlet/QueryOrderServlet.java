package imp.servlet;

import imp.bean.FileMsg;
import imp.bean.Order;
import imp.bean.Pagination;
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

import com.sun.org.apache.bcel.internal.generic.IF_ACMPEQ;
import com.sun.org.apache.bcel.internal.generic.NEW;


public class QueryOrderServlet extends HttpServlet {
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
	
		String time = null;
		String dateLimit = null;//标识年月日，对应123
		if(request.getParameter("time") != null){
			time = request.getParameter("time");
			String [] timefrom = time.split(":");
			if(timefrom.length == 1){//非时间段
				String [] times = time.split("-");
				if(times.length == 1){//年
					dateLimit = "date_format(date,'%Y')='"+time+"'";
				}else if(times.length == 2){//月
					dateLimit = "date_format(date,'%Y-%m')='"+time+"'";
				}else if(times.length == 3){//日
					dateLimit = "date_format(date,'%Y-%m-%d')='"+time+"'";
				}
			}else {
		
				dateLimit = "date between '"+timefrom[0]+"' and '"+timefrom[1]+"'";
			}
			
		}else {
			time = new SimpleDateFormat("yyyy-MM").format(new Date());
			dateLimit = "date_format(date,'%Y-%m')='"+time+"'";
		}
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String result = null;
		try{
			con = Dbcp.getConnection();
			pstmt = con.prepareStatement("select distinct ordernum from paths where finish=3 and "+dateLimit+" order by date asc");
			rs = pstmt.executeQuery();
			List<String> ordernumbers = new ArrayList<String>();
			while(rs.next()){
				ordernumbers.add(rs.getString("ordernum"));
			}
			Dbcp.closePreparedStatement(pstmt);
			List<Order>  orders = new ArrayList<Order>();
			for(String i:ordernumbers){
				pstmt = con.prepareStatement("select * from paths where ordernum = ? order by date asc");
				pstmt.setString(1, i);
				rs = pstmt.executeQuery();
				if(rs.next()){
					Order order = new Order();
					order.setOrdernum(rs.getString("ordernum"));
					order.setMoney(Double.parseDouble(rs.getString("ordermoney")));
					order.setDate(rs.getString("date"));
					order.setFileid(Integer.parseInt(rs.getString("id")));
					String t = "无";
					if((int)Double.parseDouble(rs.getString("discount")) != 1){
						t = rs.getString("discount");
					}
					order.setDiscount(t);
					
					orders.add(order);
				}
				
			}
			for(Order i:orders){
				pstmt = con.prepareStatement("select * from waitprint where fileid = ?");
				pstmt.setInt(1, i.getFileid());
				rs = pstmt.executeQuery();
				if(rs.next()){
					i.setTel(rs.getString("tel"));
				}
			}
			request.setAttribute("nowtime", time);
			request.setAttribute("orders", orders);
			
			request.getSession().setAttribute("nowtime", time);
			request.getSession().setAttribute("orders", orders);
			request.getRequestDispatcher("admin/data.jsp").forward(request, response);
		} catch (Exception e) {
		
			e.printStackTrace();
		}finally{
			Dbcp.closeConnection(con);
			Dbcp.closePreparedStatement(pstmt);
		}
		}
		
	
}
