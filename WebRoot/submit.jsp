<%@page import="imp.unit.WebParams"%>
<%@page import="imp.servlet.SendMsgServlet"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";


	String m="";
	if(request.getAttribute("money") != null){
		m = request.getAttribute("money").toString();
	}
	int waittime=0;
	if(request.getAttribute("waittime") != null){
		String time = request.getAttribute("waittime").toString();
		waittime = Integer.parseInt(time);
	}
	
	double discount = WebParams.discount;
	
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
	
	<script type="text/javascript">
	var random;
	var discount = <%= discount%>;

	var dd;//订单排到那一天 
		$(function(){
			browserRedirect();//手机访问显示打开支付应用按钮
		var mo = <%= m%>;
		
		mo *=discount; 
		
		mo = parseFloat(mo).toFixed(1);
		$('.mon').html(mo);
		limitTime();
			$('.qq').mouseenter(function(){
						$('.erweima').show(200);
					});
					$('.qq').mouseleave(function(){
						$('.erweima').hide();
					});
				
			$('.btn-ok').click(function(){
				var state = $('#state').val();
				if(state == 1){
					var tel = $('#telphone').val();
					var vcode = $('#no-vcode').val();
					var address = $('#no-address').val();
					if(tel.length!= 11){
						alert("电话号码填写错误");
						return false;
					}
					if(vcode.length != 4){
						alert("验证码错误");
						return false;
					}else{
						//var code = <%=SendMsgServlet.random%>;
						
						//alert(random);
						if(vcode != random){
						alert("验证码错误");
							return false;
						}
					}
					if(address.length == 0){
						alert("收货地址为空");
						return false;
					}
					
				}else if(state == 2){
					if($('#addre').val() == 1){
						if($('#address').val().length == 0){
						alert("收货地址为空");
						return false;
					}
					}
					
				}
				
				if($('.sudu').val() == 1){//未选择时间段,或无时间段可选
					if($('.shour').val() == 1 || $('.sday').val() == 4){
					alert("请选择可用的时间段");
					return false;
					}
					
				}
				
				var result = confirm('确定下单吗?接单状态将会短息通知您');
				if(result){
				
					return true;
				}else{
					return false;
				}
				
			});
		
			$('.saveaddress').click(function(){
				var addresses = $('.usernewaddress').val();
				
				if(addresses.length == 0){
					alert("地址为空，保存失败");
					return false;
				}else{
					
				$.ajax({
		                cache: true,
		                type: "POST",
		                url:"saveaddress",
		                data:{address:addresses},// 你的formid
		                async: false,
		                error: function(request) {
		                    alert("保存失败");
		                },
		                success: function(data) {
		                  alert("保存成功");
		                }
		            });		
					  
				}
			});
			$('.add').click(function(){
				var addresses = $('#address').val();
				if(addresses.length==0){
					alert("地址为空，保存失败");
					return false;
				}
				$.ajax({
                cache: true,
                type: "POST",
                url:"address",
                data:$('#formaddress').serialize(),// 你的formid
                async: false,
                error: function(request) {
                    alert("新地址添加失败");
                },
                success: function(data) {
                    alert("新地址添加成功");
                    //$('#addresult').html("新地址添加成功");
                    
                }
            });		
			
			});
			$('.shour').blur(function(){
				var t = $(this).val();
				if(t == 1){
					//alert("请选择时间段");
				}
			});
			$('.sday').blur(function(){
				var t = $(this).val();
				
				if((dd == 1&&t == 2)||(dd == 1&&t == 3)||(dd == 2&&t == 3)){
					$('.shour').find('option').eq(1).removeAttr("disabled");
					$('.shour').find('option').eq(2).removeAttr("disabled");
					$('.shour').find('option').eq(3).removeAttr("disabled");
					$('.shour').find('option').eq(4).removeAttr("disabled");
					$('.shour').find('option').eq(5).removeAttr("disabled");
					$('.shour').find('option').eq(6).removeAttr("disabled");
					$('.shour').find('option').eq(7).removeAttr("disabled");
				}
			});
			$('.sday').blur(function(){
				
				var t = $(this).val();
				if(t==1){
					nottime("");//后台时间段控制
				}
				if(t==2){
					nottime(2);//后台时间段控制
				}
				if(t==3){
					nottime(3);//后台时间段控制
				}
				if(dd == 1&&t == 1 || dd == 2&&t == 2 || dd == 3&&t == 3){
					limitTime();
				}
			});
			
		});
		function browserRedirect() {
		    var sUserAgent = navigator.userAgent.toLowerCase();
		    var bIsIpad = sUserAgent.match(/ipad/i) == "ipad";
		    var bIsIphoneOs = sUserAgent.match(/iphone os/i) == "iphone os";
		    var bIsMidp = sUserAgent.match(/midp/i) == "midp";
		    var bIsUc7 = sUserAgent.match(/rv:1.2.3.4/i) == "rv:1.2.3.4";
		    var bIsUc = sUserAgent.match(/ucweb/i) == "ucweb";
		    var bIsAndroid = sUserAgent.match(/android/i) == "android";
		    var bIsCE = sUserAgent.match(/windows ce/i) == "windows ce";
		    var bIsWM = sUserAgent.match(/windows mobile/i) == "windows mobile";
		   
		    if (bIsIpad || bIsIphoneOs || bIsMidp || bIsUc7 || bIsUc || bIsAndroid || bIsCE || bIsWM) {
		       $('.pay').show();
		       $('.ewm').hide();
		    	//window.location.href="http://m.baidu.com";
		    } else {
		      
		    }  
		} 

	//计算配送方式对应价钱
	function getp(){
		
		var money = <%= m%>;
		
		if($('.sudu').val() == 1){
			money = Math.floor(money * 100) / 100 ;//保留一位小数
		}
		if($('.sudu').val() == 2){
			money = Math.floor(money * 100 * 2) / 100 ;//保留一位小数
		}
		if($('.sudu').val() == 3){
			money = Math.floor(money * 100 * 5) / 100 ;//保留一位小数
		}
		money *=discount; 
		
		money = parseFloat(money).toFixed(1);
		$('.mon').html(money);
		$('.mon1').val(money);
		//alert($('.sudu').val());
		limitTime();
	} 
	
	function nottime(fp){
		var str = $('#ids'+fp).val();
		strs=str.split(","); //字符分割 
		for(var i = 0;i < strs.length;i++){
				if(strs[i] == "no1"){
					$('.shour').find('option').eq(1).attr('disabled','disabled');
				}
				if(strs[i] == "no2"){
					$('.shour').find('option').eq(2).attr('disabled','disabled');
				}
				if(strs[i] == "no3"){
					$('.shour').find('option').eq(3).attr('disabled','disabled');
				}
				if(strs[i] == "no4"){
					$('.shour').find('option').eq(4).attr('disabled','disabled');
				}
				if(strs[i] == "no5"){
					$('.shour').find('option').eq(5).attr('disabled','disabled');
				}
				if(strs[i] == "no6"){
					$('.shour').find('option').eq(6).attr('disabled','disabled');
				}
				if(strs[i] == "no7"){
					$('.shour').find('option').eq(7).attr('disabled','disabled');
				}
			}
	}
	
	function limitTime(){
		var nowtime = new Date();
		//alert(nowtime.getHours());
		var nowday = nowtime.getDay();
		var nowhour = nowtime.getHours();
		var nowminute = nowtime.getMinutes();
		
		var w = <%=waittime%>;
			w += 300;//5分钟额外时间
		
		if($('.sudu').val() == 1){
			$('.sday').show();
			$('.shour').show();
			$('.tip1').hide();
			$('.timerange').hide();
			$('.timerange1').hide();
			$('.plantime').html("");
			var t1 = 0;
			var t2 = 0;
			var t3 = 0;//三个变量对应时间选择框状态
			
			if(parseInt(w/(60*60))+nowhour <= 21){//当天
				nottime("");//后台时间段控制
				t1 = 1;
				t2 = parseInt(w/(60*60))+nowhour;
				t3 = w%(60*60)/60;
				if(60 - nowminute < t3){
					t2 += 1;
					t3 = t3 - (60 - nowminute); 
				}else{
					t3 = t3 + nowminute;
				}
				//当前时间所在时间段 不可选
				if((nowhour == 9 && nowminute >=40) || nowhour >= 10){
					$('.shour').find('option').eq(1).attr('disabled','disabled');
				}
				if (nowhour == 12 && nowminute >= 30) {
					$('.shour').find('option').eq(2).attr('disabled','disabled');
				}
				if ((nowhour == 13 && nowminute >= 40)||nowhour>=14) {
					$('.shour').find('option').eq(3).attr('disabled','disabled');
				}
				if (nowhour == 15 && nowminute >= 20 && nowminute <= 50 ) {
					$('.shour').find('option').eq(4).attr('disabled','disabled');
				}
				if ((nowhour == 17 && nowminute >= 40) || nowhour >= 18) {
					$('.shour').find('option').eq(5).attr('disabled','disabled');
				}
				if ((nowhour == 18 && nowminute >= 40) || nowhour >= 19) {
					$('.shour').find('option').eq(6).attr('disabled','disabled');
				}
				if (nowhour == 21 && nowminute >= 10 && nowminute <= 40) {
					$('.shour').find('option').eq(7).attr('disabled','disabled');
				}
				
			}else if(parseInt(w/(60*60))+nowhour > 21 && parseInt(w/(60*60)) - (21 - nowhour) <= 12){//明天
				
				t1 = 2;
				t2 = 9 + parseInt(w/(60*60)) - (21 - nowhour);
				t3 = w%(60*60)/60;
				if(60 - nowminute < t3){
					t2 += 1;
					t3 = t3 - (60 - nowminute); 
				}else{
					t3 = t3 + nowminute;
				}
			}else if(parseInt(w/(60*60)) - (21 - nowhour) > 12&&parseInt(w/(60*60)) - (21 - nowhour) < 24){//后天
				
				t1 = 3;
				t2 = 9 + parseInt(w/(60*60)) - (21 - nowhour) - 12;
				t3 = w%(60*60)/60;
				if(60 - nowminute < t3){
					t2 += 1;
					t3 = t3 - (60 - nowminute); 
				}else{
					t3 = t3 + nowminute;
				}
			}
			//alert(t1+","+t2+","+t3);
			dd = t1;
			for(var i = 1;i < t1;i++){
				$('.sday').find('option').eq(i).attr('disabled','disabled');
			}
			
			if((t2 == 10&&t3>20)||t2>10){
				$('.shour').find('option').eq(1).attr('disabled','disabled');
			} 
			if(t2 == 13&&t3>0||t2>13){
				//$('.shour').find('option').eq(0).attr('disabled','disabled');
				$('.shour').find('option').eq(2).attr('disabled','disabled');
			}
			if((t2 == 14&&t3>10)||t2>14){
				$('.shour').find('option').eq(3).attr('disabled','disabled');
			}
			
			if((t2 == 15&&t3>50) || t2>15){
				$('.shour').find('option').eq(4).attr('disabled','disabled');
			}
			if(t2 == 18&&t3>10 || t2>18){
				
				$('.shour').find('option').eq(5).attr('disabled','disabled');
			}
			if(t2 == 19&&t3>10 || t2>19){
				
				$('.shour').find('option').eq(6).attr('disabled','disabled');
			}
			//alert(t2+","+t3);
			if(t2 == 21&&t3>40 || t2 > 21){
				
				$('.shour').find('option').eq(7).attr('disabled','disabled');
			}
			
		}else if($('.sudu').val() == 2){
			$('.tip1').show();
			$('.timerange').show();
			$('.timerange1').hide();
			$('.sday').hide();
			$('.shour').hide();
			
			var will = <%=m%>;
			will = (parseInt(will)+1)*60;
			w = w + will; 
			var t1 = 0;
			var t2 = 0;
			var t3 = 0;//三个变量对应时间选择框状态
			
			if(parseInt(w/(60*60))+nowhour <= 21){//当天
				t1 = 1;
				t2 = parseInt(w/(60*60))+nowhour;
				t3 = parseInt(w%(60*60)/60);
				if(60 - nowminute < t3){
					t2 += 1;
					t3 = t3 - (60 - nowminute); 
				}else{
					t3 = t3 + nowminute;
				}
				
			}else if(parseInt(w/(60*60))+nowhour > 21 && parseInt(w/(60*60)) - (21 - nowhour) <= 12){//明天
				t1 = 2;
				t2 = 9 + parseInt(w/(60*60)) - (21 - nowhour);
				t3 = w%(60*60)/60;
				if(60 - nowminute < t3){
					t2 += 1;
					t3 = t3 - (60 - nowminute); 
				}else{
					t3 = t3 + nowminute;
				}
			}else if(parseInt(w/(60*60)) - (21 - nowhour) > 12&&parseInt(w/(60*60)) - (21 - nowhour) < 24){//后天
				t1 = 3;
				t2 = 9 + parseInt(w/(60*60)) - (21 - nowhour) - 12;
				t3 = w%(60*60)/60;
				if(60 - nowminute < t3){
					t2 += 1;
					t3 = t3 - (60 - nowminute); 
				}else{
					t3 = t3 + nowminute;
				}
			}
			if(t2<10){
				t2 = "0"+t2;
			}
			if(t3<10){
				t3 = "0"+t3;
			}
			//显示预计送达时间
			var t = "预计打印完成时间：";
			switch(t1){
				case 1:t += "今天";break;
				case 2:t += "明天";break;
				case 3:t += "后天";break;
			}
			//alert(t1+t2);
			$('.plantime').html(t+t2+":"+t3);
			
			
		}
		else if($('.sudu').val() == 3){
			$('.tip1').show();
			$('.timerange').hide();
			$('.timerange1').show();
			$('.sday').hide();
			$('.shour').hide();
			var will = <%=m%>;
			will = (parseInt(will)+1)*60;
			w = w + will; 
			var t1 = 0;
			var t2 = 0;
			var t3 = 0;//三个变量对应时间选择框状态
			
			if(parseInt(w/(60*60))+nowhour <= 21){//当天
				t1 = 1;
				t2 = parseInt(w/(60*60))+nowhour;
				t3 = parseInt(w%(60*60)/60);
				if(60 - nowminute < t3){
					t2 += 1;
					t3 = t3 - (60 - nowminute); 
				}else{
					t3 = t3 + nowminute;
				}
				
			}else if(parseInt(w/(60*60))+nowhour > 21 && parseInt(w/(60*60)) - (21 - nowhour) <= 12){//后天
				t1 = 2;
				t2 = 9 + parseInt(w/(60*60)) - (21 - nowhour);
				t3 = w%(60*60)/60;
				if(60 - nowminute < t3){
					t2 += 1;
					t3 = t3 - (60 - nowminute); 
				}else{
					t3 = t3 + nowminute;
				}
			}else if(parseInt(w/(60*60)) - (21 - nowhour) > 12&&parseInt(w/(60*60)) - (21 - nowhour) < 24){//后天
				t1 = 3;
				t2 = 9 + parseInt(w/(60*60)) - (21 - nowhour) - 12;
				t3 = w%(60*60)/60;
				if(60 - nowminute < t3){
					t2 += 1;
					t3 = t3 - (60 - nowminute); 
				}else{
					t3 = t3 + nowminute;
				}
			}
			if(t2<10){
				t2 = "0"+t2;
			}
			if(t3<10){
				t3 = "0"+t3;
			}
			//显示预计送达时间
			var t = "预计打印完成时间：";
			switch(t1){
				case 1:t += "今天";break;
				case 2:t += "明天";break;
				case 3:t += "后天";break;
			}
			//alert(t1+t2);
			$('.plantime').html(t+t2+":"+t3);
			
			
		}
		
	}	
		var wait=120; 
		function time1(o) { 
		
			if($("#telphone").val().length == 11){
				if(wait == 120){
				
					$.ajax({
					   type:"post",//请求方式
					   url:"sendmsg",//发送请求地址
					   data:{//发送给数据库的数据
					   tel:$("#telphone").val(),
					   fp:"recoll"
					   },
					   //请求成功后的回调函数有两个参数
					   success:function(data,textStatus){
					   random = data;
					   //alert(data);
					   //window.top.location.href="";
					   }
					   });
					 
				}
				
				////
				 if (wait == 0) {  
		            o.removeAttribute("disabled");            
		            o.value="获取验证码";  
		            wait = 120;  
		        } else {  
		            o.setAttribute("disabled", true);  
		            o.value="重新发送(" + wait + ")";  
		            wait--;  
		            setTimeout(function() {  
		                time(o)  
		            },  
		            1000)  
		        }  
			} else{
				alert("请正确填写手机号码");
			}
	       
	    }  
	    
		function telValidate(){
			var tel = $('#tel').val();
			if(tel.length != 11){
				$('#telerror').html("请输入正确的手机号");
			}else{
				var myreg = /^(((13[0-9]{1})|(15[0-9]{1})|(18[0-9]{1}))+\d{8})$/; 
				if(!myreg.test(tel)) {
					$('#telerror').html("不是有效的手机号");
				}else{
					$('#telerror').html("");
				}
			}
		}
		function pswValidate(){
			var psw = $('#psw').val();
			if(psw.length <6||psw.length >20){
				$('#pswerror').html("密码长度6~20位数字或字符");
			}else{
				var reg = /^[0-9a-zA-Z]+$/;
				if(!reg.test(psw)){
					$('#pswerror').html("密码只能由数字或字母组成");

				}else{
					$('#pswerror').html("");
				}
			}
		}
		function yzmValidate(){
			var yzm = $('#yzm').val();
			if(yzm.length != 4){
				$('#yzmerror').html("验证码长度错误");
			}else{
				$('#yzmerror').html("");
			}var yzm = $(this).val();
			if(yzm.length != 4){
				$('#yzmerror').html("验证码长度错误");
			}else{
				$('#yzmerror').html("");
			}
		}
		function rpswValidate(){
			var rpsw = $('#rpsw').val();
			var psw = $('#psw').val();
			if(rpsw != psw){
				$('#rpswerror').html("两次密码不匹配");
			}else{
				$('#rpswerror').html("");
			}
		}

		//var wait=120; 
		function time(o) { 
			$('#tel').blur();
			if($("#telerror").html().length == 0){
				if(wait == 120){
					$.ajax({
					   type:"post",//请求方式
					   url:"sendmsg",//发送请求地址
					   data:{//发送给数据库的数据
					   tel:$("#tel").val(),
					   fp:"recoll"
					   },
					   //请求成功后的回调函数有两个参数
					   success:function(data,textStatus){
					   //window.top.location.href="";
					   }
					   });
					 
				}
				
				////
				 if (wait == 0) {  
		            o.removeAttribute("disabled");            
		            o.value="获取验证码";  
		            wait = 120;  
		        } else {  
		            o.setAttribute("disabled", true);  
		            o.value="重新发送(" + wait + ")";  
		            wait--;  
		            setTimeout(function() {  
		                time(o)  
		            },  
		            1000)  
		        }  
			} 
		   
		}  

		function postform(which){
			var action;
			var formid;
			var formvalidate =false;//表单验证是否满足
			if(which == 1){
				$('#pswerror').blur();
				$('#telerror').blur();
				if($('#pswerror').html().length != 0 || $('#telerror').html().length != 0){
					return false;
				}
				action = 'login';
				formid = 'loginform';
			}
			if(which == 2){
				$('#pswerror').blur();
				$('#rpswerror').blur();
				$('#telerror').blur();
				$('#yzmerror').blur();
				if($('#pswerror').html().length != 0 || $('#telerror').html().length != 0 ||$('#rpswerror').html().length != 0||$('#yzm').html().length != 0 ){
					return false;
				}
				action = 'recoll';
				formid = 'recollform';
			}
			if(which == 3){
				$('#yzmerror').blur();
				$('#telerror').blur();
				if($('#yzmerror').html().length != 0 || $('#telerror').html().length != 0){
					return false;
				}
				action = 'modifypsw';
				formid = 'modifyform';
			}
			var state = false;
			$.ajax({
				cache: true,
		        type: "POST",
		        url:action,
		        data:$('#'+formid).serialize(),// 你的formid
		        async: false,
		        error: function(request) {
		            alert("提交失败");
		        },
		        success: function(data) {
		           
		            if(data == 'user'){
		            	state = true;
		            	alert("登录成功");
		            }else if(data == 'admin'){
		            	
		            	window.location.href="waitorder";
		            }else{
		            	 $("#result").html(data);
		            	
		            }
		        }
				
			});
			
			 return state;
			
		}

		//显示界面
		function showlogin(which){
			$('#showdiv').html('');
				var htmls ='';
				if(which == 1){//登录界面
					htmls = '<form id="loginform" class="form-horizontal" method="post" >';
					htmls += '<div class="form-group">';
				    htmls += '<label for="inputEmail3" class="col-sm-2 control-label">手机号码</label>';
				    htmls += '<div class="col-sm-10">';
				    htmls += '<input type="text" class="form-control" id="tel" name="telphone" placeholder="11位手机号" onblur="telValidate();">';
				    htmls += '<p id="telerror" style="color:red;"></p>';
				    htmls += '</div>';
				  	htmls += '</div>';
				  	htmls += '<div class="form-group">';
				    htmls += '<label for="inputPassword3" class="col-sm-2 control-label">登录密码</label>';
				    htmls += '<div class="col-sm-10">';
				    htmls += '<input type="password" class="form-control" id="psw" name="password" placeholder="6~20位字符" onblur="pswValidate();">';
				    htmls += '<p id="pswerror" style="color:red;"></p>';
				    htmls += '</div>';
				  	htmls += '</div>';
				  	htmls += '<div class="form-group">';
				    htmls += '<div class="col-sm-offset-2 col-sm-10">';
				    htmls += '<button type="submit" class="btn btn-default" onclick="return postform(1);">提交</button>';
				    htmls += '</div>';
				  	htmls += '</div>';
				  	htmls += '<div class="form-group">';
				    htmls += '<div class="col-sm-offset-2 col-sm-10">';
					htmls += '<p id="result" style="color: red;"></p>';
				    htmls += '</div>';
				  	htmls += '</div>';
					htmls += '</form>';
				}
				if(which == 2){//注册界面
					
					htmls = '<form id="recollform" class="form-horizontal" method="post">';
					htmls += '<div class="form-group">';
				    htmls += '<label for="inputEmail3" class="col-sm-2 control-label">手机号码</label>';
				    htmls += '<div class="col-sm-10">';
				    htmls += '<input type="text" class="form-control" id="tel" name="telphone" placeholder="11位手机号" onblur="telValidate();">';
				    htmls += '<p id="telerror" style="color:red;"></p>';
				    htmls += '</div>';
				  	htmls += '</div>';
				    htmls += '<div class="form-group">';
				    htmls += '<label for="inputEmail3" class="col-sm-2 control-label">验证码</label>';
				    htmls += '<div class="col-sm-10">';
				    htmls += '<div class="row">';
				    htmls += '<div class="col-sm-9"><input type="text" class="form-control"  id="yzm" name="numbercode" placeholder="" onblur="yzmValidate();"></div>';
				    htmls += '<div class="col-sm-3"> <input style="float: right;" class="btn btn-primary" type="button" value="获取验证码" onclick="time(this);"/></div>';
				    htmls += '<p id="yzmerror" style="color:red;"></p>';
				    htmls += '</div>';
				    htmls += '</div>';
				    htmls += '</div>';
				    htmls += '<div class="form-group">';
				    htmls += '<label for="inputPassword3" class="col-sm-2 control-label">登录密码</label>';
				    htmls += '<div class="col-sm-10">';
				    htmls += '<input type="password" class="form-control" id="psw" name="password" placeholder="6~20位字符" onblur="pswValidate();">';
				    htmls += '<p id="pswerror" style="color:red;"></p>';
				    htmls += '</div>';
				  	htmls += '</div>';
				 	htmls += '<div class="form-group">';
				    htmls += '<label for="inputPassword3" class="col-sm-2 control-label">确认密码</label>';
				    htmls += '<div class="col-sm-10">';
				    htmls += '<input type="password" class="form-control" id="rpsw" name="rpassword" placeholder="6~20位字符" onblur="rpswValidate();">';
				    htmls += '<p id="rpswerror" style="color:red;"></p>';
				    htmls += '</div>';
				  	htmls += '</div>';
				  	htmls += '<div class="form-group">';
				    htmls += '<div class="col-sm-offset-2 col-sm-10">';
				    htmls += '<button type="submit" class="btn btn-default" onclick="return postform(2);">提交</button>';
				    htmls += '</div>';
				  	htmls += '</div>';
				  	htmls += '<div class="form-group">';
				    htmls += '<div class="col-sm-offset-2 col-sm-10">';
				    htmls += '<p id="result" style="color: red;"></p>';
				    htmls += '</div>';
				  	htmls += '</div>';
					htmls += '</form>';
				}
				if(which == 3){//忘记密码
					htmls = '<form id="modifyform" class="form-horizontal" method="post" >';
					htmls += '<div class="form-group">';
				    htmls += '<label for="inputEmail3" class="col-sm-2 control-label">手机号码</label>';
				    htmls += '<div class="col-sm-10">';
				    htmls += '<input type="text" class="form-control" id="tel" name="telphone" placeholder="11位手机号" onblur="telValidate();">';
				    htmls += '<p id="telerror" style="color:red;"></p>';
				    htmls += '</div>';
				  	htmls += '</div>';
				 	htmls += '<div class="form-group">';
				    htmls += '<label for="inputEmail3" class="col-sm-2 control-label">验证码</label>';
				    htmls += '<div class="col-sm-10">';
				   	htmls += '<div class="row">';
				    htmls += '<div class="col-sm-9"><input type="text" class="form-control"  id="yzm" name="numbercode" placeholder="" onblur="yzmValidate();"></div>';
				   	htmls += '<div class="col-sm-3"> <input style="float: right;" class="btn btn-primary"  type="button" value="获取验证码" onclick="time(this);"/></div>';
				    htmls += '<p id="yzmerror" style="color:red;"></p>';
				   	htmls += '</div>';
				    htmls += '</div>';
				  	htmls += '</div>';
				    htmls += '<div class="form-group">';
				    htmls += '<div class="col-sm-offset-2 col-sm-10">';
				    htmls += '<button type="submit" class="btn btn-default" onclick="return postform(3);">提交</button>';
				    htmls += '</div>';
				  	htmls += '</div>';
				  	htmls += '<div class="form-group">';
				    htmls += '<div class="col-sm-offset-2 col-sm-10">';
				    htmls += '<p id="result" style="color: red;"></p>';
				    htmls += '</div>';
				  	htmls += '</div>';
					htmls += '</form>';
				}
				$('#showdiv').html(htmls);
			}

	</script>
  </head>
  
  <body style="background:#f4f4f4;">
  <input type="hidden" id="ids" value="<%=WebParams.ids%>"/>
  <input type="hidden" id="ids2" value="<%=WebParams.ids2%>"/>
  <input type="hidden" id="ids3" value="<%=WebParams.ids3%>"/>
  
 
    	<div class="contaniter-fluid" >
				<div class="row">
					<ul class="breadcrumb" style="background-color: #333333;padding-top: 15px;padding-bottom: 15px;">
						 <li style="margin-left: 20px;"><a href="index.jsp">首页</a> <span class="divider"></span></li>
						 
						 <li><a href="printset">文件上传</a></li>
						 <li ><c:if test="${empty sessionScope.users }"><a href="submit.jsp">配送设置</a></c:if>
						 	  <c:if test="${not empty sessionScope.users }"><a href="submitset?users=${sessionScope.users }">配送设置</a></c:if></li>
						 <li class="active">订单管理</li>
						<c:if test="${not empty sessionScope.users }">
							 <div class="active" style="float: right;margin-right: 20px;"><a class="" title="进入用户管理界面" href="usermenu?user=${sessionScope.users }" style="color: white;"> <img alt="用户" width="30px" height="30px" src="image/log.png"></a></div>
							</c:if>
							<c:if test="${empty sessionScope.users }">
							 <div class="active" style="float: right;margin-right: 20px;"><a class="" title="未登录，点击登录" data-toggle="modal" data-target="#logModal" style="color: white;"><img alt="用户" width="30px" height="30px" src="image/nolog.png"></a></div>
							</c:if>
							</ul>
				</div>
				<div class="row" style="padding-top: 5px;">
					<div class="col-md-5"></div>
					<div class="col-md-2" align="center">
						<img alt="" src="image/ps.png" width="50px" height="50px"><br>
						<h5 style="font-weight: bold;">配送选择</h5>
					</div>
					<div class="col-md-5"></div>
				</div>
			<hr style="margin-top: 5px;background-color: grey;height: 1px;">
				<div class="row">
					<div class="col-md-3"></div>
					<div class="col-md-6">
					<div class="row" style="" >
					
						
						<%
							if(!WebParams.msg.equals("")){
							%>
							<div style="background-color: white;padding: 5px;">
								<h4 style="color: red;">系统提示：<%=WebParams.msg %></h4>
							 </div>
							<%
							}
						 %>
						
					</div>
						<div class="row" style="min-height: 300px;" >
							
							<div style="padding: 5px;margin: 5px;">
								 <li class="list-group-item" style="background-color: transparent;min-height: 300px;">
								<form class="form-horizontal"  action="isorder" method="post">	
								<div class="form-group">
									<label class="col-sm-2 control-label">配送方式</label>
									<div class="col-sm-10">
									<select class="sudu" name="sudu" style="background-color: transparent;" onchange="getp();">
											<option value="1">普速达(0.1元/面)</option>
											<option value="2">及时达(0.2元/面)</option>										
											<option value="3">瞬时达(0.5元/面)</option>										
									</select>
									<label class="control-label plantime" style="color: red;font-weight: normal;"></label>
									</div>
								</div>		
													    											     		
								<div class="form-group">
									<label class="col-sm-2 control-label">时间选择</label>
									<div class="col-sm-10">
										<select class="sday" name="gettime_date" style="background-color: transparent;">
											<option value="4">选择日期</option>
											<option value="1">今天</option>
											<option value="2">明天</option>										
											<option value="3">后天</option>										
										</select>
										<select class="shour" name="gettime_hour" style="background-color: transparent;margin-left: 10px;">
											<option value="1">选择时间段</option>
											<option value="09:40~10:20">09:40~10:20</option>
											<option value="12:30~13:00">12:30~13:00</option>	
											<option value="13:40~14:10">13:40~14:10</option>
											<option value="15:20~15:50">15:20~15:50</option>									
											<option value="17:40~18:10">17:40~18:10</option>									
											<option value="18:40~19:10">18:40~19:10</option>									
											<option value="21:10~21:40">21:10~21:40</option>									
																				
										</select>
										<label class="tip1" style="font-weight: normal;">打印完成后</label>
										<select class="timerange" name="timerange" style="background-color: transparent;">
																				
											<option value="30分">30分</option>										
											<option value="40分">40分</option>										
											<option value="50分">50分</option>										
																				
										</select>
										<select class="timerange1" name="timerange1" style="background-color: transparent;">
																				
											<option value="0分 ">0分</option>										
											<option value="10分">10分</option>										
											<option value="20分">20分</option>										
																				
										</select>			    
									</div>	
									
								</div>
								<c:if test="${empty sessionScope.users }">
									<input type="hidden" id="state" value="1"/>
									<div class="form-group">
										<label class="col-sm-2 control-label">手机号</label>
										<div class="col-sm-10">
											<input  type="text" style="background-color: transparent;" id="telphone"  name="tel" value="" placeholder=""/>
											<!--  <button class="get_code" value="" onclick="time(this);">获取验证码</button>-->
											<input class="get_code" type="button" value="获取验证码" onclick="time1(this);"/>											    
										</div>	
									</div>
									<div class="form-group">
										<label class="col-sm-2 control-label">验证码</label>
										<div class="col-sm-10">
											<input  type="text" style="background-color: transparent;" id="no-vcode"  name="vcode" value="" placeholder=""/>
																					    
										</div>	
									</div>
									<div class="form-group">
										<label class="col-sm-2 control-label">收货地址</label>
										<div class="col-sm-10">
											<input  type="text" style="width: 70%;background-color: transparent;" id="no-address" name="address" value="" placeholder=""/>
																					    
										</div>	
									</div>
									</c:if>
									<c:if test="${not empty sessionScope.users }">
										<input type="hidden" id="state" value="2"/>
										<div class="form-group">
											<label class=" col-sm-2 control-label">收货地址</label>
											<div class="col-sm-10">
												<c:if test="${empty requestScope.addresses }">
													<input type="hidden" id="addre" value="1"/>
													<input  type="text" class="usernewaddress" style="width: 70%;background-color: transparent;" id="address" name="address" value="" placeholder=""/>
													<button class="saveaddress">保存地址</button>
												</c:if>
												<c:if test="${not empty requestScope.addresses }">
													<input type="hidden" id="addre" value="2"/>
													<select class="" name="address" style="background-color: transparent;">
														<c:forEach items="${requestScope.addresses }" var="i">
															 <option>${i.address }</option>
														</c:forEach>
													
													</select>	
											
													<a class="btn" style=""  data-toggle="modal" data-target="#myModal">添加新地址</a>
													
												</c:if>
																				    
											</div>	
										</div>
									</c:if>
									
									<div class="form-group">
										<label class=" col-sm-2 control-label">备注</label>
										<div class="col-sm-10">
											<input  type="text" style="width: 70%;background-color: transparent;" name="moreword" value="" placeholder="选填"/>
																					    
										</div>	
									</div>
									<c:set value="<%=(int)discount %>" var="dis"></c:set>
									<c:if test="${dis!=1  }">
									<div class="form-group">
										<label class=" col-sm-2 control-label">折扣</label>
										<div class="col-sm-10">
											<label class="control-label" style="font-weight: normal;"><%=discount %></label>								    
										</div>	
									</div>
									</c:if>
									
									<div class="form-group">
										<label class=" col-sm-2 control-label">付款金额</label>
										<div class="col-sm-10">
											<input type="hidden" class="mon1" name="money" value="${requestScope.money }"/>
											<label class="control-label mon" style="font-weight: normal;color: red;">${requestScope.money }</label>								    
										</div>	
									</div>
									<div class="form-group">
										<label class=" col-sm-2 control-label">在线支付方式</label>
										<div class="col-sm-10">
											<div class="ewm">
											<img width="120px" height="120px" src="image/qqpay.png"/>
											<img width="120px" height="120px" src="image/zfbpay.jpg" style="margin-left: 50px;"/><br>
											 </div>
											 <div class="pay" style="display: none;"><a href="https://qr.alipay.com/apq51bdcbr44ufswa8" class="btn btn-success">支付宝支付</a><a href="http://qm.qq.com/cgi-bin/qm/qr?k=qavntYVlpOIAVFXfaXN7BnQzqP_WwhGh" style="margin-left: 10px;" class="btn btn-success">qq支付</a>
											 </div>										    
										</div>	
									</div>
							<div class="form-group">
									<div class="col-sm-offset-2 col-sm-10">
									<p  style="color: red;">注：请填写正确信息，付款后接单</p>
									<button type="submit"  class="btn btn-info btn-ok"><span class="glyphicon glyphicon-ok"></span> 确认下单</button>
									</div>
								</div>
								</form>
								</li>
							</div>

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
													        <form  method="post" id="formaddress" action="" class="form-horizontal">
													        <input type="hidden" class="form-control"  name="fp" value="submit">
													        	<input type="hidden" class="form-control"  name="user" value="${sessionScope.users}">
															   <div class="form-group">
															    <label class="control-label col-sm-2">地址</label>
															     <div class="col-sm-10">
															    <input type="type" class="form-control" id="address" name="address">
															   </div>
															   </div>
															  <div class="form-group">
															    <label class="control-label col-sm-2"></label>
															     <div class="col-sm-10">
															     <button type="submit" class="add" class="btn btn-default col-sm-offset-2" onclick=""><span class="glyphicon glyphicon-ok"></span> 确定</button>
																
															   </div>
															    <label id="addresult" style="color: red;"></label>
															   </div>
															
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
					<div class="col-md-3"></div>
				</div>
				<hr style="margin-top: 5px;background-color: grey;height: 1px;">
				<div class="row" style="margin-top: 20px;">
						
						<div class="col-md-3"></div>
								<div class="col-md-6" align="middle"><a href="printset" title="上一步"><img alt="" src="image/left.png" width="50px" height="50px" ></a>
																	</div>
								<div class="col-md-3"></div>
							</div>
			</div>
		<div class="qq" style="position: fixed;right: 4%;bottom: 30px;cursor: pointer;"><br><p align="center" style="font-size: 12px;margin-top: -10px;"><a href="http://wpa.qq.com/msgrd?v=3&uin=949071759&site=qq&menu=yes" target="_blank" title="发起qq聊天"><img width="50" height="50" src="image/qq.png"/><br>联系我</a></p></div>
  	 <%@ include file="_loginmodal.jsp" %>
  </body>
</html>
