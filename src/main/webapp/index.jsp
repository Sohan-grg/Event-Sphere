<%@ page session="false" %>
<%--
    Default welcome file. Tomcat serves this when the user opens the project's
    context root (e.g. clicking "Run on Server" in Eclipse). Forwards to the
    LandingController so the page goes through the MVC pipeline.
--%>
<jsp:forward page="/landing"/>