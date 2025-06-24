package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Cart;
import model.CartItem;

import java.io.IOException;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Base64;
import java.util.List;

@WebServlet("/InvoiceServlet")
public class InvoiceServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy thông tin từ form modal
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String depositStr = request.getParameter("depositAmount");

        double deposit = depositStr != null && !depositStr.isEmpty() ? Double.parseDouble(depositStr) : 0.0;

        DecimalFormat df = new DecimalFormat("#,###.##");

        // Lấy cart từ session
        HttpSession session = request.getSession();
        Cart cart = (Cart) session.getAttribute("cart");

        if (cart == null || cart.getItems() == null || cart.getItems().isEmpty()) {
            // Nếu giỏ hàng trống, chuyển hướng về trang giỏ hàng
            response.sendRedirect("cart");
            return;
        }

        List<CartItem> cartItems = cart.getItems();
        double total = cart.getTotal();

        // Tạo rawData để mã hóa/hàm băm
        StringBuilder rawData = new StringBuilder();
        rawData.append("Tên: ").append(name).append("\n");
        rawData.append("Email: ").append(email).append("\n");
        rawData.append("SĐT: ").append(phone).append("\n");
        rawData.append("Tổng tiền: ").append(df.format(total)).append("\n\n");

        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        int index = 1;
        for (CartItem item : cartItems) {
            rawData.append("Phòng ").append(index++).append(":\n");
            rawData.append("- Tên phòng: ").append(item.getRoom().getName()).append("\n");
            rawData.append("- Giá: ").append(df.format(item.getRoom().getPrice())).append("\n");
            rawData.append("- Check-in: ").append(sdf.format(item.getCheckIn())).append("\n");
            rawData.append("- Check-out: ").append(sdf.format(item.getCheckOut())).append("\n");
            rawData.append("- Số lượng: ").append(item.getQuantity()).append("\n");
            rawData.append("- Thành tiền: ").append(df.format(item.getSubtotal())).append("\n\n");
        }
        long timestamp = System.currentTimeMillis();
        rawData.append("Timestamp: ").append(timestamp);

        // --- Lưu vào session để xác thực chữ ký sau này ---
        session.setAttribute("rawDataForSign", rawData.toString());
        session.setAttribute("invoiceTimestamp", timestamp);

        // Gửi dữ liệu sang invoice.jsp
        request.setAttribute("name", name);
        request.setAttribute("email", email);
        request.setAttribute("phone", phone);
        request.setAttribute("deposit", deposit);
        request.setAttribute("total", total);
        request.setAttribute("cartItems", cartItems);
        request.setAttribute("rawData", rawData.toString());

        request.getRequestDispatcher("invoice.jsp").forward(request, response);
    }
}
