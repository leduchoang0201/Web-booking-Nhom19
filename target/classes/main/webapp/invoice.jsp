<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, java.text.SimpleDateFormat, java.security.MessageDigest" %>
<%@ page import="model.CartItem" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");

    String name = (String) request.getAttribute("name");
    String email = (String) request.getAttribute("email");
    String phone = (String) request.getAttribute("phone");
    double total = (double) request.getAttribute("total");
    double deposit = (double) request.getAttribute("deposit");
    String rawData = (String) request.getAttribute("rawData");
    List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems");
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");


    // Create SHA-256 hash for invoice ID
    MessageDigest digest = MessageDigest.getInstance("SHA-256");
    byte[] hashBytes = digest.digest(rawData.toString().getBytes("UTF-8"));
    StringBuilder hashString = new StringBuilder();
    for (byte b : hashBytes) {
        hashString.append(String.format("%02x", b));
    }
    String invoiceId = hashString.toString();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Hóa đơn</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<jsp:include page="Header.jsp" />
<body>
<div class="container mt-5">
    <h2 class="mb-4">Hóa đơn thanh toán</h2>

    <p><strong>Mã hóa đơn:</strong> <%= invoiceId %></p>
    <p><strong>Họ tên:</strong> <%= name %></p>
    <p><strong>Email:</strong> <%= email %></p>
    <p><strong>Số điện thoại:</strong> <%= phone %></p>

    <table class="table table-bordered mt-4">
        <thead>
        <tr>
            <th>Tên phòng</th>
            <th>Giá</th>
            <th>Check-in</th>
            <th>Check-out</th>
            <th>Số lượng</th>
            <th>Thành tiền</th>
        </tr>
        </thead>
        <tbody>
        <% for (CartItem item : cartItems) { %>
        <tr>
            <td><%= item.getRoom().getName() %></td>
            <td><%= item.getRoom().getPrice() %> VNĐ</td>
            <td><%= sdf.format(item.getCheckIn()) %></td>
            <td><%= sdf.format(item.getCheckOut()) %></td>
            <td><%= item.getQuantity() %></td>
            <td><%= item.getSubtotal() %> VNĐ</td>
        </tr>
        <% } %>
        </tbody>
    </table>

    <h4 class="text-end mt-4">Tổng tiền: <%= String.format("%,.0f", total) %> VNĐ</h4>
    <h5 class="text-end">Số tiền đặt cọc (10%): <%= String.format("%,.0f", total * 0.10) %> VNĐ</h5>

    <div class="text-center mt-4">
        <a href="rooms" class="btn btn-primary">Tiếp tục đặt phòng</a>
    </div>
</div>
<jsp:include page="Footer.jsp" />
</body>
</html>
