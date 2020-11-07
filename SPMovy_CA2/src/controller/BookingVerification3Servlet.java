package controller;

import java.io.IOException;
import java.util.ArrayList;

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
 * Servlet implementation class BookingVerification3Servlet
 */
@WebServlet("/BookingVerification3Servlet")
public class BookingVerification3Servlet extends HttpServlet {
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
		
		//Verify parameters passed in
		int bookingID = Integer.parseInt(request.getParameter("bookingID") == null ? "0" : request.getParameter("bookingID") );
		String[] selectedSeats = request.getParameterValues("seatNo");
		if (bookingID == 0 || selectedSeats == null){
			response.sendRedirect("error.html");
			return;
		}
		
		//Verify the number of selected seats is correct
		CartService cart = (CartService)session.getAttribute("cart");
		Booking booking = cart.getBooking(bookingID);
		if (booking.getNoTickets() != selectedSeats.length){
			response.sendRedirect("error.html");
			return;
		}
		
		//Verify all seats selected are within the allowed seat range
		for (String seat: selectedSeats){
			if (!seat.matches("^[A-J]([1-9]|1[0-9]|20)$")){
				response.sendRedirect("error.html");
				return;
			}
		}
		
		//Verify all seats selected are not occupied again, to prevent race condition
		ArrayList<String> occupiedSeats = cart.getOccupiedSeats(booking.getScheduleID());
		for (String seat: selectedSeats){
			if (occupiedSeats.contains(seat)){
				//two users trying to select same seats together, redirect back to pSeatSelection.jsp
				request.setAttribute("bookingID", bookingID);
				request.getRequestDispatcher("pSeatSelection.jsp").forward(request, response);
				return;
			}
		}
		
		//Add Selected Seats to booking entry & update booking in shopping cart
		boolean result = cart.addSeatToBooking(bookingID, selectedSeats);
		if(result){
			//direct to display user's shopping cart -> can add another booking or check out
			response.sendRedirect("pCart.jsp");
			return;
		}else{
			response.sendRedirect("error.html");
			return;
		}
		
	}

}
