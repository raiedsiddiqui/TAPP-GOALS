<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:h="http://java.sun.com/jsf/html">
<head>
	<title>Tapestry Admin</title>
	<meta name="viewport" content="width=device-width, initial-scale=1.0"></meta>
		<link href="${pageContext.request.contextPath}/resources/css/bootstrap.min.css" rel="stylesheet" />
		<link href="${pageContext.request.contextPath}/resources/css/bootstrap-responsive.min.css" rel="stylesheet" />  		
		<script src="${pageContext.request.contextPath}/resources/js/jquery-2.0.3.min.js"></script>
		<script src="${pageContext.request.contextPath}/resources/js/bootstrap.min.js"></script>
	
	<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/printelement.js"></script>
	

	<style type="text/css">
		.row-fluid{
			margin:10px;
		}
	</style>
	
	<script type="text/javascript">
		function printTable(){
			$('.table').printThis();
		}
	</script>
</head>
	
<body>	
  <img src="<c:url value="/resources/images/logo.png"/>" />
	<div class="content">
		<%@include file="navbar.jsp" %>
		<div class="row-fluid">
			<h2>Survey Results: ${results["title"]}</h2>
			<h4>Completed on: ${results["date"]}</h4>
			<table class="table">
				<tr>
					<th>Question</th>
					<th>Answer</th>
				</tr>
				<c:forEach items="${results}" var="entry">
					<c:if test="${entry.key != 'title' && entry.key != 'date' && entry.key != 'surveyId'}">
					<tr>
						<td>${entry.key}</td>
						<td>${entry.value}</td>
					</tr>
					</c:if>
				</c:forEach>
			</table>
			<a href="<c:url value="/export_csv/${id}"/>" class="btn btn-primary">Export as CSV</a>
		</div>
	</div>
</body>
</html>
