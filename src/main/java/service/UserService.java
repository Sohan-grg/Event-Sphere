package service;

import config.DatabaseConfig;
import exception.DuplicateAccountException;
import exception.ValidationException;
import util.Validator;

import java.sql.*;
import java.util.UUID;

/**
 * Account-related business logic: registration, authentication, lookups, and
 * the forgot-password / reset-password flow.
 *
 * Auto-creates the `password_resets` table on first use so the project runs
 * out of the box without a separate migration step.
 */
public class UserService {

    /** How long a password-reset token is valid (in minutes). */
    private static final int RESET_TOKEN_TTL_MINUTES = 15;

    public UserService() {
       
    }

    // ════════════════════════════════════════════════════════════
    // Registration
    // ════════════════════════════════════════════════════════════
    public void register(String fullName, String email, String password, String role)
            throws ValidationException, DuplicateAccountException, SQLException {

        if (!Validator.isValidName(fullName)) {
            throw new ValidationException(
                    "Full name must contain only letters and be 2-60 characters long.");
        }
        if (!Validator.isValidEmail(email)) {
            throw new ValidationException("Please enter a valid email address.");
        }
        if (!Validator.isValidPassword(password)) {
            throw new ValidationException(
                    "Password must be at least 6 characters and contain a letter and a digit.");
        }
        if (!Validator.isValidRole(role)) {
            throw new ValidationException("Please select a valid role.");
        }

        if (existsByEmail(email)) {
            throw new DuplicateAccountException(
                    "An account with this email already exists.");
        }

        String sql = "INSERT INTO User(`FULL NAME`, `EMAIL ADDRESS`, `PASSWORD`, `SELECT ROLE`) " +
                     "VALUES (?, ?, ?, ?)";

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, fullName.trim());
            ps.setString(2, email.trim());
            ps.setString(3, password);
            ps.setString(4, role.trim().toLowerCase());
            ps.executeUpdate();
        }
    }

    // ════════════════════════════════════════════════════════════
    // Login
    // ════════════════════════════════════════════════════════════
    public String authenticate(String fullName, String password) throws SQLException {

        String sql = "SELECT `SELECT ROLE` FROM User WHERE `FULL NAME` = ? AND `PASSWORD` = ?";

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, fullName);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getString("SELECT ROLE");
            }
        }
        return null;
    }

    public boolean existsByEmail(String email) throws SQLException {
        String sql = "SELECT 1 FROM User WHERE `EMAIL ADDRESS` = ? LIMIT 1";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email.trim());
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    // ════════════════════════════════════════════════════════════
    // Forgot Password / Reset Password
    // ════════════════════════════════════════════════════════════

    /**
     * Generates a single-use reset token tied to the email and stores it with
     * an expiry timestamp. Throws ValidationException if no account is found.
     * In production this would be emailed to the user; here we return the
     * token so the caller can display a "reset link" on the success page.
     */
    public String createResetToken(String email)
            throws ValidationException, SQLException {

        if (!Validator.isValidEmail(email)) {
            throw new ValidationException("Please enter a valid email address.");
        }
        if (!existsByEmail(email)) {
            throw new ValidationException("No account is registered with that email.");
        }

        String token = UUID.randomUUID().toString().replace("-", "");
        Timestamp expires = new Timestamp(
                System.currentTimeMillis() + RESET_TOKEN_TTL_MINUTES * 60_000L);

        // Invalidate any older unused tokens so only the latest one works.
        String invalidate =
                "UPDATE password_resets SET used = 1 WHERE user_email = ? AND used = 0";
        String insert =
                "INSERT INTO password_resets(user_email, token, expires_at) VALUES(?, ?, ?)";

        try (Connection conn = DatabaseConfig.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement ps1 = conn.prepareStatement(invalidate);
                 PreparedStatement ps2 = conn.prepareStatement(insert)) {

                ps1.setString(1, email.trim());
                ps1.executeUpdate();

                ps2.setString(1, email.trim());
                ps2.setString(2, token);
                ps2.setTimestamp(3, expires);
                ps2.executeUpdate();

                conn.commit();
            } catch (SQLException ex) {
                try { conn.rollback(); } catch (SQLException ignore) {}
                throw ex;
            }
        }
        return token;
    }

    /**
     * Returns the email associated with a valid (existing, unused, unexpired)
     * token, or null if the token is invalid.
     */
    public String findEmailForToken(String token) throws SQLException {
        if (token == null || token.trim().isEmpty()) return null;

        String sql = "SELECT user_email FROM password_resets " +
                     "WHERE token = ? AND used = 0 AND expires_at > CURRENT_TIMESTAMP";

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, token.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getString("user_email");
            }
        }
        return null;
    }

    /**
     * Validates the token + new password rules, updates the account password,
     * and marks the token consumed. Returns the email of the affected user.
     */
    public String resetPassword(String token, String newPassword, String confirmPassword)
            throws ValidationException, SQLException {

        if (!Validator.isValidPassword(newPassword)) {
            throw new ValidationException(
                    "Password must be at least 6 characters and contain a letter and a digit.");
        }
        if (newPassword == null || !newPassword.equals(confirmPassword)) {
            throw new ValidationException("Both passwords must match.");
        }

        String email = findEmailForToken(token);
        if (email == null) {
            throw new ValidationException(
                    "This reset link is invalid or has expired. Please start over.");
        }

        String updatePw = "UPDATE User SET `PASSWORD` = ? WHERE `EMAIL ADDRESS` = ?";
        String burnTok  = "UPDATE password_resets SET used = 1 WHERE token = ?";

        try (Connection conn = DatabaseConfig.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement ps1 = conn.prepareStatement(updatePw);
                 PreparedStatement ps2 = conn.prepareStatement(burnTok)) {

                ps1.setString(1, newPassword);
                ps1.setString(2, email);
                ps1.executeUpdate();

                ps2.setString(1, token);
                ps2.executeUpdate();

                conn.commit();
            } catch (SQLException ex) {
                try { conn.rollback(); } catch (SQLException ignore) {}
                throw ex;
            }
        }
        return email;
    }

}