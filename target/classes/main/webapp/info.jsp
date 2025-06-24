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
        .key-section {
            margin-bottom: 40px;
            background-color: #fff;
            padding: 25px;
            border-radius: 8px;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
        }

        .public-key-box {
            width: 100%;
            font-family: monospace;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 6px;
            resize: none;
        }

        .key-form {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-top: 15px;
            flex-wrap: wrap;
        }

        .custom-file-upload {
            background-color: #f1f1f1;
            padding: 10px 15px;
            border: 1px solid #ccc;
            border-radius: 5px;
            cursor: pointer;
            display: inline-block;
            color: #333;
            transition: background 0.3s ease;
        }

        .custom-file-upload:hover {
            background-color: #e0e0e0;
        }

        .custom-file-upload input[type="file"] {
            display: none;
        }

        .load-key-btn {
            padding: 10px 20px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background 0.3s ease;
        }

        .load-key-btn:hover {
            background-color: #0056b3;
        }

        .delete-key-btn {
            padding: 10px 20px;
            background-color: #dc3545;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background 0.3s ease;
        }

        .delete-key-btn:hover {
            background-color: #b02a37;
        }

    </style>
</head>
<jsp:include page="Header.jsp" />
<body>

<div class="container">
    <%
        String message = (String) session.getAttribute("message");
        if (message != null) {
    %>
    <div style="background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; padding: 15px; margin: 20px; border-radius: 5px;">
        <%= message %>
    </div>
    <%
            session.removeAttribute("message"); // Xóa để không hiển thị lại khi reload
        }
    %>
    <%
        session = request.getSession();
        User user = (User) session.getAttribute("User");
        dao.UserDAO userDAO = new dao.UserDAO();
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        String publicKey = userDAO.getPublicKey(user.getId());
    %>

    <div style="display: flex; flex-wrap: wrap; gap: 20px;">
        <!-- Khung khóa công khai -->
        <div class="key-section" style="flex: 1; min-width: 300px;">
            <h2>Khóa công khai</h2>

            <% if (publicKey != null && !publicKey.trim().isEmpty()) { %>
            <textarea rows="8" class="public-key-box" readonly><%= publicKey %></textarea>
            <div style="margin-top: 10px;">
                <label><strong>Xem nhanh khóa:</strong></label>
                <input type="text" value="<%= publicKey.length() > 30 ? publicKey.substring(0, 30) + "..." : publicKey %>"
                       readonly style="width: 100%; padding: 8px; margin-top: 5px; font-family: monospace; border: 1px solid #ccc; border-radius: 5px;">
            </div>
            <% } else { %>
            <p style="color: gray;">Chưa có khóa công khai.</p>
            <% } %>

            <!-- Gửi action = upload -->
            <form action="InfoServlet" method="post" enctype="multipart/form-data" class="key-form">
                <input type="hidden" name="action" value="uploadKey">
                <label class="custom-file-upload">
                    <input type="file" name="publicKeyFile" accept=".txt,.pem" required onchange="this.form.submit()">
                    <i class="fa fa-upload"></i> Tải khóa lên
                </label>
            </form>

            <!-- Gửi action = delete -->
            <form action="InfoServlet" method="post" style="margin-top: 15px;">
                <input type="hidden" name="action" value="deleteKey">
                <button type="submit" class="delete-key-btn">Báo mất khóa</button>
            </form>
            <div style="margin-top: 20px;">
                <p style="color: #333;">
                    Chưa có tool? Hãy
                    <a href="tools/ToolChuKySo.exe.zip" download style="color: #007bff; text-decoration: none;">tải ở đây</a>.
                </p>
            </div>

        </div>

        <!-- Khung thông tin người dùng -->
        <div class="key-section" style="flex: 1; min-width: 300px;">
            <h2>Thông tin người dùng</h2>
            <form action="InfoServlet" method="post" style="display: flex; flex-direction: column; gap: 15px;">
                <input type="hidden" name="action" value="updateUser">
                <div>
                    <label for="fullName"><strong>Họ và tên:</strong></label>
                    <input type="text" id="fullName" name="fullName" value="<%= user.getName() %>" required
                           style="width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 5px;">
                </div>
                <div>
                    <label for="email"><strong>Email:</strong></label>
                    <input type="email" id="email" name="email" value="<%= user.getEmail() %>" required
                           style="width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 5px;">
                </div>
                <button type="submit" class="load-key-btn" style="width: fit-content;">Cập nhật thông tin</button>
            </form>
        </div>
    </div>


    <h1 class="heading">Thông tin đặt phòng</h1>

    <%

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