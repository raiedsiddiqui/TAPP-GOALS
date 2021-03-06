<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Tapestry Volunteer Add Plans for Appointment</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="icon" href="${pageContext.request.contextPath}/resources/images/favicon.ico" type="image/x-icon" />
		<link rel="shortcut icon" href="${pageContext.request.contextPath}/resources/images/favicon.ico" type="image/x-icon" />

		<link href="${pageContext.request.contextPath}/resources/css/bootstrap.min.css" rel="stylesheet" />
		<link href="${pageContext.request.contextPath}/resources/css/bootstrap-responsive.min.css" rel="stylesheet" />  		
		<link href="${pageContext.request.contextPath}/resources/css/font-awesome.css" rel="stylesheet">
		<link href="${pageContext.request.contextPath}/resources/css/bootstrap-datetimepicker.min.css" rel="stylesheet" />

		<script src="${pageContext.request.contextPath}/resources/js/jquery-2.0.3.min.js"></script>
		<script src="${pageContext.request.contextPath}/resources/js/bootstrap.min.js"></script>
		<script src="${pageContext.request.contextPath}/resources/js/bootstrap-datetimepicker.min.js"></script>
		<script src="${pageContext.request.contextPath}/resources/js/bootstrap-lightbox.js"></script>
		
		<!-- CUSTOM CSS -->
	<link href="${pageContext.request.contextPath}/resources/css/breadcrumb.css" rel="stylesheet" /> 
	<link href="${pageContext.request.contextPath}/resources/css/custom.css" rel="stylesheet" /> 
     

	  <link href='http://fonts.googleapis.com/css?family=Roboto+Slab' rel='stylesheet' type='text/css'>
	<!-- 	CUSTOM CSS END -->
		
		<style type="text/css">
		html,body{
			height:100%;
		}
		.content{
/*			overflow-x:auto;
		overflow-y:auto;*/	
			border-radius:5px;
			-moz-border-radius:5px;
			-webkit-border-radius:5px;
			-o-border-radius:5px;
			-ms-border-radius:5px;

		}
		.content a{
			color:#ffffff;
		}
		textarea{
			width:90%;
			margin-right:10px;
		}
		.modal-backdrop{
			z-index:0;
		}
		
		.lightbox{
			z-index:1;
		}
		.thumbnail{
			width:320px;
		}
		
	</style>
		
</head>
<body>
<div id="headerholder">	
<%@include file="subNavi.jsp" %>
</div>
<!-- 	breadcrumb START-->	
	<div id="crumbs"> 
		<ul>
			<li> <a href="<c:url value="/"/>">Appointments</a> </li>
			<li><a href="<c:url value="/?patientId=${patient.patientID}"/>">
				<c:choose>
					<c:when test="${not empty patient.preferredName}">
						<b>${patient.preferredName} (${patient.gender})</b>
					</c:when>
					<c:otherwise>
						<b>${patient.firstName}  ${patient.lastName}(${patient.gender})</b>
					</c:otherwise>
				</c:choose>
				</a>
			</li>
			<li><a href="">${appointment.date}</a></li>
			<li><a href=""><b>Plan</b></a></li>
		</ul>
<!-- Message display 
	<div id="visitandbook" class="span12 btn-group">
			<c:if test="${not empty patient.notes}">
				<a href="#modalNotes" class="btn btn-large btn-inverse lgbtn" role="button" data-toggle="modal"><i class="icon-info-sign icon-white"></i></a>
			</c:if>
			<c:if test="${not empty appointment}">
				<a href="<c:url value="/visit_complete/${appointment.appointmentID}"/>" role="button" class="btn btn-primary pull-right lgbtn">Visit Complete</a>
			</c:if>
			<a href="" role="button" class="btn btn-primary pull-right lgbtn" >Submit</a>
	</div>	
	-->
	</div>
	
	<form id="plansfrm" action="<c:url value="/savePlans"/>" method="post">
<h2>                                                                  <button type="submit">Submit</button></h2><a href="<c:url value="/open_alerts_keyObservations_plan/${appointment.appointmentID}"/>" class="btn btn-primary" >Cancel</a><br/>
<label>1 &nbsp &nbsp  </label>
	<select name="plan1" form="plansfrm">
		<c:forEach items="${plans}" var="p">							
			<option value="${p}" >${p}</option>
		</c:forEach>
	</select><br/>
<label>2 &nbsp &nbsp  </label>
	<select name="plan2" form="plansfrm">
		<c:forEach items="${plans}" var="p">							
			<option value="${p}" >${p}</option>
		</c:forEach>
	</select><br/>
<label>3  &nbsp &nbsp </label>
	<select name="plan3" form="plansfrm">
		<c:forEach items="${plans}" var="p">							
			<option value="${p}" >${p}</option>
		</c:forEach>
	</select><br/>
<label>4  &nbsp &nbsp </label>
	<select name="plan4" form="plansfrm">
		<c:forEach items="${plans}" var="p">							
			<option value="${p}" >${p}</option>
		</c:forEach>
	</select><br/>
<label>5  &nbsp &nbsp </label>
	<select name="plan5" form="plansfrm">
		<c:forEach items="${plans}" var="p">							
			<option value="${p}" >${p}</option>
		</c:forEach>
	</select><br/>
&nbsp &nbsp &nbsp	<label>Specify :   </label><br/>
<label>6 &nbsp &nbsp  </label>
<input type="textarea" class="form-control" rows="8" cols="50" name="planSpecify"/><br/>
	
</form>
</body>
</html>