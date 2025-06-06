<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="java.io.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
    String fullname = request.getParameter("fullname");
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    String confirmPassword = request.getParameter("confirmPassword");

    if (password.equals(confirmPassword)) {
        out.println("<h2 style='color:green;'>Đăng ký thành công!</h2>");
        out.println("<p>Xin chào, " + fullname + "! Tài khoản của bạn đã được tạo thành công.</p>");
    } else {
        out.println("<h2 style='color:red;'>Mật khẩu không khớp! Vui lòng thử lại.</h2>");
    }
%>
</body>
</html>