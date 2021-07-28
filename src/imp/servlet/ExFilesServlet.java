package imp.servlet;

import imp.bean.Address;
import imp.bean.ExFile;
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

public class ExFilesServlet extends HttpServlet {
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
		List<ExFile> fMsgs = new ArrayList<ExFile>();
		try {
			con = Dbcp.getConnection();
			
			pstmt = con.prepareStatement("select * from expaths order by id desc");
			rs = pstmt.executeQuery();
			
			//String savePath = this.getServletContext().getRealPath("/") + "exattached/";
			while(rs.next()){
				ExFile exFile = new ExFile();
				exFile.setId(rs.getInt("id"));
				exFile.setPath(rs.getString("path"));
				exFile.setName(rs.getString("name"));
				exFile.setDate(rs.getString("date"));
				exFile.setUser(rs.getString("user"));
				exFile.setWord(rs.getString("word"));
				exFile.setType(JudgeFileType.getFileType(rs.getString("path")));
				fMsgs.add(exFile);
				
			}
			
			request.setAttribute("exfile", fMsgs);

			
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			Dbcp.closeConnection(con);
			Dbcp.closePreparedStatement(pstmt);
		}
		request.getRequestDispatcher("admin/exfiles.jsp").forward(request, response);
	}

}
