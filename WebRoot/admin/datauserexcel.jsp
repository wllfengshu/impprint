<%@page import="imp.unit.DealFileName"%>
<%@page import="imp.bean.WaitPrintFile"%>
<%@page import="imp.bean.Pagination"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8" contentType="application/vnd.ms-excel"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
response.setHeader("Content-Disposition", "inline; filename=" + "excel.xls");
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>印象打印</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<jsp:include page="../res/bootstrap.jsp"></jsp:include>
	
	<script type="text/javascript">
		$(function(){
			
			
			
		});
		
		
		
	
	</script>
  </head>
  
  <body >
  <%
  			String type = null;
  			if(session.getAttribute("type") != null){
  				type = (String)session.getAttribute("type");
  			}
  			if(type==null){
  				response.sendRedirect("index.jsp");
  			}else{
  				if(type.equals("user")){
  					response.sendRedirect("index.jsp");
  				}
  			}
  		 %>

	<table class="table table-hover table-bordered">
							<col width="5%"><col><col><col><col width="10%">
							<thead>
								<tr>
									<th>用户</th>
									<th>订单总数</th>
									<th>订单总额</th>
									
								
								</tr>
							</thead>
							<tbody>
							<c:if test="${empty sessionScope.userOrders }">
								<tr><td colspan="4">暂无数据</td></tr>
							</c:if>
							
							<c:set var="orders" value="0"></c:set>
							<c:set var="moneys" value="0"></c:set>
							<c:forEach items="${sessionScope.userOrders }" var="i" varStatus="n">
									<tr>
										<td>${n.count }</td>
										<td>${i.user}</td>
										<td>${i.totalOrderNum }</td>
										<td><fmt:formatNumber value="${i.totalMoney }"></fmt:formatNumber></td>
										<c:set var="orders" value="${orders+i.totalOrderNum }"></c:set>
										<c:set var="moneys" value="${moneys+i.totalMoney }"></c:set>
									</tr>
							</c:forEach>
							<c:if test="${not empty sessionScope.userOrders }">
								<tr style="background-color: #E0E0E0;">
									<td colspan="5"> 总计 : 总订单数（<span style="color: red;"><fmt:formatNumber value="${ orders}"></fmt:formatNumber></span>） 总金额（<span style="color: red;"><fmt:formatNumber value="${ moneys}"></fmt:formatNumber></span>）</td></tr>
							</c:if>
							
				 	 	</tbody>
				 	 	</table>
				   
</body>
</html>
