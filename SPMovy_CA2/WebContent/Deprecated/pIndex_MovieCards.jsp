<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="dto.Movie, service.DisplayService, java.util.ArrayList" %>

<%
	DisplayService display = new DisplayService();
	ArrayList<Movie> movies = display.displayAllMovie();
	display.close();
%>

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

<%-- <!--- Cards -->
<div class="container-fluid">
	<div class="row">
	<% for(Movie movie : movies){
			if(movie.getStatus().equals("showing")){	
	%>
			<div class="col-md-4">
				<div class="card">
					<img class="card-img-top" src="RetrieveMovieImageServlet?movieID=<%=movie.getMovieID()%>" width="100%" height="100%">
					<div class="card-body">
						<a class="card-title card-link" href="#" ><%=movie.getMovieTitle()%></a>
						<p class="card-text">Duration: <%=movie.getDuration()%> minutes</p>
					</div>
				</div>
			</div>
	<%}	} %>
	</div>
</div> --%>