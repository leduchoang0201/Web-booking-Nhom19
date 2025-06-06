package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

import model.Cart;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Cart cart = (Cart) session.getAttribute("cart");

        if (cart != null) {
            request.setAttribute("cartItems", cart.getItems());
            request.setAttribute("total", cart.getTotal());
        } else {
            request.setAttribute("cartItems", null);
            request.setAttribute("total", 0);
        }

        request.getRequestDispatcher("cart.jsp").forward(request, response);
    }
}
