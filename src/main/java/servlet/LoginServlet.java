package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.*;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.*;

import controller.GetCookie;
import dao.*;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    UserDAO uDAO = new UserDAO();

    public LoginServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String re = request.getParameter("rememberMe");
        boolean remember = "Y".equalsIgnoreCase(re);

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

        if (!uDAO.checkMail(email)) {
            request.setAttribute("errorMessage", "Email không tồn tại");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        User user = uDAO.login(email, password);
        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("User", user);
            if (remember) {
                GetCookie.storeUserCookie(response, user);
            } else {
                GetCookie.deleteUserCookie(response);
            }

            // Tính đơn hàng không hợp lệ
            try {
                int invalidCount = 0;
                OrderDAO orderDAO = new OrderDAO();
                BookingDAO bookingDAO = new BookingDAO();
                RoomDAO roomDAO = new RoomDAO();
                SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
                DecimalFormat df = new DecimalFormat("#,###");

                List<Order> orders = orderDAO.getAllByUser(user);
                for (Order order : orders) {
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
                        rawData.append("Phòng ").append(index++).append(":\n")
                                .append("- Tên phòng: ").append(r.getName()).append("\n")
                                .append("- Giá: ").append(df.format(r.getPrice())).append("\n")
                                .append("- Check-in: ").append(sdf.format(b.getCheckIn())).append("\n")
                                .append("- Check-out: ").append(sdf.format(b.getCheckOut())).append("\n")
                                .append("- Số lượng: ").append(b.getQuantity()).append("\n")
                                .append("- Thành tiền: ").append(df.format(b.getQuantity() * r.getPrice())).append("\n\n");
                    }

                    rawData.append("Timestamp: ").append(order.getTimeStamp());

                    // Xác minh chữ ký
                    RSAModel rsa = new RSAModel();
                    rsa.loadPublicKeyFromBase64(order.getPublicKeyString());
                    boolean isSignatureValid = rsa.verifyText(rawData.toString(), order.getSignature());

                    // Xác minh hash
                    String expectedHash = "";
                    try {
                        MessageDigest md = MessageDigest.getInstance("SHA-256");
                        byte[] digest = md.digest((rawData + "HNH").getBytes(StandardCharsets.UTF_8));
                        StringBuilder sb = new StringBuilder();
                        for (byte b : digest) {
                            sb.append(String.format("%02x", b));
                        }
                        expectedHash = sb.toString();
                    } catch (Exception ignored) {}

                    boolean isHashValid = expectedHash.equalsIgnoreCase(order.getHashData());
                    if (!isSignatureValid || !isHashValid) {
                        invalidCount++;
                    }
                }

                // Lưu vào session
                session.setAttribute("invalidOrderCount", invalidCount);
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("invalidOrderCount", 0);
            }

            // Chuyển hướng
            if (user.getRole() == 1) {
                response.sendRedirect("admin");
            } else {
                response.sendRedirect("home.jsp");
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
