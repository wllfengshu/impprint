
<%@page import="imp.unit.CreateRandomUser"%>
<%@page import="imp.unit.WebParams"%>
<%@page import="imp.bean.FileMsg"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<%
  		List<FileMsg> fMsgs = (List<FileMsg>)request.getAttribute("fMsgs");
  		int filenumber = fMsgs.size();
  		double adcount = WebParams.adcount;
  		
 %>	
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>印象打印</title>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="印象打印,打印,在线打印,印象,impprint">
	<meta http-equiv="description" content="印象打印致力于帮助学生用户更方便快捷的打印资料,无需注册，简化操作，配送上门，让您享受不一样的服务！！">
	<jsp:include page="res/bootstrap.jsp"></jsp:include>
	<script type="text/javascript">

	var timer;
	$(function(){
		var islog = $('#islog').val();
		var fp = $('#fp').val();
		if(islog == 'n' && fp == 'y'){
			$('#log').click();
			
		}
		
			///////
			$('.tonext').click(function(){
				var n = <%=filenumber%>;
				if(n == 0){
					alert("未上传文件，不能进行下一步");
					return false;
				}
				if($('#pl_page').is(":hidden")){
					
					for(var i = 1;i <= n;i++){
						if($('#number'+i).val() <= 0 || isNaN($('#number'+i).val())){
							alert("数据有误，不能提交");
							return false;
						}
					}
					
				}else{
					if($('#pl_number').val() <= 0|| isNaN($('#pl_number').val())){
							alert("数据有误，不能提交");
							return false;
						}
				}
				for(var i = 1;i <= n;i++){
						if($('#total'+i).val() <= 0){
							alert("文件页数有误，不能提交");
							return false;
						}
				}
				var href =  $(this).attr('_href');
				var result = confirm('确定已设置完成吗?');
				if(result){
					
					if($('#pl_page').is(":hidden")){
						//未使用批量设计
						for(var i = 1;i <= <%= filenumber%>;i++){
							$.ajax({
								 type: "post",
					             url:"saveset",
					             data:{id:$('#fid'+i).val(),
					             	   page:$('#page'+i).val(),
					             	   fix:$('#fix'+i).val(),
					             	   color:$('#color'+i).val(),
					             	   number:$('#number'+i).val(),
					             	   pptpage:$('#pptpage'+i).val(),
					             	   totalpage:$('#total'+i).val(),
					             	   money:$('#price'+i).attr('value'),
					             	   ordermoney:$('#allmoney').attr('value'),
					             	   ad:$('#ad'+i).val()
					            	 },
					             async: false,
							});
						}
					}else{
						for(var i = 1;i <= <%= filenumber%>;i++){
							$.ajax({
								 type: "post",
					             url:"saveset",
					             data:{id:$('#fid'+i).val(),
					             	   page:$('#pl_page').val(),
					             	   fix:$('#pl_fix').val(),
					             	   color:$('#pl_color').val(),
					             	   number:$('#pl_number').val(),
					             	   pptpage:$('#pl_pptpage').val(),
					             	   totalpage:$('#total'+i).val(),
					             	   money:$('#price'+i).attr('value'),
					             	   ordermoney:$('#allmoney').attr('value'),
					             	   ad:$('#pl_ad').val()
					             	   },
					             	   
					             async: false,
							});
						}
					}
					window.top.location.href=href;
				}
			});
			$('.deleteuploadfile').click(function(){
				//var href =  $(this).attr('_href');
				var deleteid = $(this).attr('id');
				var result = confirm('确定删除吗?');
				if(result){
					//window.top.location.href=href;
					$.ajax({
		                cache: true,
		                type: "post",
		                url:"deleteuploadfile",
		                data:{id:deleteid,fp:"print"},// 你的formid
		                async: false,
		                error: function(request) {
		                    alert("删除失败");
		                },
		                success: function(data) {
		                	 window.top.location.href="printset";
		                  //alert("删除成功");
		                }
		            });		
				}
			});
			$('.btn-pl').click(function(){
				$('.plset').slideDown(300);
				$('.btn-pl').hide();
				$('.btn-pl-not').show();
				$('.set').hide();
				
			});
			$('.btn-pl-not').click(function(){
				$('.plset').hide();
				$('.btn-pl').show();
				$('.btn-pl-not').hide();
				$('.set').show();
			});
			$('.btn-cancel').click(function(){
				
				clearInterval(timer);
				window.top.location.href="printset";
			});
			
		});
		/*
			
		}*/
		var pronum;
		function checkFile() {
		//用元素的id获得该元素的值，从而进行判断选择的文件是否合法  
		var file = document.getElementById("uploadify").value;
		//alert("文件："+file) ;  
		if (file == null || file == "") {
			alert("未选择文件!");
			return false;
		}
		if (file.lastIndexOf(".") == -1) {
			alert("路径不正确!");
			return false;
		}
		var allType = ".doc|.docx|.ppt|.pptx|.pdf|.PDF|";
		var extName = file.substring(file.lastIndexOf("."));
		if (allType.indexOf(extName + "|") == -1) {

			errMsg = "该文件类型不允许上传。请上传 " + allType + " 类型的文件，当前文件类型为" + extName;
			
			alert(errMsg);
			return false;
		}
		
		/////
		//f1.submit();
		$('.progress').show();
		$('.fpdiv').show();
		
		$('#startup').hide();
		$('.btn-cancel').show();
		//$('#startup').attr("value","点击取消上传");
		//$('#startup').attr("class","btn btn-danger btn-sm btn-cancel");
		timer=setInterval("getP()",200);
		
		return true;
		
	}
	function excheck(){
	
		var file = document.getElementById("exfiles").value;
		//alert("文件："+file) ;  
		if (file == null || file == "") {
			alert("未选择文件!");
			return false;
		}
		if (file.lastIndexOf(".") == -1) {
			alert("路径不正确!");
			return false;
		}
		timer=setInterval("getP1()",200);
	}
	function getP(){
		$.ajax({
				cache: false,
				type: "POST",
                url:"pro?&_"+new Date(),
              
                //请求成功后的回调函数有两个参数
				success:function(data,textStatus){
					strs=data.split(","); //字符分割 
					if(strs[0] == null||strs[0]==undefined||strs[0]==''){
						strs[0] = "加载中";
					}
					if(strs[2] == null||strs[2]==undefined||strs[2]==''){
						strs[2] = "加载中";
					}
					
					$('.progress-bar').attr("style","width:"+parseInt(strs[1])+"%");
					//$('.progress-bar').attr("aria-valuenow",parseInt(data));
					$('.fp').html("正在上传"+"("+strs[2]+")"+": "+strs[0]);
					$('.progress-bar').html(parseInt(strs[1])+"%");
					
				}
					   
                
			});
	}
	function getP1(){
		$.ajax({
				cache: false,
				type: "POST",
                url:"pro?&_"+new Date(),
              
                //请求成功后的回调函数有两个参数
				success:function(data,textStatus){
					$('.progress-bar1').attr("style","width:"+parseInt(data)+"%");
					//$('.progress-bar').attr("aria-valuenow",parseInt(data));
					
					$('.progress-bar1').html(parseInt(data)+"%");
					var d = parseInt(data);
					if(d == 100){
						alert("已上传");
					}
				}
					   
                
			});
	}
	function adtip(){
		var text = $('#adtext').val();
		$(this).attr("title",text);
	}
	function telValidate(){
		var tel = $('#tel').val();
		if(tel.length != 11){
			$('#telerror').html("请输入正确的手机号");
		}else{
			var myreg = /^(((13[0-9]{1})|(15[0-9]{1})|(18[0-9]{1}))+\d{8})$/; 
			if(!myreg.test(tel)) {
				$('#telerror').html("不是有效的手机号");
			}else{
				$('#telerror').html("");
			}
		}
	}
	function pswValidate(){
		var psw = $('#psw').val();
		if(psw.length <6||psw.length >20){
			$('#pswerror').html("密码长度6~20位数字或字符");
		}else{
			var reg = /^[0-9a-zA-Z]+$/;
			if(!reg.test(psw)){
				$('#pswerror').html("密码只能由数字或字母组成");

			}else{
				$('#pswerror').html("");
			}
		}
	}
	function yzmValidate(){
		var yzm = $('#yzm').val();
		if(yzm.length != 4){
			$('#yzmerror').html("验证码长度错误");
		}else{
			$('#yzmerror').html("");
		}var yzm = $(this).val();
		if(yzm.length != 4){
			$('#yzmerror').html("验证码长度错误");
		}else{
			$('#yzmerror').html("");
		}
	}
	function rpswValidate(){
		var rpsw = $('#rpsw').val();
		var psw = $('#psw').val();
		if(rpsw != psw){
			$('#rpswerror').html("两次密码不匹配");
		}else{
			$('#rpswerror').html("");
		}
	}

	var wait=120; 
	function time(o) { 
		$('#tel').blur();
		if($("#telerror").html().length == 0){
			if(wait == 120){
				$.ajax({
				   type:"post",//请求方式
				   url:"sendmsg",//发送请求地址
				   data:{//发送给数据库的数据
				   tel:$("#tel").val(),
				   fp:"recoll"
				   },
				   //请求成功后的回调函数有两个参数
				   success:function(data,textStatus){
				   //window.top.location.href="";
				   }
				   });
				 
			}
			
			////
			 if (wait == 0) {  
	            o.removeAttribute("disabled");            
	            o.value="获取验证码";  
	            wait = 120;  
	        } else {  
	            o.setAttribute("disabled", true);  
	            o.value="重新发送(" + wait + ")";  
	            wait--;  
	            setTimeout(function() {  
	                time(o)  
	            },  
	            1000)  
	        }  
		} 
	   
	}  

	function postform(which){
		var action;
		var formid;
		var formvalidate =false;//表单验证是否满足
		if(which == 1){
			$('#pswerror').blur();
			$('#telerror').blur();
			if($('#pswerror').html().length != 0 || $('#telerror').html().length != 0){
				return false;
			}
			action = 'login';
			formid = 'loginform';
		}
		if(which == 2){
			$('#pswerror').blur();
			$('#rpswerror').blur();
			$('#telerror').blur();
			$('#yzmerror').blur();
			if($('#pswerror').html().length != 0 || $('#telerror').html().length != 0 ||$('#rpswerror').html().length != 0||$('#yzm').html().length != 0 ){
				return false;
			}
			action = 'recoll';
			formid = 'recollform';
		}
		if(which == 3){
			$('#yzmerror').blur();
			$('#telerror').blur();
			if($('#yzmerror').html().length != 0 || $('#telerror').html().length != 0){
				return false;
			}
			action = 'modifypsw';
			formid = 'modifyform';
		}
		var state = false;
		$.ajax({
			cache: true,
	        type: "POST",
	        url:action,
	        data:$('#'+formid).serialize(),// 你的formid
	        async: false,
	        error: function(request) {
	            alert("提交失败");
	        },
	        success: function(data) {
	           
	            if(data == 'user'){
	            	state = true;
	            	alert("登录成功");
	            }else if(data == 'admin'){
	            	
	            	window.location.href="waitorder";
	            }else{
	            	 $("#result").html(data);
	            	
	            }
	        }
			
		});
		
		 return state;
		
	}

	//显示界面
	function showlogin(which){
		$('#showdiv').html('');
			var htmls ='';
			if(which == 1){//登录界面
				htmls = '<form id="loginform" class="form-horizontal" method="post" >';
				htmls += '<div class="form-group">';
			    htmls += '<label for="inputEmail3" class="col-sm-2 control-label">手机号码</label>';
			    htmls += '<div class="col-sm-10">';
			    htmls += '<input type="text" class="form-control" id="tel" name="telphone" placeholder="11位手机号" onblur="telValidate();">';
			    htmls += '<p id="telerror" style="color:red;"></p>';
			    htmls += '</div>';
			  	htmls += '</div>';
			  	htmls += '<div class="form-group">';
			    htmls += '<label for="inputPassword3" class="col-sm-2 control-label">登录密码</label>';
			    htmls += '<div class="col-sm-10">';
			    htmls += '<input type="password" class="form-control" id="psw" name="password" placeholder="6~20位字符" onblur="pswValidate();">';
			    htmls += '<p id="pswerror" style="color:red;"></p>';
			    htmls += '</div>';
			  	htmls += '</div>';
			  	htmls += '<div class="form-group">';
			    htmls += '<div class="col-sm-offset-2 col-sm-10">';
			    htmls += '<button type="submit" class="btn btn-default" onclick="return postform(1);">提交</button>';
			    htmls += '</div>';
			  	htmls += '</div>';
			  	htmls += '<div class="form-group">';
			    htmls += '<div class="col-sm-offset-2 col-sm-10">';
				htmls += '<p id="result" style="color: red;"></p>';
			    htmls += '</div>';
			  	htmls += '</div>';
				htmls += '</form>';
			}
			if(which == 2){//注册界面
				
				htmls = '<form id="recollform" class="form-horizontal" method="post">';
				htmls += '<div class="form-group">';
			    htmls += '<label for="inputEmail3" class="col-sm-2 control-label">手机号码</label>';
			    htmls += '<div class="col-sm-10">';
			    htmls += '<input type="text" class="form-control" id="tel" name="telphone" placeholder="11位手机号" onblur="telValidate();">';
			    htmls += '<p id="telerror" style="color:red;"></p>';
			    htmls += '</div>';
			  	htmls += '</div>';
			    htmls += '<div class="form-group">';
			    htmls += '<label for="inputEmail3" class="col-sm-2 control-label">验证码</label>';
			    htmls += '<div class="col-sm-10">';
			    htmls += '<div class="row">';
			    htmls += '<div class="col-sm-9"><input type="text" class="form-control"  id="yzm" name="numbercode" placeholder="" onblur="yzmValidate();"></div>';
			    htmls += '<div class="col-sm-3"> <input style="float: right;" class="btn btn-primary" type="button" value="获取验证码" onclick="time(this);"/></div>';
			    htmls += '<p id="yzmerror" style="color:red;"></p>';
			    htmls += '</div>';
			    htmls += '</div>';
			    htmls += '</div>';
			    htmls += '<div class="form-group">';
			    htmls += '<label for="inputPassword3" class="col-sm-2 control-label">登录密码</label>';
			    htmls += '<div class="col-sm-10">';
			    htmls += '<input type="password" class="form-control" id="psw" name="password" placeholder="6~20位字符" onblur="pswValidate();">';
			    htmls += '<p id="pswerror" style="color:red;"></p>';
			    htmls += '</div>';
			  	htmls += '</div>';
			 	htmls += '<div class="form-group">';
			    htmls += '<label for="inputPassword3" class="col-sm-2 control-label">确认密码</label>';
			    htmls += '<div class="col-sm-10">';
			    htmls += '<input type="password" class="form-control" id="rpsw" name="rpassword" placeholder="6~20位字符" onblur="rpswValidate();">';
			    htmls += '<p id="rpswerror" style="color:red;"></p>';
			    htmls += '</div>';
			  	htmls += '</div>';
			  	htmls += '<div class="form-group">';
			    htmls += '<div class="col-sm-offset-2 col-sm-10">';
			    htmls += '<button type="submit" class="btn btn-default" onclick="return postform(2);">提交</button>';
			    htmls += '</div>';
			  	htmls += '</div>';
			  	htmls += '<div class="form-group">';
			    htmls += '<div class="col-sm-offset-2 col-sm-10">';
			    htmls += '<p id="result" style="color: red;"></p>';
			    htmls += '</div>';
			  	htmls += '</div>';
				htmls += '</form>';
			}
			if(which == 3){//忘记密码
				htmls = '<form id="modifyform" class="form-horizontal" method="post" >';
				htmls += '<div class="form-group">';
			    htmls += '<label for="inputEmail3" class="col-sm-2 control-label">手机号码</label>';
			    htmls += '<div class="col-sm-10">';
			    htmls += '<input type="text" class="form-control" id="tel" name="telphone" placeholder="11位手机号" onblur="telValidate();">';
			    htmls += '<p id="telerror" style="color:red;"></p>';
			    htmls += '</div>';
			  	htmls += '</div>';
			 	htmls += '<div class="form-group">';
			    htmls += '<label for="inputEmail3" class="col-sm-2 control-label">验证码</label>';
			    htmls += '<div class="col-sm-10">';
			   	htmls += '<div class="row">';
			    htmls += '<div class="col-sm-9"><input type="text" class="form-control"  id="yzm" name="numbercode" placeholder="" onblur="yzmValidate();"></div>';
			   	htmls += '<div class="col-sm-3"> <input style="float: right;" class="btn btn-primary"  type="button" value="获取验证码" onclick="time(this);"/></div>';
			    htmls += '<p id="yzmerror" style="color:red;"></p>';
			   	htmls += '</div>';
			    htmls += '</div>';
			  	htmls += '</div>';
			    htmls += '<div class="form-group">';
			    htmls += '<div class="col-sm-offset-2 col-sm-10">';
			    htmls += '<button type="submit" class="btn btn-default" onclick="return postform(3);">提交</button>';
			    htmls += '</div>';
			  	htmls += '</div>';
			  	htmls += '<div class="form-group">';
			    htmls += '<div class="col-sm-offset-2 col-sm-10">';
			    htmls += '<p id="result" style="color: red;"></p>';
			    htmls += '</div>';
			  	htmls += '</div>';
				htmls += '</form>';
			}
			$('#showdiv').html(htmls);
		}

	</script>
  </head>
  
  <body style="background: #f4f4f4;">
  <c:if test="${empty sessionScope.users && empty sessionScope.nousers }">
				<%
					session.setAttribute("nousers",new CreateRandomUser().getNumbers() );
					//System.out.print(session.getAttribute("nousers"));
				 %>
  </c:if>
  <c:if test="${empty sessionScope.users }"><input type="hidden" id="islog" value="n"/></c:if>
  <c:if test="${not empty sessionScope.users }"><input type="hidden" id="islog" value="y"/></c:if>
  <c:if test="${requestScope.fp == 'index' }"><input type="hidden" id="fp" value="y"/></c:if>
  <c:if test="${requestScope.fp == 'noindex' }"><input type="hidden" id="fp" value="n"/></c:if>
  
  

    <div class="contaniter-fluid" style="">
				<div class="row">
					<ul class="breadcrumb" style="background-color: #333333;padding-top: 15px;padding-bottom: 15px;">
						 <li style="margin-left: 20px;"><a href="index.jsp">首页</a> <span class="divider"></span></li>
						
						 <li><a href="printset">文件上传</a></li>
						 <li class="active">配送设置</li>
						 <li class="active">订单管理</li>
						  <c:if test="${not empty sessionScope.users }">
							 <div class="active" style="float: right;margin-right: 20px;"><a class="" title="进入用户管理界面" href="usermenu?user=${sessionScope.users }" style="color: white;"> <img alt="用户" width="30px" height="30px" src="image/log.png"></a></div>
							</c:if>
							<c:if test="${empty sessionScope.users }">
							 <div class="active" style="float: right;margin-right: 20px;"><a class="" title="未登录，点击登录" data-toggle="modal" data-target="#logModal" style="color: white;"><img alt="用户" width="30px" height="30px" src="image/nolog.png"></a></div>
							</c:if>
						 <div class="active" style="float: right;margin-right: 15px;margin-top: 5px;"><a class="btn btn-danger btn-xs" title="未跟商家沟通请勿使用"  style="color: white;" data-toggle="modal" data-target="#myModal">备用上传通道</a></div>
						
					</ul>
				</div>
				<!-- Modal 备用上传-->
								<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
								  <div class="modal-dialog" role="document">
								    <div class="modal-content">
								      <div class="modal-header">
								        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
								        <h4 class="modal-title" id="myModalLabel">文件上传备用通道</h4>
								      </div>
								      <div class="modal-body" >
								        <form  method="post" action="exupload" class="form-horizontal" encType="multipart/form-data">
								        	<c:if test="${empty sessionScope.users}"><input type="hidden" id="" name="exuser" value="${sessionScope.nousers }"/></c:if>
				        					<c:if test="${not empty sessionScope.users}"><input type="hidden" id="" name="exuser" value="${sessionScope.users }"/></c:if>
							  
										   <div class="form-group">
										    <label class="control-label col-sm-2">选择文件</label>
										     <div class="col-sm-10">
										    <input type="file" class="" id="exfiles" name="exfiles">
										   </div>
										   </div>
										    <div class="form-group">
										    <label class="control-label col-sm-2">备注</label>
										     <div class="col-sm-10">
										   <textarea rows="3" cols="60" name="exword" placeholder="备注打印要求和补充说明"></textarea>
										   </div>
										   </div>
										    <div class="form-group">
										    <label class="control-label col-sm-2"></label>
										     <div class="col-sm-10">
										  <p style="color: red;">说明：如果有多个文件请打包后进行上传</p>
										   </div>
										   </div>
										 	<div class="form-group">
										 	  <label class="control-label col-sm-2"></label>
										 	   <div class="col-sm-10">
										   		 <button type="submit" id="add" onclick="return excheck(this);"><span class="glyphicon glyphicon-ok"></span> 确定</button>
											</div>
										   </div>
										  
										   <div class="form-group">
										     <label class="control-label col-sm-2"></label>
										 	   <div class="col-sm-10">
										 	  
										   <div class="progress " style="margin-right: 55px;">
										  
											  <div class="progress-bar progress-bar-success progress-bar-striped progress-bar1" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width: 0%">
											   0%
											  </div>
											</div>
											</div>
											</div>
										</form>
										
										
								      </div>
								      <div class="modal-footer">
								        <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
								        
								      </div>
								    </div>
								  </div>
								</div>
								<!-- Modal -->
				<div class="row" style="padding-top: 5px;">
					<div class="col-md-5 col-xs-4"></div>
					<div class="col-md-2 col-xs-4" align="center">
						<img alt="" src="image/fileup.png" width="50px" height="50px"><br>
						<h5 style="font-weight: bold;">文件上传</h5>
					</div>
					<div class="col-md-5 col-xs-4"></div>
				</div>
				<hr style="margin-top: 5px;background-color: grey;height: 1px;">
				<div class="row" style="min-height: 300px;">
					<div class="col-md-2 col-xs-1"></div>
					<div class="col-md-8 col-xs-10">
					<div class="row uploadarea" style="margin-top: 2px;background-color: white;height: 190px;padding-left: 30px;padding-top: 15px;margin-bottom: 10px;">
							<form action="upload" method="post" id="f1" name="f1" class="form-horizontal" encType="multipart/form-data">
					  	 		<c:if test="${empty sessionScope.users}"><input type="hidden" id="user" name="user" value="${sessionScope.nousers }"/></c:if>
				        		<c:if test="${not empty sessionScope.users}"><input type="hidden" id="user" name="user" value="${sessionScope.users }"/></c:if>
							  
					  	 		 <div class="form-group">
								  
								    <input type="file" accept="application/pdf,application/vnd.ms-powerpoint,application/msword,application/vnd.openxmlformats-officedocument.presentationml.presentation,application/vnd.openxmlformats-officedocument.wordprocessingml.document" name="uploadify" id="uploadify" multiple/>
								    <p class="help-block">只允许上传word、ppt和pdf格式文件,可同时选择多文件上传</p>
								    <input type="submit" class="btn btn-success btn-sm" id="startup" style="margin-top: 5px;" value="开始上传" onclick="return checkFile(this);"/>
								  
					  	 			<a class="btn btn-danger btn-sm btn-cancel" style="display: none;">取消上传</a>
								  </div>
								  <div class="form-group fpdiv" style="margin-right: 15px;display: none;">
								 <label></label> <label style="font-weight: normal;" class="fp"></label>
								  </div>
					  	 		<div class="progress form-group" style="margin-right: 15px;display: none;">
					  	 		 
								  <div class="progress-bar progress-bar-success progress-bar-striped" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width: 0%">
								   0%
								  </div>
								</div>
					  	 	</form>
					  	 	
					  	 	
						</div>
					<c:set value="<%=(int)adcount %>" var="ad"></c:set>
					<form class="form-horizontal"  action="printsetfinish" method="post">		
					<div class="row">
						<div  style="padding: 5px;">
						 <c:if test="${not empty sessionScope.users}"> <a class="btn btn-danger btn-xs" href="clearerror?user=${ sessionScope.users}" style="margin-bottom: 10px;float: right;margin-left: 3px;">删除全部</a></c:if>
   						 <c:if test="${not empty sessionScope.nousers}"> <a class="btn btn-danger btn-xs" href="clearerror?user=${ sessionScope.nousers}" style="margin-bottom: 10px;float: right;margin-left: 3px;">删除全部</a></c:if>
  
						<div class="plset" id="plset" style="display: none;float: left;">
							<label>批量设置:</label>
							<select class="" name="pl_page" id="pl_page" style="margin-left: 15px;background-color: transparent;" onchange="plset();">
											<option value="1">双面打印</option>
											<option value="2">单面打印</option>										
							</select>
						
							<select class="" name="pl_fix" id="pl_fix" style="margin-left: 15px;background-color: transparent;" onchange="plset();">
											<option value="1">每个装订</option>
											<option value="2">不装订</option>
																				
							</select>
							<select class="" name="pl_color" id="pl_color" style="margin-left: 15px;background-color: transparent;" onchange="plset();">
											<option value="1">黑白</option>
											<option value="2">彩印</option>
																				
							</select>
							
								<c:if test="${ad != 1 }">
											<select class="" name="ad" id="pl_ad" style="margin-left: 15px;background-color: transparent;" title="<%=WebParams.adtext%>" onchange="plset();">
															
															<option value="1">添加广告语(<%=adcount*10 %>折)</option>
															<option value="0">不添加广告语</option>								
											</select>
								</c:if>
								<c:if test="${ad == 1 }">
											<select class="" name="ad" id="pl_ad" style="margin-left: 15px;background-color: transparent;display: none;" onchange="plset();">
															<option value="-1">不添加广告语</option>
															
																								
											</select>
								</c:if>
							<select class="" name="pl_pptpage" id="pl_pptpage" title="只对ppt文件生效" style="margin-left: 15px;background-color: transparent;" onchange="plset();">
									<option value="0">ppt选项</option>
									<option value="1">每面1张</option>
									<option value="2">每面2张</option>															
									<option value="4">每面4张</option>
							</select>
							<label style="font-weight: normal;margin-left: 15px;">每个打印<input type="text" name="pl_number" id="pl_number" value="1" maxlength="3" style="width: 30px;background: transparent;" onchange="plset();" />份</label>
						</div>
						
						<div style="float: right;"><a class="btn btn-info btn-xs btn-pl" style="margin-bottom: 10px;">使用批量设置</a>
													<a class="btn btn-danger btn-xs btn-pl-not" style="margin-bottom: 10px;display: none;">不使用批量设置</a>
													<!-- <a class="btn btn-danger btn-xs btn-upload" style="margin-right: 10px;margin-bottom: 10px;">全部清空</a> -->
						</div>
						
						</div>
							
						</div>
						
						<div class="row" style="margin-top: 2px;">
							<div class="list-group">
								<c:if test="${empty requestScope.fMsgs }">
									<li class="list-group-item" style="background-color: transparent;color: red;padding: 30px;" >未上传任何文件</li>
								</c:if>
								<c:forEach items="${requestScope.fMsgs }" var="i" varStatus="n">
								
								 <li class="list-group-item" style="background-color: transparent;">
								 <div>
								 	<div class="row">
								 		<div style="padding: 10px;">
								 			<c:if test="${i.type =='doc' }"><img src="image/WORD.png" width="30px" height="30px"/></c:if>
											<c:if test="${i.type =='ppt' }"><img src="image/PPT.png" width="30px" height="30px"/></c:if>
											<c:if test="${i.type =='pdf' }"><img src="image/pdf.png" width="30px" height="30px"/></c:if>	
								 			<label style="font-weight: normal;">${i.name }</label>
								 			<a _href="deleteuploadfile?" id="${i.id }" class="deleteuploadfile" style="cursor: pointer;" title="删除"><img src="image/delete.png" width="30px" height="30px" style="float: right;margin-right: 10px;"/></a>
								 		</div>
								 		<div>
								 		<input type="hidden" id="fid${n.count }" value="${i.id }"/>
								 		<p style="margin-left: 50px;font-size: 11px;color: red;">
								 			<!-- 页数获取失败设置为1 -->
								 			<c:if test="${i.totalPage == 0}">文档含1页
								 			<input type="hidden" name="total${n.count }" id="total${n.count }" value="1"/>
								 			</c:if>
											<c:if test="${i.totalPage != 0}">文档含${i.totalPage}页
											<input type="hidden" name="total${n.count }" id="total${n.count }" value="${i.totalPage}"/>
											</c:if>
											<label id="price${n.count }" value="0" style="float: right;margin-right: 100px;font-size: 20px;font-weight: normal;"></label>
								 		</p>
								 		</div>	
								 		<div class="set" style="margin-left: 30px;">
								 			<select class="" name="page${n.count }" id="page${n.count }" style="margin-left: 15px;background-color: transparent;" onchange="getPrice(${n.count });">
												<option value="1">双面打印</option>
												<option value="2">单面打印</option>										
											</select>
											<select class="" name="fix${n.count }" id="fix${n.count }" style="margin-left: 15px;background-color: transparent;" onchange="getPrice(${n.count });">
												<option value="1">每个装订</option>
												<option value="2">不装订</option>
																						
											</select>
											<select class="" name="color${n.count }" id="color${n.count }" style="margin-left: 15px;background-color: transparent;" onchange="getPrice(${n.count });">
															<option value="1">黑白</option>
															<option value="2">彩印</option>
											</select>
											
											<c:if test="${ad != 1 }">
											<select class="" name="ad${n.count }" id="ad${n.count }" style="margin-left: 15px;background-color: transparent;" onchange="getPrice(${n.count });" title="<%=WebParams.adtext%>">
															<option value="1">添加广告语(<%=adcount*10 %>折)</option>
															<option value="0">不添加广告语</option>						
											</select>
											</c:if>
											<c:if test="${ad == 1 }">
											<select class="" name="ad${n.count }" id="ad${n.count }" style="margin-left: 15px;background-color: transparent;display: none;" onchange="getPrice(${n.count });">
															<option value="-1">不添加广告语</option>
														
																								
											</select>
											</c:if>
											<c:if test="${i.type =='ppt' }">
												<input type="hidden" id="isppt${n.count }" value="yes"/>
												<select class="" name="pptpage${n.count }" id="pptpage${n.count }" style="margin-left: 15px;background-color: transparent;" onchange="getPrice(${n.count });">
															<option value="1">每面1张</option>
															<option value="2">每面2张</option>															
															<option value="4">每面4张</option>
																								
												</select>
											</c:if>
											<c:if test="${i.type !='ppt' }">
												<input type="hidden" id="isppt${n.count }" value="no"/>
												<select class="" name="pptpage${n.count }" id="pptpage${n.count }" style="margin-left: 15px;background-color: transparent;display: none;">
															
															<option value="0"></option>
																								
												</select>
											</c:if>
											<label style="font-weight: normal;margin-left: 15px;">打印<input type="text" name="number${n.count }" id="number${n.count }" maxlength="3" value="1" style="width: 30px;background-color: transparent;" onchange="getPrice(${n.count });" />份</label>
								 		</div>
								 	</div>
								 	
								 </div>
								</li>
						</c:forEach>	 
							 
							 </div>
						</div>
						
						<div class="row" style="margin-top: 2px;padding: 5px;">
							<label style="font-weight: normal;">费用合计(元)：</label> <label type="text" id="allmoney" style="color: red;" value="" ></label><br>
							<label style="font-weight: normal;">说明：</label> <label style="color: red;font-weight: normal;" >文件页数如若出现不准确情况，可正常下单，联系客服确定价格</label>
						</div>
						
						</form>
						<script type="text/javascript">
							var adcount = <%= adcount%>;
							function getPrice(i){
								var total = $('#total'+i).val();
								var page = $('#page'+i).val();
								var fix = $('#fix'+i).val();
								var color = $('#color'+i).val();
								var pptpage = $('#pptpage'+i).val();
								var number = $('#number'+i).val();
								var ad = $('#ad'+i).val();
								if(number <= 0){
									//alert("打印份数应该大于0，请重新设置");
									number = 1;
									$('#number'+i).val("1");
									//$('#price'+i).html("打印份数错误");
									//return false;
								}
								if(isNaN(number)){
									number = 1;
									$('#number'+i).val("1");
									//alert("打印份数应该为数字");
									//return false;
								}
								
								var m = 0.1;//1毛钱每页
								if(page == 1 && pptpage == 0){//非ppt，双面打印
									//total = total % 2 == 0?total/2:parseInt(total/2)+1;
									total *= number;
								}else if(page == 2 && pptpage == 0){
									total *= number;
								}else if(pptpage != 0){
									total = total % pptpage == 0?total/pptpage:parseInt(total/pptpage)+1;
								}
								
								var money;
								if(color == 1){//黑白
								
									money = total * m;
									money = Math.floor(money * 100) / 100 ;//保留一位小数
								
								}else{
									money = total * m * 3;
									money = Math.floor(money * 100) / 100 ;
								}
								if(ad == 1){
									money = money * adcount;
									money = parseFloat(money).toFixed(1);
								}
								$('#price'+i).html(money+"元");
								$('#price'+i).attr("value",money);
								getallmoney();
							}
							
							function getPlPrice(i){
								var total = $('#total'+i).val();
								var page = $('#pl_page').val();
								var fix = $('#pl_fix').val();
								var color = $('#pl_color').val();
								var pptpage = $('#pl_pptpage').val();
								var number = $('#pl_number').val();
								var isppt = $('#isppt'+i).val();
								var ad = $('#pl_ad').val();
								if(isNaN(number)){
									number = 1;
									$('#pl_number').val("1");
									//alert("打印份数应该为数字");
									//return false;
								}
									//alert(page+","+color+","+pptpage);
								var mo = 0.1;//1毛钱每页
								if(page == 1 && isppt == "no"){//非ppt，双面打印
									//total = total % 2 == 0?total/2:parseInt(total/2)+1;
									total *= number;
									
								}else if(page == 2 && isppt == "no"){
									total *= number;
								
								}else if(isppt == "yes"){
									if(pptpage == 0){
										pptpage = 1;//批量ppt默认每面一张
									}
									total = total % pptpage == 0?total/pptpage:parseInt(total/pptpage)+1;
									total *= number;
								}
								
								var money;
								if(color == 1){//黑白
									//alert(money);
									money = total * mo;
									money = Math.floor(money * 100) / 100 ;//保留一位小数
								
								}else{
									money = total * mo * 3;
									money = Math.floor(money * 100) / 100 ;
								}
								if(ad == 1){
									money = money * adcount;
									money = parseFloat(money).toFixed(1);
								}
								$('#price'+i).html(money+"元");
								$('#price'+i).attr("value",money);
								getallmoney();
							}
							function plset(){
								var n = <%=filenumber%>;
								
								//var totalarray = new Array();
									for(var i = 1;i <= n;i++){
										if($('#pl_number').val() <= 0){
											$('#pl_number').val("1");
											//alert("打印份数应该大于0，请重新设置");
											//$('#price'+i).html("打印份数错误");
											//return false;
										}
										getPlPrice(i);
									//	totalarray.push($('#total'+i).val());
										
									}
							}
							function getallmoney(){
								var allmoney = 0;
								var n = <%=filenumber%>;
								for(var i = 1;i <= n;i++){
									allmoney += parseFloat($('#price'+i).attr("value"));
									
									
								}
								allmoney = parseFloat(allmoney).toFixed(1);
								$('#allmoney').html(allmoney);
								$('#allmoney').attr("value", allmoney);
							}
							$(function(){
								//初始状态
								
								var n = <%=filenumber%>;
								for(var i = 1;i <= n;i++){
									getPrice(i);
									
								}
								/////
								$('.btn-pl').click(function(){
									//批量初始状态
									plset();
									
								});
								$('.btn-pl-not').click(function(){
									//初始状态
								var n = <%=filenumber%>;
								for(var i = 1;i <= n;i++){
									getPrice(i);
									allmoney += parseFloat($('#price'+i).attr("value"));
								}
									
								});
								getallmoney();
							});
						</script>
					</div>
					<div class="col-md-2 col-xs-1"></div>
				</div>
				<hr style="margin-top: 5px;background-color: grey;height: 1px;">
						<div class="row" style="margin-top: 20px;"><div class="col-md-3"></div>
							<div class="col-md-6" align="middle">
																<c:if test="${empty sessionScope.users }"><a _href="submitset?user=${sessionScope.nousers }" title="下一步" class="tonext"><img alt="" src="image/right.png" width="50px" height="50px" style="margin-left: 30px;"></a></c:if>
																<c:if test="${not empty sessionScope.users }"><a _href="submitset?users=${sessionScope.users }" class="tonext" title="下一步" style="cursor: pointer;"><img alt="" src="image/right.png" width="50px" height="50px" style="margin-left: 30px;"></a></c:if>
																</div>
							<div class="col-md-3"></div>
						</div>
			</div>
		<div class="qq" style="position: fixed;right: 4%;bottom: 30px;cursor: pointer;"><br><p align="center" style="font-size: 12px;margin-top: -10px;"><a href="http://wpa.qq.com/msgrd?v=3&uin=949071759&site=qq&menu=yes" target="_blank" title="发起qq聊天"><img width="50" height="50" src="image/qq.png"/><br>联系我</a></p></div>
  	<a class="" id="log"  data-toggle="modal" data-target="#logModal"></a>
  <%@ include file="_loginmodal.jsp" %>
  </body>
  
</html>
