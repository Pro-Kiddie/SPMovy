<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page
	import="dto.User,dto.Review,dto.Movie,service.DisplayService,java.util.ArrayList"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Manage Movie's Reviews</title>
<link rel="stylesheet" href="css/SPMovy-Admin.css" />
<!-- Contains all the bootstrap CSS and JS -->
<jsp:include page="css/BootstrapLinks.jsp" />
<style>
.PopUpHeader {
	background: linear-gradient(#e5e5e5, #c5cfe0);
}

.PopUpBody {
	background-color: #e3e5e8;
}

.PopUpFooter {
	background: linear-gradient(#c5cfe0, #e5e5e5);
}

#adminLink {
	color: #ffffff;
}

.container {
	margin-top: 3%;
}

.card {
	width: 100%;
	margin-top: 3%;
}

.checked {
	color: #ff5500;
}

.py-5 {
	margin-top: 5%;
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
		DisplayService display = new DisplayService();
		ArrayList<Review> reviews = display.displayReviewsOfMovie(movieID);
		Movie movie = display.displayMovie(movieID);
		String movieRating = display.displayMovieRating(movieID);
		display.close();
	%>
	<!--Navigation Bar -->
	<jsp:include page="adminNavigationBar.jsp" />

	<div class="container">
		<h3>
			Reviews for <i><%=movie.getMovieTitle()%></i>
		</h3>
		<h3>
			Overall Rating:
			<%
			if (movieRating.equals("No Reviews")) {
				out.print(movieRating);
			} else {
				out.print(DisplayService.convertRatingToStars(movieRating));
			}
		%>

		</h3>

		<%
			for (Review review : reviews) {
		%>
		<div class="card border-dark mb-3">
			<div class="card-header font-weight-bold">
				<span class="fa fa-envelope-open"></span> From:
				<%=review.getName()%>
			</div>
			<div class="card-body text-dark">
				<p class="card-text">
					Rating:
					<%=review.getRating()%></p>
				<p class="card-text">
					Review:
					<%=review.getComments()%></p>


			</div>
			<div class="card-footer bg-transparent border-dark">
				<form action="DeleteMovieReviewServlet">
					<input type="hidden" name="reviewID"
						value="<%=review.getReviewID()%>"> <input type="hidden"
						name="movieID" value="<%=movieID%>">
					<button type="submit" value="Delete" class="btn btn-danger">Delete</button>
				</form>
			</div>
		</div>

		<%
			}
		%>
	</div>
	<jsp:include page="adminFooter.jsp" />
	<jsp:include page="js/BootstrapScriptLinks.jsp" />
	<script src="https://use.fontawesome.com/releases/v5.0.8/js/all.js"></script>
</body>
</html>