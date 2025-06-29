package adminServlet;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.*;
import dao.*;

import java.io.IOException;
import java.util.List;

/**
 * Servlet implementation class AdminServelet
 */
@WebServlet("/admin")
public class AdminServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AdminServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User adminUser = (User) session.getAttribute("User");

        if (adminUser == null) {
            request.setAttribute("errorMessage", "Vui lòng đăng nhập để truy cập trang quản lý.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }
        if (adminUser.getRole() != 1) {
        	request.setAttribute("errorMessage", "Vui lòng đăng nhập tài khoản admin.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }
        RoomDAO roomDAO = new RoomDAO();
        List<Room> rooms = roomDAO.getAll();

        BookingDAO bookingDAO = new BookingDAO();
        List<Booking> bookings = bookingDAO.getAll();

        UserDAO userDAO = new UserDAO();
        List<User> users = userDAO.getAll();

        OrderDAO orderDAO = new OrderDAO();
        List<Order> orders = orderDAO.getAll();

        request.setAttribute("rooms", rooms);
        request.setAttribute("bookings", bookings);
        request.setAttribute("users", users);
        request.setAttribute("orders", orders);

        request.setAttribute("adminName", adminUser.getName());

        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin.jsp");
        dispatcher.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }

}
