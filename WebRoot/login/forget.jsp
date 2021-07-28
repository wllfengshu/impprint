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
			$("#findpsw").click(function(){
			//alert($("#btncode").val().length);
			if($("#btncode").val().length == 0){
				
				alert("验证码未填写");
				return false;
			}
		});
		});
	
		var wait=60; 
		function time(o) { 
			if($("#telphone").val().length == 11){
				if(wait == 60){
					$.ajax({
					   type:"post",//请求方式
					   url:"sendmsg",//发送请求地址
					   data:{//发送给数据库的数据
					   tel:$("#telphone").val(),
					   
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
		            wait = 60;  
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
		    <form id="signupForm" method="post" action="modifypsw">
		       <p class="clearfix">
		        	<label class="one" for="telphone">手机号码：</label>
		        	<input id="telphone" name="telphone" class="required" value placeholder="请输入手机号" />
		        </p>
		         <p class="clearfix">
		        	<label class="one" >校验码：</label>
		            <input class="identifying_code" id="btncode" name="numbercode" type="text" value placeholder="请输入手机校验码" />
		            <input class="get_code" type="button" value="获取验证码" onclick="time(this);"/>
		        </p>
		        
		       	<p class="clearfix"><input class="submit" id="findpsw" type="submit" value="找回密码"/></p>   
		       <p class="last"><a href="login/login.jsp">立即登录&gt;</a></p>
		        
		        <p class="clearfix">
		         	<c:if test="${not empty requestScope.result }">
				    <p align="left" style="color: red;margin-left: 80px;">${requestScope.result }</p>
				    </c:if> 
				 </p>
		         
		    </form>
		   
		</div>
	 </div>
  </body>
</html>
