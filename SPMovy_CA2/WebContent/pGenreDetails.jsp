<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="dto.Genre, dto.Movie, service.DisplayService, java.util.ArrayList" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">

<jsp:include page="css/pBootstrapCSS_Icons.html"></jsp:include>


<title>Genre Details</title>
</head>
<body>
<%
	int genreID = Integer.parseInt(request.getParameter("genreID"));
	DisplayService display = new DisplayService();
	Genre genre = display.displayGenre(genreID);
	int numOfMovies = display.displayNumberOfMovieInGenre(genreID);
	ArrayList<Movie> movies = display.displayMoviesInGenre(genreID);
	display.close();
%>
<!-- Public Navigation Bar  -->
<jsp:include page="pNavBar.jsp"></jsp:include>

<!-- Genre Details Jumbotron -->
<div class="jumbotron jumbotron-fluid bg-white pb-1">
  <div class="container genreJumbo">
    <div class="row">
    	<div class="col-8">
    		<h1 class="display-4"><%= genre.getGenreName() %></h1>
    		<p class="lead"><%= numOfMovies %> Movies</p>
    	</div>
    	<div class="col-4 text-right pr-5">
    		<i class="fas fa-film genreIcon"></i>
    	</div>
    </div>
    <hr class="my-4">
    <p class="text-justify"><%= genre.getDescription() %></p>
  </div>
</div>

<!-- Cards for Movies in the Genre -->
<div class="container-fluid px-5">

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
						<a class="card-title card-link" href="pMovieDetails.jsp?movieID=<%=movie.getMovieID()%>"><%=movie.getMovieTitle()%></a>
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