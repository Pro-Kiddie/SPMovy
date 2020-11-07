package controller;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dto.Booking;
import service.CartService;

/**
 * Servlet implementation class DeleteBookingServlet
 */
@WebServlet("/DeleteBookingServlet")
public class DeleteBookingServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//check if the user is a member
		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute("user") == null){
			request.setAttribute("errorMsg", "Login or register as a member to book movie tickets");
			RequestDispatcher dp = request.getRequestDispatcher("login.jsp");
			dp.forward(request, response);
			return;
		}
		//Retrieve Parameters & Verify Parameters
		int bookingID = Integer.parseInt(request.getParameter("bookingID") == null ? "0" : request.getParameter("bookingID"));
		if (bookingID == 0){
			response.sendRedirect("error.html");
			return;
		}
		
		//Verify the booking is inside the specific user's shopping cart
		//Prevent him from deleting other people's booking
		CartService cart = (CartService)session.getAttribute("cart");
		Booking booking = cart.getBooking(bookingID);
		if (booking == null){
			response.sendRedirect("error.html");
			return;
		}
		
		//Booking belongs to the user and delete the booking for the user
		//All bookings inside one's cart are not complete yet, not selected seat, not paid
		//When a user paid, booking will be removed from his shopping cart, then the booking in database becomes permanent
		boolean result = cart.deleteBooking(bookingID, booking.getScheduleID(), booking.getNoTickets());
		if (result){
			response.sendRedirect("pCart.jsp");
		}else{
			response.sendRedirect("error.html");
		}
		return;
	}

}
