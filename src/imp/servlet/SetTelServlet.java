package imp.servlet;

import imp.unit.WebParams;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class SetTelServlet extends HttpServlet{
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		doPost(req, resp);
	}
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		
		String tel = req.getParameter("tel");
		WebParams.adtel = tel;
		PrintWriter out = resp.getWriter();
		out.print(tel+"接收短信设置成功");
		out.flush();
		out.close();
		// ServletContext application=this.getServletContext();          //设置Application属性  
		 //application.setAttribute("startTime", s);   
		 //application.setAttribute("endTime", e);   
		//System.out.println(WebParams.startTime+",");
	}

}
