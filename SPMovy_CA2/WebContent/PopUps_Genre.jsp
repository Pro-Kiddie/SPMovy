<%@ page import="dto.User, dto.Genre, dto.Movie, java.util.ArrayList, service.DisplayService" %>




<!-- Modal -->
<% 	/* int genreIndex = Integer.parseInt(request.getParameter("genreIndex"));
	int genreID = genreIndex;
	@SuppressWarnings("unchecked") //Casting cannot ensure elements of ArrayList is actually Genre type -> unchecked warning
	ArrayList<Genre> genres = (ArrayList<Genre>)session.getAttribute("genres");
	Genre genre = genres.get(genreIndex); */
	
	int genreID = Integer.parseInt(request.getParameter("genreID"));
	DisplayService display = new DisplayService();
	Genre genre = display.displayGenre(genreID);
	ArrayList<Movie> moviesInGenre = display.displayMoviesInGenre(genre.getGenreID());
	ArrayList<Movie> moviesNotInGenre = display.displayMoviesNotInGenre(genre.getGenreID());
	display.close();
		
%>
	
<!-- Modal for Deleting Genre -->
 <div class="modal fade" id="WarningGenre" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header PopUpHeader">
       <h5 class="modal-title" id="exampleModalLabel"><span class="fa fa-warning text-danger"></span> Delete Genre</h5>
      	 <button type="button" class="close" onclick="location.href='ManageGenre.jsp?genreID=<%=genreID%>'" aria-label="Close">
			          <span aria-hidden="true">&times;</span>
		 </button>
      </div>
      <div class="modal-body PopUpBody">
       	You are about to delete this genre named, <%=genre.getGenreName()%>.<br/>Are you sure
       	you want to proceed?
      </div>
      <div class="modal-footer PopUpFooter">
      	<form action="deleteGenreServlet">
      	<input type="hidden" name="genreID" value="<%= genre.getGenreID() %>" />
      	<button type="submit" name="confirmation" value="Yes" class="btn btn-info">Yes</button>
      	<button type="submit" name="confirmation" value="No" class="btn btn-secondary">No</button>
      	</form>
      </div>
    </div>
  </div>
</div>

<!-- Modal for Deleting Genre's image -->
 <div class="modal fade" id="WarningImage" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header PopUpHeader">
       <h5 class="modal-title" id="exampleModalLabel"><span class="fa fa-warning text-danger"></span> Delete Genre's image</h5>
      	 <button type="button" class="close" onclick="location.href='ManageGenre.jsp?genreID=<%=genreID%>'" aria-label="Close">
			          <span aria-hidden="true">&times;</span>
		 </button>
      </div>
      <div class="modal-body PopUpBody">
       	You are about to delete <i><%=genre.getGenreName()%></i>'s image.<br/>Are you sure
       	you want to proceed?
      </div>
      <div class="modal-footer PopUpFooter">
      	<form action="DeleteImageServlet">
      	<button type="submit" name="genreID" value="<%=genre.getGenreID() %>" class="btn btn-info">Yes</button>
      	<a href="ManageGenre.jsp?genreID=<%=genreID %>" class="btn btn-secondary">No</a>
      	</form>
      </div>
    </div>
  </div>
</div>

<!-- Modal for Updating Genre -->
<div class="modal fade" id="UpdateGenre" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header PopUpHeader">
      <h5 class="modal-title" id="exampleModalLabel">Update Genre</h5>
        <button type="button" class="close" onclick="location.href='ManageGenre.jsp?genreID=<%=genreID%>'" aria-label="Close">
			     <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <form action="UpdateGenreServlet" method="get">
      <div class="modal-body PopUpBody">    
		    
		    <div class="form-group">	    
			    <label for="formGroupExampleInput">Genre Name:</label>
	    		<input type="text" class="form-control" id="formGroupExampleInput" name="genreName" value="<%=genre.getGenreName()%>" required/>	
		    </div>
		    
		     <div class="form-group">
			    <label for="exampleFormControlTextarea1">Genre Description:</label>
			    <textarea class="form-control" id="exampleFormControlTextarea1" rows="8" name="description"><%=genre.getDescription() %></textarea>
			  	<input type="hidden" name="genreID" value="<%=genre.getGenreID()%>">
		  	</div>
        </div>
        <div class="modal-footer PopUpFooter">
        	<button class="btn btn-info" type="submit" value="Update">Update</button>
		  	<button class="btn btn-secondary" type="reset" value="Reset">Reset</button>
		  	
        </div>
        </form>
		
      </div>
    </div>
  </div>


<!-- Uploading Genre Image -->
  <div class="modal fade" id="uploadGenreImage" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<div class="modal-header PopUpHeader">
			<h5 class="modal-title" id="exampleModalLabel">Upload Genre Image</h5>
			        <button type="button" class="close" onclick="location.href='ManageGenre.jsp?genreID=<%=genreID%>'" aria-label="Close">
			          <span aria-hidden="true">&times;</span>
			        </button>
			 </div>
			 <form action="UploadImageServlet" method="post" enctype="multipart/form-data">
			 <div class="modal-body PopUpBody">
			 	
					 <div class="form-group">
						 <label for="formGroupExampleInput">Upload Image for <%= genre.getGenreName() %>:</label>
						 <input type="file" name="image" class="form-control-file" required>
						 <input type="hidden" name="genreID" value="<%=genreID%>">
					 
					 </div>
			</div>	 
			<div class="modal-footer PopUpFooter">
			<button type="submit" class="btn btn-info" value="Submit">Upload</button>
			</div>
			</form>	
		</div>
	</div>
</div>  

<!-- Manage Movies Under Genre -->
 
 <div class="modal fade" id="ManageGenreMovies" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<div class="modal-header PopUpHeader">
			<h5 class="modal-title" id="exampleModalLabel">Manage Movies in Genres</h5>
			       <button type="button" class="close" onclick="location.href='ManageGenre.jsp?genreID=<%=genreID%>'" aria-label="Close">
			          <span aria-hidden="true">&times;</span>
			        </button>
			 </div>
			
			 <div class="modal-body PopUpBody">
			 	
					 <div class="card border-dark mb-3">
					  <div class="card-header"><h3>Movies that are in <%= genre.getGenreName() %></h3></div>
					  <div class="card-body text-dark">
					    
					    
					    <%
							for(Movie movie : moviesInGenre){
						%>
						
								<a class="btn btn-secondary toDeleteMovies" href="DeleteGenre_MovieServlet?movieID=<%= movie.getMovieID()%>&genreID=<%=genre.getGenreID()%>" role="button"><span class="fa fa-times-circle"></span> <%=movie.getMovieTitle() %></a>
					    
					    <%}%>
					  </div>
					</div>
					
					<div class="card border-dark mb-3">
					  <div class="card-header"><h3>Movies that are not in <%= genre.getGenreName() %></h3></div>
					  <div class="card-body text-dark">
					    
					   <%
							for(Movie movie : moviesNotInGenre){
					   %>
					   
					   		<a class="btn btn-info toDeleteMovies" href="AddGenre_MovieServlet?movieID=<%= movie.getMovieID()%>&genreID=<%=genre.getGenreID()%>" role="button"><span class="fa fa-plus-circle"></span> <%=movie.getMovieTitle() %></a>
					   		
					   <% }%>
					  </div>
					</div>
			</div>
		</div>
	</div>
</div>







