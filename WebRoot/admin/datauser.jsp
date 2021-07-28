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
	<link rel="stylesheet" type="text/css"  href="res/monthSelect/jquery.monthpicker.css"/>
	<script src="res/monthSelect/jquery.monthpicker.js"></script>
	<script type="text/javascript">
		$(function(){
			//$('#monthly').monthpicker({
				//years: [2016, 2017, 2018, 2019, 2020],
		        //topOffset: 6
			//})
			
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
		/*function showDate(){
			var t = $('#time').val();
			if(t == 1){//月
				$('#month').show();
				$('#day').hide();
				$('#year').hide();
			}
			if(t == 2){//日
				$('#month').hide();
				$('#day').show();
				$('#year').hide();
			}
			if(t == 3){
				$('#month').hide();
				$('#day').hide();
				$('#year').show();
			}
		}*/
		/*function querySubmit(){
			var t = $('#time').val();
			if(t == 1){//月
				$('#selecttime').val($('#timemonth').val());
			}
			if(t == 2){
				$('#selecttime').val($('#timeday').val());
			}
			if(t == 3){
				$('#selecttime').val($('#timeyear').val());
			}
			
			return true;
			
		}*/
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
  </head>
  
  <body style="background-color: #f4f4f4;">
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
				  	 <li class="list-group-item " ><a href="usermanger" style="color: black;">系统管理</a></li>
				  	 <li class="list-group-item active" ><a href="queryorder" style="color: black;">数据报表</a></li>
				  </ul>
				</div>
 			</div>
 			<div class="col-md-10" style="margin-top: 30px;padding: 3px;">
 				<div class="panel panel-default">
				  <!-- Default panel contents -->
				  <div class="panel-heading" style="font-weight: bold;">数据统计</div>
				   <div class="panel-body" style="min-height: 500px;">
					  <form action="queryusersearch" method="post">
						   <span>查询条件</span>
						   <select id="showtype" onchange="changepage()">
						   	<option value="2">用户统计</option>
						   	<option value="1">订单统计</option>
						   </select>
						 
						   <input type="text"  style="width: 30%" name="query" placeholder="手机号或订单号">
						   <input type="submit" value="搜索" >
						  <a style="float: right;margin-right: 10px;" class="btn btn-info btn-xs" href="admin/datauserexcel.jsp"  target="_blank">导出excel</a>
					   </form>
					   <hr style="margin-top: 5px;">
				   		<table class="table table-hover table-bordered">
							<col width="5%"><col><col><col><col width="10%">
							<thead>
								<tr>
									<th>序号</th>
									<th>用户</th>
									<th>订单总数</th>
									<th>订单总额</th>
									<th>操作</th>
								
								</tr>
							</thead>
							<tbody>
							<c:if test="${empty requestScope.userOrders }">
								<tr><td colspan="4">暂无数据</td></tr>
							</c:if>
							
							<c:set var="orders" value="0"></c:set>
							<c:set var="moneys" value="0"></c:set>
							<c:forEach items="${requestScope.userOrders }" var="i" varStatus="n">
									<tr>
										<td>${n.count }</td>
										<td>${i.user}</td>
										<td>${i.totalOrderNum }</td>
										<td><fmt:formatNumber value="${i.totalMoney }"></fmt:formatNumber></td>
										<td ><a href="queryuserdetail?orderNums=${ i.orderNums}&tel=${i.user}" class="btn btn-primary btn-xs">查看详情</a></td>
										<c:set var="orders" value="${orders+i.totalOrderNum }"></c:set>
										<c:set var="moneys" value="${moneys+i.totalMoney }"></c:set>
									</tr>
							</c:forEach>
							<c:if test="${not empty requestScope.userOrders }">
								<tr style="background-color: #E0E0E0;">
									<td colspan="5"> 总计 : 总订单数（<span style="color: red;"><fmt:formatNumber value="${ orders}"></fmt:formatNumber></span>） 总金额（<span style="color: red;"><fmt:formatNumber value="${ moneys}"></fmt:formatNumber></span>）</td></tr>
							</c:if>
							
				 	 	</tbody>
				 	 	</table>
				   
				   </div>
				
				</div>
			
 			</div>
 		</div>
  	</div>
  	
  	 <!-- Modal -->
	<div class="modal fade" id="myModal" tabindex="-1" role="dialog"
		aria-labelledby="myModalLabel">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">用户订单详情</h4>
				</div>
				<div class="modal-body">
					

				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>

				</div>
			</div>
		</div>
	</div>
	<!-- Modal -->
  </body>
</html>
