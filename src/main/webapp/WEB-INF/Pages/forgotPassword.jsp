<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forgot Password – EventSphere</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/Login.css">
</head>
<body>

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

        <c:choose>
            <%-- ───── STEP 2: token issued, show simulated reset link ───── --%>
            <c:when test="${step eq 'sent'}">
                <h1 class="brand-title">Check your inbox</h1>
                <p class="brand-sub">
                    We've prepared a reset link for
                    <strong><c:out value="${submittedEmail}"/></strong>
                </p>

                <div class="info-box">
                    <strong>Demo mode:</strong> emailing isn't configured, so the link is shown below.
                </div>

                <div class="reset-link-box">
                    ${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}<c:out value="${resetLink}"/>
                </div>

                <a href="<c:out value='${resetLink}'/>" class="btn-signin" style="text-decoration:none">
                    Open Reset Link
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4">
                        <line x1="5" y1="12" x2="19" y2="12"/>
                        <polyline points="12 5 19 12 12 19"/>
                    </svg>
                </a>

                <p class="register-prompt">
                    <a href="${pageContext.request.contextPath}/login">← Back to Login</a>
                </p>
            </c:when>

            <%-- ───── STEP 1: ask for the email ───── --%>
            <c:otherwise>
                <h1 class="brand-title">Forgot Password?</h1>
                <p class="brand-sub">Enter your email and we'll send you a reset link.</p>

                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-error"><c:out value="${errorMessage}"/></div>
                </c:if>

                <form action="${pageContext.request.contextPath}/forgot" method="post" class="login-form" novalidate>

                    <div class="field">
                        <label for="email">EMAIL ADDRESS</label>
                        <div class="field-input">
                            <svg class="field-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                                <rect x="2" y="4" width="20" height="16" rx="2"/>
                                <path d="m2 7 10 7 10-7"/>
                            </svg>
                            <input type="email" id="email" name="email" required
                                   placeholder="*****@email.com"
                                   value="<c:out value='${submittedEmail}'/>" maxlength="150"/>
                        </div>
                    </div>

                    <button type="submit" class="btn-signin">
                        Send Reset Link
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4">
                            <line x1="5" y1="12" x2="19" y2="12"/>
                            <polyline points="12 5 19 12 12 19"/>
                        </svg>
                    </button>

                    <p class="register-prompt">
                        Remembered it?
                        <a href="${pageContext.request.contextPath}/login">Back to Login</a>
                    </p>
                </form>
            </c:otherwise>
        </c:choose>
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