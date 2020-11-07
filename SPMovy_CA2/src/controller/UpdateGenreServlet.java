package controller;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import service.ManageService;

/**
 * Servlet implementation class updateGenreServlet
 */
@WebServlet("/UpdateGenreServlet")
public class UpdateGenreServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String genreID = request.getParameter("genreID");
		String genreName = request.getParameter("genreName");
		String description = request.getParameter("description");
		
		ManageService manage = null;
		try{
			manage = new ManageService();
			boolean result = manage.updateGenre(Integer.parseInt(genreID), genreName, description);
			if (result){
				//updated successfully -> direct back to ManageGenre.jsp
				//User can see the change immediately
				response.sendRedirect("ManageGenre.jsp?genreID=" + genreID);
			}
			else{
				throw new Exception("Failed to update");
			}
			
		}catch (Exception e){
			e.printStackTrace();
			response.sendRedirect("error.html");
		}finally{
			if (manage != null){
				manage.close();
			}
		}
	}

}
