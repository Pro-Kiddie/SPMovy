package service;

import java.sql.*;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.spec.InvalidKeySpecException;

import dto.User;

public class LoginService {
	
	private Connection conn;
	
	public LoginService(){
		conn = DBConnection.getConnection();
	}
	
	public boolean authenticate(String userID, String passwd) throws SQLException, NoSuchAlgorithmException, InvalidKeySpecException{
		PreparedStatement stmt = conn.prepareStatement("select password from user where userID=?");
		stmt.setString(1, userID);
		ResultSet result = stmt.executeQuery();
		if(!result.next()){
			//userID does not exist in the database
			close(stmt,result);
			return false;
		}
		else{
			String storedPasswd = result.getString("password");
			close(stmt, result);
			return validatePassword(passwd, storedPasswd);
		}
	}
	
	public User getUserDetails(String userID) throws SQLException{
		PreparedStatement stmt = conn.prepareStatement("select * from user where userID=?");
		stmt.setString(1, userID);
		ResultSet result = stmt.executeQuery();
		result.next();
		User user = new User();
		user.setUserID(result.getString("userID"));
		user.setRole(result.getString("role"));
		user.setfName(result.getString("fName"));
		user.setlName(result.getString("lName"));
		user.setEmail(result.getString("email"));
		user.setContact(result.getString("contact"));
		user.setCc(result.getString("cc"));
		close(stmt, result);
		return user;
	}
	
	public boolean uniqueUserID(String userID) throws SQLException{
		PreparedStatement stmt = conn.prepareStatement("select userID from user where userID=?");
		stmt.setString(1, userID);
		ResultSet result = stmt.executeQuery();
		if(result.next()){
			close(stmt, result);
			return false;
		}else{
			close(stmt, result);
			return true;
		}
	}
	
	public boolean addUser(User user) throws SQLException{
		PreparedStatement stmt = conn.prepareStatement("insert into user values (?,?,?,?,?,?,?,?)");
		stmt.setString(1, user.getUserID());
		stmt.setString(2, user.getPasswd());
		stmt.setString(3, user.getRole());
		stmt.setString(4, user.getfName());
		stmt.setString(5, user.getlName());
		stmt.setString(6, user.getEmail());
		stmt.setString(7, user.getContact());
		stmt.setString(8, user.getCc());
		
		int rowsAffected = stmt.executeUpdate();
		close(stmt, null);
		return rowsAffected == 1;
	}
	
	public boolean changePasswd(String userID, String passwd) throws SQLException{
		PreparedStatement stmt = conn.prepareStatement("update user set password=? where userID=?");
		stmt.setString(1, passwd);
		stmt.setString(2, userID);
		int rowsAffected = stmt.executeUpdate();
		close(stmt, null);
		return rowsAffected == 1;
	}
	
	public boolean updateUserParticulars(User user) throws SQLException{
		PreparedStatement stmt = conn.prepareStatement("update user set fName=?,lName=?,email=?,contact=?,cc=? where userID=? ");
		stmt.setString(1, user.getfName());
		stmt.setString(2, user.getlName());
		stmt.setString(3, user.getEmail());
		stmt.setString(4, user.getContact());
		stmt.setString(5, user.getCc());
		stmt.setString(6, user.getUserID());
		int rowsAffected = stmt.executeUpdate();
		close(stmt, null);
		return rowsAffected == 1;
	}
	
	public void close(){
		try{
			conn.close();
		}catch (SQLException e ){
			e.printStackTrace();
		}
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
	
	public static String getHash(String passwd) throws NoSuchAlgorithmException, InvalidKeySpecException{
		int iterations = 1000;
		int keyLength = 64 * 8; //final hash will be 64 * 8 bytes = 64 characters = 128 hex digits
		char[] passwdChars = passwd.toCharArray();
		byte[] salt = getSalt();
		
		PBEKeySpec spec = new PBEKeySpec(passwdChars, salt, iterations, keyLength);
		SecretKeyFactory skf = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA1");
		byte[] hash = skf.generateSecret(spec).getEncoded();
		return iterations + ":" + toHex(salt) + ":" + toHex(hash);
	}
	
	public static boolean validatePassword(String passwd, String storedPasswd) throws NoSuchAlgorithmException, InvalidKeySpecException{
		//Retrieve the iterations, salt from stored password
		String[] parts = storedPasswd.split(":");
		int iterations = Integer.parseInt(parts[0]);
		byte[] salt = fromHex(parts[1]);
		byte[] hash = fromHex(parts[2]);
		
		//Generate new hash based on input using the same spec
		PBEKeySpec spec = new PBEKeySpec(passwd.toCharArray(), salt, iterations, hash.length * 8);
		SecretKeyFactory skf = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA1");
		byte[] hashInput = skf.generateSecret(spec).getEncoded();
		
		//Compare the two hash using bitwise operations
		int diff = hash.length ^ hashInput.length;
		//The 2 hash arrays should have the same length
		//XOR same value should return 0 -> set the flag in diff
		
		for(int i = 0; i < hash.length && i < hashInput.length; i++){
			diff = diff | (hash[i] ^ hashInput[i]);
			//XOR each byte in the two arrays
			//set the flag in diff if (hash[i] ^ hashInput[i]) returns 1 
		}
		return diff == 0;
	}
	
	public static byte[] getSalt() throws NoSuchAlgorithmException{
		SecureRandom sr = SecureRandom.getInstance("SHA1PRNG");
		byte[] salt = new byte[16];
		sr.nextBytes(salt);
		return salt;
	}
	
	public static String toHex(byte[] array){
		//Use BigInteger to represent the number represented by array
		BigInteger bi = new BigInteger(1, array);
		//Represent the BigInteger as hex
		String hex = bi.toString(16);
		//In case the String hex has 0 in front, the leading 0s will be gone
		//Must be padded with 0s
		int paddingLength = (array.length * 2) - hex.length();
		if (paddingLength > 0){
			return String.format("%0" + paddingLength + "d", 0) + hex;
		}else{
			return hex;
		}
	}
	
	public static byte[] fromHex(String hex){
		//2 hex digit is 1 byte
		byte[] bytes = new byte[hex.length()/2];
		for(int i = 0; i < bytes.length; i++){
			bytes[i] = (byte)Integer.parseInt(hex.substring(i * 2, i * 2 + 2), 16);
		}
		return bytes;
	}
	
	public static String formatName(String name){
		String[] nameParts = name.trim().split(" ");
		for (int i = 0; i < nameParts.length; i++){
			String part = nameParts[i];
			part = part.substring(0, 1).toUpperCase();
			if (nameParts[i].length() > 1){
				part = part + nameParts[i].substring(1);
			}
			nameParts[i] = part;
		}
		return String.join(" ", nameParts);
	}
	
	public static void main(String[] args) throws Exception {
		
		System.out.println(getHash("test"));
	}
	

}
