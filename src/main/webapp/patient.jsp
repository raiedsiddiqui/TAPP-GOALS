<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
	<title>Tapestry</title>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<link href="${pageContext.request.contextPath}/resources/css/bootstrap.min.css" rel="stylesheet" />
		<link href="${pageContext.request.contextPath}/resources/css/bootstrap-responsive.min.css" rel="stylesheet" />  		
		<script src="${pageContext.request.contextPath}/resources/js/jquery-2.0.3.min.js"></script>
		<script src="${pageContext.request.contextPath}/resources/js/bootstrap.min.js"></script>
	<link href="${pageContext.request.contextPath}/resources/css/font-awesome.css" rel="stylesheet">

	<!-- CUSTOM CSS -->
	<link href="${pageContext.request.contextPath}/resources/css/breadcrumb.css" rel="stylesheet" />      
	<link href="${pageContext.request.contextPath}/resources/css/custom.css" rel="stylesheet" /> 

	  <link href='http://fonts.googleapis.com/css?family=Roboto+Slab' rel='stylesheet' type='text/css'>
	<!-- 	CUSTOM CSS END -->

	<script src="${pageContext.request.contextPath}/resources/js/bootstrap-lightbox.js"></script>

	<style type="text/css">
		html,body{
			height:100%;
		}
		.content{
			overflow-x:auto;
			overflow-y:auto;
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
	  <img id="logo" src="<c:url value="/resources/images/logo.png"/>" />
		<div class="navbar">
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
							<li><a href="<c:url value="/profile"/>">My Profile</a></li>
							<li><a href="<c:url value="/inbox"/>">Inbox <c:if test="${unread > 0}"> <span class="badge badge-info">${unread}</span> </c:if></a></li>
							<li><a href="<c:url value="/logout"/>">Log Out</a></li>
						</ul>
					</div>
				</div>	
			</div>
		</div>
	</div>
<!-- 	breadcrumb START-->	
	<div id="crumbs"> 
		<ul>
			<li> <a href="">My Clients</a> </li>
			<li><a href="">
				<c:choose>
						<c:when test="${not empty patient.preferredName}">
						<b>${patient.preferredName} (${patient.gender})</b>
						</c:when>
						<c:otherwise>
						<b>${patient.displayName} (${patient.gender})</b>
						</c:otherwise>
				</c:choose>
				</a>
			</li>
		</ul>	
	</div>
<!-- 	breadcrumb END-->	
	<div class="content">
		<div style="padding: 0px 15px;">
			<div class="row-fluid">
<!-- 				<div class="span3">
					<c:choose>
						<c:when test="${not empty patient.preferredName}">
							<h2>${patient.preferredName} (${patient.gender})</h2>
						</c:when>
						<c:otherwise>
							<h2>${patient.displayName} (${patient.gender})</h2>
						</c:otherwise>
					</c:choose>
				</div> -->
				<div class="span3 btn-group">
					<c:if test="${not empty patient.notes}">
						<a href="#modalNotes" class="btn btn-large btn-inverse" role="button" data-toggle="modal"><i class="icon-info-sign icon-white"></i></a>
					</c:if>
				</div>
			</div>
			<c:if test="${not empty completed}">
				<p class="alert alert-success">Completed survey: ${completed}</p>
			</c:if>
			<c:if test="${not empty inProgress}">
				<p class="alert alert-warning">Exited survery: ${inProgress}</p>
			</c:if>
			<div class="sheading">Active Surveys</div>
			<c:forEach items="${surveys}" var="s">
			<div class="row-fluid">
				<a href="<c:url value="/open_survey/${s.resultID}"/>" class="span12 btn btn-primary survey-list" style="height:50px; margin-bottom:10px;">
					<b>${s.surveyTitle}</b><br/>
					${s.description}
				</a>
			</div>
			</c:forEach>

			<div class="sheading">Completed Surveys</div>

		</div>
		<!--
		<div class="span8">
			<h2>Pictures</h2>
			<form id="uploadPic" action="<c:url value="/upload_picture_for_patient/${patient.patientID}" />" method="POST" enctype="multipart/form-data">
				<label>Upload picture</label>
  				<input form="uploadPic" type="file" name="pic" accept="image/*" required /><br/>
  				<input form="uploadPic" type="submit" value="Upload" />
			</form>
			<c:choose>
				<c:when test="${not empty pictures}">
					<ul class="thumbnails">
						<c:forEach items="${pictures}" var="pic">
							<li>
	    						<a href="#${fn:replace(pic.path, ".", "-")}" data-toggle="lightbox">
	      							<img class="thumbnail" src="<c:url value="/uploads/${pic.path}"/>"/>
	    						</a>
	    						<a href="<c:url value="/remove_picture/${pic.pictureID}"/>" class="btn btn-danger" style="width:92%;">Remove</a>
	    						<div id="${fn:replace(pic.path, ".", "-")}" class="lightbox hide fade" role="dialog" aria-hidden="true" tab-index="-1">
	    							<div class="lightbox-content">
	    								<img src="<c:url value="/uploads/${pic.path}"/>">
	    							</div>
	    						</div>
	  						</li>
						</c:forEach>
					</ul>
				</c:when>
				<c:otherwise>
					<p>No pictures uploaded</p>
				</c:otherwise>
			</c:choose>
		</div>
		-->
	</div>

	<div id="modalNotes" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="warnLabel" aria-hidden="true">
		<div class="modal-header">
   			<button type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
   			<h3 id="warnLabel" style="color:#000000;">
   				<c:choose>
					<c:when test="${not empty patient.preferredName}">
						${patient.preferredName}
					</c:when>
					<c:otherwise>
						${patient.displayName}
					</c:otherwise>
				</c:choose>
   			</h3>
  		</div>
  		<div class="modal-body">
  			<p class="text-warning">${patient.notes}</p>
  		</div>
  		<div class="modal-footer">
   			<button class="btn btn-primary" data-dismiss="modal" aria-hidden="true">Close</button>
  		</div>
	</div>
</body>
</html>
