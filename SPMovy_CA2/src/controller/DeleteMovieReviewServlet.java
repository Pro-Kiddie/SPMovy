package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import service.ManageService;

/**
 * Servlet implementation class DeleteMovieReviewServlet
 */
@WebServlet("/DeleteMovieReviewServlet")
public class DeleteMovieReviewServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int reviewID = Integer.parseInt(request.getParameter("reviewID"));
		ManageService manage = null;
		try{
			manage = new ManageService();
			manage.deleteReview(reviewID);
			response.sendRedirect("manageMovieReviews.jsp?movieID=" + request.getParameter("movieID"));
		}catch (Exception e){
			e.printStackTrace();
			response.sendRedirect("error.html");
		}finally{
			if(manage != null){
				manage.close();
			}
		}
	}

}
