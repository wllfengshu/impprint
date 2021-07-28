<%@page import="imp.unit.DealFileName"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="imp.bean.WaitPrintFile"%>
<%@page import="imp.bean.Pagination"%>
<%@ page language="java" import="java.util.*"  pageEncoding="UTF-8" %>
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
			
			
			$('.btn-finish').click(function(){
				
				var href =  $(this).attr('_href');
				var result = confirm('确认接单吗?');
				if(result){
					window.top.location.href=href;
					
				}
			});
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
               async: false,
                error: function(request) {
                    $("#addresult").parent().html("分配子账号失败");
                },
                success: function(data,textStatus) {
                  // alert(data);
                    $("#addresult").parent().html(data);
                }
            });		
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
  	<div class="container-fluid" >
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
				  
				    <li class="list-group-item active"><span class="badge">${requestScope.pagination.count}</span><a href="waitorder" style="color: black;">待确认订单</a></li>
				    <li class="list-group-item"><a href="sendfile" style="color: black;">待送货订单</a></li>
				    <li class="list-group-item"><a href="orderfinish" style="color: black;">已结束订单</a></li>
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
				 	 	<table class="table table-hover table-bordered" >
							 <col width="10%"><col width="20%"><col width="5%"><col width="20%">
							 <col width="15%"><col width="13%"><col width="12%"><col width="5%">  
							<thead>
								<tr>
									<th>订单编号</th>
									<th>文件名称</th>
									<th>页数</th>
									<th>打印要求</th>
									<th>用户信息</th>
									<th>下单/送货时间</th>
									
									<th>备注</th>
									<th>操作</th>
								</tr>
							</thead>
							<tbody>
							<c:if test="${empty requestScope.pageorders }">
								<tr><td></td><td>暂无新订单</td><td></td><td></td><td></td><td></td><td></td></tr>
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
									<td style="text-overflow: ellipsis;white-space: nowrap;">
									<%
										for(int j = 0;j < order.size();j++){
										%>
											<%
											if(order.get(j).getType().equals("doc")){%><img src="image/WORD.png" width="20px" height="20px"/><% }
											if(order.get(j).getType().equals("ppt")){%><img src="image/PPT.png" width="20px" height="20px"/><% }
											if(order.get(j).getType().equals("pdf")){%><img src="image/pdf.png" width="20px" height="20px"/><% }
										 	%>
										 
										 <a href="download?path=<%=order.get(j).getPath() %>&name=<%=order.get(j).getName() %>&ordernum=<%=orders.get(i) %>" style="color: black;" title="<%=order.get(j).getName() %>"><%=order.get(j).getName() %></a> 
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
											<%=order.get(j).getTotalPage() %>
								 			<c:if test="<%=j!=order.size()-1 %>"><hr></c:if>
										<%
										}
									 %>	
									</td>
									<td style="text-overflow: ellipsis;white-space: nowrap;">
									
										<%
											for(int j = 0;j < order.size();j++){
											%>
											<div style="margin-top: 4px;"></div>
												<c:if test="<%=order.get(j).getPage()==1 %>">双面 </c:if>
											 	<c:if test="<%=order.get(j).getPage()==2 %>">单面 </c:if>
											 	<c:if test="<%=order.get(j).getFix()==1 %>">装订 </c:if>
											 	<c:if test="<%=order.get(j).getFix()==2 %>">不装订 </c:if>
											 	<c:if test="<%=order.get(j).getColor()==1 %>">黑白 </c:if>
											 	<c:if test="<%=order.get(j).getColor()==2 %>">彩印 </c:if>
											 	<c:if test="<%=order.get(j).getAd()==0 %>">无广告 </c:if>
											 	<c:if test="<%=order.get(j).getAd()==1 %>">有广告 </c:if>
											 	<%=order.get(j).getNumber() %>份
											 	
											 	<c:if test="<%=j!=order.size()-1 %>"><hr></c:if>
											<%
											}
										 %>
										
									</td>
									<td style="text-overflow: ellipsis;white-space: nowrap;">
										<%=f.getTel() %><br><a title="<%=f.getAddress() %>" style="color: black;"><%=f.getAddress() %></a>
									</td>
									<td style="text-overflow: ellipsis;white-space: nowrap;">
										<%=f.getTime() %><br><%=f.getArrivetime() %>
									</td>
									
									<td style="text-overflow: ellipsis;white-space: nowrap;">
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
										
										<%=f.getOrdermoney() %>元
										<br>
										<a title="<%=f.getMoreword() %>" style="color: black;"><%=f.getMoreword() %></a>
										
									</td>
									<td >
										<a _href="changeorder?ordernum=<%=ordernum %>&finish=2" title="点击接单后提交到待送货列表" class="btn btn-info btn-xs btn-finish" style="margin-bottom: 3px;">接单</a><br>
									    <a _href="changeorder?ordernum=<%=ordernum %>&finish=4" title="拒绝该订单" id="<%=ordernum %>" value="<%=ordernum %>" onclick="clickDeny(this);" class="btn btn-danger btn-xs btn-delete" data-toggle="modal" data-target="#myModal">拒绝</a>
										
									 
									</td>
									</tr>
								<%
								}
							 %>
						
				 	 	</tbody>
				 	 	</table>
				 	 	<hr>
				 	 	 <!-- Modal 拒绝订单-->
								<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
								  <div class="modal-dialog" role="document">
								    <div class="modal-content">
								      <div class="modal-header">
								        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
								        <h4 class="modal-title" id="myModalLabel">填写拒绝理由</h4>
								      </div>
								      <div class="modal-body" >
								       
								        	
										   <div class="form-group">
										    <label class="control-label col-sm-2">拒绝原因</label>
										     <div class="col-sm-10">
										     <textarea rows="2" cols="40" class="form-control" id="reason" name="reason" onkeyup="checkLength1(this);"></textarea>
										 	 
										   </div>
										   </div>
										 <span class="wordage" style="float: right;margin-right: 10px;">剩余字数：<span id="sy1" style="color:Red; " >40</span></span>
										<button  id="deny" class="btn btn-primary col-sm-offset-2" style="margin-top: 10px;"><span class="glyphicon glyphicon-ok"></span> 确定</button>
												 
									
										
										
								      </div>
								      <div class="modal-footer">
								        <button type="button" class="btn btn-default btn-close" data-dismiss="modal">取消</button>
								        
								      </div>
								    </div>
								  </div>
								</div>
								<script type="text/javascript">
									var ordernum = "";
									$('#deny').click(function(){
										$.ajax({
							                cache: true,
							                type: "POST",
							                url:"reasons",
							                data:{on:ordernum,
							                	  reason:$('#reason').val()},// 你的formid
							                async: false,
							                success: function(data) {
							                    window.top.location.href="waitorder";
							                }
														               
							            });		
										//$('.btn-close').click();
									});
									function clickDeny(which){
										ordernum = which.id;
										//alert(ordernum);
									
									}
									function checkLength1(which) {
															var maxChars = 40; //
															if(which.value.length > maxChars){
																alert("输入入的字数超多限制!");
																// 超过限制的字数了就将 文本框中的内容按规定的字数 截取
																which.value = which.value.substring(0,maxChars);
																return false;
															}else{
																var curr = maxChars - which.value.length; //100 减去 当前输入的
																document.getElementById("sy1").innerHTML = curr.toString();
																return true;
															}
														}
								</script>
								<!-- Modal -->
				 	 	
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
						    	 <a href="waitorder?page=${requestScope.pagination.page-1 }" aria-label="Previous">
							        <span aria-hidden="true">&laquo;</span>
							      </a>
						    </c:if>
						    <c:if test="${requestScope.pagination.page == 1 }">
						    	 <a href="waitorder?page=1" aria-label="Previous">
							        <span aria-hidden="true">&laquo;</span>
							      </a>
						    </c:if> 
						    </li>
						    <%
						   Pagination p = (Pagination)request.getAttribute("pagination");
						   
						   		for(int i = 1;i <= p.getTotal();i++){
						   		%>
						   		 <li <% if(p.getPage() == i){%>class="active"<% } %>><a href="waitorder?page=<%=i%>"><%=i %></a></li>
						   		<% 
						   		}
						    %>
						    
						    
						    <li>
						    	<c:if test="${requestScope.pagination.page < requestScope.pagination.total}">
						    	 <a href="waitorder?page=${requestScope.pagination.page-1 }" aria-label="Next">
								        <span aria-hidden="true">&raquo;</span>
								      </a>
							    </c:if>
							    <c:if test="${requestScope.pagination.page >= requestScope.pagination.total}">
							    	 <a href="waitorder?page=${requestScope.pagination.total }" aria-label="Next">
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
