<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Details of volunteer</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0"></meta>
		<link href="${pageContext.request.contextPath}/resources/css/bootstrap.min.css" rel="stylesheet" />
		<link href="${pageContext.request.contextPath}/resources/css/bootstrap-responsive.min.css" rel="stylesheet" />  		
		<script src="${pageContext.request.contextPath}/resources/js/jquery-2.0.3.min.js"></script>
		<script src="${pageContext.request.contextPath}/resources/js/bootstrap.min.js"></script>
	
	<script type="text/javascript">
		
	</script>

</head>
<body>
<div class="content">
<%@include file="navbar.jsp" %>

<div class="row-fluid">

<div><h4><a href="<c:url value="/view_clients_admin"/>" >Client ></a> ${patient.displayName}</h4></div>

<table>
	<tr>
		<td colspan="2">
			<h2>${patient.displayName}<a href="<c:url value="/edit_patient/${patient.patientID}"/>">Edit</a></h2>
		</td>		
	</tr>
	<tr>
		<td>
			<label>&nbsp Date of birth:</label>&nbsp ${patient.bod}
		</td>
		<td>
			<label >&nbsp Gender:</label>&nbsp${patient.gender}
		</td>
	<tr>
		<td>
			<label >&nbsp Address :</label>&nbsp${patient.address}
		</td>
		<td>
			<label>&nbsp MRP:</label>&nbsp${patient.mrp}
		</td>
	</tr>
	<tr>
		<td>
			<label>&nbsp Phone #:</label>&nbsp${patient.homePhone}
		</td>
		<td>
			<label >&nbsp Clinic :</label>&nbsp${patient.clinicName}
		</td>
	</tr>
	<tr>
		<td>
			<label>&nbsp Email :</label>&nbsp${patient.email}
		</td>
		<td>
			<label>&nbsp MyOscar Verified :</label>&nbsp${patient.myOscarAuthentication}
	</tr>
	
</table>

		<table width="1020">
			<tr>
				<td width="600">
					<table>
						<tr>
							<td><label>&nbsp Alerts: </label></td>
						</tr>
						<tr>
							<td>&nbsp ${patient.alerts}</td>
						</tr>
					</table>	
				</td>
				<td>
					<table>
						<tr>
							<td><label>Assigned Volunteers:</label></td>
						</tr>
						<tr>
							<td>
								<select name="volunteer1"  id ="volunteer1">
									<c:forEach items="${volunteers}" var="v">
										<option value="${v.volunteerId}" <c:if test="${v.volunteerId eq selectedVolunteer1}">selected</c:if>>${v.displayName}</option>
									</c:forEach>						
								</select>
							</td>
						</tr>
						<tr>
							<td>
								 <select name="volunteer2"  id ="volunteer2">
									<c:forEach items="${volunteers}" var="v">
										<option value="${v.volunteerId}" <c:if test="${v.volunteerId eq selectedVolunteer2}">selected</c:if>>${v.displayName}</option>
									</c:forEach>						
								</select>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
 
<h2>Availability</h2>

	<table width="100%" border="1">
		<tr>
			<td width ="200" valign="top">
				<table>
					<tr><th>Monday</th></tr>
					<c:choose>
						<c:when test="${fn:contains(monAvailability, 'non')}">
							<tr><td>N/A</td></tr>		
						</c:when>
						<c:otherwise >
						    <c:forEach items="${monAvailability}" var="moA">	
						    	<tr><td align="center">${moA}</td></tr>		
						    </c:forEach>							
						</c:otherwise>
					</c:choose>						
				</table>
			</td>
			<td width ="200" valign="top">
				<table>
					<tr><th>Tuesday</th></tr>
					<c:choose>
						<c:when test="${fn:contains(tueAvailability, 'non') }">
							<tr><td>N/A</td></tr>		
						</c:when>
						<c:otherwise >
						    <c:forEach items="${tueAvailability}" var="tuA">	
						    	<tr><td align="center">${tuA}</td></tr>		
						    </c:forEach>							
						</c:otherwise>
					</c:choose>
				</table>
			</td>
			<td width ="200" valign="top">
				<table>
					<tr><th>Wednesday</th></tr>
					<c:choose>
						<c:when test="${fn:contains(wedAvailability, 'non') }">
							<tr><td>N/A</td></tr>		
						</c:when>
						<c:otherwise >
						    <c:forEach items="${wedAvailability}" var="weA">	
						    	<tr><td align="center">${weA}</td></tr>		
						    </c:forEach>							
						</c:otherwise>
					</c:choose>
				</table>
			</td>
			<td width ="200" valign="top">
				<table>
					<tr><th>Thursday</th></tr>
					<c:choose>
						<c:when test="${fn:contains(thuAvailability, 'non') }">
							<tr><td>N/A</td></tr>		
						</c:when>
						<c:otherwise >
						    <c:forEach items="${thuAvailability}" var="thA">	
						    	<tr><td align="center">${thA}</td></tr>		
						    </c:forEach>							
						</c:otherwise>
					</c:choose>
				</table>
			</td>
			<td width ="200" valign="top">
			
				<table>
					<tr><th>Friday</th></tr>		
					<c:choose>
						<c:when test="${fn:contains(friAvailability, 'non')}">
							<tr><td>N/A</td></tr>		
						</c:when>
						<c:otherwise >
						    <c:forEach items="${friAvailability}" var="frA">	
						    	<tr><td align="center">${frA}</td></tr>		
						    </c:forEach>							
						</c:otherwise>
					</c:choose>
				</table>
			</td>
		
		</tr>
		
	</table>

	<h2>Upcoming Visits</h2>
	<table  class="table table-stripe" width="970" border="1">
		<tr>
			
			<th width="500">Visit Date</th>
			
			<th>Assigned Volunteers</th>
			
		</tr>
		<c:forEach items="${upcomingVisits}" var="uVistits">
		
		<tr >
			<td>${uVistits.date}</td>			
			<td>${uVistits.volunteer},&nbsp &nbsp ${uVistits.partner}</td>
			
		</tr>
		</c:forEach>
	</table>
	<h2>Completed Visits</h2>
	<table  width="970" border="1">
		<tr>
			<th width="300">Visit #</th>
			<th width="300"> Visit Date</th>		
			<th>Assigned Volunteers</th>
			<th>Report</th>
		</tr>
		<c:forEach items="${completedVisits}" var="cVistits">
		<tr >
			<td>${cVistits.appointmentID}</td>
			<td>${cVistits.date}</td>			
			<td>${cVistits.volunteer},&nbsp &nbsp ${cVistits.partner}</td>
			<td><a href="<c:url value="/view_report/${patient.patientID}?appointmentId=${cVistits.appointmentID}"/>">DOWNLOAD</a> </td>
		</tr>
		</c:forEach>
	</table>
	
	<h2>Surveys <a href="">Assign Survey</a> </h2>
	<table  width="970" border="1">
		<tr>
			<th width="200">Assigned Surveys</th>
			<th width="250"> Date Started</th>		
			<th width="250">Last Edited</th>
			<th>Completed Status</th>
		</tr>
		<c:forEach items="${surveys}" var="s">
		<tr >
			<td>${s.surveyTitle}</td>
			<td>${s.startDate}</td>
			<td>${s.editDate}</td>
			<td>${s.strCompleted}</td>
		</tr>
		</c:forEach>
	</table>
	

<hr>

	
</div>


</div>

</body>
</html>