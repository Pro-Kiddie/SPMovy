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
 * Servlet implementation class CheckoutServlet
 */
@WebServlet("/CheckoutServlet")
public class CheckoutServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//check if the user is a member
		HttpSession session = request.getSession(false);
		CartService cart = null;
		if (session == null || (cart = (CartService)session.getAttribute("cart")) == null){
			request.setAttribute("errorMsg", "Login or register as a member to book movie tickets");
			RequestDispatcher dp = request.getRequestDispatcher("login.jsp");
			dp.forward(request, response);
			return;
		}	
		//Cart cannot be empty before checking out
		if (cart.isEmpty()){
			response.sendRedirect("error.html");
			return;
		}
		//Check all the bookings in user's cart is completed (seat selected)
		//Possibility that user haven't select seat yet, straight away url access this servlet to checkout
		if (!cart.isAllSeatsSelected()){
			response.sendRedirect("pCart.jsp?seatNotSelected=true");
			return;
		}
		
		//Update the booking's status to paid
		//Remove the bookings in the cart to make the bookings permanent
		boolean result = cart.checkout();
		if(result){
			response.sendRedirect("pSuccessBooking.jsp");
			return;
		}else{
			response.sendRedirect("error.html");
		}
	}

}
