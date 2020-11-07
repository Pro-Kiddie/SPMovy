<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import ="dto.User, dto.Booking, dto.Schedule, dto.Cinema, dto.Movie, java.util.ArrayList, service.DisplayService" %>
<% 
User user = (User) session.getAttribute("user");
if (user == null || !user.getRole().equals("admin")) {
	response.sendRedirect("error.html");
	// use return keyword to return _jspService()
	// prevent the Java code and HTML code below from being rendered 
	return;
}

String userID;
DisplayService display = new DisplayService();
ArrayList<User> allUsers = display.displayAllUsers();
userID = request.getParameter("chosenUser");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="css/BootstrapLinks.jsp"/>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>User Credentials</title>
<style>
#adminLink {
	color: #ffffff;
}
#reportLink {
	color: #00b0ff;
}
label
{
	font-size: 120%;
}
</style>
</head>
<body>
<jsp:include page="adminNavigationBar.jsp" />

<div class="container">

<form action="userCredentials.jsp" method="post" class="mt-4 font-weight-bold">

<div class="form-group">
    <label for="exampleFormControlSelect1">Select a user:</label>
    <select class="form-control" id="exampleFormControlSelect1" name="chosenUser">
    <%if(userID != null){ %>
       <option selected="selected" id="setDefaultValue"><%=userID%></option>
      <%}else{%>
    	  <option selected="selected" id="setDefaultValue">No User Selected</option>
      <%} %>
     
       <%for (int i = 0; i < allUsers.size(); i++){  %>      
    	<option class="mt-1"><%=allUsers.get(i).getUserID()%></option>
       <%}%>
    </select>
  </div>


      <button type="submit" class="btn btn-primary mt-2">View Credentials</button>
  
</form>


 <% 
	 if(userID != null)
	{
		ArrayList <Booking> bookings = display.displayUserBooking(userID);%>
		<!-- <table class="table table-borderless table-hover table-sm text-center"> -->
		<table class="table table-striped table-dark mt-5">
				<thead>
					<tr>
				      	<th scope="col">Movie Title</th>
				      	<th scope="col">Cinema</th>
						<th scope="col">Date</th>
						<th scope="col">Show Time</th>
						<th scope="col">Seat(s)</th>
						<th scope="col">Amount Paid</th>
					</tr>
				 </thead>
				 <tbody>
				 	<tr>
				 <%
				 	for (Booking booking : bookings){
				 		//for each booking display booking information
				 		Schedule schedule = display.displaySchedule(booking.getScheduleID());
				 		Movie movie = display.displayMovie(schedule.getMovieID());
				 		Cinema cinema = display.displayCinema(schedule.getCinemaID());
				 %>
				 		<td><%= movie.getMovieTitle() %></td>
				 		<td><%= cinema.getCinemaName() %> </td>
				 		<td><%= schedule.getDate().split(" ")[1] %></td>
				 		<td><%= schedule.getTimeslot() %></td>
				 		<td><%= booking.getSeatNo() %></td>
				 		<td>S$ <%= String.format("%.2f", booking.getNoTickets()*schedule.getPrice()) %></td>
				 	</tr>
				 <%}
				 	display.close();
				 %>	
				 </tbody>
			</table>	 
		
		
	<%}else
	{
		;}
	%>
</div>
<jsp:include page="adminFooter.jsp" />
<jsp:include page="js/BootstrapScriptLinks.jsp"></jsp:include>
</body>
</html>