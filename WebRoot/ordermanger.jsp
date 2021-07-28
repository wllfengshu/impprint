<%@page import="imp.bean.WaitPrintFile"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %> 
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
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
	<script type="text/javascript" src="res/loginjs.js"/>
	
	<link rel="stylesheet" href="res/jqueryupload/uploadify.css" type="text/css"></link>  
        
        <script type="text/javascript"  
            src="res/jqueryupload/jquery.uploadify.min.js"></script>  
	<script type="text/javascript">
		$(function(){
			$('.qq').mouseenter(function(){
						$('.erweima').show(200);
					});
			$('.qq').mouseleave(function(){
						$('.erweima').hide();
			});
					
			$('.deleteuploadfile').click(function(){
				//var href =  $(this).attr('_href');
				//var deleteid = $(this).attr('id');
				var result = confirm('确定删除吗?');
				if(result){
					//window.top.location.href=href;
					$.ajax({
		                cache: true,
		                type: "POST",
		                url:"deleteorder",
		                data:{ordernum:$(this).attr('id')},// 你的formid
		                async: false,
		                error: function(request) {
		                    alert("删除失败");
		                },
		                success: function(data) {
						   window.top.location.href="orderstate";
		                  alert("删除成功");
		                }
		            });		
				}
			});	
			$('.look').mouseover(function(){
			  $('.ewm').show();
			});
			$('.look').mouseout(function(){
			  $('.ewm').hide();
			});
		});
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
  	<%@ include file="_loginmodal.jsp" %>
    	<div class="contaniter-fluid" >
			<div class="row">
				<ul class="breadcrumb" style="background-color: #333333;padding-top: 15px;padding-bottom: 15px;">
					 <li style="margin-left: 20px;"><a href="index.jsp">首页</a> <span class="divider"></span></li>
					
					<li class="active">文件上传</li>
					 <li class="active">配送设置</li>
					 <li ><a href="orderstate">订单管理</a></li>
					<c:if test="${not empty sessionScope.users }">
							 <div class="active" style="float: right;margin-right: 20px;"><a class="" title="进入用户管理界面" href="usermenu?user=${sessionScope.users }" style="color: white;"> <img alt="用户" width="30px" height="30px" src="image/log.png"></a></div>
							</c:if>
							<c:if test="${empty sessionScope.users }">
							 <div class="active" style="float: right;margin-right: 20px;"><a class="" title="未登录，点击登录" data-toggle="modal" data-target="#logModal" style="color: white;"><img alt="用户" width="30px" height="30px" src="image/nolog.png"></a></div>
							</c:if>
				</ul>
			</div>
			<div class="row" style="padding-top: 5px;">
				<div class="col-md-1"></div>
				<div class="col-md-4" style="padding-top: 60px;">
				<a style="cursor: pointer;" class="look">查看付款二维码</a>
				</div>
				<div class="ewm" style="position: absolute;padding-left: 120px;padding-top: 100px;z-index: 1;display: none;">
					<div style="background-color: gray;padding: 10px;"><img width="120px" height="120px" src="image/qqpay.png"/>
											<img width="120px" height="120px" src="image/zfbpay.jpg" style="margin-left: 70px;"/>
											<!-- <br><label style="margin-left: 10px;">qq：949071759</label><label style="margin-left: 70px;">支付宝：18140548446</label> -->
								</div>					
				</div>				
				<div class="col-md-2" align="center">
					<img alt="" src="image/orderma.png" width="50px" height="50px"><br>
					<h5 style="font-weight: bold;">订单管理</h5>
				</div>
				<div class="col-md-5"></div>
			</div>
			<hr style="margin-top: 5px;background-color: grey;height: 1px;">
			<div class="row" style="min-height: 300px;">
				<div class="col-md-1"></div>
				<div class="col-md-10" style="" align="center">
					<table class="table table-hover table-bordered" style="background-color: white;">
							 <col width="10%"><col width="15%"><col width="5%"><col width="20%"><col width="10%">
							 <col width="15%"><col width="8%"><col width="10%"><col width="7%">
							<thead>
								<tr>
									<th>订单编号</th>
									<th>文件名称</th>
									<th>页数</th>
									<th>打印要求</th>
									<th>送货信息</th>
									
									<th>下单/送达时间</th>
									<th>价格</th>
									<th>备注</th>
									<th>状态</th>
								</tr>
							</thead>
							<tbody>
							<c:if test="${empty requestScope.ordernumbers }">
								<tr><td></td><td>暂无订单</td><td></td><td></td><td></td><td></td><td></td></tr>
							</c:if>
							<%
								List<String> orders = (List<String>)request.getAttribute("ordernumbers");
								for(int i = 0;i < orders.size();i++)
								{
								String ordernum = orders.get(i);
								List<WaitPrintFile> order = (List<WaitPrintFile>)request.getAttribute(ordernum);
								WaitPrintFile f = order.get(0);
								%>
									<tr>
									<td >
										<a title="<%=orders.get(i) %>" style="color: black;"><%=orders.get(i) %></a>
										
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
											 <a style="color: black;" title="<%=order.get(j).getName() %>"><%=order.get(j).getName() %></a> 
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
									<td>
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
									<td valign="middle">
										<%=f.getTel() %><br><a title="<%=f.getAddress() %>" style="color: black;"><%=f.getAddress() %></a>
									</td>
									<td valign="middle">
										<%=f.getTime() %><br><%=f.getArrivetime() %>
									</td>
									<td valign="middle">
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
										<%=f.getOrdermoney() %>
									</td>
									<td valign="middle">
										<a title="<%=f.getMoreword() %>" style="color: black;"><%=f.getMoreword() %></a>
									</td>
									<td valign="middle">
										<c:if test="<%=f.getFinish() == 0  %>"><a class="btn btn-primary btn-xs">暂未下单</a><br>
									 	<a _href="deleteuploadfile?ordernum=<%=ordernum %>" title="点击取消订单" id="<%=ordernum %>"  value=""  class="btn btn-danger btn-xs deleteuploadfile" style="margin-top: 5px;" > 删除文件 </a></c:if>
									 	<c:if test="<%=f.getFinish() == 1  %>"><a class="btn btn-info btn-xs">等待接单</a><br>
									 	 <a _href="deleteuploadfile?ordernum=<%=ordernum %>" title="点击取消订单"  id="<%=ordernum %>"  class="btn btn-danger btn-xs deleteuploadfile" style="margin-top: 5px;" >取消订单</a></c:if>
									 	<c:if test="<%=f.getFinish() == 2  %>"><a class="btn btn-success btn-xs">等待送货</a></c:if>
									 	<c:if test="<%=f.getFinish() == 3  %>"><a class="btn btn-default btn-xs">交易完成</a></c:if>
									 	<c:if test="<%=f.getFinish() == 4  %>"><a class="btn btn-danger btn-xs">订单被拒</a><br><a href="editorder?ordernum=<%=orders.get(i) %>" class="btn btn-primary btn-xs" title="修改订单重新提交" style="margin-top: 5px;">修改订单</a></c:if>
									 
									</td>
									</tr>
								<%
								}
							 %>
							
							
							
				 	 	<!-- <c:forEach items="${requestScope.orders }" var="i">
				 	 		<tr>
				 	 			<td><c:if test="${i.type =='doc' }"><img src="image/WORD.png" width="30px" height="30px"/></c:if>
											<c:if test="${i.type =='ppt' }"><img src="image/PPT.png" width="30px" height="30px"/></c:if>
											<c:if test="${i.type =='pdf' }"><img src="image/pdf.png" width="30px" height="30px"/></c:if>	
								 			${i.name }
								 </td>
								 <td>${i.tel }<br>${i.address }</td>
							
								 <td>
								 	<c:if test="${i.page == 1 }">双面打印 </c:if>
								 	<c:if test="${i.page == 2 }">单面打印 </c:if>
								 	<c:if test="${i.fix == 1 }">装订 </c:if>
								 	<c:if test="${i.fix == 2 }">不装订 </c:if>
								 	<c:if test="${i.color == 1 }">黑白 </c:if>
								 	<c:if test="${i.color == 2 }">彩印 </c:if>
								 	${i.number }份
								 </td>
								 <td>${i.time }<br>${i.arrivetime }</td>
								 <td>${i.money }</td>
								 <td><c:if test="${empty i.moreword }">无</c:if><c:if test="${not empty i.moreword }">${i.moreword }</c:if></td>
								 <td>
								 <c:if test="${i.finish == 0 }"><a class="btn btn-primary btn-xs">暂未提交</a>
								 <a _href="deleteuploadfile?id=${i.fileid }"  value="${i.fileid }" id="${i.fileid }" class="btn btn-danger btn-xs deleteuploadfile" style="margin-top: 5px;" > 取消订单 </a></c:if>
								 	<c:if test="${i.finish == 1 }"><a class="btn btn-info btn-xs">等待接单</a>
								 	 <a _href="deleteuploadfile?id=${i.fileid }" value="${i.fileid }" id="${i.fileid }" class="btn btn-danger btn-xs deleteuploadfile" style="margin-top: 5px;" >取消订单</a></c:if>
								 	<c:if test="${i.finish == 2 }"><a class="btn btn-success btn-xs">等待送货</a></c:if>
								 	<c:if test="${i.finish == 3 }"><a class="btn btn-default btn-xs">交易完成</a></c:if>
								 	<c:if test="${i.finish == 4 }"><a class="btn btn-danger btn-xs">订单被拒</a></c:if>
								 </td>
				 	 		</tr>
				 	 		
				 	 	</c:forEach> -->
				 	 	</tbody>
				 	 	</table>
					
				</div>
				<div class="col-md-1"></div>
				
			</div>
			<hr style="margin-top: 5px;background-color: grey;height: 1px;">
			
			</div>
	<div class="qq" style="position: fixed;right: 4%;bottom: 30px;cursor: pointer;"><br><p align="center" style="font-size: 12px;margin-top: -10px;"><a href="http://wpa.qq.com/msgrd?v=3&uin=949071759&site=qq&menu=yes" target="_blank" title="发起qq聊天"><img width="50" height="50" src="image/qq.png"/><br>联系我</a></p></div>
  	
  </body>
</html>
