package adminServlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Booking;

import java.io.IOException;
import java.sql.Date;

import dao.BookingDAO;
@WebServlet("/bookingAdmin")
public class BookingAdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    BookingDAO bookingDAO = new BookingDAO();
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	response.setContentType("text/html; charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        try {
            if ("insert".equals(action)) {
                int bookingId = Integer.parseInt(request.getParameter("bookingId"));
                int userId = Integer.parseInt(request.getParameter("userId"));
                int roomId = Integer.parseInt(request.getParameter("roomId"));
                Date checkInDate = 	Date.valueOf(request.getParameter("checkinDate"));
        		Date checkOutDate = Date.valueOf(request.getParameter("checkoutDate"));
                String status = request.getParameter("status"); 
                
                Booking newBooking = new Booking(bookingId, userId, roomId, checkInDate, checkOutDate, status);
                System.out.println(newBooking);
                bookingDAO.insert(newBooking);
                
                response.sendRedirect("admin");

            } else if ("update".equals(action)) {
            	System.out.println("Update");
                int bookingId = Integer.parseInt(request.getParameter("bookingId"));
                int userId = Integer.parseInt(request.getParameter("userId"));
                int roomId = Integer.parseInt(request.getParameter("roomId"));
                System.out.println("Check-in Date: " + request.getParameter("checkinDate"));
                System.out.println("Check-out Date: " + request.getParameter("checkoutDate"));
                Date checkInDate = 	Date.valueOf(request.getParameter("checkinDate"));
        		Date checkOutDate = Date.valueOf(request.getParameter("checkoutDate"));
                String status = request.getParameter("status");
                
                Booking updatedBooking = new Booking(bookingId, userId, roomId, checkInDate, checkOutDate, status);
                System.out.println(updatedBooking);
                bookingDAO.update(updatedBooking);
                response.sendRedirect("admin");

            } else if ("delete".equals(action)) {
                int bookingId = Integer.parseInt(request.getParameter("bookingId"));
                bookingDAO.delete(bookingId);
                response.sendRedirect("admin");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi thêm/cập nhật/xóa lịch đặt");
            request.getRequestDispatcher("admin").forward(request, response);
        }
    }
}
