<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="dto.User,dto.Movie,service.DisplayService,java.util.ArrayList" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Add Movies to the Genre</title>
</head>
<body>
<%
	//Verify it is admin visting the page first
	//User user = (User)session.getAttribute("user"); 
	//if (user == null || !user.getRole().equals("admin")){
		//response.sendRedirect("error.html");
		//return;
	//}
	
	//Retrieve the genreID
	String genreID = request.getParameter("genreID");
	String genreName = request.getParameter("genreName");

	//Display all the movies in the database THAT ARE NOT IN THIS GENRE
	DisplayService display = new DisplayService();
	ArrayList<Movie> movies = display.displayMoviesNotInGenre(Integer.parseInt(genreID));
%>
<h1>Please select movies that are in <%=genreName%>: </h1>
<form action="">
<%	
	for(Movie movie : movies){
%>
	<input type="checkbox" name="movies" value="<%=movie.getMovieID()%>"> <%=movie.getMovieTitle()%><br>
	<%} %>
	<input type="submit" value="Submit">
</form>
</body>
</html>