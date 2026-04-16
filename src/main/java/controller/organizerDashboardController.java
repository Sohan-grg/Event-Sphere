package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import config.DatabaseConfig;
import model.Event;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/organizerDashboard")
public class organizerDashboardController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final String DASHBOARD_JSP = "/WEB-INF/Pages/organizerDashboard.jsp";

    // ── GET: load dashboard ───────────────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Guard: must be logged in as organizer
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("fullName") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String fullName = (String) session.getAttribute("fullName");
        loadDashboard(request, response, fullName);
    }

    // ── POST: create / delete event ───────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("fullName") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String fullName = (String) session.getAttribute("fullName");
        String action   = request.getParameter("action");

        if ("create".equalsIgnoreCase(action)) {
            createEvent(request, response, fullName);
        } else if ("delete".equalsIgnoreCase(action)) {
            deleteEvent(request, response, fullName);
        } else if ("edit".equalsIgnoreCase(action)) {
            updateEvent(request, response, fullName);
        } else {
            response.sendRedirect(request.getContextPath() + "/organizerDashboard");
        }
    }

    // ── Load dashboard data ───────────────────────────────────────────────────
    private void loadDashboard(HttpServletRequest request,
                                HttpServletResponse response,
                                String fullName) throws ServletException, IOException {

        List<Event> events        = new ArrayList<>();
        int    totalRegistrations = 0;
        int    activeWaitlists    = 0;
        double totalRevenue       = 0;
        double avgRating          = 4.9; // static for now

        String sql = "SELECT * FROM events WHERE organizer_name = ? ORDER BY created_at DESC";

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, fullName);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Event e = mapRow(rs);
                    events.add(e);
                    totalRegistrations += e.getTicketsSold();
                    totalRevenue       += e.getRevenue().doubleValue();
                    if ("Draft".equalsIgnoreCase(e.getStatus())) activeWaitlists++;
                }
            }

        } catch (SQLException ex) {
            ex.printStackTrace();
            request.setAttribute("errorMessage", "Failed to load events: " + ex.getMessage());
        }

        request.setAttribute("events",             events);
        request.setAttribute("totalRegistrations", totalRegistrations);
        request.setAttribute("activeWaitlists",    activeWaitlists);
        request.setAttribute("totalRevenue", String.format("Rs. %.2f", totalRevenue));
        request.setAttribute("avgRating",           avgRating);
        request.setAttribute("eventCount",          events.size());

        request.getRequestDispatcher(DASHBOARD_JSP).forward(request, response);
    }

    // ── Create event ──────────────────────────────────────────────────────────
    private void createEvent(HttpServletRequest request,
                              HttpServletResponse response,
                              String fullName) throws ServletException, IOException {

        String title       = request.getParameter("title");
        String description = request.getParameter("description");
        String category    = request.getParameter("category");
        String location    = request.getParameter("location");
        String dateStr     = request.getParameter("eventDate");
        String priceStr    = request.getParameter("ticketPrice");
        String capStr      = request.getParameter("capacity");
        String statusParam = request.getParameter("status"); // "Published" or "Draft"

        if (isEmpty(title)) {
            request.getSession().setAttribute("errorMessage", "Event title is required.");
            response.sendRedirect(request.getContextPath() + "/organizerDashboard");
            return;
        }

        String sql = "INSERT INTO events " +
                     "(organizer_name, title, description, category, location, event_date, ticket_price, capacity, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, fullName);
            ps.setString(2, title.trim());
            ps.setString(3, isEmpty(description) ? "" : description.trim());
            ps.setString(4, isEmpty(category)    ? "General" : category.trim());
            ps.setString(5, isEmpty(location)    ? "" : location.trim());
            ps.setTimestamp(6, isEmpty(dateStr)  ? null : Timestamp.valueOf(dateStr.replace("T", " ") + ":00"));
            ps.setBigDecimal(7, isEmpty(priceStr) ? BigDecimal.ZERO : new BigDecimal(priceStr));
            ps.setInt(8,       isEmpty(capStr)   ? 0 : Integer.parseInt(capStr));
            ps.setString(9,    isEmpty(statusParam) ? "Draft" : statusParam);

            ps.executeUpdate();
            request.getSession().setAttribute("successMessage", "Event created successfully!");

        } catch (Exception ex) {
            ex.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Failed to create event: " + ex.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/organizerDashboard");
    }

    // ── Delete event ──────────────────────────────────────────────────────────
    private void deleteEvent(HttpServletRequest request,
                              HttpServletResponse response,
                              String fullName) throws ServletException, IOException {

        String idParam = request.getParameter("id");
        if (isEmpty(idParam)) {
            response.sendRedirect(request.getContextPath() + "/organizerDashboard");
            return;
        }

        // Only delete events belonging to this organizer
        String sql = "DELETE FROM events WHERE id = ? AND organizer_name = ?";

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, Integer.parseInt(idParam));
            ps.setString(2, fullName);
            ps.executeUpdate();
            request.getSession().setAttribute("successMessage", "Event deleted.");

        } catch (Exception ex) {
            ex.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Failed to delete event: " + ex.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/organizerDashboard");
    }
    
    
    private void updateEvent(HttpServletRequest request,
            HttpServletResponse response,
            String fullName) throws IOException {

String idStr       = request.getParameter("id");
String title       = request.getParameter("title");
String category    = request.getParameter("category");
String location    = request.getParameter("location");
String capStr      = request.getParameter("capacity");
String priceStr    = request.getParameter("ticketPrice");
String status = request.getParameter("status");
if (status == null) {
    status = "Draft";
}

if (isEmpty(idStr)) {
response.sendRedirect(request.getContextPath() + "/organizerDashboard");
return;
}

String sql = "UPDATE events SET title=?, category=?, location=?, capacity=?, ticket_price=?, status=? " +
        "WHERE id=? AND organizer_name=?";

try (Connection conn = DatabaseConfig.getConnection();
PreparedStatement ps = conn.prepareStatement(sql)) {

	ps.setString(1, title);
	ps.setString(2, category);
	ps.setString(3, location);
	ps.setInt(4, isEmpty(capStr) ? 0 : Integer.parseInt(capStr));
	ps.setBigDecimal(5, isEmpty(priceStr) ? BigDecimal.ZERO : new BigDecimal(priceStr));
	ps.setString(6, status);  // 
	ps.setInt(7, Integer.parseInt(idStr));
	ps.setString(8, fullName);

ps.executeUpdate();

request.getSession().setAttribute("successMessage", "Event updated!");

} catch (Exception e) {
e.printStackTrace();
request.getSession().setAttribute("errorMessage", "Update failed.");
}

response.sendRedirect(request.getContextPath() + "/organizerDashboard");
}

    // ── Map ResultSet row → Event ─────────────────────────────────────────────
    private Event mapRow(ResultSet rs) throws SQLException {
        Event e = new Event();
        e.setId(rs.getInt("id"));
        e.setOrganizerName(rs.getString("organizer_name"));
        e.setTitle(rs.getString("title"));
        e.setDescription(rs.getString("description"));
        e.setCategory(rs.getString("category"));
        e.setLocation(rs.getString("location"));
        e.setEventDate(rs.getTimestamp("event_date"));
        e.setTicketPrice(rs.getBigDecimal("ticket_price"));
        e.setCapacity(rs.getInt("capacity"));
        e.setTicketsSold(rs.getInt("tickets_sold"));
        e.setStatus(rs.getString("status"));
        e.setRevenue(rs.getBigDecimal("revenue") != null
                     ? rs.getBigDecimal("revenue") : BigDecimal.ZERO);
        e.setCreatedAt(rs.getTimestamp("created_at"));
        return e;
    }

    private boolean isEmpty(String v) { return v == null || v.trim().isEmpty(); }
}