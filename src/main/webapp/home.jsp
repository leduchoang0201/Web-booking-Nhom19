<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>HOTELBOOKING</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<link rel="stylesheet" href="static/css/index.css">
<link rel="stylesheet"
	href="lib/bootstrap-5.0.2-dist/css/bootstrap.min.css">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css"
	rel="stylesheet">
</head>
<body>
<jsp:include page="Header.jsp" />
	<div id="demo" class="carousel slide" data-bs-ride="carousel"
		style="padding-top: 80px">

		<!-- Indicators/dots -->
		<div class="carousel-indicators">
			<button type="button" data-bs-target="#demo" data-bs-slide-to="0"
				class="active"></button>
			<button type="button" data-bs-target="#demo" data-bs-slide-to="1"></button>
			<button type="button" data-bs-target="#demo" data-bs-slide-to="2"></button>
		</div>

		<!-- The slideshow/carousel -->
		<div class="carousel-inner">
			<div class="carousel-item active">
				<img src="static/images/abc.jpg" alt="Los Angeles" class="d-block"
					style="width: 100%">
			</div>
			<div class="carousel-item">
				<img src="static/images/nen1.jpg" alt="Chicago" class="d-block"
					style="width: 100%">
			</div>
			<div class="carousel-item">
				<img src="static/images/nen2.jpg" alt="New York" class="d-block"
					style="width: 100%">
			</div>
		</div>

		<!-- Left and right controls/icons -->
		<button class="carousel-control-prev" type="button"
			data-bs-target="#demo" data-bs-slide="prev">
			<span class="carousel-control-prev-icon"></span>
		</button>
		<button class="carousel-control-next" type="button"
			data-bs-target="#demo" data-bs-slide="next">
			<span class="carousel-control-next-icon"></span>
		</button>
	</div>
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
		<button onclick="location.href='Category?location=Phú Quốc'">Phú Quốc</button>
	    <button onclick="location.href='Category?location=Nha Trang'">Nha Trang</button>
	    <button onclick="location.href='Category?location=Nam Hội'">Nam Hội An</button>
	    <button onclick="location.href='Category?location=HạLong'">Hạ Long</button>
	</nav>
	<main>
		<section class="hotel">
			<img src="static/images/resort1.jpg" alt="Vinpearl Beachfront Nha Trang">
			<div class="info">
				<h2>Vinpearl Beachfront Nha Trang</h2>
				<p>78 - 80 Đ. Trần Phú, P.Lộc Thọ, TP.Nha Trang, Khánh Hòa</p>
				<p>
					<strong>Số điện thoại:</strong> (+84) 297 3550 550
				</p>
				<p>
					<strong>Đánh giá:</strong> <span class="rating">4.5</span> <span
						class="stars">★★★★★</span>
				</p>
				<p class="price">
					Giá Chỉ Từ: <span>2,430,000 VNĐ</span> /Đêm
				</p>
			<button class="book-now" data-bs-toggle="modal" data-bs-target="#bookingModal">Đặt Ngay</button>
			</div>
		</section>
		<section class="hotel">
			<img src="static/images/resort2.jpg"
				alt="Vinpearl Resort & Spa Nha Trang Bay">
			<div class="info">
				<h2>Vinpearl Resort & Spa Nha Trang Bay</h2>
				<p>Đảo Hòn Tre, Nha Trang, Khánh Hòa, Việt Nam</p>
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
		<section class="hotel">
			<img src="static/images/resort3.jpg" alt="Vinpearl Resort Nha Trang">
			<div class="info">
				<h2>Vinpearl Resort Nha Trang</h2>
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
		<section class="hotel">
			<img src="static/images/resort4.jpg" alt="Vinpearl Luxury Nha Trang">
			<div class="info">
				<h2>Vinpearl Luxury Nha Trang</h2>
				<p>Khu Bãi Dài, Xã Gành Dầu, Thành Phố Phú Quốc, Tỉnh Kiên Giang</p>
				<p>
					<strong>Số điện thoại:</strong> (+84) 297 3550 550
				</p>
				<p>
					<strong>Đánh giá:</strong> <span class="rating">4.7</span> <span
						class="stars">★★★★★</span>
				</p>
				<p class="price">
					Giá Chỉ Từ: <span>4,100,000 VNĐ</span> /Đêm
				</p>
			<button class="book-now" data-bs-toggle="modal" data-bs-target="#bookingModal">Đặt Ngay</button>
			</div>
		</section>
		<section class="hotel">
			<img src="static/images/resort5.jpg" alt="Hòn Tằm Resort">
			<div class="info">
				<h2>Hòn Tằm Resort</h2>
				<p>Đảo Hòn Tằm, Phường Vĩnh Nguyên, Thành Phố Nha Trang, Tỉnh
					Khánh Hòa, Việt Nam</p>
				<p>
					<strong>Số điện thoại:</strong> (+84) 297 3550 550
				</p>
				<p>
					<strong>Đánh giá:</strong> <span class="rating">4.7</span> <span
						class="stars">★★★★★</span>
				</p>
				<p class="price">
					Giá Chỉ Từ: <span>1,100,000 VNĐ</span> /Đêm
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
