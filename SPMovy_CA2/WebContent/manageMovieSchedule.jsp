<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
 <%@ page import="dto.User,dto.Movie,dto.Schedule,dto.Cinema,service.DisplayService,java.util.ArrayList" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">

<link rel="stylesheet" href="css/SPMovy-Admin.css"/>
<!-- Contains all the bootstrap CSS and JS -->
<jsp:include page="css/BootstrapLinks.jsp"/>
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<link rel="stylesheet" href="/resources/demos/style.css">
<link rel="stylesheet" href="https://jonthornton.github.io/jquery-timepicker/jquery.timepicker.css">

<title>Manage Movie Schedule</title>

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
	
#manageMovieSchedule1{
		margin: 5% auto;
}
#manageMovieSchedule1 table{
		margin-top: 3%;
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
	//Display all the schedules of the movie
	DisplayService display = new DisplayService();
	Movie movie = display.displayMovie(movieID);
	ArrayList<Cinema> cinemas = display.displayAllCinema();
%>
	<!--Navigation Bar -->
	<jsp:include page="adminNavigationBar.jsp"/>
	<div class="container" id="manageMovieSchedule1">
	<h2>Schedule for <i><%=movie.getMovieTitle() %></i></h2>
	
	<%
		for (Cinema cinema: cinemas){
			ArrayList <Schedule> schedules = display.displaySchedulesOfMovie(movieID, cinema.getCinemaID());
	%>
		<h4 class="display-5 d-inline font-weight-bold text-info"><%=cinema.getCinemaName() %></h4>
		<table class="table table-hover table-dark mt-1 mb-4 text-center">
			<thead>
	    		<tr>
	      			<th scope="col">Date</th>
			      	<th scope="col">Show Time</th>
			      	<th scope="col">Price</th>
			      	<th scope="col">Tickets Available</th>
			      	<th scope="col">Action</th>
			    </tr>
	  		</thead>
	  		<tbody>
	  			<%	
					if (schedules.size() != 0){
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
						out.print("<td rowspan='" + rowSpans.get(k++) + "\'>" + previousDate + "</td>");
						i++;
					}
					else if(!schedule.getDate().equals(previousDate)){
						//put the new date as a <th> with its row span
						out.print("<td rowspan='" + rowSpans.get(k++) + "\'>" + schedule.getDate() + "</td>");
						previousDate = schedule.getDate();
					}%>
					<td class="schedule"><%= schedule.getTimeslot() %></td>
					<td class="schedule">S$<%= String.format("%.2f", schedule.getPrice()) %></td>
					<td class="schedule"><%= schedule.getTickets() %></td>
					<td class="schedule">
					<button type="button" class="btn btn-info btn-sm" data-toggle="modal" data-target="#UpdateTickets<%= schedule.getScheduleID() %>">Update Tickets</button>
					<div class="modal fade" id="UpdateTickets<%= schedule.getScheduleID() %>" tabindex="-1" role="dialog">
  						<div class="modal-dialog modal-dialog-centered" role="document">
    						<div class="modal-content">
    	  						<div class="modal-header PopUpHeader">
        							<h5 class="modal-title" id="exampleModalLabel">Update Tickets</h5>
        					   		<button type="button" class="close" data-dismiss="modal" aria-label="Close">
			          					<span aria-hidden="true">&times;</span>
			        				</button>
      							</div>
      							<form action="UpdateScheduleTicketsServlet" class="px-4 py-4">
									<div class="form-group row">
										<input type="hidden" name="scheduleID" value="<%= schedule.getScheduleID() %>">
										<input type="hidden" name="movieID" value="<%= schedule.getMovieID() %>">
										<div class="col-md-6">
											<input type="number" name="tickets" class="form-control"required /> 
										</div>							
										<div class="col-md-6 text-left">
											<button type="submit" value="Update Tickets" class="btn btn-info">Update</button>
										</div>	
									</div>
								</form>
							</div>
     			 		</div>
    				</div>
    				<button type="button" class="btn btn-secondary btn-sm" data-toggle="modal" data-target="#UpdatePrice<%= schedule.getScheduleID() %>">Update Price</button> 
    				<div class="modal fade" id="UpdatePrice<%= schedule.getScheduleID() %>" tabindex="-1" role="dialog">
  						<div class="modal-dialog modal-dialog-centered" role="document">
    						<div class="modal-content">
    	  						<div class="modal-header PopUpHeader">
        							<h5 class="modal-title" id="exampleModalLabel">Update Price</h5>
        					   		<button type="button" class="close" data-dismiss="modal" aria-label="Close">
			          					<span aria-hidden="true">&times;</span>
			        				</button>
      							</div>
      							<form action="UpdateSchedulePriceServlet" class="px-4 py-4">
									<div class="form-group row">
										<input type="hidden" name="scheduleID" value="<%= schedule.getScheduleID() %>">
										<input type="hidden" name="movieID" value="<%= schedule.getMovieID() %>">
										<div class="col-md-6">
											<input type="text" name="price" class="form-control" id="price2" onblur="validatePrice2()" placeholder="E.g 7.50" required/> 
										</div>							
										<div class="col-md-6 text-left">
											<button type="submit" value="Update" class="btn btn-info">Update</button>
										</div>	
									</div>
								</form>
							</div>
     			 		</div>
    				</div>
    				<form action="DeleteMovieScheduleServlet" class="d-inline">
						<div class="form-group d-inline">
						<input type="hidden" name="scheduleID" value="<%= schedule.getScheduleID() %>">	
						<input type="hidden" name="movieID" value="<%= schedule.getMovieID() %>">					
						<button type="submit" value="Delete" class="btn btn-danger btn-sm">Delete</button>
						</div>
					</form>
				</td>	
				<%}}%>
	  		</tbody>
		</table>
		<%
			}
			display.close();
		%>
	</div>
	
	<div class="jumbotron container pt-4">
		<h2 class="text-center">Add Schedule</h2>
		<form action="AddMovieScheduleServlet" class="container">	
			<div class="form-group row">
    			<div class="col-md-12">
	    			<label for="cinema">Cinema:</label>
	    			<select class="form-control" id="cinema" name="cinemaID" required>
	    				<option value="1" selected>Dover</option>
	    				<option value="2">Causeway Point</option>
	    				<option value="3">Orchard ION</option>
	    			</select>
	    		</div>
    		</div>
			<div class="form-group row">
    			<div class="col-md-6">
    				<label for="DateInput">Date:</label>
    				<input type="text" class="datepicker form-control" id="DateInput" name="date" required/>
    			</div>
    			<div class="col-md-6">
    				<label for="price">Price:</label>
    				<div class="input-group">
    					<div class="input-group-prepend">
   							<span class="input-group-text">S$</span>
 						</div>
    					<input type="text" class="form-control" id="price" name="price" onblur="validatePrice()" placeholder="E.g 7.50" required/>
    				</div>
    			</div>
    		</div>
    		<div class="form-group row">
    			<div class="col-md-4 mb-3">
    				<label for="Timeslot1">Show Time 1:</label>
    				<input type="text" class="timepicker form-control" id="Timeslot1" name="timeslot" required/>
    			</div>
    			<div class="col-md-4 mb-3">
    				<label for="Timeslot2">Show Time 2:</label>
    				<input type="text" class="timepicker form-control" id="Timeslot2" name="timeslot" />
    			</div>
    			<div class="col-md-4 mb-3">
    				<label for="Timeslot3">Show Time 3:</label>
    				<input type="text" class="timepicker form-control" id="Timeslot3" name="timeslot" />
    			</div>
    		</div>
    		<div class="form-group row">
    			<div class="col-md-4 mb-3">
    				<label for="Timeslot4">Show Time 4:</label>
    				<input type="text" class="timepicker form-control" id="Timeslot4" name="timeslot" />
    			</div>
    			<div class="col-md-4 mb-3">
    				<label for="Timeslot5">Show Time 5:</label>
    				<input type="text" class="timepicker form-control" id="Timeslot5" name="timeslot" />
    			</div>
    			<div class="col-md-4 mb-3">
    				<label for="Timeslot6">Show Time 6:</label>
    				<input type="text" class="timepicker form-control" id="Timeslot6" name="timeslot" />
    			</div>
    		</div>
    		<input type="hidden" value="<%= movieID %>" name="movieID">
    		<div class="form-group row">
    			<button type="submit" value="Add" class="btn btn-info btn-lg mx-auto" id="AddSched">Add</button>
    		</div>
    		
		</form>
	</div>

<jsp:include page="adminFooter.jsp"/>
<jsp:include page="js/BootstrapScriptLinks.jsp"/>
<script src="https://jonthornton.github.io/jquery-timepicker/jquery.timepicker.js"></script>
<script>
	$( function() {
   		$( ".datepicker" ).datepicker();
	} );

	function scheduleExist() {
   	 	alert("The Entered Schedule Already Exist!");
	}
	
	$(function(){
		$('.timepicker').timepicker({
			   'timeFormat': 'H:i',
			   'step': '10',
			   'minTime': '10:00',
			   'maxTime': '18:00',
			   'disableTextInput': true
		   }); 
		});
	
	function validatePrice(){
		var price = document.getElementById("price");
		if(price.value != "" && price.value.match(/^\d{1,2}\.\d{2}$/) == null){
			price.value = "";
			alert("Invalid Price. E.g. 13.00");
		}
	}
	function validatePrice2(){
		var price = document.getElementById("price2");
		if(price.value != "" && price.value.match(/^\d{1,2}\.\d{2}$/) == null){
			price.value = "";
			alert("Invalid Price. E.g. 13.00");
		}
	}
	
</script>
<%
	//if genreExist parameter exist, display error message
	if(request.getParameter("scheduleExist") != null){
		out.println("<script>scheduleExist();</script>");
	}
%>
</body>
</html>