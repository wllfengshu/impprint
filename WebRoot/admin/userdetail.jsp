<%@page import="imp.bean.FileMsg"%>
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
						   	<option value="2">用户订单详情</option>
						   	<option value="1">订单金额统计</option>
						   	
						   </select>
						 
						   <input type="text"  style="width: 30%" name="query" placeholder="手机号或订单号">
						   <input type="submit" value="搜索" >
						   <a style="float: right;margin-right: 10px;" href="queryuserorder"><span class="glyphicon glyphicon-share-alt" aria-hidden="true"></span>返回</a>
					   </form>
					   
					   <hr style="margin-top: 5px;">
					   <c:if test="${empty requestScope.order }">
								<div style="width: 100%;height: 200px;">暂无数据</div>
						</c:if>
						<%
							List<String> order = (List<String>)request.getAttribute("order");
							for(int i = 0;i < order.size();i++){
								List<FileMsg> files = (List<FileMsg>)request.getAttribute(order.get(i));
							%>
								<p style="background-color: #E0E0E0;">用户:${requestScope.tel } 订单编号:<%=order.get(i) %></p>
								<table class="table table-hover table-bordered">
									<col width="5%">
									<thead><tr>
										<th>序号</th>
										<th>文件</th>
										<th>金额</th>
										<th>打印要求</th>
										<th>商家折扣</th>
										<th>广告有无</th>
									</tr></thead>
									<tbody>
									<%
										if(files.size() == 0){
											%>
											<tr><td colspan="6">无相关记录</td></tr>
											<%
										}
										for(int j = 0;j < files.size();j++){
											FileMsg file = files.get(j);
											
											%>
												<tr>
													<td><%= j+1 %></td>
													<td> <a href="download?path=<%=file.getPath() %>&name=<%=file.getName() %>&ordernum=<%=order.get(i) %>" style="color: black;" title="<%=file.getName() %>"><%=file.getName() %></a> </td>
													<td><%= file.getMoney() %></td>
													<td>
														<c:if test="<%=file.getPage()==1 %>">双面 </c:if>
													 	<c:if test="<%=file.getPage()==2 %>">单面 </c:if>
													 	<c:if test="<%=file.getFix()==1 %>">装订 </c:if>
													 	<c:if test="<%=file.getFix()==2 %>">不装订 </c:if>
													 	<c:if test="<%=file.getColor()==1 %>">黑白 </c:if>
													 	<c:if test="<%=file.getColor()==2 %>">彩印 </c:if>
													 	<c:if test="<%=file.getAd()==0 %>">无广告 </c:if>
													 	<c:if test="<%=file.getAd()==1 %>">有广告 </c:if>
													 	<%=file.getNumber() %>份
													</td>
													<td>
														<%
															if((int)file.getDiscount() != 1){
																%><%=file.getDiscount()%><% 
															}else{
																%>无<% 
															}
														%>
													</td>
													<td><%if(file.getAd() ==1){%>Y<%} else{%>N<%} %></td>
												</tr>
												
											<% 
											if(j == files.size() - 1){
												%><tr><td colspan="6">总计：<%= file.getOrdermoney()%> 元</td></tr><% 
											}
										}
									%>
									
									</tbody>
								</table>	
							<% 
							}
						%>
						
				   
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
