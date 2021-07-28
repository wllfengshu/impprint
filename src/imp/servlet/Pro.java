package imp.servlet;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class Pro extends HttpServlet {
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		doPost(req, resp);
	}
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		PrintWriter out = response.getWriter();
		String persent = (String)request.getSession().getAttribute("persent");
		String filename = (String)request.getSession().getAttribute("filename");
		String finish = (String)request.getSession().getAttribute("finish");
		if(filename == null){
			filename = "加载中";
			
		}
		if(finish == null){
			finish = "加载中";
		}
		out.print(filename+","+persent+","+finish);
		//System.out.println("pro"+persent);
		
		//if((String)request.getSession().getAttribute("persent") == "100"){
			//request.getSession().removeAttribute("persent");
			
	//	}
		out.flush();
		out.close();
	}

}
