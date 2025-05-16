<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Phú Quốc</title>
</head>
<body>
	<jsp:include page="Header.jsp" />
<div class="search-bar">
		<div>
			<span class="icon">📍</span> <input type="text"
				placeholder="Chọn điểm đến, khách sạn theo sở thích ...">
		</div>
		<div>
			<span class="icon">📅</span> <input
				style="width: 100%; font-size: 14px; border-radius: 5px; padding: 8px;"
				type="date" value="2024-11-28">
		</div>
		<div>
			<span class="icon">👤</span> <select>
				<option>1 Phòng - 1 Người</option>
				<option>2 Phòng - 2 Người</option>
				<option>3 Phòng - 4 Người</option>
			</select>
		</div>
		<div>
			<span class="icon">🎫</span> <input type="text"
				placeholder="Mã ưu đãi">
		</div>
		<button class="btn-search">Tìm kiếm</button>
	</div>
	<header>
		<h1>Khám phá khách sạn Vinpearl</h1>
	</header>
	<nav>
		<a href="PhuQuoc.jsp"><button>Phú Quốc</button></a>
		<a href="home.jsp">	<button >Nha Trang</button></a>
		<a href="Namhoi.jsp"><button>Nam Hội An</button></a>
		<a href="HaLong.jsp">  <button>Hạ Long</button></a>
	</nav>
	<main>
		<section class="hotel">
			<img src="static/images/pq1.jpg" alt="VinHolidays Fiesta Phú Quốc">
			<div class="info">
				<h2>VinHolidays Fiesta Phú Quốc</h2>
				<p>Khu Bãi Dài, Xã Gành Dầu, Thành phố Phú Quốc, Tỉnh Kiên Giang</p>
				<p>
					<strong>Số điện thoại:</strong> (+84) 297 3550 550
				</p>
				<p>
					<strong>Đánh giá:</strong> <span class="rating">4.5</span> <span
						class="stars">★★★★★</span>
				</p>
				<p class="price">
					Giá Chỉ Từ: <span>990,000 VNĐ </span> /Đêm
				</p>
				<button class="book-now" data-bs-toggle="modal" data-bs-target="#bookingModal">Đặt Ngay</button>
			</div>
		</section>
		<section class="hotel">
			<img src="static/images/pq2.jpg"
				alt="Vinpearl Wonderworld Phú Quốc">
			<div class="info">
				<h2>Vinpearl Wonderworld Phú Quốc</h2>
				<p>Khu Bãi Dài, xã Gành Dầu, thành phố Phú Quốc, tỉnh Kiên Giang</p>
				<p>
					<strong>Số điện thoại:</strong> (+84) 297 3550 550
				</p>
				<p>
					<strong>Đánh giá:</strong> <span class="rating">4.7</span> <span
						class="stars">★★★★★</span>
				</p>
				<p class="price">
					Giá Chỉ Từ: <span>11,765,250 VNĐ</span> /Đêm
				</p>
			<button class="book-now" data-bs-toggle="modal" data-bs-target="#bookingModal">Đặt Ngay</button>
			</div>
		</section>
		<section class="hotel">
			<img src="static/images/pq3.jpg" alt="Vinpearl Resort & Spa Phú Quốc">
			<div class="info">
				<h2>Vinpearl Resort & Spa Phú Quốc</h2>
				<p>Khu Bãi Dài, Xã Gành Dầu, Thành Phố Phú Quốc, Tỉnh Kiên Giang</p>
				<p>
					<strong>Số điện thoại:</strong> (+84) 297 3550 550
				</p>
				<p>
					<strong>Đánh giá:</strong> <span class="rating">4.7</span> <span
						class="stars">★★★★★</span>
				</p>
				<p class="price">
					Giá Chỉ Từ: <span>3,100,000 VNĐ</span> /Đêm
				</p>
			<button class="book-now" data-bs-toggle="modal" data-bs-target="#bookingModal">Đặt Ngay</button>
			</div>
		</section>
		
	</main>
	<!-- Modal Đặt Phòng -->
<div class="modal fade" id="bookingModal" tabindex="-1" aria-labelledby="bookingModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="bookingModalLabel">Đặt Phòng</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form>
                    <div class="mb-3">
                        <label for="customerName" class="form-label">Họ và Tên</label>
                        <input type="text" class="form-control" id="customerName" required>
                    </div>
                    <div class="mb-3">
                        <label for="checkinDate" class="form-label">Ngày Nhận Phòng</label>
                        <input type="date" class="form-control" id="checkinDate" required>
                    </div>
                    <div class="mb-3">
                        <label for="checkoutDate" class="form-label">Ngày Trả Phòng</label>
                        <input type="date" class="form-control" id="checkoutDate" required>
                    </div>
                    <div class="mb-3">
                        <label for="roomCount" class="form-label">Số Phòng</label>
                        <select id="roomCount" class="form-select">
                            <option value="1">1 Phòng</option>
                            <option value="2">2 Phòng</option>
                            <option value="3">3 Phòng</option>
                        </select>
                    </div>
                    <button type="submit" class="btn btn-primary">Xác Nhận Đặt Phòng</button>
                </form>
            </div>
        </div>
    </div>
</div>
	<jsp:include page="Footer.jsp" />
</body>
</html>