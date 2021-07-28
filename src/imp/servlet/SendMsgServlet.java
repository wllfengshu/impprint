package imp.servlet;

import imp.dbcp.Dbcp;
import imp.unit.CreateMsgValidation;

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

import com.taobao.api.DefaultTaobaoClient;
import com.taobao.api.TaobaoClient;
import com.taobao.api.request.AlibabaAliqinFcSmsNumSendRequest;
import com.taobao.api.response.AlibabaAliqinFcSmsNumSendResponse;


public class SendMsgServlet extends HttpServlet {
	/**
	 * 
	 */
	public static String random = null;
	private static final long serialVersionUID = 1L;
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		doPost(req, resp);
	}
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
	
		//System.out.println("*****");
		String tel = "";
		if(request.getParameter("tel") != null){
			tel = request.getParameter("tel");
		}
		String fp = "";
		if(request.getParameter("fp") != null){
			fp = request.getParameter("fp");
		}
		
		CreateMsgValidation createMsgValidation = new CreateMsgValidation();
		random = createMsgValidation.getNumbers();
		//System.out.println(tel+","+numbers);
		TaobaoClient client = new DefaultTaobaoClient("http://gw.api.taobao.com/router/rest", "23359836", "bf8a161714e5020dfc44e3be5bf16922");
		AlibabaAliqinFcSmsNumSendRequest req = new AlibabaAliqinFcSmsNumSendRequest();
		//req.setExtend("123456");
		req.setSmsType("normal");
		req.setSmsFreeSignName("操作验证");///
		req.setRecNum(tel);
		if(fp.equals("recoll")){
			req.setSmsParamString("{\"vcode\":\""+random+"\"}");
			req.setSmsTemplateCode("SMS_9641373");////
		}else if(fp.equals("orderok")){
			req.setSmsTemplateCode("SMS_10305198");
		}else if(fp.equals("orderno")){
			req.setSmsTemplateCode("SMS_10275264");
			
		}
		
		AlibabaAliqinFcSmsNumSendResponse rsp = null;
		try {
			rsp = client.execute(req);
			System.out.println(rsp.getBody());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		PrintWriter out = response.getWriter();
		out.print(random);
		out.flush();
		out.close();
		
	}
}
