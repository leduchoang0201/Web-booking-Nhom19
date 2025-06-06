package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Cart;
import model.CartItem;

import java.io.IOException;
import java.text.SimpleDateFormat;
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
        rawData.append(name).append(email).append(phone).append(total);

        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");

        for (CartItem item : cartItems) {
            rawData.append(item.getRoom().getName())
                    .append(item.getRoom().getPrice())
                    .append(sdf.format(item.getCheckIn()))
                    .append(sdf.format(item.getCheckOut()))
                    .append(item.getQuantity())
                    .append(item.getSubtotal());
        }

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
