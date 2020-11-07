<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
 <%@ page import="dto.User,dto.Movie,dto.Genre,service.DisplayService,java.util.ArrayList,java.util.List,java.util.Arrays" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Movie Details</title>
 <link rel="stylesheet" href="css/SPMovy-Admin.css"/>
 <link href="Bootstrap/css/2-col-portfolio.css" rel="stylesheet">
 
 <!-- Contains all the bootstrap CSS and JS -->
<jsp:include page="css/BootstrapLinks.jsp"></jsp:include>

<style>
.PopUpHeader{
	 background: linear-gradient(#e5e5e5, #c5cfe0);
}
.PopUpBody{
	background-color:#e3e5e8;
	
} 
.PopUpFooter{
	background: linear-gradient(#c5cfe0,#e5e5e5);
	
}
#adminLink{
	color:#ffffff;
}

	.btn{
		margin-top:1%;
	}

</style>
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
	
	int movieID = Integer.parseInt(request.getParameter("movieID"));
	//int movieID = 4;
	DisplayService display = new DisplayService();
	//Retrieve Movie's details
	Movie movie = display.displayMovie(movieID);
	//Retrieve Genre's which movie fall under
	ArrayList<Genre> genres = display.displayGenresOfMovie(movieID);
	display.close();
	
	List <String> Actors = Arrays.asList(movie.getActorList().split(","));
%>
<!--Navigation Bar -->
<jsp:include page="adminNavigationBar.jsp"/>



<div class="container" id="movieDetailsContainer">

     

      <!-- Portfolio Item Row -->
      <div class="row">

        <div class="col-md-6">
          <img class="img-fluid" src="RetrieveMovieImageServlet?movieID=<%=movieID%>" alt="">
          
        </div>

        <div class="col-md-6">
          <h3 class="my-3"><%=movie.getMovieTitle() %></h3>
          <p class="text-justify"><%=movie.getSynopsis()%></p>
          <h3 class="my-3">Genres</h3>
          <ul>
          		<%if(genres.size() == 0) out.print("None <br>");
    			else{
    				for(int i = 0; i < genres.size(); i++){
    					if(i == 0){%>
    						<li><%=genres.get(i).getGenreName()%></li>
    					
    					<%}/*end-if*/
    					else{%>
    						<li><%=genres.get(i).getGenreName()%></li>
    					<%} /*end-else*/%>
    				<%}/*for-end*/%>
    			<%}/*else-end*/%>
          </ul>
          <h3 class="my-3">Actors / Actresses</h3>
          <ul>
          <%for(String actor : Actors){%>
            <li><%=actor%></li>
           <%}%>
          </ul>
          <h4 class="my-3">Release Date: <small><%=movie.getReleaseDate() %></small></h4>
          <h4 class="my-3">Duration: <small><%=movie.getDuration() %> minutes</small></h4>
          <h4 class="my-3">Status: <small><%=movie.getStatus() %></small></h4>
          <h3 class="my-3">Settings</h3>
          
          <button type="button" class="btn btn-info btn-sm" data-toggle="modal" data-target="#UpdateMovie"><span class="fa fa-film"></span> Update Movie</button>
          <button type="button" class="btn btn-info btn-sm" data-toggle="modal" data-target="#UploadImage"><span class="fa fa-cloud-upload"></span> Upload Image</button>
          <a class="btn btn-info btn-sm" href="manageMovieSchedule.jsp?movieID=<%=movieID%>" role="button"><span class="fa fa-calendar"></span> Manage Schedule</a>
          <button type="button" class="btn btn-info btn-sm" data-toggle="modal" data-target="#UpdateGenresOfMovie" id="clickManageGenre"><span class="fa fa-wrench"></span> Manage Genre</button>
          <a class="btn btn-info btn-sm" href="manageMovieReviews.jsp?movieID=<%=movieID%>" role="button"><span class="fa fa-wrench"></span> Manage Reviews</a>
          <button type="button" class="btn btn-info btn-sm py-2" data-toggle="modal" data-target="#WarningImage"><span class="fa fa-cloud-upload">Delete Image</button>
          <button type="button" class="btn btn-info btn-sm" data-toggle="modal" data-target="#DeleteMovie"><span class="fa fa-film"></span>  Delete Movie</button>
        </div>
	
      </div>
      
      
</div>
<jsp:include page="adminFooter.jsp"/>
<jsp:include page="PopUps_Movie.jsp"/>

<jsp:include page="js/BootstrapScriptLinks.jsp"></jsp:include>

<script>
	function updateSuccessful() {
   	 alert("Updated Movie Details Successfully!");
	}
	function clickManageGenre(){
		$("#clickManageGenre").trigger("click");
	}

	function actorListWrongFormat() {
  	 alert("Please separate each Actor/Actress by a comma!");
	} 
	$( function() {
   		 $("#ReleaseDate").datepicker();
	} );

</script>
<%
	if(request.getParameter("updateSuccessful") != null){
		out.println("<script> updateSuccessful(); </script>");
	}
	
	if(request.getParameter("clickManageGenre") != null){
		out.println("<script> clickManageGenre(); </script>");
	}
	if(request.getParameter("actorListFormatError") != null){
		out.println("<script> actorListWrongFormat(); </script>");
	}
	
%>
</body>
</html>