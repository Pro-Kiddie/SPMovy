package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import service.ManageService;

/**
 * Servlet implementation class DeleteMovieServlet
 */
@WebServlet("/DeleteMovieServlet")
public class DeleteMovieServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String choice = request.getParameter("confirmation");
		int movieID = Integer.parseInt(request.getParameter("movieID"));
		if(choice.equals("No")){
			response.sendRedirect("movieDetails.jsp?movieID=" + movieID);
			return;
		}
		ManageService manage = null;
		if(choice.equals("Yes")){
			try{
				manage = new ManageService();
				boolean result = manage.deleteMovie(movieID);
				if (result){
					response.sendRedirect("admin.jsp?deleteMovieSuccessful=true");
				}else{
					throw new Exception("Delete Failed");
				}
			}
			catch (Exception e){
				e.printStackTrace();
				response.sendRedirect("error.html");
			}
			finally{
				if(manage != null) manage.close();
			}
		}
	}

}
