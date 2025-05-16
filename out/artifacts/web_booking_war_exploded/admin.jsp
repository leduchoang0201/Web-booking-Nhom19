<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="model.*"%>
<%@ page import="dao.*"%>
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

<!-- Room Management -->
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
            <th>Số lượng</th>
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

<!-- Booking Management -->
<div class="d-flex justify-content-between align-items-center mb-3">
    <h2>Danh sách lịch đặt</h2>
    <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#addBookingModal">Thêm Lịch Đặt Mới</button>
</div>

<table class="table table-bordered table-striped">
    <thead>
        <tr>
            <th>ID</th>
            <th>ID người đặt</th>
            <th>ID phòng</th>
            <th>Ngày nhận phòng</th>
            <th>Ngày đi</th>
            <th>Trạng thái</th>
            <th>Đặt vào ngày</th>
            <th>Hành Động</th>
        </tr>
    </thead>
    <tbody>
        <% 
        List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
        if (bookings != null) {
            for (Booking booking : bookings) {
        %>
        <tr>
            <td><%= booking.getBookingId() %></td>
            <td><%= booking.getUserId() %></td>
            <td><%= booking.getRoomId() %></td>
            <td><%= booking.getCheckIn() %></td>
            <td><%= booking.getCheckOut() %></td>
            <td><%= booking.getStatus() %></td>
            <td><%= booking.getCreatedAt() %></td>
            <td>
                <button class="btn btn-warning" data-bs-toggle="modal" data-bs-target="#updateBookingModal" 
			    data-id="<%= booking.getBookingId() %>" 
			    data-user-id="<%= booking.getUserId() %>" 
			    data-room-id="<%= booking.getRoomId() %>" 
			    data-check-in="<%= booking.getCheckIn() %>" 
			    data-check-out="<%= booking.getCheckOut() %>" 
			    data-status="<%= booking.getStatus() %>">Cập Nhật</button>

                <form action="bookingAdmin" method="POST" style="display:inline;">
                    <button type="submit" name="action" value="delete" class="btn btn-danger">Xóa</button>
                    <input type="hidden" name="bookingId" value="<%= booking.getBookingId() %>" />
                </form>
            </td>
        </tr>
        <%
        }
        } else {
        %>
        <tr>
            <td colspan="8" class="text-center">Không có lịch đặt nào</td>
        </tr>
        <%
        }
        %>
    </tbody>
</table>

<!-- User Management -->
<div class="d-flex justify-content-between align-items-center mb-3">
    <h2>Danh sách người dùng</h2>
    <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#addUserModal">Thêm Người Dùng Mới</button>
</div>

<table class="table table-bordered table-striped">
    <thead>
        <tr>
            <th>ID</th>
            <th>Tên người dùng</th>
            <th>Email</th>
            <th>Mật khẩu</th>
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
            <td><%=user.getPassword()%></td>
            <td><%=user.getCreatedAt()%></td>
            <td>
                <button class="btn btn-warning" data-bs-toggle="modal" data-bs-target="#updateUserModal" 
                        data-id="<%=user.getId()%>" 
                        data-name="<%=user.getName()%>" 
                        data-email="<%=user.getEmail()%>" 
                        data-password="<%=user.getPassword()%>" 
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

<!-- Modal Thêm Lịch Đặt -->
<div class="modal fade" id="addBookingModal" tabindex="-1" aria-labelledby="addBookingModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="addBookingModalLabel">Thêm Lịch Đặt Mới</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form action="bookingAdmin" method="POST" accept-charset="UTF-8">
                    <div class="mb-3">
                        <label for="bookingUserId" class="form-label">ID người đặt</label>
                        <input type="number" class="form-control" id="bookingUserId" name="userId" required>
                    </div>
                    <div class="mb-3">
                        <label for="bookingRoomId" class="form-label">ID phòng</label>
                        <input type="number" class="form-control" id="bookingRoomId" name="roomId" required>
                    </div>
                    <div class="mb-3">
                        <label for="bookingCheckIn" class="form-label">Ngày nhận phòng</label>
                        <input type="date" class="form-control" id="bookingCheckIn" name="checkinDate" required>
                    </div>
                    <div class="mb-3">
                        <label for="bookingCheckOut" class="form-label">Ngày đi</label>
                        <input type="date" class="form-control" id="bookingCheckOut" name="checkoutDate" required>
                    </div>
                    <button type="submit" class="btn btn-primary" name="action" value="insert">Xác nhận thêm lịch đặt</button>
                </form>
            </div>
        </div>
    </div>
</div>

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
                        <label for="updateBookingUserId" class="form-label">ID người đặt</label>
                        <input type="number" class="form-control" id="updateBookingUserId" name="userId" required>
                    </div>
                    <div class="mb-3">
                        <label for="updateBookingRoomId" class="form-label">ID phòng</label>
                        <input type="number" class="form-control" id="updateBookingRoomId" name="roomId" required>
                    </div>
                    <div class="mb-3">
                        <label for="updateBookingCheckIn" class="form-label">Ngày nhận phòng</label>
                        <input type="date" class="form-control" id="updateBookingCheckIn" name="checkinDate" required>
                    </div>
                    <div class="mb-3">
                        <label for="updateBookingCheckOut" class="form-label">Ngày đi</label>
                        <input type="date" class="form-control" id="updateBookingCheckOut" name="checkoutDate" required>
                    </div>
                    <div class="mb-3">
                        <label for="updateBookingStatus" class="form-label">Trạng thái</label>
                        <select class="form-control" id="updateBookingStatus" name="status" required>
                            <option value="Pending">Pending</option>
                            <option value="Confirmed">Confirmed</option>
                            <option value="Cancelled">Cancelled</option>
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
    var userId = button.getAttribute('data-user-id');
    var roomId = button.getAttribute('data-room-id');
    var checkIn = button.getAttribute('data-check-in');
    var checkOut = button.getAttribute('data-check-out');
    var status = button.getAttribute('data-status');

    document.getElementById('updateBookingId').value = bookingId;
    document.getElementById('updateBookingUserId').value = userId;
    document.getElementById('updateBookingRoomId').value = roomId;
    document.getElementById('updateBookingCheckIn').value = checkIn;
    document.getElementById('updateBookingCheckOut').value = checkOut;
    document.getElementById('updateBookingStatus').value = status;
});
</script>
<!-- Modal Thêm Người Dùng -->
<div class="modal fade" id="addUserModal" tabindex="-1" aria-labelledby="addUserModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="addUserModalLabel">Thêm Người Dùng Mới</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form action="userAdmin" method="POST" accept-charset="UTF-8">
                    <div class="mb-3">
                        <label for="userName" class="form-label">Tên người dùng</label>
                        <input type="text" class="form-control" id="userName" name="name" required>
                    </div>
                    <div class="mb-3">
                        <label for="userEmail" class="form-label">Email</label>
                        <input type="email" class="form-control" id="userEmail" name="email" required>
                    </div>
                    <div class="mb-3">
                        <label for="userPassword" class="form-label">Mật khẩu</label>
                        <input type="password" class="form-control" id="userPassword" name="password" required>
                    </div>
                    <button type="submit" class="btn btn-primary" name="action" value="insert">Thêm người dùng</button>
                </form>
            </div>
        </div>
    </div>
</div>
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
                    <div class="mb-3">
                        <label for="updateUserPassword" class="form-label">Mật khẩu</label>
                        <input type="password" class="form-control" id="updateUserPassword" name="password" required>
                    </div>
                    <div class="mb-3">
                        <label for="updateUserCreatedAt" class="form-label">Ngày tạo</label>
                        <input type="text" class="form-control" id="updateUserCreatedAt" name="createdAt" readonly>
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
    var userPassword = button.getAttribute('data-password');
    var userCreatedAt = button.getAttribute('data-created-at');

    document.getElementById('updateUserId').value = userId;
    document.getElementById('updateUserName').value = userName;
    document.getElementById('updateUserEmail').value = userEmail;
    document.getElementById('updateUserPassword').value = userPassword;
    document.getElementById('updateUserCreatedAt').value = userCreatedAt;
});
</script>

</body>
</html>
