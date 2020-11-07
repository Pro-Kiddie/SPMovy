<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="dto.Genre,dto.User,service.ManageService" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<%
User user = (User) session.getAttribute("user");
if (user == null || !user.getRole().equals("admin")) {
	response.sendRedirect("error.html");
	// use return keyword to return _jspService()
	// prevent the Java code and HTML code below from being rendered 
	return;
}
%>
<jsp:useBean id="genre" class="dto.Genre" scope="request">
	<jsp:setProperty name="genre" property="*"/>
</jsp:useBean>

<%
	ManageService manage = new ManageService();
	try{
		int genreID = manage.addGenre(genre); //returns 0 if Genre not created successfully
		//Only add Movies to the Genre after sucessfully added the Genre
		//First retrieve movies from the movies parameter
		String [] movieIDs = request.getParameterValues("movies"); //["movieID1", "movieID2" ...]
		//if Admin never select any movie, moiveIDs will be null
		if(movieIDs != null){
			for(String movieID : movieIDs){
			manage.addMovieToGenre(Integer.parseInt(movieID), genreID);
			//no need to check whether movies successfully added to genre
			//definitely will be successful as the genre is newly created
			}
		}
		//redirect back to admin page after adding
		response.sendRedirect("admin.jsp");
	}catch(com.mysql.jdbc.exceptions.jdbc4.MySQLIntegrityConstraintViolationException ex){
		//trying to add a genre with the same name as a genre that is already in the database
		//Since genreName is set to be UNIQUE in database
		//redirect back to admin.jsp
		response.sendRedirect("admin.jsp?genreExist=true");
	}catch(Exception e){
		//something went wrong, most likely cannot connect to database
		e.printStackTrace();
		response.sendRedirect("error.html");
	}finally{
		manage.close();
	}
%>
</body>
</html>