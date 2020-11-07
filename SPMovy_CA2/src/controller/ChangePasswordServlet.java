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
 * Servlet implementation class ChangePasswordServlet
 */
@WebServlet("/ChangePasswordServlet")
public class ChangePasswordServlet extends HttpServlet {
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
		
		//Retrieve parameters and verify
		String oldPasswd = request.getParameter("oldPasswd");
		String passwd = request.getParameter("passwd");
		String cPasswd = request.getParameter("cPasswd");
		if (oldPasswd == null || passwd ==null || cPasswd == null){
			response.sendRedirect("error.html");
			return;
		}
		
		//Validate the new passwd meets the complexity requirement
		RequestDispatcher rd = request.getRequestDispatcher("pProfile.jsp"); 
		String errorMsg = null;
		if (!oldPasswd.matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#%\\&\\$\\^\\*])[^\\s]{8,16}$") || !passwd.matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#%\\&\\$\\^\\*])[^\\s]{8,16}$")){
			errorMsg = "Password does not meet complexity requirement.";
		}
		else if(!cPasswd.equals(passwd)){
			errorMsg = "The passwords does not match.";
		}
		if (errorMsg != null){
			request.setAttribute("msg", errorMsg);
			rd.forward(request, response);
			return;
		}
		
		// Authenticate the old password first
		// if authenticated, Update the new password to database
		LoginService login = null;
		try{
			login = new LoginService();
			boolean validUser = login.authenticate(user.getUserID(), oldPasswd);
			if (!validUser){
				//probably someone left computer unattended after login and someone try to change password of his account
				request.setAttribute("msg", "Update failed. Invalid old password.");
				rd.forward(request, response);
				return;
			}
			//provided valid old password, allow user to update password
			//userID is to get from user object in SESSION, should not let user pass in the userID
			boolean result = login.changePasswd(user.getUserID(), LoginService.getHash(passwd));
			if (result){
				request.setAttribute("msg", "Password updated successfully.");
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
