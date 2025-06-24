<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, java.text.SimpleDateFormat" %>
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
    SimpleDateFormat timestampFormat = new SimpleDateFormat("HH:mm:ss dd/MM/yyyy");
    Date now = new Date();
    Long invoiceTimestamp = (Long) session.getAttribute("invoiceTimestamp");
    long expireMillis = invoiceTimestamp != null ? invoiceTimestamp + (5 * 60 * 1000) : System.currentTimeMillis();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Hóa đơn</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="static/css/invoice.css">
    <style>
        /* CSS tùy chỉnh để căn chỉnh nút Tải dữ liệu */
        .download-btn {
            margin-top: 15px; /* Khoảng cách từ hướng dẫn */
        }
        .modal-footer {
            justify-content: flex-end; /* Căn phải cho nút Hủy và Xác nhận */
        }
    </style>
</head>
<jsp:include page="Header.jsp" />
<body>
<div class="container mt-5 mb-5">

    <!-- KHUNG HÓA ĐƠN -->
    <div class="section invoice-section mb-5">
        <h2 class="section-title text-primary mb-4">Hóa đơn thanh toán</h2>
        <p><strong>Họ tên:</strong> <%= name %></p>
        <p><strong>Email:</strong> <%= email %></p>
        <p><strong>Số điện thoại:</strong> <%= phone %></p>

        <table class="table table-bordered mt-4">
            <thead class="table-light">
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
                <td><span class="money"><%= item.getRoom().getPrice() %></span></td>
                <td><%= sdf.format(item.getCheckIn()) %></td>
                <td><%= sdf.format(item.getCheckOut()) %></td>
                <td><%= item.getQuantity() %></td>
                <td><span class="subtotal"><%= item.getSubtotal() %></span></td>
            </tr>
            <% } %>
            </tbody>
        </table>

        <h4 class="text-end mt-4 text-success">Tổng tiền:
            <span id="totalAmount" class="money" data-value="<%= total %>"><%= total %></span>
        </h4>
        <h5 class="text-end text-danger">Số tiền đặt cọc (10%):
            <span id="depositAmount" class="money" data-value="<%= deposit %>"><%= deposit %></span>
        </h5>
    </div>
    <div id="timeoutMessage" class="alert alert-danger text-center" style="display: none;">
        Hóa đơn đã hết thời hạn xác thực. Vui lòng <a href="rooms">tạo hóa đơn mới</a>.
    </div>

    <!-- Nút xác thực -->
    <div class="text-center mt-4">
        <button class="btn btn-success btn-lg" onclick="showVerificationModal()">Xác thực chữ ký số</button>
    </div>

    <!-- Modal xác thực chữ ký số -->
    <div class="modal fade" id="verifyModal" tabindex="-1" aria-labelledby="verifyModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content">
                <form action="verifySignature" method="post" onsubmit="return handleSubmit()">
                    <input type="hidden" name="name" value="<%= name %>">
                    <input type="hidden" name="email" value="<%= email %>">
                    <input type="hidden" name="phone" value="<%= phone %>">
                    <div class="modal-header">
                        <h5 class="modal-title" id="verifyModalLabel">Xác thực chữ ký số</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                    </div>
                    <div class="modal-body">
                        <!-- Thời gian tĩnh -->
                        <div class="alert alert-warning text-center">
                            Bạn chỉ có <strong>5'</strong> để thực hiện xác thực.
                        </div>
                        <input type="hidden" id="expireAt" value="<%= String.valueOf(expireMillis) %>">

                        <!-- Hướng dẫn -->
                        <p class="text-center">
                            Bạn cần <strong>ký dữ liệu</strong> bằng <strong>RSA Private Key</strong> của mình và dán chữ ký vào đây:
                        </p>

                        <!-- Nút Tải dữ liệu dưới hướng dẫn -->
                        <div class="text-center download-btn" style="margin-bottom: 15px;">
                            <button type="button" id="downloadButton" class="btn btn-primary" onclick="toggleDownloadStyle()">📄 Tải dữ liệu</button>
                            <input type="hidden" id="rawDataHidden" value="<%= rawData %>">
                        </div>

                        <!-- Trường nhập chữ ký -->
                        <textarea id="signatureInput" class="form-control" name="signature" rows="5" placeholder="Dán chữ ký số tại đây" required></textarea>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-success">Xác nhận và gửi</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Nút quay lại -->
    <div class="text-center mt-4">
        <a href="rooms" class="btn btn-outline-primary">Tiếp tục đặt phòng</a>
    </div>
</div>

<script>
    function checkTimeout() {
        const expireAtInput = document.getElementById("expireAt");
        const verifyButton = document.querySelector(".btn-success.btn-lg");
        const modalSubmitButton = document.querySelector("#verifyModal .btn-success");
        const timeoutMessage = document.getElementById("timeoutMessage");

        if (!expireAtInput || !expireAtInput.value) {
            console.error("Không tìm thấy hoặc giá trị rỗng cho input #expireAt");
            if (timeoutMessage) timeoutMessage.style.display = "block";
            if (verifyButton) verifyButton.disabled = true;
            if (modalSubmitButton) modalSubmitButton.disabled = true;
            return;
        }

        const expireAt = parseInt(expireAtInput.value);
        if (isNaN(expireAt)) {
            console.error("Giá trị expireAt không hợp lệ:", expireAtInput.value);
            if (timeoutMessage) timeoutMessage.style.display = "block";
            if (verifyButton) verifyButton.disabled = true;
            if (modalSubmitButton) modalSubmitButton.disabled = true;
            return;
        }

        const now = Date.now();
        if (now >= expireAt) {
            console.log("Hết thời gian xác thực");
            if (timeoutMessage) timeoutMessage.style.display = "block";
            if (verifyButton) verifyButton.disabled = true;
            if (modalSubmitButton) modalSubmitButton.disabled = true;
            setTimeout(() => {
                window.location.href = "rooms";
            }, 5000);
        } else {
            setTimeout(checkTimeout, expireAt - now);
        }
    }

    function showVerificationModal() {
        const modal = new bootstrap.Modal(document.getElementById("verifyModal"));
        modal.show();
    }

    function handleSubmit() {
        const signature = document.getElementById("signatureInput").value.trim();
        if (!signature) {
            const errorDiv = document.createElement("div");
            errorDiv.className = "alert alert-danger text-center";
            errorDiv.textContent = "Vui lòng dán chữ ký số.";
            document.querySelector("#verifyModal .modal-body").prepend(errorDiv);
            setTimeout(() => errorDiv.remove(), 3000);
            return false;
        }
        return true;
    }

    function downloadRawData() {
        const rawData = document.getElementById("rawDataHidden").value;
        if (!rawData) {
            console.error("Không có dữ liệu để tải.");
            return;
        }
        const blob = new Blob([rawData], { type: 'text/plain' });
        const url = window.URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = 'rawData.txt';
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        window.URL.revokeObjectURL(url);
    }

    function toggleDownloadStyle() {
        const button = document.getElementById("downloadButton");
        if (button.classList.contains("btn-primary")) {
            button.classList.remove("btn-primary");
            button.classList.add("btn-outline-primary");
        } else {
            button.classList.remove("btn-outline-primary");
            button.classList.add("btn-primary");
        }
        downloadRawData(); // Gọi hàm tải dữ liệu
    }

    function updateSubtotals() {
        document.querySelectorAll(".subtotal").forEach(span => {
            let raw = parseFloat(span.textContent);
            if (!isNaN(raw)) {
                span.textContent = raw.toLocaleString('vi-VN') + ' VNĐ';
            }
        });
    }

    function updateTotal() {
        const totalSpan = document.querySelector("#totalAmount");
        const depositSpan = document.querySelector("#depositAmount");

        let total = parseFloat(totalSpan.dataset.value);
        let deposit = parseFloat(depositSpan.dataset.value);

        if (!isNaN(total)) {
            totalSpan.textContent = total.toLocaleString('vi-VN') + ' VNĐ';
        }

        if (!isNaN(deposit)) {
            depositSpan.textContent = deposit.toLocaleString('vi-VN') + ' VNĐ';
        }
    }

    document.addEventListener("DOMContentLoaded", () => {
        updateSubtotals();
        updateTotal();
        checkTimeout();
    });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<jsp:include page="Footer.jsp" />
</body>
</html>