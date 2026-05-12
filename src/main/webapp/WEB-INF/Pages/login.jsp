<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign in – EventSphere</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/Login.css">
</head>
<body>

<!-- Decorative background rings (left + right) -->
<div class="bg-rings bg-rings-left"  aria-hidden="true"></div>
<div class="bg-rings bg-rings-right" aria-hidden="true"></div>

<main class="page">
    <div class="login-card">

        <!-- Brand mark (rocket) -->
        <div class="brand-mark">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                <path d="M4.5 16.5c-1.5 1.26-2 5-2 5s3.74-.5 5-2c.71-.84.7-2.13-.09-2.91a2.18 2.18 0 0 0-2.91-.09z"/>
                <path d="M12 15 9 12a11 11 0 0 1 8-7c0 4-1.59 6.36-4 8-1 .68-3 2-3 2z"/>
                <path d="M9 12s-3 1-5 2 2 6 2 6"/>
                <path d="M14.5 3.5c2.5-1 5 0 5 0s.5 2.5-1 5"/>
            </svg>
        </div>

        <h1 class="brand-title">EventSphere</h1>
        <p class="brand-sub">The Digital Concierge for Elite Events</p>

        <c:if test="${not empty sessionScope.successMessage}">
            <div class="alert alert-success">
                <c:out value="${sessionScope.successMessage}"/>
            </div>
            <c:remove var="successMessage" scope="session"/>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-error">
                <c:out value="${errorMessage}"/>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="post" class="login-form" novalidate>

            <!-- ACCESS ROLE -->
            <fieldset class="role-group">
                <legend>ACCESS ROLE</legend>
                <div class="role-tiles">

                    <label class="role-tile">
                        <input type="radio" name="role" value="attendee" checked/>
                        <div class="role-inner">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                                <circle cx="12" cy="7" r="4"/>
                            </svg>
                            <span>Attendee</span>
                        </div>
                    </label>

                    <label class="role-tile">
                        <input type="radio" name="role" value="organizer"/>
                        <div class="role-inner">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                                <path d="M5 21V11l3-3h8l3 3v10"/>
                                <path d="M9 21v-6h6v6"/>
                                <path d="M3 21h18"/>
                            </svg>
                            <span>Organizer</span>
                        </div>
                    </label>

                </div>
            </fieldset>

            <!-- FULL NAME -->
<div class="field">
    <label for="fullName">FULL NAME</label>
    <div class="field-input">
        <svg class="field-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
            <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
            <circle cx="12" cy="7" r="4"/>
        </svg>
        <input type="text" id="fullName" name="fullName" required
               placeholder="Full Name"
               value="<c:out value='${param.fullName}'/>" maxlength="60"/>
    </div>
</div>

            <!-- PASSWORD -->
            <div class="field">
                <div class="label-row">
                    <label for="password">PASSWORD</label>
                    <a href="${pageContext.request.contextPath}/forgot" class="forgot-link">Forgot?</a>
                </div>
                <div class="field-input">
                    <svg class="field-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                        <rect x="3" y="11" width="18" height="11" rx="2"/>
                        <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                    </svg>
                    <input type="password" id="password" name="password" required
                           placeholder="••••••••" minlength="6"/>
                </div>
            </div>

            <!-- SIGN IN -->
            <button type="submit" class="btn-signin">
                Sign In
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4">
                    <line x1="5" y1="12" x2="19" y2="12"/>
                    <polyline points="12 5 19 12 12 19"/>
                </svg>
            </button>

            <p class="register-prompt">
                New to EventSphere?
                <a href="${pageContext.request.contextPath}/register">Register Account</a>
            </p>
        </form>
    </div>

    <!-- Trust block -->
    <div class="trust-block">
        <span class="trust-label">TRUSTED BY INDUSTRY LEADERS</span>
        <div class="trust-icons">
            <svg viewBox="0 0 24 24" fill="currentColor"><path d="M12 2 2 9l10 13L22 9z"/></svg>
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                <path d="M12 2 14 8h6l-5 4 2 7-7-5-7 5 2-7-5-4h6z"/>
            </svg>
            <svg viewBox="0 0 24 24" fill="currentColor">
                <path d="M12 1 9 4 5 4 4 8 1 11l3 3-1 5 4-1 3 4 2-3h2l2 3 3-4 4 1-1-5 3-3-3-3-1-4-4 0z"/>
            </svg>
        </div>
    </div>
</main>

<footer class="login-footer">
    <span>© <fmt:formatDate value="<%= new java.util.Date() %>" pattern="yyyy"/> EventSphere. All rights reserved.</span>
    <nav>
        <a href="#">Privacy Policy</a>
        <a href="#">Terms of Service</a>
        <a href="#">Contact Us</a>
    </nav>
</footer>

</body>
</html>