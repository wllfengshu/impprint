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
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<jsp:include page="res/bootstrap.jsp"></jsp:include>
	<link rel="stylesheet" href="res/jqueryupload/uploadify.css" type="text/css"></link>  
        
        <script type="text/javascript"  
            src="res/jqueryupload/jquery.uploadify.min.js"></script>  
	<script type="text/javascript">
		 $(function() {  
		 		$(function(){
					$('.qq').mouseenter(function(){
						$('.erweima').show(200);
					});
					$('.qq').mouseleave(function(){
						$('.erweima').hide();
					});
				});
                $("#file_upload").uploadify({  
                    'height'        : 30,   
                    'width'         : 100,    
                    'buttonText'    : '浏 览',  
                    'swf'           : '<%=basePath%>res/jqueryupload/uploadify.swf',  
                    'uploader'      : 'upload', 
                    checkExisting   : true, 
                    fileSizeLimit   : 0,    
                    'auto'          : false,  
                    'fileTypeExts'  : '*.doc;*.docx;*.pdf;*.ppt;*.pptx',  
                   'formData'      : {'user':''},  
                    'onUploadStart' : function(file) {  
                           
                        //校验     
                       /* var name=$('#userName').val();      
                         if(name.replace(/\s/g,'') == ''){     
                              alert("名称不能为空！");     
                              return false;     
                         }   
                           
                         //校验     
                        var qq=$('#qq').val();      
                         if(qq.replace(/\s/g,'') == ''){     
                              alert("QQ不能为空！");     
                              return false;     
                         }  */
                          var username=$('#userName').val();
                        $("#file_upload").uploadify("settings", "formData", {'user':username});  
                        //$("#file_upload").uploadify("settings", "qq", );  
                    }  
                });  
            });  
	</script>
	
  </head>
  
  <body style="background: #f4f4f4;">
    	<div class="contaniter-fluid" style="">
			<div class="row">
				<ul class="breadcrumb" style="background-color: #333333;padding-top: 15px;padding-bottom: 15px;">
					 <li style="margin-left: 20px;"><a href="index.jsp">首页</a> <span class="divider"></span></li>
					 <li ><a >文件上传</a></li> 
					 <li class="active">打印设置</li>
					 <li class="active">配送设置</li>
					 <li class="active">订单管理</li>
					 <c:if test="${not empty sessionScope.users }">
					 <div class="active" style="float: right;margin-right: 20px;"><a class="btn btn-info btn-xs" title="用户管理" href="usermenu?user=${sessionScope.users }" style="color: white;"> ${sessionScope.users }</a></div>
					</c:if>
					<c:if test="${empty sessionScope.users }">
					 <div class="active" style="float: right;margin-right: 20px;"><a class="btn btn-info btn-xs" title="用户登录" href="login/login.jsp" style="color: white;"> 未登录</a></div>
					</c:if>
				</ul>
			</div>
			<div class="row" style="padding-top: 5px;">
				<div class="col-md-5 col-xs-4"></div>
				<div class="col-md-2 col-xs-4" align="center">
					<img alt="" src="image/icon_fileupload.png" width="50px" height="50px"><br>
					<h5 style="font-weight: bold;">上传文件</h5>
				</div>
				<div class="col-md-5 col-xs=4"></div>
			</div>
			<hr style="margin-top: 5px;background-color: grey;height: 1px;">
			<div class="row" style="min-height: 300px;">
				<div class="col-md-1 col-xs-1"></div>
				<div class="col-md-10 col-xs-10" style="" align="center">
					<div>
						 <div class="form-group" style="min-height: 200px;">
							 <div>请选择文件：<img src="image/WORD.png" width="25px" height="25px" style="margin-right: 5px;"/><img src="image/pdf.png" width="25px" height="25px" style="margin-right: 5px;"/>
							 <img src="image/PPT.png" width="25px" height="25px" style="margin-right: 5px;"/></div>
				        		<c:if test="${empty sessionScope.users}"><input type="hidden" id="userName" name="userName" value="${sessionScope.nousers }"/></c:if>
				        		<c:if test="${not empty sessionScope.users}"><input type="hidden" id="userName" name="userName" value="${sessionScope.users }"/></c:if>
							  <div class="" style="margin-top: 10px;">
							  <input type="file" name="uploadify" id="file_upload" />  
						</div>
						</div>
						<div style="">
				      	<a href="javascript:$('#file_upload').uploadify('upload','*')" class="btn btn-default btn-sm">开始上传</a>&nbsp;     
				        <a href="javascript:$('#file_upload').uploadify('cancel', '*')" class="btn btn-danger btn-sm">取消所有上传</a>   
						</div>
					</div>
					
				</div>
				<div class="col-md-1 col-xs-1"></div>
				
			</div>
			<hr style="margin-top: 5px;background-color: grey;height: 1px;"">
			<div class="row" style="margin-top: 20px;"><div class="col-md-3 col-xs-3"></div>
				<div class="col-md-6 col-xs-6" align="middle"><a href="printset" title="下一步"><img alt="" src="image/right.png" width="50px" height="50px" ></a></div>
				<div class="col-md-3 col-xs-3"></div>
			</div>
			</div>
		<div class="erweima" style="position: fixed;right: 8%;bottom: 110px;display: none;"><img width="120" height="120" src="image/erweima.png"/></div>
		<div class="qq" style="position: fixed;right: 4%;bottom: 30px;cursor: pointer;"><img width="80" height="80" src="image/qq.png"/><br><p align="center" style="font-size: 12px;margin-top: -10px;">联系我</p></div>
		
  </body>
</html>
