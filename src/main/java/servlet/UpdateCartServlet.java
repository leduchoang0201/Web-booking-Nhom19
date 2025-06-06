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
import java.time.LocalDate;
import java.util.*;

@WebServlet("/updateCartServlet")
public class UpdateCartServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int index = Integer.parseInt(request.getParameter("index"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        LocalDate checkIn = LocalDate.parse(request.getParameter("checkIn"));
        LocalDate checkOut = LocalDate.parse(request.getParameter("checkOut"));

        HttpSession session = request.getSession();
        Cart cart = (Cart) session.getAttribute("cart");

        if (cart != null) {
            List<CartItem> cartItems = cart.getItems();

            if (index >= 0 && index < cartItems.size()) {
                CartItem item = cartItems.get(index);
                item.setQuantity(quantity);
                item.setCheckIn(java.sql.Date.valueOf(checkIn));
                item.setCheckOut(java.sql.Date.valueOf(checkOut));
                item.getSubtotal();
            }
        }
            response.sendRedirect(request.getContextPath() + "/cart");
        }

    }
