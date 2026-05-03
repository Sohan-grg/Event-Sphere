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
 * "Forgot password" entry point. The user enters their email; we generate a
 * one-time reset token and surface a reset link on the next page.
 */
@WebServlet("/forgot")
public class ForgotPasswordController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final String FORGOT_JSP = "/WEB-INF/Pages/forgotPassword.jsp";

    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher(FORGOT_JSP).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = Validator.safeTrim(request.getParameter("email"));

        try {
            String token = userService.createResetToken(email);

            // In production this URL would be sent by email; we display it on
            // the page so the user can continue the demo without SMTP setup.
            String resetLink = request.getContextPath() + "/reset?token=" + token;

            request.setAttribute("submittedEmail", email);
            request.setAttribute("resetLink",      resetLink);
            request.setAttribute("step",           "sent");
            request.getRequestDispatcher(FORGOT_JSP).forward(request, response);

        } catch (ValidationException ve) {
            request.setAttribute("errorMessage", ve.getMessage());
            request.setAttribute("submittedEmail", email);
            request.getRequestDispatcher(FORGOT_JSP).forward(request, response);

        } catch (SQLException se) {
            se.printStackTrace();
            request.setAttribute("errorMessage", "Database error. Please try again later.");
            request.getRequestDispatcher(FORGOT_JSP).forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Unexpected error. Please try again.");
            request.getRequestDispatcher(FORGOT_JSP).forward(request, response);
        }
    }
}