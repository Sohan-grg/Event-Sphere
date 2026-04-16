<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EventSphere – Create Account</title>
    <link rel="stylesheet" href="CSS/register.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
</head>
<body>

<div class="page-wrapper">
    <div class="card">

        <!-- LEFT PANEL -->
        <div class="panel-left">
            <div class="brand">
                <span class="brand-dot"></span>
                <span class="brand-name">EventSphere</span>
            </div>

            <div class="panel-watermark" aria-hidden="true">
                <svg viewBox="0 0 400 400" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <circle cx="200" cy="200" r="190" stroke="white" stroke-opacity="0.08" stroke-width="1"/>
                    <circle cx="200" cy="200" r="140" stroke="white" stroke-opacity="0.06" stroke-width="1"/>
                    <circle cx="200" cy="200" r="90"  stroke="white" stroke-opacity="0.05" stroke-width="1"/>
                    <text x="50%" y="46%" dominant-baseline="middle" text-anchor="middle"
                          font-size="52" font-family="Syne" fill="white" fill-opacity="0.06" font-weight="800">cafe</text>
                    <text x="50%" y="58%" dominant-baseline="middle" text-anchor="middle"
                          font-size="38" font-family="Syne" fill="white" fill-opacity="0.06" font-weight="800">NETWORK</text>
                </svg>
            </div>

            <div class="panel-hero">
                <h1>Your journey to<br>exceptional<br>events starts here.</h1>
                <p>Join the most innovative platform for event organizers and attendees. Manage, explore, and experience with ease.</p>
            </div>

            <div class="panel-badges">
                <span>Curated<br>Experience</span>
                <span class="sep">•</span>
                <span>Editorial<br>Control</span>
                <span class="sep">•</span>
                <span>Digital<br>Concierge</span>
            </div>
        </div>

        <!-- RIGHT PANEL -->
        <div class="panel-right">
            <div class="form-header">
                <h2>Create an account</h2>
                <p>Already have an account? <a href="${pageContext.request.contextPath}/login">Login</a></p>
            </div>

            <!-- Server-side error/success messages via JSTL -->
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-error">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                    <c:out value="${errorMessage}"/>
                </div>
            </c:if>
            <c:if test="${not empty successMessage}">
                <div class="alert alert-success">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="20 6 9 17 4 12"/></svg>
                    <c:out value="${successMessage}"/>
                </div>
            </c:if>

            <form action="register" method="post" novalidate>
                <!-- CSRF Token -->
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>

                <!-- Full Name -->
                <div class="field-group <c:if test='${not empty fieldErrors.fullName}'>has-error</c:if>">
                    <label for="fullName">Full Name</label>
                    <div class="input-wrap">
                        <svg class="input-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                            <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                            <circle cx="12" cy="7" r="4"/>
                        </svg>
                        <input type="text" id="fullName" name="fullName"
                               placeholder="Alex Morgan"
                               value="<c:out value='${param.fullName}'/>"
                               required autocomplete="name"/>
                    </div>
                    <c:if test="${not empty fieldErrors.fullName}">
                        <span class="field-error"><c:out value="${fieldErrors.fullName}"/></span>
                    </c:if>
                </div>

                <!-- Email -->
                <div class="field-group <c:if test='${not empty fieldErrors.email}'>has-error</c:if>">
                    <label for="email">Email Address</label>
                    <div class="input-wrap">
                        <svg class="input-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                            <rect x="2" y="4" width="20" height="16" rx="2"/>
                            <path d="m2 7 10 7 10-7"/>
                        </svg>
                        <input type="email" id="email" name="email"
                               placeholder="alex@eventsphere.com"
                               value="<c:out value='${param.email}'/>"
                               required autocomplete="email"/>
                    </div>
                    <c:if test="${not empty fieldErrors.email}">
                        <span class="field-error"><c:out value="${fieldErrors.email}"/></span>
                    </c:if>
                </div>

                <!-- Password -->
                <div class="field-group <c:if test='${not empty fieldErrors.password}'>has-error</c:if>">
                    <label for="password">Password</label>
                    <div class="input-wrap">
                        <svg class="input-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                            <rect x="3" y="11" width="18" height="11" rx="2"/>
                            <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                        </svg>
                        <input type="password" id="password" name="password"
                               placeholder="••••••••"
                               required autocomplete="new-password"/>
                        <button type="button" class="toggle-pw" aria-label="Toggle password visibility" onclick="togglePassword()">
                            <svg id="eye-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                                <circle cx="12" cy="12" r="3"/>
                            </svg>
                        </button>
                    </div>
                    <c:if test="${not empty fieldErrors.password}">
                        <span class="field-error"><c:out value="${fieldErrors.password}"/></span>
                    </c:if>
                </div>

                <!-- Role -->
                <div class="field-group <c:if test='${not empty fieldErrors.role}'>has-error</c:if>">
                    <label for="role">Select Role</label>
                    <div class="input-wrap select-wrap">
                        <svg class="input-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                            <rect x="2" y="7" width="20" height="14" rx="2"/>
                            <path d="M16 7V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v2"/>
                        </svg>
                        <select id="role" name="role" required>
                            <option value="" disabled
                                <c:if test="${empty param.role}">selected</c:if>>Who are you?</option>
                            <c:forEach var="r" items="${roles}">
                                <option value="${r.value}"
                                    <c:if test="${param.role eq r.value}">selected</c:if>>
                                    <c:out value="${r.label}"/>
                                </option>
                            </c:forEach>
                            <%-- Fallback static options if roles not set from servlet --%>
                            <c:if test="${empty roles}">
                                <option value="attendee"  <c:if test="${param.role eq 'attendee'}">selected</c:if>>Attendee</option>
                                <option value="organizer" <c:if test="${param.role eq 'organizer'}">selected</c:if>>Event Organizer</option>
                                <option value="vendor"    <c:if test="${param.role eq 'vendor'}">selected</c:if>>Vendor / Sponsor</option>
                            </c:if>
                        </select>
                        <svg class="chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <polyline points="6 9 12 15 18 9"/>
                        </svg>
                    </div>
                    <c:if test="${not empty fieldErrors.role}">
                        <span class="field-error"><c:out value="${fieldErrors.role}"/></span>
                    </c:if>
                </div>

                <!-- Terms -->
                <div class="terms-row">
                    <input type="checkbox" id="terms" name="terms" value="true"
                           <c:if test="${param.terms eq 'true'}">checked</c:if> required/>
                    <label for="terms">
                        I agree to the <a href="terms.jsp">Terms of Service</a> and <a href="privacy.jsp">Privacy Policy</a>.
                    </label>
                </div>
                <c:if test="${not empty fieldErrors.terms}">
                    <span class="field-error terms-error"><c:out value="${fieldErrors.terms}"/></span>
                </c:if>

                <button type="submit" class="btn-primary">
                    Create Account
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                        <line x1="5" y1="12" x2="19" y2="12"/>
                        <polyline points="12 5 19 12 12 19"/>
                    </svg>
                </button>
            </form>

            <div class="divider"><span>or continue with</span></div>

            <div class="social-row">
                <button type="button" class="btn-social" onclick="location.href='oauth/google'">
                    <svg viewBox="0 0 24 24" width="20" height="20">
                        <path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"/>
                        <path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/>
                        <path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l3.66-2.84z"/>
                        <path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"/>
                    </svg>
                    Google
                </button>
                <button type="button" class="btn-social" onclick="location.href='oauth/apple'">
                    <svg viewBox="0 0 24 24" width="20" height="20" fill="currentColor">
                        <path d="M18.71 19.5c-.83 1.24-1.71 2.45-3.05 2.47-1.34.03-1.77-.79-3.29-.79-1.53 0-2 .77-3.27.82-1.31.05-2.3-1.32-3.14-2.53C4.25 17 2.94 12.45 4.7 9.39c.87-1.52 2.43-2.48 4.12-2.51 1.28-.02 2.5.87 3.29.87.78 0 2.26-1.07 3.8-.91.65.03 2.47.26 3.64 1.98-.09.06-2.17 1.28-2.15 3.81.03 3.02 2.65 4.03 2.68 4.04-.03.07-.42 1.44-1.38 2.83M13 3.5c.73-.83 1.94-1.46 2.94-1.5.13 1.17-.34 2.35-1.04 3.19-.69.85-1.83 1.51-2.95 1.42-.15-1.15.41-2.35 1.05-3.11z"/>
                    </svg>
                    Apple
                </button>
            </div>

            <p class="copyright">© <fmt:formatDate value="<%= new java.util.Date() %>" pattern="yyyy"/> EventSphere. All rights reserved.</p>
        </div>

    </div>
</div>

<script>
    function togglePassword() {
        const input = document.getElementById('password');
        input.type = input.type === 'password' ? 'text' : 'password';
    }

    // Subtle label-float on focus
    document.querySelectorAll('.field-group input, .field-group select').forEach(el => {
        el.addEventListener('focus', () => el.closest('.field-group').classList.add('focused'));
        el.addEventListener('blur',  () => el.closest('.field-group').classList.remove('focused'));
    });
</script>

</body>
</html>
