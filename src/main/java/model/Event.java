package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Event {

    private int        id;
    private String     organizerName;
    private String     title;
    private String     description;
    private String     category;
    private String     location;
    private Timestamp  eventDate;
    private BigDecimal ticketPrice;
    private int        capacity;
    private int        ticketsSold;
    private String     status;       // Draft | Published | Completed
    private BigDecimal revenue;
    private Timestamp  createdAt;

    // ── Constructors ──────────────────────────────────────────────────────────
    public Event() {}

    public Event(int id, String organizerName, String title, String description,
                 String category, String location, Timestamp eventDate,
                 BigDecimal ticketPrice, int capacity, int ticketsSold,
                 String status, BigDecimal revenue, Timestamp createdAt) {
        this.id            = id;
        this.organizerName = organizerName;
        this.title         = title;
        this.description   = description;
        this.category      = category;
        this.location      = location;
        this.eventDate     = eventDate;
        this.ticketPrice   = ticketPrice;
        this.capacity      = capacity;
        this.ticketsSold   = ticketsSold;
        this.status        = status;
        this.revenue       = revenue;
        this.createdAt     = createdAt;
    }

    // ── Getters ───────────────────────────────────────────────────────────────
    public int        getId()            { return id; }
    public String     getOrganizerName() { return organizerName; }
    public String     getTitle()         { return title; }
    public String     getDescription()   { return description; }
    public String     getCategory()      { return category; }
    public String     getLocation()      { return location; }
    public Timestamp  getEventDate()     { return eventDate; }
    public BigDecimal getTicketPrice()   { return ticketPrice; }
    public int        getCapacity()      { return capacity; }
    public int        getTicketsSold()   { return ticketsSold; }
    public String     getStatus()        { return status; }
    public BigDecimal getRevenue()       { return revenue; }
    public Timestamp  getCreatedAt()     { return createdAt; }

    // ── Setters ───────────────────────────────────────────────────────────────
    public void setId(int id)                       { this.id = id; }
    public void setOrganizerName(String v)          { this.organizerName = v; }
    public void setTitle(String v)                  { this.title = v; }
    public void setDescription(String v)            { this.description = v; }
    public void setCategory(String v)               { this.category = v; }
    public void setLocation(String v)               { this.location = v; }
    public void setEventDate(Timestamp v)           { this.eventDate = v; }
    public void setTicketPrice(BigDecimal v)        { this.ticketPrice = v; }
    public void setCapacity(int v)                  { this.capacity = v; }
    public void setTicketsSold(int v)               { this.ticketsSold = v; }
    public void setStatus(String v)                 { this.status = v; }
    public void setRevenue(BigDecimal v)            { this.revenue = v; }
    public void setCreatedAt(Timestamp v)           { this.createdAt = v; }

    // ── Helpers ───────────────────────────────────────────────────────────────
    /** e.g. "450 / 500" */
    public String getTicketDisplay() {
        return ticketsSold + " / " + capacity;
    }

    /** true when capacity > 0 and all tickets sold */
    public boolean isSoldOut() {
        return capacity > 0 && ticketsSold >= capacity;
    }
}