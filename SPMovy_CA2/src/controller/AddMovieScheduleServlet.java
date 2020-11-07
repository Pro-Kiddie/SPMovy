package controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import service.ManageService;

/**
 * Servlet implementation class AddMovieScheduleServlet
 */
@WebServlet("/AddMovieScheduleServlet")
public class AddMovieScheduleServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int movieID = Integer.parseInt(request.getParameter("movieID"));
		int cinemaID = Integer.parseInt(request.getParameter("cinemaID"));
		double price = Double.parseDouble(request.getParameter("price"));
		String date = ManageService.convertDateString(request.getParameter("date"));
		String[] timeslots = request.getParameterValues("timeslot");
		/*response.getWriter().println(timeslots.length);
		for (String timeslot : timeslots){
			response.getWriter().println(timeslot + "<br>");
			response.getWriter().println(timeslot.equals(""));
		}*/
		ManageService manage = null;
		try{
			manage = new ManageService();
			for(String timeslot : timeslots){
				if(!timeslot.equals("")){ //timepicker returns "" if user did not select a date
					manage.addScheduleToMovie(movieID, cinemaID, date, timeslot, price);
				}
			}
			//added all timeslots successfully, direct back to Manage Movie Schedule Page again
			response.sendRedirect("manageMovieSchedule.jsp?movieID=" + movieID);
		}catch(com.mysql.jdbc.exceptions.jdbc4.MySQLIntegrityConstraintViolationException e){
			//the schedule already exists for the movie
			//pass back an error parameter
			response.sendRedirect("manageMovieSchedule.jsp?movieID=" + movieID + "&scheduleExist=true");
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
