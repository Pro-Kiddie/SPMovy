package controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.util.Properties;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;


/**
 * Servlet implementation class MovieImageServlet
 */
@WebServlet("/UploadImageServlet")
@MultipartConfig()
public class UploadImageServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String movieID = request.getParameter("movieID");
		String genreID = request.getParameter("genreID");
		
		InputStream uploadProperties = getServletContext().getResourceAsStream("upload.properties");
		Properties props = new Properties();
		props.load(uploadProperties);
		//Retrieve the upload directory set from properties
		File uploadDir;
		if(movieID != null){
			//movieID not null -> uploading image for movie -> retrieve movie's upload dir
			uploadDir = new File(props.getProperty("movieUploadDir"));
		}
		else if (genreID != null){
			//uploading image for genre -> retrieve genre's upload dir
			uploadDir = new File(props.getProperty("genreUploadDir"));
		}
		else{
			response.sendRedirect("error.html");
			return;
		}
		uploadProperties.close();
		//Check if the uploadDir exist. 
		//if !uploadDir.exists() evaluated to be true, THEN !uploadDir.mkdirs() will be evaluated to make the upload directory
		//mkdirs() able to make all nonexistent parent directory too
		if( !uploadDir.exists() && !uploadDir.mkdirs()){
			//print out for debugging purpose
			PrintWriter out = response.getWriter();
			out.println("Failed in making upload directory");
			out.close();
			return;
		}
		
		//Retrieve Image from request parameter (Multi-parts)
		Part imagePart = request.getPart("image");
		InputStream input = imagePart.getInputStream();
		//Use movieID as filename since it will be unique.
		//Will be using movieID to retrieve the movie image too
		File image = new File(uploadDir, movieID == null ? genreID : movieID);
		FileOutputStream output = new FileOutputStream(image);
		byte [] buffer = new byte[1024];
		while(input.read(buffer) > 0){
			output.write(buffer);
		}
		input.close();
		output.close();
		
		//upload finish, direct back to movieDetails.jsp to see the uploaded image and manage other details of the movie
		if (movieID != null){
			response.sendRedirect("movieDetails.jsp?movieID=" + movieID);
		}else if( genreID != null){
			response.sendRedirect("ManageGenre.jsp?genreID=" + genreID);
		}
		
	}

}
