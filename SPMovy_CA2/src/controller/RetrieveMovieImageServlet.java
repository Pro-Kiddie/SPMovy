package controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class RetrieveImageServlet
 */
@WebServlet("/RetrieveMovieImageServlet")
public class RetrieveMovieImageServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String movieID = request.getParameter("movieID");
		
		InputStream uploadProperties = getServletContext().getResourceAsStream("upload.properties");
		Properties props = new Properties();
		props.load(uploadProperties);
		String uploadDir = props.getProperty("movieUploadDir");
		uploadProperties.close();
		
		File movieImage = new File(uploadDir, movieID);
		//check if the movie's image has been uploaded before
		if(movieImage.exists()){
			//uploaded before, retrieve the image and render as response
			FileInputStream input = new FileInputStream(movieImage);
			byte [] image = new byte[1024];
			while(input.read(image) > 0){
				response.getOutputStream().write(image);
			}
			response.setContentType("image/gif");
			input.close();
		}
		else{
			//not uploaded before. Open the default image on web server
			InputStream input = getServletContext().getResourceAsStream("image/defaultMovie.jpg"); //Image aspect ratio 2:3
			byte [] image = new byte[1024];
			while(input.read(image) > 0){
				response.getOutputStream().write(image);
			}
			response.setContentType("image/gif");
			input.close();
		}
	}

}
