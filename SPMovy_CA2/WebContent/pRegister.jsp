<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">

<jsp:include page="css/pBootstrapCSS_Icons.html"></jsp:include>

<title>Register Member</title>
</head>
<body>

<!-- Public Navigation Bar  -->
<jsp:include page="pNavBar.jsp"></jsp:include>

<!-- Page Header -->
<div class="container-fluid">
	<div class="row px-5">
	<div class="col-12">
		<h1 class="px-4 mt-4 text-center text-muted">SPMovy Registration</h1>
	</div>
	</div>
</div>
<hr>

<!-- Registration Form -->
<div class="container mt-4">
		<form action="Registration" method="POST" name="registration" onsubmit="return validate()"> 
			<fieldset class="container">
				<legend>Account Details:</legend>
				<div class="form-row">
				<div class="col-md-6 py-0">
					<div class="form-group row mb-0">
						<label class="col-md-4 col-lg-3 col-form-label pt-4 pb-0">Username:</label>
						<div class="col-md-8 col-lg-9 pl-0 pr-5 pb-0">
							<input type="text" class="form-control" name="userID" id="userID" onfocus="clearMsg(document.getElementById('userID_Msg'))">
							<small class="form-text text-muted"> Only alphabets and numbers.</small>
							<small id="userID_Msg" class="form-text text-danger"></small>
						</div>
					</div>
				</div>
				<div class="col-md-6 py-0">
					<div class="form-group row mb-0">
						<label class="col-md-4 col-lg-3 col-form-label pt-4 pb-0">Password:</label>
						<div class="col-md-8 col-lg-9 pl-0 pr-5 pb-0">
							<input type="password" class="form-control" name="passwd" id="passwd">
							<small class="form-text text-muted"> At least a lower, uppercase, digit and symbol.</small>
							<small id="passwd_Msg" class="form-text text-danger"></small>
						</div>
					</div>
				</div>
				</div>
				<div class="form-row py-0">
					<div class="col-md-6 pt-0 py-0"></div>
					<div class="col-md-6 pt-0 py-0">
						<div class="form-group row mb-0">
							<label class="col-md-4 col-lg-3 col-form-label pt-2 pb-1">Confirm Password:</label>
							<div class="col-md-8 col-lg-9 pl-0 pr-5">
								<input type="password" class="form-control" name="cPasswd" id="cPasswd">
								<small id="cPasswd_Msg" class="form-text text-danger"></small>
							</div>
						</div>
					</div>
				</div>
			</fieldset>
			<hr>
			<fieldset class="container">
				<legend>Personal Information:</legend>
				<div class="form-row">
					<div class="col-md-6 pt-0 py-0">
						<div class="form-group row mb-0">
							<label class="col-md-4 col-lg-3 col-form-label pt-4 pb-0 pr-0">First Name:</label>
							<div class="col-md-8 col-lg-9 pl-0 pr-5 pb-1">
								<input type="text" class="form-control" name="fName" id="fName">
								<small id="fName_Msg" class="form-text text-danger"></small>
							</div>
						</div>
					</div>
					<div class="col-md-6 py-0">
						<div class="form-group row mb-0">
							<label class="col-md-4 col-lg-3 col-form-label pt-4 pb-0 pr-0">Last Name:</label>
							<div class="col-md-8 col-lg-9 pl-0 pr-5 pb-1">
								<input type="text" class="form-control" name="lName" id="lName">
								<small id="lName_Msg" class="form-text text-danger"></small>
							</div>
						</div>
					</div>
				</div>
				<div class="form-row">
					<div class="col-md-6 pt-0 py-0">
						<div class="form-group row mb-0">
							<label class="col-md-4 col-lg-3 col-form-label pt-4 pb-0 pr-0">Email:</label>
							<div class="col-md-8 col-lg-9 pl-0 pr-5 pb-1">
								<input type="email" class="form-control" name="email" id="email">
								<small id="email_Msg" class="form-text text-danger"></small>
							</div>
						</div>
					</div>
					<div class="col-md-6 py-0">
						<div class="form-group row mb-0">
							<label class="col-md-4 col-lg-3 col-form-label pt-4 pb-0 pr-0">Contact:</label>
							<div class="col-md-8 col-lg-9 pl-0 pr-5 pb-1">
								<div class="input-group">
									<div class="input-group-prepend">
										<span class="input-group-text">+65</span>
									</div>
									<input type="tel" class="form-control" name="contact" id="contact">
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
					<div class="col-md-6 pt-0 py-0">
						<div class="form-group row mb-0">
							<label class="col-md-4 col-lg-3 col-form-label pt-4 pb-0 pr-0">Credit Card:</label>
							<div class="col-md-8 col-lg-9 pl-0 pr-5 pb-1">
								<input type="text" class="form-control" name="cc" id="cc">
								<small id="cc_Msg" class="form-text text-danger"></small>
							</div>
						</div>
					</div>
				</div>
			</fieldset>
			<hr>
			<div class="form-row">
				<div class="col-6 text-right pr-2">
					<input type="reset" class="btn btn-lg" value="Reset">
				</div>
				<div class="col-6">
					<input type="submit" class="btn btn-primary btn-lg" value="Register">
				</div>
				
				
			</div>
		</form>
</div>


<!-- Footer -->
<jsp:include page="pFooter.html"></jsp:include>

<jsp:include page="js/pBootstrapScripts.html"></jsp:include>
<script type="text/javascript">
	
	//Get all the HTML input elements which needed to be verified
	var userID = document.getElementById("userID");
	var passwd = document.getElementById("passwd");
	var cPasswd = document.getElementById("cPasswd");
	var fName = document.getElementById("fName");
	var lName = document.getElementById("lName");
	var email = document.getElementById("email");
	var contact = document.getElementById("contact");
	var cc = document.getElementById("cc");
	//Get all the input elements' msgBox too
	var userID_Msg = document.getElementById("userID_Msg");
	var passwd_Msg = document.getElementById("passwd_Msg");
	var cPasswd_Msg = document.getElementById("cPasswd_Msg");
	var fName_Msg = document.getElementById("fName_Msg");
	var lName_Msg = document.getElementById("lName_Msg");
	var email_Msg = document.getElementById("email_Msg");
	var contact_Msg = document.getElementById("contact_Msg");
	var cc_Msg = document.getElementById("cc_Msg");
	//Add listener to all in input element to clear its msgBox's warning when focused
	userID.addEventListener("focus", function(){userID_Msg.innerHTML="";}, true);
	passwd.addEventListener("focus", function(){passwd_Msg.innerHTML="";}, true);
	cPasswd.addEventListener("focus", function(){cPasswd_Msg.innerHTML="";}, true);
	fName.addEventListener("focus", function(){fName_Msg.innerHTML="";}, true);
	lName.addEventListener("focus", function(){lName_Msg.innerHTML="";}, true);
	email.addEventListener("focus", function(){email_Msg.innerHTML="";}, true);
	contact.addEventListener("focus", function(){contact_Msg.innerHTML="";}, true);
	cc.addEventListener("focus", function(){cc.innerHTML="";}, true);
	
	//Validate Credit Card input as user types & auto insert space every 4 digits
	cc.addEventListener("input", onChangeCreditCard, true);
	
	function validate(){
		//a variable to store the boolean value if the form is valid
		var valid = true; 
		
		//Verify username
		if (userID.value == "") {
			valid = false;
			userID_Msg.innerHTML = "** Username is required";
		}
		else if (userID.value.length<5 || userID.value.length>20 ){
			valid = false;
			userID_Msg.innerHTML = "** Username must be between 5 and 20 characters";
		}
		else if (userID.value.match(/^\w{5,20}$/) == null){
			valid = false;
			userID_Msg.innerHTML = "** Invalid username";
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
	
	function clearMsg(msg){
		msg.innerHTML = "";
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
	
	function errorMsg(){
		$("#errorMsgButton").trigger("click");
	}
</script>
<%
	String errorMsg = (String)request.getAttribute("errorMsg");
	if (errorMsg != null){
%>
<button type="button" class="btn btn-info btn-sm" data-toggle="modal" data-target="#errorMsg" style="display: none;" id="errorMsgButton"></button>
					<div class="modal fade" id="errorMsg" tabindex="-1" role="dialog">
  						<div class="modal-dialog modal-dialog-centered" role="document">
    						<div class="modal-content">
    	  						<div class="modal-header PopUpHeader">
        							<h5 class="modal-title" id="exampleModalLabel">Error</h5>
        					   		<button type="button" class="close" data-dismiss="modal">
			          					<span>&times;</span>
			        				</button>
      							</div>
      							<div class="container mt-3">
      								<p><%=errorMsg %></p>
      							</div>
							</div>
     			 		</div>
    				</div>
<script>errorMsg();</script>
<%} %>
</body>
</html>