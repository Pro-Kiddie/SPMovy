<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="dto.Movie, service.DisplayService, java.util.ArrayList" %>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">

<jsp:include page="css/pBootstrapCSS_Icons.html"></jsp:include>

<title>SPMovy</title>
</head>
<body>

<%
	DisplayService display = new DisplayService();
	ArrayList<Movie> movies = display.displayAllMovie();
	display.close();
%>
<!-- Public Navigation Bar  -->
<jsp:include page="pNavBar.jsp"></jsp:include>

<!-- Image Slider -->
<div id="slides" class="carousel slide" data-ride="carousel">
	<ul class="carousel-indicators"> <!--The 3 rectangle toggle below to switch between pictures-->
		<li data-target="#slides" data-slide-to="0" class="active"></li>
		<li data-target="#slides" data-slide-to="1"></li>
		<li data-target="#slides" data-slide-to="2"></li>
	</ul>
	<div class="carousel-inner">
		<div class="carousel-item active">
			<img src="image/Avengers-Infinity-War-poster.jpg" width="100%" height="100%">
			<div class="carousel-caption d-none d-md-block">
				<h4>Marvel Studios' Avengers: Infinity War</h4> <!--Display Classes for differnt heading sizes. Total 4 (1 to 4)-->
				<p>The Avengers and their allies must be willing to sacrifice all in an attempt to defeat the powerful Thanos before his blitz of devastation and ruin puts an end to the universe</p>
			</div>
		</div>
		<div class="carousel-item">
			<img src="image/i-kill-giants.jpg" width="100%" height="100%">
			<div class="carousel-caption d-none d-md-block">
			<h4>I Kill Giants</h4> 
			<p>Barbara Thorson (Madison Wolfe) is a teenage girl who escapes the realities of school and a troubled family life by retreating into her magical world of fighting evil giants.</p>
			</div>
		</div>
		<div class="carousel-item">
			<img src="image/sakura.jpg" width="100%" height="100%">
			<div class="carousel-caption d-none d-md-block">
			<h4>Sakura Guardian In The North</h4> 
			<p>Spring of 1945, cherry blossoms flower in southern Sakhalin, a symbol of hope for Tetsu Ezure and her family.</p>
			</div>
		</div>
	</div>
</div>

<!-- Movie Cards -->
<div class="container-fluid my-4">

  <ul class="nav nav-tabs">
    <li class="nav-item"><a class="nav-link text-dark" data-toggle="pill" href="#showing">Showing</a></li>
    <li class="nav-item"><a class="nav-link text-dark" data-toggle="pill" href="#coming">Coming Soon</a></li>
    <li class="nav-item"><a class="nav-link text-dark" data-toggle="pill" href="#over">Over</a></li>
  </ul>
  
  <div class="tab-content">
    <div id="showing" class="tab-pane fade show active">
		<div class="row px-2">
	<% for(Movie movie : movies){
			if(movie.getStatus().equals("showing")){	
	%>
			<div class="col-md-4">
				<div class="card">
					<img class="card-img-top" src="RetrieveMovieImageServlet?movieID=<%=movie.getMovieID()%>" width="100%" height="100%">
					<div class="card-body text-truncate">
						<a class="card-title card-link" href="pMovieDetails.jsp?movieID=<%=movie.getMovieID()%>" ><%=movie.getMovieTitle()%></a>
						<p class="card-text">Duration: <%=movie.getDuration()%> minutes</p>
					</div>
				</div>
			</div>
	<%}	} %>
		</div>
    </div>
    
    <div id="coming" class="tab-pane fade">
      <div class="row px-2">
	<% for(Movie movie : movies){
			if(movie.getStatus().equals("coming")){	
	%>
			<div class="col-md-4">
				<div class="card">
					<img class="card-img-top" src="RetrieveMovieImageServlet?movieID=<%=movie.getMovieID()%>" width="100%" height="100%">
					<div class="card-body text-truncate">
						<a class="card-title card-link" href="pMovieDetails.jsp?movieID=<%=movie.getMovieID()%>" ><%=movie.getMovieTitle()%></a>
						<p class="card-text">Duration: <%=movie.getDuration()%> minutes</p>
					</div>
				</div>
			</div>
	<%}	} %>
		</div>
    </div>
    
    <div id="over" class="tab-pane fade">
      <div class="row px-2">
	<% for(Movie movie : movies){
			if(movie.getStatus().equals("over")){	
	%>
			<div class="col-md-4">
				<div class="card">
					<img class="card-img-top" src="RetrieveMovieImageServlet?movieID=<%=movie.getMovieID()%>" width="100%" height="100%">
					<div class="card-body text-truncate">
						<a class="card-title card-link" href="pMovieDetails.jsp?movieID=<%=movie.getMovieID()%>" ><%=movie.getMovieTitle()%></a>
						<p class="card-text">Duration: <%=movie.getDuration()%> minutes</p>
					</div>
				</div>
			</div>
	<%}	} %>
		</div>
    </div>
  </div>
</div>

<!-- Footer -->
<jsp:include page="pFooter.html"></jsp:include>

<jsp:include page="js/pBootstrapScripts.html"></jsp:include>

</body>
</html>