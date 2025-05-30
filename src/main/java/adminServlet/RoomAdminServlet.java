package adminServlet;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import dao.*;
import model.*;
import java.util.*;

/**
 * Servlet implementation class AdminServlet
 */
@WebServlet("/roomAdmin")
public class RoomAdminServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	RoomDAO roomDAO = new RoomDAO();

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
	        throws ServletException, IOException {
	    response.setContentType("text/html; charset=UTF-8");
	    request.setCharacterEncoding("UTF-8");

	    String action = request.getParameter("action");
	    try {
	        if ("insert".equals(action)) {
	            int roomId = Integer.parseInt(request.getParameter("roomId"));
	            String roomName = request.getParameter("roomName");
	            String roomType = request.getParameter("roomType");
	            double roomPrice = Double.parseDouble(request.getParameter("roomPrice"));
	            int roomCapacity = Integer.parseInt(request.getParameter("roomCapacity"));
	            String roomImage = request.getParameter("roomImage");
	            String roomLocation = request.getParameter("roomLocation");

	            Room newRoom = new Room(roomId, roomName, roomType, roomPrice, roomCapacity, roomImage, roomLocation);
	            roomDAO.insert(newRoom);

	            response.sendRedirect("admin");
	        } else if ("update".equals(action)) {
	            String roomIdStr = request.getParameter("roomId");
	            int roomId = Integer.parseInt(roomIdStr.trim());

	            String roomName = request.getParameter("roomName");
	            String roomType = request.getParameter("roomType");
	            double roomPrice = Double.parseDouble(request.getParameter("roomPrice"));
	            int roomCapacity = Integer.parseInt(request.getParameter("roomCapacity"));
	            String roomImage = request.getParameter("roomImage");
	            String roomLocation = request.getParameter("roomLocation");

	            Room updatedRoom = new Room(roomId, roomName, roomType, roomPrice, roomCapacity, roomImage, roomLocation);
	            roomDAO.update(updatedRoom);
	            response.sendRedirect("admin");
	        } else if ("delete".equals(action)) {
	            int roomId = Integer.parseInt(request.getParameter("roomId"));
	            roomDAO.delete(roomId);
	            response.sendRedirect("admin");
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	        request.setAttribute("error", "Lỗi khi thêm/cập nhật phòng");
	        request.getRequestDispatcher("admin").forward(request, response);
	    }
	}

}
