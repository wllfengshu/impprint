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

var wait=120; 
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
