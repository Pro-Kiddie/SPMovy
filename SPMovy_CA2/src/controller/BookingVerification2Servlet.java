package controller;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dto.User;
import service.CartService;

/**
 * Servlet implementation class BookingVerification2Servlet
 */
@WebServlet("/BookingVerification2Servlet")
public class BookingVerification2Servlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//check if the user is a member
		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute("user") == null){
			request.setAttribute("errorMsg", "Login or register as a member to book movie tickets");
			RequestDispatcher dp = request.getRequestDispatcher("login.jsp");
			dp.forward(request, response);
			return;
		}
		
		//retrieve parameters
		int scheduleID;
		int movieID;
		int noTickets;
		try{
			scheduleID = Integer.parseInt(request.getParameter("scheduleID"));
			movieID = Integer.parseInt(request.getParameter("movieID"));
			noTickets = Integer.parseInt(request.getParameter("noTickets"));
		}catch(NumberFormatException | NullPointerException e){
			//one of the parameters is not number or missing
			response.sendRedirect("error.html");
			return;
		}
		CartService cart = (CartService)session.getAttribute("cart");
		User user = (User)session.getAttribute("user");
		
		//verify the noTickets entered by user is greater or equal to tickets available
		if (cart.checkScheduleTickets(scheduleID, noTickets)){
			//enough tickets
			//add bookings to booking table in database & and place the booking in user's shopping cart
			int bookingID = cart.addBooking(scheduleID, user.getUserID(), noTickets);
			if (bookingID > 0){
				//insert successful, proceed to seat selection
				request.setAttribute("bookingID", bookingID);
				RequestDispatcher rd = request.getRequestDispatcher("pSeatSelection.jsp");
				rd.forward(request, response);
				return;
			}
		}
		//when code run until here
		//either initial check returns not enough ticket OR addBooking failed due to not enough tickets
		//redirect back to movie details page and alert user unable to proceed due to quantity ordered too many
		//also tell user how many tickets now on hold because haven't check out, so he can check later in case anyone cancel
		int ticketsOnHold = cart.getTicketsOnHold(scheduleID);
		response.sendRedirect("pMovieDetails.jsp?movieID=" + movieID + "&ticketsOnHold=" + ticketsOnHold);
		return;
	}

}
