<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
    <title>KẾT QUẢ THANH TOÁN</title>
    <link href="assets/bootstrap.min.css" rel="stylesheet"/>
    <link href="assets/jumbotron-narrow.css" rel="stylesheet">
    <script src="assets/jquery-1.11.3.min.js"></script>
</head>
<body>
<div class="container">
    <div class="header clearfix">
        <h3 class="text-muted">KẾT QUẢ THANH TOÁN</h3>
    </div>
    <div class="table-responsive">
        <div class="form-group">
            <label>Mã giao dịch thanh toán:</label>
            <label><%= request.getAttribute("vnp_TxnRef") %></label>
        </div>
        <div class="form-group">
            <label>Số tiền:</label>
            <label><%= request.getAttribute("vnp_Amount") %></label>
        </div>
        <div class="form-group">
            <label>Mô tả giao dịch:</label>
            <label><%= request.getAttribute("vnp_OrderInfo") %></label>
        </div>
        <div class="form-group">
            <label>Mã lỗi thanh toán:</label>
            <label><%= request.getAttribute("vnp_ResponseCode") %></label>
        </div>
        <div class="form-group">
            <label>Mã giao dịch tại VNPAY:</label>
            <label><%= request.getAttribute("vnp_TransactionNo") %></label>
        </div>
        <div class="form-group">
            <label>Mã ngân hàng thanh toán:</label>
            <label><%= request.getAttribute("vnp_BankCode") %></label>
        </div>
        <div class="form-group">
            <label>Thời gian thanh toán:</label>
            <label><%= request.getAttribute("vnp_PayDate") %></label>
        </div>
        <div class="form-group">
            <label>Tình trạng giao dịch:</label>
            <label>
                <%
                    String responseCode = (String) request.getAttribute("vnp_ResponseCode");
                    Boolean isValidSignature = (Boolean) request.getAttribute("isValidSignature");
                    if (isValidSignature != null && isValidSignature && "00".equals(responseCode)) {
                        out.print("Thanh toán thành công.");
                %>
                <form action="BookingServlet" method="GET">
                    <button type="submit" class="btn btn-success">Tiếp tục</button>
                </form>
                <%
                } else {
                    out.print("Không thành công. Mã lỗi: " + responseCode);
                    if (isValidSignature == null || !isValidSignature) {
                        out.print(" (Chữ ký không hợp lệ)");
                    }
                %>
                <br>
                <a href="home.jsp" class="btn btn-primary">Quay về trang chủ</a>
                <%
                    }
                %>
            </label>
        </div>
    </div>
    <footer class="footer">
        <p>© VNPAY 2020</p>
    </footer>
</div>
</body>
</html>