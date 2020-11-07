package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import service.ManageService;

/**
 * Servlet implementation class UpdateSchedulePriceServlet
 */
@WebServlet("/UpdateSchedulePriceServlet")
public class UpdateSchedulePriceServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		double price = Double.parseDouble(request.getParameter("price"));
		int scheduleID = Integer.parseInt(request.getParameter("scheduleID"));
		int movieID = Integer.parseInt(request.getParameter("movieID"));
		
		ManageService manage = null;
		try{
			manage = new ManageService();
			boolean result = manage.updateSchedulePrice(scheduleID, price);
			if (result){
				response.sendRedirect("manageMovieSchedule.jsp?movieID=" + movieID);
			}else{
				throw new Exception("Update Schedule's Price Failed");
			}
			}catch (Exception e){
				e.printStackTrace();
				response.sendRedirect("error.html");
			}finally{
				if (manage != null){
					manage.close();
			}
		}
	}

}
