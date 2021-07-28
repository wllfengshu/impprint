package imp.servlet;

import imp.bean.Address;
import imp.bean.FileMsg;
import imp.dbcp.Dbcp;
import imp.unit.JudgeFileType;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.codec.digest.DigestUtils;

import sun.security.provider.MD5;

public class LoginUserServlet extends HttpServlet {
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
		}
		
		
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<Address> addresses = new ArrayList<Address>();
		try {
			con = Dbcp.getConnection();
			////收货地址////
			pstmt = con.prepareStatement("select * from useraddress where user=?");
			pstmt.setString(1, user);
			rs = pstmt.executeQuery();
			while(rs.next()){
				Address address = new Address();
				address.setId(rs.getInt("id"));
				address.setUser(rs.getString("user"));
				address.setAddress(rs.getString("address"));
				addresses.add(address);
			}
		Dbcp.closePreparedStatement(pstmt);
		request.setAttribute("addresses", addresses);
		
		////历史订单
		pstmt = con.prepareStatement("select * from paths where user=?");
		pstmt.setString(1, user);
		rs = pstmt.executeQuery();
		List<FileMsg> orders = new ArrayList<FileMsg>();
		while(rs.next()){
			FileMsg fileMsg = new FileMsg();
			fileMsg.setId(rs.getInt("id"));
			fileMsg.setName(rs.getString("name"));
			fileMsg.setPath(rs.getString("path"));
			fileMsg.setDate(rs.getString("date").substring(0,16));
			fileMsg.setType(JudgeFileType.getFileType(rs.getString("path")));
			fileMsg.setFinish(rs.getInt("finish"));
			orders.add(fileMsg);
		}
		request.setAttribute("orders", orders);
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			Dbcp.closeConnection(con);
			Dbcp.closePreparedStatement(pstmt);
		}
		request.getRequestDispatcher("usermenu.jsp").forward(request, response);
	}

}
