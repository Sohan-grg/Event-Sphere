package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import config.DatabaseConfig;


@WebServlet("/studentServlet")
public class databaseController extends HttpServlet {
    
    private static final long serialVersionUID = 1L;

	@Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Set content type for response
        response.setContentType("text/html");
        
        PrintWriter out = response.getWriter();
        Connection conn = null;
        
        try {
            
            conn = DatabaseConfig.getConnection();
            
            if (conn == null) {
                out.println("DB Connection Failed");
                return;
            }
            
         // Query to fetch student records
            String query = "SELECT * FROM students";
            PreparedStatement ps = conn.prepareStatement(query);
            ResultSet rs = ps.executeQuery();
            
            // Loop through the result set and print student details
            while (rs.next()) {
                out.println("ID: " + rs.getInt("id") + "<br>");
                out.println("Name: " + rs.getString("first_name") + "<br>");
                out.println("----------------------<br>");
            }
            
            // Clean up resources
            rs.close();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
            out.println("Error: " + e.getMessage());
        } finally {
            // Close the connection if it was opened
            try {
                if (conn != null) {
                    conn.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        out.println("Extra");
        response.getWriter().append("Served at: ").append(request.getContextPath());
    }
}