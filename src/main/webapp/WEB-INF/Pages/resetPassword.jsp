<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reset Password – EventSphere</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/Login.css">
</head>
<body>

<div class="wrapper">
    <div class="card">

        <h2>Reset Password</h2>

        <c:choose>
            <c:when test="${invalid}">
                <p class="subtitle">This reset link is invalid or has expired.</p>
                <c:if test="${not empty errorMessage}">
                    <p class="error"><c:out value="${errorMessage}"/></p>
                </c:if>
                <a href="${pageContext.request.contextPath}/forgot" class="btn">Request a New Link</a>
                <div class="login-link">
                    <a href="${pageContext.request.contextPath}/login">← Back to Login</a>
                </div>
            </c:when>

            <c:otherwise>
                <p class="subtitle">
                    Setting a new password for
                    <strong><c:out value="${email}"/></strong>.
                </p>

                <c:if test="${not empty errorMessage}">
                    <p class="error"><c:out value="${errorMessage}"/></p>
                </c:if>

                <form action="${pageContext.request.contextPath}/reset" method="post" style="width:100%">
                    <input type="hidden" name="token" value="<c:out value='${token}'/>"/>

                    <div class="input-box">
                        <label for="password">New Password</label>
                        <input type="password" id="password" name="password"
                               placeholder="At least 6 chars · letter + digit"
                               required minlength="6" maxlength="60"/>
                    </div>

                    <div class="input-box">
                        <label for="confirmPassword">Confirm Password</label>
                        <input type="password" id="confirmPassword" name="confirmPassword"
                               placeholder="Re-enter password"
                               required minlength="6" maxlength="60"/>
                    </div>

                    <button type="submit" class="btn">Update Password</button>

                    <div class="login-link">
                        <a href="${pageContext.request.contextPath}/login">← Back to Login</a>
                    </div>
                </form>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script>
    // Light client-side check; the server validates authoritatively.
    document.querySelector('form')?.addEventListener('submit', e => {
        const pw = document.getElementById('password');
        const cf = document.getElementById('confirmPassword');
        if (pw && cf && pw.value !== cf.value) {
            e.preventDefault();
            alert('The two passwords do not match.');
            cf.focus();
        }
    });
</script>

</body>
</html>