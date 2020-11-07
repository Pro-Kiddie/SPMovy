package controller;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class DeleteImageServlet
 */
@WebServlet("/DeleteImageServlet")
public class DeleteImageServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String movieID = request.getParameter("movieID");
		String genreID = request.getParameter("genreID");

		InputStream uploadProperties = getServletContext().getResourceAsStream("upload.properties");
		Properties props = new Properties();
		props.load(uploadProperties);
		// Retrieve the upload directory set from properties
		File uploadDir;
		if (movieID != null) {
			// movieID not null -> uploading image for movie -> retrieve movie's
			// upload dir
			uploadDir = new File(props.getProperty("movieUploadDir"));
		} else if (genreID != null) {
			// uploading image for genre -> retrieve genre's upload dir
			uploadDir = new File(props.getProperty("genreUploadDir"));
		} else {
			response.sendRedirect("error.html");
			return;
		}
		uploadProperties.close();

		File image = new File(uploadDir, movieID == null ? genreID : movieID);
		if (image.exists()) {
			// delete the image
			image.delete();
		}
		// return back to movieDetails.jsp request from movie
		if (movieID != null) {
			response.sendRedirect("movieDetails.jsp?movieID=" + movieID);
		} else {
			// return back to admin.jsp if request from genre
			response.sendRedirect("ManageGenre.jsp?genreID=" + genreID);
		}

	}
}
