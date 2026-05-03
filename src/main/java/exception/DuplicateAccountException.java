package exception;

/**
 * Thrown when registration is attempted with an email that already exists.
 */
public class DuplicateAccountException extends Exception {

    private static final long serialVersionUID = 1L;

    public DuplicateAccountException(String message) {
        super(message);
    }
}