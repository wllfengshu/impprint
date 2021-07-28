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


public class QueryUserOrderServlet extends HttpServlet {
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
		String exportToExcel = null;
		if(request.getParameter("exportToExcel") != null){
			request.setAttribute("exportToExcel", request.getParameter("exportToExcel"));
		}
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String result = null;
		try{
			con = Dbcp.getConnection();
			pstmt = con.prepareStatement("select distinct ordernum from paths where finish=3 order by date asc");
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
			/////
			List<UserOrder> userOrders = new ArrayList<UserOrder>();
			for(int i = 0;i < orders.size();i++){
				if(userOrders.size() > 0){
					boolean had = false;
					for(UserOrder u:userOrders){
						if(u.getUser().equals(orders.get(i).getTel())){
							had = true;
							break;
						}
					}
					if(had){
						continue;
					}
				}
				UserOrder userOrder = new UserOrder();
				userOrder.setUser(orders.get(i).getTel());
				userOrder.setTotalMoney(orders.get(i).getMoney());
				userOrder.setTotalOrderNum(1);
				userOrder.setOrderNums(orders.get(i).getOrdernum());
				String tel = orders.get(i).getTel();
				int count = 1;
				double money = orders.get(i).getMoney();
				for(int j = i + 1;j < orders.size();j++){
					if(orders.get(j).getTel().equals(userOrder.getUser())){
						userOrder.setTotalOrderNum(userOrder.getTotalOrderNum() + 1);
						userOrder.setTotalMoney(userOrder.getTotalMoney() + orders.get(j).getMoney());
						userOrder.setOrderNums(userOrder.getOrderNums() + "-" + orders.get(j).getOrdernum());
					}
				}
				userOrders.add(userOrder);
			}
			//对list通过ordernum降序
			Collections.sort(userOrders, new Comparator<Object>(){  
		        @Override  
		        public int compare(Object o1, Object o2) {  
		            UserOrder u1=(UserOrder)o1;  
		            UserOrder u2=(UserOrder)o2;  
		            if(u1.getTotalOrderNum()<u2.getTotalOrderNum()){  
		                return 1;  
		            }else if(u1.getTotalOrderNum()==u2.getTotalOrderNum()){  
		                return 0;  
		            }else{  
		                return -1;  
		            }  
		        }             
		    });
			request.setAttribute("userOrders", userOrders);
			request.getSession().setAttribute("userOrders", userOrders);
			request.getRequestDispatcher("admin/datauser.jsp").forward(request, response);
		} catch (Exception e) {
		
			e.printStackTrace();
		}finally{
			Dbcp.closeConnection(con);
			Dbcp.closePreparedStatement(pstmt);
		}
		/*String number = null;
		if(request.getParameter("number") != null){
			number = request.getParameter("number");
			
		}
		System.out.println("s:"+number);
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String result = null;
		try{
			con = Dbcp.getConnection();
			pstmt = con.prepareStatement("select distinct ordernum from paths where finish=3 order by date asc");
			rs = pstmt.executeQuery();
			List<String> ordernumbers = new ArrayList<String>();
			while(rs.next()){
				ordernumbers.add(rs.getString("ordernum"));
			}
			Dbcp.closePreparedStatement(pstmt);
			List<Integer>  ids = new ArrayList<Integer>();
			for(String i:ordernumbers){
				pstmt = con.prepareStatement("select id from paths where ordernum = ? order by date asc");
				pstmt.setString(1, i);
				rs = pstmt.executeQuery();
				if(rs.next()){
					ids.add(rs.getInt(1));
				}
				Dbcp.closePreparedStatement(pstmt);
			}
			List<String> tels = new ArrayList<String>();
			for(Integer i:ids){
				pstmt = con.prepareStatement("select tel from waitprint where fileid = ?");
				pstmt.setInt(1, i);
				rs = pstmt.executeQuery();
				if(rs.next()){
					tels.add(rs.getString("tel"));
				}
				
				Dbcp.closePreparedStatement(pstmt);
			}
			
			//request.setAttribute("nowtime", time);
			//request.setAttribute("orders", orders);
			request.getRequestDispatcher("admin/data.jsp").forward(request, response);
		} catch (Exception e) {
		
			e.printStackTrace();
		}finally{
			Dbcp.closeConnection(con);
			Dbcp.closePreparedStatement(pstmt);
		}*/
		}
		
	
}
