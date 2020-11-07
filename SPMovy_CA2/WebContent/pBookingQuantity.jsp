<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="dto.Movie, dto.Schedule, service.DisplayService" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">

<jsp:include page="css/pBootstrapCSS_Icons.html"></jsp:include>

<title>Select Tickets</title>
</head>
<body>
<%
	//first verify the request to this page is valid, should have valid attribute in request
	//no need to verify the user attribute in session again
	//all verified in previous servlet as request forwarded from there
	String valid = (String)request.getAttribute("valid");
	if (valid == null || !valid.equals("fromBookingVerificationServlet")){
		response.sendRedirect("error.html");
		return;
	}
	//retrieve parameter from request
	int scheduleID = Integer.parseInt(request.getParameter("scheduleID"));
	int movieID = Integer.parseInt(request.getParameter("movieID"));
	//display movie's image, title
	DisplayService display = new DisplayService();
	Movie movie = display.displayMovie(movieID);
	//display schedule's date & time & price
	Schedule schedule = display.displaySchedule(scheduleID);
	display.close();
%>

<!-- Public Navigation Bar  -->
<jsp:include page="pNavBar.jsp"></jsp:include>
<!-- Changes here 1 -->
<div class="container" style="margin:1%;">
	<div class ="row">
		<div class="col-6">
		<!-- Retrieving the image -->
		<img src="RetrieveMovieImageServlet?movieID=<%=movieID%>" class="img-fluid rounded">
		</div>
		<div class="col-6">
		<!-- 	<div class="jumbotron"> -->
				<h1 class="mb-3"><%=movie.getMovieTitle() %></h1>
				<h5 class="mb-3"><%= schedule.getDate() %></h5>
				<h5 class="mb-3">Time: <%= schedule.getTimeslot() %></h5>
				<p class="mb-3">Price: S$<%= schedule.getPrice() %></p>
				<p class="mb-4">Total Price: S$<span id="totalPrice">0.00</span></p>
					
				<form action="BookingVerification2Servlet" method="POST">
					<div class="form-group row">
					<label class="col-4 col-lg-3 col-xl-2 col-form-label">Quantity:</label> 
					<input type="number" name="noTickets" oninput="updateTotalPrice()" id="quantity" class="col-7 col-lg-6 form-control"  required><br>
					</div>
					<input type="hidden" name="scheduleID" value="<%= scheduleID %>">
					<input type="hidden" name="movieID" value="<%= movieID %>">
					
					<button type="submit" class="btn btn-info mt-3 btn-lg" value="Next">Next</button>
				</form>
			<!-- </div> -->
		</div>
	</div>
</div> <!-- container end -->
	
<!-- Footer -->
<jsp:include page="pFooter.html"></jsp:include>
<jsp:include page="js/pBootstrapScripts.html"></jsp:include>
<script>
	function updateTotalPrice(){
		var quantity = document.getElementById("quantity").value;
		var totalPrice = document.getElementById("totalPrice");
		if(quantity != null && quantity != "")
		{
			totalPrice.innerHTML = parseFloat(parseInt(quantity)*parseFloat(<%=schedule.getPrice()%>)).toFixed(2);
		}
		else
		{
			totalPrice.innerHTML = 0.00;
		}
		
	}
</script>
</body>
</html>