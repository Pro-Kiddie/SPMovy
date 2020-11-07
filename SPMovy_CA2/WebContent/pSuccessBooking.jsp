<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
   <%@ page import="dto.User" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">

<jsp:include page="css/pBootstrapCSS_Icons.html"></jsp:include>

<title>Successful</title>
</head>
<body>

<%
	User user = (User)session.getAttribute("user");
	if (user == null){
		response.sendRedirect("login.jsp?errorMsg=");
		return;
	}
%>

<!-- Public Navigation Bar  -->
<jsp:include page="pNavBar.jsp"></jsp:include>

<!-- Page Header -->
<div class="container-fluid">
	<div class="row px-5">
		<div class="col-12">
			<h1 class="px-4 mt-4 text-center text-muted">Success Booking</h1>
		</div>
	</div>
</div>
<hr>
<div class="jumbotron col-12 bg-white">
	<h3 class="display-3 text-center text-danger">Enjoy your movie!</h3>
	<h4 class="text-center mt-4">We look forward to see you at SPMovy cinemas.</h4>
	<h5 class="text-center">You can view all your past bookings at your profile.</h5>
</div>

<!-- Footer -->
<jsp:include page="pFooter.html"></jsp:include>

<jsp:include page="js/pBootstrapScripts.html"></jsp:include>
</body>
</html>