	package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Room;
import model.User;

import java.io.IOException;
import java.util.List;

import dao.RoomDAO;

/**
 * Servlet implementation class Category
 */
@WebServlet("/Category")
public class CategoryServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public CategoryServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	HttpSession session = request.getSession();

		User user = (User) session.getAttribute("User");

		if (user == null) {
			request.setAttribute("errorMessage", "Đăng nhập để xem phòng");
            request.getRequestDispatcher("login.jsp").forward(request, response);
		    return;
		}
        String location = request.getParameter("location");
        RoomDAO rDAO = new RoomDAO();
        List<Room> rooms = rDAO.getRoomsByLocation(location);
        request.setAttribute("rooms", rooms);
        request.setAttribute("location", location);
        request.setAttribute("userId", user.getId());
        request.getRequestDispatcher("category.jsp").forward(request, response);
    }
	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
