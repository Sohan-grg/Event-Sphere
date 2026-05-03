package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Event;
import service.EventService;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Collections;
import java.util.List;

/**
 * Public landing page (the first thing any visitor sees). Pulls a few
 * upcoming published events to highlight on the page.
 */
@WebServlet({"/landing", "/about", "/contact"})
public class LandingController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final String LANDING_JSP = "/WEB-INF/Pages/landing.jsp";

    private final EventService eventService = new EventService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Event> featured = Collections.emptyList();
        try {
            List<Event> all = eventService.findPublishedEvents(null, null);
            // show at most 3 events on the landing
            featured = all.size() > 3 ? all.subList(0, 3) : all;
        } catch (SQLException ex) {
            ex.printStackTrace();
            request.setAttribute("errorMessage", "Unable to load featured events.");
        }

        request.setAttribute("featured", featured);

        // Provide the section anchor based on the path that hit us, so
        // /about and /contact scroll to the matching landing section.
        String path = request.getServletPath();
        if ("/about".equals(path))   request.setAttribute("scrollTo", "about");
        if ("/contact".equals(path)) request.setAttribute("scrollTo", "contact");

        request.getRequestDispatcher(LANDING_JSP).forward(request, response);
    }
}