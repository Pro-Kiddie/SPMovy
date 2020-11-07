<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="dto.User,dto.Movie,dto.Genre, dto.Schedule,service.DisplayService,service.ManageService,java.util.ArrayList,java.time.LocalDate, java.sql.Date" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">

<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<link rel="stylesheet" href="/resources/demos/style.css">
</head>
<body>

<%
	//User user = (User)session.getAttribute("user"); 
	//if (user == null || !user.getRole().equals("admin")){
		//response.sendRedirect("error.html");
		//return;
	//}
	
	int movieID = Integer.parseInt(request.getParameter("movieID"));
	DisplayService display = new DisplayService();
	//retrieve the genres that this movie fall under
	ArrayList<Genre> genresOfMovie = display.displayGenresOfMovie(movieID);
	//retrieve the genres that this movie DOES NOT belong to
	ArrayList<Genre> notGenresOfMovie = display.displayNotGenresOfMovie(movieID);
	LocalDate now = LocalDate.now();
	ArrayList<Schedule> schedules = display.displaySchedulesAfterToday(movieID, Date.valueOf(now));
	Movie movie = display.displayMovie(movieID);
	display.close();
%>

<!-- Modal for Uploading Image-->

<div class="modal fade" id="UploadImage" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header PopUpHeader">
        <h5 class="modal-title" id="exampleModalLabel">Upload Movie Image</h5>
        <button type="button" class="close" onclick="location.href='movieDetails.jsp?movieID=<%=Integer.toString(movieID)%>'" aria-label="Close">
			          <span aria-hidden="true">&times;</span>
			        </button>
      </div>
      
      <form action="UploadImageServlet" method="post" enctype="multipart/form-data">
      <div class="modal-body PopUpBody">
		  
		    		    
		    <div class="form-group">	    
			    <input type="file" name="image" required><br>
			    <input type="hidden" name="movieID" value="<%=movieID%>">	
		    </div>
		</div>
            <div class="modal-footer PopUpFooter">
		  	   <button class="btn btn-info" type="submit" value="Upload">Upload</button>
            </div>
		  	</form>
		</div>
      </div>
    </div>
  


<!-- Modal for Updating Genres Of Movie-->
<div class="modal fade" id="UpdateGenresOfMovie" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header PopUpHeader">
        <h5 class="modal-title" id="exampleModalLabel">Manage Genres assigned to this movie</h5>
         <button type="button" class="close" onclick="location.href='movieDetails.jsp?movieID=<%=Integer.toString(movieID)%>'" aria-label="Close">
			          <span aria-hidden="true">&times;</span>
			        </button>

      </div>
      <div class="modal-body PopUpBody">
       	<div class="card border-dark mb-3">
  			<div class="card-header"><h3>Delete Genres of <%=movie.getMovieTitle() %></h3></div>
  				<div class="card-body text-dark">
    		
    			<%
					for(Genre genre : genresOfMovie){
				%>
				
                    	
					<form action="DeleteGenre_MovieServlet">
						
						
						<input type="hidden" name="genreID" value="<%= genre.getGenreID()%>">
						<input type="hidden" name="movieID" value="<%= movieID%>">
						<input type="hidden" name="fromMoviePage">
						
						
						<button type="submit" class="btn btn-secondary todeleteOrAddGenre" value="Delete"><span class="fa fa-times-circle"></span> <%= genre.getGenreName()%></button>
					</form>
					<%} %>
					
		
    			
 			 </div>
		</div>
		
		<div class="card border-dark mb-3">
  			<div class="card-header"><h3>Add Genres to <%=movie.getMovieTitle() %></h3></div>
  				<div class="card-body text-dark">
    		
    			<%
					for(Genre genre : notGenresOfMovie){
				%>
				
				
				<form action="AddGenre_MovieServlet">
					<input type="hidden" name="genreID" value="<%= genre.getGenreID()%>">
					<input type="hidden" name="movieID" value="<%= movieID%>">
					<input type="hidden" name="fromMoviePage">
					
					<button type="submit" class="btn btn-info todeleteOrAddGenre"  value="Add"><span class="fa fa-plus-circle"></span> <%= genre.getGenreName()%></button>
				</form>
				<%} %>
    			
 			 </div>
		</div>
    </div>
  </div>
</div>
</div>


<!-- Modal for Deleting Movie-->

<div class="modal fade" id="DeleteMovie" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" >
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
      <div class="modal-header PopUpHeader">
      <h5 class="modal-title" id="exampleModalLabel">Deleting <%= movie.getMovieTitle() %></h5>
        
         <button type="button" class="close" onclick="location.href='movieDetails.jsp?movieID=<%=Integer.toString(movieID)%>'">
			          <span>&times;</span>
			        </button>
      </div>
      <div class="modal-body PopUpBody">
		  <p>Movie Status: <span class="text-danger text-uppercase font-weight-bold"><%= movie.getStatus() %></span></p>
		  <p>The Movie has Schedules on <b class="text-danger">Today or After:</b> 
		   <%
			if (schedules.size() == 0) out.print("None</p>");
			else {
				out.print("</p>");
		 	%>
		 		<table class="table table-hover table-dark">
	  				<thead>
	  					<tr>
	  						<th scope="col">Date</th>
	  						<th scope="col">Show Time</th>
	  					</tr>
	  				</thead>
	  			<tbody>
	  		<%	
				ArrayList<Integer> rowSpans = DisplayService.getRowSpans(schedules);
				String previousDate = schedules.get(0).getDate();
				int i = 0, k = 0;
				for(Schedule schedule : schedules){
			%>
			
				<tr class="schedule">
			<%
				if (i == 0){
					//first schedule -> date confirm equal to previous date
					//print out previous date as header
					//only for first schedule
					out.print("<th class='schedule' rowspan='" + rowSpans.get(k++) + "'>" + previousDate + "</th>");
					i++;
				}
				else if(!schedule.getDate().equals(previousDate)){
					//put the new date as a <th> with its row span
					out.print("<th class='schedule' rowspan='" + rowSpans.get(k++) + "'>" + schedule.getDate() + "</th>");
					previousDate = schedule.getDate();
				}
			%>
			<td class="schedule"><%= schedule.getTimeslot() %></td>
		</tr>		
			<%}%>
			</tbody>
			</table>
	<%}
		%>
		</div>
		<div class="modal-footer PopUpFooter">
		<form action="DeleteMovieServlet">
			<input type="hidden" name="movieID" value="<%= movie.getMovieID() %>" />
			<button type="submit" name="confirmation" value="Yes" class="btn btn-info">Yes</button>
			<button type="submit" name="confirmation" value="No" class="btn btn-secondary">No</button>
		</form>
        
        
      </div>
      </div>
    </div>
  </div>


<!-- Modal for Updating Movie-->
<div class="modal fade" id="UpdateMovie" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header PopUpHeader">
        <h5 class="modal-title" id="exampleModalLabel">Basic Information</h5>
         <button type="button" class="close" data-dismiss="modal" aria-label="Close">
			          <span aria-hidden="true">&times;</span>
			        </button>
      </div>
      
      <form action="addMovieServlet">
        <div class="modal-body PopUpBody">
       	
		    
		    
		    <div class="form-group">	    
			   <label for="formGroupExampleInput">Movie Title:</label>
    		   <input type="text" class="form-control" id="formGroupExampleInput" name="movieTitle" value="<%= movie.getMovieTitle()%>" required/>	
		    </div>
            
		    <div class="form-group">	    
			   <label for="formGroupExampleInput">Actor List:</label>
    		   <input type="text" class="form-control" id="formGroupExampleInput" name="actorList" value="<%= movie.getActorList()%>" required/>	
		       <small  class="form-text text-danger">Separate by comma</small>
		    </div>
            
		    <div class="form-group">	    
			   <label for="ReleaseDate">ReleaseDate:</label>
    		   <input type="text" class="datepicker form-control" id="ReleaseDate" name="releaseDate" value="<%=ManageService.convertUpdateMovieDate(movie.getReleaseDate())%>" required/>	
		    </div>
            
		    <div class="form-group">	    
			   <label for="formGroupExampleInput">Synopsis:</label>
    		   <textarea class="form-control" id="exampleFormControlTextarea1" rows="8" name="synopsis" required><%=movie.getSynopsis()%></textarea>	
		    </div>
            
		    <div class="form-group row" id="rowFormgroup">	    
			   <label for="formGroupExampleInput">Duration:</label>
    		   <input type="number" class="form-control" id="minuteInput" name="duration" value="<%=movie.getDuration() %>" required/>
		       <label for="formGroupExampleInput">minutes</label>
		    </div>
            
		     <div class="form-group">	    
			   <label for="formGroupExampleInput">Status:</label>
			 	<select class="form-control" name="status">
    		   		<option value="showing" <% if(movie.getStatus().equals("showing")) out.print("selected"); %>>Showing</option>
					<option value="coming" <% if(movie.getStatus().equals("coming")) out.print("selected"); %>>Coming Soon</option>
					<option value="over" <% if(movie.getStatus().equals("over")) out.print("selected"); %>>Over</option>
			 	</select>	
		    </div>
		    </div>
            <div class="modal-footer PopUpFooter">
		    <input type="hidden" name="movieID" value="<%=movieID%>">
		  	<button class="btn btn-info" type="submit" value="Update">Update</button>
            </div>
		  	</form>
		</div>
      </div>
    </div> 
    
    <!-- Modal for Deleting Movie's image -->
 <div class="modal fade" id="WarningImage" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header PopUpHeader">
       <h5 class="modal-title" id="exampleModalLabel"><span class="fa fa-warning text-danger"></span> Delete Movie's image</h5>
      	 <button type="button" class="close" onclick="location.href='movieDetails.jsp?movieID=<%=movieID%>'" aria-label="Close">
			          <span aria-hidden="true">&times;</span>
		 </button>
      </div>
      <div class="modal-body PopUpBody">
       	You are about to delete <i><%=movie.getMovieTitle()%></i>'s image.<br/>Are you sure
       	you want to proceed?
      </div>
      <div class="modal-footer PopUpFooter">
      	<form action="DeleteImageServlet">
      	<button type="submit" name="movieID" value="<%=movie.getMovieID() %>" class="btn btn-info">Yes</button>
      	<a href="movieDetails.jsp?movieID=<%=movieID %>" class="btn btn-secondary">No</a>
      	</form>
      </div>
    </div>
  </div>
</div>
 
<%-- <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script>
	$( function() {
   		 $( ".datepicker" ).datepicker();
	} );

	function actorListWrongFormat() {
   	 alert("Please separate each Actor/Actress by a comma!");
	}
</script>
<script>
	function movieShowing() {
   	 alert("You are deleting a movie that is Showing!");
	}
</script>
<%
	if(movie.getStatus().equals("showing")){
		out.println("<script> movieShowing(); </script>");
	}
%>
<%
	if(request.getParameter("actorListFormatError") != null){
		out.println("<script> actorListWrongFormat(); </script>");
	}
%>
 --%>
</body>
</html>