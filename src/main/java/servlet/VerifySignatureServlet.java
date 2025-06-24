package servlet;

import controller.SendEmailOrder;
import dao.BookingDAO;
import dao.OrderDAO;
import dao.RoomDAO;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.*;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.util.ArrayList;

import java.util.List;

@WebServlet("/verifySignature")
public class VerifySignatureServlet extends HttpServlet {
    // Thời gian hiệu lực của hóa đơn (ms) – 5 phút
    private static final long EXPIRATION_TIME_MS = 5 * 60 * 1000;
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("User");

        // Kiểm tra đăng nhập
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Nhận hash ban đầu và chữ ký từ form
        String rawData = (String) session.getAttribute("rawDataForSign");
        Long timestamp = (Long) session.getAttribute("invoiceTimestamp");
        String signatureBase64 = request.getParameter("signature");

        if (rawData == null || signatureBase64 == null || signatureBase64.trim().isEmpty()) {
            session.setAttribute("message", "Thiếu dữ liệu cần thiết để xác thực."
             + "Signature" + signatureBase64);
            response.sendRedirect("verify-orders");
            return;
        }
        // Kiểm tra thời gian hết hạn
        long now = System.currentTimeMillis();
        if (timestamp == null || now - timestamp > EXPIRATION_TIME_MS) {
            // Xóa dữ liệu hết hạn khỏi session
            session.removeAttribute("rawDataForSign");
            session.removeAttribute("invoiceTimestamp");

            session.setAttribute("message", "Phiên xác thực đã hết hạn. Vui lòng thực hiện lại trong vòng 5 phút.");
            response.sendRedirect("verify-orders");
            return;
        }

        // Xóa khoảng trắng và xuống dòng (nếu người dùng paste chữ ký dài)
        signatureBase64 = signatureBase64.replaceAll("\\s+", "");

        try {
            // Lấy public key của người dùng từ DB
            UserDAO userDAO = new UserDAO();
            String publicKeyString = userDAO.getPublicKey(user.getId());

            if (publicKeyString == null || publicKeyString.trim().isEmpty()) {
                session.setAttribute("message", "Bạn chưa tải lên khóa công khai.");
                response.sendRedirect("verify-orders");
                return;
            }
            RSAModel rsa = new RSAModel();
            rsa.loadPublicKeyFromBase64(publicKeyString); // Load public key
            boolean isValid = rsa.verifyText(rawData, signatureBase64);

            if (isValid) {
                BookingDAO bookingDAO = new BookingDAO();
                RoomDAO roomDAO = new RoomDAO();
                double totalPrice = 0;
                List<Integer> bookingIds = new ArrayList<>();

                Cart cart = (Cart) session.getAttribute("cart");
                List<CartItem> cartItems = cart != null ? cart.getItems() : new ArrayList<>();
                if (cartItems != null && !cartItems.isEmpty()) {
                    for (CartItem item : cartItems) {
                        Booking booking = new Booking();
                        booking.setUserId(user.getId());
                        booking.setRoomId(item.getRoom().getId());
                        booking.setCheckIn(item.getCheckIn());
                        booking.setCheckOut(item.getCheckOut());
                        booking.setQuantity(item.getQuantity());
                        int bookingId = bookingDAO.insertAndReturnId(booking);
                        if (bookingId > 0) {
                            bookingIds.add(bookingId);
                        }
                    }
                }

                totalPrice = cart.getTotal();

                String name = request.getParameter("name");
                String email = request.getParameter("email");
                String phone = request.getParameter("phone");

                // Lưu đơn hàng
                Order order = new Order();
                order.setUserId(user.getId());
                order.setCustomerName(name);
                order.setCustomerEmail(email);
                order.setCustomerPhone(phone);
                order.setPublicKeyString(publicKeyString);
                order.setSignature(signatureBase64);
                order.setTotalPrice(totalPrice);
                order.setTimeStamp(timestamp);

                OrderDAO orderDAO = new OrderDAO();
                int orderId = orderDAO.insert(order);

                if (orderId > 0) {
                    order.setOrderId(orderId);
                    for (int bookingId : bookingIds) {
                        bookingDAO.updateOrderId(bookingId, orderId);
                    }
                    try {
                        SendEmailOrder.sendOrderInfo(order, bookingDAO, roomDAO);
                        session.setAttribute("message", "Chữ ký số hợp lệ. Đặt phòng thành công! Email xác nhận đã được gửi.");
                    } catch (Exception e) {
                        session.setAttribute("message", "Chữ ký số hợp lệ. Đặt phòng thành công! Lỗi gửi email: " + e.getMessage());
                        e.printStackTrace();
                    }
                } else {
                    session.setAttribute("message", "Lỗi khi lưu đơn hàng!");
                }
            }
            else {
                session.setAttribute("message", "Chữ ký số không hợp lệ!<br>");

            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("message", "Lỗi xác thực chữ ký số: " + e.getMessage());
        }
        session.removeAttribute("rawDataForSign");
        session.removeAttribute("invoiceTimestamp");
        session.removeAttribute("cart");
        response.sendRedirect("verify-orders");
    }

}