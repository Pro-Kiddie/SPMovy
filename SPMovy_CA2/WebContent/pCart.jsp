<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="dto.User, dto.Booking, dto.Schedule, dto.Movie, dto.Cinema, service.CartService, service.DisplayService, java.util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">

<jsp:include page="css/pBootstrapCSS_Icons.html"></jsp:include>

<title>Shopping Cart</title>
</head>
<body>

<%
 	//Verify user is a member
	User user = (User)session.getAttribute("user");
	if (user == null){
		//not a member
		request.setAttribute("errorMsg", "Login or register as a member to book movie tickets");
		RequestDispatcher dp = request.getRequestDispatcher("login.jsp");
		dp.forward(request, response);
		return;
	} 
	//display user's shopping cart
	CartService cart = (CartService)session.getAttribute("cart");
%>

<!-- Public Navigation Bar  -->
<jsp:include page="pNavBar.jsp"></jsp:include>

<!-- Page Header -->
<div class="container-fluid">
	<div class="row px-5">
	<div class="col-12">
		<h1 class="px-4 mt-4 text-center text-muted">Shopping Cart</h1>
	</div>
	</div>
</div>

<!-- Booking Items -->
<div class="container">
<%
	if (!cart.isEmpty()){
%>
	<table class="table table-hover mt-1 mb-4 text-center">
		<thead>
			<tr>
		      	<th scope="col">Movie Title</th>
		      	<th scope="col">Cinema</th>
				<th scope="col">Date</th>
				<th scope="col">Show Time</th>
				<th scope="col">Price</th>
				<th scope="col">Quantity</th>
				<th scope="col">Seat(s)</th>
				<th scope="col">Total Price</th>
				<th scope="col">Action</th>
			</tr>
		 </thead>
		 <tbody>
		 	<tr>
		 <%
			 DisplayService display = new DisplayService();
		 	for (Booking booking : cart.getCart()){
		 		//for each booking display booking information
		 		Schedule schedule = display.displaySchedule(booking.getScheduleID());
		 		Movie movie = display.displayMovie(schedule.getMovieID());
		 		Cinema cinema = display.displayCinema(schedule.getCinemaID());
		 %>
		 		<td><%= movie.getMovieTitle() %></td>
		 		<td><%= cinema.getCinemaName() %> </td>
		 		<td><%= schedule.getDate().split(" ")[1] %></td>
		 		<td><%= schedule.getTimeslot() %></td>
		 		<td>S$<%= String.format("%.2f", schedule.getPrice()) %></td>
		 		<td><%= booking.getNoTickets() %></td>
		 		<td><%= booking.getSeatNo() == null ? "Not Selected" : booking.getSeatNo() %></td>
		 		<td>S$<%= String.format("%.2f", schedule.getPrice()*booking.getNoTickets()) %></td>
		 		<td class="row">
		 			<%
		 				if(booking.getSeatNo() == null){
		 					out.print("<a class='btn btn-info btn-sm' href='BackToSeatSelectionServlet?bookingID=" + booking.getBookingID() + "'>Select Seat</a>");
		 				}
		 			%>
		 			<a class="btn btn-danger btn-sm mx-auto" href="DeleteBookingServlet?bookingID=<%= booking.getBookingID() %>">Delete</a>
		 		</td>
		 	</tr>
		 <%}
		 	display.close();
		 	%>	
		 </tbody>
	</table>
	<hr class="mb-2">
	<div class="row mt-4">
		<div class="col-md-7">
		</div>
		<div class="jumbotron col-md-5 mb-0">
			<h5>Total Payable:</h5>
			<h5 class="text-right font-weight-bold">S$: <%= String.format("%.2f", cart.getTotalPayable()) %></h5>
			<hr>
			<div class="row">
				<div class="col-sm-12 col-md-6 text-left py-0">
					<a class="btn btn-secondary btn-sm" href="index.jsp">Book Another Movie</a>
				</div>
				<div class="col-sm-12 col-md-6 text-right py-0">
					<a class="btn btn-primary btn-sm" href="BookingVerification4Servlet">Check Out</a>
				</div>
			</div>
		</div>
	</div>
	<%}else{ %>
	<hr>
	<div class="jumbotron col-12 bg-white">
		<h1 class="text-center text-danger">Your Cart is Empty</h1>
		<h3 class="text-center text-secondary">Book a ticket now!</h3>
	</div>
	<%} %>
</div>

<!-- Footer -->
<jsp:include page="pFooter.html"></jsp:include>

<jsp:include page="js/pBootstrapScripts.html"></jsp:include>
<script>
function seatNotSelected(){
	$("#seatNotSelectedButton").trigger("click");
}
</script>
<%
  	String seatNotSelected = request.getParameter("seatNotSelected");
  	if (seatNotSelected != null){
  %>
  <button type="button" class="btn btn-info btn-sm" data-toggle="modal" data-target="#seatNotSelected" style="display: none;" id="seatNotSelectedButton"></button>
					<div class="modal fade" id="seatNotSelected" tabindex="-1" role="dialog">
  						<div class="modal-dialog modal-dialog-centered" role="document">
    						<div class="modal-content">
    	  						<div class="modal-header PopUpHeader">
        							<h5 class="modal-title" id="exampleModalLabel">Unable to Checkout</h5>
        					   		<button type="button" class="close" data-dismiss="modal" aria-label="Close">
			          					<span aria-hidden="true">&times;</span>
			        				</button>
      							</div>
      							<div class="container mt-3">
      								<p>You have at least 1 booking that did not select seat(s).</p>
      								<p>Please complete your booking.</p>
      							</div>
							</div>
     			 		</div>
    				</div>
   <script>seatNotSelected();</script>
   <%} %>
</body>
</html>