package util;

import java.util.regex.Pattern;

/**
 * Reusable input validation helpers for forms across the application.
 * Centralizing validation here avoids redundant checks in every controller.
 */
public class Validator {

    private static final Pattern EMAIL_PATTERN =
            Pattern.compile("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");

    private static final Pattern NAME_PATTERN =
            Pattern.compile("^[A-Za-z][A-Za-z .'-]{1,59}$");

    private Validator() {}

    public static boolean isEmpty(String value) {
        return value == null || value.trim().isEmpty();
    }

    public static boolean isValidEmail(String email) {
        return !isEmpty(email) && EMAIL_PATTERN.matcher(email.trim()).matches();
    }

    /**
     * Full names must start with a letter and contain only letters, spaces,
     * apostrophes, dots, or hyphens. Numerical input is rejected.
     */
    public static boolean isValidName(String name) {
        return !isEmpty(name) && NAME_PATTERN.matcher(name.trim()).matches();
    }

    /** Minimum 6 chars and at least one letter and one digit. */
    public static boolean isValidPassword(String password) {
        if (isEmpty(password) || password.length() < 6) return false;
        boolean hasLetter = false;
        boolean hasDigit  = false;
        for (char c : password.toCharArray()) {
            if (Character.isLetter(c)) hasLetter = true;
            else if (Character.isDigit(c)) hasDigit = true;
        }
        return hasLetter && hasDigit;
    }

    public static boolean isValidRole(String role) {
        if (isEmpty(role)) return false;
        String r = role.trim().toLowerCase();
        return r.equals("attendee") || r.equals("organizer") || r.equals("vendor");
    }

    public static int parsePositiveInt(String value, int fallback) {
        try {
            int v = Integer.parseInt(value);
            return v >= 0 ? v : fallback;
        } catch (Exception e) {
            return fallback;
        }
    }

    public static String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }
}