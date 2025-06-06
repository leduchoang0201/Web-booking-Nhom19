<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.CartItem" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems");
    Number totalValue = (Number) request.getAttribute("total");
    double total = totalValue != null ? totalValue.doubleValue() : 0.0;
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Giỏ hàng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="static/css/index.css">
</head>
<jsp:include page="Header.jsp" />
<body>
<div class="container mt-5" style="padding-top: 70px">
    <div class="text-center mb-4">
        <h2 class="mb-3">Giỏ hàng của bạn</h2>
        <a href="rooms" class="btn btn-secondary">← Tiếp tục mua hàng</a>
    </div>
    <%
        if (cartItems == null || cartItems.isEmpty()) {
    %>
    <div class="alert alert-info">Chưa có phòng nào trong giỏ hàng.</div>
    <%
    } else {
    %>
    <table class="table table-bordered">
        <thead>
        <tr>
            <th>Tên phòng</th>
            <th>Giá</th>
            <th>Check-in</th>
            <th>Check-out</th>
            <th>Số lượng</th>
            <th>Thành tiền</th>
            <th>Xoá</th>
        </tr>
        </thead>
        <tbody>
        <% for (int i = 0; i < cartItems.size(); i++) {
            CartItem item = cartItems.get(i);
        %>
        <tr>
            <td><%= item.getRoom().getName() %></td>
            <td><span class="money price" data-price="<%= item.getRoom().getPrice() %>"><%= item.getRoom().getPrice() %></span></td>
            <td>
                <input type="date" name="checkIn" value="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(item.getCheckIn()) %>" class="form-control checkIn" data-index="<%= i %>" required>
            </td>
            <td>
                <input type="date" name="checkOut" value="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(item.getCheckOut()) %>" class="form-control checkOut" data-index="<%= i %>" required>
            </td>
            <td>
                <input type="number" name="quantity" value="<%= item.getQuantity() %>" min="1" class="form-control quantity" data-index="<%= i %>" data-price="<%= item.getRoom().getPrice() %>" required>
            </td>
            <td><span class="money subtotal"><%= item.getSubtotal() %></span></td>
            <td>
                <a href="<%= request.getContextPath() %>/removeFromCart?index=<%= i %>" class="btn btn-danger btn-sm">Xoá</a>
            </td>
        </tr>

        <% } %>
        </tbody>
    </table>

    <h4 class="text-end">Tổng cộng: <span class="money"><%= total %> </span></h4>
    <div class="text-end">
        <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#checkoutModal">
            Thanh toán
        </button>

    </div>
    <%
        }
    %>
    <!-- Modal -->
    <div class="modal fade" id="checkoutModal" tabindex="-1" aria-labelledby="checkoutModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <form action="CreateInvoiceServlet" method="post">
                    <div class="modal-header">
                        <h5 class="modal-title" id="checkoutModalLabel">Xác nhận thanh toán</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                    </div>
                    <div class="modal-body">
                        <%
                            model.User user = (model.User) session.getAttribute("user");
                            String customerName = user != null ? user.getName() : "";
                            String customerEmail = user != null ? user.getEmail() : "";
                            double deposit = total * 0.10;
                        %>
                        <div class="mb-3">
                            <label class="form-label">Họ tên người đặt</label>
                            <input type="text" name="name" class="form-control" value="<%= customerName %>" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Email</label>
                            <input type="email" name="email" class="form-control" value="<%= customerEmail %>" readonly>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Số điện thoại</label>
                            <input type="text" name="phone" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Số tiền đặt cọc (10%)</label>
                            <input type="text" name="depositAmount" class="form-control" value="<%= String.format("%.2f", deposit) %>" readonly>
                        </div>
                        <input type="hidden" name="total" value="<%= total %>">
                        <input type="hidden" name="depositPercent" value="10">
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Huỷ</button>
                        <button type="submit" class="btn btn-primary">Xác nhận</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<script>

    function calcDays(checkIn, checkOut) {
        const inDate = new Date(checkIn);
        const outDate = new Date(checkOut);
        const diff = Math.ceil((outDate - inDate) / (1000 * 60 * 60 * 24));
        return diff > 0 ? diff : 1;
    }

    function updateSubtotal(index) {
        const quantityInput = document.querySelector(`input.quantity[data-index='${index}']`);
        const checkInInput = document.querySelectorAll(".checkIn")[index];
        const checkOutInput = document.querySelectorAll(".checkOut")[index];
        const subtotalSpan = document.querySelectorAll(".subtotal")[index];

        const price = parseFloat(quantityInput.dataset.price);
        const quantity = parseInt(quantityInput.value);
        const checkIn = checkInInput.value;
        const checkOut = checkOutInput.value;

        const days = calcDays(checkIn, checkOut);
        const subtotal = price * quantity * days;

        subtotalSpan.textContent = subtotal.toFixed(2);

        updateTotal(); // Cập nhật tổng luôn
    }

    function updateTotal() {
        const subtotals = document.querySelectorAll(".subtotal");
        let total = 0;
        subtotals.forEach(span => total += parseFloat(span.textContent));
        document.querySelector(".text-end .money").textContent = total.toFixed(2);
        document.querySelector("input[name='total']").value = total.toFixed(2);
        document.querySelector("input[name='depositAmount']").value = (total * 0.10).toFixed(2);
    }

    document.querySelectorAll(".quantity, .checkIn, .checkOut").forEach((input, i) => {
        input.addEventListener("change", () => {
            const index = input.closest("tr").querySelector("input[name='index']").value;
            updateSubtotal(index);
        });
    });
</script>

<script>
    document.querySelectorAll(".checkIn, .checkOut, .quantity").forEach(input => {
        input.addEventListener("change", async () => {
            const index = input.dataset.index;
            const row = input.closest("tr");

            const checkIn = row.querySelector(".checkIn").value;
            const checkOut = row.querySelector(".checkOut").value;
            if (new Date(checkOut) <= new Date(checkIn)) {
                alert("Ngày trả phòng phải sau ngày nhận phòng.");
                return;
            }
            const quantity = row.querySelector(".quantity").value;
            const price = parseFloat(row.querySelector(".quantity").dataset.price);
            const days = Math.max(1, Math.ceil((new Date(checkOut) - new Date(checkIn)) / (1000 * 60 * 60 * 24)));

            const subtotal = price * quantity * days;
            row.querySelector(".subtotal").textContent = subtotal.toFixed(2);

            // Cập nhật tổng cộng
            updateTotal();

            // Gửi dữ liệu AJAX đến Servlet
            try {
                const response = await fetch("updateCartServlet", {
                    method: "POST",
                    headers: { "Content-Type": "application/x-www-form-urlencoded" },
                    body: new URLSearchParams({
                        index,
                        checkIn,
                        checkOut,
                        quantity
                    })
                });

                if (!response.ok) {
                    alert("Cập nhật thất bại!");
                }
            } catch (error) {
                alert("Lỗi mạng khi cập nhật giỏ hàng!");
            }
        });
    });
</script>

<jsp:include page="Footer.jsp" />
</body>
</html>
