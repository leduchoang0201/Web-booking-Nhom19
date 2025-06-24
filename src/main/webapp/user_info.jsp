<%@ page import="model.User" %>
<%@ page import="dao.UserDAO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="Header.jsp" />
<!DOCTYPE html>
<html>
<head>
    <title>Thông tin người dùng</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
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

        .key-section {
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }

        .key-section h2 {
            margin-bottom: 20px;
        }

        .public-key-box {
            width: 100%;
            height: 100px;
            font-family: monospace;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 6px;
            resize: none;
        }

        .load-key-btn, .delete-key-btn {
            padding: 10px 20px;
            margin-top: 10px;
            border-radius: 5px;
            cursor: pointer;
            transition: background 0.3s ease;
            border: none;
        }

        .load-key-btn {
            background-color: #007bff;
            color: white;
        }

        .load-key-btn:hover {
            background-color: #0056b3;
        }

        .delete-key-btn {
            background-color: #dc3545;
            color: white;
        }

        .delete-key-btn:hover {
            background-color: #b02a37;
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

        form input[type="text"], form input[type="email"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        form label {
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
    UserDAO userDAO = new UserDAO();
    String publicKey = userDAO.getPublicKey(user.getId());
    String message = (String) session.getAttribute("message");
%>

<!-- Layout giống order.jsp -->
<div style="display: flex; max-width: 1200px; margin: 0 auto; padding: 30px; gap: 30px;">
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
            <div style="font-size: 18px; color: gray;">&#x25BC;</div>
            <a href="tools/ToolChuKySo.exe.zip" download style="color: #007bff; text-decoration: none; font-weight: bold;">
                Tải tại đây
            </a>
        </div>
    </div>

    <!-- Nội dung chính -->
    <div style="flex: 1; display: flex; flex-direction: column; align-items: center;">
        <div style="width: 100%; max-width: 700px;">
            <% if (message != null) { %>
            <div style="background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; padding: 15px; margin-bottom: 30px; border-radius: 5px;">
                <%= message %>
            </div>
            <% session.removeAttribute("message"); %>
            <% } %>

            <div class="key-section">
                <h2>Thông tin người dùng</h2>
                <form action="InfoServlet" method="post" style="display: flex; flex-direction: column; gap: 15px;">
                    <input type="hidden" name="action" value="updateUser">
                    <div>
                        <label for="fullName">Họ và tên:</label>
                        <input type="text" id="fullName" name="fullName" value="<%= user.getName() %>" required>
                    </div>
                    <div>
                        <label for="email">Email:</label>
                        <input type="email" id="email" name="email" value="<%= user.getEmail() %>" required>
                    </div>
                    <button type="submit" class="load-key-btn">Cập nhật thông tin</button>
                </form>
            </div>

            <div class="key-section">
                <h2>Khóa công khai</h2>
                <% if (publicKey != null && !publicKey.trim().isEmpty()) { %>
                <textarea rows="8" class="public-key-box" readonly><%= publicKey %></textarea>
                <form action="SendOTPServlet" method="post">
                    <button type="submit" class="delete-key-btn">Báo mất khóa</button>
                </form>
                <% } else { %>
                <p style="color: gray;">Chưa có khóa công khai.</p>
                <form action="InfoServlet" method="post" enctype="multipart/form-data" class="key-form">
                    <input type="hidden" name="action" value="uploadKey">
                    <label class="custom-file-upload">
                        <input type="file" name="publicKeyFile" accept=".txt,.pem" required onchange="this.form.submit()">
                        <i class="fa fa-upload"></i> Tải khóa lên
                    </label>
                </form>
                <% } %>
                <div style="margin-top: 20px;">
                    <p style="color: #333;">
                        Chưa có tool? Hãy
                        <a href="tools/ToolChuKySo.exe.zip" download style="color: #007bff; text-decoration: none;">tải ở đây</a>.
                    </p>
                </div>
            </div>
        </div>
    </div>

</div>

<!-- Modal OTP -->
<%
    Boolean showModal = (Boolean) session.getAttribute("showOtpModal");
    if (showModal != null && showModal) {
%>
<div id="otpModal" style="position: fixed; top: 0; left: 0; width: 100%; height: 100%;
    background: rgba(0,0,0,0.5); display: flex; justify-content: center; align-items: center; z-index: 9999;">
    <div style="background: white; padding: 30px; border-radius: 8px; min-width: 300px; max-width: 90%;">
        <h3>Xác minh OTP</h3>
        <form action="InfoServlet" method="post" style="display: flex; flex-direction: column; gap: 10px;">
            <input type="hidden" name="action" value="verifyOtpAndDelete">
            <label>Nhập mã OTP gửi đến email:</label>
            <input type="text" name="otp" required placeholder="6 chữ số">
            <div style="display: flex; gap: 10px; justify-content: flex-end;">
                <button type="submit" class="load-key-btn">Xác nhận</button>
                <button type="button" onclick="document.getElementById('otpModal').style.display='none'" class="delete-key-btn">Huỷ</button>
            </div>
        </form>
    </div>
</div>
<% session.removeAttribute("showOtpModal"); } %>

<jsp:include page="Footer.jsp" />
</body>
</html>
