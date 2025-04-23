package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

import java.io.IOException;

import controller.GetCookie;
import controller.SendEmailRegister;
import dao.UserDAO;

/**
 * Servlet implementation class LoginServlet
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	UserDAO uDAO = new UserDAO();

	public LoginServlet() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
		// Lấy dữ liệu từ form đăng nhập
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String re = request.getParameter("rememberMe"); // Nút "ghi nhớ tôi"
        boolean remember ="Y".equalsIgnoreCase(re); 
        
        // Xử lý validation input người dùng
        if (email == null || email.isEmpty()) {
            request.setAttribute("errorMessage", "Email không được để trống");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        if (password == null || password.isEmpty()) {
            request.setAttribute("errorMessage", "Mật khẩu không được để trống");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }
        // Kiểm tra mail
        if (!uDAO.checkMail(email)) { 
            request.setAttribute("errorMessage", "Email không tồn tại");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }
        User user = uDAO.login(email, password); // Kiểm tra mail và mật khẩu
        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("User", user);
            if(remember) {
            	GetCookie.storeUserCookie(response, user); // Lưu cookie người dùng
            }else {
            	GetCookie.deleteUserCookie(response); // Hủy cookie
            }
            if (user.getRole() == 1) {
                response.sendRedirect("admin"); // Đăng nhập tài khoản admin thì chuyển trang admin.
            } else {
                response.sendRedirect("home.jsp"); // Đăng nhập tài khoản thường thì chuyển về trang chủ.
            }
        } else {
            request.setAttribute("errorMessage", "Mật khẩu sai");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
        
	}
    
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}
}
