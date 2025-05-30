package controller;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import model.User;

public class GetCookie {
    private static final String ATT_NAME_USER_NAME = "USER_NAME_COOKIE";

    public static void storeUserCookie(HttpServletResponse response, User user) {
    	Cookie cookieUserName = new Cookie(ATT_NAME_USER_NAME, user.getEmail());
        cookieUserName.setMaxAge(24 * 60 * 60); 
        response.addCookie(cookieUserName);
    }

    public static String getUserNameInCookie(HttpServletRequest request) {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (ATT_NAME_USER_NAME.equals(cookie.getName())) {
                    return cookie.getValue();
                }
            }
        }
        return null;
    }

    public static void deleteUserCookie(HttpServletResponse response) {
        Cookie cookieUserName = new Cookie(ATT_NAME_USER_NAME, null);
        cookieUserName.setMaxAge(0); 
        response.addCookie(cookieUserName);
    }
}
