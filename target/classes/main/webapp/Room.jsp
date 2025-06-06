<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="model.Room"%>
<%@ page import="model.User"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Danh sách phòng</title>
</head>
<style>
		.content {
    padding-top: 150px;
}
		
        .mass {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 20px;
            margin: 0 auto;
            max-width: 1200px;
        }
        .card {
            flex: 1 1 calc(33.333% - 20px);
            max-width: calc(33.333% - 20px);
            box-sizing: border-box;
            border: 1px solid #ddd;
            border-radius: 5px;
            overflow: hidden;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            background-color: #fff;
            text-align: center;
        }
        .card img {
            width: 100%;
            height: 200px;
            object-fit: cover;
        }
        .card-body {
            padding: 15px;
        }
        .card h3 {
            margin: 10px 0;
            font-size: 1.2em;
            color: #007BFF;
        }
        .card p {
            margin: 5px 0;
            color: #555;
        }
        .book-now {
            background-color: #007BFF;
            color: #fff;
            padding: 10px 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin-top: 10px;
        }
        .book-now:disabled {
            background-color: #ccc;
            cursor: not-allowed;
        }
        .pagination {
            display: flex;
            justify-content: center;
            list-style: none;
            padding: 0;
            margin: 20px 0;
        }
        .pagination li {
            margin: 0 5px;
        }
        .pagination a {
            display: block;
            padding: 5px 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            text-decoration: none;
            color: #007BFF;
        }
        .pagination .disabled a {
            color: #ccc;
            pointer-events: none;
        }
        .pagination .active a {
            background-color: #007BFF;
            color: #fff;
        }
    </style>
 <jsp:include page="Header.jsp" />
 
    <div class="content">
        <h1>Danh sách phòng</h1>
        <nav>
		<button onclick="location.href='Category?location=Phú Quốc'">Phú Quốc</button>
	    <button onclick="location.href='Category?location=Nha Trang'">Nha Trang</button>
	    <button onclick="location.href='Category?location=Nam Hội An'">Nam Hội An</button>
	    <button onclick="location.href='Category?location=Hạ Long'">Hạ Long</button>
	        <button onclick="location.href='rooms'">Tất Cả</button>
	</nav>
        <% 
		    User user = (User) session.getAttribute("User"); 
		%>
<div class="mass">
    <div class="row">
        <% 
            List<Room> rooms = (List<Room>) request.getAttribute("rooms");
            if (rooms != null) {
                for (Room room : rooms) {
        %>
        <div class="card">
            <img src="<%= request.getContextPath() %>/static/images/<%= room.getImage() %>" 
                 alt="<%= room.getName() %>">
            <div class="card-body">
                <h3><%= room.getName() %></h3>
                <p><%= room.getPrice() %> VNĐ mỗi đêm</p>
                <p>Cơ sở: <%= room.getLocation() %></p>
                <p>Còn phòng: 
                    <% if (room.isAvailable()) { %>
                        <span style="color: green;">Có</span>
                    <% } else { %>
                        <span style="color: red;">Không</span>
                    <% } %>
                </p>
                <p>Khách hàng: <%= room.getCapacity() %></p>

                <% if (room.isAvailable()) { %>
                    <% if (user != null) { %>
                        <!-- Người dùng đã đăng nhập -->
                        <button class="book-now" data-bs-toggle="modal"
                        data-bs-target="#bookingModal"
                        data-room-id="<%= room.getId() %>"
                        data-room-name="<%= room.getName() %>"
                        data-room-price="<%= room.getPrice() %>"
                        data-user-id="<%= user.getId() %>">Đặt Ngay</button>
                    <% } else { %>
                        <!-- Người dùng chưa đăng nhập -->
                        <button class="book-now" onclick="location.href='<%= request.getContextPath() %>/login.jsp'">
                            Đăng nhập để đặt phòng
                        </button>
                    <% } %>
                <% } else { %>
                    <button class="book-now" disabled>Phòng đã được đặt</button>
                <% } %>
            </div>
        </div>
        <% 
                }
            } else { 
        %>
        <p>Không có phòng nào được tìm thấy.</p>
        <% 
            } 
        %>
    	</div>
	</div>


        <div class="modal fade" id="bookingModal" tabindex="-1" aria-labelledby="bookingModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="bookingModalLabel">Thanh Toán Đặt Phòng</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <h2>${message}</h2> <!-- Thông báo lỗi nếu có -->
                        <form id="paymentForm" action=PaymentServlet method="POST">
                            <input type="hidden" id="roomId" name="roomId">
                            <input type="hidden" id="roomName" name="roomName">
                            <input type="hidden" id="roomPrice" name="roomPrice">
                            <input type="hidden" id="userId" name="userId">

                            <div class="mb-3">
                                <label for="customerName" class="form-label">Họ và Tên</label>
                                <input type="text" class="form-control" id="customerName" name="customerName" required>
                            </div>
                            <div class="mb-3">
                                <label for="checkinDate" class="form-label">Ngày Nhận Phòng</label>
                                <input type="date" class="form-control" id="checkinDate" name="checkinDate" required>
                            </div>
                            <div class="mb-3">
                                <label for="checkoutDate" class="form-label">Ngày Trả Phòng</label>
                                <input type="date" class="form-control" id="checkoutDate" name="checkoutDate" required>
                            </div>
                            <div class="mb-3">
                                <label for="totalPrice" class="form-label">Tổng Số Tiền (VNĐ)</label>
                                <input type="text" class="form-control" id="totalPrice" name="totalPrice" readonly>
                            </div>
                            <button type="submit" class="btn btn-primary">Thanh Toán</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script>
    const bookingButtons = document.querySelectorAll('.book-now');
    bookingButtons.forEach(button => {
        button.addEventListener('click', (e) => {
            const roomId = e.target.getAttribute('data-room-id');
            const roomName = e.target.getAttribute('data-room-name');
            const roomPrice = parseFloat(e.target.getAttribute('data-room-price'));
            const userId = e.target.getAttribute('data-user-id');

            document.getElementById('roomId').value = roomId;
            document.getElementById('roomName').value = roomName;
            document.getElementById('roomPrice').value = roomPrice;
            document.getElementById('userId').value = userId;
            document.getElementById('totalPrice').value = roomPrice;

            // Mở modal
            if (!modalElement.classList.contains('show')) {
	            modal.show();
	        }
            modalElement.addEventListener('hidden.bs.modal', function () {
                document.body.style.overflow = 'auto';
            });
        });
    });
    const checkinDateInput = document.getElementById('checkinDate');
    const checkoutDateInput = document.getElementById('checkoutDate');

    // Hàm để cập nhật ngày trả phòng tối thiểu
    checkinDateInput.addEventListener('change', function () {
        const checkinDate = new Date(checkinDateInput.value);
        
        // Thêm 1 ngày vào ngày nhận phòng để làm ngày trả phòng tối thiểu
        checkinDate.setDate(checkinDate.getDate() + 1);

        // Cập nhật giá trị ngày trả phòng tối thiểu
        const minCheckoutDate = checkinDate.toISOString().split('T')[0]; // Định dạng YYYY-MM-DD
        checkoutDateInput.setAttribute('min', minCheckoutDate);
        
        // Nếu ngày trả phòng đã được chọn trước đó, kiểm tra xem nó có hợp lệ không
        if (new Date(checkoutDateInput.value) < checkinDate) {
            checkoutDateInput.value = minCheckoutDate;
        }
    });
    
    </script>
    <jsp:include page="Footer.jsp" />
</body>
</html>
