package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import service.ManageService;

/**
 * Servlet implementation class AddGenre_MovieServlet
 */
@WebServlet("/AddGenre_MovieServlet")
public class AddGenre_MovieServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int genreID = Integer.parseInt(request.getParameter("genreID"));
		int movieID = Integer.parseInt(request.getParameter("movieID"));
		ManageService manage = null;
		try{
			manage = new ManageService();
			boolean result = manage.addMovieToGenre(movieID, genreID);
			if (result){
				if(request.getParameter("fromMoviePage") == null) response.sendRedirect("ManageGenre.jsp?genreID=" + genreID + "&clickManageMovie=true");
				else response.sendRedirect("movieDetails.jsp?movieID=" + movieID + "&clickManageGenre=true");
			}
			else{
				throw new Exception("Failed to add");
			}
		}catch (Exception e){
			e.printStackTrace();
			response.sendRedirect("error.html");
		}finally{
			if(manage != null) manage.close();
		}
	}

}
