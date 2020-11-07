package service;

import java.sql.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;

import dto.Genre;
import dto.Movie;
import dto.Review;

public class ManageService {
	
	private Connection conn;
	
	public ManageService(){
		conn = DBConnection.getConnection();
	}
	
	public int addGenre(Genre genre) throws SQLException{
		CallableStatement stmt = conn.prepareCall("{call addGenre(?,?)}");
		stmt.setString(1, genre.getGenreName());
		stmt.setString(2, genre.getDescription());
		
		ResultSet result = stmt.executeQuery();
		if(result.next()){
			int genreID = result.getInt(1); 
			close(stmt, result);
			return genreID;
		}else{
			//no genre with such name
			close(stmt, result);
			return 0;
		}
	}
	
	public boolean updateGenre(int genreID, String genreName, String description) throws SQLException{
		PreparedStatement stmt = conn.prepareStatement("update genre set genreName=?,description=? where genreID=?");
		stmt.setString(1, genreName);
		stmt.setString(2, description);
		stmt.setInt(3, genreID);
		int rowsAffected = stmt.executeUpdate();
		close(stmt, null);
		return rowsAffected == 1; 
	}
	
	public boolean addMovieToGenre(int movieID, int genreID) throws SQLException{
		PreparedStatement stmt = conn.prepareStatement("insert into genre_movie (genreID,movieID) values (?,?)");
		stmt.setInt(1, genreID);
		stmt.setInt(2, movieID);
		int rowsAffected = stmt.executeUpdate();
		close(stmt, null);
		return rowsAffected == 1; 
	}
	
	public boolean deleteGenre_Movie(int genreID, int movieID) throws SQLException{
		PreparedStatement stmt = conn.prepareStatement("delete from genre_movie where genreID=? and movieID=?");
		stmt.setInt(1, genreID);
		stmt.setInt(2, movieID);
		int rowsAffected = stmt.executeUpdate();
		close(stmt, null);
		return rowsAffected == 1; 
	}
	
	public boolean deleteGenre(int genreID) throws SQLException{
		PreparedStatement stmt = conn.prepareStatement("delete from genre where genreID=?");
		stmt.setInt(1, genreID);
		int rowsAffected = stmt.executeUpdate();
		close(stmt, null);
		return rowsAffected == 1;
	}
	
	public boolean deleteMovie(int movieID) throws SQLException {
		PreparedStatement stmt = conn.prepareStatement("delete from movie where movieID=?");
		stmt.setInt(1, movieID);
		int rowsAffected = stmt.executeUpdate();
		close(stmt, null);
		return rowsAffected == 1;
	}
	
	public int addMovie(Movie movie) throws SQLException{
		CallableStatement stmt = conn.prepareCall("{call addMovie(?,?,?,?,?,?)}");
		stmt.setString(1, movie.getMovieTitle());
		stmt.setString(2, movie.getActorList());
		stmt.setString(3, movie.getReleaseDate());
		stmt.setString(4, movie.getSynopsis());
		stmt.setInt(5, movie.getDuration());
		stmt.setString(6, movie.getStatus());
		
		ResultSet result = stmt.executeQuery();
		if(result.next()){
			int movieID = result.getInt(1);
			close(stmt, result);
			return movieID;
		}else{
			close(stmt, result);
			return 0;
		}
	}
	
	public boolean updateMovie(Movie movie, int movieID) throws SQLException{
		PreparedStatement stmt = conn.prepareStatement("update movie set movieTitle=?,actorList=?,releaseDate=?,synopsis=?,duration=?,status=? "
				+ "where movieID=? ");
		stmt.setString(1, movie.getMovieTitle());
		stmt.setString(2, movie.getActorList());
		stmt.setString(3, movie.getReleaseDate());
		stmt.setString(4, movie.getSynopsis());
		stmt.setInt(5, movie.getDuration());
		stmt.setString(6, movie.getStatus());
		stmt.setInt(7, movieID);
		
		int rowsAffected = stmt.executeUpdate();
		close(stmt,null);
		return rowsAffected == 1;
	}
	
	public void addScheduleToMovie(int movieID, int cinemaID, String date, String timeslot, double price) throws SQLException{
		PreparedStatement statement = conn.prepareStatement("select * from schedule where movieID=? and cinemaID=? and date=? and timeslot=?");
		statement.setInt(1, movieID);
		statement.setInt(2, cinemaID);
		statement.setString(3, date);
		statement.setString(4, timeslot);
		ResultSet result = statement.executeQuery();
		if (result.next()){
			//schedule already exist
			close(statement, result);
			throw new com.mysql.jdbc.exceptions.jdbc4.MySQLIntegrityConstraintViolationException();
		}else{
			PreparedStatement stmt = conn.prepareStatement("insert into schedule (movieID,cinemaID,date,timeslot,price) values (?,?,?,?,?)");
			stmt.setInt(1, movieID);
			stmt.setInt(2, cinemaID);
			stmt.setString(3, date);
			stmt.setString(4, timeslot);
			stmt.setDouble(5, price);
			stmt.executeUpdate();
			close(statement, result);
			close(stmt, null);
		}
	}
	
	public boolean deleteSchedule(int scheduleID) throws SQLException{
		PreparedStatement stmt = conn.prepareStatement("delete from schedule where scheduleID=?");
		stmt.setInt(1, scheduleID);
		int rowsAffected = stmt.executeUpdate();
		close(stmt, null);
		return rowsAffected == 1;
	}
	
	public boolean updateScheduleTickets(int scheduleID, int tickets) throws SQLException {
		PreparedStatement stmt = conn.prepareStatement("update schedule set tickets=? where scheduleID=?");
		stmt.setInt(1, tickets);
		stmt.setInt(2, scheduleID);
		int rowsAffected = stmt.executeUpdate();
		close(stmt, null);
		return rowsAffected == 1;
	}
	
	public boolean updateSchedulePrice(int scheduleID, double price) throws SQLException {
		PreparedStatement stmt = conn.prepareStatement("update schedule set price=? where scheduleID=?");
		stmt.setDouble(1, price);
		stmt.setInt(2, scheduleID);
		int rowsAffected = stmt.executeUpdate();
		close(stmt, null);
		return rowsAffected == 1;
	}
	
	public void deleteReview(int reviewID) throws SQLException{
		PreparedStatement stmt = conn.prepareStatement("delete from review where reviewID=?");
		stmt.setInt(1, reviewID);
		stmt.executeUpdate();
		close(stmt, null);
	}
	
	public boolean addReview(Review review) throws SQLException{
		PreparedStatement stmt = conn.prepareStatement("insert into review (name,rating,comments,movieID) values (?,?,?,?)");
		stmt.setString(1, review.getName());
		stmt.setDouble(2, review.getRating());
		stmt.setString(3, review.getComments());
		stmt.setInt(4,review.getMovieID());
		
		int rowsAffected = stmt.executeUpdate();
		close(stmt, null);
		return rowsAffected == 1;
	}
	
	/*public void addMovieImage(String filename, int movieID) throws SQLException{
		PreparedStatement stmt = conn.prepareStatement("update movie set imageURL=? where movieID=?");
		stmt.setString(1, filename);
		stmt.setInt(2, movieID);
		stmt.executeUpdate();
		close(stmt,null);
	}*/
	
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
		}catch (SQLException e){
			e.printStackTrace();
		}
	}
	
	public static String convertDateString(String wrong){
		//wrong = 05/02/2018 from datepicker MM-dd-yyyy
		//SQL only accepts YYYY-MM-DD
		StringBuilder correct = new StringBuilder();
		correct.append(wrong.substring(6, 10));
		correct.append('-');
		correct.append(wrong.substring(0,2));
		correct.append('-');
		correct.append(wrong.substring(3,5));
		return correct.toString();
	}
	
	public static String convertScheduleDate(String wrong){
		//wrong = 01/05/2018 (Schedule's Date formatted as dd-MM-yyyy)
		//Convert to SQL accepted format
		StringBuilder correct = new StringBuilder();
		correct.append(wrong.substring(6, 10));
		correct.append('-');
		correct.append(wrong.substring(3,5));
		correct.append('-');
		correct.append(wrong.substring(0,2));
		return correct.toString();
	}
	
	public static String convertUpdateMovieDate(String wrong){
		//Movie's release date formatted as dd MMM yyyy
		//Convert it to datepicker format, in case the user did not update the release date
		SimpleDateFormat format = new SimpleDateFormat("dd MMM yyyy");
		try {
			java.util.Date date = format.parse(wrong);
			return new SimpleDateFormat("MM/dd/yyyy").format(date);
		} catch (ParseException e) {
			e.printStackTrace();
			return "";
		}
	}
	
	public static String processActorList(String actorList){
		StringBuilder result = new StringBuilder();
		String [] actors = actorList.split(",");
		for(int i = 0; i < actors.length; i++){
			String tmp = actors[i].trim();
			result.append(tmp);
			if(i != (actors.length - 1)) result.append(", ");
		}
		return result.toString();
	}

	public static void main(String[] args) {
		System.out.println(convertUpdateMovieDate("13 May 2018"));
	}

	

	

	

	

}
