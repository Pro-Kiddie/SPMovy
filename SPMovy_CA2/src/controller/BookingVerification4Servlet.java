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
 * Servlet implementation class BookingVerification4Servlet
 */
@WebServlet("/BookingVerification4Servlet")
public class BookingVerification4Servlet extends HttpServlet {
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
		CartService cart = (CartService)session.getAttribute("cart");
		//Cart cannot be empty before checking out
		if (cart.isEmpty()){
			response.sendRedirect("error.html");
			return;
		}
		//Check all the bookings in user's cart is completed (seat selected)
		if (!cart.isAllSeatsSelected()){
			response.sendRedirect("pCart.jsp?seatNotSelected=true");
			return;
		}
		
		//All booking's seats are selected, direct user to confirm particulars
		request.setAttribute("fromVerification4Servlet", "true");
		RequestDispatcher rd = request.getRequestDispatcher("pConfirmation.jsp");
		rd.forward(request, response);
		return;
	}

}
