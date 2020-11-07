package service;

import java.util.ArrayList;

import javax.servlet.http.HttpSessionBindingEvent;
import javax.servlet.http.HttpSessionBindingListener;

import com.sun.xml.internal.ws.org.objectweb.asm.Type;

import java.sql.*;
import dto.Booking;

public class CartService implements HttpSessionBindingListener{
	
	private ArrayList<Booking> cart;
	
	public CartService(){
		cart = new ArrayList<Booking>();
	}
	
	public int addBooking(int scheduleID, String userID, int noTickets){
		
		Connection conn = null;
		CallableStatement stmt = null;
		ResultSet result = null;
		try{
			conn = DBConnection.getConnection();
			//set AutoCommit to false -> Prevent Race Condition
			conn.setAutoCommit(false);
			stmt = conn.prepareCall("{call addBooking(?,?,?,?,?)}");
			//addBooking(scheduleID, userID, noTickets, id, balance)
			//This stored procedure insert the booking into booking table
			//Then update the schedule table to minus the noTickets away from the schedule
			//And select the last_inserted_id and the latest number of tickets for the schedule
			//In case 2 people reach this method together, and tickets not enough, the later 1 will cause ticket to be negative
			//the later person's stored procedure will get rollback
			stmt.setInt(1, scheduleID);
			stmt.setString(2, userID);
			stmt.setInt(3, noTickets);
			//Register latest inserted id as OUT parameter
			stmt.registerOutParameter(4, Type.INT);
			//Register latest balance of schedule as OUT parameter
			stmt.registerOutParameter(5, Type.INT);
			stmt.execute();
			//Check if the latest balance < 0	
			int ticketBalance = stmt.getInt(5); 
			if(ticketBalance >= 0){
				//Balance 0 or more, commit the stored procedure
				conn.commit();
				//Store the booking in user's cart
				Booking booking = new Booking();
				int bookingID = stmt.getInt(4);
				booking.setBookingID(bookingID);
				booking.setScheduleID(scheduleID);
				booking.setUserID(userID);
				booking.setNoTickets(noTickets);
				//Set the booking's status to on hold, haven't paid yet
				booking.setStatus("hold");
				//Add the new booking to user's shopping cart
				cart.add(booking);
				return bookingID;
			}else{
				//Balance < 0, roll back the stored procedure
				conn.rollback();
				return 0;
			}
			}catch (Exception e){
				e.printStackTrace();
				//always try to roll back if any error occurs
				try {conn.rollback();} catch (SQLException e1) {e1.printStackTrace();}
				//Return 0 to signify adding failed
				return 0;
			}finally{
				close(conn, stmt, result);
			}
	}
	
	public boolean addSeatToBooking(int bookingID, String[] selectedSeats) {
		String seats = String.join(",", selectedSeats);
		Connection conn = null;
		PreparedStatement stmt = null;
		try{
			conn = DBConnection.getConnection();
			stmt = conn.prepareStatement("update booking set seatNo=? where bookingID=?");
			stmt.setString(1, seats);
			stmt.setInt(2, bookingID);
			int rowsAffected = stmt.executeUpdate();
			if (rowsAffected == 1){
				//update booking in shopping cart
				this.getBooking(bookingID).setSeatNo(seats);
				return true;
			}else{
				throw new Exception();
			}
		}catch (Exception e){
			e.printStackTrace();
			return false;
		}finally{
			close(conn, stmt, null);
		}
	}
		
	public boolean checkScheduleTickets(int scheduleID, int qty){
		Connection conn = null;
		PreparedStatement stmt = null;
		ResultSet result = null;
		try{
			conn = DBConnection.getConnection();
			stmt = conn.prepareStatement("select tickets from schedule where scheduleID=?");
			stmt.setInt(1, scheduleID);
			result = stmt.executeQuery();
			if (result.next()){
				return result.getInt("tickets") >= qty;
			}else{
				return false;
			}
		}catch (Exception e){
			e.printStackTrace();
			return false;
		}finally{
			close(conn, stmt, result);
		}
	}
	
	public boolean checkout(){
		Connection conn = null;
		PreparedStatement stmt = null;
		boolean success = true;
		try{
			conn = DBConnection.getConnection();
			conn.setAutoCommit(false);
			stmt = conn.prepareStatement("update booking set status='paid' where bookingID=?");
			for(Booking booking : cart){
				stmt.setInt(1, booking.getBookingID());
				success = stmt.executeUpdate() == 1;
				if(!success){
					//something went wrong, break the loop and return false
					return success;
				}
			}
			//all bookings updated, commit the statements
			conn.commit();
		}catch(Exception e){
			e.printStackTrace();
			success = false;
		}finally{
			try {
				//if not successful, roll back the updates before closing
				if (!success){
					//if result in Exception here, means haven't get a connection or setAutoCommit(false) never executed
					conn.rollback();
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}
			close(conn,stmt,null);
		}
		//code reach here, all bookings have been updated
		//remove the bookings the cart
		if (success){
			cart.clear();
		}
		return success;
	}
	
	public boolean deleteBooking(int bookingID, int scheduleID, int noTickets){
		boolean result;
		Connection conn = null;
		CallableStatement stmt = null;
		try{
			conn = DBConnection.getConnection();
			stmt = conn.prepareCall("{call deleteBooking(?,?,?)}");
			stmt.setInt(1, bookingID);
			stmt.setInt(2, scheduleID);
			stmt.setInt(3, noTickets);
			stmt.execute();
			result = true;
		}catch (Exception e){
			e.printStackTrace();
			result = false;
		}finally{
			close(conn, stmt, null);
		}
		//if result = true, successfully removed booking from database
		if (result){
			//remove the booking from user's cart too
			for(int i = 0; i < cart.size(); i++){
				if (cart.get(i).getBookingID() == bookingID){
					cart.remove(i);
				}
			}
		}
		return result;
	}
	
	public Booking getBooking(int bookingID){
		for (Booking booking : cart){
			if (booking.getBookingID() == bookingID){
				return booking;
			}
		}
		return null;
	}
	
	public ArrayList<Booking> getCart(){
		return cart;
	}
	
	public ArrayList<String> getOccupiedSeats(int scheduleID){
		Connection conn = null;
		PreparedStatement stmt = null;
		ResultSet result = null;
		ArrayList<String> seats = new ArrayList<>();
		try{
			conn = DBConnection.getConnection();
			stmt = conn.prepareStatement("select seatNo from booking where scheduleID=? and seatNo is not null");
			stmt.setInt(1, scheduleID);
			result = stmt.executeQuery();
			while(result.next()){
				for(String seat : result.getString("seatNo").split(",")){
					seats.add(seat);
				}
			}
		}catch (Exception e){
			e.printStackTrace();
		}finally{
			close(conn, stmt, result);
		}
		return seats;
	}
	
	public int getTicketsOnHold(int scheduleID){
		Connection conn = null;
		PreparedStatement stmt = null;
		ResultSet result = null;
		try{
			conn = DBConnection.getConnection();
			stmt = conn.prepareStatement("select sum(noTickets) from booking where scheduleID=? and status='hold'");
			stmt.setInt(1, scheduleID);
			result = stmt.executeQuery();
			result.next();
			return result.getInt(1);
		}catch (Exception e){
			e.printStackTrace();
			return -1;
		}finally{
			close(conn, stmt, result);
		}
	}
	
	public double getTotalPayable(){
		double amt = 0;
		DisplayService display = new DisplayService();
		for (Booking booking : cart){
			try {
				amt += booking.getNoTickets() * display.displaySchedule(booking.getScheduleID()).getPrice();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		display.close();
		return amt;
	}
	
	public boolean isEmpty(){
		return cart.isEmpty();
	}
	
	public boolean isAllSeatsSelected(){
		//ALl the bookings in the cart must have seats selected
		for (Booking booking : cart){
			if (booking.getSeatNo() == null){
				return false;
			}
		}
		//cart is ready to checkout
		return true;
	}
	
	@Override
	public void valueUnbound(HttpSessionBindingEvent event){
		//After placing the cart inside a user's session
		//Whenever cart is unbounded from the session
		//3 Scenerios: the session expires, session is being invalidated() or the cart attribute is being removed from the session
		//this method will get called
		//Can use to remove all unpaid booking inside user's shopping cart and remove the reservation for the ticket
		Connection conn = null;
		CallableStatement stmt = null;
		try{
			conn = DBConnection.getConnection();
			stmt = conn.prepareCall("{call deleteBooking(?,?,?)}");
			for(Booking booking : cart){
				stmt.setInt(1, booking.getBookingID());
				stmt.setInt(2, booking.getScheduleID());
				stmt.setInt(3, booking.getNoTickets());
				stmt.execute();
			}
		}catch (Exception e){
			e.printStackTrace();
		}finally{
			close(conn, stmt, null);
		}
		//set cart to null because this method will get called 3 times when user logout which cause session.invalidate()
		//session invalidated, at same time, it expired, and cart is unbounded from session
		//set cart to null when it is called the first time
		cart = null;
	}
	
	private void close(Connection conn, Statement stmt, ResultSet result){
		try{
			if(conn != null){
				//Due to the usage of connection pool -> closing a connection is returning it to the pool
				//Always set the autocommit back to true as a safe net
				conn.setAutoCommit(true);
				conn.close();
			}
			if(stmt != null){
				stmt.close();
			}
			if(result != null){
				result.close();
			}
		}catch (Exception e){
			e.printStackTrace();
		}
	}
	
	public static void main(String[] args) {
		ArrayList<String> occupiedSeat = new ArrayList<>();

		/*String [] selectedSeat = {"A10", "A11"};
		
		for (String seat : selectedSeat){
			System.out.println(occupiedSeat.contains(seat));
		}*/
		
		System.out.println("J9".matches("^[A-J]([1-9]|1[0-9]|20)$"));
	}

	

}
