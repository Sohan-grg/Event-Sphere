package controller;

import exception.ValidationException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import service.UserService;
import util.Validator;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/login")
public class LoginController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final String LOGIN_JSP = "/WEB-INF/Pages/login.jsp";

    /** Lock the account after this many consecutive failures. */
    private static final int MAX_FAILED_ATTEMPTS = 5;

    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher(LOGIN_JSP).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullName = Validator.safeTrim(request.getParameter("fullName"));
        String password = request.getParameter("password");
        String selRole  = Validator.safeTrim(request.getParameter("role")).toLowerCase();

        HttpSession session = request.getSession();

        try {
            if (Validator.isEmpty(fullName) || Validator.isEmpty(password)) {
                throw new ValidationException("Please enter both name and password.");
            }

            if (Validator.isEmpty(selRole) ||
                !(selRole.equals("attendee") || selRole.equals("organizer"))) {
                throw new ValidationException("Please choose an access role.");
            }

            // Check the lock counter held in the session.
            Integer attempts = (Integer) session.getAttribute("failedAttempts");
            if (attempts != null && attempts >= MAX_FAILED_ATTEMPTS) {
                throw new ValidationException(
                        "Too many failed attempts. Please wait and try again later.");
            }

            String role = userService.authenticate(fullName, password);

            if (role == null) {
                int next = (attempts == null ? 0 : attempts) + 1;
                session.setAttribute("failedAttempts", next);
                throw new ValidationException("Invalid name or password.");
            }

            // ── Role gate ──────────────────────────────────────────────
            // Organizer tile → must be an organizer account.
            // Attendee  tile → must NOT be an organizer (covers attendee + vendor).
            String actualRole = role.trim().toLowerCase();
            boolean ok =
                    (selRole.equals("organizer") && actualRole.equals("organizer")) ||
                    (selRole.equals("attendee")  && !actualRole.equals("organizer"));

            if (!ok) {
                throw new ValidationException(
                        "Selected access role doesn't match this account.");
            }

            // Success — start a fresh session and clear any failure counter.
            session.invalidate();
            session = request.getSession(true);
            session.setAttribute("fullName", fullName);
            session.setAttribute("role", actualRole);

            if ("organizer".equals(actualRole)) {
                response.sendRedirect(request.getContextPath() + "/organizerDashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/home");
            }

        } catch (ValidationException ve) {
            request.setAttribute("errorMessage", ve.getMessage());
            request.getRequestDispatcher(LOGIN_JSP).forward(request, response);

        } catch (SQLException se) {
            se.printStackTrace();
            request.setAttribute("errorMessage",
                    "Database error. Please try again later.");
            request.getRequestDispatcher(LOGIN_JSP).forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage",
                    "An unexpected error occurred. Please try again.");
            request.getRequestDispatcher(LOGIN_JSP).forward(request, response);
        }
    }
}