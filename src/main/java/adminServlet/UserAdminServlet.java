package adminServlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;

import java.io.IOException;

import dao.UserDAO;

/**
 * Servlet implementation class UserAdminServlet
 */
@WebServlet("/userAdmin")
public class UserAdminServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
    UserDAO userDAO = new UserDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html; charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        try {
            if ("insert".equals(action)) {
                String name = request.getParameter("name");
                String email = request.getParameter("email");
                String password = request.getParameter("password");

                User newUser = new User(name, email, password);
                userDAO.insert(newUser);

                response.sendRedirect("admin");
            } else if ("update".equals(action)) {
                int userId = Integer.parseInt(request.getParameter("userId"));
                String name = request.getParameter("name");
                String email = request.getParameter("email");
                String password = request.getParameter("password");

                User updatedUser = new User();
                updatedUser.setId(userId);
                updatedUser.setName(name);
                updatedUser.setEmail(email);
                updatedUser.setPassword(password);
                userDAO.update(updatedUser);

                response.sendRedirect("admin");
            } else if ("delete".equals(action)) {
                int userId = Integer.parseInt(request.getParameter("userId"));
                userDAO.delete(userId);

                response.sendRedirect("admin");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi thêm/cập nhật/xóa người dùng");
            request.getRequestDispatcher("admin").forward(request, response);
        }
    }

}
