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
import service.LoginService;

/**
 * Servlet implementation class LoginServlet
 */
@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String userID = request.getParameter("userID");
		String passwd = request.getParameter("passwd");
		LoginService loginService = null;
		try {
			loginService = new LoginService();
			boolean result = loginService.authenticate(userID, passwd);
			//session.invalidate
			//session=request.getSession();
			//Should invalidate the whatever the previous session and create a new session with a new session ID
			//The old sessionID might have been stolen by others on client side, when the client login -> others can impersonate
			//a new session will get a new Session ID,  stolen session ID will not be valid anymore
			//but before invalidate() can copy the info you need from the old session to new session first
			//SessionID stores in client browser and does not change -> send to server for every request even after it expired
			//SessionID reused
			if (result) {
				//retrieve user details from db
				User user = loginService.getUserDetails(userID);
				HttpSession session = request.getSession(false);
				if(session != null){
					//invalidate the existed session and create a new one -> prevent session fixation attack
					session.invalidate();
				}
				//get a new session with new sessionID
				session = request.getSession(true);
				//session will expire in 2 hours
				session.setMaxInactiveInterval(3600 * 2);
				//set the user object in the session
				session.setAttribute("user", user);
				//if the user's role is admin, direct him to admin page
				if (user.getRole().equals("admin")){
					response.sendRedirect("admin.jsp");
					CartService cart = new CartService();
					session.setAttribute("cart", cart);
					return;
				}
				else if (user.getRole().equals("member")){
					//if role is member, put shopping cart inside his session
					CartService cart = new CartService();
					session.setAttribute("cart", cart);
					//direct him to his or her profile page
					RequestDispatcher rd = request.getRequestDispatcher("pProfile.jsp");
					request.setAttribute("msg", "Welcome back to SPMovy!");
					rd.forward(request, response);
					return;
				}
			}else {
				//login fail, direct back to login page with the result
				response.sendRedirect("login.jsp?result=" + result);
				return;
			}
			
		} catch (Exception e) {
			//Cannot connect to database
			//Redirect back to login.jsp
			e.printStackTrace();
			response.sendRedirect("error.html");
		}finally{
			if(loginService != null) loginService.close();
		}

	}

}
