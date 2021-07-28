package imp.servlet;

import imp.unit.WebParams;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class SetNoTimeServlet extends HttpServlet{
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		doPost(req, resp);
	}
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		
		String ids = req.getParameter("ids");
		String fp = req.getParameter("fp");
		
		if(fp.equals("n1")){
			WebParams.ids = ids;
		}else if(fp.equals("n2")){
			WebParams.ids2 = ids;
		}else if(fp.equals("n3")){
			WebParams.ids3 = ids;
		}
		
		System.out.println("&:"+WebParams.ids);
		System.out.println("&:"+WebParams.ids2);
		System.out.println("&:"+WebParams.ids3);
		//System.out.println("):"+WebParams.ids);
		PrintWriter out = resp.getWriter();
		out.print("设置已生效");
		out.flush();
		out.close();
		// ServletContext application=this.getServletContext();          //设置Application属性  
		 //application.setAttribute("startTime", s);   
		 //application.setAttribute("endTime", e);   
		//System.out.println(WebParams.startTime+",");
	}

}
