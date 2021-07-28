<%@page import="imp.unit.WebParams"%>
<%@page import="imp.unit.CreateRandomUser"%>
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
	 <link rel="stylesheet" type="text/css" href="res/lunbo/css/slide.css"/>
	<script type="text/javascript" src="res/lunbo/js/jquery-1.11.3.min.js"></script>
	<script type="text/javascript" src="res/lunbo/js/slide.js"></script> 
	<script type="text/javascript">
		
		function toggle(){
			$("#menus").toggle(500);//显示隐藏切换,参数可以无,参数说明同上
								 
		}
		$(function(){
			$('.qq').mouseenter(function(){
				$('.erweima').show(200);
			});
			$('.qq').mouseleave(function(){
				$('.erweima').hide();
			});
			$('.print').click(function(){
				
				var start = $('#start').val();
				var end = $('#end').val();
				var result = time_range(start, end);
				//alert(start+","+end);
				if(result == 1){
					window.top.location.href="printset";
					//return true;
				}
				if(result == 2){
					return false;
				}
			});
			
			//lunbo
			$(".slideInner").slide({
				slideContainer: $('.slideInner a'),
				effect: 'easeOutCirc',
				autoRunTime: 5000,
				slideSpeed: 1000,
				nav: true,
				autoRun: true,
				prevBtn: $('a.prev'),
				nextBtn: $('a.next')
			});
			////
			$('.exitlog').click(function(){
				var result = confirm('确定退出登录吗?');
				if(result){
					var href = $(this).attr('_href');
					window.top.location.href = href;
				}
			});
		});
		
		var time_range = function (beginTime, endTime) {
	     var strb = beginTime.split (":");
	      if (strb.length != 2) {
	          return false;
	      }
	  
	      var stre = endTime.split (":");
	      if (stre.length != 2) {
	          return false;
	     }
	 
	     var b = new Date ();
	     var e = new Date ();
	     var n = new Date ();
	 
	     b.setHours (strb[0]);
	     b.setMinutes (strb[1]);
	     e.setHours (stre[0]);
	     e.setMinutes (stre[1]);
	 
	     if (n.getTime () - b.getTime () > 0 && n.getTime () - e.getTime () < 0) {
	         return 1;
	     } else {
	         alert ( "下单时间范围内为 "+beginTime+"~"+endTime+",现在不能下单");
	         return 2;
	     }
	 }
	 
	</script>
	
	
	<style>
   
    </style>
  </head>
 
  <body>
  <input type="hidden" value="<%=WebParams.startTime%>" id="start"/>
  <input type="hidden" value="<%=WebParams.endTime%>" id="end"/>
  	<!--  <section class="canvas-wrap">
		<div id="canvas" class="gradient">
		</div>	
		</section>-->
		<!--  -->
	<div class="mymenu" style="position: absolute;right: 30px;top: 20px;z-index: 100;">
		
			<!-- 未登录，生成随机账号 -->
			<c:if test="${empty sessionScope.users && empty sessionScope.nousers }">
				<%
					session.setAttribute("nousers",new CreateRandomUser().getNumbers() );
					System.out.print(session.getAttribute("nousers"));
				 %>
			</c:if>
				<div style="">
					
					<div id="menu"  style="cursor: pointer;">
					<c:if test="${not empty sessionScope.users }">
						<a _href="login/exituser.jsp" class="exitlog" title="${sessionScope.users },点击退出登录" style="color: white;"><img src="image/log.png" width="30" height="30"/></a >
						
					</c:if>
					<c:if test="${empty sessionScope.users }">
						<a href="login/login.jsp" class="" title="请登录账号" style="margin-bottom: 5px;"><img src="image/nolog.png" width="30" height="25"/></a>
					</c:if>
					<img alt="菜单" title="菜单" width="40px" height="40px" onclick="toggle()" src="image/nmenu.png" style="margin-left: 15px;"></div>
					<div id="menus" style="display: none;margin-left: 50px;">
						<c:if test="${empty sessionScope.users }">
							<div id="menu1" style="margin-top: 15px;cursor: pointer;" title="用户管理"><a href="login/login.jsp"><img alt="用户" width="30px" height="30px" src="image/nuser.png"></a></div>
						</c:if>
						<c:if test="${not empty sessionScope.users }">
							<div id="menu1" style="margin-top: 15px;cursor: pointer;" title="用户管理"><a href="usermenu?user=${sessionScope.users }"><img alt="用户" width="30px" height="30px" src="image/nuser.png"/></a></div>
						</c:if>
						<div id="menu2" style="margin-top: 15px;cursor: pointer;" title="订单管理"><a href="orderstate"><img alt="订单管理" width="30px" height="30px" src="image/norder.png"/></a></div>
						<div id="menu3" style="margin-top: 15px;cursor: pointer;" title="百度文库"><a href="http://wenku.baidu.com/" target="view_window"><img alt="文库" width="30px" height="30px" src="image/nwenku.png"/></a></div>
					</div>
				</div>
				
			</div>	
			<div style="position: absolute;left: 20px;top: 10px;z-index: 100;">
					<img alt="" width="150" height="80" src="image/leftlogo.png">
				</div>
	
	<div class="slides">
		<div class="slideInner">
			<a _href="#" style="background: url(res/lunbo/img/pp1.jpg) no-repeat 0px -20px;">
			 
				<img width="150" height="60" style="position: absolute;z-index: 1000;left: 50%;top: 60%;cursor: pointer;margin-left: -75px;" class="print" title="点击进入打印界面" src="image/pr.png"/>	
				<!--  <div class="moveElem img1" rel="0,easeInOutExpo"> <img src="res/lunbo/img/slide1p1.png" /> </div>
				<div class="moveElem img2" rel="150,easeInOutExpo"> <img src="res/lunbo/img/slide1p2.png" /> </div>
				 -->
			</a>
			<a _href="#" style="background: url(res/lunbo/img/pp2.jpg) no-repeat 0px -20px;">
				<!-- <div class="moveElem img1" rel="0,easeInOutExpo"> <img src="img/slide2p1.png" /> </div> -->
			</a>
			<a _href="#" class="slide3" style="background: url(res/lunbo/img/pp3.jpg) no-repeat 0px -20px;">
				<!--  <div class="moveElem img1" rel="0,easeInOutExpo"> <img src="img/slide3p1.png" /> </div>
				<div class="moveElem img2" rel="150,easeInOutExpo"> <img src="img/slide3p2.png" /> </div>
				<div class="moveElem img3" rel="300,easeInOutExpo"> <img src="img/slide3p3.png" /> </div>
				-->
			</a>
			<a _href="#" style="background: url(res/lunbo/img/pp4.jpg) no-repeat 0px -20px;">
				<!-- <div class="moveElem img1" rel="0,easeInOutExpo"> <img src="res/lunbo/img/slide1p1.png" /> </div>
				<div class="moveElem img2" rel="150,easeInOutExpo"> <img src="res/lunbo/img/slide1p2.png" /> </div>
				 -->
			</a>
			
		</div>
		<div class="nav">
			<a class="prev" href="javascript:;"></a>
			<a class="next" href="javascript:;"></a>
		</div>
	</div>
	
		
  </body>
   
</html>
