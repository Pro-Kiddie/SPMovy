package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import service.ManageService;

/**
 * Servlet implementation class UpdateScheduleTicketsServlet
 */
@WebServlet("/UpdateScheduleTicketsServlet")
public class UpdateScheduleTicketsServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int movieID = Integer.parseInt(request.getParameter("movieID"));
		int scheduleID = Integer.parseInt(request.getParameter("scheduleID"));
		int tickets = Integer.parseInt(request.getParameter("tickets"));
		ManageService manage = null;
		try{
			manage = new ManageService();
			boolean result = manage.updateScheduleTickets(scheduleID, tickets);
			if(result){
				response.sendRedirect("manageMovieSchedule.jsp?movieID=" + movieID);
			}else{
				throw new Exception("Update Schedule's Tickets Failed");
			}
		}catch(Exception e){
			e.printStackTrace();
			response.sendRedirect("error.html");
		}finally{
			if(manage != null){
				manage.close();
			}
		}
	}

}
