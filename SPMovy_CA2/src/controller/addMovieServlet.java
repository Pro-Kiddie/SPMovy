package controller;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import dto.Movie;
import service.ManageService;
/**
 * Servlet implementation class addMovieServlet
 */
@WebServlet("/addMovieServlet")
public class addMovieServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//try to retrieve the movieID. If request from addMovie.jsp, this parameter is null
		//If request from updateMovie.jsp, this parameter has movieID
		String movieID = request.getParameter("movieID");
		
		//first retrieve parameters to create the movie object
		Movie movie = new Movie();
		movie.setMovieTitle(request.getParameter("movieTitle"));
		String actors = request.getParameter("actorList");
		//use regex to ensure each name is separated by comma.
		//Allow spaces in the name and special symbols (' and .)
		if(actors.matches("[\\w\\s'.]+(,[\\w\\s'.]+)*")){
			//Process the actorList String to a proper format E.g. Actor1, Actor2, Actor3
			movie.setActorList(ManageService.processActorList(actors));
		}
		else{
			if(movieID == null){
				//request coming from Add Movie Form coz movieID does not exist yet
				response.sendRedirect("admin.jsp?actorListFormatError=true");
				return;
			}else{ 
				//request coming from Update Movie Form which passed in movieID as input
				response.sendRedirect("movieDetails.jsp?movieID=" + request.getParameter("movieID") + "&actorListFormatError=true");
				return;
			}
		}
		movie.setReleaseDate(ManageService.convertDateString(request.getParameter("releaseDate")));
		movie.setSynopsis(request.getParameter("synopsis"));
		movie.setDuration(Integer.parseInt(request.getParameter("duration")));
		movie.setStatus(request.getParameter("status"));
		
		ManageService manage = null;
		try{
			manage = new ManageService();
			if (movieID == null){
				//insert the new movie
				int newMovieID = manage.addMovie(movie);
				//retrieve the genreIDs which the movie is in
				String[] genres = request.getParameterValues("genres");
				if(genres != null){
					for(String genre : genres){
						manage.addMovieToGenre(newMovieID, Integer.parseInt(genre));
					}
				}
				//redirect back to admin page after adding the movie & its genres
				response.sendRedirect("movieDetails.jsp?movieID=" + newMovieID);
			}else{
				//update the movie
				boolean result = manage.updateMovie(movie, Integer.parseInt(movieID));
				if (result){
					response.sendRedirect("movieDetails.jsp?movieID=" + movieID + "&updateSuccessful=true");
				}else{
					throw new Exception("Failed to update movie");
				}
			}
		}catch(Exception e){
			e.printStackTrace();
			response.sendRedirect("error.html");
		}finally{
			if(manage != null) manage.close();
		}		
		
	}

}
