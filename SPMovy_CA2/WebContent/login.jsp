<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Login Page</title>

<jsp:include page="css/pBootstrapCSS_Icons.html"></jsp:include>

<style>
	.card{
   			width:30%;
   			margin: 5% auto;
   		}
</style>
</head>
<body>

<!-- Public Navigation Bar  -->
<jsp:include page="pNavBar.jsp"></jsp:include>

<!-- Login Form -->
<div class="card text-white bg-dark mb-3">
  <div class="card-header"><h2><span class="text-danger">SP</span> <span class="fa fa-film"></span> Movy</h2></div>
  <div class="card-body">
    <form action="LoginServlet" method="post">
  <div class="form-group">
    <label for="formGroupExampleInput">User ID</label>
    <input  name="userID" type="text" class="form-control" id="formGroupExampleInput" placeholder="Username">
  </div>
  <div class="form-group">
    <label for="formGroupExampleInput2">Password</label>
    <input name="passwd" type="password" class="form-control" id="formGroupExampleInput2" placeholder="Password">
  </div>
  <div class="row">
  	<div class="col-6"><button type="submit" class="btn btn-primary mx-auto"  value="Login">Login</button></div>
  	<div class="col-6 text-right"><a type="submit" class="btn btn-secondary mx-auto"  href="pRegister.jsp">Register</a></div>
  </div>
  
  
</form>
  </div>
</div>

<!-- Footer -->
<jsp:include page="pFooter.html"></jsp:include>

<jsp:include page="js/pBootstrapScripts.html"></jsp:include>

<script>
	function error() {
   	 alert("Invalid User ID or Password Entered!");
	}
	function errorMsg(){
		$("#errorMsgButton").trigger("click");
	}
</script>
<%
	String result = request.getParameter("result");
	if (result != null && result.equals("false")){
		out.print("<script> error(); </script>");
	}
	
	String errorMsg = (String)request.getAttribute("errorMsg");
	if (errorMsg != null){
%>
<button type="button" class="btn btn-info btn-sm" data-toggle="modal" data-target="#errorMsg" style="display: none;" id="errorMsgButton"></button>
					<div class="modal fade" id="errorMsg" tabindex="-1" role="dialog">
  						<div class="modal-dialog modal-dialog-centered" role="document">
    						<div class="modal-content">
    	  						<div class="modal-header PopUpHeader">
        							<h5 class="modal-title" id="exampleModalLabel">Error</h5>
        					   		<button type="button" class="close" data-dismiss="modal" aria-label="Close">
			          					<span aria-hidden="true">&times;</span>
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