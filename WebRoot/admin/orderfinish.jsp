<%@page import="imp.unit.DealFileName"%>
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
				var result = confirm('确定删除吗?');
				if(result){
					window.top.location.href=href;
					
				}
			});
			$('.btn-finish').click(function(){
				
				var href =  $(this).attr('_href');
				var result = confirm('确定已打印吗?');
				if(result){
					window.top.location.href=href;
					
				}
			});
			
		});
		
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
				    <li class="list-group-item active"><a href="orderfinish" style="color: black;">已结束订单</a></li>
				  	 <li class="list-group-item"><a href="exfiles" style="color: black;">备用上传</a></li>
				  	 <li class="list-group-item" ><a href="usermanger" style="color: black;">系统管理</a></li>
				 	 <li class="list-group-item" ><a href="queryorder" style="color: black;">数据报表</a></li>
				  </ul>
				</div>
 			</div>
 			<div class="col-md-10" style="margin-top: 30px;padding: 3px;">
 			
			<!--  -->
			<div class="panel panel-default">
				  <!-- Default panel contents -->
				  <div class="panel-heading" style="font-weight: bold;">订单列表 (<label style="color: red;">${requestScope.pagination.count}</label>)</div>
				 	 <div class="panel-body" style="min-height: 500px;">
				 	 	<table class="table table-hover table-bordered">
							 <col width="10%"><col width="20%"><col width="20%"><col width="15%"><col width="12%"><col width="7%"><col width="10%">
							
							<thead>
								<tr>
									<th>订单编号</th>
									<th>文件名称</th>
									<th>打印要求</th>
									<th>用户信息</th>
									<th>送达时间</th>
									<th>金额</th>
									<th>备注</th>
								
								</tr>
							</thead>
							<tbody>
							<c:if test="${empty requestScope.pageorders }">
								<tr><td></td><td>暂无结束订单</td><td></td><td></td><td></td><td></td><td></td></tr>
							</c:if>
							<%
								List<String> orders = (List<String>)request.getAttribute("pageorders");
								for(int i = 0;i < orders.size();i++)
								{
								String ordernum = orders.get(i);
								List<WaitPrintFile> order = (List<WaitPrintFile>)request.getAttribute(ordernum);
								WaitPrintFile f = null;
								if(order != null){
									f = order.get(0);
								}
								
								%>
									<tr>
									<td >
										<a title="<%=orders.get(i) %>" style="color: black;"><%=orders.get(i) %></a><br><a href="pldownload?ordernum=<%=orders.get(i) %>">全部下载</a>
									</td>
									<td>
									<%
										for(int j = 0;j < order.size();j++){
										%>
											<%
											if(order.get(j).getType().equals("doc")){%><img src="image/WORD.png" width="20px" height="20px"/><% }
											if(order.get(j).getType().equals("ppt")){%><img src="image/PPT.png" width="20px" height="20px"/><% }
											if(order.get(j).getType().equals("pdf")){%><img src="image/pdf.png" width="20px" height="20px"/><% }
										 	%>
										 
										 <a href="download?path=<%=order.get(j).getPath() %>&name=<%=order.get(j).getName() %>&ordernum=<%=orders.get(i) %>" style="color: black;" title="<%=order.get(j).getName() %>"><%=DealFileName.getFileName(order.get(j).getName()) %></a> 
								 			<c:if test="<%=j!=order.size()-1 %>"><hr></c:if>
										<%
										}
									 %>
									</td>
									
									<td>
										<%
											for(int j = 0;j < order.size();j++){
											%>
												<div style="margin-top: 4px;"></div>
												<div style="margin-top: 4px;"></div>
												<c:if test="<%=order.get(j).getPage()==1 %>">双面 </c:if>
											 	<c:if test="<%=order.get(j).getPage()==2 %>">单面 </c:if>
											 	<c:if test="<%=order.get(j).getFix()==1 %>">装订 </c:if>
											 	<c:if test="<%=order.get(j).getFix()==2 %>">不装订 </c:if>
											 	<c:if test="<%=order.get(j).getColor()==1 %>">黑白 </c:if>
											 	<c:if test="<%=order.get(j).getColor()==2 %>">彩印 </c:if>
											 	<%=order.get(j).getNumber() %>份
											 	<c:if test="<%=j!=order.size()-1 %>"><hr></c:if>
											<%
											}
										 %>
										
									</td>
									<td>
										<%=f.getTel() %><br>
										<a title="<%=f.getMoreword() %>" style="color: black;"><%=f.getMoreword() %></a>
										
									</td>
									<td >
										<%
											if(f.getSudu() == 1){
											%>普速达<%
											}
										 %>
										 <%
											if(f.getSudu() == 2){
											%>及时达<%
											}
										 %>
										 <%
											if(f.getSudu() == 3){
											%>瞬时达<%
											}
										 %>
										<br>
										<%=f.getArrivetime() %>
									</td>
									<td>
										<%=f.getOrdermoney() %>
									</td>
									<td>
										<%
											if(f.getFinish() == 4){
											%>
												被拒
											<% 
											}
										 %>
									</td>
									
									</tr>
								<%
								}
							 %>
						
				 	 	</tbody>
				 	 	</table>
				 	 	<hr>
				 	 	<!--  <ul class="list-group">
				 	 		<c:forEach items="${requestScope.waitprintfiles }" var="i">
				 	 			<li class="list-group-item">${i.name }</li>
				 	 		</c:forEach>
				 	 	</ul>-->
				 	 	<c:if test="${not empty requestScope.pageorders }">
				 	 	<nav>
						  <ul class="pagination">
						    <li>
						    <c:if test="${requestScope.pagination.page > 1 }">
						    	 <a href="orderfinish?page=${requestScope.pagination.page-1 }" aria-label="Previous">
							        <span aria-hidden="true">&laquo;</span>
							      </a>
						    </c:if>
						    <c:if test="${requestScope.pagination.page == 1 }">
						    	 <a href="orderfinish?page=1" aria-label="Previous">
							        <span aria-hidden="true">&laquo;</span>
							      </a>
						    </c:if> 
						    </li>
						    <%
						   Pagination p = (Pagination)request.getAttribute("pagination");
						   
						   		for(int i = 1;i <= p.getTotal();i++){
						   		%>
						   		 <li <% if(p.getPage() == i){%>class="active"<% } %>><a href="orderfinish?page=<%=i%>"><%=i %></a></li>
						   		<% 
						   		}
						    %>
						    
						    
						    <li>
						    	<c:if test="${requestScope.pagination.page < requestScope.pagination.total}">
						    	 <a href="orderfinish?page=${requestScope.pagination.page-1 }" aria-label="Next">
								        <span aria-hidden="true">&raquo;</span>
								      </a>
							    </c:if>
							    <c:if test="${requestScope.pagination.page >= requestScope.pagination.total}">
							    	 <a href="orderfinish?page=${requestScope.pagination.total }" aria-label="Next">
								        <span aria-hidden="true">&raquo;</span>
								      </a>
							    </c:if> 
						     
						    </li>
						  </ul>
						</nav>
						</c:if>
				 	 </div>
				 
				</div>
 			</div>
 		</div>
  	</div>
  </body>
</html>
