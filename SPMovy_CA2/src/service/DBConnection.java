package service;

import java.sql.*;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class DBConnection {
	
	/*public static Connection getConnection() throws Exception{
		//Retrieve db user and password from a file. Do not store in source code
		Properties props = new Properties();
		InputStream dbProperties = DBConnection.class.getResourceAsStream("database.properties");
		props.load(dbProperties);
		//retrieve db username, password and connection url
		String dbUser = props.getProperty("user");
		String dbPassword = props.getProperty("password");
		String dburl = props.getProperty("dburl");
		dbProperties.close();
		Class.forName("com.mysql.jdbc.Driver");
		Connection conn = DriverManager.getConnection(dburl, dbUser, dbPassword);
		return conn;
	}*/
	
	public static Connection getConnection(){
		Connection conn = null;
		try{
			//Get the context of your Web Application
			Context context = new InitialContext();
			//Look up for the Resource specified in context.xml
			//java:comp/env/ is fixed which is followed by the JNDI name
			DataSource ds = (DataSource)context.lookup("java:comp/env/jdbc/assignment");
			//Get a connection from the connection pool
			conn = ds.getConnection();
		}catch (Exception e){
			e.printStackTrace();
		}
		return conn;
	}

}
