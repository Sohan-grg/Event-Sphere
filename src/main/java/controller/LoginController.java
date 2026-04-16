package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import config.DatabaseConfig;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/login")
public class LoginController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // Show login page
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/Pages/login.jsp").forward(request, response);
    }

    // Handle login form submission
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullName = request.getParameter("fullName");
        String password = request.getParameter("password");

        try {
            Connection conn = DatabaseConfig.getConnection();

            // ✅ Also fetch ROLE and ID
            String sql = "SELECT * FROM User WHERE `FULL NAME` = ? AND `PASSWORD` = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, fullName);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                String role = rs.getString("SELECT ROLE");

                // ✅ CREATE SESSION
                HttpSession session = request.getSession();
                session.setAttribute("fullName", fullName);
                session.setAttribute("role", role);

                // ✅ ROLE-BASED REDIRECT
                if (role.equalsIgnoreCase("organizer")) {
                    response.sendRedirect(request.getContextPath() + "/organizerDashboard");
                } else {
                    response.sendRedirect(request.getContextPath() + "/home");
                }

            } else {
                request.setAttribute("errorMessage", "Invalid name or password.");
                request.getRequestDispatcher("/WEB-INF/Pages/login.jsp").forward(request, response);
            }

            rs.close();
            ps.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/Pages/login.jsp").forward(request, response);
        }
    }
}