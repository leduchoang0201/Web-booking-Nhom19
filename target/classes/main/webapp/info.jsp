<%@page import="dao.RoomDAO"%>
<%@ page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.*"%>
<%@ page import="dao.BookingDAO"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thông tin đặt phòng</title>
    <style>
    body {
    font-family: Arial, sans-serif;
    line-height: 1.6;
    margin: 0;
    padding: 0;
    background-color: #f5f5f5;
}

.container {
    max-width: 100%;
    margin: 0 auto;
    padding: 40px;
}

.heading {
    text-align: center;
    margin-bottom: 40px;
    font-size: 28px;
    color: #333;
    font-weight: bold;
}

.ca {
    display: flex;
    flex-wrap: wrap;
    background: #fff;
    border: 1px solid #ddd;
    border-radius: 8px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
    padding: 20px;
    margin-bottom: 30px;
}

.ca img {
    width: 100%;
    max-width: 40%;  /* Ảnh chiếm 60% chiều rộng */
    height: auto;  /* Duy trì tỷ lệ khung hình của ảnh */
    margin-right: 20px;
}

.ca-info {
    flex: 1;
    width: 40%;  /* Phần chữ chiếm 40% chiều rộng */
    text-align: left;
}

.ca h3 {
    margin: 0;
    color: #007bff;
    font-size: 24px;
    font-weight: 60;
    text-align: left;
}

.ca p {
    margin: 10px 0;
    font-size: 16px;
    color: #555;
    width: 60%;
    text-align: left;  /* Căn trái cho phần chữ */
}

.ca p strong {
    color: #333;
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
    .container {
        padding: 20px;
    }

    .ca img {
        max-width: 60%; /* Ảnh sẽ chiếm hết chiều rộng trên thiết bị nhỏ */
    }

    .ca-info {
        width: 100%; /* Phần chữ chiếm hết chiều rộng trên thiết bị nhỏ */
    }

    .heading {
        font-size: 24px;
    }

    .ca h3 {
        font-size: 20px;
    }

    .back-link {
        padding: 10px 20px;
        font-size: 14px;
    }
}

    </style>
</head>
<body>
    <jsp:include page="Header.jsp" />

    <div class="container">
        <h1 class="heading">Thông tin đặt phòng</h1>

        <%
        session = request.getSession();
        User user = (User) session.getAttribute("User");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        BookingDAO bookingDAO = new BookingDAO();
        RoomDAO rDAO = new RoomDAO();
        List<Booking> bookings = bookingDAO.getAllByUser(user); 
        if (bookings != null && !bookings.isEmpty()) { 
            for (Booking booking : bookings) {
                int roomId = booking.getRoomId();
                Room room = rDAO.getRoomById(roomId);
        %>
        <div class="ca">
            <img src="<%= request.getContextPath() %>/static/images/<%= room.getImage() %>" alt="<%= room.getName() %>">
            <div class="ca-info">
                <h3>Đặt phòng #<%= booking.getBookingId() %></h3>
                <p><strong>Phòng:</strong> <%= room != null ? room.getName() : "Không xác định" %></p>
                <p><strong>Địa điểm:</strong> <%= room != null ? room.getLocation() : "Không xác định" %></p>
                <p><strong>Giá:</strong> <%= room != null ? room.getPrice() : "Không xác định" %> VNĐ mỗi đêm</p>
                <p><strong>Ngày nhận phòng:</strong> <%= booking.getCheckIn() %></p>
                <p><strong>Ngày trả phòng:</strong> <%= booking.getCheckOut() %></p>
                <p><strong>Trạng thái:</strong> <%= booking.getStatus() %></p>
                <p><strong>Tổng tiền:</strong> 
                    <%= room != null ? room.getPrice() * (booking.getCheckOut().getTime() - booking.getCheckIn().getTime()) / (1000 * 60 * 60 * 24) : "Không xác định" %> VNĐ
                </p>
            </div>
        </div>
        <%
            } // Kết thúc vòng lặp danh sách đặt phòng
        } else { 
        %>
        <p class="no-bookings">Không có thông tin đặt phòng nào.</p>
        <% 
        } 
        %>

    </div>

    <jsp:include page="Footer.jsp" />
</body>
</html>
