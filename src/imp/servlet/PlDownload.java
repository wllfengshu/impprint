package imp.servlet;

import imp.dbcp.Dbcp;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import javax.persistence.criteria.From;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.itextpdf.text.pdf.codec.Base64.OutputStream;
import com.sun.org.apache.bcel.internal.generic.Select;

public class PlDownload extends HttpServlet{
	/**
	 * 
	 */
	static String savePath = null;
	static String ordernum = null;
	private static final long serialVersionUID = 1L;
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		doPost(req, resp);
	}
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		savePath = this.getServletContext().getRealPath("/") + "attached/temp/";
		ordernum = request.getParameter("ordernum");
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = Dbcp.getConnection();
			pstmt = con.prepareStatement("select path from paths where ordernum=?");
			pstmt.setString(1, ordernum);
			rs = pstmt.executeQuery();
			String filepath;
			List<File> files = new ArrayList<File>();
			while(rs.next()){
				filepath=request.getRealPath("/") + "orders/" + ordernum + "/" + rs.getString("path");
				files.add(new File(filepath));
			}
			downLoadFiles(files, request, response);
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			Dbcp.closePreparedStatement(pstmt);
			Dbcp.closeConnection(con);
			
		}
	}
	
	 public static HttpServletResponse downLoadFiles(List<File> files,
	            HttpServletRequest request, HttpServletResponse response)
	            throws Exception {
	        try {
	           
	            /**创建一个临时压缩文件，
	             * 我们会把文件流全部注入到这个文件中
	             * 这里的文件你可以自定义是.rar还是.zip*/
	        	
	            File file = new File(savePath + ordernum + ".rar");
	            if (!file.exists()){   
	                file.createNewFile();   
	            }
	            response.reset();
	            //response.getWriter()
	            //创建文件输出流
	            FileOutputStream fous = new FileOutputStream(file);   
	            /**打包的方法我们会用到ZipOutputStream这样一个输出流,
	             * 所以这里我们把输出流转换一下*/
	           ZipOutputStream zipOut 
	            = new ZipOutputStream(fous);
	            /**这个方法接受的就是一个所要打包文件的集合，
	             * 还有一个ZipOutputStream*/
	           zipFile(files, zipOut);
	            zipOut.close();
	            fous.close();
	           return downloadZip(file,response);
	        }catch (Exception e) {
	                e.printStackTrace();
	            }
	            /**直到文件的打包已经成功了，
	             * 文件的打包过程被我封装在FileUtil.zipFile这个静态方法中，
	             * 稍后会呈现出来，接下来的就是往客户端写数据了*/
	           
	     
	        return response ;
	    }

	  /**
	     * 把接受的全部文件打成压缩包 
	     * @param List<File>;  
	     * @param org.apache.tools.zip.ZipOutputStream  
	     */
	    public static void zipFile
	            (List files,ZipOutputStream outputStream) {
	        int size = files.size();
	        for(int i = 0; i < size; i++) {
	            File file = (File) files.get(i);
	            zipFile(file, outputStream);
	        }
	    }

	    public static HttpServletResponse downloadZip(File file,HttpServletResponse response) {
	        try {
	        // 以流的形式下载文件。
	        InputStream fis = new BufferedInputStream(new FileInputStream(file.getPath()));
	        byte[] buffer = new byte[fis.available()];
	        fis.read(buffer);
	        fis.close();
	        // 清空response
	        response.reset();

	        java.io.OutputStream toClient = new BufferedOutputStream(response.getOutputStream());
	        response.setContentType("application/octet-stream");

	//如果输出的是中文名的文件，在此处就要用URLEncoder.encode方法进行处理
	        response.setHeader("Content-Disposition", "attachment;filename=" +URLEncoder.encode(file.getName(), "UTF-8"));
	        toClient.write(buffer);
	        toClient.flush();
	        toClient.close();
	        } catch (IOException ex) {
	        ex.printStackTrace();
	        }finally{
	             try {
	                    File f = new File(file.getPath());
	                    f.delete();
	                } catch (Exception e) {
	                    e.printStackTrace();
	                }
	        }
	        return response;
	    }

	/**  
	     * 根据输入的文件与输出流对文件进行打包
	     * @param File
	     * @param org.apache.tools.zip.ZipOutputStream
	     */
	    public static void zipFile(File inputFile,
	            ZipOutputStream ouputStream) {
	        try {
	            if(inputFile.exists()) {
	                /**如果是目录的话这里是不采取操作的，
	                 * 至于目录的打包正在研究中*/
	                if (inputFile.isFile()) {
	                    FileInputStream IN = new FileInputStream(inputFile);
	                    BufferedInputStream bins = new BufferedInputStream(IN, 512);
	                    //org.apache.tools.zip.ZipEntry
	                    ZipEntry entry = new ZipEntry(inputFile.getName());
	                    ouputStream.putNextEntry(entry);
	                    // 向压缩文件中输出数据   
	                    int nNumber;
	                    byte[] buffer = new byte[512];
	                    while ((nNumber = bins.read(buffer)) != -1) {
	                        ouputStream.write(buffer, 0, nNumber);
	                    }
	                    // 关闭创建的流对象   
	                    bins.close();
	                    IN.close();
	                } else {
	                    try {
	                        File[] files = inputFile.listFiles();
	                        for (int i = 0; i < files.length; i++) {
	                            zipFile(files[i], ouputStream);
	                        }
	                    } catch (Exception e) {
	                        e.printStackTrace();
	                    }
	                }
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }

}
