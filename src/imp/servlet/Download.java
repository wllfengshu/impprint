package imp.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class Download extends HttpServlet{
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
		response.setContentType("text/html");
        javax.servlet.ServletOutputStream out = response.getOutputStream();
        String ordernum = request.getParameter("ordernum") + "/";
        String filepath=request.getRealPath("/") + "orders/" + ordernum + new String(request.getParameter("path").getBytes("ISO8859_1"),"utf-8").toString();
        String filename=new String(request.getParameter("name").getBytes("ISO8859_1"),"utf-8").toString();
       
        java.io.File file = new java.io.File(filepath);
        if (!file.exists()) {
         System.out.println(file.getAbsolutePath() + " 文件不存在!");
            return;
        }
        // 读取文件流
        java.io.FileInputStream fileInputStream = new java.io.FileInputStream(file);
            // 下载文件
            // 设置响应头和下载保存的文件名
            if (filename != null && filename.length() > 0) {
                response.setContentType("application/x-msdownload");
                response.setHeader("Content-Disposition", "attachment; filename=" + new String(filename.getBytes("utf-8"),"iso8859-1") + "");
                if (fileInputStream != null) {
                    int filelen = fileInputStream.available();
                    //文件太大时内存不能一次读出,要循环
                    byte a[] = new byte[filelen];
                    fileInputStream.read(a);
                    out.write(a);
                }
                fileInputStream.close();
                out.close();
            }
		
	}
}
