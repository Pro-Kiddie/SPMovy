package controller;

import java.io.IOException;
import java.security.NoSuchAlgorithmException;
import java.security.spec.InvalidKeySpecException;

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
 * Servlet implementation class RegistrationServlet
 */
@WebServlet("/Registration")
public class RegistrationServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final String MEMBER = "member";
	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//Get all parameters & Validate again
		String userID = request.getParameter("userID");
		String passwd = request.getParameter("passwd");
		String fName = request.getParameter("fName").trim();
		String lName = request.getParameter("lName").trim();
		String email = request.getParameter("email");
		String contact = request.getParameter("contact");
		String cc = request.getParameter("cc");
		
		RequestDispatcher dispatcher = request.getRequestDispatcher("pRegister.jsp");
		String errorMsg = null;
		LoginService login = null;
		try {
			//Verify userID is correct format
			login = new LoginService();
			if (userID == null || !userID.matches("^\\w{5,20}$")){
				errorMsg = "Invalid Username.";
				throw new Exception();
			}
			//Verify userID is unique
			else if (!login.uniqueUserID(userID)){
				errorMsg = "Username already exists.";
				throw new Exception();
			}
			//Verify password meet the complexity requirement
			else if (passwd == null || !passwd.matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#%\\&\\$\\^\\*])[^\\s]{8,16}$")){
				errorMsg = "Password does not meet complexity requirement.";
				throw new Exception();
			}
			//Verify first name
			else if (fName == null || fName.equals("") || !fName.matches("^[a-zA-Z ']{1,40}$")){
				errorMsg = "Invalid first name.";
				throw new Exception();
			}
			//Verify last name
			else if (lName == null || lName.equals("") || !lName.matches("^[a-zA-Z ']{1,40}$")){
				errorMsg = "Invalid last name.";
				throw new Exception();
			}
			//Verify email
			else if (email == null || !email.matches("^\\w+([\\.-]?\\w+)*@\\w+([\\.-]?\\w+)*(\\.\\w{2,3})+$") || email.length() > 150){
				//Max email length is 149 -> prevent malicious input
				errorMsg = "Invalid email.";
				throw new Exception();
			}
			//Verify contact
			else if (contact == null || !contact.matches("^(6|8|9)\\d{7}$")){
				errorMsg = "Invalid phone number.";
				throw new Exception();
			}
			//Verify Credit Card
			else if (cc == null || !cc.matches("^(4|5)\\d{3}( \\d{4}){3}$")){
				errorMsg = "Invalid credit card.";
				throw new Exception();
			}
		}
		catch (Exception e) {
			e.printStackTrace();
			//If any error occurs -> this servlet is returned control is passed to exception clause
			//Redirect back to registration page with error message
			request.setAttribute("errorMsg", errorMsg);
			dispatcher.forward(request, response);
			//return so codes after finally clause will not be executed
			return;
		} 
		finally{
			//if errorMsg set, below code will not get executed, close connection
			if (errorMsg != null && login != null){
				//return connection to connection pool
				login.close();
			}
		}
		try {
			//All parameters verified, create the User bean class object to store the information
			User user = new User();
			user.setUserID(userID);
			//Hash the password and store the hash instead of plaintext, in case of database gets compromised
			user.setPasswd(LoginService.getHash(passwd));
			user.setfName(LoginService.formatName(fName));
			user.setlName(LoginService.formatName(lName));
			user.setEmail(email);
			user.setContact(contact);
			user.setCc(cc);
			user.setRole(MEMBER);
			
			//Insert record into db
			boolean result = login.addUser(user);
			if (result){
				HttpSession session = request.getSession(false);
				if(session != null){
					//invalidate the existed session and create a new one -> prevent session fixation attack
					session.invalidate();
				}
				//get a new session with new session ID
				session = request.getSession(true);
				session.setMaxInactiveInterval(3600 * 2);
				//Add user and cart into session
				session.setAttribute("user", user);
				CartService cart = new CartService();
				session.setAttribute("cart", cart);
				//redirect to profile page
				RequestDispatcher rdProfile = request.getRequestDispatcher("pProfile.jsp");
				request.setAttribute("msg", "Registration Successful!");
				rdProfile.forward(request, response);
			}else{ 
				response.sendRedirect("error.html");
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect("error.html");
		} finally{
			if (login != null){
				login.close();
			}
		}
	}
	

}
