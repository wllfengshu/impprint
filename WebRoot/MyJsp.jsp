<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>My JSP 'MyJsp.jsp' starting page</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
	<style type="text/css">
		.thumb {
    width: 24px;
    height: 24px;
    float: none;
    position: relative;
    top: 7px;
}
form .progress {
    line-height: 15px;
}
}
.progress {
    display: inline-block;
    width: 100px;
    border: 3px groove #CCC;
}
.progress div {
    font-size: smaller;
    background: orange;
    width: 0;
}
	</style>
	<script src="//cdn.bootcss.com/angular.js/2.0.0-beta.17/angular2-all-testing.umd.dev.js"></script>
<script src="res/ng-file-upload-bower-12.0.4/ng-file-upload-shim(.min).js"></script> <!-- for no html5 browsers support -->
<script src="res/ng-file-upload-bower-12.0.4/ng-file-upload(.min).js"></script>
	<script type="text/javascript">
		var app = angular.module('fileUpload', ['ngFileUpload']);

app.controller('MyCtrl', ['$scope', 'Upload', '$timeout', function ($scope, Upload, $timeout) {
    $scope.uploadFiles = function (files) {
        $scope.files = files;
        if (files && files.length) {
            Upload.upload({
                url: 'https://angular-file-upload-cors-srv.appspot.com/upload',
                data: {
                    files: files
                }
            }).then(function (response) {
                $timeout(function () {
                    $scope.result = response.data;
                });
            }, function (response) {
                if (response.status > 0) {
                    $scope.errorMsg = response.status + ': ' + response.data;
                }
            }, function (evt) {
                $scope.progress = 
                    Math.min(100, parseInt(100.0 * evt.loaded / evt.total));
            });
        }
    };
	</script>
  </head>
  
 <body ng-app="fileUpload" ng-controller="MyCtrl">
     <h4>Upload on file select</h4>

    <button ngf-select="uploadFiles($files)" multiple 
            accept="image/*">Select Files</button>
    <br>
    <br>Files:
    <ul>
        <li ng-repeat="f in files" style="font:smaller">
            {{f.name}}
        </li>
    </ul>
    <span class="progress" ng-show="progress >= 0">
        <div style="width:{{progress}}%" ng-bind="progress + '%'"></div>
    </span>
    {{errorMsg}}
</body>
</html>
