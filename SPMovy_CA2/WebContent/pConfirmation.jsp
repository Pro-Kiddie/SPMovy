<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="dto.User, dto.Booking, dto.Schedule, dto.Movie, dto.Cinema, service.CartService, service.DisplayService, java.util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">

<jsp:include page="css/pBootstrapCSS_Icons.html"></jsp:include>

<title>Confirm Particulars</title>
</head>
<body>
<%
 	//Verify user is a member and request came from BookingVerification4Servlet
	User user = (User)session.getAttribute("user");
	String valid = (String)request.getAttribute("fromVerification4Servlet");
	if (user == null || valid == null){
		//request not from verification4Servlet -> Malicious request attempt 
		//User want to check out without selecting seat -> Not allowed
		response.sendRedirect("error.html");
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
		<h1 class="px-4 mt-4 text-center text-muted">Confirm Particulars</h1>
	</div>
	</div>
</div>

<!-- User Information -->
<div class="container">
	<div class="row">
		<div class="jumbotron bg-white col-12">
			<h3 class="display-5 mt-2">User Information</h3>
			<hr>
			<div class="row">
				<div class="col-4 text-center">
					<p>Name:</p>
					<p>Email:</p>
					<p>Contact:</p>
					<p>Credit Card:</p>
				</div>
				<div class="col-8">
					<p><b><%=user.getfName() + " " + user.getlName() %></b></p>
					<p><b><%=user.getEmail()%> </b></p>
					<p><b><%="+65 " + user.getContact().substring(0, 4) + " " + user.getContact().substring(4)%></b></p>
					<p><b><%=user.getCc()%></b></p>
				</div>
			</div>
			<h3 class="display-5 mt-2">Order Details</h3>
			<hr>
			<table class="table table-borderless table-sm mt-1 mb-4 text-center">
				<thead>
					<tr>
				      	<th scope="col">Movie Title</th>
				      	<th scope="col">Cinema</th>
						<th scope="col">Date</th>
						<th scope="col">Show Time</th>
						<th scope="col">Seat(s)</th>
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
				 		<td><%= booking.getSeatNo() %></td>
				 	</tr>
				 <%}
				 	display.close();
				 %>	
				 </tbody>
			</table>
			<hr>
			<h4 class="display-5 text-right">Total Payable</h4>
			<p class="lead text-right font-weight-bold mr-4">S$: <%= String.format("%.2f", cart.getTotalPayable()) %></p>
			<hr>
			<div class="row">
				<div class="col-6">
					<a class="btn btn-info btn-md" href="pProfile.jsp?updateParticulars">Update Particulars</a>
				</div>
				<div class="col-6 text-right">
					<!-- <a class="btn btn-danger btn-lg mr-4" href="CheckoutServlet">Pay</a> -->
					<!-- To remove the Paypal payment, comment out the paypal-button below and uncomment the original checkout link -->
					<div id="paypal-button"></div>
				</div>
			</div>
		</div>
	</div>
</div>

<!-- Footer -->
<jsp:include page="pFooter.html"></jsp:include>

<jsp:include page="js/pBootstrapScripts.html"></jsp:include>


<script src="https://www.paypalobjects.com/api/checkout.js"></script>
<script>
paypal.Button.render({
  // Configure environment
  env: 'sandbox',
  client: {
    sandbox: 'AfmDLDoLZh5JqpwPxRDfy5lkm4t5OcZUuL0I9TcBQnGv69kmCVt73eUCS3C3hx2xOj2NL3_nonQfZsDq',
    /* production: 'demo_production_client_id' */
  },
  // Customize button (optional)
  locale: 'en_SG',
  style: {
    size: 'large',
    color: 'gold',
    shape: 'rect',
    label: 'checkout',
    tagline: 'true',
  },
  // Set up a payment
  
  payment: function (data, actions) {
    return actions.payment.create({
      transactions: [{
        amount: {
          total: '<%= String.format("%.2f", cart.getTotalPayable()) %>',
          currency: 'SGD'
        }
      }]
    });
  },
  // Execute the payment
  onAuthorize: function (data, actions) {
    return actions.payment.execute()
      .then(function () {
    	  window.location.href = "https://localhost:8443/SPMovy_Final/CheckoutServlet";
      });
  }
}, '#paypal-button');
</script>
</body>
</html>