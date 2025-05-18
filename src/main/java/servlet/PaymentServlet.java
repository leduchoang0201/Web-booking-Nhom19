package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import com.vnpay.common.Config;

/**
 * Servlet implementation class PaymentServlet
 */
@WebServlet("/PaymentServlet")
public class PaymentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public PaymentServlet() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	// Lấy dữ liệu từ form đặt phòng
        String roomId = request.getParameter("roomId");
        String roomName = request.getParameter("roomName");
        String roomPrice = request.getParameter("roomPrice");
        String userId = request.getParameter("userId");
        String customerName = request.getParameter("customerName");
        String checkinDate = request.getParameter("checkinDate");
        String checkoutDate = request.getParameter("checkoutDate");
        String totalPrice = request.getParameter("totalPrice");

        int amount = Integer.parseInt(totalPrice);
        HttpSession session = request.getSession();
        session.setAttribute("roomId", roomId);
        session.setAttribute("roomName", roomName);
        session.setAttribute("roomPrice", roomPrice);
        session.setAttribute("userId", userId);
        session.setAttribute("customerName", customerName);
        session.setAttribute("checkinDate", checkinDate);
        session.setAttribute("checkoutDate", checkoutDate);
        session.setAttribute("totalPrice", totalPrice);

        // Truyền dữ liệu đến trang thanh toán
        request.setAttribute("amount", amount);
        request.getRequestDispatcher("vnpay_pay.jsp").forward(request, response);
    }
}
