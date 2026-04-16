package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.RequestDispatcher;
import java.sql.Connection;
import java.sql.PreparedStatement;
import config.DatabaseConfig;
import java.io.IOException;

@WebServlet("/register")
public class RegisterController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/Pages/register.jsp");
        rd.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // Get form parameters
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        // Basic validation to ensure no fields are left empty
        if (fullName == null || email == null || password == null || role == null) {
            request.setAttribute("error", "Please fill in all the fields.");
            RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/Pages/register.jsp");
            rd.forward(request, response);
            return;
        }

        try {
            // Establish database connection
            Connection conn = DatabaseConfig.getConnection();

            // SQL query to insert user details into the database
            String sql = "INSERT INTO User(`FULL NAME`, `EMAIL ADDRESS`, `PASSWORD`, `SELECT ROLE`) VALUES (?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, fullName);
            ps.setString(2, email);
            ps.setString(3, password);  // Consider hashing the password before storing
            ps.setString(4, role);

            // Execute the update
            ps.executeUpdate();

            // Redirect to login page after successful registration
            response.sendRedirect("login");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred during registration. Please try again.");
            RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/Pages/register.jsp");
            rd.forward(request, response);
        }
    }
}