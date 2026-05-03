package controller;

import exception.ValidationException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import service.UserService;
import util.Validator;

import java.io.IOException;
import java.sql.SQLException;

/**
 * Validates the reset token from the URL, lets the user enter a new password,
 * and applies the change. The token is single-use and expires after the TTL
 * configured in {@link UserService}.
 */
@WebServlet("/reset")
public class ResetPasswordController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final String RESET_JSP = "/WEB-INF/Pages/resetPassword.jsp";

    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String token = Validator.safeTrim(request.getParameter("token"));

        try {
            String email = userService.findEmailForToken(token);
            if (email == null) {
                request.setAttribute("errorMessage",
                        "This reset link is invalid or has expired.");
                request.setAttribute("invalid", true);
            } else {
                request.setAttribute("token", token);
                request.setAttribute("email", email);
            }
        } catch (SQLException se) {
            se.printStackTrace();
            request.setAttribute("errorMessage",
                    "Database error. Please try again later.");
            request.setAttribute("invalid", true);
        }

        request.getRequestDispatcher(RESET_JSP).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String token    = Validator.safeTrim(request.getParameter("token"));
        String pw       = request.getParameter("password");
        String confirm  = request.getParameter("confirmPassword");

        try {
            userService.resetPassword(token, pw, confirm);

            HttpSession session = request.getSession();
            session.setAttribute("successMessage",
                    "Password updated. Please log in with your new password.");
            response.sendRedirect(request.getContextPath() + "/login");

        } catch (ValidationException ve) {
            request.setAttribute("errorMessage", ve.getMessage());
            request.setAttribute("token", token);
            // Keep the email visible if the token is still valid.
            try {
                String email = userService.findEmailForToken(token);
                if (email != null) request.setAttribute("email", email);
                else request.setAttribute("invalid", true);
            } catch (SQLException ignore) {}
            request.getRequestDispatcher(RESET_JSP).forward(request, response);

        } catch (SQLException se) {
            se.printStackTrace();
            request.setAttribute("errorMessage",
                    "Database error. Please try again later.");
            request.setAttribute("token", token);
            request.getRequestDispatcher(RESET_JSP).forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage",
                    "Unexpected error. Please try again.");
            request.setAttribute("token", token);
            request.getRequestDispatcher(RESET_JSP).forward(request, response);
        }
    }
}