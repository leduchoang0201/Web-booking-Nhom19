<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.CartItem" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%
    List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems");
    Number totalValue = (Number) request.getAttribute("total");
    double total = totalValue != null ? totalValue.doubleValue() : 0.0;
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");

%>

<%
    NumberFormat currencyFormatter = NumberFormat.getInstance(new Locale("vi", "VN"));
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Giỏ hàng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="static/css/index.css">
</head>
<style>
    .money {
        white-space: nowrap;
        overflow: visible;
        text-overflow: unset;
        width: auto;
    }
</style>

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
            <td><span class="money price" data-price="<%= item.getRoom().getPrice() %>"><%= item.getRoom().getPrice() %></span>/đêm</td>
            <td>
                <input type="date" name="checkIn"  value="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(item.getCheckIn()) %>" class="form-control checkIn" data-index="<%= i %>" required>
            </td>
            <td>
                <input type="date" name="checkOut" value="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(item.getCheckOut()) %>" class="form-control checkOut" data-index="<%= i %>" required>
            </td>
            <td>
                <input type="number" name="quantity" value="<%= item.getQuantity() %>" min="1" max="<%= item.getRoom().getQuantity() %>" class="form-control quantity" data-index="<%= i %>" data-price="<%= item.getRoom().getPrice() %>" required>
            </td>
            <td>
                <span class="money subtotal"
                      data-subtotal="<%= item.getSubtotal() %>">
                      <%= item.getSubtotal() %> VNĐ
                </span>
            </td>

            <td>
                <a href="<%= request.getContextPath() %>/removeFromCart?index=<%= i %>" class="btn btn-danger btn-sm">Xoá</a>
            </td>
        </tr>

        <% } %>
        </tbody>
    </table>

    <h4 class="text-end">Tổng cộng: <span class="money"><%= currencyFormatter.format(total) %> VNĐ</span></h4>
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
                <form action="InvoiceServlet" method="post">
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
                            <input type="email" name="email" class="form-control" value="<%= customerEmail %>" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Số điện thoại</label>
                            <input type="text" name="phone" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Số tiền đặt cọc (10%)</label>
                            <input type="text" id="displayDeposit" class="form-control" value="<%= String.format("%.0f", deposit) %> VNĐ" readonly>
                            <input type="hidden" name="depositAmount" id="depositAmount" value="<%= deposit %>">
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
    function setMinCheckout(row) {
        const checkInInput = row.querySelector(".checkIn");
        const checkOutInput = row.querySelector(".checkOut");

        if (!checkInInput || !checkOutInput) return;

        const inDate = new Date(checkInInput.value);
        if (!isNaN(inDate)) {
            inDate.setDate(inDate.getDate() + 1);
            const minDateStr = inDate.toISOString().split("T")[0];
            checkOutInput.min = minDateStr;

            const currentOut = new Date(checkOutInput.value);
            if (isNaN(currentOut) || currentOut <= new Date(checkInInput.value)) {
                checkOutInput.value = minDateStr;
            }
        }
    }

    // Tính số ngày giữa check-in và check-out
    function calcDays(checkIn, checkOut) {
        const inDate = new Date(checkIn);
        const outDate = new Date(checkOut);
        const diff = Math.ceil((outDate - inDate) / (1000 * 60 * 60 * 24));
        return diff > 0 ? diff : 1;
    }

    // Cập nhật thành tiền và gửi yêu cầu cập nhật giỏ hàng
    async function handleCartChange(row, index) {
        const checkIn = row.querySelector(".checkIn").value;
        const checkOut = row.querySelector(".checkOut").value;
        const quantity = parseInt(row.querySelector(".quantity").value);
        const price = parseFloat(row.querySelector(".quantity").dataset.price);

        const days = calcDays(checkIn, checkOut);
        const subtotal = price * quantity * days;

        row.querySelector(".subtotal").textContent = subtotal.toLocaleString('vi-VN') + ' VNĐ';
        row.querySelector(".subtotal").dataset.subtotal = subtotal.toFixed(2);
        updateTotal();

        try {
            const response = await fetch("updateCartServlet", {
                method: "POST",
                headers: { "Content-Type": "application/x-www-form-urlencoded" },
                body: new URLSearchParams({ index, checkIn, checkOut, quantity })
            });

            if (!response.ok) {
                alert("Cập nhật thất bại!");
            }
        } catch (error) {
            alert("Lỗi khi cập nhật giỏ hàng!");
        }
    }
    function updateSubtotals() {
        document.querySelectorAll("tbody tr").forEach(row => {
            const checkIn = row.querySelector(".checkIn").value;
            const checkOut = row.querySelector(".checkOut").value;
            const quantity = parseInt(row.querySelector(".quantity").value);
            const price = parseFloat(row.querySelector(".quantity").dataset.price);

            const days = calcDays(checkIn, checkOut);
            const subtotal = price * quantity * days;

            row.querySelector(".subtotal").textContent = subtotal.toLocaleString('vi-VN') + ' VNĐ';
            row.querySelector(".subtotal").dataset.subtotal = subtotal.toFixed(2);
        });
    }
    function updateTotal() {
        const subtotals = document.querySelectorAll(".subtotal");
        let total = 0;
        subtotals.forEach(span => {
            const value = parseFloat(span.dataset.subtotal);
            if (!isNaN(value)) total += value;
        });

        document.querySelector(".text-end .money").textContent = total.toLocaleString('vi-VN') + ' VNĐ';
        document.querySelector("input[name='total']").value = total;
        document.getElementById("displayDeposit").value = (total * 0.10).toLocaleString('vi-VN') + ' VNĐ';
        document.getElementById("depositAmount").value = (total * 0.10).toFixed(2);

    }


    // Ràng buộc sự kiện khi DOM đã sẵn sàng
    document.addEventListener("DOMContentLoaded", () => {
        document.querySelectorAll("tbody tr").forEach(row => {
            const index = row.querySelector(".quantity").dataset.index;

            ["change", "input"].forEach(eventType => {
                row.querySelector(".checkIn").addEventListener(eventType, () => handleCartChange(row, index));
                row.querySelector(".checkOut").addEventListener(eventType, () => handleCartChange(row, index));
                row.querySelector(".quantity").addEventListener(eventType, () => handleCartChange(row, index));
            });

            // Xử lý min ngày checkout khi chọn checkin
            const checkInInput = row.querySelector(".checkIn");
            const checkOutInput = row.querySelector(".checkOut");
            const today = new Date().toISOString().split("T")[0];
            checkInInput.setAttribute("min", today);

            if (checkInInput && checkOutInput) {
                checkInInput.addEventListener("change", () => {
                    setMinCheckout(row);
                    handleCartChange(row, index);
                });
                setMinCheckout(row);


                if (checkInInput.value) {
                    const inDate = new Date(checkInInput.value);
                    inDate.setDate(inDate.getDate() + 1);
                    const minDate = inDate.toISOString().split("T")[0];
                    checkOutInput.setAttribute("min", minDate);
                }
            }
        });
        updateSubtotals()
        updateTotal();
    });
    const quantities = document.querySelectorAll("input.quantity");
    quantities.forEach(input => {
        input.addEventListener("input", () => {
            const max = parseInt(input.max);
            const val = parseInt(input.value);
            if (val > max) {
                alert("Bạn không thể đặt nhiều hơn số phòng còn lại.");
                input.value = max;
            }
        });
    });

</script>


<jsp:include page="Footer.jsp" />
</body>
</html>
