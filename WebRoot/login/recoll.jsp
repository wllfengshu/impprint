<%@page import="imp.unit.SendMessage"%>
<%@page import="imp.unit.CreateMsgValidation"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
	<link rel="stylesheet" type="text/css" href="login/css/base.css" />
	<link rel="stylesheet" type="text/css" href="login/css/register.css" />
	<script type="text/javascript" src="login/js/jq.js"></script>
	<script type="text/javascript" src="login/js/jquery.validate.js"></script>
	<script type="text/javascript" src="login/js/jquery.metadata.js"></script>
	<script type="text/javascript" src="login/js/resgin.js"></script>
	<script type="text/javascript">
		$(function(){
			$("#btnrecoll").click(function(){
			if($("#btncode").val().length !=4){
				//$(".tip").innerText("验证码错误");
				alert("验证码错误");
				return false;
			}
		});
		});
	
		var wait=120; 
		function time(o) { 
		
			if($("#telphone").val().length == 11){
				if(wait == 120){
				
					$.ajax({
					   type:"post",//请求方式
					   url:"sendmsg",//发送请求地址
					   data:{//发送给数据库的数据
					   tel:$("#telphone").val(),
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
			} else{
				alert("请正确填写手机号码");
			}
	       
	    }  
	    
	    
	</script>
  </head>
  
  <body>
  <div class="container-fluid">
 		<div class="row" style="background-color: #4d4d4d;height: 50px;">
 		<div style="float: right;margin-right: 10px;margin-top: 10px;"><a class="btn btn-default btn-sm" href="<%=basePath %>index.jsp"> 回到首页</a></div>
 			<h4 align="center" style="color: #e5e5e5;">印象打印</h4>
 		</div>
   		<div class="wrapper container">
		    <form id="signupForm" method="post" action="recoll">
		        <p class="clearfix">
		        	<label class="one" for="telphone">手机号码：</label>
		        	<input id="telphone" name="telphone" class="required" value placeholder="请输入手机号" />
		        </p>
		         <p class="clearfix">
		        	<label class="one" >校验码：</label>
		            <input class="identifying_code" id="btncode" name="numbercode" type="text" value placeholder="请输入手机校验码" />
		            <input class="get_code" type="button" value="获取验证码" onclick="time(this);"/>
		        </p>
		        <p class="clearfix">
		         	<label class="one"  for="password">登录密码：</label>
		        	<input id="password" name="password" type="password" class="{required:true,rangelength:[8,20],}" value placeholder="请输入密码" />
		        </p>
		        <p class="clearfix">
		        	<label class="one" for="confirm_password">确认密码：</label>
		        	<input id="confirm_password" name="confirm_password" type="password" class="{required:true,equalTo:'#password'}" value placeholder="请再次输入密码" />
		        </p>
		        
		        
		       	<p class="clearfix"><input class="submit" id="btnrecoll" type="submit" value="立即注册"/></p>   
		        <p class="last"><a href="login/login.jsp">立即登录&gt;</a></p>
		       
		       
		        <p class="clearfix">
		         	<c:if test="${not empty requestScope.result }">
				    <p align="left" style="color: red;margin-left: 80px;">${requestScope.result }</p>
				    </c:if> 
				    <p class="tip" align="left" style="color: red;margin-left: 80px;"></p>
				 </p>
		    </form>
		</div>
	 </div>
  </body>
</html>
