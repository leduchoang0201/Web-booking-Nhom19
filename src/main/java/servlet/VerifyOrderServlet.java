package servlet;
import dao.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.*;
import java.io.IOException;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.*;

@WebServlet("/verify-orders")
public class VerifyOrderServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("User");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        OrderDAO orderDAO = new OrderDAO();
        BookingDAO bookingDAO = new BookingDAO();
        RoomDAO roomDAO = new RoomDAO();

        List<Order> orders = orderDAO.getAllByUser(user);
        Collections.reverse(orders);
        Map<Integer, Boolean> verificationMap = new HashMap<>();

        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        DecimalFormat df = new DecimalFormat("#,###");

        for (Order order : orders) {
            try {
                List<Booking> bookings = bookingDAO.getByOrderId(order.getOrderId());
                List<Room> rooms = new ArrayList<>();

                for (Booking b : bookings) {
                    rooms.add(roomDAO.getRoomById(b.getRoomId()));
                }

                StringBuilder rawData = new StringBuilder();
                rawData.append("Tên: ").append(order.getCustomerName()).append("\n");
                rawData.append("Email: ").append(order.getCustomerEmail()).append("\n");
                rawData.append("SĐT: ").append(order.getCustomerPhone()).append("\n");
                rawData.append("Tổng tiền: ").append(df.format(order.getTotalPrice())).append("\n\n");

                int index = 1;
                for (int i = 0; i < bookings.size(); i++) {
                    Booking b = bookings.get(i);
                    Room r = rooms.get(i);
                    rawData.append("Phòng ").append(index++).append(":\n");
                    rawData.append("- Tên phòng: ").append(r.getName()).append("\n");
                    rawData.append("- Giá: ").append(df.format(r.getPrice())).append("\n");
                    rawData.append("- Check-in: ").append(sdf.format(b.getCheckIn())).append("\n");
                    rawData.append("- Check-out: ").append(sdf.format(b.getCheckOut())).append("\n");
                    rawData.append("- Số lượng: ").append(b.getQuantity()).append("\n");
                    rawData.append("- Thành tiền: ").append(df.format(b.getQuantity() * r.getPrice())).append("\n\n");
                }

                rawData.append("Timestamp: ").append(order.getTimeStamp());

                RSAModel rsa = new RSAModel();
                rsa.loadPublicKeyFromBase64(order.getPublicKeyString());
                boolean isValid = rsa.verifyText(rawData.toString(), order.getSignature());
                verificationMap.put(order.getOrderId(), isValid);
            } catch (Exception e) {
                e.printStackTrace();
                verificationMap.put(order.getOrderId(), false);
            }
        }

        request.setAttribute("orders", orders);
        request.setAttribute("verificationMap", verificationMap);

        request.getRequestDispatcher("order.jsp").forward(request, response);
    }
}