<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.CartItem" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems");
    double total = (double) request.getAttribute("total");
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Giỏ hàng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="static/css/index.css">
</head>
<body>
<jsp:include page="Header.jsp" />
<div class="container mt-5">
    <h2 class="mb-4">Giỏ hàng của bạn</h2>

    <%
        if (cartItems == null || cartItems.isEmpty()) {
    %>
    <div class="alert alert-info">Chưa có phòng nào trong giỏ hàng.</div>
    <%
    } else {
    %>
    <table class="table table-bordered">
        <thead>
        <tr>
            <th>Tên phòng</th>
            <th>Giá</th>
            <th>Check-in</th>
            <th>Check-out</th>
            <th>Số lượng</th>
            <th>Thành tiền</th>
            <th>Xoá</th>
        </tr>
        </thead>
        <tbody>
        <% for (int i = 0; i < cartItems.size(); i++) {
            CartItem item = cartItems.get(i);
        %>
        <tr>
            <td><%= item.getRoom().getName() %></td>
            <td><%= item.getRoom().getPrice() %></td>
            <td><%= sdf.format(item.getCheckIn()) %></td>
            <td><%= sdf.format(item.getCheckOut()) %></td>
            <td><%= item.getQuantity() %></td>
            <td><%= item.getSubtotal() %></td>
            <td>
                <a href="removeFromCart?index=<%= i %>" class="btn btn-danger btn-sm">Xoá</a>
            </td>
        </tr>
        <% } %>
        </tbody>
    </table>

    <h4 class="text-end">Tổng cộng: <%= total %> VND</h4>
    <div class="text-end">
        <a href="checkout.jsp" class="btn btn-success">Thanh toán</a>
    </div>
    <%
        }
    %>
</div>
<jsp:include page="Footer.jsp" />
</body>
</html>
