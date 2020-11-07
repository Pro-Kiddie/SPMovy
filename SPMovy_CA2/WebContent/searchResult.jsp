<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ page import="dto.Movie,dto.User,service.DisplayService,java.util.ArrayList" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link rel="stylesheet" href="css/SPMovy-Admin.css"/>
<!-- Contains all the bootstrap CSS and JS -->
<jsp:include page="css/BootstrapLinks.jsp"/>
<style>
#adminLink{
	color:#ffffff;
	}

</style>
</head>
<body>

<!--Navigation Bar -->
<jsp:include page="adminNavigationBar.jsp"/>

<h2 style="margin: 3% 0 3% 10%;"><span class="fa fa-search"></span> Search Results</h2>

<%
	User user = (User) session.getAttribute("user");
	if (user == null || !user.getRole().equals("admin")) {
		response.sendRedirect("error.html");
		// use return keyword to return _jspService()
		// prevent the Java code and HTML code below from being rendered 
		return;
	}
	
	String keyword = request.getParameter("keyword");
	DisplayService display = new DisplayService();
	ArrayList<Movie> movies = display.searchMovie(keyword);
	display.close();
	if(movies.size() == 0){
%>
		<div class="container">
		<h2 class="text-danger">No Record of Movie Found</h2>
		</div>
<%
	}
	
	else{%>
		<div class="container">
		<table class="table table-striped table-dark">
		  <thead>
		    <tr>			  
		      <th scope="col">Movie Name</th>
		      <th scope="col">Click To Manage Movies</th>
		    </tr>
		  </thead>
		  <tbody>
		  <% 	for(Movie movie : movies){
			  %>
			  
			  <tr>
			  		<td><%=movie.getMovieTitle() %></td>
			  		<td><a class="btn btn-light" href="movieDetails.jsp?movieID=<%=movie.getMovieID()%>" role="button"><span class="fa fa-gears"> Manage</span></a></td>
			  </tr>
			<%}%>  
		  </tbody>
		  </table>
		 </div>
		<%} %>
		
<jsp:include page="adminFooter.jsp"/>

<jsp:include page="js/BootstrapScriptLinks.jsp"/>

</body>
</html>