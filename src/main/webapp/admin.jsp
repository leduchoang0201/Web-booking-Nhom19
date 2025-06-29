<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="model.*"%>
<%@ page import="dao.*"%>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.TreeMap" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Quản lý phòng</title>
<!-- Thêm liên kết với Bootstrap để sử dụng Modal -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="static/css/admin.css">
<style>
	

</style>
</head>
<body>
<div class="d-flex justify-content-end align-items-center mb-3">
    <p class="me-3">Chào mừng admin</p>
    <a href="logout" class="btn btn-danger btn-sm">Đăng xuất</a>
</div>
<ul class="nav nav-tabs" id="adminTab" role="tablist">
    <li class="nav-item" role="presentation">
        <button class="nav-link active" id="rooms-tab" data-bs-toggle="tab" data-bs-target="#rooms" type="button" role="tab">Phòng</button>
    </li>
    <li class="nav-item" role="presentation">
        <button class="nav-link" id="users-tab" data-bs-toggle="tab" data-bs-target="#users" type="button" role="tab">Người dùng</button>
    </li>
    <li class="nav-item" role="presentation">
        <button class="nav-link" id="orders-tab" data-bs-toggle="tab" data-bs-target="#orders" type="button" role="tab">Đơn hàng</button>
    </li>
    <li class="nav-item" role="presentation">
        <button class="nav-link" id="revenue-tab" data-bs-toggle="tab" data-bs-target="#revenue" type="button" role="tab">Doanh thu</button>
    </li>

</ul>
<%
    String message = (String) session.getAttribute("message");
    if (message != null) {
%>
<div class="alert alert-success alert-dismissible fade show mt-3 mx-3" role="alert">
    <%= message %>
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
</div>
<%
        session.removeAttribute("message");
    }
%>

<div class="tab-content" id="adminTabContent">
    <!-- Room Management -->
    <div class="tab-pane fade show active" id="rooms" role="tabpanel">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h2>Danh sách phòng</h2>
            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addRoomModal">Thêm Phòng Mới</button>
        </div>

        <table class="table table-bordered table-striped">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Tên phòng</th>
                    <th>Loại</th>
                    <th>Giá</th>
                    <th>Số người</th>
                    <th>Số phòng</th>
                    <th>Có sẵn</th>
                    <th>Ảnh</th>
                    <th>Địa điểm</th>
                    <th>Hành Động</th>
                </tr>
            </thead>
            <tbody>
                <%
                List<Room> rooms = (List<Room>) request.getAttribute("rooms");
                if (rooms != null) {
                    for (Room room : rooms) {
                %>
                <tr>
                    <td><%= room.getId() %></td>
                    <td><%= room.getName() %></td>
                    <td><%= room.getType() %></td>
                    <td><%= room.getPrice() %></td>
                    <td><%= room.getCapacity() %></td>
                    <td><%= room.getQuantity() %></td>
                    <td><%= room.isAvailable() ? "Có" : "Không" %></td>
                    <td><%= room.getImage() %></td>
                    <td><%= room.getLocation() %></td>
                    <td>
                        <button class="btn btn-warning" data-bs-toggle="modal" data-bs-target="#updateRoomModal"
                        data-id="<%= room.getId() %>" data-name="<%= room.getName() %>" data-type="<%= room.getType() %>"
                        data-price="<%= room.getPrice() %>" data-capacity="<%= room.getCapacity() %>" data-image="<%= room.getImage() %>"
                        data-location="<%= room.getLocation() %>">Cập Nhật</button>
                        <form action="roomAdmin" method="POST" style="display:inline;">
                            <button type="submit" name="action" value="delete" class="btn btn-danger">Xóa</button>
                            <input type="hidden" name="roomId" value="<%= room.getId() %>" />
                        </form>
                    </td>
                </tr>
                <%
                }
                } else {
                %>
                <tr>
                    <td colspan="9" class="text-center">Không có phòng nào</td>
                </tr>
                <%
                }
                %>
            </tbody>
        </table>
    </div>
    <!-- Order Management -->
    <div class="tab-pane fade" id="orders" role="tabpanel">
        <h2 class="mt-3">Danh sách đơn hàng</h2>
        <table class="table table-bordered mt-3">
            <thead>
            <tr>
                <th>Order ID</th>
                <th>Người đặt</th>
                <th>Email</th>
                <th>Điện thoại</th>
                <th>Tổng tiền</th>
                <th>Ngày đặt phòng</th>
                <th>Chi tiết</th>
            </tr>
            </thead>
            <tbody>
            <%
                List<Order> orders = (List<Order>) request.getAttribute("orders");
                BookingDAO bookingDAO = new BookingDAO();
                RoomDAO roomDAO = new RoomDAO();
                if (orders != null) {
                    for (Order o : orders) {
            %>
            <tr>
                <td><%= o.getOrderId() %></td>
                <td><%= o.getCustomerName() %></td>
                <td><%= o.getCustomerEmail() %></td>
                <td><%= o.getCustomerPhone() %></td>
                <td><%= o.getTotalPrice() %> VNĐ</td>
                <td><%= new java.util.Date(o.getTimeStamp()) %></td>
                <td>
                    <button class="btn btn-sm btn-info" type="button" data-bs-toggle="collapse" data-bs-target="#orderDetails<%= o.getOrderId() %>">
                        Xem Booking
                    </button>
                </td>
            </tr>
            <tr class="collapse" id="orderDetails<%= o.getOrderId() %>">
                <td colspan="7">
                    <strong>Booking:</strong>
                    <table class="table table-sm table-bordered mt-2">
                        <thead>
                        <tr>
                            <th>Booking ID</th>
                            <th>ID phòng</th>
                            <th>Phòng</th>
                            <th>Check-in</th>
                            <th>Check-out</th>
                            <th>Số lượng</th>
                            <th>Trạng thái</th>
                            <th>Hành Động</th>
                        </tr>
                        </thead>
                        <tbody>
                        <%
                            List<Booking> bookings = bookingDAO.getByOrderId(o.getOrderId());
                            for (Booking b : bookings) {
                                Room r = roomDAO.getRoomById(b.getRoomId());
                        %>
                        <tr>
                            <td><%= b.getBookingId() %></td>
                            <td><%= r.getId() %></td>
                            <td><%= r != null ? r.getName() : "Phòng đã xoá" %></td>
                            <td><%= b.getCheckIn() %></td>
                            <td><%= b.getCheckOut() %></td>
                            <td><%= b.getQuantity() %></td>
                            <td><%= b.getStatus() %></td>
                            <td>
                                <button class="btn btn-warning" data-bs-toggle="modal" data-bs-target="#updateBookingModal"
                                        data-id="<%= b.getBookingId() %>"
                                        data-check-out="<%= b.getCheckOut() %>"
                                        data-status="<%= b.getStatus() %>">Cập Nhật</button>

                                <form action="bookingAdmin" method="POST" style="display:inline;">
                                    <button type="submit" name="action" value="delete" class="btn btn-danger">Xóa</button>
                                    <input type="hidden" name="bookingId" value="<%= b.getBookingId() %>" />
                                </form>
                            </td>
                        </tr>
                        <% } %>
                        </tbody>
                    </table>
                </td>
            </tr>
            <%
                }
            } else {
            %>
            <tr><td colspan="7" class="text-center">Không có đơn hàng nào</td></tr>
            <%
                }
            %>
            </tbody>
        </table>
    </div>


    <!-- User Management -->
    <div class="tab-pane fade" id="users" role="tabpanel">
        <h2 class="mt-3">Danh sách người dùng</h2>
        <table class="table table-bordered table-striped">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Tên người dùng</th>
                    <th>Email</th>
                    <th>Ngày tạo</th>
                    <th>Hành Động</th>
                </tr>
            </thead>
            <tbody>
                <%
                List<User> users = (List<User>) request.getAttribute("users");
                if (users != null) {
                    for (User user : users) {
                %>
                <tr>
                    <td><%= user.getId() %></td>
                    <td><%= user.getName() %></td>
                    <td><%= user.getEmail() %></td>
                    <td><%=user.getCreatedAt()%></td>
                    <td>
                        <button class="btn btn-warning" data-bs-toggle="modal" data-bs-target="#updateUserModal"
                                data-id="<%=user.getId()%>"
                                data-name="<%=user.getName()%>"
                                data-email="<%=user.getEmail()%>"
                                data-created-at="<%= user.getCreatedAt() %>">Cập Nhật</button>

                        <form action="userAdmin" method="POST" style="display:inline;">
                            <button type="submit" name="action" value="delete" class="btn btn-danger">Xóa</button>
                            <input type="hidden" name="userId" value="<%= user.getId() %>" />
                        </form>
                    </td>
                </tr>
                <%
                    }
                } else {
                %>
                <tr>
                    <td colspan="6" class="text-center">Không có người dùng nào</td>
                </tr>
                <%
                }
                %>
            </tbody>
        </table>
    </div>
    <!-- Revenue Management -->
    <div class="tab-pane fade" id="revenue" role="tabpanel">
        <%
            orders = (List<Order>) request.getAttribute("orders");
            bookingDAO = new BookingDAO();
            UserDAO userDAO = new UserDAO();

            double totalRevenue = 0;
            int totalBookings = 0;

            Map<Integer, Integer> bookingCountByUser = new HashMap<>();
            Map<String, Double> revenueByMonth = new TreeMap<>();

            if (orders != null) {
                for (Order order : orders) {
                    totalRevenue += order.getTotalPrice();

                    List<Booking> bookings = bookingDAO.getByOrderId(order.getOrderId());
                    totalBookings += bookings.size();

                    // Đếm số lần đặt theo user
                    int userId = order.getUserId();
                    bookingCountByUser.put(userId, bookingCountByUser.getOrDefault(userId, 0) + bookings.size());

                    // Tính doanh thu theo tháng
                    java.util.Date orderDate = new java.util.Date(order.getTimeStamp());
                    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("MM/yyyy");
                    String monthKey = sdf.format(orderDate);

                    revenueByMonth.put(monthKey, revenueByMonth.getOrDefault(monthKey, 0.0) + order.getTotalPrice());
                }
            }

            // Người đặt nhiều nhất
            int topUserId = -1;
            int maxBookings = 0;
            for (Map.Entry<Integer, Integer> entry : bookingCountByUser.entrySet()) {
                if (entry.getValue() > maxBookings) {
                    maxBookings = entry.getValue();
                    topUserId = entry.getKey();
                }
            }
            User topUser = (topUserId != -1) ? userDAO.getUserById(topUserId) : null;
        %>

        <div class="my-3">
            <h2>Thống kê doanh thu</h2>
        </div>

        <div class="row mt-4">
            <div class="col-md-4">
                <div class="card text-white bg-primary mb-3">
                    <div class="card-body">
                        <h5 class="card-title">Tổng doanh thu</h5>
                        <p class="card-text fs-4"><%= String.format("%,.0f", totalRevenue) %> VNĐ</p>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card text-white bg-success mb-3">
                    <div class="card-body">
                        <h5 class="card-title">Tổng lượt đặt</h5>
                        <p class="card-text fs-4"><%= totalBookings %> lượt</p>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card text-white bg-info mb-3">
                    <div class="card-body">
                        <h5 class="card-title">Người đặt nhiều nhất</h5>
                        <p class="card-text fs-6">
                            <% if (topUser != null) { %>
                            <strong><%= topUser.getName() %> -  <%=topUser.getEmail()%> </strong><br/>

                            <%= maxBookings %> lượt đặt
                            <% } else { %>
                            Không có dữ liệu
                            <% } %>
                        </p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bảng doanh thu theo tháng -->
        <h4 class="mt-4">Doanh thu theo tháng</h4>
        <table class="table table-bordered table-hover">
            <thead class="table-primary">
            <tr>
                <th>Tháng</th>
                <th>Doanh thu (VNĐ)</th>
            </tr>
            </thead>
            <tbody>
            <% for (Map.Entry<String, Double> entry : revenueByMonth.entrySet()) { %>
            <tr>
                <td><%= entry.getKey() %></td>
                <td><%= String.format("%,.0f", entry.getValue()) %></td>
            </tr>
            <% } %>
            </tbody>
        </table>
    </div>

    <!-- Modal Thêm Phòng -->
<div class="modal fade" id="addRoomModal" tabindex="-1" aria-labelledby="addRoomModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="addRoomModalLabel">Thêm Phòng Mới</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form action="roomAdmin" method="POST" accept-charset="UTF-8">
                    <div class="mb-3">
                        <label for="roomId" class="form-label">ID phòng</label>
                        <input type="number" class="form-control" id="roomId" name="roomId" required>
                    </div>
                    <div class="mb-3">
                        <label for="roomName" class="form-label">Tên phòng</label>
                        <input type="text" class="form-control" id="roomName" name="roomName" required>
                    </div>
                    <div class="mb-3">
                        <label for="roomType" class="form-label">Loại phòng</label>
                        <input type="text" class="form-control" id="roomType" name="roomType" required>
                    </div>
                    <div class="mb-3">
                        <label for="roomPrice" class="form-label">Giá phòng</label>
                        <input type="number" class="form-control" id="roomPrice" name="roomPrice" required>
                    </div>
                    <div class="mb-3">
                        <label for="roomCapacity" class="form-label">Số lượng</label>
                        <input type="number" class="form-control" id="roomCapacity" name="roomCapacity" required>
                    </div>
                    <div class="mb-3">
                        <label for="roomImage" class="form-label">Ảnh phòng</label>
                        <input type="text" class="form-control" id="roomImage" name="roomImage" required>
                    </div>
                    <div class="mb-3">
                        <label for="roomLocation" class="form-label">Địa điểm</label>
                        <input type="text" class="form-control" id="roomLocation" name="roomLocation" required>
                    </div>
                    <button type="submit" class="btn btn-primary" name="action" value="insert">Xác nhận thêm phòng</button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Modal Cập Nhật Phòng -->
<div class="modal fade" id="updateRoomModal" tabindex="-1" aria-labelledby="updateRoomModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="updateRoomModalLabel">Cập Nhật Phòng</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form action="roomAdmin" method="POST">
                    <input type="hidden" id="updateRoomId" name="roomId">
                    <div class="mb-3">
                        <label for="updateRoomName" class="form-label">Tên phòng</label>
                        <input type="text" class="form-control" id="updateRoomName" name="roomName" required>
                    </div>
                    <div class="mb-3">
                        <label for="updateRoomType" class="form-label">Loại phòng</label>
                        <input type="text" class="form-control" id="updateRoomType" name="roomType" required>
                    </div>
                    <div class="mb-3">
                        <label for="updateRoomPrice" class="form-label">Giá phòng</label>
                        <input type="number" class="form-control" id="updateRoomPrice" name="roomPrice" required>
                    </div>
                    <div class="mb-3">
                        <label for="updateRoomCapacity" class="form-label">Số lượng</label>
                        <input type="number" class="form-control" id="updateRoomCapacity" name="roomCapacity" required>
                    </div>
                    <div class="mb-3">
                        <label for="updateRoomImage" class="form-label">Ảnh phòng</label>
                        <input type="text" class="form-control" id="updateRoomImage" name="roomImage" required>
                    </div>
                    <div class="mb-3">
                        <label for="updateRoomLocation" class="form-label">Địa điểm</label>
                        <input type="text" class="form-control" id="updateRoomLocation" name="roomLocation" required>
                    </div>
                    <button type="submit" class="btn btn-primary" name="action" value="update">Cập nhật phòng</button>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>

<script>
var updateRoomModal = document.getElementById('updateRoomModal');
updateRoomModal.addEventListener('show.bs.modal', function(event) {
    var button = event.relatedTarget;
    var roomId = button.getAttribute('data-id');
    var roomName = button.getAttribute('data-name');
    var roomType = button.getAttribute('data-type');
    var roomPrice = button.getAttribute('data-price');
    var roomCapacity = button.getAttribute('data-capacity');
    var roomImage = button.getAttribute('data-image');
    var roomLocation = button.getAttribute('data-location');

    document.getElementById('updateRoomId').value = roomId;
    document.getElementById('updateRoomName').value = roomName;
    document.getElementById('updateRoomType').value = roomType;
    document.getElementById('updateRoomPrice').value = roomPrice;
    document.getElementById('updateRoomCapacity').value = roomCapacity;
    document.getElementById('updateRoomImage').value = roomImage;
    document.getElementById('updateRoomLocation').value = roomLocation;
});
</script>
<!-- Modal Cập Nhật Lịch Đặt -->
<div class="modal fade" id="updateBookingModal" tabindex="-1" aria-labelledby="updateBookingModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="updateBookingModalLabel">Cập Nhật Lịch Đặt</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form action="bookingAdmin" method="POST">
                    <input type="hidden" id="updateBookingId" name="bookingId">
                    <div class="mb-3">
                        <label for="updateBookingCheckOut" class="form-label">Ngày đi</label>
                        <input type="date" class="form-control" id="updateBookingCheckOut" name="checkoutDate" required>
                    </div>
                    <div class="mb-3">
                        <label for="updateBookingStatus" class="form-label">Trạng thái</label>
                        <select class="form-control" id="updateBookingStatus" name="status" required>
                            <option value="confirmed">Confirmed</option>
                            <option value="cancelled">Cancelled</option>
                            <option value="checked_out">Checked out</option>
                        </select>
                    </div>
                    <button type="submit" class="btn btn-primary" name="action" value="update">Cập nhật lịch đặt</button>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
var updateBookingModal = document.getElementById('updateBookingModal');
updateBookingModal.addEventListener('show.bs.modal', function(event) {
    var button = event.relatedTarget;
    var bookingId = button.getAttribute('data-id');
    var checkOut = button.getAttribute('data-check-out');
    var status = button.getAttribute('data-status');

    document.getElementById('updateBookingId').value = bookingId;
    document.getElementById('updateBookingCheckOut').value = checkOut;
    document.getElementById('updateBookingStatus').value = status;
});
</script>
<!-- Modal Cập Nhật Người Dùng -->
<div class="modal fade" id="updateUserModal" tabindex="-1" aria-labelledby="updateUserModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="updateUserModalLabel">Cập Nhật Người Dùng</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form action="userAdmin" method="POST">
                    <input type="hidden" id="updateUserId" name="userId">
                    <div class="mb-3">
                        <label for="updateUserName" class="form-label">Tên người dùng</label>
                        <input type="text" class="form-control" id="updateUserName" name="name" required>
                    </div>
                    <div class="mb-3">
                        <label for="updateUserEmail" class="form-label">Email</label>
                        <input type="email" class="form-control" id="updateUserEmail" name="email" required>
                    </div>
                    <button type="submit" class="btn btn-primary" name="action" value="update">Cập nhật người dùng</button>
                </form>
            </div>
        </div>
    </div>
</div>
<script>
var updateUserModal = document.getElementById('updateUserModal');
updateUserModal.addEventListener('show.bs.modal', function(event) {
    var button = event.relatedTarget;
    var userId = button.getAttribute('data-id');
    var userName = button.getAttribute('data-name');
    var userEmail = button.getAttribute('data-email');

    document.getElementById('updateUserId').value = userId;
    document.getElementById('updateUserName').value = userName;
    document.getElementById('updateUserEmail').value = userEmail;
});
</script>
</div>
</body>
</html>
