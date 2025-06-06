<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page import="model.User" %>


<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Insert title here</title>
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
            rel="stylesheet">
    <script
            src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" type="text/css"
          href="static/css/index.css">
    <link rel="stylesheet" type="text/css" href="static/css/room.css">
</head>
<link rel="stylesheet"
      href="lib/bootstrap-5.0.2-dist/css/bootstrap.min.css">
<link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css"
        rel="stylesheet">
</head>
<body>
<header class="header">
    <a href="home.jsp" class="logo">HotelBooking</a>
    <label for="" class="icons">
        <i class="fa-solid fa-bars"></i>
    </label>
    <nav class="navbars">
        <a style="color: #c0a600" href="home.jsp">TRANG CHỦ</a>
        <a href="rooms">PHÒNG</a>
        <a href="about.jsp">GIỚI THIỆU & LIÊN HỆ</a>

        <a href="cart"><i class="fa-solid fa-cart-shopping"></i>Giỏ Hàng</a>
        <% if (request.getSession().getAttribute("User") != null) {
            User user = (User) request.getSession().getAttribute("User");
        %>
        <a href="info.jsp" class="d-block"><i class="fa-solid fa-user"></i> <%= user.getName() %></a>
        <a href="logout" class="nav-link">
            <p><i class="fa-solid fa-arrow-right-from-bracket"></i> Đăng xuất</p>
        </a>
        <% } else { %>
        <a href="login.jsp"><i class="fa-solid fa-magnifying-glass"></i> Đăng Nhập/Đăng Kí</a>
        <% } %>
    </nav>
</header>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        document.querySelectorAll('.money').forEach(el => {
            const num = parseFloat(el.textContent.replace(/[^\d.-]/g, ''));
            if (!isNaN(num)) {
                el.textContent = num.toLocaleString('vi-VN') + ' VNĐ';
            }
        });
    });
</script>

</body>
</html>