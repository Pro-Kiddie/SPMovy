package controller;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import service.CartService;

/**
 * Servlet implementation class BookingQuantityServlet
 */
@WebServlet("/BookingVerificationServlet")
public class BookingVerificationServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//check if the user is a member
		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute("user") == null){
			request.setAttribute("errorMsg", "Login or Register as a member to book movie tickets");
			RequestDispatcher dp = request.getRequestDispatcher("login.jsp");
			dp.forward(request, response);
			return;
		}
		
		//User is a member, must have cart in his session
		//cart is placed inside session only when user is placed inside session
		CartService cart = (CartService)session.getAttribute("cart");
		
		//Retrieve Parameter and verify parameter
		int scheduleID = Integer.parseInt(request.getParameter("scheduleID") == null ? "0" : request.getParameter("scheduleID"));
		String movieID = request.getParameter("movieID");
		if (scheduleID == 0 || movieID == null){
			response.sendRedirect("error.html");
			return;
		}

		//check the database for the latest number of tickets for the schedule >= 1
		if(cart.checkScheduleTickets(scheduleID, 1)){
			//more than 0 tickets
			//direct user to booking quantity page
			//set an attribute, so next page can check to make sure request only from this page
			request.setAttribute("valid", "fromBookingVerificationServlet");
			RequestDispatcher dp = request.getRequestDispatcher("pBookingQuantity.jsp");
			dp.forward(request, response);
			return;
		}else{
			//Not enough tickets
			//redirect back to movie details page
			int ticketsOnHold = cart.getTicketsOnHold(scheduleID);
			response.sendRedirect("pMovieDetails.jsp?movieID=" + movieID + "&ticketsOnHold=" + ticketsOnHold);
			return;
		}
	}

}

//Add the booking to booking table and decrease the schedule ticket to reserve the ticket for him, so the quantity of ticket for that schedule is always the latest
//Add the booking to his shopping cart too
//int bookingID = cart.addBooking(Integer.parseInt(scheduleID), user.getUserID());