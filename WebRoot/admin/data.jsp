<%@page import="imp.bean.Order"%>
<%@page import="imp.unit.DealFileName"%>
<%@page import="imp.bean.WaitPrintFile"%>
<%@page import="imp.bean.Pagination"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
			
			
			
		});
		function changepage(){
		
			var page = $('#showtype').val();
			if(page == '1'){
				window.top.location.href = "queryorder";
			}
			if(page == '2'){
				window.top.location.href = "queryuserorder";	
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
				  	<li class="list-group-item"><a href="exfiles" style="color: black;">备用上传</a></li>
				  	 <li class="list-group-item" ><a href="usermanger" style="color: black;">系统管理</a></li>
				  	 <li class="list-group-item active" ><a href="queryorder" style="color: black;">数据报表</a></li>
				  </ul>
				</div>
 			</div>
 			<div class="col-md-10" style="margin-top: 30px;padding: 3px;">
 			
			<!--  -->
			<div class="panel panel-default">
				  <!-- Default panel contents -->
				  <div class="panel-heading" style="font-weight: bold;">数据统计</div>
				 	 <div class="panel-body" style="min-height: 500px;">
				 	 	  <form action="queryorder" method="post">
						   <span>查询条件</span>
						   <select id="showtype" onchange="changepage()">
						   	<option value="1">订单统计</option>
						   	<option value="2">用户统计</option>
						   </select>
						  
						  <!--   <select id="time" onchange="showDate();">
						   	<option value="1">按月</option>
						   	<option value="2">按日</option>
						   	<option value="3">按年</option>
						   	<option value="4">自定义时间段</option>
						   </select>
						  <span id="month" style="display: none;"> <input type="text" class="input" id="timemonth"/></span>
						  <span id="day" style="display: none;"> <input type="text" id="timeday" /></span>
						  <span id="year" style="display: none;"> <input type="text" id="timeyear" /></span>
						  <input type="hidden" id="selecttime" name="time"/>-->
						  时间区间
						 
						  <input type="text"  style="width: 30%" name="time"  <c:if test="${not empty requestScope.nowtime }">value="${requestScope.nowtime }"</c:if> title="【格式】 按年：2016；按月：2016-08；按日：2016-08-01;按时间段：2016-08-01:2016-08-07" placeholder="请按格式要求填写">
						   <input type="submit" value="查询" >
						  
						   <a style="float: right;margin-right: 10px;" class="btn btn-info btn-xs" href="admin/dataexcel.jsp"  target="_blank">导出excel</a>
					   </form>
					   <hr style="margin-top: 5px;">
				   		<table class="table table-hover table-bordered" id="tableExcel">
							<col width="15%">
							<thead>
								<tr>
									<th>订单日期</th>
									<th>订单编号</th>
									<th>商家折扣</th>
									<th>客户电话</th>
									<th>订单金额</th>
								
								</tr>
							</thead>
							<tbody>
							<c:if test="${empty requestScope.orders }">
								<tr><td colspan="4">暂无数据</td></tr>
							</c:if>
							
							<c:set var="sum" value="0"></c:set>
							<c:forEach items="${requestScope.orders }" var="i">
									<tr>
										<td>${fn:substring(i.date, 0, 10)}</td>
										<td><a href="queryusersearch?query=${i.ordernum }">${i.ordernum }</a></td>
										<td>${i.discount } </td>
										<td><a href="queryusersearch?query=${i.tel }">${i.tel }</a></td>
										<td>${i.money }</td>
									</tr>
									<c:set var="sum" value="${sum+i.money }"></c:set>
									
							</c:forEach>
							<c:if test="${not empty requestScope.orders }">
								<tr style="background-color: #E0E0E0;"><td colspan="5"><c:if test="${not empty requestScope.nowtime }">${requestScope.nowtime}</c:if> 总计 : 订单数量（<span style="color: red;">${fn:length(orders)}</span>）总金额（<span style="color: red;"><fmt:formatNumber value="${ sum}"></fmt:formatNumber></span>）</td></tr>
							</c:if>
							
				 	 	</tbody>
				 	 	</table>
				 	 </div>
				 
				</div>
 			</div>
 		</div>
  	</div>
  </body>
</html>
