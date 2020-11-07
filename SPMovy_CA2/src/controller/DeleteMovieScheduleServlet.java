package controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import service.ManageService;

/**
 * Servlet implementation class DeleteMovieScheduleServlet
 */
@WebServlet("/DeleteMovieScheduleServlet")
public class DeleteMovieScheduleServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int scheduleID = Integer.parseInt(request.getParameter("scheduleID"));
		int movieID = Integer.parseInt(request.getParameter("movieID"));
		//String date = ManageService.convertScheduleDate(request.getParameter("date").split(" ")[1]);
		//String timeslot = request.getParameter("timeslot");
/*		PrintWriter output = response.getWriter();
		output.print(movieID);
		output.print(date);
		output.print(timeslot);*/
		ManageService manage = null;
		try{
			manage = new ManageService();
			boolean result = manage.deleteSchedule(scheduleID);
			if(result){
				response.sendRedirect("manageMovieSchedule.jsp?movieID=" + movieID);
			}else{
				throw new Exception("Delete Movie Schedule Failed");
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
