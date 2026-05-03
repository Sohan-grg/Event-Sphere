package controller;

import exception.DuplicateAccountException;
import exception.ValidationException;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import service.UserService;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/register")
public class RegisterController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final String REGISTER_JSP = "/WEB-INF/Pages/register.jsp";

    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher(REGISTER_JSP).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullName = request.getParameter("fullName");
        String email    = request.getParameter("email");
        String password = request.getParameter("password");
        String role     = request.getParameter("role");
        String terms    = request.getParameter("terms");

        try {
            if (terms == null || !"true".equalsIgnoreCase(terms)) {
                throw new ValidationException(
                        "You must accept the Terms of Service to register.");
            }

            userService.register(fullName, email, password, role);

            HttpSession session = request.getSession();
            session.setAttribute("successMessage",
                    "Registration successful! Please log in.");
            response.sendRedirect(request.getContextPath() + "/login");

        } catch (ValidationException ve) {
            forwardWithError(request, response, ve.getMessage());

        } catch (DuplicateAccountException dae) {
            forwardWithError(request, response, dae.getMessage());

        } catch (SQLException se) {
            se.printStackTrace();
            forwardWithError(request, response,
                    "Database error. Please try again in a moment.");

        } catch (Exception e) {
            e.printStackTrace();
            forwardWithError(request, response,
                    "An unexpected error occurred. Please try again.");
        }
    }

    private void forwardWithError(HttpServletRequest request,
                                   HttpServletResponse response,
                                   String message)
            throws ServletException, IOException {
        request.setAttribute("errorMessage", message);
        RequestDispatcher rd = request.getRequestDispatcher(REGISTER_JSP);
        rd.forward(request, response);
    }
}