<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EventSphere – Discover & book unforgettable events</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800;900&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/landing.css">
</head>
<body>

<%-- ════════════  NAVBAR  ════════════ --%>
<header class="nav-wrap">
    <nav class="nav container">
        <a href="${pageContext.request.contextPath}/landing" class="nav-brand">
            <span class="brand-dot"></span>
            <span>EventSphere</span>
        </a>

        <ul class="nav-links">
            <li><a href="#home">Home</a></li>
            <li><a href="#events">Events</a></li>
            <li><a href="#features">Features</a></li>
            <li><a href="#how">How it works</a></li>
            <li><a href="#about">About</a></li>
            <li><a href="#contact">Contact</a></li>
        </ul>

        <div class="nav-cta">
            <c:choose>
                <c:when test="${not empty sessionScope.fullName}">
                    <c:choose>
                        <c:when test="${sessionScope.role eq 'organizer'}">
                            <a href="${pageContext.request.contextPath}/organizerDashboard" class="btn-ghost">Dashboard</a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/home" class="btn-ghost">Dashboard</a>
                        </c:otherwise>
                    </c:choose>
                    <a href="${pageContext.request.contextPath}/logout" class="btn-primary">Logout</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login"    class="btn-ghost">Login</a>
                    <a href="${pageContext.request.contextPath}/register" class="btn-primary">Register</a>
                </c:otherwise>
            </c:choose>
            <button class="hamburger" aria-label="Menu" onclick="toggleMenu()">
                <span></span><span></span><span></span>
            </button>
        </div>
    </nav>
</header>

<%-- ════════════  HERO  ════════════ --%>
<section id="home" class="hero">
    <div class="container hero-grid">
        <div class="hero-text">
            <span class="eyebrow">EventSphere · Live Booking Platform</span>
            <h1>
                Discover <span class="grad">unforgettable</span><br>
                events. Reserve in seconds.
            </h1>
            <p class="hero-sub">
                EventSphere brings together organizers, attendees, and unforgettable moments.
                Browse curated experiences, secure your seat, and manage every event from one
                clean dashboard.
            </p>

            <div class="hero-cta">
                <a href="${pageContext.request.contextPath}/register" class="btn-primary btn-lg">
                    Get Started — It's Free
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4">
                        <line x1="5" y1="12" x2="19" y2="12"/>
                        <polyline points="12 5 19 12 12 19"/>
                    </svg>
                </a>
                <a href="#events" class="btn-ghost btn-lg">Browse Events</a>
            </div>

            <div class="hero-stats">
                <div>
                    <div class="stat-num">500+</div>
                    <div class="stat-lbl">Events hosted</div>
                </div>
                <div>
                    <div class="stat-num">25k</div>
                    <div class="stat-lbl">Happy attendees</div>
                </div>
                <div>
                    <div class="stat-num">4.9★</div>
                    <div class="stat-lbl">Avg. rating</div>
                </div>
            </div>
        </div>

        <div class="hero-visual" aria-hidden="true">
            <div class="ticket-card ticket-1">
                <span class="ticket-tag">CORPORATE</span>
                <div class="ticket-title">Global Tech Summit</div>
                <div class="ticket-meta">📍 Kathmandu · Jun 15</div>
                <div class="ticket-foot">
                    <span class="ticket-price">Rs. 1,500</span>
                    <span class="ticket-cta">Book →</span>
                </div>
            </div>
            <div class="ticket-card ticket-2">
                <span class="ticket-tag tag-pink">SOCIAL</span>
                <div class="ticket-title">Indie Music Night</div>
                <div class="ticket-meta">📍 Thamel · May 25</div>
                <div class="ticket-foot">
                    <span class="ticket-price">Rs. 800</span>
                    <span class="ticket-cta">Book →</span>
                </div>
            </div>
            <div class="ticket-card ticket-3">
                <span class="ticket-tag tag-purple">CREATIVE</span>
                <div class="ticket-title">Writing Workshop</div>
                <div class="ticket-meta">📍 Patan · Jun 02</div>
                <div class="ticket-foot">
                    <span class="ticket-price">Rs. 500</span>
                    <span class="ticket-cta">Book →</span>
                </div>
            </div>
            <div class="orb orb-1"></div>
            <div class="orb orb-2"></div>
        </div>
    </div>
</section>

<%-- ════════════  FEATURED EVENTS  ════════════ --%>
<section id="events" class="section">
    <div class="container">
        <div class="section-head">
            <span class="eyebrow">Featured</span>
            <h2>Upcoming events you'll love</h2>
            <p class="section-sub">Hand-picked experiences happening soon. Reserve your spot before they sell out.</p>
        </div>

        <c:choose>
            <c:when test="${empty featured}">
                <div class="event-grid">
                    <%-- Mock cards when DB empty so the page never looks broken --%>
                    <div class="event-card">
                        <div class="event-thumb thumb-corporate"><span>GTS</span></div>
                        <div class="event-body">
                            <span class="badge badge-corporate">Corporate</span>
                            <h3>Global Tech Summit 2026</h3>
                            <p class="event-meta">📅 Jun 15, 2026 · 10:00 AM</p>
                            <p class="event-meta">📍 Soaltee Hotel, Kathmandu</p>
                            <div class="event-foot">
                                <span class="price">Rs. 1,500</span>
                                <a href="${pageContext.request.contextPath}/login" class="btn-primary btn-sm">Book Now</a>
                            </div>
                        </div>
                    </div>
                    <div class="event-card">
                        <div class="event-thumb thumb-social"><span>IMN</span></div>
                        <div class="event-body">
                            <span class="badge badge-social">Social</span>
                            <h3>Indie Music Night</h3>
                            <p class="event-meta">📅 May 25, 2026 · 7:00 PM</p>
                            <p class="event-meta">📍 House of Music, Thamel</p>
                            <div class="event-foot">
                                <span class="price">Rs. 800</span>
                                <a href="${pageContext.request.contextPath}/login" class="btn-primary btn-sm">Book Now</a>
                            </div>
                        </div>
                    </div>
                    <div class="event-card">
                        <div class="event-thumb thumb-creative"><span>CWS</span></div>
                        <div class="event-body">
                            <span class="badge badge-creative">Creative</span>
                            <h3>Creative Writing Workshop</h3>
                            <p class="event-meta">📅 Jun 02, 2026 · 2:00 PM</p>
                            <p class="event-meta">📍 Yala Maya Kendra, Patan</p>
                            <div class="event-foot">
                                <span class="price">Rs. 500</span>
                                <a href="${pageContext.request.contextPath}/login" class="btn-primary btn-sm">Book Now</a>
                            </div>
                        </div>
                    </div>
                </div>
                <p class="hint center">Sign in to see live availability and reserve tickets.</p>
            </c:when>
            <c:otherwise>
                <div class="event-grid">
                    <c:forEach var="ev" items="${featured}">
                        <div class="event-card">
                            <div class="event-thumb thumb-${fn:toLowerCase(ev.category)}">
                                <span>${fn:substring(ev.title,0,3)}</span>
                            </div>
                            <div class="event-body">
                                <span class="badge badge-${fn:toLowerCase(ev.category)}"><c:out value="${ev.category}"/></span>
                                <h3><c:out value="${ev.title}"/></h3>
                                <p class="event-meta">
                                    📅
                                    <c:choose>
                                        <c:when test="${ev.eventDate != null}">
                                            <fmt:formatDate value="${ev.eventDate}" pattern="MMM dd, yyyy · hh:mm a"/>
                                        </c:when>
                                        <c:otherwise>Date TBA</c:otherwise>
                                    </c:choose>
                                </p>
                                <c:if test="${not empty ev.location}">
                                    <p class="event-meta">📍 <c:out value="${ev.location}"/></p>
                                </c:if>
                                <div class="event-foot">
                                    <span class="price">Rs.<fmt:formatNumber value="${ev.ticketPrice}" pattern="#,##0.00"/></span>
                                    <a href="${pageContext.request.contextPath}/login" class="btn-primary btn-sm">Book Now</a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</section>

<%-- ════════════  FEATURES  ════════════ --%>
<section id="features" class="section section-alt">
    <div class="container">
        <div class="section-head">
            <span class="eyebrow">Why EventSphere</span>
            <h2>Built for organizers and attendees alike</h2>
            <p class="section-sub">Everything you need to plan, promote, and attend events — without the noise.</p>
        </div>

        <div class="feature-grid">
            <div class="feature-card">
                <div class="feature-icon ic-blue">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                </div>
                <h3>Discover with ease</h3>
                <p>Filter by category, location, or date. Find events that match exactly what you're looking for.</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon ic-purple">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M19 14H5l-2 7 9-3 9 3-2-7z"/><path d="M5 14V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2v9"/></svg>
                </div>
                <h3>Instant booking</h3>
                <p>Reserve seats in seconds. Live capacity tracking means no overbooking and no surprises.</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon ic-pink">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></svg>
                </div>
                <h3>Powerful organizer tools</h3>
                <p>Create, edit, and publish events from one dashboard. Track revenue, attendance, and waitlists in real time.</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon ic-green">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                </div>
                <h3>Secure & reliable</h3>
                <p>Role-based access, session locking, and validated input keep your account and data safe.</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon ic-orange">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>
                </div>
                <h3>One-click cancel</h3>
                <p>Plans changed? Cancel any booking instantly and the seat is returned to the pool.</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon ic-blue">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M3 3v18h18"/><polyline points="7 14 11 10 15 13 21 7"/></svg>
                </div>
                <h3>Real-time insights</h3>
                <p>Watch your audience grow with live attendance, revenue, and waitlist analytics.</p>
            </div>
        </div>
    </div>
</section>

<%-- ════════════  HOW IT WORKS  ════════════ --%>
<section id="how" class="section">
    <div class="container">
        <div class="section-head">
            <span class="eyebrow">How it works</span>
            <h2>From registration to reservation in 3 steps</h2>
        </div>

        <div class="step-grid">
            <div class="step-card">
                <span class="step-num">01</span>
                <h3>Create your account</h3>
                <p>Sign up as an attendee or organizer. Takes less than a minute.</p>
            </div>
            <div class="step-card">
                <span class="step-num">02</span>
                <h3>Browse or publish</h3>
                <p>Attendees explore events; organizers publish from the dashboard.</p>
            </div>
            <div class="step-card">
                <span class="step-num">03</span>
                <h3>Book or manage</h3>
                <p>Reserve a ticket — or watch your event fill up in real time.</p>
            </div>
        </div>
    </div>
</section>

<%-- ════════════  ABOUT  ════════════ --%>
<section id="about" class="section section-alt">
    <div class="container about-grid">
        <div>
            <span class="eyebrow">About us</span>
            <h2>We believe great events should be effortless to find — and effortless to host.</h2>
        </div>
        <div class="about-text">
            <p>
                EventSphere was built to remove the friction between organizers and the people who want to attend
                their events. Whether you're hosting a tech summit, a music night, or a community workshop, our
                platform gives you everything you need to publish, sell, and manage seats — without the bloat of
                enterprise event tooling.
            </p>
            <p>
                For attendees, we're a curated home for the moments worth showing up for. Discover what's happening
                near you, book in seconds, and never miss out.
            </p>
        </div>
    </div>
</section>

<%-- ════════════  CONTACT / CTA  ════════════ --%>
<section id="contact" class="section cta-section">
    <div class="container cta-card">
        <h2>Ready to host or attend your next event?</h2>
        <p>Join EventSphere today — free for attendees, no setup fees for organizers.</p>
        <div class="cta-buttons">
            <a href="${pageContext.request.contextPath}/register" class="btn-primary btn-lg">Create Account</a>
            <a href="${pageContext.request.contextPath}/login" class="btn-ghost btn-lg">I already have one</a>
        </div>
        <div class="contact-row">
            <span>📧 hello@eventsphere.com</span>
            <span>📞 +977 1-555-0199</span>
            <span>📍 Kathmandu, Nepal</span>
        </div>
    </div>
</section>

<%-- ════════════  FOOTER  ════════════ --%>
<footer class="footer">
    <div class="container footer-grid">
        <div>
            <div class="footer-brand">
                <span class="brand-dot"></span> EventSphere
            </div>
            <p>The modern home for event discovery and ticketing.</p>
        </div>
        <div>
            <h4>Product</h4>
            <a href="#events">Events</a>
            <a href="#features">Features</a>
            <a href="#how">How it works</a>
        </div>
        <div>
            <h4>Company</h4>
            <a href="#about">About</a>
            <a href="#contact">Contact</a>
            <a href="${pageContext.request.contextPath}/register">Become an organizer</a>
        </div>
        <div>
            <h4>Legal</h4>
            <a href="#">Privacy Policy</a>
            <a href="#">Terms of Service</a>
        </div>
    </div>
    <div class="container footer-bottom">
        <span>© <fmt:formatDate value="<%= new java.util.Date() %>" pattern="yyyy"/> EventSphere. All rights reserved.</span>
    </div>
</footer>

<script>
    // Mobile menu toggle
    function toggleMenu() {
        document.querySelector('.nav-links').classList.toggle('open');
    }

    // Auto-scroll to a section if controller asked us to
    <c:if test="${not empty scrollTo}">
    window.addEventListener('load', () => {
        const el = document.getElementById('${scrollTo}');
        if (el) el.scrollIntoView({ behavior: 'smooth' });
    });
    </c:if>

    // Hide mobile menu after click
    document.querySelectorAll('.nav-links a').forEach(a =>
        a.addEventListener('click', () =>
            document.querySelector('.nav-links').classList.remove('open')));
</script>

</body>
</html>