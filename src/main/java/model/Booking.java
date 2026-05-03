package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * Represents a single ticket booking made by an attendee for an event.
 */
public class Booking {

    private int        id;
    private String     userName;
    private int        eventId;
    private String     eventTitle;
    private String     eventCategory;
    private String     eventLocation;
    private Timestamp  eventDate;
    private int        quantity;
    private BigDecimal totalPrice;
    private String     status;       // CONFIRMED | CANCELLED
    private Timestamp  bookedAt;

    public Booking() {}

    public int        getId()            { return id; }
    public String     getUserName()      { return userName; }
    public int        getEventId()       { return eventId; }
    public String     getEventTitle()    { return eventTitle; }
    public String     getEventCategory() { return eventCategory; }
    public String     getEventLocation() { return eventLocation; }
    public Timestamp  getEventDate()     { return eventDate; }
    public int        getQuantity()      { return quantity; }
    public BigDecimal getTotalPrice()    { return totalPrice; }
    public String     getStatus()        { return status; }
    public Timestamp  getBookedAt()      { return bookedAt; }

    public void setId(int v)              { this.id = v; }
    public void setUserName(String v)     { this.userName = v; }
    public void setEventId(int v)         { this.eventId = v; }
    public void setEventTitle(String v)   { this.eventTitle = v; }
    public void setEventCategory(String v){ this.eventCategory = v; }
    public void setEventLocation(String v){ this.eventLocation = v; }
    public void setEventDate(Timestamp v) { this.eventDate = v; }
    public void setQuantity(int v)        { this.quantity = v; }
    public void setTotalPrice(BigDecimal v){ this.totalPrice = v; }
    public void setStatus(String v)       { this.status = v; }
    public void setBookedAt(Timestamp v)  { this.bookedAt = v; }
}