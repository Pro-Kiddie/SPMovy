<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page
	import="dto.User, dto.Genre, dto.Movie, service.DisplayService, java.util.ArrayList"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Admin Page</title>


<!-- Contains all the bootstrap CSS and JS -->
<jsp:include page="css/BootstrapLinks.jsp"></jsp:include>


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
	color: #00b0ff;
}

.col-lg-4 {
	margin-top: 3%;
}

.genreTheme {
	position: relative;
	box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2), 0 6px 20px 0
		rgba(0, 0, 0, 0.19);
}

.text-block {
	position: absolute;
	bottom: 38%;
	right: 30%;
	background-color: black;
	color: white;
	padding-left: 10%;
	padding-right: 10%;
}

.py-5 {
	margin-top: 5%;
}

#section2 {
	margin-top: 5%;
}

table {
	margin-top: 2%;
	margin-bottom: 15%;
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

		DisplayService display = new DisplayService();
		ArrayList<Genre> genres = display.displayAllGenre();
		ArrayList<Movie> movies = display.displayAllMovie();
		display.close();
	%>

	<!--Navigation Bar -->
	<jsp:include page="adminNavigationBar.jsp" />

	<div class="container">
		<div class="row">
			<%
				for (int i = 0; i < genres.size(); i++) {
			%>
			<div class="col-lg-4  col-md-4 col-sm-4">
				<div class="genreTheme">
					<a href="ManageGenre.jsp?genreID=<%=genres.get(i).getGenreID()%>"><img
						src="RetrieveGenreImageServlet?genreID=<%=genres.get(i).getGenreID()%>"
						alt="" style="width: 100%"></a>
					<div class="text-block">
						<h4><%=genres.get(i).getGenreName()%></h4>
					</div>
				</div>
			</div>
			<%
				}
			%>
		</div>
		<div id="section2">
			<h4 class="display-4 d-inline font-weight-bold text-info">Showing</h4>

			<table class="table table-striped table-dark">
				<thead>
					<tr>
						<th scope="col">Movie Name</th>
						<th scope="col">Click To Manage Movies</th>
					</tr>
				</thead>
				<tbody>

					<%
						for (Movie movie : movies) {
							if (movie.getStatus().equals("showing")) {
					%>

					<tr>
						<td><%=movie.getMovieTitle()%></td>
						<td><a class="btn btn-light"
							href="movieDetails.jsp?movieID=<%=movie.getMovieID()%>"
							role="button"><span class="fa fa-gears"> Manage</span></a></td>
					</tr>
					<%
							}
						}
					%>

				</tbody>
			</table>

			<h4 class="display-4 d-inline font-weight-bold text-warning">Coming
				Soon</h4>

			<table class="table table-striped table-dark">
				<thead>
					<tr>
						<th scope="col">Movie Name</th>
						<th scope="col">Click To Manage Movies</th>
					</tr>
				</thead>
				<tbody>

					<%
						for (Movie movie : movies) {
							if (movie.getStatus().equals("coming")) {
					%>

					<tr>
						<td><%=movie.getMovieTitle()%></td>
						<td><a class="btn btn-light"
							href="movieDetails.jsp?movieID=<%=movie.getMovieID()%>"
							role="button"><span class="fa fa-gears"> Manage</span></a></td>
					</tr>
					<%
							}
						}
					%>

				</tbody>
			</table>

			<h4 class="display-4 d-inline font-weight-bold text-muted">Over</h4>

			<table class="table table-striped table-dark">
				<thead>
					<tr>
						<th scope="col">Movie Name</th>
						<th scope="col">Click To Manage Movies</th>
					</tr>
				</thead>
				<tbody>
					<%
						for (Movie movie : movies) {
							if (movie.getStatus().equals("over")) {
					%>

					<tr>
						<td><%=movie.getMovieTitle()%></td>
						<td><a class="btn btn-light"
							href="movieDetails.jsp?movieID=<%=movie.getMovieID()%>"
							role="button"><span class="fa fa-gears"> Manage</span></a></td>
					</tr>
					<%
							}
						}
					%>

				</tbody>
			</table>


		</div>
	</div>

	<jsp:include page="adminFooter.jsp" />

	<jsp:include page="js/BootstrapScriptLinks.jsp"></jsp:include>

	<script>
		function genreExist() {
			alert("The Genre already exist!");
		}
		function actorListWrongFormat() {
			alert("Add Movie Failed! Please separate each Actor/Actress by a comma!");
		}
	</script>
	<%
		//if genreExist parameter exist, display error message
		if (request.getParameter("genreExist") != null) {
			out.println("<script>genreExist();</script>");
		}
		//addMovie Failed. Directed back to admin page with parameter set
		if (request.getParameter("actorListFormatError") != null) {
			out.println("<script> actorListWrongFormat(); </script>");
		}
	%>
</body>
</html>