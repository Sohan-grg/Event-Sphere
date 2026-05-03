<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EventSphere – User Dashboard</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/userDashboard.css">
</head>
<body>

<div class="layout">

    <%-- ─────────────────  SIDEBAR  ───────────────── --%>
    <aside class="sidebar">
        <div class="sidebar-brand">
            <span class="brand-dot"></span>EventSphere
        </div>

        <div class="sidebar-profile">
            <div class="avatar">${fn:substring(sessionScope.fullName, 0, 1)}</div>
            <div>
                <div class="profile-name"><c:out value="${sessionScope.fullName}"/></div>
                <div class="profile-role">Member</div>
            </div>
        </div>

        <nav class="sidebar-nav">
            <a href="#" class="nav-item active" onclick="showView('discover')">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                    <circle cx="12" cy="12" r="10"/>
                    <polygon points="16.24 7.76 14.12 14.12 7.76 16.24 9.88 9.88 16.24 7.76"/>
                </svg>
                Discover Events
            </a>
            <a href="#" class="nav-item" onclick="showView('bookings')">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                    <path d="M19 14H5l-2 7 9-3 9 3-2-7z"/><path d="M5 14V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2v9"/>
                </svg>
                My Bookings
                <c:if test="${bookingCount > 0}">
                    <span class="nav-badge">${bookingCount}</span>
                </c:if>
            </a>
        </nav>

        <a href="${pageContext.request.contextPath}/logout" class="sidebar-logout">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/>
                <polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/>
            </svg>
            Logout
        </a>
    </aside>

    <%-- ─────────────────  MAIN  ───────────────── --%>
    <main class="main">

        <c:if test="${not empty sessionScope.successMessage}">
            <div class="flash flash-success">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="20 6 9 17 4 12"/></svg>
                <c:out value="${sessionScope.successMessage}"/>
            </div>
            <c:remove var="successMessage" scope="session"/>
        </c:if>
        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="flash flash-error">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                <c:out value="${sessionScope.errorMessage}"/>
            </div>
            <c:remove var="errorMessage" scope="session"/>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="flash flash-error">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                <c:out value="${errorMessage}"/>
            </div>
        </c:if>

        <%-- ═══ VIEW: DISCOVER EVENTS ═══ --%>
        <section id="view-discover" class="view">

            <div class="page-header">
                <div>
                    <p class="page-sub">DISCOVER</p>
                    <h1>Welcome back, <c:out value="${sessionScope.fullName}"/>.</h1>
                    <p class="page-sub normal">Explore upcoming events and reserve your spot.</p>
                </div>
                <div class="header-actions">
                    <div class="quick-stat">
                        <div class="qs-label">My Bookings</div>
                        <div class="qs-value">${bookingCount}</div>
                    </div>
                    <div class="quick-stat">
                        <div class="qs-label">Total Spent</div>
                        <div class="qs-value">Rs.<fmt:formatNumber value="${totalSpent}" pattern="#,##0.00"/></div>
                    </div>
                </div>
            </div>

            <%-- Search + Filter --%>
            <form class="search-bar" method="get" action="${pageContext.request.contextPath}/home">
                <div class="search-wrap">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                        <circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/>
                    </svg>
                    <input type="text" name="search" placeholder="Search by title, location, or keyword..."
                           value="<c:out value='${searchTerm}'/>"/>
                </div>

                <div class="chip-row">
                    <button type="submit" name="category" value="All"
                            class="chip ${activeCategory eq 'All' ? 'chip-active' : ''}">All</button>
                    <button type="submit" name="category" value="Corporate"
                            class="chip ${activeCategory eq 'Corporate' ? 'chip-active' : ''}">Corporate</button>
                    <button type="submit" name="category" value="Social"
                            class="chip ${activeCategory eq 'Social' ? 'chip-active' : ''}">Social</button>
                    <button type="submit" name="category" value="Creative"
                            class="chip ${activeCategory eq 'Creative' ? 'chip-active' : ''}">Creative</button>
                    <button type="submit" name="category" value="General"
                            class="chip ${activeCategory eq 'General' ? 'chip-active' : ''}">General</button>
                </div>
            </form>

            <%-- Event grid --%>
            <c:choose>
                <c:when test="${empty events}">
                    <div class="empty-state">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" width="56" height="56">
                            <rect x="3" y="4" width="18" height="18" rx="2"/>
                            <line x1="16" y1="2" x2="16" y2="6"/>
                            <line x1="8" y1="2" x2="8" y2="6"/>
                            <line x1="3" y1="10" x2="21" y2="10"/>
                        </svg>
                        <h3>No events found</h3>
                        <p>Try a different search term or category.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="event-grid">
                        <c:forEach var="ev" items="${events}">
                            <article class="event-card">
                                <div class="event-thumb thumb-${fn:toLowerCase(ev.category)}">
                                    <span class="event-thumb-tag"><c:out value="${ev.category}"/></span>
                                    <span class="event-thumb-title">${fn:substring(ev.title,0,3)}</span>
                                </div>
                                <div class="event-body">
                                    <h3 class="event-title"><c:out value="${ev.title}"/></h3>

                                    <c:if test="${not empty ev.description}">
                                        <p class="event-desc">
                                            <c:out value="${fn:substring(ev.description, 0, 110)}"/><c:if test="${fn:length(ev.description) > 110}">…</c:if>
                                        </p>
                                    </c:if>

                                    <div class="event-meta-row">
                                        <span class="event-meta">
                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" width="14" height="14"><rect x="3" y="4" width="18" height="18" rx="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
                                            <c:choose>
                                                <c:when test="${ev.eventDate != null}">
                                                    <fmt:formatDate value="${ev.eventDate}" pattern="MMM dd, yyyy · hh:mm a"/>
                                                </c:when>
                                                <c:otherwise>Date TBA</c:otherwise>
                                            </c:choose>
                                        </span>
                                        <c:if test="${not empty ev.location}">
                                            <span class="event-meta">
                                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" width="14" height="14"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>
                                                <c:out value="${ev.location}"/>
                                            </span>
                                        </c:if>
                                    </div>

                                    <div class="event-footer">
                                        <div>
                                            <div class="event-price">Rs.<fmt:formatNumber value="${ev.ticketPrice}" pattern="#,##0.00"/></div>
                                            <div class="event-seats">
                                                <c:choose>
                                                    <c:when test="${ev.soldOut}">
                                                        <span class="badge badge-soldout">Sold Out</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${ev.capacity - ev.ticketsSold} of ${ev.capacity} left
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                        <c:if test="${not ev.soldOut}">
                                            <button type="button" class="btn-primary"
                                                    onclick="openBookModal(${ev.id}, '${fn:replace(ev.title, "'", "\\'")}', ${ev.ticketPrice == null ? 0 : ev.ticketPrice}, ${ev.capacity - ev.ticketsSold})">
                                                Book Now
                                            </button>
                                        </c:if>
                                    </div>
                                </div>
                            </article>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>

        <%-- ═══ VIEW: MY BOOKINGS ═══ --%>
        <section id="view-bookings" class="view" style="display:none">
            <div class="page-header">
                <div>
                    <p class="page-sub">MY BOOKINGS</p>
                    <h1>Your reservations</h1>
                    <p class="page-sub normal">Manage your tickets and cancellations.</p>
                </div>
            </div>

            <c:choose>
                <c:when test="${empty bookings}">
                    <div class="empty-state">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" width="56" height="56">
                            <path d="M19 14H5l-2 7 9-3 9 3-2-7z"/><path d="M5 14V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2v9"/>
                        </svg>
                        <h3>No bookings yet</h3>
                        <p>Browse events and reserve a spot.</p>
                        <button class="btn-primary" onclick="showView('discover')">Discover Events</button>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="booking-list">
                        <c:forEach var="b" items="${bookings}">
                            <div class="booking-card">
                                <div class="booking-thumb thumb-${fn:toLowerCase(b.eventCategory)}">
                                    <span>${fn:substring(b.eventTitle,0,2)}</span>
                                </div>
                                <div class="booking-body">
                                    <div class="booking-top">
                                        <span class="badge badge-${fn:toLowerCase(b.eventCategory)}"><c:out value="${b.eventCategory}"/></span>
                                        <span class="status-pill status-pill-${fn:toLowerCase(b.status)}">
                                            <span class="dot"></span><c:out value="${b.status}"/>
                                        </span>
                                    </div>
                                    <div class="booking-title"><c:out value="${b.eventTitle}"/></div>
                                    <div class="booking-meta">
                                        <span>
                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" width="13" height="13"><rect x="3" y="4" width="18" height="18" rx="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
                                            <c:choose>
                                                <c:when test="${b.eventDate != null}">
                                                    <fmt:formatDate value="${b.eventDate}" pattern="MMM dd, yyyy · hh:mm a"/>
                                                </c:when>
                                                <c:otherwise>Date TBA</c:otherwise>
                                            </c:choose>
                                        </span>
                                        <c:if test="${not empty b.eventLocation}">
                                            <span>
                                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" width="13" height="13"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>
                                                <c:out value="${b.eventLocation}"/>
                                            </span>
                                        </c:if>
                                    </div>
                                </div>
                                <div class="booking-side">
                                    <div class="booking-qty">${b.quantity} × ticket</div>
                                    <div class="booking-total">Rs.<fmt:formatNumber value="${b.totalPrice}" pattern="#,##0.00"/></div>
                                    <c:if test="${b.status eq 'CONFIRMED'}">
                                        <form method="post" action="${pageContext.request.contextPath}/home"
                                              onsubmit="return confirm('Cancel this booking?');">
                                            <input type="hidden" name="action" value="cancel"/>
                                            <input type="hidden" name="bookingId" value="${b.id}"/>
                                            <button type="submit" class="btn-link-danger">Cancel</button>
                                        </form>
                                    </c:if>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>
    </main>
</div>

<%-- ──────────────  BOOKING MODAL  ────────────── --%>
<div id="bookModal" class="modal-overlay" style="display:none">
    <div class="modal">
        <div class="modal-header">
            <h2>Reserve Tickets</h2>
            <span class="close-btn" onclick="closeModal('bookModal')">✕</span>
        </div>

        <form method="post" action="${pageContext.request.contextPath}/home" onsubmit="return validateBooking()">
            <input type="hidden" name="action" value="book"/>
            <input type="hidden" name="eventId" id="bookEventId"/>

            <div class="modal-body">
                <p class="modal-event-title" id="bookEventTitle"></p>

                <div class="form-group">
                    <label for="bookQuantity">Number of Tickets</label>
                    <input type="number" id="bookQuantity" name="quantity"
                           min="1" max="10" value="1" required oninput="updateTotal()"/>
                    <small id="bookSeatsLeft" class="hint"></small>
                </div>

                <div class="summary-row">
                    <span>Total</span>
                    <strong>Rs. <span id="bookTotal">0.00</span></strong>
                </div>
            </div>

            <div class="modal-actions">
                <button type="button" class="btn-ghost" onclick="closeModal('bookModal')">Cancel</button>
                <button type="submit" class="btn-primary">Confirm Booking</button>
            </div>
        </form>
    </div>
</div>

<footer class="footer">
    <div class="footer-brand">
        <div class="footer-name">EventSphere</div>
        <div class="footer-copy">© <fmt:formatDate value="<%= new java.util.Date() %>" pattern="yyyy"/> EventSphere. All rights reserved.</div>
    </div>
    <div class="footer-links">
        <a href="#">Privacy Policy</a>
        <a href="#">Terms of Service</a>
        <a href="#">Contact Us</a>
    </div>
</footer>

<script>
    let _bookPrice = 0;
    let _bookSeats = 0;

    function showView(name) {
        document.querySelectorAll('.view').forEach(v => v.style.display = 'none');
        document.querySelectorAll('.nav-item').forEach(n => n.classList.remove('active'));
        const target = document.getElementById('view-' + name);
        if (target) target.style.display = 'block';
        const map = { discover: 0, bookings: 1 };
        const items = document.querySelectorAll('.nav-item');
        if (items[map[name]]) items[map[name]].classList.add('active');
        window.scrollTo({ top: 0, behavior: 'smooth' });
    }

    function openBookModal(id, title, price, seatsLeft) {
        _bookPrice = Number(price) || 0;
        _bookSeats = Number(seatsLeft) || 0;
        document.getElementById('bookEventId').value = id;
        document.getElementById('bookEventTitle').textContent = title;

        const qty = document.getElementById('bookQuantity');
        qty.value = 1;
        qty.max = Math.max(1, Math.min(10, _bookSeats || 10));

        document.getElementById('bookSeatsLeft').textContent =
            _bookSeats > 0 ? (_bookSeats + ' seat(s) available') : '';

        updateTotal();
        document.getElementById('bookModal').style.display = 'flex';
    }

    function updateTotal() {
        const qty = parseInt(document.getElementById('bookQuantity').value, 10) || 1;
        const total = (qty * _bookPrice).toFixed(2);
        document.getElementById('bookTotal').textContent = total;
    }

    function validateBooking() {
        const qty = parseInt(document.getElementById('bookQuantity').value, 10);
        if (isNaN(qty) || qty < 1) {
            alert('Please enter a valid quantity.');
            return false;
        }
        if (qty > 10) {
            alert('Maximum 10 tickets per booking.');
            return false;
        }
        if (_bookSeats > 0 && qty > _bookSeats) {
            alert('Only ' + _bookSeats + ' ticket(s) remaining.');
            return false;
        }
        return true;
    }

    function closeModal(id) {
        document.getElementById(id).style.display = 'none';
    }

    document.getElementById('bookModal').addEventListener('click', function(e) {
        if (e.target === this) closeModal('bookModal');
    });

    showView('discover');
</script>
</body>
</html>