<%@page import="dao.RoomDAO"%>
<%@ page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.*"%>
<%@ page import="dao.BookingDAO"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Thông tin cá nhân & Đặt phòng</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 0;
            line-height: 1.6;
        }
        .container {
            max-width: 900px;
            margin: 40px auto;
            background: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        h1 {
            text-align: center;
            color: #333;
            margin-bottom: 40px;
        }
        .personal-info {
            margin-bottom: 50px;
            padding: 20px;
            border-bottom: 2px solid #007bff;
        }
        .personal-info h2 {
            color: #007bff;
            margin-bottom: 15px;
        }
        .personal-info p {
            font-size: 18px;
            color: #555;
        }
        .bookings-list {
            margin-top: 20px;
        }
        .booking-card {
            display: flex;
            flex-wrap: wrap;
            background: #fafafa;
            border: 1px solid #ddd;
            border-radius: 8px;
            margin-bottom: 25px;
            box-shadow: 0 1px 5px rgba(0,0,0,0.08);
            padding: 20px;
        }
        .booking-card img {
            width: 100%;
            max-width: 40%;
            height: auto;
            margin-right: 20px;
            border-radius: 6px;
        }
        .booking-info {
            flex: 1;
            width: 55%;
            text-align: left;
        }
        .booking-info h3 {
            margin-top: 0;
            color: #007bff;
            font-weight: 600;
        }
        .booking-info p {
            margin: 8px 0;
            font-size: 16px;
            color: #444;
        }
        .booking-info strong {
            color: #222;
        }
        .no-bookings {
            text-align: center;
            font-size: 18px;
            color: #666;
            margin-top: 40px;
        }
        .back-link {
            display: inline-block;
            margin-top: 30px;
            padding: 12px 25px;
            background: #007bff;
            color: #fff;
            text-decoration: none;
            border-radius: 5px;
            font-size: 16px;
            transition: background 0.3s ease;
            text-align: center;
        }
        .back-link:hover {
            background: #0056b3;
        }
        @media (max-width: 768px) {
            .booking-card {
                flex-direction: column;
            }
            .booking-card img {
                max-width: 100%;
                margin-bottom: 15px;
            }
            .booking-info {
                width: 100%;
            }
        }
    </style>
</head>
<jsp:include page="Header.jsp" />
<body>
<div class="container">
    <h1>Thông tin cá nhân & Đặt phòng</h1>

    <%
        // Lấy user từ session
        session = request.getSession();
        User user = (User) session.getAttribute("User");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
    %>

    <!-- Phần thông tin cá nhân -->
    <div class="personal-info">
        <h2>Thông tin cá nhân</h2>
        <p><strong>Họ tên:</strong> <%= user.getName() != null ? user.getName() : "Chưa cập nhật" %></p>
        <p><strong>Email:</strong> <%= user.getEmail() != null ? user.getEmail() : "Chưa cập nhật" %></p>
    </div>

    <!-- Phần danh sách đặt phòng -->
    <div class="bookings-list">
        <h2>Danh sách phòng đã đặt</h2>
        <%
            BookingDAO bookingDAO = new BookingDAO();
            RoomDAO rDAO = new RoomDAO();
            List<Booking> bookings = bookingDAO.getAllByUser(user);

            if (bookings != null && !bookings.isEmpty()) {
                for (Booking booking : bookings) {
                    int roomId = booking.getRoomId();
                    Room room = rDAO.getRoomById(roomId);
        %>
        <div class="booking-card">
            <img src="<%= request.getContextPath() %>/static/images/<%= room != null ? room.getImage() : "default-room.jpg" %>" alt="<%= room != null ? room.getName() : "Phòng" %>">
            <div class="booking-info">
                <h3>Đặt phòng #<%= booking.getBookingId() %></h3>
                <p><strong>Phòng:</strong> <%= room != null ? room.getName() : "Không xác định" %></p>
                <p><strong>Địa điểm:</strong> <%= room != null ? room.getLocation() : "Không xác định" %></p>
                <p><strong>Giá:</strong> <%= room != null ? room.getPrice() : "Không xác định" %> VNĐ mỗi đêm</p>
                <p><strong>Ngày nhận phòng:</strong> <%= booking.getCheckIn() %></p>
                <p><strong>Ngày trả phòng:</strong> <%= booking.getCheckOut() %></p>
                <p><strong>Trạng thái:</strong> <%= booking.getStatus() %></p>
                <p><strong>Tổng tiền:</strong>
                    <%= room != null
                            ? room.getPrice() * (booking.getCheckOut().getTime() - booking.getCheckIn().getTime()) / (1000 * 60 * 60 * 24)
                            : "Không xác định" %> VNĐ
                </p>
            </div>
        </div>
        <%
            }
        } else {
        %>
        <p class="no-bookings">Bạn chưa có phòng nào được đặt.</p>
        <% } %>
    </div>

    <a href="home.jsp" class="back-link">Quay lại trang chủ</a>
</div>
<jsp:include page="Footer.jsp" />
</body>
</html>
