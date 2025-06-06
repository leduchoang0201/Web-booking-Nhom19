package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


import java.io.IOException;
import java.util.List;

import model.CartItem;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        double total = 0;
        if (cart != null) {
            for (CartItem item : cart) {
                total += item.getSubtotal();
            }
        }

        request.setAttribute("cartItems", cart);
        request.setAttribute("total", total);
        request.getRequestDispatcher("cart.jsp").forward(request, response);
    }
}
