package service;

import config.DatabaseConfig;
import model.Event;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Business logic for reading published events that attendees can browse.
 * Keeps SQL out of the controllers and centralizes ResultSet → Event mapping.
 */
public class EventService {

    /** Returns all events with status "Published" ordered by upcoming date. */
    public List<Event> findPublishedEvents(String search, String category) throws SQLException {

        StringBuilder sql = new StringBuilder(
                "SELECT * FROM events WHERE LOWER(status) = 'published'");

        List<Object> params = new ArrayList<>();

        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (LOWER(title) LIKE ? OR LOWER(location) LIKE ? OR LOWER(description) LIKE ?)");
            String like = "%" + search.trim().toLowerCase() + "%";
            params.add(like);
            params.add(like);
            params.add(like);
        }

        if (category != null && !category.trim().isEmpty() && !"All".equalsIgnoreCase(category)) {
            sql.append(" AND LOWER(category) = ?");
            params.add(category.trim().toLowerCase());
        }

        sql.append(" ORDER BY (event_date IS NULL), event_date ASC, created_at DESC");

        List<Event> list = new ArrayList<>();

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        }
        return list;
    }

    public Event findById(int id) throws SQLException {
        String sql = "SELECT * FROM events WHERE id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        }
        return null;
    }

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
}