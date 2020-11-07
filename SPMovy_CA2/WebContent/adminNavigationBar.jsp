<%@ page import="dto.User,dto.Genre,dto.Movie,service.DisplayService,java.util.ArrayList" %>
<link rel="stylesheet" href="css/SPMovy-Admin.css"/>
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<link rel="stylesheet" href="/resources/demos/style.css">

<%
	DisplayService display = new DisplayService();
	ArrayList<Genre> genres = display.displayAllGenre();
	ArrayList<Movie> movies = display.displayAllMovie();
	display.close();	
%>

<nav class="navbar navbar-expand-lg navbar-light bg-dark">
  <a class="navbar-brand font-weight-bold text-light" href="admin.jsp"><span class="text-danger">SP</span> <span class="fa fa-film	
  "></span> Movy</a>
  <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
    <span class="navbar-toggler-icon"></span>
  </button>

  <div class="collapse navbar-collapse" id="navbarSupportedContent">
    <ul class="navbar-nav mr-auto">
      <li class="nav-item active">
        <a class="nav-link" href="admin.jsp" id="adminLink"><span class="fa fa-user-circle"></span> Admin Page<span class="sr-only">(current)</span></a>
      </li>
      <li class="nav-item dropdown active">
        <a class="nav-link dropdown-toggle text-light" data-toggle="dropdown" href="#"  id="navbarDropdown"><span class="fa fa-plus-circle"></span> Add</a>
      	<div class="dropdown-menu" role="button" aria-haspopup="true" aria-expanded="false">
      		 <a class="dropdown-item"  data-toggle="modal" data-target="#addGenre">Genre</a>
      		 <a class="dropdown-item" data-toggle="modal" data-target="#addMovie">Movie</a> 
      	</div>
      </li>
      <li class="nav-item dropdown active">
        <a class="nav-link dropdown-toggle text-light" data-toggle="dropdown" href="#"  id="reportLink"><span class="fa fa-file-text"></span> Report</a>
      	<div class="dropdown-menu" role="button" aria-haspopup="true" aria-expanded="false">
      		<a class="dropdown-item" href="topMovies.jsp">Top Movies</a>
      		<a class="dropdown-item" href="userCredentials.jsp">User Credentials</a>
      		
      	</div>
      </li>
      <li class="nav-item active">
        <a class="nav-link text-light" href="LogoutServlet"><span class="fa fa-sign-out"></span> Log Out</a>
      </li>
    </ul>
    <form action="searchResult.jsp" class="form-inline my-2 my-lg-0">
      <input name="keyword" class="form-control mr-sm-2" type="search" placeholder="E.g. Movie Title, Actor/Actress Name, Showing" aria-label="Search">
      <button class="btn btn-outline-info my-2 my-sm-0" type="submit" value="Search">Search</button>
    </form>
  </div>
</nav>

<!-- Modal for Adding Genre -->
 <div class="modal fade" id="addGenre" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<div class="modal-header PopUpHeader">
			<h5 class="modal-title" id="exampleModalLabel">Add Genre</h5>
			        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
			          <span aria-hidden="true">&times;</span>
			        </button>
			 </div>
			 <form action="addGenreServlet.jsp" method="get">
			 <div class="modal-body PopUpBody">
			 	
					 <div class="form-group">
					 <label for="formGroupExampleInput">Genre Name:</label>
					 <input type="text" name="genreName"  class="form-control" id="formGroupExampleInput" required>
					 </div>
					 <div class="form-group">
					 <label for="formGroupExampleInput">Genre Description:</label>
					 <textarea name="description" class="form-control" id="exampleFormControlTextarea1" rows="5" placeholder="Enter your description here" required></textarea>
					 <label for="formGroupExampleInput">Please select movies that are in this Genre:</label>
					 </div>
					 <%	
								for(Movie movie : movies){
					 %>
							  <div class="form-check">
							    <input type="checkbox" class="form-check-input" id="exampleCheck1" name="movies" value="<%=movie.getMovieID()%>">
							    <label class="form-check-label" for="exampleCheck1"><%=movie.getMovieTitle()%></label>
							  </div>
							  <%	} %>
			</div>
			<div class="modal-footer PopUpFooter">
			<button type="submit" class="btn btn-info" value="Submit">Add</button>
			</div>
			</form>	
		</div>
	</div>
</div> 

<!-- Modal for Adding Movie -->
<div class="modal fade" id="addMovie" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<div class="modal-header PopUpHeader">
			<h5 class="modal-title" id="exampleModalLabel">Add Movie</h5>
			        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
			          <span aria-hidden="true">&times;</span>
			        </button>
			 </div>
			 <form action="addMovieServlet">
			 <div class="modal-body PopUpBody">
			 	
					 <div class="form-group">
						 <label for="formGroupExampleInput">Movie Title:</label>
						 <input type="text" name="movieTitle"  class="form-control" id="formGroupExampleInput" required>
					 </div>
					 <div class="form-group">
						 <label for="formGroupExampleInput">Actor List:</label>
						 <input type="text" name="actorList"  class="form-control" id="formGroupExampleInput" placeholder="Actor1,Actor2,Actor3..."required>
					 	 <small  class="form-text text-danger">Separate by comma</small>
					 </div>
					  <div class="form-group">
						 <label for="formGroupExampleInput">Release Date:</label>
						 <input type="text" name="releaseDate"  class="datepicker form-control"  required/>
					 </div>
					 <div class="form-group">
					 	<label for="formGroupExampleInput">Synopsis:</label>
					 	<textarea name="synopsis" class="form-control" id="exampleFormControlTextarea1" rows="5" placeholder="Enter your description here" required></textarea>
					 </div>
					 <div class="form-group row" style="margin-left:1%;">
					 	<label for="formGroupExampleInput">Duration:</label>
					 	<input type="number" name="duration" class="form-control" required/ style="width:13%; margin-left: 1%; margin-right: 1%; ">
					 	<label for="formGroupExampleInput">minutes</label>
					 </div>
					 <div class="form-group row" style="margin-left:1%;">
					 	<label for="exampleFormControlSelect1">Status:</label>
					 	<select name="status" class="form-control" id="exampleFormControlSelect1" style="width:85%; margin-left: 1%;">
					 		<option value="showing">Showing</option>
					 		<option value="coming">Coming Soon</option>
					 		<option value="over">Over</option>
					 	</select>
					 	<label for="exampleFormControlSelect1">Choose Genres for the New Movie:</label>
					 </div>
					 <%	
								for(Genre genre : genres){
					 %>
							  <div class="form-check">
							    <input type="checkbox" class="form-check-input" id="exampleCheck1" name="genres" value="<%=genre.getGenreID()%>">
							    <label class="form-check-label" for="exampleCheck1"><%=genre.getGenreName()%></label>
							  </div>
							  <%	} %>
					 
			</div>
			<div class="modal-footer PopUpFooter">
			<button type="submit" class="btn btn-info" value="Submit">Add</button>
			</div>
			</form>	
		</div>
	</div>
</div>

<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script>
	$( function() {
   		 $(".datepicker").datepicker();
	} );
</script>





