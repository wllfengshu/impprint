package imp.servlet;

import imp.bean.FileMsg;
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

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.codec.digest.DigestUtils;


public class WaitOrderServlet extends HttpServlet {
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
		Pagination pagination = new Pagination();
		if(request.getParameter("page") != null){
			pagination.setPage(Integer.parseInt(request.getParameter("page")));
		}
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = Dbcp.getConnection();
			pstmt = con.prepareStatement("select distinct ordernum from paths where finish=1 order by date desc");
			rs = pstmt.executeQuery();
			List<String> ordernumbers = new ArrayList<String>();
			List<String> pageorders = new ArrayList<String>();//当前页面订单编号集合
			while(rs.next()){
				ordernumbers.add(rs.getString("ordernum"));
			}
			Dbcp.closePreparedStatement(pstmt);
			pagination.setCount(ordernumbers.size());
			pagination.setTotal(pagination.getCount()%pagination.getRows()==0?pagination.getCount()/pagination.getRows():pagination.getCount()/pagination.getRows()+1);
			
			int start = (pagination.getPage() - 1)*pagination.getRows();
			int end;
			if(pagination.getPage() < pagination.getTotal()){
				end = (pagination.getPage() - 1)*pagination.getRows() + pagination.getRows();
			}else if(pagination.getPage() == pagination.getTotal()){
				end = pagination.getCount() % pagination.getRows()==0?start + 10:start + pagination.getCount() % pagination.getRows();
			}else {
				end=0;
			}
			//System.out.println("total:"+ordernumbers.size()+" start:"+start+" end:"+end);
			for(;start < end;start++){
				
				pageorders.add(ordernumbers.get(start));
				pstmt = con.prepareStatement("select * from paths where ordernum=? order by date desc");
				pstmt.setString(1, ordernumbers.get(start));
				rs = pstmt.executeQuery();
				List<WaitPrintFile> orders = new ArrayList<WaitPrintFile>();
				//double ordermoney = 0;
				while(rs.next()){
					WaitPrintFile file = new WaitPrintFile();
					file.setFileid(rs.getInt("id"));
					file.setName(rs.getString("name"));
					file.setPath(rs.getString("path"));
					file.setTime(rs.getString("date").substring(0,16));
					file.setPage(rs.getInt("page"));
					file.setFix(rs.getInt("fix"));
					file.setColor(rs.getInt("color"));
					file.setNumber(rs.getInt("number"));
					file.setMoney(rs.getDouble("money"));
					file.setOrdermoney(Math.round(rs.getDouble("ordermoney")*10)/10.0);
					//ordermoney += file.getMoney();
					file.setType(JudgeFileType.getFileType(rs.getString("path")));
					file.setAd(rs.getInt("ad"));
					file.setTotalPage(rs.getInt("totalpage"));
					orders.add(file);
				}
				Dbcp.closePreparedStatement(pstmt);
				//在waitprint表查询打印具体信息
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
				
				request.setAttribute(ordernumbers.get(start), orders);
			}
			request.setAttribute("pageorders", pageorders);
			request.setAttribute("pagination", pagination);
			request.getRequestDispatcher("admin/waitorder.jsp").forward(request, response);
			//
		/*	pstmt = con.prepareStatement("select * from paths where finish=1 limit ?,?");
			pstmt.setInt(1, (pagination.getPage() - 1)*pagination.getRows());
			pstmt.setInt(2, pagination.getRows());
			rs = pstmt.executeQuery();
			List<WaitPrintFile> files = new ArrayList<WaitPrintFile>();
			while(rs.next()){
				
				WaitPrintFile file = new WaitPrintFile();
				file.setFileid(rs.getInt("id"));
				file.setName(rs.getString("name"));
				file.setPath(rs.getString("path"));
				file.setTime(rs.getString("date").substring(0,16));
				file.setType(JudgeFileType.getFileType(rs.getString("path")));
				file.setPage(rs.getInt("page"));
				file.setFix(rs.getInt("fix"));
				file.setColor(rs.getInt("color"));
				file.setNumber(rs.getInt("number"));
				file.setMoney(rs.getDouble("money"));
				files.add(file);
			}
			
			Dbcp.closePreparedStatement(pstmt);
			//在waitprint表查询打印具体信息
			for(WaitPrintFile f:files){
				pstmt = con.prepareStatement("select * from waitprint where fileid=?");
				pstmt.setInt(1, f.getFileid() );
				rs = pstmt.executeQuery();
				if(rs.next()){
					f.setTel(rs.getString("tel"));
					f.setAddress(rs.getString("address"));
					f.setArrivetime(rs.getString("arrivetime"));
					f.setMoreword(rs.getString("moreword"));
				}
				Dbcp.closePreparedStatement(pstmt);
			}
			request.setAttribute("waitprintfiles", files);
			request.setAttribute("pagination", pagination);
			request.getRequestDispatcher("admin/waitorder.jsp").forward(request, response);*/
			
		} catch (Exception e) {
		
			e.printStackTrace();
		}finally{
			Dbcp.closeConnection(con);
			Dbcp.closePreparedStatement(pstmt);
		}
		}
		
	
}
