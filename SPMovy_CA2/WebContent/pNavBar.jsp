<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="dto.User, dto.Genre, dto.Movie, service.DisplayService, java.util.ArrayList" %>

<%
	DisplayService display = new DisplayService();
	ArrayList<Genre> genres = display.displayAllGenre();
	ArrayList<Movie> movies = display.displayAllMovie();
	User user = (User)session.getAttribute("user");
	display.close();
%>
<!-- Navigation -->
<nav class="navbar navbar-expand-md navbar-light bg-light sticky-top">
	<div class="container-fluid">
	<!-- container-fluid means the container will take up 100% width of the screen -->
		<a class="navbar-brand mr-0" href="index.jsp">
			<img src="image/SPMovy_Logo.JPG" width="170" height="49">
		</a>
		<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarResponsive">
			<!-- data-toggle is a bootstrap attribute. press on the button the data which data-target point to will collapse/show -->
			<span class="navbar-toggler-icon"></span>
		</button>
		<div class="collapse navbar-collapse" id="navbarResponsive">
			<ul class="navbar-nav text-center"> 
				<!-- ml-auto = margin left auto, push the navbar to the right instead of center at full width. sm will toggle and collapse -->
				<li class="nav-item active dropdown"> <!--active Will make this nav-item darker than then rest-->
					<a class="nav-link dropdown-toggle" href="#" id="genreDropdown" data-toggle="dropdown">Genres</a>
					<div class="dropdown-menu">
						<%
							for(Genre genre : genres){
						%>
                            <a class="dropdown-item" href="pGenreDetails.jsp?genreID=<%=genre.getGenreID()%>"><%= genre.getGenreName()%></a>
                        <%}%>    
                    </div>
				</li>
				<li class="nav-item dropdown">
					<a class="nav-link dropdown-toggle" href="#" id="movieDropdown" data-toggle="dropdown">Movies</a>
					<div class="dropdown-menu">
						<h6 class="dropdown-header">Showing</h6>
						<%
							for(Movie movie : movies){
								if(movie.getStatus().equals("showing")){
						%>
                            <a class="dropdown-item" href="pMovieDetails.jsp?movieID=<%=movie.getMovieID()%>"><%= movie.getMovieTitle()%></a>
                        <%}}%>
                        	 <div class="dropdown-divider"></div>
                        	 <h6 class="dropdown-header">Coming Soon</h6>
                        <%
							for(Movie movie : movies){
								if(movie.getStatus().equals("coming")){
						%>
                            <a class="dropdown-item" href="pMovieDetails.jsp?movieID=<%=movie.getMovieID()%>"><%= movie.getMovieTitle()%></a>
                        <%}}%>
					</div>
				</li>
				<li class="nav-item">
					<%= user == null ? "<a class='nav-link' href='login.jsp'>Login</a>" : "<a class='nav-link' href='pProfile.jsp'>Profile</a>" %>
				</li>
				<% if (user != null){ %>
				<li class="nav-item">
					<a class="nav-link" href="pCart.jsp">Cart</a>
				</li>
				<li class="nav-item">
					<a class="nav-link" href="LogoutServlet">Logout</a>
				</li>
				<%} %>
			</ul>
		</div>
		<form class="form-inline d-xs-none d-sm-none d-lg-block d-xl-block" method="get" action="SearchServlet">
			<select name="type" class="custom-select">
				<option value="title" selected>Title</option>
				<option value="actor">Actor</option>
			</select>
			<input type="search" class="form-control" placeholder="Keyword" name="keyword" size="15" maxlength="40">
			<button type="submit" class="btn btn-outline-dark">Search</button>
		</form>
	</div>
</nav>
