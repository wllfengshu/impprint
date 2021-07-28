<%@page import="imp.bean.WaitPrintFile"%>
<%@page import="imp.bean.Pagination"%>
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
	<style type="text/css">
		table{	font-size: 14px;
				width: 100%;   
            	table-layout: fixed;}
         td{   
            white-space: nowrap;/*控制单行显示*/   
            overflow: hidden;/*超出隐藏*/   
            text-overflow: ellipsis;/*隐藏的字符用省略号表示*/   
        }  
	</style>
	<script type="text/javascript">
	$(function(){
		$('.btn-delete').click(function(){
			
				var href =  $(this).attr('_href');
				var result = confirm('确认删除吗?');
				if(result){
					window.top.location.href=href;
					
				}
			});
	});
		
			
	</script>
  </head>
  
  <body style="background-color: #f4f4f4;">
  <%
  			String type = null;
  			if(session.getAttribute("type") != null){
  				type = (String)session.getAttribute("type");
  			}
  			if(type==null){
  				response.sendRedirect("index.jsp");
  			}else{
  				if(type.equals("user")){
  					response.sendRedirect("index.jsp");
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
				    <li class="list-group-item active"><a href="exfiles" style="color: black;">备用上传</a></li>
				  	 <li class="list-group-item" ><a href="usermanger" style="color: black;">系统管理</a></li>
				 	 <li class="list-group-item" ><a href="queryorder" style="color: black;">数据报表</a></li>
				  </ul>
				</div>
 			</div>
 			<div class="col-md-10" style="margin-top: 30px;padding: 3px;">
 			
			<!--  -->
			<div class="panel panel-default">
				  <!-- Default panel contents -->
				  <div class="panel-heading" style="font-weight: bold;">订单列表 </div>
				 	 <div class="panel-body" style="min-height: 500px;">
				 	 	<table class="table table-hover table-bordered">
							<col width="40%"><col width="25%"><col width="25%"><col width="10%">    
							<thead>
								<tr>
									
									<th>文件名称</th>
									<th>上传时间</th>
									<th>备注</th>
									<th>操作</th>
								</tr>
							</thead>
							<tbody>
							<c:if test="${empty requestScope.exfile }">
								<tr><td>暂无备用上传文件</td><td></td><td></td><td></tr>
							</c:if>
							<c:forEach items="${requestScope.exfile }" var="i">
								<tr>
									<td>${i.name }<a href="exdownload?path=${i.path }" title="${i.name }" target="_blank">下载</a></td>
									<td>${i.date }</td>
									<td><a style="color: black;" title="${i.word }">${i.word }</a></td>
									<td><a class="btn btn-danger btn-xs btn-delete"  _href="deleteexfile?id=${i.id }&path=${i.path}">删除</a></td>
								</tr>
							</c:forEach>
				 	 	</tbody>
				 	 	</table>
				 	 	<!--  <ul class="list-group">
				 	 		<c:forEach items="${requestScope.waitprintfiles }" var="i">
				 	 			<li class="list-group-item">${i.name }</li>
				 	 		</c:forEach>
				 	 	</ul>-->
				 	 
				 	 </div>
				 
				</div>
 			</div>
 		</div>
  	</div>
  </body>
</html>
