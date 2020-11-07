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
 * Servlet implementation class BackToSeatSelectionServlet
 */
@WebServlet("/BackToSeatSelectionServlet")
public class BackToSeatSelectionServlet extends HttpServlet {
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
		//Prevent him from selecting seat for other people's booking
		//If the booking already has seat selected, cannot reselect seat
		CartService cart = (CartService)session.getAttribute("cart");
		Booking booking = cart.getBooking(bookingID);
		if (booking == null || booking.getSeatNo() != null){
			response.sendRedirect("error.html");
			return;
		}
		
		//Forward the request to page selection page to complete the booking
		request.setAttribute("bookingID", bookingID);
		RequestDispatcher rd = request.getRequestDispatcher("pSeatSelection.jsp");
		rd.forward(request, response);
		return;
		
	}

}
