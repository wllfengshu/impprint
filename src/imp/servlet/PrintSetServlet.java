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

public class PrintSetServlet extends HttpServlet {
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
		//标识从index页面进入，
		String fp = null;
		if(request.getParameter("fp") != null){
			fp = request.getParameter("fp");
			request.setAttribute("fp", fp);
		}else {
			request.setAttribute("fp", "noindex");
		}
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<FileMsg> fMsgs = new ArrayList<FileMsg>();
		try {
			con = Dbcp.getConnection();
			
			pstmt = con.prepareStatement("select * from paths where user=? and finish=0 order by id desc");
			pstmt.setString(1, user);
			rs = pstmt.executeQuery();
			
			String savePath = this.getServletContext().getRealPath("/") + "attached/";
			while(rs.next()){
				FileMsg fm = new FileMsg();
				fm.setId(rs.getInt("id"));
				fm.setPath(rs.getString("path"));
				fm.setName(rs.getString("name"));
				fm.setDate(rs.getString("date"));
				fm.setType(JudgeFileType.getFileType(rs.getString("path")));
				String filepath = savePath+fm.getPath();
				if(fm.getType().equals("doc")){
					fm.setTotalPage(GetFilePages.getWordPage(filepath));
				}
				if(fm.getType().equals("pdf")){
					
					fm.setTotalPage(GetFilePages.getPdfPage(filepath));
					
				}
				if(fm.getType().equals("ppt")){
					
					fm.setTotalPage(GetFilePages.getPptPage(filepath));
					
				}
				//得到文档页数
				
				fMsgs.add(fm);
			}
			
		request.setAttribute("fMsgs", fMsgs);
		request.getRequestDispatcher("print.jsp").forward(request, response);
			
		} catch (Exception e) {
			request.setAttribute("error","出现错误，请点击修复按钮修复。" );
			request.getRequestDispatcher("fileerror.jsp").forward(request, response);
			//e.printStackTrace();
		}finally{
			Dbcp.closeConnection(con);
			Dbcp.closePreparedStatement(pstmt);
		}
		
	}

}
