<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>Tapestry Admin</title>
	<meta name="viewport" content="width=device-width, initial-scale=1.0"></meta>
	<link href="http://netdna.bootstrapcdn.com/twitter-bootstrap/2.3.2/css/bootstrap-combined.min.css" rel="stylesheet"></link>
	<script src="http://code.jquery.com/jquery-2.0.0.min.js"></script>
	<script src="http://netdna.bootstrapcdn.com/twitter-bootstrap/2.3.2/js/bootstrap.min.js"></script>
	
	<script type="text/javascript">
		function showAssignSurvey(){
			document.getElementById("assignSurveyDiv").style.display="block";
		}
	</script>
	
	<style type="text/css">
		.row-fluid{
			margin:10px;
		}
	</style>
</head>

<body>
  <img src="<c:url value="/resources/images/logo.png"/>" />
	<div class="content">
		<div class="navbar navbar-inverse">
			<div class="navbar-inner">
				<div class="container">
					<a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
        				<span class="icon-bar"></span>
        				<span class="icon-bar"></span>
       			 		<span class="icon-bar"></span>
     				</a>
     					
     				<a class="brand" href="<c:url value="/"/>">Home</a>
     				<div class="nav-collapse collapse">
						<ul class="nav">
							<li><a href="<c:url value="/manage_users"/>">Manage Volunteers</a></li>
							<li><a href="<c:url value="/manage_patients"/>">Manage Patients</a></li>
							<li><a href="<c:url value="/manage_survey_templates"/>">Manage Survey Templates</a></li>
							<li><a href="<c:url value="/manage_surveys"/>">Manage Surveys</a></li>
							<li><a href="<c:url value="/user_logs"/>">User Logs</a><li>
							<li><a href="<c:url value="/j_spring_security_logout"/>">Log Out</a></li>
						</ul>
					</div>
				</div>	
			</div>
		</div>
		
		
		<div class="row-fluid">
			<h2>Surveys</h2>
			<table class="table">
				<tr>
					<th>Survey</th>
					<th>Patient</th>
					<th>Date Assigned</th>
					<th>Status</th>
					<th>Last Edit Date</th>
					<th>Remove</th>
				</tr>
				<c:forEach items="${surveys}" var="s">
				<tr>
					<td><a href="<c:url value="/show_survey/${s.resultID}"/>">${s.surveyTitle}</a></td>
					<td>${s.patientName}</td>
					<td>${s.startDate}</td>
					<td><c:choose>
							<c:when test="${!s.completed}">Incomplete</c:when>
							<c:otherwise>Complete</c:otherwise>
						</c:choose></td>
					<td>${s.editDate}</td>
					<td><a href="<c:url value="/delete_survey/${s.resultID}"/>" class="btn btn-danger">Remove</a></td>
				</tr>
				</c:forEach>
			</table>
			<a class="btn btn-primary" onClick="showAssignSurvey()">Assign Surveys</a>
		</div>

		<div class="row-fluid" id="assignSurveyDiv" style="display:none";>
			<form action="assign_surveys" method="post">
				<fieldset>
					<legend></legend>
					<label>Survey</label>
					<select name="surveyID">
						<c:forEach items="${survey_templates}" var="st">
						<option value="${st.surveyID}">${st.title}</option>
						</c:forEach>
					</select><br />
					<label>Patient(s):</label>
					<select multiple name="patients[]">
						<c:forEach items="${patients}" var="p">
						<option value="${p.patientID}">${p.firstName} ${p.lastName}</option>
						</c:forEach>
					</select><br />
					<input class="btn btn-primary" type="submit" value="Upload" />
				</fieldset>
			</form>
		</div>
	</div>
</body>
</html>