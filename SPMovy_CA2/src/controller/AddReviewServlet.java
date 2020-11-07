package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.text.StringEscapeUtils;

import dto.Review;
import service.ManageService;

/**
 * Servlet implementation class AddReviewServlet
 */
@WebServlet("/AddReviewServlet")
public class AddReviewServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String name = request.getParameter("name");
		Double rating = Double.parseDouble(request.getParameter("rating"));
		String comments = request.getParameter("comments");
		int movieID = Integer.parseInt(request.getParameter("movieID"));
		
		Review review = new Review();
		review.setComments(StringEscapeUtils.escapeHtml4(comments));
		review.setName(StringEscapeUtils.escapeHtml4(name));
		review.setMovieID(movieID);
		review.setRating(rating);
		
		ManageService manage = null;
		try{
			manage = new ManageService();
			boolean result = manage.addReview(review);
			if(result) response.sendRedirect("pMovieDetails.jsp?movieID=" + movieID);
			else throw new Exception("Failed to Add review");
		}catch(Exception e){
			e.printStackTrace();
			response.sendRedirect("error.html");
		}finally{
			if (manage != null) manage.close();
		}
		
	}

}
