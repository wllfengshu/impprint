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

	<table class="table table-hover table-bordered" id="tableExcel">
		<col width="15%">
		<thead>
			<tr>
				<th>订单日期</th>
				<th>订单编号</th>
				<th>客户电话</th>
				<th>订单金额</th>

			</tr>
		</thead>
		<tbody>
			<c:if test="${empty sessionScope.orders }">
				<tr>
					<td colspan="4">暂无数据</td>
				</tr>
			</c:if>

			<c:set var="sum" value="0"></c:set>
			<c:forEach items="${sessionScope.orders }" var="i">
				<tr>
					<td>${fn:substring(i.date, 0, 10)}</td>
					<td>${i.ordernum }</td>
					<td>${i.tel }</td>
					<td>${i.money }</td>
				</tr>
				<c:set var="sum" value="${sum+i.money }"></c:set>

			</c:forEach>
			<c:if test="${not empty sessionScope.orders }">
				<tr style="background-color: #E0E0E0;">
					<td colspan="4"><c:if
							test="${not empty sessionScope.nowtime }">${sessionScope.nowtime}</c:if>
						总计 : 订单数量（<span style="color: red;">${fn:length(orders)}</span>）总金额（<span
						style="color: red;"><fmt:formatNumber value="${ sum}"></fmt:formatNumber>
					</span>）</td>
				</tr>
			</c:if>

		</tbody>
	</table>
</body>
</html>
