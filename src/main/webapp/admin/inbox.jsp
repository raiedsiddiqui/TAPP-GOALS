<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>Tapestry</title>
	<meta name="viewport" content="width=device-width, initial-scale=1.0"></meta>
		<link href="${pageContext.request.contextPath}/resources/css/bootstrap.min.css" rel="stylesheet" />
		<link href="${pageContext.request.contextPath}/resources/css/bootstrap-responsive.min.css" rel="stylesheet" />  		
		<script src="${pageContext.request.contextPath}/resources/js/jquery-2.0.3.min.js"></script>
		<script src="${pageContext.request.contextPath}/resources/js/bootstrap.min.js"></script>

	<style type="text/css">
		html,body{
			height:100%;
		}
		.content{
			overflow-x:auto;
			border-radius:5px;
			-moz-border-radius:5px;
			-webkit-border-radius:5px;
			-o-border-radius:5px;
			-ms-border-radius:5px;
		}

		tr:hover{
			background-color:#D9EDF7;
		}
	</style>
</head>
	
<body>	
  <img src="<c:url value="/resources/images/logo.png"/>" />
	<div class="content">
		<%@include file="navbar.jsp" %>
		
		<div class="row-fluid">
			<div class="span12" style="padding:0px 15px;">
				<ul class="breadcrumb">
					<li><h2><a href="<c:url value="/inbox"/>">Inbox</a></h2></li>
				</ul>
				<c:choose>
					<c:when test="${not empty messages}">
					<table class="table">
						<tr>
							<th>Sender</th>
							<th>Subject</th>
							<th>Date</th>
							<th></th>
						</tr>
						<c:forEach items="${messages}" var="m">
						<c:choose>
							<c:when test="${! m.read}"><tr onClick="document.location='<c:url value="/view_message/${m.messageID}"/>';" style="font-weight:bold;"></c:when>
							<c:otherwise><tr onClick="document.location='<c:url value="/view_message/${m.messageID}"/>';"></c:otherwise>
						</c:choose>
							<td>${m.sender}</td>
							<td>${m.subject}</td>
							<td>${m.date}</td>
							<td><a href="<c:url value="/delete_message/${m.messageID}"/>" class="btn btn-danger">Delete</button><td>
						</tr>
						</c:forEach>
					</table>
					</c:when>
					<c:otherwise>
						<p style="margin-left:25px">You have no messages</p>
					</c:otherwise>
				</c:choose>
			</div>
		</div>
	</div>


</body>
</html>