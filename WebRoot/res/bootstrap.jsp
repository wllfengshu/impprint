<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% 
	String basePath = request.getScheme()
					+ "://"
					+ request.getServerName()
					+ ":"
					+ request.getServerPort()
					+ request.getContextPath()
					+ "/";
%>
  <Link Rel="SHORTCUT ICON" href="<%= basePath %>image/logo.png">
<script type="text/javascript" src="<%= basePath %>res/jquery.min.js"></script>
<link rel="stylesheet" type="text/css" href="<%= basePath %>res/common.css">
<link rel="stylesheet" type="text/css" href="<%= basePath %>res/bootstrap-3.3.5-dist/css/bootstrap.min.css">
<script type="text/javascript" src="<%= basePath %>res/bootstrap-3.3.5-dist/js/bootstrap.min.js"></script>
