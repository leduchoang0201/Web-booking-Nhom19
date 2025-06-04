package servlet;

import dao.RoomDAO;
import model.CartItem;
import model.Room;
import model.Cart;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.*;

@WebServlet("/addToCart")
public class AddToCartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int roomId = Integer.parseInt(request.getParameter("roomId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            String checkinStr = request.getParameter("checkinDate");
            String checkoutStr = request.getParameter("checkoutDate");

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date checkinDate = sdf.parse(checkinStr);
            Date checkoutDate = sdf.parse(checkoutStr);

            // Lấy thông tin phòng từ DAO
            RoomDAO dao = new RoomDAO();
            Room room = dao.getRoomById(roomId);

            if (room == null) {
                response.sendRedirect("rooms?error=room_not_found");
                return;
            }

            // Tạo CartItem mới
            CartItem item = new CartItem(room, checkinDate, checkoutDate, quantity);

            // Lấy giỏ hàng từ session hoặc tạo mới
            HttpSession session = request.getSession();
            Cart cart = (Cart) session.getAttribute("cart");

            if (cart == null) {
                cart = new Cart(new ArrayList<>()); // Khởi tạo với danh sách rỗng
            }

            cart.add(room, checkinDate, checkoutDate, quantity);
            session.setAttribute("cart", cart);

            response.sendRedirect("rooms?success=added");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("rooms?error=exception");
        }
    }
}
