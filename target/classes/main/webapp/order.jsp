<%@ page import="java.util.*" %>
<%@ page import="model.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="Header.jsp" />
<html>
<head>
    <title>Đơn hàng đã xác thực</title>
    <style>
        .sidebar {
            width: 250px;
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 0 8px rgba(0,0,0,0.05);
            padding: 20px;
        }
        .sidebar .avatar {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background: #ddd;
            margin: 0 auto;
        }
        .sidebar p {
            text-align: center;
            font-weight: bold;
            margin-top: 10px;
        }
        .sidebar a {
            display: block;
            padding: 10px;
            color: #333;
            text-decoration: none;
            border-radius: 5px;
            margin-top: 10px;
        }
        .sidebar a:hover {
            background-color: #f0f0f0;
        }
        .order-box {
            border: 1px solid #ccc;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 30px;
            background-color: #f9f9f9;
            box-shadow: 0 2px 6px rgba(0,0,0,0.05);
        }
        .order-header {
            font-weight: bold;
            color: #007bff;
            margin-bottom: 15px;
        }
        .ca {
            display: flex;
            background: white;
            border-radius: 8px;
            padding: 15px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            margin-bottom: 15px;
            gap: 15px;
        }
        .ca img {
            width: 300px;
            max-width: 100%;
            height: 200px;
            object-fit: cover;
            border-radius: 8px;
        }
        .ca-info {
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
        .ca-info p {
            margin: 5px 0;
        }
        .sidebar-menu li a {
            display: block;
            padding: 10px 15px;
            border-radius: 6px;
            color: #333;
            text-decoration: none;
            transition: background-color 0.3s ease, transform 0.2s ease;
        }
        .sidebar-menu li a:hover {
            background-color: #f0f8ff;
            font-weight: bold;
            color: #007bff;
            transform: translateX(5px);
        }
        .filter-buttons {
            display: flex;
            gap: 10px;
        }
        .filter-btn {
            padding: 8px 16px;
            background-color: #e9ecef;
            color: #333;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.25s ease;
            min-width: 100px;
        }
        .filter-btn:hover {
            background-color: #007bff;
            color: white;
            border-color: #007bff;
            transform: translateY(-1px);
        }
        .filter-btn.active {
            background-color: #007bff;
            color: white;
            border-color: #007bff;
            font-weight: bold;
        }
    </style>
</head>
<body style="margin-top: 80px;">
<%
    session = request.getSession();
    User user = (User) session.getAttribute("User");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<div style="display: flex; max-width: 1200px; margin: 0 auto; padding: 30px; gap: 30px;">
    <%
        String message = (String) session.getAttribute("message");
        if (message != null) {
    %>
    <div style="background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; padding: 15px; margin-bottom: 30px; border-radius: 5px; width: 100%;">
        <%= message %>
    </div>
    <%
            session.removeAttribute("message");
        }
    %>

    <!-- Sidebar -->
    <div style="width: 250px; background-color: #fff; border-right: 1px solid #ddd; padding: 20px;">
        <div style="text-align: center; margin-bottom: 20px;">
            <div style="font-size: 60px; color: #007bff;">
                <i class="fa-solid fa-circle-user"></i>
            </div>
            <p style="margin-top: 10px; font-weight: bold;"><%= user.getName() %></p>
        </div>
        <hr style="margin-top: 20px; margin-bottom: 15px; border: none; border-top: 2px solid #999;">
        <ul class="sidebar-menu" style="list-style: none; padding: 0; margin: 0;">
            <li style="margin-bottom: 10px;">
                <a href="user_info.jsp">
                    <i class="fa-solid fa-user-gear me-2"></i> Tài khoản của tôi
                </a>
            </li>
            <li style="margin-bottom: 10px;">
                <a href="verify-orders">
                    <i class="fa-solid fa-file-invoice me-2"></i> Đơn đặt phòng
                </a>
            </li>
        </ul>
        <hr style="margin-top: 20px; margin-bottom: 15px; border: none; border-top: 2px solid #999;">
        <div style="margin-top: 30px; text-align: center; font-size: 14px;">
            <p style="color: red; font-weight: bold; margin-bottom: 5px;">
                Chưa có tool?
            </p>
            <div style="font-size: 18px; color: gray;">▼</div>
            <a href="tools/ToolChuKySo.exe.zip" download style="color: #007bff; text-decoration: none; font-weight: bold;">
                Tải tại đây
            </a>
        </div>
    </div>
    <!-- Main content -->
    <div style="flex: 1;">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
            <h2 style="margin: 0;">Danh sách phòng đã đặt</h2>
            <div style="width: 2px; height: 30px; background-color: #999;"></div>
            <div class="filter-buttons">
                <button class="filter-btn <%= "all".equals(request.getParameter("filter")) || request.getParameter("filter") == null ? "active" : "" %>" onclick="filterOrders('all')">Tất cả</button>
                <button class="filter-btn <%= "valid".equals(request.getParameter("filter")) ? "active" : "" %>" onclick="filterOrders('valid')">Hợp lệ</button>
                <button class="filter-btn <%= "invalid".equals(request.getParameter("filter")) ? "active" : "" %>" onclick="filterOrders('invalid')">Không hợp lệ</button>
            </div>
        </div>
        <%
            List<Order> orders = (List<Order>) request.getAttribute("orders");
            Map<Integer, Boolean> verificationMap = (Map<Integer, Boolean>) request.getAttribute("verificationMap");
            if (orders == null || orders.isEmpty()) {
        %>
        <p>Chưa có đơn hàng nào.</p>
        <%
        } else {
            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm");
            BookingDAO bookingDAO = new BookingDAO();
            RoomDAO roomDAO = new RoomDAO();
            DecimalFormat currencyFormat = new DecimalFormat("#,###");
            for (Order order : orders) {
                Boolean valid = verificationMap != null ? verificationMap.get(order.getOrderId()) : null;
        %>
        <div class="order-box" data-valid="<%= valid != null && valid %>">
            <div class="order-header">
                Người đặt: <%= order.getCustomerName() %> |
                Email: <%= order.getCustomerEmail() %> |
                Số điện thoại: <%= order.getCustomerPhone() %><br>
                Thời gian: <%= sdf.format(order.getTimeStamp()) %><br>
                <strong style="color: green;">Tổng tiền: <%= currencyFormat.format(order.getTotalPrice()) %> VNĐ</strong>
            </div>
            <% if (valid != null) { %>
            <p style="margin-top: 8px;">
                <% if (valid) { %>
                <span style="color: green; font-weight: bold;">Đơn hàng hợp lệ</span>
                <% } else { %>
                <span style="color: red; font-weight: bold;">Đơn hàng không hợp lệ</span>
                <% } %>
            </p>
            <% } %>
            <%
                List<Booking> bookings = bookingDAO.getByOrderId(order.getOrderId());
                for (Booking b : bookings) {
                    Room room = roomDAO.getRoomById(b.getRoomId());
            %>
            <div class="ca">
                <img src="<%= request.getContextPath() %>/static/images/<%= room.getImage() %>" alt="<%= room.getName() %>">
                <div class="ca-info">
                    <p><strong>Phòng:</strong> <%= room.getName() %></p>
                    <p><strong>Địa điểm:</strong> <%= room.getLocation() %></p>
                    <p><strong>Check-in:</strong> <%= sdf.format(b.getCheckIn()) %></p>
                    <p><strong>Check-out:</strong> <%= sdf.format(b.getCheckOut()) %></p>
                    <p><strong>Số lượng phòng:</strong> <%= b.getQuantity() %></p>
                    <p><strong>Giá:</strong> <%= currencyFormat.format(room.getPrice()) %> VNĐ/đêm</p>
                </div>
            </div>
            <% } %>
        </div>
        <% } } %>
    </div>
</div>
<script>
    function filterOrders(type) {
        const allOrders = document.querySelectorAll('.order-box');
        allOrders.forEach(order => {
            const isValid = order.getAttribute('data-valid') === 'true';
            if (type === 'all') {
                order.style.display = 'block';
            } else if (type === 'valid') {
                order.style.display = isValid ? 'block' : 'none';
            } else if (type === 'invalid') {
                order.style.display = !isValid ? 'block' : 'none';
            }
        });
        document.querySelectorAll('.filter-btn').forEach(btn => btn.classList.remove('active'));
        const index = type === 'valid' ? 1 : type === 'invalid' ? 2 : 0;
        document.querySelectorAll('.filter-btn')[index].classList.add('active');
    }
    // Apply filter based on URL parameter
    document.addEventListener('DOMContentLoaded', function() {
        const urlParams = new URLSearchParams(window.location.search);
        const filter = urlParams.get('filter');
        if (filter === 'all' || filter === 'valid' || filter === 'invalid') {
            filterOrders(filter);
        }
    });
</script>
<jsp:include page="Footer.jsp" />
</body>
</html>