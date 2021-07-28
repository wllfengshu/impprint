package imp.unit;

import imp.dbcp.Dbcp;

import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.mysql.jdbc.Connection;
import com.taobao.api.DefaultTaobaoClient;
import com.taobao.api.TaobaoClient;
import com.taobao.api.request.AlibabaAliqinFcSmsNumSendRequest;
import com.taobao.api.response.AlibabaAliqinFcSmsNumSendResponse;

public class SendMessage {
	
	public static void send(String tel,String fp,String ordernum){
		CreateMsgValidation createMsgValidation = new CreateMsgValidation();
		String random = createMsgValidation.getNumbers();
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
			//设置拒绝理由参数：yhy
			String r = "";
			java.sql.Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			try {
				con = Dbcp.getConnection();
				pstmt = con.prepareStatement("select reason from reasons where ordernum=?");
				pstmt.setString(1, ordernum);
				rs = pstmt.executeQuery();
				if(rs.next()){
					r = rs.getString("reason");
					req.setSmsParamString("{\"yhy\":\""+r+"\"}");
				}
				
			}catch (Exception e) {
				e.printStackTrace();
			}finally{
				Dbcp.closePreparedStatement(pstmt);
				Dbcp.closeConnection(con);
			}
			req.setSmsTemplateCode("SMS_11040048");
		}else if(fp.equals("admin")){
			req.setSmsTemplateCode("SMS_10406042");
			
		}
		AlibabaAliqinFcSmsNumSendResponse rsp = null;
		try {
			rsp = client.execute(req);
			System.out.println(rsp.getBody());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	
}
