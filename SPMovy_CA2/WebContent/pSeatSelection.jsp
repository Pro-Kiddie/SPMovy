<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="dto.Booking, service.CartService, java.util.*,java.util.*, java.io.*" %>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<!-- <link href="css/Seats.css" rel="stylesheet"> -->
<jsp:include page="css/pBootstrapCSS_Icons.html"></jsp:include>
<style>
form > div
{
	margin-top: 50px;
	margin-left: 20px;
} 
#seats{
	display:inline-block;
	/* margin-left: 50px; */
	
}
.seat-select {
    display: none;
}
.seat {
	position: relative;
    display: inline-block;
    margin: 2px;
    background: #ccdfff;
    
    width: 44px;
    height: 44px;
    
    
}
#seats:nth-of-type(4n+0){
	margin-right:10px;
}
.seat #seat-name
{	
	position: absolute;
	top: 21%;
	left: 23%;
}


.seat-select {
    display: none;
}

.seat-select:checked+.seat {
     background: #08D8D5; 
   /*   background: #b70505;  */
}

#holder {
	width: 1090px;
	margin-top: 30px;
	margin-left:138px;
}
.legend
{
	width: 100%;

}
.legend div, .legend h4
{
	display:inline-block;

}
.legend h4
 {
 	display:inline;
 	vertical-align: middle;
 	height: 24px;
 }
#disabled, #available, #selected
{
	width: 24px;
    height: 24px;
    
}
 #disabled
{
	background-color: #373b42;
	
}

 #available
{
	background-color: #ccdfff;
	
}
 #selected
 {
 	background-color: #08D8D5;
 }
 #NextBtn{
 margin-left: 225px;
 }
 #Screen
 {
 margin-left:138px;
 width: 1070px;
 }
 label
 {
 	font-size:15px;
 }

</style>
<title>Select Seats</title>
</head>

<%

	Object valid = request.getAttribute("bookingID");
	if (valid == null){
		//if bookingID is null, request not from previous servlet -> Illegal access
		response.sendRedirect("error.html");
		return;
	}
	int bookingID = (int)valid;
	//the just added booking is inside user's shopping cart
	CartService cart = (CartService)session.getAttribute("cart");
	Booking booking = cart.getBooking(bookingID);
	//Retrieve noTickets for number of seat to be selected
	int noTickets = booking.getNoTickets();
	//Retrieve occupied seat to disable the seats when displaying all seats
	ArrayList<String> occupiedSeats = cart.getOccupiedSeats(booking.getScheduleID());
	String [] takenSeat = occupiedSeats.toArray(new String[occupiedSeats.size()]);
	String passJavaScriptSeats = Arrays.toString(takenSeat);
	
	
%>
<%if(takenSeat.length != 0){
	out.print("<body onload='disableSeats()'>");
} 
else
{
	out.print("<body>");
}%>

<!-- Public Navigation Bar  -->
<jsp:include page="pNavBar.jsp"></jsp:include>


		<div class="text-center text-light font-weight-bold col-12 bg-secondary mt-3" id="Screen">
			Screen
		</div>
	

	<form action="BookingVerification3Servlet" method="post" onsubmit="return fewerSeatsChosenPrompt()">
		<div id="holder">
		<%for(int i = 65; i <= 74; i ++){
			for(int c = 1; c <= 20; c++){ %>
			    <div id="seats">
			      <input name="seatNo" id="seat-sel-<%=(char)i%><%=c%>"  class="seat-select" type="checkbox" value="<%=(char)i%><%=c%>" />
			      <label for="seat-sel-<%=(char)i%><%=c%>" class="seat text-center"><span id="seat-name"><%=(char)i%><%=c%></span></label>
			   	</div>
   		<%}}%>
   	
		<!-- <input type="checkbox" name="seatNo" value="B10">B10<br>
		<input type="checkbox" name="seatNo" value="B11">B11<br> -->
		<input type="hidden" name="bookingID" value="<%=bookingID%>">
		
		
		<!-- <input type="submit" value="Next"/> -->
		
		<div class="row mt-1 text-center">
				<div class="col-2">
					<h3>Legend:</h3>
				</div>
				<div class="col-2">
					<div class="mx-auto" id="disabled">
					</div>
					<h5>Disabled</h5>
				</div>
				<div class="col-2">
					<div class="mx-auto" id="available">
					</div>
					<h5>Available</h5>
				</div>
				<div class="col-2">
					<div class="mx-auto" id="selected">
					</div>
					<h5>Selected</h5>
				</div>
				<div class="col-2">
					<button type="submit" class="btn btn-lg btn-primary" id="NextBtn">Next</button>
				</div>
			</div>
		</div>
		</form>

	<input type="button" data-toggle="modal" data-target="#myModal" id="TriggerModal" hidden/>
	<input type="button" data-toggle="modal" data-target="#myModal2" id="TriggerModal2" hidden/>

<!-- Footer -->
<jsp:include page="pFooter.html"></jsp:include>

<!-- The Modal -->
<div class="modal" id="myModal">
  <div class="modal-dialog">
    <div class="modal-content">
    
      <!-- Modal Header -->
      <div class="modal-header">
        <h4 class="modal-title">Invalid Request</h4>
        <button type="button" class="close" data-dismiss="modal">&times;</button>
      </div>
      
      <!-- Modal body -->
      <div class="modal-body">
       You only requested for <%=noTickets%> tickets!!!
      </div>

    </div>
  </div>
 </div>
 
 <div class="modal" id="myModal2">
  <div class="modal-dialog">
    <div class="modal-content">
    
      <!-- Modal Header -->
      <div class="modal-header">
        <h4 class="modal-title">Unable to proceed</h4>
        <button type="button" class="close" data-dismiss="modal">&times;</button>
      </div>
      
      <!-- Modal body -->
      <div class="modal-body">
       Please select <%=noTickets%> tickets!!!
      </div>

    </div>
  </div>
 </div>
 
<jsp:include page="js/pBootstrapScripts.html"></jsp:include>
<script>
$(document).ready(function () {
	  
	   $("input[name='seatNo']").change(function () {
	
	      var maxAllowed = <%=noTickets%>;
	
	      var cnt = $("input[name='seatNo']:checked").length;
	
	      if (cnt > maxAllowed)
	
	      {
	
	         $(this).prop("checked", "");
	         /* document.getElementById("TriggerModalbtn").click(); */
			document.querySelector("#TriggerModal").click()
	        /* alert('You are booking for ' + maxAllowed + ' tickets only!');  */
	
	     }
	    
	
	  });
});

function disableSeats()
{
	var x = "<%=passJavaScriptSeats%>";
	x = x.replace("[","").replace("]","").split(" ").toString().split(",,");
	for(var i = 0; i < x.length; i++)
	{
		document.querySelector("#seat-sel-" + x[i]).disabled = true; 
		document.querySelector("#seat-sel-" + x[i] + "+ label").style.background = "#373b42";
		document.querySelector("#seat-sel-" + x[i] + "+ label").style.color = "#e8eef7";
		
	}
}
function fewerSeatsChosenPrompt()
{
	var chosenSeats =  document.querySelectorAll('input[type="checkbox"]:checked').length;
	var noOfTickets = <%=noTickets%>;
	if(chosenSeats < noOfTickets)
	{
		/* alert("please select " + noOfTickets); */
		document.querySelector("#TriggerModal2").click();
		return false;
	}
	return true
	
}
</script>
</body>
</html>