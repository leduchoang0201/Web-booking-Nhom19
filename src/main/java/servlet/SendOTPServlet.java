package servlet;


import controller.SendOTP;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import model.User;

import java.io.IOException;

@WebServlet("/SendOTPServlet")
public class SendOTPServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("User");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String email = user.getEmail();
        String otp = String.valueOf((int)(Math.random() * 900000) + 100000);

        session.setAttribute("otp", otp);
        session.setAttribute("otpEmail", email);
        session.setAttribute("showOtpModal", true);

        // Gửi email OTP (giả sử bạn có hàm này)
        SendOTP.sendOtpToEmail(email, otp);

        session.setAttribute("message", "Mã OTP đã được gửi tới email của bạn.");
        response.sendRedirect("user_info.jsp");
    }
}

