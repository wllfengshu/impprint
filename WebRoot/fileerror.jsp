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
    
    <title>错误提示</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->

  </head>
  
  <body>
    ${requestScope.error }
    <c:if test="${empty sessionScope.users && empty sessionScope.nousers }"><a href="index.jsp">点击修复</a></c:if>
    <c:if test="${not empty sessionScope.users}"> <a href="clearerror?user=${ sessionScope.users}">点击修复</a></c:if>
    <c:if test="${not empty sessionScope.nousers}"> <a href="clearerror?user=${ sessionScope.nousers}">点击修复</a></c:if>
  </body>
</html>
