<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ page import="model.Order" %>
<%@ page import="model.Booking" %>
<%@ page import="model.Room" %>
<%@ page import="model.RSAModel" %>
<%@ page import="dao.OrderDAO" %>
<%@ page import="dao.BookingDAO" %>
<%@ page import="dao.RoomDAO" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.DecimalFormat" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Hotel Booking</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" type="text/css" href="static/css/index.css">
    <link rel="stylesheet" type="text/css" href="static/css/room.css">
    <style>
        .dropdown:hover .dropdown-menu {
            display: block;
            margin-top: 0;
        }
        .notification-badge {
            position: absolute;
            top: -10px;
            right: -10px;
            background-color: #dc3545;
            color: white;
            border-radius: 50%;
            padding: 2px 8px;
            font-size: 12px;
            font-weight: bold;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .notification-icon {
            position: relative;
            color: #dc3545;
            text-decoration: none;
            margin-right: 15px;
        }
        .notification-icon:hover {
            color: #c0a600;
        }
    </style>
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
        <a href="cart"><i class="fa-solid fa-cart-shopping"></i> Giỏ Hàng</a>
        <%
            User user = (User) session.getAttribute("User");
            Integer invalidOrderCount = (Integer) session.getAttribute("invalidOrderCount");
            if (invalidOrderCount == null) invalidOrderCount = 0;

            if (user != null) {
        %>
        <a href="verify-orders?filter=invalid" class="notification-icon" data-bs-toggle="tooltip"
           title="Thông báo: <%= invalidOrderCount %> đơn hàng không hợp lệ">
            <i class="fa-solid fa-bell"></i>
            <span class="notification-badge"><%= invalidOrderCount %></span>
        </a>

        <div class="dropdown d-inline-block">
            <a class="nav-link dropdown-toggle text-white" href="#" id="userDropdown" role="button">
                <i class="fa-solid fa-user"></i> <%= user.getName() %>
            </a>
            <ul class="dropdown-menu" aria-labelledby="userDropdown">
                <li><a class="dropdown-item text-dark" href="user_info.jsp"><i class="fa-solid fa-user-gear me-2"></i> Tài khoản của tôi</a></li>
                <li><a class="dropdown-item text-dark" href="verify-orders"><i class="fa-solid fa-file-invoice me-2"></i> Đơn đặt phòng</a></li>
                <li><hr class="dropdown-divider"></li>
                <li><a class="dropdown-item text-danger" href="logout"><i class="fa-solid fa-arrow-right-from-bracket me-2"></i> Đăng xuất</a></li>
            </ul>
        </div>
        <%
        } else {
        %>
        <a href="login.jsp"><i class="fa-solid fa-magnifying-glass"></i> Đăng Nhập/Đăng Kí</a>
        <%
            }
        %>
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
        // Initialize Bootstrap tooltips
        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
        var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl);
        });

    });
</script>
</body>
</html>