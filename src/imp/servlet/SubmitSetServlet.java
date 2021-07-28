package imp.servlet;

import imp.bean.Address;
import imp.bean.FileMsg;
import imp.dbcp.Dbcp;

import imp.unit.GetFilePages;
import imp.unit.JudgeFileType;

import java.io.FileInputStream;
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
import org.apache.poi.POIXMLDocument;
import org.apache.poi.hwpf.HWPFDocument;
import org.apache.poi.hwpf.usermodel.Range;
import org.apache.poi.xwpf.usermodel.XWPFDocument;

import com.itextpdf.text.pdf.PdfReader;

import sun.security.provider.MD5;

public class SubmitSetServlet extends HttpServlet {
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
		
		
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<FileMsg> fMsgs = new ArrayList<FileMsg>();
		try {
			con = Dbcp.getConnection();

			pstmt = con.prepareStatement("select * from useraddress where user=?");
			pstmt.setString(1, user);
			rs = pstmt.executeQuery();
			List<Address> addresses = new ArrayList<Address>();
			while(rs.next()){
				Address address = new Address();
				address.setId(rs.getInt("id"));
				address.setAddress(rs.getString("address"));
				addresses.add(address);
			
			}
			request.setAttribute("addresses", addresses);
			Dbcp.closePreparedStatement(pstmt);
			//查询订单金额
			pstmt = con.prepareStatement("select * from paths where user=? order by id desc limit 1");
			pstmt.setString(1, user);
			rs = pstmt.executeQuery();
			double money = 0;
			if(rs.next()){
				money = rs.getDouble("ordermoney");
			}
			request.setAttribute("money", money);
			Dbcp.closePreparedStatement(pstmt);
			//查寻已接订单打印所需时间
			pstmt = con.prepareStatement("select distinct ordermoney from paths where finish=2");
			rs = pstmt.executeQuery();
			double m = 0;
			while(rs.next()){
				m += rs.getDouble("ordermoney");
			}
			double tmin = m * 0.85;//
			int ts = (new Double(tmin).intValue() + 1) * 60;//秒
			System.out.println("t:"+ts);
			request.setAttribute("waittime", ts);
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			Dbcp.closeConnection(con);
			Dbcp.closePreparedStatement(pstmt);
		}
		request.getRequestDispatcher("submit.jsp").forward(request, response);
	}

}
