package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;
import jakarta.mail.*;
import jakarta.mail.internet.*;

import java.io.IOException;

import controller.SendEmailRegister;
import dao.UserDAO;

/**
 * Servlet implementation class register
 */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
      UserDAO uDAO = new UserDAO();
    /**
     * @see HttpServlet#HttpServlet()
     */
    public RegisterServlet() {
        super();
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }


	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("fullname");
        String email = request.getParameter("email");
        String pass = request.getParameter("password");
        String repass = request.getParameter("confirmPassword");
        
        if (name == null || name.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Họ và tên không được để trống.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Email/Số điện thoại không được để trống.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        if (!isValidEmail(email)) {
            request.setAttribute("errorMessage", "Email không hợp lệ.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        if (pass == null || pass.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Mật khẩu không được để trống.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        if (!pass.equals(repass)) {
            request.setAttribute("errorMessage", "Mật khẩu và nhập lại mật khẩu không khớp.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        if (uDAO.checkMail(email)) {
            request.setAttribute("errorMessage", "Email đã được đăng ký.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        uDAO.insert(new User(name, email, pass)); // Thêm người dùng
        SendEmailRegister.sendRegistrationConfirmation(email); // Gửi mail thông báo

        response.sendRedirect("login.jsp");
    }

    private boolean isValidEmail(String email) {
        String emailPattern = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$";
        return email.matches(emailPattern);
    }
   
}
