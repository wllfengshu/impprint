 <%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
 
 
 <!-- <a class="" id="log"  data-toggle="modal" data-target="#logModal"></a> -->
 <!-- Modal 登录框-->
	<div class="modal fade" id="logModal" tabindex="-1" role="dialog"
		aria-labelledby="myModalLabel">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">用户登录窗口</h4>
				</div>
				<div id="showdiv" class="modal-body">
					<!--  -->
					<form id="loginform" class="form-horizontal" method="post">
						<div class="form-group">
							<label for="inputEmail3" class="col-sm-2 control-label">手机号码</label>
							<div class="col-sm-10">
								<input type="text" class="form-control" id="tel" name="telphone" onblur="telValidate();"
									placeholder="11位手机号">
								<p id="telerror" style="color:red;"></p>
							</div>
						</div>
						<div class="form-group">
							<label for="inputPassword3" class="col-sm-2 control-label">登录密码</label>
							<div class="col-sm-10">
								<input type="password" class="form-control" id="psw" onblur="pswValidate();"
									name="password" placeholder="6~20位字符">
								<p id="pswerror" style="color:red;"></p>
							</div>
						</div>
						<div class="form-group">
							<div class="col-sm-offset-2 col-sm-10">
								<button type="submit" class="btn btn-default"
									onclick="return postform(1);">提交</button>
							</div>
						</div>
						<div class="form-group">
							<div class="col-sm-offset-2 col-sm-10">
								<p id="result" style="color: red;"></p>
							</div>
						</div>
					</form>

				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default"
						onclick="showlogin('3');">忘记密码</button>
					<button type="button" class="btn btn-default"
						onclick="showlogin('2');">立即注册</button>
					<button type="button" class="btn btn-default"
						onclick="showlogin('1');">立即登录</button>
					<button type="button" class="btn btn-default" data-dismiss="modal">跳过登录</button>

				</div>
			</div>
		</div>
	</div>
	<!-- Modal -->