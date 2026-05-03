<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login – EventSphere</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/Login.css">
</head>
<body>

<div class="wrapper">
    <div class="card">
        <h2>Welcome Back</h2>
        <p class="subtitle">Sign in to continue to EventSphere</p>

        <c:if test="${not empty sessionScope.successMessage}">
            <p class="error" style="background:#f0fdf4;color:#16a34a;border-color:#bbf7d0">
                <c:out value="${sessionScope.successMessage}"/>
            </p>
            <c:remove var="successMessage" scope="session"/>
        </c:if>

        <c:if test="${not empty errorMessage}">
            <p class="error"><c:out value="${errorMessage}"/></p>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="post" style="width:100%">

            <div class="input-box">
                <label for="fullName">Full Name</label>
                <input type="text" id="fullName" name="fullName" placeholder="Enter your full name"
                       value="<c:out value='${param.fullName}'/>" required maxlength="60"/>
            </div>

            <div class="input-box">
                <div class="label-row">
                    <label for="password">Password</label>
                    <a href="${pageContext.request.contextPath}/forgot" class="forgot-link">Forgot password?</a>
                </div>
                <input type="password" id="password" name="password" placeholder="Enter your password" required minlength="6"/>
            </div>

            <button type="submit" class="btn">LOGIN</button>

            <div class="login-link">
                Don't have an account?
                <a href="${pageContext.request.contextPath}/register">Register</a>
            </div>

        </form>
    </div>
</div>

</body>
</html>