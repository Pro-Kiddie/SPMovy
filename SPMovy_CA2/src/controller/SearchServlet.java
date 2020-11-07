package controller;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dto.Movie;
import service.DisplayService;

/**
 * Servlet implementation class SearchServlet
 */
@WebServlet("/SearchServlet")
public class SearchServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String keyword = request.getParameter("keyword");
		String type = request.getParameter("type");
		final int MAX_KEYWORD_LENGTH = 40;
		
		ArrayList<Movie> movies;
		DisplayService display = null;
		try{
			display = new DisplayService();
			if (keyword == null || keyword.trim().length() == 0 || keyword.length() > MAX_KEYWORD_LENGTH){
				//empty keyword or keyword length is more than the maximum, return all movies
				movies = display.displayAllMovie();
			}
			else if (type.equals("title")){
				movies = display.searchByTitle(keyword);
			}
			else if (type.equals("actor")){
				movies = display.searchByActor(keyword);
			}
			else if (type.equals("genre")){
				movies = display.searchByGenre(keyword);
			}
			else{
				response.sendRedirect("error.html");
				return;
			}
			RequestDispatcher dispatcher = request.getRequestDispatcher("pSearchResult.jsp");
			request.setAttribute("result", movies);
			dispatcher.forward(request, response);
		}catch (Exception e){
			e.printStackTrace();
		}finally{
			if (display != null){
				display.close();
			}
		}	
	}
}
