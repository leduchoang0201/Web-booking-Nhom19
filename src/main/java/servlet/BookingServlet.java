package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Booking;
import model.Room;
import model.User;

import java.io.IOException;
import java.sql.Date;

import controller.SendEmailBooking;
import dao.BookingDAO;
import dao.RoomDAO;

/**
 * Servlet implementation class BookingServlet
 */
@WebServlet("/BookingServlet")
public class BookingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        // Lấy dữ liệu từ từ payment
        int userId = Integer.parseInt((String) session.getAttribute("userId"));
        int roomId = Integer.parseInt((String) session.getAttribute("roomId"));
        String customerName = (String) session.getAttribute("customerName");
        String roomName = (String) session.getAttribute("roomName");
        String roomPrice = (String) session.getAttribute("roomPrice");
        Date checkInDate = Date.valueOf((String) session.getAttribute("checkinDate"));
        Date checkOutDate = Date.valueOf((String) session.getAttribute("checkoutDate"));

        User user = (User) session.getAttribute("User");
        String name = user.getName();
        String email = user.getEmail();

        RoomDAO roomDAO = new RoomDAO();
        Room room = roomDAO.getRoomById(roomId);

        Booking booking = new Booking(userId, roomId, checkInDate, checkOutDate);
        booking.setStatus("confirmed");
        BookingDAO bookingDAO = new BookingDAO();
        
        int result = bookingDAO.insert(booking); // Tạo lịch đặt (booking)

        if (result > 0) {
            roomDAO.updateRoomAvailability(roomId, 0);
            //Send mail nếu tạo lịch đặt thành công
            SendEmailBooking.sendBookingInfo(email, name, roomName, checkInDate, checkOutDate, roomPrice); 

            request.setAttribute("booking", booking);
            request.setAttribute("roomId", roomId);
            //Truyền đến trang info để hiển thị thông tin lịch đặt
            request.getRequestDispatcher("/info.jsp").forward(request, response);
            
        } else {
            request.setAttribute("message", "Đặt phòng thất bại!");
            request.getRequestDispatcher("rooms").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
