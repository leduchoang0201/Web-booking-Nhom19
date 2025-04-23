package controller;

import java.io.IOException;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import model.User;
import dao.UserDAO;

@WebFilter(filterName = "cookieFilter", urlPatterns = {"/*" })
public class CookieFilter implements Filter {

    public CookieFilter() {}

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void destroy() {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpSession session = req.getSession(false); 
        User user = (session != null) ? (User) session.getAttribute("User") : null;
        if (user != null) {
            chain.doFilter(request, response);
            return;
        }

        String email = GetCookie.getUserNameInCookie(req);
        if (email != null) {
            UserDAO userDAO = new UserDAO();
            User userFromDb = userDAO.getUserByEmail(email);

            if (userFromDb != null) {
                if (session == null) {
                    session = req.getSession();
                }
                session.setAttribute("User", userFromDb);
            }
        }

        chain.doFilter(request, response);
    }
}
