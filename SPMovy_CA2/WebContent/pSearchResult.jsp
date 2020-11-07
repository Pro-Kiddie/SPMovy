<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="dto.Movie, service.DisplayService, java.util.ArrayList" %>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">

<jsp:include page="css/pBootstrapCSS_Icons.html"></jsp:include>

<title>Search Result</title>
</head>
<body>

<%
	ArrayList<Movie> movies = (ArrayList<Movie>)request.getAttribute("result");
	if (movies == null){
		response.sendRedirect("error.html");
	}
%>
<!-- Public Navigation Bar  -->
<jsp:include page="pNavBar.jsp"></jsp:include>

<div class="container-fluid">
	<div class="row px-5">
	<div class="col-12">
		<h1 class="px-4 mt-4 text-center text-muted">Search Results</h1>
		<hr class="mb-4">
	</div>
		
	<% 
		if(movies.size() > 0){
			for(Movie movie : movies){
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
	<%}}else{%>
			<div class="jumbotron col-12 bg-white">
				<h1 class="text-center text-danger">No Record Found</h1>
			</div>
	<%} %>
	</div>
</div>


<!-- Footer -->
<jsp:include page="pFooter.html"></jsp:include>

<jsp:include page="js/pBootstrapScripts.html"></jsp:include>
</body>
</html>