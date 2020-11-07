package service;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import org.apache.commons.text.StringEscapeUtils;

import dto.Booking;
import dto.Cinema;
import dto.Genre;
import dto.Movie;
import dto.Review;
import dto.Schedule;
import dto.TopMovies;
import dto.User;

public class DisplayService {
	
	private Connection conn;
	
	public DisplayService(){
		conn = DBConnection.getConnection();
		//conn might be null if all connections in the pool is being used
	}
	
	public ArrayList<Genre> displayAllGenre() throws SQLException{
		Statement stmt = conn.createStatement();
		ResultSet result = stmt.executeQuery("select * from genre");
		ArrayList<Genre> genres = retrieveGenres(result);
		close(stmt,result);
		return genres;
	}
	
	public ArrayList<Movie> displayAllMovie() throws SQLException{
		Statement stmt = conn.createStatement();
		ResultSet result = stmt.executeQuery("select * from movie order by releaseDate desc");
		ArrayList<Movie> movies = retrieveMovies(result);
		close(stmt,result);
		return movies;
	}
	
	public ArrayList<Cinema> displayAllCinema() throws SQLException{
		Statement stmt = conn.createStatement();
		ResultSet result = stmt.executeQuery("select * from cinema");
		ArrayList<Cinema> cinemas = new ArrayList<>();
		while (result.next()){
			Cinema cinema = new Cinema();
			cinema.setCinemaID(result.getInt("cinemaID"));
			cinema.setCinemaName(result.getString("cinemaName"));
			cinemas.add(cinema);
		}
		close(stmt,result);
		return cinemas;
	}
	
	public ArrayList<User> displayAllUsers() throws SQLException
	{
		Statement stmt = conn.createStatement();
		ResultSet result = stmt.executeQuery("SELECT * FROM assignment.user where role = 'member';");
		ArrayList<User> allUsers = retrieveallUsers(result);
		close(stmt,result);
		return allUsers;
		
	}
	
	public Cinema displayCinema(int cinemaID) throws SQLException{
		PreparedStatement stmt = conn.prepareStatement("select * from cinema where cinemaID=?");
		stmt.setInt(1, cinemaID);
		ResultSet result = stmt.executeQuery();
		Cinema cinema = null;
		if(result.next()){
			cinema = new Cinema();
			cinema.setCinemaID(result.getInt("cinemaID"));
			cinema.setCinemaName(result.getString("cinemaName"));
		}
		close(stmt,result);
		return cinema;
	}
	
	public ArrayList<Schedule> displaySchedulesOfMovie(int movieID, int cinemaID)throws SQLException{
		PreparedStatement stmt = conn.prepareStatement("select * from schedule where movieID=? and cinemaID=? order by date,timeslot");
		stmt.setInt(1, movieID);
		stmt.setInt(2, cinemaID);
		ResultSet result = stmt.executeQuery();
		ArrayList<Schedule> schedules = retrieveSchedules(result);
		close(stmt,result);
		return schedules;
	}
	
	public ArrayList<Movie> displayMoviesInGenre(int genreID) throws SQLException{
		PreparedStatement stmt = conn.prepareStatement("select * "
				+ "from genre_movie gm, movie m "
				+ "where gm.genreID=? and gm.movieID=m.movieID");
		stmt.setInt(1, genreID);
		ResultSet result = stmt.executeQuery();
		ArrayList<Movie> movies = retrieveMovies(result);
		close(stmt,result);
		return movies;
	}	
	
	public ArrayList<Movie> displayMoviesNotInGenre(int genreID) throws SQLException{
		PreparedStatement stmt = conn.prepareStatement("select * from movie where movieID not in "
				+ "(select movieID from genre_movie where genreID=?)");
		stmt.setInt(1, genreID);
		ResultSet result = stmt.executeQuery();
		ArrayList<Movie> movies = retrieveMovies(result);
		close(stmt,result);
		return movies;
	}
	
	public Genre displayGenre(int genreID) throws SQLException{
		PreparedStatement stmt = conn.prepareStatement("select * from genre where genreID=?");
		stmt.setInt(1, genreID);
		ResultSet result = stmt.executeQuery();
		ArrayList<Genre> genre = retrieveGenres(result);
		return genre.get(0);
	}
	
	public ArrayList<Genre> displayGenresOfMovie(int movieID) throws SQLException{
		PreparedStatement stmt = conn.prepareStatement("select * "
				+ "from genre_movie gm, genre g "
				+ "where gm.movieID=? and gm.genreID=g.genreID");
		stmt.setInt(1, movieID);
		ResultSet result = stmt.executeQuery();
		ArrayList<Genre> genres = retrieveGenres(result);
		close(stmt,result);
		return genres;
	}
	
	public ArrayList<Genre> displayNotGenresOfMovie(int movieID) throws SQLException{
		PreparedStatement stmt = conn.prepareStatement("select * from genre where genreID not in "
				+ "(select genreID from genre_movie where movieID=?)");
		stmt.setInt(1, movieID);
		ResultSet result = stmt.executeQuery();
		ArrayList<Genre> genres = retrieveGenres(result);
		close(stmt,result);
		return genres;
	}
	
	//Deprecated
	public ArrayList<Movie> searchMovie(String keyword) throws SQLException{
		//PreparedStatement stmt = conn.prepareStatement("select * from movie where movieTitle like ? or movieTitle like ? or movieTitle like ? or movieTitle like ? or movieTitle like ?");
		PreparedStatement stmt = conn.prepareStatement("select * from movie where "
				+ "LOWER(CONCAT(movieTitle,' ',actorList,' ',releaseDate,' ',synopsis,' ',duration,' ',status)) like LOWER(?)");
		stmt.setString(1, '%' + keyword + '%');
		
		ResultSet result = stmt.executeQuery();
		ArrayList<Movie> movies = retrieveMovies(result);
		close(stmt,result);
		return movies;
	}
	
	public ArrayList<Movie> searchByTitle(String title) throws SQLException{
		PreparedStatement stmt = conn.prepareStatement("select * from movie where LOWER(movieTitle) like LOWER(?) order by releaseDate desc");
		stmt.setString(1, '%' + title + '%');
		
		ResultSet result = stmt.executeQuery();
		ArrayList<Movie> movies = retrieveMovies(result);
		close(stmt,result);
		return movies;
	}
	
	public ArrayList<Movie> searchByActor(String actor) throws SQLException{
		PreparedStatement stmt = conn.prepareStatement("select * from movie where LOWER(actorList) like LOWER(?) order by releaseDate desc");
		stmt.setString(1, '%' + actor + '%');
		
		ResultSet result = stmt.executeQuery();
		ArrayList<Movie> movies = retrieveMovies(result);
		close(stmt,result);
		return movies;
	}
	
	public ArrayList<Movie> searchByGenre(String genre) throws SQLException{
		CallableStatement stmt = conn.prepareCall("{call displayMoviesInGenre(?)}");
		stmt.setString(1, genre);
		stmt.execute();
		ResultSet result = stmt.getResultSet();
		ArrayList<Movie> movies = retrieveMovies(result);
		close(stmt,result);
		return movies;
	}
	
	public ArrayList<Review> displayReviewsOfMovie(int movieID) throws SQLException{
		PreparedStatement stmt = conn.prepareStatement("select reviewID,name,rating,comments,date from review where movieID=?");
		stmt.setInt(1, movieID);
		ResultSet result = stmt.executeQuery();
		ArrayList<Review> reviews = new ArrayList<>();
		while(result.next()){
			Review review = new Review();
			review.setReviewID(result.getInt("reviewID"));
			review.setName(result.getString("name"));
			review.setRating(result.getDouble("rating"));
			review.setComments(result.getString("comments"));
			review.setDate(result.getString("date").substring(0,19));
			reviews.add(review);
		}
		close(stmt,result);
		return reviews;
	}
	
	public String displayMovieRating(int movieID) throws SQLException{
		PreparedStatement stmt = conn.prepareStatement("select avg(rating) from review where movieID=? group by movieID");
		stmt.setInt(1, movieID);
		ResultSet result = stmt.executeQuery();
		String rating;
		if(result.next()){
			rating = String.format("%.1f",result.getBigDecimal(1));
		}else{
			rating = "No Reviews";
		}
		return rating;
	}
	
	public Movie displayMovie(int movieID) throws SQLException{
		PreparedStatement stmt = conn.prepareStatement("select * from movie where movieID=?");
		stmt.setInt(1, movieID);
		ResultSet result = stmt.executeQuery();
		ArrayList<Movie> movie = retrieveMovies(result);
		return movie.get(0);
	}
	
	public Schedule displaySchedule(int scheduleID) throws SQLException{
		PreparedStatement stmt = conn.prepareStatement("select * from schedule where scheduleID=?");
		stmt.setInt(1, scheduleID);
		ResultSet result = stmt.executeQuery();
		ArrayList<Schedule> schedule = retrieveSchedules(result);
		return schedule.get(0);
	}
	
	public int displayNumberOfMovieInGenre(int genreID) throws SQLException{
		PreparedStatement stmt = conn.prepareStatement("select count(movieID) from genre_movie where genreID=? group by genreID");
		stmt.setInt(1, genreID);
		ResultSet result = stmt.executeQuery();
		int num;
		if(result.next()){
			num = result.getInt(1);
		}else{
			num = 0;
		}
		return num;
	}
	
	public ArrayList<Schedule> displaySchedulesAfterToday(int movieID, java.sql.Date now) throws SQLException{
		PreparedStatement stmt = conn.prepareStatement("select * from schedule where movieID=? and date>=?");
		stmt.setInt(1, movieID);
		stmt.setDate(2, now);
		ResultSet result = stmt.executeQuery();
		ArrayList<Schedule> schedules = retrieveSchedules(result); 
		close(stmt, result);
		return schedules;
	}
	
	
	public ArrayList<TopMovies> displayAllTopMovies(int month, String year) throws SQLException
	{		
		PreparedStatement stmt = conn.prepareStatement("select M.movieTitle 'Movie Name' , sum(B.noTickets) 'Tickets Bought' from booking B, schedule S, movie M where S.scheduleID = B.scheduleID and M.movieID = S.movieID  and Month(S.date)=? and year(S.date)=? group by M.movieTitle order by 2 desc limit 10 ");
		stmt.setInt(1, month);
		stmt.setInt(2, Integer.parseInt(year));
		ResultSet result = stmt.executeQuery();
		ArrayList<TopMovies> topMovies = retrieveTopMovies(result);
		close(stmt,result);
		return topMovies;
	}
	
	public ArrayList<Booking> displayUserBooking(String userID) throws SQLException{
		PreparedStatement stmt = conn.prepareStatement("select * from booking b, schedule s where b.userID=? and b.status='paid' and b.scheduleID=s.scheduleID order by s.date desc, s.timeslot desc");
		stmt.setString(1, userID);
		ResultSet result = stmt.executeQuery();
		ArrayList<Booking> bookings = new ArrayList<>();
		while (result.next()){
			Booking booking = new Booking();
			booking.setBookingID(result.getInt("bookingID"));
			booking.setScheduleID(result.getInt("scheduleID"));
			booking.setUserID(result.getString("userID"));
			booking.setNoTickets(result.getInt("noTickets"));
			booking.setSeatNo(result.getString("seatNo"));
			booking.setStatus(result.getString("status"));
			bookings.add(booking);
		}
		close(stmt, result);
		return bookings;
	}
		
	private ArrayList<Movie> retrieveMovies(ResultSet result) throws SQLException {
		ArrayList<Movie> movies = new ArrayList<Movie>();
		if (result != null){
			while(result.next()){
				Movie movie = new Movie();
				movie.setMovieID(result.getInt("movieID"));
				movie.setMovieTitle(StringEscapeUtils.escapeHtml4((result.getString("movieTitle"))));
				movie.setActorList(result.getString("actorList"));
				SimpleDateFormat format = new SimpleDateFormat("dd MMM yyyy");
				movie.setReleaseDate(format.format(result.getDate("releaseDate")));
				movie.setSynopsis(StringEscapeUtils.escapeHtml4(result.getString("synopsis")));
				movie.setDuration(result.getInt("duration"));
				movie.setStatus(result.getString("status"));
				movies.add(movie);
			}
		}
		return movies;
	}
	
	private ArrayList<Genre> retrieveGenres(ResultSet result) throws SQLException{
		ArrayList<Genre> genres = new ArrayList<Genre>();
		while(result.next()){
			Genre genre = new Genre();
			genre.setGenreID(result.getInt("genreID"));
			genre.setGenreName(result.getString("genreName"));
			genre.setDescription(StringEscapeUtils.escapeHtml4(result.getString("description")));
			genres.add(genre);
		}
		//if empty, returns empty genre ArrayList
		return genres;
	}
	
	private ArrayList<Schedule> retrieveSchedules(ResultSet result) throws SQLException{
		ArrayList<Schedule> schedules = new ArrayList<>();
		while(result.next()){
			Schedule schedule = new Schedule();
			schedule.setScheduleID(result.getInt("scheduleID"));
			schedule.setMovieID(result.getInt("movieID"));
			schedule.setCinemaID(result.getInt("cinemaID"));
			schedule.setDate(new SimpleDateFormat("EEEE dd-MM-yyyy").format(result.getDate("date")));
			schedule.setTimeslot(result.getString("timeslot").substring(0, 5));
			schedule.setTickets(result.getInt("tickets"));
			schedule.setPrice(result.getDouble("price"));
			schedules.add(schedule);
		}
		return schedules;
	}
	
	private ArrayList<TopMovies> retrieveTopMovies(ResultSet result) throws SQLException
	{
		ArrayList<TopMovies> topMovies = new ArrayList<TopMovies>();
		if(result != null) 
		{
			while(result.next()) 
			{
				TopMovies topMovie = new TopMovies();
				topMovie.setMovieName(result.getString("Movie Name"));
				topMovie.setTicketBought(result.getInt("Tickets Bought"));
				topMovies.add(topMovie);
			}
		}
		return topMovies;
	}
	
	private ArrayList<User> retrieveallUsers(ResultSet result) throws SQLException{
		ArrayList<User> allUsers = new ArrayList<User>();
		if(result != null) 
		{
			while(result.next()) 
			{
				User allUser = new User();
				allUser.setUserID(result.getString("userID"));
				allUsers.add(allUser);
			}
		}
		return allUsers;
	}
	
	
	public static void close(Statement stmt, ResultSet result){
		if(stmt != null){
			try { stmt.close(); } catch (Exception e) {e.printStackTrace();}
			stmt = null;
		}
		if(result != null){
			try{ result.close(); } catch (Exception e) { e.printStackTrace();}
			result = null;
		}
	}

	public void close(){
		try{
			conn.close();
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	public static ArrayList<Integer> getRowSpans(ArrayList<Schedule> schedules){
		ArrayList<Integer> result = new ArrayList<>();
		String previousDate = schedules.get(0).getDate();
		int rowSpan = 1;
		//if only 1 schedule for the movie, just add the rowSpan and return
		if (schedules.size() == 1){
			result.add(rowSpan);
		}
		//more than 1 schedule, loop through from the 2nd schedule
		else{
			for(int i = 1; i < schedules.size(); i++){
				if(schedules.get(i).getDate().equals(previousDate)){
					//still the same date
					rowSpan++;
					//if reach last schedule, and it is the same date, must add the date's row span
					if(i == schedules.size() - 1){
						result.add(rowSpan);
					}
				}else{
					//new date
					//append the rowSpan of previousDate to result
					result.add(rowSpan);
					//reset the rowSpan to 1 for new date
					rowSpan = 1;
					//change previousDate to new date
					previousDate = schedules.get(i).getDate();
					if(i == schedules.size() - 1){
						result.add(rowSpan);
					}
				}
			}
			//for last schedule
			//if same as previousDate, must add the current rowSpan value to the result too
		}
		return result;
	}
	
	public static String convertRatingToStars(String rating){
		//make sure you pasted font-awesome script link
		//make sure your css specify a checked class with color orange
		//the string returned can straight away insert into html
		StringBuilder rating_Stars = new StringBuilder();
		if(rating.equals("No Reviews")){
			rating_Stars.append(rating);
		}else{
			int noOfStars = (int)Math.round(Double.parseDouble(rating)/2);
			if (noOfStars == 0) {
				//There are reviews, but after rounding, noOfStars = 0 -> just give a single star for empathy
				rating_Stars.append("<i class='fas fa-star checked'></i>");
				for(int i = 0; i < 4; i++){
					rating_Stars.append("<i class='fas fa-star'></i>");
				}
			}else {
				//noOfStars > 0
				for(int i = 0; i < 5; i++){
					if(noOfStars != 0){
						rating_Stars.append("<i class='fas fa-star checked'></i>");
						noOfStars--;
					}else{
						rating_Stars.append("<i class='fas fa-star'></i>");
					}
				}
			}
		}
		rating = rating_Stars.toString();
		return rating;
	}

	
	public static void main(String [] argv) throws Exception{
		DisplayService displayService = new DisplayService();
		
		/*ArrayList<Schedule> schedules = displayService.displaySchedulesOfMovie(1);
		
		for(Integer i : getRowSpans(schedules)){
			System.out.println(i);
		}
		
		String day;
		String newDay;
		int i = 1;
		System.out.println(schedules.get(i - 1).getDate());
		System.out.print(schedules.get(i - 1).getTimeslot() + " ");
		do{
			day = schedules.get(i - 1).getDate();
			newDay = schedules.get(i).getDate();
			
			if(newDay.equals(day)){
				System.out.print(schedules.get(i).getTimeslot() + " ");
			}
			else{
				System.out.println("\n" + newDay);
				System.out.print(schedules.get(i).getTimeslot() + " ");
			}
			i++;
		}while(i < schedules.size());*/
		
		ArrayList<Movie> movies = displayService.searchMovie("ANLIN");
		for(Movie movie : movies){
			System.out.println(movie.getMovieTitle());
		}
		System.out.println(DisplayService.convertRatingToStars("4.0"));
		
		for(Review review: displayService.displayReviewsOfMovie(1)){
			System.out.println(review.getDate());
		}
		displayService.close();
		/*
		ArrayList<Movie> movies = displayService.displayAllMovie();
		for(Movie movie: movies){
			System.out.println(movie.getMovieID());
			for(String schedule : movie.getSchedules()){
				System.out.println(schedule);
			}
		}
		
		ArrayList<Genre> genres = displayService.displayMovie_Genres(1);
		for (Genre genre: genres){
			System.out.println(genre.getGenreName());
		}
		
		ArrayList<Movie> movies = displayService.searchMovie("");
		for (Movie movie: movies){
			System.out.println(movie.getMovieTitle());
		}
		
		ArrayList<Review> movies = displayService.displayMovie_Reviews(1);
		for (Review movie: movies){
			System.out.println(movie.getName());
			System.out.println(movie.getRating());
			System.out.println(movie.getComments());
		}*/
	}
}
