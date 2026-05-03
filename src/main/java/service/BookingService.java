package service;

import config.DatabaseConfig;
import exception.ValidationException;
import model.Booking;
import model.Event;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Handles ticket booking transactions: capacity checks, inserting the booking,
 * and updating the parent event's tickets_sold / revenue counters atomically.
 *
 * Auto-creates the bookings table on first call so the project runs out of the
 * box without a separate migration script.
 */
public class BookingService {

    public BookingService() {
        ensureTable();
    }

    /**
     * Books `quantity` tickets for the given event on behalf of the user.
     * Throws ValidationException for any business-rule violation (sold out,
     * non-existent event, bad quantity).
     */
    public Booking createBooking(String userName, int eventId, int quantity)
            throws ValidationException, SQLException {

        if (userName == null || userName.trim().isEmpty()) {
            throw new ValidationException("You must be logged in to book an event.");
        }
        if (quantity <= 0) {
            throw new ValidationException("Please book at least one ticket.");
        }
        if (quantity > 10) {
            throw new ValidationException("Maximum 10 tickets per booking.");
        }

        try (Connection conn = DatabaseConfig.getConnection()) {
            conn.setAutoCommit(false);

            try {
                Event event = lockEventRow(conn, eventId);
                if (event == null) {
                    throw new ValidationException("Event not found.");
                }
                if (!"Published".equalsIgnoreCase(event.getStatus())) {
                    throw new ValidationException("This event is not open for booking.");
                }

                int remaining = event.getCapacity() - event.getTicketsSold();
                if (event.getCapacity() > 0 && quantity > remaining) {
                    throw new ValidationException(
                            "Only " + remaining + " ticket(s) remaining for this event.");
                }

                BigDecimal unitPrice = event.getTicketPrice() != null
                        ? event.getTicketPrice() : BigDecimal.ZERO;
                BigDecimal total = unitPrice.multiply(BigDecimal.valueOf(quantity));

                int bookingId = insertBooking(conn, userName, event, quantity, total);
                updateEventCounters(conn, eventId, quantity, total);

                conn.commit();

                Booking b = new Booking();
                b.setId(bookingId);
                b.setUserName(userName);
                b.setEventId(eventId);
                b.setEventTitle(event.getTitle());
                b.setEventCategory(event.getCategory());
                b.setEventLocation(event.getLocation());
                b.setEventDate(event.getEventDate());
                b.setQuantity(quantity);
                b.setTotalPrice(total);
                b.setStatus("CONFIRMED");
                return b;

            } catch (Exception ex) {
                try { conn.rollback(); } catch (SQLException ignore) {}
                if (ex instanceof ValidationException) throw (ValidationException) ex;
                if (ex instanceof SQLException)        throw (SQLException) ex;
                throw new SQLException(ex);
            }
        }
    }

    /** Returns all bookings made by the given user, most recent first. */
    public List<Booking> findBookingsByUser(String userName) throws SQLException {

        String sql =
                "SELECT b.id, b.user_name, b.event_id, b.quantity, b.total_price, b.status, b.booked_at, " +
                "       e.title, e.category, e.location, e.event_date " +
                "FROM   bookings b " +
                "LEFT JOIN events e ON e.id = b.event_id " +
                "WHERE  b.user_name = ? " +
                "ORDER BY b.booked_at DESC";

        List<Booking> list = new ArrayList<>();
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, userName);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Booking b = new Booking();
                    b.setId(rs.getInt("id"));
                    b.setUserName(rs.getString("user_name"));
                    b.setEventId(rs.getInt("event_id"));
                    b.setQuantity(rs.getInt("quantity"));
                    b.setTotalPrice(rs.getBigDecimal("total_price"));
                    b.setStatus(rs.getString("status"));
                    b.setBookedAt(rs.getTimestamp("booked_at"));
                    b.setEventTitle(rs.getString("title"));
                    b.setEventCategory(rs.getString("category"));
                    b.setEventLocation(rs.getString("location"));
                    b.setEventDate(rs.getTimestamp("event_date"));
                    list.add(b);
                }
            }
        }
        return list;
    }

    public boolean cancelBooking(int bookingId, String userName)
            throws SQLException, ValidationException {

        try (Connection conn = DatabaseConfig.getConnection()) {
            conn.setAutoCommit(false);
            try {
                String fetch = "SELECT event_id, quantity, total_price, status FROM bookings " +
                               "WHERE id = ? AND user_name = ? FOR UPDATE";

                int     eventId;
                int     qty;
                BigDecimal total;

                try (PreparedStatement ps = conn.prepareStatement(fetch)) {
                    ps.setInt(1, bookingId);
                    ps.setString(2, userName);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (!rs.next()) {
                            throw new ValidationException("Booking not found.");
                        }
                        if ("CANCELLED".equalsIgnoreCase(rs.getString("status"))) {
                            throw new ValidationException("Booking is already cancelled.");
                        }
                        eventId = rs.getInt("event_id");
                        qty     = rs.getInt("quantity");
                        total   = rs.getBigDecimal("total_price");
                    }
                }

                try (PreparedStatement ps = conn.prepareStatement(
                        "UPDATE bookings SET status='CANCELLED' WHERE id = ?")) {
                    ps.setInt(1, bookingId);
                    ps.executeUpdate();
                }

                try (PreparedStatement ps = conn.prepareStatement(
                        "UPDATE events SET tickets_sold = GREATEST(tickets_sold - ?, 0), " +
                        "                 revenue = GREATEST(revenue - ?, 0) WHERE id = ?")) {
                    ps.setInt(1, qty);
                    ps.setBigDecimal(2, total != null ? total : BigDecimal.ZERO);
                    ps.setInt(3, eventId);
                    ps.executeUpdate();
                }

                conn.commit();
                return true;

            } catch (Exception ex) {
                try { conn.rollback(); } catch (SQLException ignore) {}
                if (ex instanceof ValidationException) throw (ValidationException) ex;
                if (ex instanceof SQLException)        throw (SQLException) ex;
                throw new SQLException(ex);
            }
        }
    }

    // ── Internal helpers ─────────────────────────────────────────────────────

    private Event lockEventRow(Connection conn, int eventId) throws SQLException {
        String sql = "SELECT * FROM events WHERE id = ? FOR UPDATE";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Event e = new Event();
                    e.setId(rs.getInt("id"));
                    e.setTitle(rs.getString("title"));
                    e.setCategory(rs.getString("category"));
                    e.setLocation(rs.getString("location"));
                    e.setEventDate(rs.getTimestamp("event_date"));
                    e.setTicketPrice(rs.getBigDecimal("ticket_price"));
                    e.setCapacity(rs.getInt("capacity"));
                    e.setTicketsSold(rs.getInt("tickets_sold"));
                    e.setStatus(rs.getString("status"));
                    return e;
                }
            }
        }
        return null;
    }

    private int insertBooking(Connection conn, String userName, Event event,
                              int quantity, BigDecimal total) throws SQLException {

        String sql = "INSERT INTO bookings(user_name, event_id, quantity, total_price, status) " +
                     "VALUES (?, ?, ?, ?, 'CONFIRMED')";

        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, userName);
            ps.setInt(2, event.getId());
            ps.setInt(3, quantity);
            ps.setBigDecimal(4, total);
            ps.executeUpdate();

            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) return keys.getInt(1);
            }
        }
        return -1;
    }

    private void updateEventCounters(Connection conn, int eventId, int quantity,
                                      BigDecimal total) throws SQLException {
        String sql = "UPDATE events SET tickets_sold = tickets_sold + ?, " +
                     "                 revenue = COALESCE(revenue, 0) + ? WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setBigDecimal(2, total);
            ps.setInt(3, eventId);
            ps.executeUpdate();
        }
    }

    /** Creates the bookings table on first use if it doesn't already exist. */
    private void ensureTable() {
        String ddl =
                "CREATE TABLE IF NOT EXISTS bookings (" +
                "  id INT AUTO_INCREMENT PRIMARY KEY," +
                "  user_name   VARCHAR(120) NOT NULL," +
                "  event_id    INT          NOT NULL," +
                "  quantity    INT          NOT NULL DEFAULT 1," +
                "  total_price DECIMAL(10,2) NOT NULL DEFAULT 0.00," +
                "  status      VARCHAR(20)  NOT NULL DEFAULT 'CONFIRMED'," +
                "  booked_at   TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP," +
                "  INDEX idx_user (user_name)," +
                "  INDEX idx_event (event_id)" +
                ")";
        try (Connection conn = DatabaseConfig.getConnection();
             Statement st = conn.createStatement()) {
            st.executeUpdate(ddl);
        } catch (Exception ex) {
            // Non-fatal: the table may already exist or DB may be unreachable;
            // controllers will surface a meaningful error on the next call.
            ex.printStackTrace();
        }
    }
}