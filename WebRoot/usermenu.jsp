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
	<meta http-equiv="keywords" content="印象打印,打印,在线打印,印象,impprint">
	<meta http-equiv="description" content="印象打印致力于帮助学生用户更方便快捷的打印资料,无需注册，简化操作，配送上门，让您享受不一样的服务！！">
	<jsp:include page="res/bootstrap.jsp"></jsp:include>
	<script type="text/javascript">
		$(function(){
		
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
            	// $("#result").html(htmlobj.responseText);
			});
			$("#add").click(function(){
				if($("#address").val().length==0){
					$("#addresult").html("地址为空，请填写完整");
					return false;
				}
			});
			$(".btn-delete-address").click(function(){
				//var id =  $(this).attr('id');
				var result = confirm('确定删除吗？');
				if(result){
					//window.top.location.href=href;
					$.ajax({
					   type:"post",//请求方式
					   url:"deleteaddress",//发送请求地址
					   data:{//发送给数据库的数据
					   id:$(this).attr('id'),
					   
					   },
					   
					   //请求成功后的回调函数有两个参数
					   success:function(data,textStatus){
					   window.top.location.href="usermenu";
					   }
					   });
					   
				}
				});
				$(".btn-address-edit").click(function(){
					var id = $(this).attr('id');
					var address = $("#ad"+id).val();
					$("#address1").val(address);
					$("#editid").val(id);
				});
		});
	</script>
  </head>
  
  <body style="background-color: #f4f4f4;">
    <div class="container-fluid" >
    	<div class="row" style="background-color: #333333;height: 50px;">
 		<div style="float: right;margin-right: 20px;margin-top: 10px;"><a class="btn btn-default btn-sm" href="<%=basePath %>index.jsp"> 回到首页</a></div>
 			<h4 align="center" style="color: #e5e5e5;">印象打印</h4>
 		</div>
    	<div class="row" style="margin-top: 30px;">
    		
    		<div class="col-sm-12 col-xs-12">
    			<ul class="list-group" >
    				<li class="list-group-item" style="background: #EBEBEB;"><label style="font-weight: bold;">我的信息</label><br>
    					<div class="" style="background: white;">
						 	 <div><p style="padding-top: 20px;margin-left: 20px;">账号：${sessionScope.users} <a class="btn btn-default btn-xs" id="edp" style="float: right;margin-right: 20px;">修改密码</a></p>
						 	 	<div class="editpsw" style="width:60%;margin-left: 20%;display: none;">
						 	 	<hr>
						 	 		<form class="form-horizontal" id="pswform" action="editpsw" method="post">
										        	<input type="hidden" class="form-control"  name="user" value="${sessionScope.users}">
											     	  <div class="form-group">
													    <label for="inputEmail3" class="col-sm-2 control-label">原始密码</label>
													    <div class="col-sm-10">
													      <input type="text" class="form-control" id="opsw" name="oldpassword" value="">
													      <label id="opswtip" style="color: red;"></label>
													    </div>
													  </div>
											     	 <div class="form-group">
													    <label for="inputEmail3" class="col-sm-2 control-label">新密码</label>
													    <div class="col-sm-10">
													      <input type="password" class="form-control" id="npsw" name="password" value="">
													    	 <label id="npswtip" style="color: red;"></label>
													    </div>
													  </div>
													  <div class="form-group">
													    <label for="inputPassword3" class="col-sm-2 control-label">确认密码</label>
													    <div class="col-sm-10">
													     	<input type="password" class="form-control" id="rnpsw" name="rpassword" value="">
													    <label id="rnpswtip" style="color: red;"></label>
													    </div>
													  </div>
											   		
											   		 <div class="form-group">
													    <div class="col-sm-offset-2 col-sm-10">
											
													      <button type="submit" class="btn btn-info psw-checkpsw"><span class="glyphicon glyphicon-ok"></span> 提交</button>
													       <button type="reset" class="btn btn-danger"><span class="glyphicon glyphicon-share-alt"></span> 重置</button>
													    </div>
													  </div>
													   <div id="result" style="color: red;"></div>
													   
										        </form>
						 	 	</div>
						 	 </div>
						 	 <hr>
						 	 <div style=""><p style="margin-left: 20px;">收货地址 <a class="btn btn-default btn-xs" style="float: right;margin-right: 20px;"  data-toggle="modal" data-target="#myModal">添加地址</a></p>
						 	 	<ul class="list-group" >
						 	 		<c:if test="${empty requestScope.addresses }">
						 	 			<li class="list-group-item" style="padding-left: 30px;">暂无收货地址</li>
						 	 		</c:if>
						 	 		<c:forEach items="${requestScope.addresses }" var="i" varStatus="n">
						 	 		<input type="hidden" id="ad${i.id }" value="${i.address }"/>
										<li class="list-group-item" style="padding-left: 30px;">地址${n.count } : ${ i.address}<a class="btn btn-info btn-xs btn-address-edit" id="${i.id }" style="float: right;margin-right: 5px;" data-toggle="modal" data-target="#myModal2">修改</a>
							 	 			<a class="btn btn-danger btn-xs btn-delete-address" id="${i.id }" style="float: right;margin-right: 10px;" >删除</a>
							 	 		</li>		 	 		
						 	 		</c:forEach>
						 	 		
						 	 	</ul>
						 	 </div>
						 	 <!-- Modal 添加地址-->
								<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
								  <div class="modal-dialog" role="document">
								    <div class="modal-content">
								      <div class="modal-header">
								        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
								        <h4 class="modal-title" id="myModalLabel">添加收货地址</h4>
								      </div>
								      <div class="modal-body" >
								        <form  method="post" action="address" class="form-horizontal">
								        	<input type="hidden" class="form-control"  name="user" value="${sessionScope.users}">
								        	<input type="hidden" class="form-control"  name="fp" value="um" value="${sessionScope.users}">
										   <div class="form-group">
										    <label class="control-label col-sm-2">地址</label>
										     <div class="col-sm-10">
										    <input type="type" class="form-control" id="address" name="address">
										   </div>
										   </div>
										 
										  <button type="submit" id="add" class="btn btn-primary col-sm-offset-2" onclick=""><span class="glyphicon glyphicon-ok"></span> 确定</button>
											<label id="addresult" style="color: red;"></label>
										</form>
										
										
								      </div>
								      <div class="modal-footer">
								        <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
								        
								      </div>
								    </div>
								  </div>
								</div>
								<!-- Modal -->
								
								<!-- Modal 修改地址-->
								<div class="modal fade" id="myModal2" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
								  <div class="modal-dialog" role="document">
								    <div class="modal-content">
								      <div class="modal-header">
								        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
								        <h4 class="modal-title" id="myModalLabel">修改收货地址</h4>
								      </div>
								      <div class="modal-body" >
								        <form  method="post" action="editaddress" class="form-horizontal">
								        <input type="hidden" class="form-control" id="editid" name="id">
								        	
										   <div class="form-group">
										    <label class="control-label col-sm-2">地址</label>
										     <div class="col-sm-10">
										    <input type="type" class="form-control" id="address1" name="address">
										   </div>
										   </div>
										 
										  <button type="submit" id="add" class="btn btn-primary col-sm-offset-2" onclick=""><span class="glyphicon glyphicon-ok"></span> 确定</button>
											<label id="addresult" style="color: red;"></label>
										</form>
										
										
								      </div>
								      <div class="modal-footer">
								        <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
								        
								      </div>
								    </div>
								  </div>
								</div>
								<!-- Modal -->
						</div>
    				</li>
    				<li class="list-group-item" style="background: #EBEBEB;font-weight: bold;">历史订单<br>
    					<div class="" style="background: white;min-height: 200px;">
    						<c:if test="${empty requestScope.orders }">
    							<p align="center" style="color: red;margin-top: 50px;margin-left: 30px;">无订单</p>
    						</c:if>
    						<c:if test="${not empty requestScope.orders }">
    						<ul class="list-group" >
    							<c:forEach items="${requestScope.orders }" var="i">
    								<li class="list-group-item" style="padding-left: 30px;">
    									<c:if test="${i.finish == 0 }"><a class="btn btn-primary btn-xs">未提交</a></c:if>
    								<c:if test="${i.finish == 1 }"><a class="btn btn-info btn-xs">待接单</a></c:if>
    								<c:if test="${i.finish == 2 }"><a class="btn btn-success btn-xs">待送货</a></c:if>
    								<c:if test="${i.finish == 3 }"><a class="btn btn-default btn-xs">已完成</a></c:if>
    								<c:if test="${i.finish == 4 }"><a class="btn btn-danger btn-xs">被拒绝</a></c:if>
    									<c:if test="${i.type =='doc' }"><img src="image/WORD.png" width="30px" height="30px"/></c:if>
											<c:if test="${i.type =='ppt' }"><img src="image/PPT.png" width="30px" height="30px"/></c:if>
											<c:if test="${i.type =='pdf' }"><img src="image/pdf.png" width="30px" height="30px"/></c:if>	
    										<label style="font-weight: normal;margin-right: 20px;">${i.name }</label>
    									
    								
    										<label style="font-weight: normal;float: right;margin-right: 10px;" >${i.date }</label>
    										</li>
    							</c:forEach>
    						</ul>
    						</c:if>
    					</div>
    				</li>
    			</ul>
    		</div>
    		
    	</div>
    	
    </div>
  </body>
</html>
