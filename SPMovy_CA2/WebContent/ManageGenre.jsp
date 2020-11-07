<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page
	import="dto.User, dto.Genre, dto.Movie, java.util.ArrayList, service.DisplayService"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Manage Genre</title>

<link rel="stylesheet" href="css/SPMovy-Admin.css" />
<!-- Contains all the bootstrap CSS and JS -->
<jsp:include page="css/BootstrapLinks.jsp" />

<style>
#adminLink {
	color: #ffffff;
}

.PopUpHeader {
	background: linear-gradient(#e5e5e5, #c5cfe0);
}

.PopUpBody {
	background-color: #e3e5e8;
}

.PopUpFooter {
	background: linear-gradient(#c5cfe0, #e5e5e5);
}

table {
	margin-top: 2%;
}

#ManageGenreContainer {
	margin-top: 6%;
}

.lead {
	margin-bottom: 5%;
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

		//display all the information about the genre.
		//int genreIndex = Integer.parseInt(request.getParameter("genreIndex"));
		//@SuppressWarnings("unchecked") //Casting cannot ensure elements of ArrayList is actually Genre type -> unchecked warning
		//ArrayList<Genre> genres = (ArrayList<Genre>)session.getAttribute("genres");
		//Genre genre = genres.get(genreIndex);

		int genreID = Integer.parseInt(request.getParameter("genreID"));
		DisplayService display = new DisplayService();
		Genre genre = display.displayGenre(genreID);
		ArrayList<Movie> movies = display.displayMoviesInGenre(genreID);
		display.close();
	%>

	<!--Navigation Bar -->
	<jsp:include page="adminNavigationBar.jsp" />

	<!-- Contains the Genre's details -->
	<div class="container-fluid">
		<div class="jumbotron row">
				<div class="col-md-8">
					<!-- To display the Genre's name -->
					<h1 class="display-3 d-inline">
						<%=genre.getGenreName()%></h1>

					<!-- To display the Genre's ID -->
					<kbd class="d-inline">
						Genre ID:
						<%=genre.getGenreID()%></kbd>

					<!-- To display the Genre's description -->
					<p class="lead text-justify"><%=genre.getDescription()%></p>
				</div>
				<div class="col-md-4 my-3">
					<img src="RetrieveGenreImageServlet?genreID=<%=genreID %>" class="rounded" width="100%" height="100%">
				</div>
			<!-- Button for updating the Genre -->
			<button type="button" class="btn btn-info btn-lg mx-1" data-toggle="modal"
				data-target="#UpdateGenre">Update</button>

			<!-- Button for uploading the Genre image -->
			<button type="button" class="btn btn-info btn-lg mx-1" data-toggle="modal"
				data-target="#uploadGenreImage">Upload Image</button>

			<!-- Button for managing the genre's movies -->
			<button type="button" class="btn btn-info btn-lg mx-1" data-toggle="modal"
				data-target="#ManageGenreMovies" id="clickManageMovie">Manage
				Genre Movies</button>
			
			<!-- Button for deleting the Genre's image -->
			<button type="button" class="btn btn-info btn-lg mx-1" data-toggle="modal"
				data-target="#WarningImage">Delete Image</button>
					
			<!-- Button for deleting the Genre -->
			<button type="button" class="btn btn-info btn-lg mx-1" data-toggle="modal"
				data-target="#WarningGenre">Delete Genre</button>

			<!-- To include the page that contains all the modal for this page -->
			<jsp:include page="PopUps_Genre.jsp" />

		</div>
		<!-- End of  div ".container" class -->
	</div>
	<!-- End of div ".jumbotron" -->

	<!-- To contain the table with the movies under this genre -->
	<div class=container id="ManageGenreContainer">
		<h4 class="display-4 d-inline">
			Movies that are in
			<%=genre.getGenreName()%></h4>
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
				%>
				<tr>

					<td><%=movie.getMovieTitle()%></td>
					<td><a class="btn btn-light"
						href="movieDetails.jsp?movieID=<%=movie.getMovieID()%>"
						role="button"><span class="fa fa-gears"> Manage</span></a></td>
				</tr>
				<%
					}
				%>

			</tbody>
		</table>
	</div>


	<jsp:include page="adminFooter.jsp" />
	<jsp:include page="js/BootstrapScriptLinks.jsp" />
	<script>
		function clickManageMovie() {
			$("#clickManageMovie").trigger("click");
		}
	</script>

	<%
		if (request.getParameter("clickManageMovie") != null) {
			out.println("<script> clickManageMovie(); </script>");
		}
	%>

</body>
</html>