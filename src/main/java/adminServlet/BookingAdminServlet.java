package adminServlet;

import dao.OrderDAO;
import dao.RoomDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Booking;

import java.io.IOException;
import java.sql.Date;

import dao.BookingDAO;
import model.Order;
import model.Room;

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
                Date newCheckOut = Date.valueOf(request.getParameter("checkoutDate"));
                String status = request.getParameter("status");

                BookingDAO bookingDAO = new BookingDAO();
                RoomDAO roomDAO = new RoomDAO();
                OrderDAO orderDAO = new OrderDAO();

                Booking booking = bookingDAO.getBookingById(bookingId);
                Date oldCheckOut = (Date) booking.getCheckOut();

                boolean giaHan = false;

                // Nếu ngày mới > ngày cũ thì tính tiền thêm
                if (newCheckOut.after(oldCheckOut)) {
                    long millisPerDay = 1000 * 60 * 60 * 24;
                    long extraDays = (newCheckOut.getTime() - oldCheckOut.getTime()) / millisPerDay;

                    if (extraDays > 0) {
                        Room room = roomDAO.getRoomById(booking.getRoomId());
                        Order order = orderDAO.getOrderById(booking.getOrderId());

                        double extraCost = room.getPrice() * extraDays * booking.getQuantity();
                        double updatedTotal = order.getTotalPrice() + extraCost;

                        order.setTotalPrice(updatedTotal);
                        orderDAO.update(order);

                        giaHan = true;
                    }
                }

                booking.setCheckOut(newCheckOut);
                booking.setStatus(status);
                bookingDAO.update(booking);

                // Thiết lập thông báo phù hợp
                if (giaHan) {
                    request.getSession().setAttribute("message", "Gia hạn phòng và cập nhật trạng thái thành công!");
                } else {
                    request.getSession().setAttribute("message", "Cập nhật trạng thái lịch đặt thành công!");
                }

                response.sendRedirect("admin");
            }
            else if ("delete".equals(action)) {
                int bookingId = Integer.parseInt(request.getParameter("bookingId"));
                bookingDAO.delete(bookingId);
                request.getSession().setAttribute("message", "Xóa lịch đặt thành công!");
                response.sendRedirect("admin");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi thêm/cập nhật/xóa lịch đặt");
            request.getRequestDispatcher("admin").forward(request, response);
        }
    }
}
