package imp.servlet;

import imp.bean.FileMsg;
import imp.dbcp.Dbcp;
import imp.unit.CreateMsgValidation;
import imp.unit.SendMessage;
import imp.unit.WebParams;

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
import org.apache.commons.io.FileUtils;

import com.sun.org.apache.bcel.internal.generic.NEW;


public class IsOrderServlet extends HttpServlet {
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
	
		boolean isLogin = true;
		String user = null;
		if(request.getSession().getAttribute("users") != null){
			user = (String)request.getSession().getAttribute("users");
		}else {
			isLogin = false;
			user = (String)request.getSession().getAttribute("nousers");
		}
		String arriveTime = "";
		String moreWord = "";
		String tel = "";
		String address = "";
		String money = "";
		
		int sudu = 0;
		
		if(!isLogin){
			//arriveTime = request.getParameter("gettime_date") + request.getParameter("gettime_hour") +":"+request.getParameter("gettime_minute");
			address = request.getParameter("address");
			tel = request.getParameter("tel");
			if(request.getParameter("moreword") != null){
				moreWord = request.getParameter("moreword");
			}
		}else {
			//arriveTime = request.getParameter("gettime_date") + request.getParameter("gettime_hour") +":"+request.getParameter("gettime_minute");
			address = request.getParameter("address");
			tel = user;
			if(request.getParameter("moreword") != null){
				moreWord = request.getParameter("moreword");
			}
		}
		if(request.getParameter("money") != null){
			money = request.getParameter("money");
		}
		if(request.getParameter("sudu") != null){
			sudu = Integer.parseInt(request.getParameter("sudu"));
			if(request.getParameter("sudu").equals("1")){
				
				String str = "";
				switch(Integer.parseInt(request.getParameter("gettime_date"))){
					case 1:str = "今天";break;
					case 2:str = "明天";break;
					case 3:str = "后天";break;
				}
				arriveTime = str + request.getParameter("gettime_hour");
				
			}else if(request.getParameter("sudu").equals("2")){
				
				arriveTime = "打印后" + request.getParameter("timerange");
				
			}else if(request.getParameter("sudu").equals("3")){
				arriveTime = "打印后" + request.getParameter("timerange1");
			}
		}
		
				
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String result = null;
		try {
			con = Dbcp.getConnection();
			//得到用户要打印的文件
			pstmt = con.prepareStatement("select * from paths where user=? and finish=0");
			pstmt.setString(1, user);
			rs = pstmt.executeQuery();
			List<FileMsg> files = new ArrayList<FileMsg>();
			
			while(rs.next()){
				
				FileMsg file = new FileMsg();
				file.setId(rs.getInt("id"));
				file.setPath(rs.getString("path"));
				//file.setName(rs.getString("name"));
				//file.setPath(rs.getString("path"));
				//file.setTotalPage(Integer.parseInt(rs.getString("totalpage")));
				//file.setDate(rs.getString("date"));
				files.add(file);
			}
			
			Dbcp.closePreparedStatement(pstmt);
			
			//生成订单编号
			SimpleDateFormat df = new SimpleDateFormat("yyyyMMddHHmmss");
			String ordernum = df.format(new Date()) + new CreateMsgValidation().getNumbers();
			String savePath = this.getServletContext().getRealPath("/") + "orders/" + ordernum +"/";
			File dirFile = new File(savePath);
			if (!dirFile.exists()) {
				dirFile.mkdirs();
			}
			
			for(FileMsg f:files){
				
					pstmt = con.prepareStatement("insert into waitprint(fileid,address,tel,moreword,arrivetime,sudu) values(?,?,?,?,?,?)");
					pstmt.setInt(1, f.getId());
					pstmt.setString(2, address);
					pstmt.setString(3, tel);
					pstmt.setString(4, moreWord);
					pstmt.setString(5, arriveTime);
					pstmt.setInt(6, sudu);
					pstmt.executeUpdate();
					Dbcp.closePreparedStatement(pstmt);
				//更改paths表中文件finish为1，表示订单提交，等待收货,并且更新价格
				pstmt = con.prepareStatement("update paths set finish=1,date=?,ordernum=?,ordermoney=?,discount=? where id=?");
				pstmt.setString(1, new SimpleDateFormat("yyyy-MM-dd HH:mm").format(new Date()));
				pstmt.setString(2, ordernum);
				pstmt.setString(3, money);
				pstmt.setString(4, Double.toString(WebParams.discount));
				pstmt.setInt(5, f.getId());
				pstmt.executeUpdate();
				Dbcp.closePreparedStatement(pstmt);
				//创建订单编号为名称的文件夹，将对应订单移进去
				File file = new File(this.getServletContext().getRealPath("/") + "attached/" + f.getPath());
				FileUtils.copyFileToDirectory(file,new File(savePath));
				file.getAbsoluteFile().delete();
				
			}
			
			//发送短信通知
			SendMessage.send(WebParams.adtel, "admin","no");
			response.sendRedirect("orderstate");
			//request.getRequestDispatcher("orderstate").forward(request, response);
			
		} catch (Exception e) {
		
			e.printStackTrace();
			
		}finally{
			Dbcp.closeConnection(con);
			Dbcp.closePreparedStatement(pstmt);
		}
		}
		
	
}
