package config;

import java.sql.Connection;
import java.sql.DriverManager;

public class DatabaseConfig {
	private static final String DB_NAME = "User";
	private static final String URL = "jdbc:mysql://127.0.0.1:3306/"+DB_NAME;
    private static final String USER = "root";
    private static final String PASSWORD = "";

    public static Connection getConnection() {
        Connection conn = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("Database Connected!");
        } catch (Exception e) {
            e.printStackTrace();
        }

        return conn;
    }
}