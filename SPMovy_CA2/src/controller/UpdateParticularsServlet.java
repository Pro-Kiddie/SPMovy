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
import service.LoginService;

/**
 * Servlet implementation class UpdateParticularsServlet
 */
@WebServlet("/UpdateParticularsServlet")
public class UpdateParticularsServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//Verify the member is a user
		HttpSession session = request.getSession(false);
		User user;
		if (session == null || (user = (User)session.getAttribute("user")) == null){
			response.sendRedirect("error.html");
			return;
		}
		
		//Retrieve parameters
		String fName = request.getParameter("fName");
		String lName = request.getParameter("lName");
		String email = request.getParameter("email");
		String contact = request.getParameter("contact");
		String cc = request.getParameter("cc");
		if (fName== null || lName == null || email == null || contact == null || cc == null){
			response.sendRedirect("error.html");
			return;
		}
		
		//Verify the parameters
		RequestDispatcher rd = request.getRequestDispatcher("pProfile.jsp"); 
		String errorMsg = null;
		//Verify first name
		if (fName.equals("") || !fName.matches("^[a-zA-Z ']{1,40}$")){
			errorMsg = "Invalid first name.";
		}
		//Verify last name
		else if (lName.equals("") || !lName.matches("^[a-zA-Z ']{1,40}$")){
			errorMsg = "Invalid last name.";
		}
		//Verify email
		else if (!email.matches("^\\w+([\\.-]?\\w+)*@\\w+([\\.-]?\\w+)*(\\.\\w{2,3})+$") || email.length() > 150){
			//Max email length is 149 -> prevent malicious input
			errorMsg = "Invalid email.";
		}
		//Verify contact
		else if (!contact.matches("^(6|8|9)\\d{7}$")){
			errorMsg = "Invalid phone number.";
		}
		//Verify Credit Card
		else if (!cc.matches("^(4|5)\\d{3}( \\d{4}){3}$")){
			errorMsg = "Invalid credit card.";
		}
		if(errorMsg != null){
			request.setAttribute("msg", errorMsg);
			rd.forward(request, response);
			return;
		}
		
		//Everything alright, update the user object in session and update database
		LoginService login = null;
		try{
			login = new LoginService();
			user.setfName(fName);
			user.setlName(lName);
			user.setEmail(email);
			user.setContact(contact);
			user.setCc(cc);
			boolean result = login.updateUserParticulars(user);
			if (result){
				request.setAttribute("msg", "Personal particulars updated successfully.");
				rd.forward(request, response);
				return;
			}else{
				throw new Exception();
			}
		}catch (Exception e){
			e.printStackTrace();
			response.sendRedirect("error.html");
		}finally{
			if(login != null){
				login.close();
			}
		}
	}

}
