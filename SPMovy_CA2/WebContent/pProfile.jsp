<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="dto.User, dto.Booking, dto.Schedule, dto.Movie, dto.Cinema, service.DisplayService, java.util.ArrayList"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">

<jsp:include page="css/pBootstrapCSS_Icons.html"></jsp:include>

<style>
.nav-link.active, .show > .nav-link{
	background-color: #e9ecef !important;
}
</style>

<title>Profile</title>
</head>
<%
	User user = (User)session.getAttribute("user");
	if (user == null){
		response.sendRedirect("login.jsp?errorMsg=");
		return;
	}
	//Display user's booking history
	DisplayService display = new DisplayService();
	ArrayList<Booking> bookings = display.displayUserBooking(user.getUserID());
%>
<body>

<!-- Public Navigation Bar  -->
<jsp:include page="pNavBar.jsp"></jsp:include>

<!-- Page Header -->
<div class="container-fluid">
	<div class="row px-5">
		<div class="col-12">
			<h1 class="px-4 mt-4 text-center text-muted"><%= user.getfName() %>'s Profile</h1>
		</div>
	</div>
</div>
<hr>

<!-- Profile Navigation Pane -->
<div class="container-fluid">
	<div class="row">
	  <div class="col-md-4 col-lg-3">
	    <div class="nav flex-column nav-pills text-center" role="tablist">
	      <a class="nav-link active text-dark" data-toggle="pill" href="#particulars" role="tab">Particulars</a>
	      <a class="nav-link text-dark" data-toggle="pill" href="#changePass" role="tab">Change Password</a>
	      <a class="nav-link text-dark" data-toggle="pill" id="updateParticularsButton" href="#updateParticulars" role="tab">Update Particulars</a>
	      <a class="nav-link text-dark" data-toggle="pill" href="#myBooking" role="tab">View My Booking</a>
	    </div>
	  </div>
	  <div class="col-md-8 col-lg-9">
	    <div class="tab-content">
	      <div class="tab-pane fade show active" id="particulars" role="tabpanel">
	      	<div class="jumbotron bg-white pt-0 pb-3 mb-0">
	      		<div class="row">
					<div class="col-4 text-right pt-1">
						<p>Username:</p>
						<p>Full Name:</p>
						<p>Email:</p>
						<p>Contact:</p>
						<p>Credit Card:</p>
					</div>
					<div class="col-8 pt-1">
						<p><b><%=user.getUserID() %></b></p>
						<p><b><%=user.getfName() + " " + user.getlName() %></b></p>
						<p><b><%=user.getEmail()%> </b></p>
						<p><b><%="+65 " + user.getContact().substring(0, 4) + " " + user.getContact().substring(4)%></b></p>
						<p><b><%=user.getCc()%></b></p>
					</div>
				</div>
	      	</div>
	      </div>
	      <div class="tab-pane fade" id="changePass" role="tabpanel">
	      	<form action="ChangePasswordServlet" method="POST" onsubmit="return validate1()">
	      		<fieldset class="container">
				<legend>Change Password:</legend>
				<div class="form-row">
				<div class="col-md-6 py-0">
					<div class="form-group row mb-0">
						<label class="col-md-5 col-lg-3 col-form-label text-center pt-2 pb-0">Old Password:</label>
						<div class="col-md-7 col-lg-9 pl-0 pr-4 pb-0">
							<input type="password" class="form-control" name="oldPasswd" id="oldPasswd">
							<small id="oldPasswd_Msg" class="form-text text-danger"></small>
						</div>
					</div>
				</div>
				</div>
				<div class="form-row">
				<div class="col-md-6 py-0">
					<div class="form-group row mb-0">
						<label class="col-md-5 col-lg-3 col-form-label text-center pt-2 pb-0">New Password:</label>
						<div class="col-md-7 col-lg-9 pl-0 pr-4 pb-0">
							<input type="password" class="form-control" name="passwd" id="passwd">
							<small class="form-text text-muted"> At least a lower, uppercase, digit and symbol.</small>
							<small id="passwd_Msg" class="form-text text-danger"></small>
						</div>
					</div>
				</div>
				<div class="col-md-6 pt-0 py-0">
					<div class="form-group row mb-0">
						<label class="col-md-5 col-lg-3 col-form-label text-center pt-2 pb-1">Confirm Password:</label>
						<div class="col-md-7 col-lg-9 pl-0 pr-4">
							<input type="password" class="form-control" name="cPasswd" id="cPasswd">
							<small id="cPasswd_Msg" class="form-text text-danger"></small>
						</div>
					</div>
				</div>
				</div>
			</fieldset>
			<div class="form-row">
				<div class="col-6 text-right pr-2">
					<input type="reset" class="btn" value="Reset">
				</div>
				<div class="col-6">
					<input type="submit" class="btn btn-primary" value="Update">
				</div>				
			</div>
	      	</form>
	      </div>
	      <div class="tab-pane fade" id="updateParticulars" role="tabpanel">
	      <form action="UpdateParticularsServlet" method="POST" onsubmit="return validate2()">
			<fieldset class="container">
				<legend>Personal Information:</legend>
				<div class="form-row">
					<div class="col-lg-6 pt-0 py-0">
						<div class="form-group row mb-0">
							<label class="col-lg-4 col-xl-3 col-form-label pt-4 pb-0 pr-0">First Name:</label>
							<div class="col-lg-8 col-xl-9 pl-0 pr-5 pb-1">
								<input type="text" class="form-control" name="fName" id="fName" value="<%=user.getfName()%>">
								<small id="fName_Msg" class="form-text text-danger"></small>
							</div>
						</div>
					</div>
					<div class="col-lg-6 pt-0 py-0">
						<div class="form-group row mb-0">
							<label class="col-lg-4 col-xl-3 col-form-label pt-4 pb-0 pr-0">Last Name:</label>
							<div class="col-lg-8 col-xl-9 pl-0 pr-5 pb-1">
								<input type="text" class="form-control" name="lName" id="lName" value="<%=user.getlName()%>">
								<small id="lName_Msg" class="form-text text-danger"></small>
							</div>
						</div>
					</div>
				</div>
				<div class="form-row">
					<div class="col-lg-6 pt-0 py-0">
						<div class="form-group row mb-0">
							<label class="col-lg-4 col-xl-3 col-form-label pt-4 pb-0 pr-0">Email:</label>
							<div class="col-lg-8 col-xl-9 pl-0 pr-5 pb-1">
								<input type="email" class="form-control" name="email" id="email" value="<%=user.getEmail()%>">
								<small id="email_Msg" class="form-text text-danger"></small>
							</div>
						</div>
					</div>
					<div class="col-lg-6 py-0">
						<div class="form-group row mb-0">
							<label class="col-lg-4 col-xl-3 col-form-label pt-4 pb-0 pr-0">Contact:</label>
							<div class="col-lg-8 col-xl-9 pl-0 pr-5 pb-1">
								<div class="input-group">
									<div class="input-group-prepend">
										<span class="input-group-text">+65</span>
									</div>
									<input type="tel" class="form-control" name="contact" id="contact" value="<%=user.getContact()%>">
								</div>
								<small id="contact_Msg" class="form-text text-danger"></small>
							</div>
						</div>
					</div>
				</div>
			</fieldset>
			<hr>
			<fieldset class="container mt-3">
				<legend>Payment:</legend>
				<div class="form-row">
					<div class="col-lg-6 pt-0 py-0">
						<div class="form-group row mb-0">
							<label class="col-lg-4 col-xl-3 col-form-label pt-4 pb-0 pr-0">Credit Card:</label>
							<div class="col-lg-8 col-xl-9 pl-0 pr-5 pb-1">
								<input type="text" class="form-control" name="cc" id="cc" value="<%=user.getCc()%>">
								<small id="cc_Msg" class="form-text text-danger"></small>
							</div>
						</div>
					</div>
				</div>
			</fieldset>
			<hr>
			<div class="form-row">
				<div class="col-6 text-right pr-2">
					<input type="reset" class="btn" value="Reset">
				</div>
				<div class="col-6">
					<input type="submit" class="btn btn-primary" value="Update">
				</div>
			</div>
		</form>
	      </div>
	      <div class="tab-pane fade" id="myBooking" role="tabpanel">
	      	<% if(!bookings.isEmpty()){ %>
	      	<table class="table table-borderless table-hover table-sm text-center">
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
	      <%}else{ %>
	      <div class="jumbotron bg-white mt-4">
				<h1 class="text-center text-danger">No Booking Record Found</h1>
		  </div>
		  <%} %>
		  </div>
	    </div>
	  </div>
</div>
</div>

<!-- Footer -->
<jsp:include page="pFooter.html"></jsp:include>

<jsp:include page="js/pBootstrapScripts.html"></jsp:include>
<script type="text/javascript">
	
	//Get all the HTML input elements which needed to be verified
	var oldPasswd = document.getElementById("oldPasswd");
	var passwd = document.getElementById("passwd");
	var cPasswd = document.getElementById("cPasswd");
	var fName = document.getElementById("fName");
	var lName = document.getElementById("lName");
	var email = document.getElementById("email");
	var contact = document.getElementById("contact");
	var cc = document.getElementById("cc");
	//Get all the input elements' msgBox too
	var oldPasswd_Msg = document.getElementById("oldPasswd_Msg");
	var passwd_Msg = document.getElementById("passwd_Msg");
	var cPasswd_Msg = document.getElementById("cPasswd_Msg");
	var fName_Msg = document.getElementById("fName_Msg");
	var lName_Msg = document.getElementById("lName_Msg");
	var email_Msg = document.getElementById("email_Msg");
	var contact_Msg = document.getElementById("contact_Msg");
	var cc_Msg = document.getElementById("cc_Msg");
	//Add listener to all in input element to clear its msgBox's warning when focused
	oldPasswd.addEventListener("focus", function(){oldPasswd_Msg.innerHTML="";}, true);
	passwd.addEventListener("focus", function(){passwd_Msg.innerHTML="";}, true);
	cPasswd.addEventListener("focus", function(){cPasswd_Msg.innerHTML="";}, true);
	fName.addEventListener("focus", function(){fName_Msg.innerHTML="";}, true);
	lName.addEventListener("focus", function(){lName_Msg.innerHTML="";}, true);
	email.addEventListener("focus", function(){email_Msg.innerHTML="";}, true);
	contact.addEventListener("focus", function(){contact_Msg.innerHTML="";}, true);
	cc.addEventListener("focus", function(){cc.innerHTML="";}, true);
	
	//Validate Credit Card input as user types & auto insert space every 4 digits
	cc.addEventListener("input", onChangeCreditCard, true);
	
	function validate1(){
		//a variable to store the boolean value if the form is valid
		var valid = true; 
		//Verify old password
		if (oldPasswd.value == "") {
			valid = false;
			oldPasswd_Msg.innerHTML = "** Password is required";
		}
		else if (oldPasswd.value.length<8 || oldPasswd.value.length>16 ){
			valid = false;
			oldPasswd_Msg.innerHTML = "** Password must be between 8 and 16 characters";
		}
		else if (oldPasswd.value.match(/^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#%&\$\^\*])[^\s]{8,16}$/) == null){
			//(?=) look forward group -> ensures the string has this pattern and do not consumer any character
			//(?=.*[!@#\$%\^&\*]) -> must have a special symbol, characters such as $, ^, * which has Regex meaning must be escaped
			//[^\s]{8,16} -> password cannot contain space characters
			valid = false;
			oldPasswd_Msg.innerHTML = "** Password does not meet the complexity requirements";
		}
		
		//Verify password
		if (passwd.value == "") {
			valid = false;
			passwd_Msg.innerHTML = "** Password is required";
		}
		else if (passwd.value.length<8 || passwd.value.length>16 ){
			valid = false;
			passwd_Msg.innerHTML = "** Password must be between 8 and 16 characters";
		}
		else if (passwd.value.match(/^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#%&\$\^\*])[^\s]{8,16}$/) == null){
			//(?=) look forward group -> ensures the string has this pattern and do not consumer any character
			//(?=.*[!@#\$%\^&\*]) -> must have a special symbol, characters such as $, ^, * which has Regex meaning must be escaped
			//[^\s]{8,16} -> password cannot contain space characters
			valid = false;
			passwd_Msg.innerHTML = "** Password does not meet the complexity requirements";
		}
		
		//Verify Confirm Password
		if (cPasswd.value == "") {
			valid = false;
			cPasswd_Msg.innerHTML = "** Password is required";
		}
		else if (cPasswd.value != passwd.value){
			valid = false;
			cPasswd_Msg.innerHTML = "** Password does not match";
		}
		
		//return result
		return valid;
	}
	
	function validate2(){
		//a variable to store the boolean value if the form is valid
		var valid = true; 
		
		//Verify first name
		if (fName.value == ""){
			valid = false;
			fName_Msg.innerHTML = "** First name is required";
		}
		else if (fName.value.match(/^[a-zA-Z ']{1,40}$/) == null){
			valid = false;
			fName_Msg.innerHTML = "** Invalid Name. You can only use alphabets";
		}
		
		//Verify last name
		if (lName.value == ""){
			valid = false;
			lName_Msg.innerHTML = "** Last name is required";
		}
		else if (lName.value.match(/^[a-zA-Z ']{1,40}$/) == null){
			valid = false;
			lName_Msg.innerHTML = "** Invalid Name. You can only use alphabets";
		}
		
		//Verify email
		if (email.value == ""){
			valid = false;
			email_Msg.innerHTML = "** Email is required";
		}
		else if(email.value.match(/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/) == null){
			valid = false;
			email_Msg.innerHTML = "** Invalid email";
		}
		
		//Verify contact
		if (contact.value == ""){
			valid = false;
			contact_Msg.innerHTML = "** Contact is required";
		}
		else if(contact.value.match(/^(6|8|9)\d{7}$/) == null){
			valid = false;
			contact_Msg.innerHTML = "** Please enter a valid Singapore phone numer";
		}
		
		//Verify Credit Card
		if (cc.value == ""){
			valid = false;
			cc_Msg.innerHTML = "** Credit Card is required";
		}
		else if (cc.value.match(/^\d{4}( \d{4}){3}$/) == null){
			valid = false;
			cc_Msg.innerHTML = "** Invalid Credit Card format";
		}
		else if (cc.value.match(/^(4|5){1}/) == null){
			valid = false;
			cc_Msg.innerHTML = "** Only Visa/Mastercard supported";
		}
		//return result
		return valid;
	}
	
	
	function onChangeCreditCard(e) {		
	    var cardNumber = cc.value;
	    var pos = cc.selectionStart;
	    //var output = document.getElementById("demo");
	    //var output1 = document.getElementById("demo1");
	    //var output2 = document.getElementById("demo2");
	    //var output3 = document.getElementById("demo3");
	 
		  // Do not allow users to write invalid characters
	    var formattedCardNumber = cardNumber.replace(/[^\d]/g, "");
	    formattedCardNumber = formattedCardNumber.substring(0, 16);
	  
	    // Split the card number is groups of 4
	    var cardNumberSections = formattedCardNumber.match(/\d{1,4}/g);
	    if (cardNumberSections !== null) {
	        formattedCardNumber = cardNumberSections.join(' ');	
	    }
		
	    console.log("'"+ cardNumber + "' to '" + formattedCardNumber + "'");
	  
	    // If the formmattedCardNumber is different to what is shown, change the value
	    if (cardNumber !== formattedCardNumber) {
	        cc.value = formattedCardNumber;
			//output.innerHTML = formattedCardNumber.length - cardNumber.length;
	        //output1.innerHTML = formattedCardNumber.length;
	        //output2.innerHTML = cardNumber.length;
	        //output3.innerHTML = pos;
	        
	        //Move the cursor position, if not cursor will be at end after editing
	        if((formattedCardNumber.length - cardNumber.length == 1) && (pos == cardNumber.length) ){
	        	cc.selectionStart = pos + 2;
	       		cc.selectionEnd = pos + 2;
	        }
	        else if(formattedCardNumber.length - cardNumber.length == 1 ){
	        	cc.selectionStart = pos;
	       		cc.selectionEnd = pos;
	        }
	        else if(formattedCardNumber.length - cardNumber.length == -1){
	        	cc.selectionStart = pos;
	       		cc.selectionEnd = pos;
	        }
	        else if(formattedCardNumber.length == cardNumber.length){
	        	if (pos == 5 || pos == 10 || pos == 15){
	            	cc.selectionStart = pos + 1;
	       			cc.selectionEnd = pos + 1;
	            }else{
	        		cc.selectionStart = pos;
	       			cc.selectionEnd = pos;
	            }
	        }
	        
	    }
	}
	
	function msg(){
		$("#msgButton").trigger("click");
	}
	function updateParticulars(){
		$("#updateParticularsButton").trigger("click");
	}
</script>
<%
	String msg = (String)request.getAttribute("msg");
	if (msg != null){
%>
<button type="button" class="btn btn-info btn-sm" data-toggle="modal" data-target="#msg" style="display: none;" id="msgButton"></button>
	<div class="modal fade" id="msg" tabindex="-1" role="dialog">
  		<div class="modal-dialog modal-dialog-centered" role="document">
    		<div class="modal-content">
    	  		<div class="modal-header PopUpHeader">
        			<h5 class="modal-title" id="exampleModalLabel"><%= msg.equals("Password updated successfully.") || msg.equals("Personal particulars updated successfully.") || msg.equals("Registration Successful!") || msg.equals("Welcome back to SPMovy!") ? "Success" : "Error"%></h5>
        			<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span></button>
      			</div>
      			<div class="container mt-3">
      				<p><%=msg %></p>
      			</div>
			</div>
     	</div>
   	</div>
<script>msg();</script>
<%
	}
	if (request.getParameter("updateParticulars") != null){	
%>
<script>updateParticulars()</script>
<%} %>
</body>
</html>