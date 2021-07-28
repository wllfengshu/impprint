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
  </head>
  
  <body>
  <div class="container-fluid">
  		<div class="row" style="background-color: #4d4d4d;height: 50px;">
 		<div style="float: right;margin-right: 10px;margin-top: 10px;"><a class="btn btn-default btn-sm" href="<%=basePath %>index.jsp"> 回到首页</a></div>
 			<h4 align="center" style="color: #e5e5e5;">印象打印</h4>
 		</div>
 		
  		<div class="row">
  		<div class="col-md-3"></div>
   		<div class="wrapper container col-md-6">
		    <form id="signupForm" method="post" action="login">
		        <p class="clearfix" align="center">
		        	<label class="one" for="telphone">手机号码：</label>
		        	<input id="telphone" name="telphone" class="required" value placeholder="请输入手机号" />
		        </p>
		       
		        <p class="clearfix" align="center">
		         	<label class="one"  for="password">登录密码：</label>
		        	<input id="password" name="password" type="password" class="{required:true,rangelength:[8,20],}" value placeholder="请输入密码" />
		        </p>
		        
		       	<p class="clearfix"><input class="submit" type="submit" value="立即登录"/></p>   
		        <p class="last"><a href="login/recoll.jsp">立即注册&gt;</a></p>
		         <p class="last"><a href="login/forget.jsp">忘记密码&gt;</a></p>
		        <p class="clearfix">
		         	<c:if test="${not empty requestScope.result }">
				    <p align="left" style="color: red;margin-left: 80px;">${requestScope.result },请重新输入</p>
				    </c:if> 
				 </p>
		         
		    </form>
		   
		</div>
		<div class="col-md-3"></div>
		</div>
	 </div>
  </body>
</html>
