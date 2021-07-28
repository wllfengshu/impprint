package imp.servlet;


import imp.dbcp.Dbcp;
import imp.unit.WebParams;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Random;

import javax.jms.Session;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

public class ExUpload extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	//上传文件的保存路径
	protected String configPath = "exattached/";

	protected String dirTemp = "exattached/temp/";
	
	protected String dirName = "file";
	
	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		 doPost(request, response);
	}

	 
	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		//request.setCharacterEncoding("UTF-8");
		//response.setContentType("text/html; charset=UTF-8");
		PrintWriter out = response.getWriter();
		
		String user = "";
		String word = "";
		
		
		//文件保存目录路径
		String savePath = this.getServletContext().getRealPath("/") + configPath;
		
		// 临时文件目录 
		String tempPath = this.getServletContext().getRealPath("/") + dirTemp;
		
		//SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
		//String ymd = sdf.format(new Date());
		//savePath += "/" + ymd + "/";
		//创建文件夹
		File dirFile = new File(savePath);
		if (!dirFile.exists()) {
			dirFile.mkdirs();
		}
		
		//tempPath += "/" + ymd + "/";
		//创建临时文件夹
		File dirTempFile = new File(tempPath);
		if (!dirTempFile.exists()) {
			dirTempFile.mkdirs();
		}
		
		DiskFileItemFactory  factory = new DiskFileItemFactory();
		factory.setSizeThreshold(20 * 1024 * 1024); //设定使用内存超过20M时，将产生临时文件并存储于临时目录中。   
		factory.setRepository(new File(tempPath)); //设定存储临时文件的目录。   

		ServletFileUpload upload = new ServletFileUpload(factory);
		upload.setHeaderEncoding("UTF-8");
		
		
		Connection con = null;
		PreparedStatement pstmt = null;
		try {
			con = Dbcp.getConnection();
			List items = upload.parseRequest(request);
			Iterator itr = items.iterator();
			String newFileName = "";
			String exFileName = "";
			
			while (itr.hasNext()) {
				FileItem item = (FileItem) itr.next();
				String fileName = item.getName();
				long fileSize = item.getSize();
				if (!item.isFormField()) {
					String fileExt = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();
					
					SimpleDateFormat df = new SimpleDateFormat("MMddHHmmss");
					exFileName = fileName;
					String[]  str = fileName.split("\\.");
					newFileName = new Random().nextInt(1000)+ "_" + fileName;
					try{
						File uploadedFile = new File(savePath, newFileName);
						
						/*
						 * 第一种方法
						 * 
						 * 弊端： 这种方法会导致上传的文件大小比原来的文件要大
						 * 
						 * 推荐使用第二种
						 */
						//item.write(uploadedFile);
						//--------------------------------------------------------------------
						//第二种方法
	                    OutputStream os = new FileOutputStream(uploadedFile);
	                    InputStream is = item.getInputStream();
	                    byte buf[] = new byte[1024];//可以修改 1024 以提高读取速度
	                    int length = 0;
	                    double persent=0;
	                    //request.getSession().setAttribute("persent", 0);
	                    while( (length = is.read(buf)) > 0 ){  
	                    	
	                    	//计算文件进度
	                        os.write(buf, 0, length);
	                        persent+=length/(double)fileSize*100D;
	                        request.getSession().setAttribute("persent", Math.round(persent)+"");
	                        Thread.sleep(3);
	                       
	                    }  
	                    //关闭流  
	                    os.flush();
	                    os.close();  
	                    is.close();  
	                    //System.out.println("上传成功！路径："+savePath+"/"+newFileName);
	                    
	                  
	                    ////
	                  //  out.print("1");
					}catch(Exception e){
						e.printStackTrace();
					}
				}else {
					String filedName = item.getFieldName();
					if (filedName.equals("exuser")) {
						user= item.getString();
					}
					if(filedName.equals("exword")){
						word = new String(item.getString().getBytes("ISO-8859-1"),"utf-8");
						System.out.println(word);
					}
					}
				
					//System.out.println("FieldName："+filedName);
					//System.out.println("String："+item.getString("UTF-8"));//避免中文乱码
					//System.out.println("String()："+item.getString(item.getName()));
					//System.out.println("==============="); 
					
					
			} 
			  //保存到数据库
            SimpleDateFormat d = new SimpleDateFormat("yyyy-MM-dd HH:mm");
            String date = d.format(new Date());
            pstmt = con.prepareStatement("insert into expaths(path,name,word,user,date) values(?,?,?,?,?)");
            pstmt.setString(1, newFileName);
            pstmt.setString(2, exFileName);
            pstmt.setString(3, word);
            pstmt.setString(4, user);
            pstmt.setString(5, date);
            pstmt.executeUpdate();
            Dbcp.closePreparedStatement(pstmt);
			response.sendRedirect("printset");
			//request.getRequestDispatcher("printset").forward(request, response);	
			
		} catch (FileUploadException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally{
			Dbcp.closePreparedStatement(pstmt);
			Dbcp.closeConnection(con);
		}
		out.flush();
		out.close();
	
	}

}
