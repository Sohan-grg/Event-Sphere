<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login – EventSphere</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/Login.css">
</head>
<body>

<div class="wrapper">
    <div class="card">
        <h2>LOGIN</h2>

        <%-- FIX: attribute name changed to errorMessage to match servlet --%>
        <c:if test="${not empty errorMessage}">
            <p class="error"><c:out value="${errorMessage}"/></p>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="post">

            <%-- FIX: name="fullName" (no space) — matches getParameter("fullName") --%>
            <div class="input-box">
                <input type="text" name="fullName" placeholder="Full Name"
                       value="<c:out value='${param.fullName}'/>" required/>
            </div>

            <%-- FIX: name="password" (lowercase) — matches getParameter("password") --%>
            <div class="input-box">
                <input type="password" name="password" placeholder="Password" required/>
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
