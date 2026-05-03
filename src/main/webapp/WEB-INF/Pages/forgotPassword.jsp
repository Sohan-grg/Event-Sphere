<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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

<div class="wrapper">
    <div class="card">

        <c:choose>
            <%-- ───── STEP 2: token issued, show simulated reset link ───── --%>
            <c:when test="${step eq 'sent'}">
                <h2>Check your inbox</h2>
                <p class="subtitle">
                    We've prepared a password reset link for
                    <strong><c:out value="${submittedEmail}"/></strong>.
                </p>

                <div class="info-box">
                    <strong>Demo mode:</strong> emailing isn't configured, so the link
                    is shown below. In production this would be sent to your inbox.
                </div>

                <div class="reset-link-box">
                    <span>${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}<c:out value="${resetLink}"/></span>
                </div>

                <a href="<c:out value='${resetLink}'/>" class="btn">Open Reset Link</a>

                <div class="login-link">
                    <a href="${pageContext.request.contextPath}/login">← Back to Login</a>
                </div>
            </c:when>

            <%-- ───── STEP 1: ask for the email ───── --%>
            <c:otherwise>
                <h2>Forgot Password?</h2>
                <p class="subtitle">Enter your email and we'll send you a reset link.</p>

                <c:if test="${not empty errorMessage}">
                    <p class="error"><c:out value="${errorMessage}"/></p>
                </c:if>

                <form action="${pageContext.request.contextPath}/forgot" method="post" style="width:100%">

                    <div class="input-box">
                        <label for="email">Email Address</label>
                        <input type="email" id="email" name="email"
                               placeholder="alex@eventsphere.com"
                               value="<c:out value='${submittedEmail}'/>"
                               required maxlength="150"/>
                    </div>

                    <button type="submit" class="btn">Send Reset Link</button>

                    <div class="login-link">
                        Remembered it?
                        <a href="${pageContext.request.contextPath}/login">Back to Login</a>
                    </div>
                </form>
            </c:otherwise>
        </c:choose>

    </div>
</div>

</body>
</html>