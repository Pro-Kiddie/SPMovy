<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="dto.Genre, dto.Movie, dto.Schedule, dto.Review, dto.Cinema, service.DisplayService, java.util.ArrayList" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">

<jsp:include page="css/pBootstrapCSS_Icons.html"></jsp:include>
<link rel="stylesheet" type="text/css" href="css/wan-spinner.css">

<title>Movie Details</title>
</head>
<body>
<%
	int movieID = Integer.parseInt(request.getParameter("movieID"));
	DisplayService display = new DisplayService();
	Movie movie = display.displayMovie(movieID);
	
	String rating = DisplayService.convertRatingToStars(display.displayMovieRating(movieID));
	
	ArrayList<Genre> genres = display.displayGenresOfMovie(movieID);
	ArrayList<Cinema> cinemas = display.displayAllCinema();
	ArrayList<Review> reviews = display.displayReviewsOfMovie(movieID);
%>
<!-- Public Navigation Bar  -->
<jsp:include page="pNavBar.jsp"></jsp:include>

<!-- Movie Details Section  -->
<div class="container-fluid">
	<div class="row">
		<div class="col-lg-5 col-xl-3 text-center">
			<img src="RetrieveMovieImageServlet?movieID=<%=movieID%>" class="img-fluid rounded">
		</div>
		<div class="col-lg-7 col-xl-9 jumbotron bg-white pt-4" style="padding-right: 2rem;">
			<h1><%=movie.getMovieTitle()%></h1>
			<hr class="mb-3">
			<p><b>Cast:</b> <br><%= movie.getActorList() %></p>
			<div class="container row">
				<div class="col-4 p-0">
					<p><b>Release Date:</b> <br><%= movie.getReleaseDate() %></p>
				</div>
				<div class="col-4 p-0">
					<p><b>Duration: </b><br><%= movie.getDuration() %> Minutes</p>
				</div>
				<div class="col-4 p-0">
					<p><b>Genre(s): </b><br><% for(int i = 0; i < genres.size(); i++){
										if(i == (genres.size() - 1)) out.print(genres.get(i).getGenreName());
										else out.print(genres.get(i).getGenreName() + " / ");
									}%>
					</p>
				</div>
			</div>
			
			<hr class="mb-3">
			<p><b>Synopsis:</b><br><%= movie.getSynopsis() %></p>
			<hr class="mb-3">
			<div class="container row">
				<div class="col-7">
					<p class="pt-3 ratingText"><b>Rating:</b>
					<%=rating%>
					</p>
				</div>
				<div class="col-5 text-right">
					<button type="button" class="btn btn-info btn-lg mt-2" data-toggle="modal" data-target="#addReview">Write Review</button>
				</div>
			</div>
		</div>
	</div>
</div>

<!-- Add Review Form Modal-->
<form action="AddReviewServlet" id="addReviewForm">
<div class="modal fade" id="addReview" tabindex="-1" role="dialog">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">Add Review</h5>
        <button type="button" class="close" onclick="location.href='pMovieDetails.jsp?movieID=<%=movieID%>'" data-dismiss="modal">
          <span>&times;</span>
        </button>
      </div>
      <div class="modal-body">
        
		  <div class="form-group">
		      <label for="name">Name</label>
		      <input type="text" class="form-control" id="name" name="name" placeholder="Enter name" required>
		  </div>
		  <div class="form-group">
		   	  <label for="rating">Rating</label><br>
		      <!-- <input type="text" class="form-control" id="rating" name="rating" required> -->
		      <div class="wan-spinner">
				<a href="javascript:void(0)" class="minus">-</a>
				<input type="text" name="rating" id="rating" value="5" required>
				<a href="javascript:void(0)" class="plus">+</a>
			  </div>
		  </div>
		  <div class="form-group">
			  <label for="comments">Comments</label>
			  <textarea class="form-control" id="comments" name="comments" rows="3" required></textarea>
		  </div>
		  <input type="hidden" name="movieID" value="<%=movieID%>"/>
		
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" onclick="location.href='pMovieDetails.jsp?movieID=<%=movieID%>'" data-dismiss="modal">Close</button>
        <input type="submit" class="btn btn-primary" form="addReviewForm" value="Submit">
        
      </div>
    </div>
  </div>
</div>
</form>

<!-- Movie Schedule Section  -->
<div class="container-fluid my-4">

  <ul class="nav nav-tabs" role="tablist">
  <%
  	for (int i=0; i < cinemas.size(); i++){
  		Cinema cinema = cinemas.get(i);
  %>
    <li class="nav-item">
    	<a class='nav-link <%= i==0 ? "active" : "" %> text-dark' data-toggle="tab" href="#cinema<%= cinema.getCinemaID()%>" role="tab"><%= cinema.getCinemaName() %></a>
    </li>
  <%} %>
  </ul>
 
  <div class="tab-content">
  <%
  	for (int i=0; i < cinemas.size(); i++){
  		Cinema cinema = cinemas.get(i);
  		ArrayList<Schedule> schedules = display.displaySchedulesOfMovie(movieID, cinema.getCinemaID());
  %>
    <div id="cinema<%=cinema.getCinemaID() %>" class='tab-pane fade<%= i==0 ? " show active" : "" %>' role="tabpanel">
    	<% 
    		if(schedules.size() != 0){
   				Schedule first = schedules.get(0);
   				String prevDay = first.getDate();
   				out.println("<div class='row px-3'>");
   				out.println("<h5 class='col-12 pb-0 date'>" + first.getDate() + "</h5>");
    			for(Schedule schedule : schedules){
    				if(schedule.getDate().equals(prevDay)){
    					//same day
    					out.println("<a class='btn btn-outline-dark ml-3 px-4" + (schedule.getTickets()==0 ? " disabled'" : "'") + " href='BookingVerificationServlet?scheduleID="+ schedule.getScheduleID() + "&movieID=" + schedule.getMovieID() + "' data-toggle='tooltip' data-placement='bottom' title='" + schedule.getTickets() + " Tickets Left'>" +schedule.getTimeslot() + "</a>" );
    				}else{
    					//different day
    					//close up the div row first
    					out.println("</div>");
    					//start a new row
    					out.println("<div class='row px-3'>");
    					out.println("<h5 class='col-12 pb-0 date'>" + schedule.getDate() + "</h5>");
    					out.println("<a class='btn btn-outline-dark ml-3 px-4" + (schedule.getTickets()==0 ? " disabled'" : "'") + " href='BookingVerificationServlet?scheduleID="+ schedule.getScheduleID() + "&movieID=" + schedule.getMovieID() + "' data-toggle='tooltip' data-placement='bottom' title='" + schedule.getTickets() + " Tickets Left'>" +schedule.getTimeslot() + "</a>" );
    					//set prevDay = the current date
    					prevDay = schedule.getDate();
    				}
    			}
    			//close div for the last schedule
    			out.println("</div>");
    		}else{	
		%>
			<div class="container-fluid">
				<div class="jumbotron row bg-white">
					<h5 class="col-12 text-center"> No Schedule Available</h5>
				</div>
			</div>
			<%} %>
    </div>
    <%	}
  		display.close();
  	%>
  </div> 
</div>

<!-- Movie Review Section -->
<div class="container-fluid">
	<hr class="my-4">
	<h4>Member's Reviews</h4>
	<div class="row">
	<%
		if(reviews.size() != 0){
			for(Review review : reviews){
	%>
			<div class="col-12">
				<div class="card">
  						<h5 class="card-header"><%=review.getName()%><span class="text-muted ml-3 reviewDate"><%= review.getDate() %></span></h5>
  					<div class="card-body">
   						<h5 class="card-title"><%= DisplayService.convertRatingToStars(Double.toString(review.getRating()))%></h5>
    					<p class="card-text"><%=review.getComments() %></p>
    					<div class="text-right">
    					<a href="#" class="btn btn-light">Report this</a>
    					</div>
  					</div>
  					
				</div>
			</div>
	<%}}else{ %>
			<div class="jumbotron col-12 bg-white">
					<h5 class="col-12 text-center"> No Reviews Yet</h5>
			</div>
	<%} %>
	</div>
	
</div>

<!-- Footer -->
<jsp:include page="pFooter.html"></jsp:include>

<jsp:include page="js/pBootstrapScripts.html"></jsp:include>
<script src="js/wan-spinner.js"></script>
<script type="text/javascript">
  $(document).ready(function() {
    var options = {
      maxValue: 10,
      minValue: 0,
      step: 0.5,
      plusClick: function(val) {
        console.log(val);
      },
      minusClick: function(val) {
        console.log(val);
      },
      exceptionFun: function(val) {
        console.log("excep: " + val);
      },
      valueChanged: function(val) {
        console.log('change: ' + val);
      }
    }
    $(".wan-spinner").WanSpinner(options);
  });
  
  $(function () {
	  $('[data-toggle="tooltip"]').tooltip()
	})
	
	/* function noMoreTickets(){
	  alert("All tickets are either on hold or sold. Please check later in case other customers did not complete payment");
  } */
  function clickTicketsOnHoldButton(){
		$("#ticketsOnHoldButton").trigger("click");
	}
  </script>
  <%
  	String ticketsOnHold = request.getParameter("ticketsOnHold");
  	if (ticketsOnHold != null){
  %>
  <button type="button" class="btn btn-info btn-sm" data-toggle="modal" data-target="#ticketsOnHold" style="display: none;" id="ticketsOnHoldButton"></button>
					<div class="modal fade" id="ticketsOnHold" tabindex="-1" role="dialog">
  						<div class="modal-dialog modal-dialog-centered" role="document">
    						<div class="modal-content">
    	  						<div class="modal-header PopUpHeader">
        							<h5 class="modal-title" id="exampleModalLabel">Unable to Proceed for Booking</h5>
        					   		<button type="button" class="close" data-dismiss="modal" aria-label="Close">
			          					<span aria-hidden="true">&times;</span>
			        				</button>
      							</div>
      							<div class="container">
      								<p>Insufficient tickets to complete your booking.</p>
      								<p><b>Tickets on hold: <%=ticketsOnHold%></b></p>
      								<p>Please check later in case other users did not complete payment.</p>
      							</div>
							</div>
     			 		</div>
    				</div>
   <script>clickTicketsOnHoldButton();</script>
   <%} %>
</body>
</html>