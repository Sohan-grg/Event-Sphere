<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EventSphere – Organizer Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/dashboard.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&family=Inter:ital,wght@0,300;0,400;0,500;0,600;0,700;1,400&display=swap" rel="stylesheet">
</head>
<body>

<%-- ═══════════════════════════════════════════════════════════════
     LAYOUT
     ═══════════════════════════════════════════════════════════════ --%>
<div class="layout">

    <%-- ── SIDEBAR ─────────────────────────────────────────────── --%>
    <aside class="sidebar">
        <div class="sidebar-brand">
            <span class="brand-dot"></span>EventSphere
        </div>

        <div class="sidebar-profile">
            <div class="avatar">${fn:substring(sessionScope.fullName, 0, 1)}</div>
            <div>
                <div class="profile-name"><c:out value="${sessionScope.fullName}"/></div>
                <div class="profile-role">Pro Organizer</div>
            </div>
        </div>

        <nav class="sidebar-nav">
            <a href="#" class="nav-item active" onclick="showView('dashboard')">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                    <rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/>
                    <rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/>
                </svg>
                Dashboard
            </a>
            <a href="#" class="nav-item " onclick="showView('myevents')">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                    <rect x="3" y="4" width="18" height="18" rx="2"/><line x1="16" y1="2" x2="16" y2="6"/>
                    <line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/>
                </svg>
                My Events
            </a>
            <a href="#" class="nav-item" onclick="showView('create')">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                    <circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="16"/>
                    <line x1="8" y1="12" x2="16" y2="12"/>
                </svg>
                Create Event
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

    <%-- ── MAIN ────────────────────────────────────────────────── --%>
    <main class="main">

        <%-- Flash messages --%>
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

        <%-- ══════════════════════════════════
             VIEW 1 — DASHBOARD
             ══════════════════════════════════ --%>
        <section id="view-dashboard" class="view">
            <div class="page-header">
                <div>
                    <h1>Morning, <c:out value="${sessionScope.fullName}"/></h1>
                    <p class="page-sub">+12% PERFORMANCE SINCE LAST WEEK</p>
                </div>
                <div class="header-actions">
                    <button class="btn-ghost">Generate Report</button>
                    <button class="btn-primary" onclick="showView('create')">+ New Event</button>
                </div>
            </div>

            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon stat-blue">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><rect x="3" y="4" width="18" height="18" rx="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
                    </div>
                    <div class="stat-info">
                        <span class="stat-badge">+4 This Month</span>
                        <div class="stat-label">TOTAL EVENTS</div>
                        <div class="stat-value">${eventCount}</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon stat-purple">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M20 12V22H4V12"/><path d="M22 7H2v5h20V7z"/><path d="M12 22V7"/><path d="M12 7H7.5a2.5 2.5 0 0 1 0-5C11 2 12 7 12 7z"/><path d="M12 7h4.5a2.5 2.5 0 0 0 0-5C13 2 12 7 12 7z"/></svg>
                    </div>
                    <div class="stat-info">
                        <span class="stat-badge">+128 This Week</span>
                        <div class="stat-label">TOTAL BOOKINGS</div>
                        <div class="stat-value">${totalRegistrations}</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon stat-gray">
                        <div class="stat-icon stat-gray">Rs</div>
                    </div>
                    <div class="stat-info">
                        <span class="stat-badge">89% Target</span>
                        <div class="stat-label">TOTAL REVENUE</div>
                        <div class="stat-value">${totalRevenue}</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon stat-gray">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
                    </div>
                    <div class="stat-info">
                        <span class="stat-badge">+5.2%</span>
                        <div class="stat-label">UNIQUE VISITORS</div>
                        <div class="stat-value">0</div>
                    </div>
                </div>
            </div>

            <div class="section-card">
                <div class="section-header">
                    <h2>Recent Events</h2>
                    <div class="tab-group">
                        <button class="tab active">Active</button>
                        <button class="tab">Past</button>
                    </div>
                </div>
                <table class="events-table">
                    <thead>
                        <tr>
                            <th>EVENT NAME</th>
                            <th>CATEGORY</th>
                            <th>DATE</th>
                            <th>STATUS</th>
                            <th>REVENUE</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="ev" items="${events}">
                        <tr>
                            <td>
                                <div class="event-name-cell">
                                    <div class="event-thumb">${fn:substring(ev.category,0,1)}</div>
                                    <div>
                                        <div class="event-title"><c:out value="${ev.title}"/></div>
                                        <div class="event-meta">${ev.ticketsSold} Attendees</div>
                                    </div>
                                </div>
                            </td>
                            <td><span class="badge badge-${fn:toLowerCase(ev.category)}"><c:out value="${ev.category}"/></span></td>
                            <td>
                                <c:if test="${ev.eventDate != null}">
                                    <fmt:formatDate value="${ev.eventDate}" pattern="MMM dd, yyyy"/><br/>
                                    <span class="event-meta"><fmt:formatDate value="${ev.eventDate}" pattern="hh:mm a"/></span>
                                </c:if>
                            </td>
                            <td>
                                <span class="status-dot status-${fn:toLowerCase(ev.status)}"></span>
                                <c:out value="${ev.status}"/>
                            </td>
                            <td class="revenue-cell">Rs.<fmt:formatNumber value="${ev.revenue}" pattern="#,##0.00"/></td>
                            <td>
                                <button class="icon-btn">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="5" r="1"/><circle cx="12" cy="12" r="1"/><circle cx="12" cy="19" r="1"/></svg>
                                </button>
                            </td>
                        </tr>
                        </c:forEach>
                        <c:if test="${empty events}">
                        <tr><td colspan="6" class="empty-row">No events yet. <a href="#" onclick="showView('create')">Create your first event →</a></td></tr>
                        </c:if>
                    </tbody>
                </table>
                <div class="table-footer">
                    <span>Showing ${eventCount} events</span>
                </div>
            </div>
        </section>

        <%-- ══════════════════════════════════
             VIEW 2 — MY EVENTS
             ══════════════════════════════════ --%>
        <section id="view-myevents" class="view" style="display:none">
            <div class="page-header">
                <div>
                    <h1>My Events</h1>
                    <p class="page-sub">MANAGING ${eventCount} ACTIVE PRODUCTIONS</p>
                </div>
                <div class="header-actions">
                    <div class="search-wrap">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                        <input type="text" id="eventSearch" placeholder="Search events..." oninput="filterEvents(this.value)"/>
                    </div>
                    <button class="btn-primary" onclick="showView('create')">+ New Event</button>
                </div>
            </div>

            <%-- Stats row --%>
            <div class="mini-stats">
                <div class="mini-stat">
                    <div class="mini-label">TOTAL REGISTRATIONS</div>
                    <div class="mini-value blue">${totalRegistrations}</div>
                    <div class="mini-sub">+12% from last month</div>
                </div>
                <div class="mini-stat">
                    <div class="mini-label">ACTIVE WAITLISTS</div>
                    <div class="mini-value purple">${activeWaitlists}</div>
                    <div class="mini-sub">Across ${eventCount} events</div>
                </div>
                <div class="mini-stat">
                    <div class="mini-label">REVENUE GENERATED</div>
                    <div class="mini-value">${totalRevenue}</div>
                    <div class="mini-sub">Payout processed</div>
                </div>
                <div class="mini-stat">
                    <div class="mini-label">AVERAGE RATING</div>
                    <div class="mini-value">${avgRating}</div>
                    <div class="mini-sub">★ Top Tier Organizer</div>
                </div>
            </div>

            <%-- Event cards --%>
            <div id="eventCardList">
            <c:forEach var="ev" items="${events}">
            <div class="event-card" data-title="${fn:toLowerCase(ev.title)}">
                <div class="event-card-thumb thumb-${fn:toLowerCase(ev.category)}">
                    <span>${fn:substring(ev.title,0,3)}</span>
                </div>
                <div class="event-card-body">
                    <div class="event-card-top">
                        <span class="badge badge-${fn:toLowerCase(ev.category)}"><c:out value="${ev.category}"/></span>
                        <span class="status-pill status-pill-${fn:toLowerCase(ev.status)}">
                            <span class="dot"></span><c:out value="${ev.status}"/>
                        </span>
                    </div>
                    <div class="event-card-title"><c:out value="${ev.title}"/></div>
                    <div class="event-card-loc">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" width="13" height="13"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>
                        <c:out value="${ev.location}"/>
                    </div>
                </div>
                <div class="event-card-tickets">
                    <div class="tickets-count">${ev.ticketsSold}/${ev.capacity}</div>
                    <div class="tickets-label">
                        <c:choose>
                            <c:when test="${ev.soldOut}">Sold Out</c:when>
                            <c:otherwise>Tickets Sold</c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="event-card-actions">
                    <button class="icon-btn" title="Edit"
onclick="openEditModal(${ev.id}, '${ev.title}', '${ev.category}', '${ev.location}', ${ev.capacity}, ${ev.ticketPrice}, '${ev.status}')">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                    </button>
                    <button class="icon-btn icon-btn-danger" title="Delete" onclick="confirmDelete(${ev.id}, '${ev.title}')">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><polyline points="3 6 5 6 21 6"/><path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"/><path d="M10 11v6"/><path d="M14 11v6"/><path d="M9 6V4h6v2"/></svg>
                    </button>
                    <button class="icon-btn" title="More">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="5" r="1"/><circle cx="12" cy="12" r="1"/><circle cx="12" cy="19" r="1"/></svg>
                    </button>
                </div>
            </div>
            </c:forEach>
            <c:if test="${empty events}">
                <div class="empty-state">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" width="48" height="48"><rect x="3" y="4" width="18" height="18" rx="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
                    <p>No events yet.</p>
                    <button class="btn-primary" onclick="showView('create')">Create your first event</button>
                </div>
            </c:if>
            </div>
        </section>

        <%-- ══════════════════════════════════
             VIEW 3 — CREATE EVENT
             ══════════════════════════════════ --%>
        <section id="view-create" class="view" style="display:none">
            <div class="page-header">
                <div>
                    <p class="page-sub">EVENT CREATION HUB</p>
                    <h1 class="hero-title">Bring your vision to life.</h1>
                    <p class="page-sub normal">Define the details of your upcoming gathering.</p>
                </div>
            </div>

            <div class="create-layout">
                <div class="create-form-wrap section-card">
                    <form action="${pageContext.request.contextPath}/organizerDashboard" method="post">
                        <input type="hidden" name="action" value="create"/>

                        <div class="field-group">
                            <label>EVENT TITLE</label>
                            <input type="text" name="title" placeholder="e.g. Global Tech Summit 2024" required/>
                        </div>

                        <div class="field-group">
                            <label>DESCRIPTION</label>
                            <textarea name="description" rows="5"
                                      placeholder="Tell your audience what makes this event special..."
                                      oninput="updatePreview(this.value)"></textarea>
                        </div>

                        <div class="field-row">
                            <div class="field-group">
                                <label>DATE &amp; TIME</label>
                                <input type="datetime-local" name="eventDate"/>
                            </div>
                            <div class="field-group">
                                <label>LOCATION</label>
                                <div class="input-icon-wrap">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>
                                    <input type="text" name="location" placeholder="Venue name or city"/>
                                </div>
                            </div>
                        </div>

                        <div class="field-row">
                            <div class="field-group">
                                <label>TICKET PRICE ($)</label>
                                <div class="input-icon-wrap">
                                    <span class="input-prefix">Rs</span>
                                    <input type="number" name="ticketPrice" min="0" step="0.01" placeholder="0.00" style="padding-left:28px"/>
                                </div>
                            </div>
                            <div class="field-group">
                                <label>CAPACITY</label>
                                <div class="input-icon-wrap">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
                                    <input type="number" name="capacity" min="0" placeholder="Max attendees"/>
                                </div>
                            </div>
                        </div>

                        <div class="field-group">
                            <label>CATEGORY</label>
                            <select name="category">
                                <option value="Corporate">Corporate</option>
                                <option value="Social">Social</option>
                                <option value="Creative">Creative</option>
                                <option value="General">General</option>
                            </select>
                        </div>

                        <div class="form-actions">
                            <button type="submit" name="status" value="Published" class="btn-primary">
                                Publish Event →
                            </button>
                            <button type="submit" name="status" value="Draft" class="btn-ghost">
                                Save as Draft
                            </button>
                        </div>
                    </form>
                </div>

                <div class="create-sidebar">
                    <div class="preview-card section-card">
                        <h3>Event Preview</h3>
                        <div class="preview-thumb">
                            <span class="preview-badge">NEW EVENT</span>
                        </div>
                        <div class="preview-lines">
                            <div class="preview-line w80"></div>
                            <div class="preview-line w60"></div>
                            <div class="preview-line w70"></div>
                        </div>
                    </div>

                    <div class="tips-card section-card">
                        <h3>ORGANIZER TIPS</h3>
                        <div class="tip">
                            <span class="tip-dot purple"></span>
                            <p>Adding a clear <strong>venue address</strong> increases booking conversion by 40%.</p>
                        </div>
                        <div class="tip">
                            <span class="tip-dot blue"></span>
                            <p>High-quality banner images attract more attention in the <strong>Explore</strong> feed.</p>
                        </div>
                    </div>
                </div>
            </div>
        </section>

    </main>
</div>

<%-- ═══════════════════════════════════════════════════════════════
     DELETE CONFIRMATION MODAL
     ═══════════════════════════════════════════════════════════════ --%>
<div id="deleteModal" class="modal-overlay" style="display:none">
    <div class="modal">
        <div class="modal-icon danger">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="28" height="28">
                <polyline points="3 6 5 6 21 6"/><path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"/>
                <path d="M9 6V4h6v2"/>
            </svg>
        </div>
        <h3 class="modal-title">Delete Event?</h3>
        <p class="modal-body">You are about to delete <strong id="deleteEventName"></strong>. This action cannot be undone.</p>
        <div class="modal-actions">
            <button class="btn-ghost" onclick="closeModal('deleteModal')">Cancel</button>
            <form id="deleteForm" action="${pageContext.request.contextPath}/organizerDashboard" method="post" style="display:inline">
                <input type="hidden" name="action" value="delete"/>
                <input type="hidden" name="id" id="deleteEventId"/>
                <button type="submit" class="btn-danger">Delete</button>
            </form>
        </div>
    </div>
</div>

<div id="editModal" class="modal-overlay" style="display:none">
    <div class="modal premium-modal">

        <div class="modal-header">
            <h2>Edit Event</h2>
            <span class="close-btn" onclick="closeModal('editModal')">✕</span>
        </div>

        <form method="post" action="${pageContext.request.contextPath}/organizerDashboard">

            <input type="hidden" name="action" value="edit"/>
            <input type="hidden" name="id" id="editId"/>

            <div class="form-group">
                <input type="text" id="editTitle" name="title" required>
                <label>Event Title</label>
            </div>

            <div class="form-group">
                <input type="text" id="editCategory" name="category">
                <label>Category</label>
            </div>

            <div class="form-group">
                <input type="text" id="editLocation" name="location">
                <label>Location</label>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <input type="number" id="editCapacity" name="capacity">
                    <label>Capacity</label>
                </div>

                <div class="form-group">
                    <input type="number" id="editPrice" name="ticketPrice">
                    <label>Ticket Price</label>
                </div>
            </div>
            
            <div class="toggle-row">

    <span>Draft</span>

    <label class="switch">
        <input type="checkbox" id="statusToggle" name="status" value="Published">
        <span class="slider"></span>
    </label>

    <span>Published</span>

</div>

            <div class="modal-actions">
                <button type="button" class="btn-secondary" onclick="closeModal('editModal')">
                    Cancel
                </button>
                <button type="submit" class="btn-primary">
                    Update Event
                </button>
            </div>

        </form>
    </div>
</div>

<%-- Footer --%>
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
    // ── View switching ────────────────────────────────────────────
    function showView(name) {
        document.querySelectorAll('.view').forEach(v => v.style.display = 'none');
        document.querySelectorAll('.nav-item').forEach(n => n.classList.remove('active'));
        document.getElementById('view-' + name).style.display = 'block';
        const navMap = { dashboard: 0, myevents: 1, create: 2 };
        const navItems = document.querySelectorAll('.nav-item');
        if (navItems[navMap[name]]) navItems[navMap[name]].classList.add('active');
    }

    // ── Delete modal ──────────────────────────────────────────────
    function confirmDelete(id, title) {
        document.getElementById('deleteEventId').value = id;
        document.getElementById('deleteEventName').textContent = title;
        document.getElementById('deleteModal').style.display = 'flex';
    }

    function closeModal(id) {
        document.getElementById(id).style.display = 'none';
    }

    // Close modal on backdrop click
    document.getElementById('deleteModal').addEventListener('click', function(e) {
        if (e.target === this) closeModal('deleteModal');
    });

    // ── Search filter ─────────────────────────────────────────────
    function filterEvents(query) {
        const q = query.toLowerCase();
        document.querySelectorAll('#eventCardList .event-card').forEach(card => {
            const title = card.dataset.title || '';
            card.style.display = title.includes(q) ? '' : 'none';
        });
    }

    // ── Edit stub ─────────────────────────────────────────────────
    function openEditModal(id, title, category, location, capacity, price, status) {
    document.getElementById('editId').value = id;
    document.getElementById('editTitle').value = title;
    document.getElementById('editCategory').value = category;
    document.getElementById('editLocation').value = location;
    document.getElementById('editCapacity').value = capacity;
    document.getElementById('editPrice').value = price;

 //  set toggle
    document.getElementById('statusToggle').checked = (status === 'Published');
 
    document.getElementById('editModal').style.display = 'flex';
}

    // Start on My Events view
    showView('dashboard');
</script>

</body>
</html>