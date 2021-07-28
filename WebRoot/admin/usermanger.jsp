<%@page import="imp.unit.WebParams"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";


%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>印象打印</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<jsp:include page="../res/bootstrap.jsp"></jsp:include>
	<script type="text/javascript">
		
		$(function(){
		var str = $('#ids').val();
		var str2 = $('#ids2').val();
		var str3 = $('#ids3').val();
		checksatue(str,1);
		checksatue(str2,2);
		checksatue(str3,3);
		
		var st = $('#st').val();
		var et = $('#et').val();
		if(st == "8:00"){
			$('#starttime').find('option').eq(0).attr('selected','selected');
		}else if(st == "9:00"){
			$('#starttime').find('option').eq(1).attr('selected','selected');
		}else if(st == "10:00"){
			$('#starttime').find('option').eq(2).attr('selected','selected');
		}else if(st == "11:00"){
			$('#starttime').find('option').eq(3).attr('selected','selected');
		}else if(st == "12:00"){
			$('#starttime').find('option').eq(4).attr('selected','selected');
		}else if(st == "13:00"){
			$('#starttime').find('option').eq(5).attr('selected','selected');
		}else if(st == "14:00"){
			$('#starttime').find('option').eq(6).attr('selected','selected');
		}else if(st == "15:00"){
			$('#starttime').find('option').eq(7).attr('selected','selected');
		}else if(st == "16:00"){
			$('#starttime').find('option').eq(8).attr('selected','selected');
		}else if(st == "17:00"){
			$('#starttime').find('option').eq(9).attr('selected','selected');
		}else if(st == "18:00"){
			$('#starttime').find('option').eq(10).attr('selected','selected');
		}else if(st == "19:00"){
			$('#starttime').find('option').eq(11).attr('selected','selected');
		}else if(st == "20:00"){
			$('#starttime').find('option').eq(12).attr('selected','selected');
		}
		
		if(et == "9:00"){
			$('#endtime').find('option').eq(15).attr('selected','selected');
		}else if(et == "10:00"){
			$('#endtime').find('option').eq(14).attr('selected','selected');
		}else if(et == "11:00"){
			$('#endtime').find('option').eq(13).attr('selected','selected');
		}else if(et == "12:00"){
			$('#endtime').find('option').eq(12).attr('selected','selected');
		}else if(et == "13:00"){
			$('#endtime').find('option').eq(11).attr('selected','selected');
		}else if(et == "14:00"){
			$('#endtime').find('option').eq(10).attr('selected','selected');
		}else if(et == "15:00"){
			$('#endtime').find('option').eq(9).attr('selected','selected');
		}else if(et == "16:00"){
			$('#endtime').find('option').eq(8).attr('selected','selected');
		}else if(et == "17:00"){
			$('#endtime').find('option').eq(7).attr('selected','selected');
		}else if(et == "18:00"){
			$('#endtime').find('option').eq(6).attr('selected','selected');
		}else if(et == "19:00"){
			$('#endtime').find('option').eq(5).attr('selected','selected');
		}else if(et == "20:00"){
			$('#endtime').find('option').eq(4).attr('selected','selected');
		}else if(et == "21:00"){
			$('#endtime').find('option').eq(3).attr('selected','selected');
		}else if(et == "22:00"){
			$('#endtime').find('option').eq(2).attr('selected','selected');
		}else if(et == "23:00"){
			$('#endtime').find('option').eq(1).attr('selected','selected');
		}else if(et == "24:00"){
			$('#endtime').find('option').eq(0).attr('selected','selected');
		}
		//alert(str);
			$("#edp").click(function(){
			
				$(".editpsw").toggle(500);//显示隐藏切换,参数可以无,参数说明同上
			});
		
			$("#opsw").blur(function(){
				if($("#opsw").val().length>20 || $("#opsw").val().length<6){
					$("#opswtip").html("密码长度为6~20位字符");
					return false;
				}else{
					$("#opswtip").html("");
				}
			});
			$("#npsw").blur(function(){
				if($("#npsw").val().length>20 || $("#npsw").val().length<6){
					$("#npswtip").html("密码长度为6~20位字符");
					return false;
				}else{
					$("#npswtip").html("");
				}
			});
			$("#rnpsw").blur(function(){
				if($("#npsw").val()!= $("#rnpsw").val()){
					$("#rnpswtip").html("两次密码不匹配");
					return false;
				}else{
					$("#rnpswtip").html("");
				}
			});
			$(".psw-checkpsw").click(function(){
			 if($("#opsw").val().length==0&&$("#npsw").val().length==0&&$("#rnpsw").val().length==0){
					//alert("内容为空");
					$("#result").html("内容为空");
				}
				if($("#opsw").val().length>20 || $("#opsw").val().length<6){			
					return false;
				}
				if($("#npsw").val().length>20 || $("#npsw").val().length<6){			
					return false;
				}
				if($("#npsw").val()!= $("#rnpsw").val()){
		
					return false;
				}
				
				$.ajax({
                cache: true,
                type: "POST",
                url:"editpsw",
                data:$('#pswform').serialize(),// 你的formid
                async: false,
                error: function(request) {
                    alert("密码修改失败");
                },
                success: function(data) {
                    $("#result").parent().html(data);
                }
            });		
			});
			/////
			$("#nuser").click(function(){
				$(".adduser").toggle(500);//显示隐藏切换,参数可以无,参数说明同上
			});
		
			$("#newuser").blur(function(){
				if($("#newuser").val().length!=11){
					$("#newusertip").html("请输入正确的账号格式");
					return false;
				}else{
					$("#newusertip").html("");
				}
			});
			$("#defaultpsw").blur(function(){
				if($("#defaultpsw").val().length>20 || $("#defaultpsw").val().length<6){
					$("#newpswtip").html("密码长度为6~20位字符式");
					return false;
					
				}else{
					$("#newpswtip").html("");
				}
			});
			$(".adduser-check").click(function(){
				if($("#newuser").val().length!=11){
					return false;
				}
				if($("#defaultpsw").val().length>20 || $("#defaultpsw").val().length<6){
					return false;
				}
				$.ajax({
                cache: true,
                type: "POST",
                url:"adduser",
                data:$('#addform').serialize(),// 你的formid
               async: true,
                error: function(request) {
                    $("#addresult").parent().html("分配子账号失败");
                    
                },
                success: function(data,textStatus) {
                  // alert(data);
                    $("#addresult").parent().html(data);
                }
            });		
			});
			
			$('#settime').click(function(){
					if(true){
					$.ajax({
					
	                type: "post",
	                url:"settime",
	                data:{starttime:$('#starttime').val(),
	                	  endtime:$('#endtime').val()},// 你的formid
	              	
	                success: function(data,textStatus) {
	                   alert(data);
	                   // window.top.location.href="admin/usermanger.jsp";
	                    
	                }
	            });	
	            }			
			});
			$('.settel').click(function(){
				$.ajax({
	                type: "post",
	                url:"settel",
	                data:{tel:$('#adtel').val()
	          			 },// 你的formid
	              	
	                success: function(data,textStatus) {
	                   alert(data);
	                   // window.top.location.href="admin/usermanger.jsp";
	                    
	                }
	            });	
			});
			$('.setmsg').click(function(){
				$.ajax({
	                type: "post",
	                url:"setmsg",
	                data:{msg:$('#tipmsg').val()
	          			 },
	              	
	                success: function(data,textStatus) {
	                   alert(data);
	                   // window.top.location.href="admin/usermanger.jsp";
	                    
	                }
	            });	
			});
			
			$('.setdiscount').click(function(){
			var d = $('#discount').val();
			if(d<0 || d>1){
				alert("范围在0~1之间，请重新设置");
				return false;
			}
				$.ajax({
	                type: "post",
	                url:"setdiscount",
	                data:{discount:$('#discount').val(),
	                	  fp:"me"
	          			 },
	              	
	                success: function(data,textStatus) {
	                   alert(data);
	                   // window.top.location.href="admin/usermanger.jsp";
	                    
	                }
	            });	
			});
			$('.setad').click(function(){
			var d = $('#ad').val();
			if(d<0 || d>1){
				alert("范围在0~1之间，请重新设置");
				return false;
			}
				$.ajax({
	                type: "post",
	                url:"setdiscount",
	                data:{adcount:$('#ad').val(),
	                	  fp:"ad"
	          			 },
	              	
	                success: function(data,textStatus) {
	                   alert(data);
	                   // window.top.location.href="admin/usermanger.jsp";
	                    
	                }
	            });	
			});
			$('.setadtext').click(function(){
			var d = $('#word').val();
			if(d.length==0){
				alert("广告语为空,请重新设置");
				return false;
			}
				$.ajax({
	                type: "post",
	                url:"setadtext",
	                data:{msg:$('#word').val(),
	          			 },
	              	
	                success: function(data,textStatus) {
	                   alert(data);
	                   // window.top.location.href="admin/usermanger.jsp";
	                    
	                }
	            });	
			});
			
			$('.setnotime').click(function(){
				//复选框状态
			
			    text = $("input:checkbox[name='notime']:checked").map(function(index,elem) {
					return $(elem).val();
				}).get().join(',');
				//alert(text);
				$.ajax({
	                type: "post",
	                url:"setnotime",
	                data:{ids:text,
	                fp:"n1"
	          			 },
	                success: function(data,textStatus) {
	                   alert(data);
	                   // window.top.location.href="admin/usermanger.jsp";
	                    
	                }
	            });	
			});
			$('.setnotime2').click(function(){
				//复选框状态
			
			    text = $("input:checkbox[name='notime2']:checked").map(function(index,elem) {
					return $(elem).val();
				}).get().join(',');
				//alert(text);
				$.ajax({
	                type: "post",
	                url:"setnotime",
	                data:{ids:text,
	                fp:"n2"
	          			 },
	                success: function(data,textStatus) {
	                   alert(data);
	                   // window.top.location.href="admin/usermanger.jsp";
	                    
	                }
	            });	
			});
			$('.setnotime3').click(function(){
				//复选框状态
			
			    text = $("input:checkbox[name='notime3']:checked").map(function(index,elem) {
					return $(elem).val();
				}).get().join(',');
				//alert(text);
				$.ajax({
	                type: "post",
	                url:"setnotime",
	                data:{ids:text,
	                fp:"n3"
	          			 },
	                success: function(data,textStatus) {
	                   alert(data);
	                   // window.top.location.href="admin/usermanger.jsp";
	                    
	                }
	            });	
			});
			
		});
		
		function checksatue(str,fp){
			strs=str.split(","); //字符分割 
			var f;
			if(fp == 1){
				f = "";
			}
			if(fp == 2){
				f = "_2";
			}
			if(fp == 3){
				f = "_3";
			}
		for(var i = 0;i < strs.length;i++){
				if(strs[i] == "no1"){
					$('#no1'+f).attr("checked",'true');
				}
				if(strs[i] == "no2"){
					$('#no2'+f).attr("checked",'true');
				}
				if(strs[i] == "no3"){
					$('#no3'+f).attr("checked",'true');
				}
				if(strs[i] == "no4"){
					$('#no4'+f).attr("checked",'true');
				}
				if(strs[i] == "no5"){
					$('#no5'+f).attr("checked",'true');
				}
				if(strs[i] == "no6"){
					$('#no6'+f).attr("checked",'true');
				}
				if(strs[i] == "no7"){
					$('#no7'+f).attr("checked",'true');
				}
			}
		}
		//定时刷新检测有无新订单
		function myrefresh(){
		
			$.ajax({
				cache: false,
				type: "POST",
                url:"newordernumber?_"+new Date(),
                //请求成功后的回调函数有两个参数
				success:function(data,textStatus){
					$('.badge').html(data);
				}
					   
                
			});
		  // window.location.reload();
		}
		setInterval( myrefresh, 3000);
	</script>
  </head>
  
  <body style="background-color: #f4f4f4;">
  <input type="hidden" id="ids" value="<%=WebParams.ids%>"/>
  <input type="hidden" id="ids2" value="<%=WebParams.ids2%>"/>
  <input type="hidden" id="ids3" value="<%=WebParams.ids3%>"/>
  <input type="hidden" value="<%=WebParams.startTime%>" id="st"/>
  <input type="hidden" value="<%=WebParams.endTime%>" id="et"/>
  <%
  			String type = null;
  			if(session.getAttribute("type") != null){
  				type = (String)session.getAttribute("type");
  			}
  			if(type==null){
  				response.sendRedirect(basePath+"index.jsp");
  			}else{
  				if(type.equals("user")){
  					response.sendRedirect(basePath+"index.jsp");
  				}
  			}
  		 %>
  	<div class="container-fluid" >
  		 <div class="row" style="background-color: #333333;height: 50px;">
  		 	 <div style="float: left;margin-left: 20px;margin-top: 5px;"><img src="<%=basePath %>image/logo.png" width="80px" height="40px"/></div>
 			<div style="float: right;margin-right: 10px;margin-top: 10px;"><a class="btn btn-default btn-sm" href="login/exituser.jsp"> 退出后台</a></div>
 			<h4 align="center" style="color: #e5e5e5;">印象打印后台管理系统</h4>
 		</div>
 		<div class="row">
 			<div class="col-md-2" style="margin-top: 30px;">
			 	<div class="panel panel-default">
				  <!-- Default panel contents -->
				  <div class="panel-heading" style="font-weight: bold;">功能菜单</div>
				 
				  <!-- List group -->
				  <ul class="list-group">
				  
				    <li class="list-group-item"><span class="badge"></span><a href="waitorder" style="color: black;">待确认订单</a></li>
				    <li class="list-group-item"><a href="sendfile" style="color: black;">待送货订单</a></li>
				    <li class="list-group-item"><a href="orderfinish" style="color: black;">已结束订单</a></li>
				  	 <li class="list-group-item"><a href="exfiles" style="color: black;">备用上传</a></li>
				  	 <li class="list-group-item active" ><a href="usermanger" style="color: black;">系统管理</a></li>
				  	 <li class="list-group-item" ><a href="queryorder" style="color: black;">数据报表</a></li>
				  </ul>
				</div>
 			</div>
 			<div class="col-md-10" style="margin-top: 30px;padding: 3px;">
 				<div class="panel panel-default">
				  <!-- Default panel contents -->
				  <div class="panel-heading" style="font-weight: bold;">账号信息</div>
				  <div class="panel-body" style="min-height: 200px;">
				     <div><p style="padding-top: 20px;margin-left: 20px;">账号：${sessionScope.users} <a class="btn btn-danger btn-xs" id="edp" style="margin-left: 10px;">修改密码</a>
				     <c:if test="${sessionScope.type == 'root' }"><a class="btn btn-success btn-xs" id="nuser" style="margin-left: 10px;">分配子账号</a></c:if></p>
						 	 	<!-- 修改密码 -->
						 	 	<div class="editpsw" style="width:60%;margin-left: 20%;display: none;">
						 	 	<hr>
						 	 		<form class="form-horizontal" id="pswform" action="editpsw" method="post">
										        	<input type="hidden" class="form-control"  name="user" value="${sessionScope.users}">
											     	  <div class="form-group">
													    <label for="inputEmail3" class="col-sm-2 control-label">原始密码</label>
													    <div class="col-sm-10">
													      <input type="text" class="form-control" id="opsw" name="oldpassword" value="">
													      <label id="opswtip" style="color: red;"></label>
													    </div>
													  </div>
											     	 <div class="form-group">
													    <label for="inputEmail3" class="col-sm-2 control-label">新密码</label>
													    <div class="col-sm-10">
													      <input type="password" class="form-control" id="npsw" name="password" value="">
													    	 <label id="npswtip" style="color: red;"></label>
													    </div>
													  </div>
													  <div class="form-group">
													    <label for="inputPassword3" class="col-sm-2 control-label">确认密码</label>
													    <div class="col-sm-10">
													     	<input type="password" class="form-control" id="rnpsw" name="rpassword" value="">
													    <label id="rnpswtip" style="color: red;"></label>
													    </div>
													  </div>
											   		
											   		 <div class="form-group">
													    <div class="col-sm-offset-2 col-sm-10">
											
													      <button type="submit" class="btn btn-info psw-checkpsw"><span class="glyphicon glyphicon-ok"></span> 提交</button>
													       <button type="reset" class="btn btn-danger"><span class="glyphicon glyphicon-share-alt"></span> 重置</button>
													    </div>
													  </div>
													   <div id="result" style="color: red;"></div>
													   
										        </form>
						 	 	</div>
						 	 	<!-- 修改密码 -->
						 	 	<!--分配账号 -->
						 	 	<div class="adduser" style="width:60%;margin-left: 20%;display: none;">
						 	 	<hr>
						 	 		<form class="form-horizontal" id="addform" action="adduser" method="post">
										        
											     	  <div class="form-group">
													    <label for="inputEmail3" class="col-sm-2 control-label">用户账号</label>
													    <div class="col-sm-10">
													      <input type="text" class="form-control" id="newuser" name="newuser" value="" placeholder="11位手机号格式">
													      <label id="newusertip" style="color: red;"></label>
													    </div>
													  </div>
											     	 <div class="form-group">
													    <label for="inputEmail3" class="col-sm-2 control-label">初始密码</label>
													    <div class="col-sm-10">
													      <input type="text" class="form-control" id="defaultpsw" name="defaultpsw" value="">
													    	 <label id="newpswtip" style="color: red;"></label>
													    </div>
													  </div>
													  
											   		 <div class="form-group">
													    <div class="col-sm-offset-2 col-sm-10">
											
													      <button type="submit" class="btn btn-info adduser-check"><span class="glyphicon glyphicon-ok"></span> 确认</button>
													       <button type="reset" class="btn btn-danger"><span class="glyphicon glyphicon-share-alt"></span> 重置</button>
													    </div>
													  </div>
													   <div id="addresult" style="color: red;"></div>
													   
										        </form>
						 	 	</div>
						 	 	<!-- 分配账号 -->
						 	 </div>
				  </div>
				
				</div>
			<!--  -->
			<div class="panel panel-default">
				  <!-- Default panel contents -->
				  <div class="panel-heading" style="font-weight: bold;">网站管理</div>
				 	 <div class="panel-body" style="min-height: 300px;">
				 	 	
				 	 		<div class="row">
								<label for="inputEmail3" class="col-sm-2 ">营业时间</label>
								<div class="col-sm-10" style="padding: 3px;">
									开始时间：<select class="" id="starttime" name="starttime" style="background-color: transparent;">
											<option value="8:00">08：00</option>										
											<option value="9:00">09：00</option>										
											<option value="10:00">10：00</option>										
											<option value="11:00">11：00</option>										
											<option value="12:00">12：00</option>										
											<option value="13:00">13：00</option>										
											<option value="14:00">14：00</option>										
											<option value="15:00">15：00</option>										
											<option value="16:00">16：00</option>										
											<option value="17:00">17：00</option>										
											<option value="18:00">18：00</option>										
											<option value="19:00">19：00</option>										
											<option value="20:00">20：00</option>										
									</select>
									&nbsp;
									结束时间：<select class="" id="endtime" name="endtime" style="background-color: transparent;">
											<option value="24:00">24：00</option>
											<option value="23:00">23：00</option>
											<option value="22:00">22：00</option>
											<option value="21:00" selected="selected">21：00</option>	
											<option value="20:00">20：00</option>
											<option value="19:00">19：00</option>
											<option value="18:00">18：00</option>
																					
											<option value="17:00">17：00</option>										
											<option value="16:00">16：00</option>										
											<option value="15:00">15：00</option>										
											<option value="14:00">14：00</option>										
											<option value="13:00">13：00</option>										
											<option value="12:00">12：00</option>										
											<option value="11:00">11：00</option>										
											<option value="10:00">10：00</option>										
											<option value="9:00">09：00</option>										
																				
																					
									</select>
									<input type="button" id="settime" value="提交"/>
								</div>
								
							</div>
							<hr>
							<div class="row">
				 	 			<label for="inputEmail3" class="col-sm-2 ">禁用时间段（今天）</label>
								<div class="col-sm-10">
								<label style="font-weight: normal;margin-right: 10px;"><input type="checkbox" id="no1" name="notime" value="no1"/>09:40~10:20</label>	
								<label style="font-weight: normal;margin-right: 10px;"><input type="checkbox" id="no2" name="notime" value="no2"/>12:30~13:00</label>	
								<label style="font-weight: normal;margin-right: 10px;"><input type="checkbox" id="no3" name="notime" value="no3"/>13:40~14:10</label>	
								<label style="font-weight: normal;margin-right: 10px;"><input type="checkbox" id="no4" name="notime" value="no4"/>15:20~15:50</label><br>	
								<label style="font-weight: normal;margin-right: 10px;"><input type="checkbox" id="no5" name="notime" value="no5"/>17:40~18:10</label>	
								<label style="font-weight: normal;margin-right: 10px;"><input type="checkbox" id="no6" name="notime" value="no6"/>18:40~19:10</label>	
								<label style="font-weight: normal;margin-right: 10px;"><input type="checkbox" id="no7" name="notime" value="no7"/>21:10~21:40</label>	
								<input type="button" class="setnotime" value="提交"/>
								</div>
				 	 		</div>
				 	 		<hr>
							<div class="row">
				 	 			<label for="inputEmail3" class="col-sm-2 ">禁用时间段（明天）</label>
								<div class="col-sm-10">
								<label style="font-weight: normal;margin-right: 10px;"><input type="checkbox" id="no1_2" name="notime2" value="no1"/>09:40~10:20</label>	
								<label style="font-weight: normal;margin-right: 10px;"><input type="checkbox" id="no2_2" name="notime2" value="no2"/>12:30~13:00</label>	
								<label style="font-weight: normal;margin-right: 10px;"><input type="checkbox" id="no3_2" name="notime2" value="no3"/>13:40~14:10</label>	
								<label style="font-weight: normal;margin-right: 10px;"><input type="checkbox" id="no4_2" name="notime2" value="no4"/>15:20~15:50</label><br>	
								<label style="font-weight: normal;margin-right: 10px;"><input type="checkbox" id="no5_2" name="notime2" value="no5"/>17:40~18:10</label>	
								<label style="font-weight: normal;margin-right: 10px;"><input type="checkbox" id="no6_2" name="notime2" value="no6"/>18:40~19:10</label>	
								<label style="font-weight: normal;margin-right: 10px;"><input type="checkbox" id="no7_2" name="notime2" value="no7"/>21:10~21:40</label>	
								<input type="button" class="setnotime2" value="提交"/>
								</div>
				 	 		</div>
				 	 		<hr>
							<div class="row">
				 	 			<label for="inputEmail3" class="col-sm-2 ">禁用时间段（后天）</label>
								<div class="col-sm-10">
								<label style="font-weight: normal;margin-right: 10px;"><input type="checkbox" id="no1_3" name="notime3" value="no1"/>09:40~10:20</label>	
								<label style="font-weight: normal;margin-right: 10px;"><input type="checkbox" id="no2_3" name="notime3" value="no2"/>12:30~13:00</label>	
								<label style="font-weight: normal;margin-right: 10px;"><input type="checkbox" id="no3_3" name="notime3" value="no3"/>13:40~14:10</label>	
								<label style="font-weight: normal;margin-right: 10px;"><input type="checkbox" id="no4_3" name="notime3" value="no4"/>15:20~15:50</label><br>	
								<label style="font-weight: normal;margin-right: 10px;"><input type="checkbox" id="no5_3" name="notime3" value="no5"/>17:40~18:10</label>	
								<label style="font-weight: normal;margin-right: 10px;"><input type="checkbox" id="no6_3" name="notime3" value="no6"/>18:40~19:10</label>	
								<label style="font-weight: normal;margin-right: 10px;"><input type="checkbox" id="no7_3" name="notime3" value="no7"/>21:10~21:40</label>	
								<input type="button" class="setnotime3" value="提交"/>
								</div>
				 	 		</div>
				 	 		
				 	 		<hr>
				 	 		<div class="row">
				 	 			<label for="inputEmail3" class="col-sm-2 ">接收订单通知手机号</label>
								<div class="col-sm-10">
								<input type="text" id="adtel" name="adtel" value="" placeholder="<%= WebParams.adtel%>"/>
								<input type="button" class="settel" value="提交"/>
								
								</div>
				 	 		</div>
				 	 		<hr>
				 	 		<div class="row">
				 	 			<label for="inputEmail3" class="col-sm-2 ">商家折扣设置</label>
								<div class="col-sm-10">
								<input type="text" id="discount" name="" value="" placeholder="<%= WebParams.discount%>"/>
								<input type="button" class="setdiscount" value="提交"/>
								
								</div>
				 	 		</div>
				 	 		<hr>
				 	 		<div class="row">
				 	 			<label for="inputEmail3" class="col-sm-2 ">广告折扣设置</label>
								<div class="col-sm-10">
								<input type="text" id="ad" name="" value="" placeholder="<%= WebParams.adcount%>"/>
								<input type="button" class="setad" value="提交"/>
								
								</div>
				 	 		</div>
				 	 		<hr>
				 	 		<div class="row">
				 	 			<label for="inputEmail3" class="col-sm-2 ">广告语设置</label>
								<div class="col-sm-10">
								<textarea rows="2" cols="62" id="word" placeholder="<%= WebParams.adtext%>"></textarea><br>
								<!--<input type="text" id="adtext" name="" value="" placeholder="<%= WebParams.adtext%>"/>-->
								<input type="button" class="setadtext" value="提交"/>
								
								</div>
				 	 		</div>
				 	 		<hr>
				 	 		<div class="row">
				 	 			<label for="inputEmail3" class="col-sm-2 ">系统提示</label>
								<div class="col-sm-10">
								<textarea rows="2" cols="62" id="tipmsg" placeholder="<%=WebParams.msg %>"></textarea><br>
									<!--  <input type="text" id="tipmsg" name="" value="<%=WebParams.msg %>" placeholder="<%=WebParams.msg %>"/>-->
								<input type="button" class="setmsg" value="提交"/>
								</div>
				 	 		</div>
				 	 </div>
				 
				</div>
 			</div>
 		</div>
  	</div>
  </body>
</html>
