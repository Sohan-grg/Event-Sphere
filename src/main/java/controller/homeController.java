package controller;

import exception.ValidationException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Booking;
import model.Event;
import service.BookingService;
import service.EventService;
import util.Validator;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

/**
 * Attendee-facing user dashboard. Displays published events that members can
 * search, filter, and book; also lists their own existing bookings.
 */
@WebServlet("/home")
public class homeController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final String HOME_JSP = "/WEB-INF/Pages/home.jsp";

    private final EventService   eventService   = new EventService();
    private final BookingService bookingService = new BookingService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        loadDashboard(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        String userName = (String) session.getAttribute("fullName");

        try {
            if ("book".equalsIgnoreCase(action)) {
                int eventId  = Integer.parseInt(Validator.safeTrim(request.getParameter("eventId")));
                int quantity = Validator.parsePositiveInt(request.getParameter("quantity"), 1);
                Booking booking = bookingService.createBooking(userName, eventId, quantity);

                BigDecimal total = booking.getTotalPrice();
                session.setAttribute("successMessage",
                        "Booked " + booking.getQuantity() + " ticket(s) for \"" +
                        booking.getEventTitle() + "\" — Rs. " +
                        (total == null ? "0.00" : total.toPlainString()));

            } else if ("cancel".equalsIgnoreCase(action)) {
                int bookingId = Integer.parseInt(Validator.safeTrim(request.getParameter("bookingId")));
                bookingService.cancelBooking(bookingId, userName);
                session.setAttribute("successMessage", "Booking cancelled.");

            } else {
                session.setAttribute("errorMessage", "Unknown action.");
            }

        } catch (ValidationException ve) {
            session.setAttribute("errorMessage", ve.getMessage());

        } catch (NumberFormatException nfe) {
            session.setAttribute("errorMessage", "Invalid event or booking reference.");

        } catch (SQLException se) {
            se.printStackTrace();
            session.setAttribute("errorMessage", "Database error. Please try again later.");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Something went wrong. Please try again.");
        }

        response.sendRedirect(request.getContextPath() + "/home");
    }

    private void loadDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String userName = (String) request.getSession().getAttribute("fullName");
        String search   = request.getParameter("search");
        String category = request.getParameter("category");

        try {
            List<Event>   events   = eventService.findPublishedEvents(search, category);
            List<Booking> bookings = bookingService.findBookingsByUser(userName);

            int activeCount = 0;
            BigDecimal totalSpent = BigDecimal.ZERO;
            for (Booking b : bookings) {
                if ("CONFIRMED".equalsIgnoreCase(b.getStatus())) {
                    activeCount++;
                    if (b.getTotalPrice() != null) {
                        totalSpent = totalSpent.add(b.getTotalPrice());
                    }
                }
            }

            request.setAttribute("events",        events);
            request.setAttribute("bookings",      bookings);
            request.setAttribute("eventCount",    events.size());
            request.setAttribute("bookingCount",  activeCount);
            request.setAttribute("totalSpent",    totalSpent);
            request.setAttribute("searchTerm",    Validator.safeTrim(search));
            request.setAttribute("activeCategory",
                    Validator.isEmpty(category) ? "All" : category);

        } catch (SQLException se) {
            se.printStackTrace();
            request.setAttribute("errorMessage",
                    "Failed to load events: " + se.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Unexpected error loading dashboard.");
        }

        request.getRequestDispatcher(HOME_JSP).forward(request, response);
    }

    private boolean isLoggedIn(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null && session.getAttribute("fullName") != null;
    }
}