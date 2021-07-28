package imp.servlet;

import imp.unit.WebParams;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class SetDiscountServlet extends HttpServlet{
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		doPost(req, resp);
	}
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		String fp = req.getParameter("fp");
		if(fp.equals("me")){
			Double discount = Double.parseDouble(req.getParameter("discount"));
			WebParams.discount = discount;
			
		}else if(fp.equals("ad")){
			Double adcount = Double.parseDouble(req.getParameter("adcount"));
			WebParams.adcount = adcount;
		}
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
