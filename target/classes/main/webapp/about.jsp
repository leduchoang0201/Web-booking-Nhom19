<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<link rel="stylesheet" type="text/css" href="static/css/index.css">
<link rel="stylesheet"
	href="lib/bootstrap-5.0.2-dist/css/bootstrap.min.css">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
</head>
<body>
	<jsp:include page="Header.jsp" />
	
	<section class="container layout-contact">
		<div class="col-lg-6 col-12">
			<div class="contact">
				<h4>BOOKING HOTEL</h4>
				<div class="info-contact">
					<div class="group-address">
						<ul>
							<li>
								<div class="icon">
									<i class="fa-solid fa-location-dot" style="color: #c0a600"></i>
								</div>
								<div class="info">
									<b>Địa chỉ</b></br /> <span>Khu phố 6, phường Linh Trung, thành
										phố Thủ Đức , Thành phố Hồ Chí Minh </span>
								</div>
							</li>
							<li>
								<div class="icon">
									<i class="fa-solid fa-clock" style="color: #c0a600"></i>
								</div>
								<div class="info">
									<b>Thời gian làm việc</b></br /> <span>7h - 22h</br>Từ Thứ 2 đến Chủ
										Nhật
									</span>
								</div>
							</li>
							<li>
								<div class="icon">
									<i class="fa-solid fa-phone-volume" style="color: #c0a600"></i>
								</div>
								<div class="info">
									<b>Hotline</b></br /> <span>+ 84 124 56 788</span>
								</div>
							</li>
							<li>
								<div class="icon">
									<i class="fa-solid fa-envelope" style="color: #c0a600"></i>
								</div>
								<div class="info">
									<b>Email</b></br /> <span>cskh@moctra.com</span>
								</div>
							</li>
						</ul>
					</div>
				</div>
			</div>

			<div class="form-contact">
				<h4>Liên hệ với chúng tôi</h4>
				<span class="content-form"> Nếu bạn có thắc mắc gì, có thể
					gửi yêu cầu cho chúng tôi, và chúng tôi sẽ liên lạc lại với bạn sớm
					nhất có thể . </span>

				<div>
					<form method="post" action="#" id="contact" accept-charset="UTF-8">
						<div class="group_contact">
							<input placeholder="Họ và tên" type="text"
								class="form-control form-control-lg" name="contact[Name]"
								style="margin-bottom: 10px;"> <input placeholder="Email"
								type="email" id="email1" class="form-control form-control-lg"
								value="" name="contact[email]" style="margin-bottom: 10px;">
							<input type="number" placeholder="Điện thoại*"
								name="contact[phone]" class="form-control form-control-lg"
								style="margin-bottom: 10px;">
							<textarea placeholder="Nội dung" name="contact[body]"
								id="comment" class="form-control content-area form-control-lg"
								rows="5" style="margin-bottom: 10px;"></textarea>
							<button type="submit" class="btn-lienhe">Gửi thông tin</button>
						</div>
					</form>
				</div>
			</div>
		</div>

		<!--Map-->
		<div class="col-lg-6 col-12">
			<div id="contact_map" class="map">
				<iframe
					src="https://www.google.com/maps/embed?pb=!1m14!1m8!1m3!1d15672.858378257437!2d106.7917617!3d10.8712764!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3175276398969f7b%3A0x9672b7efd0893fc4!2zVHLGsOG7nW5nIMSQ4bqhaSBo4buNYyBOw7RuZyBMw6JtIFRQLiBI4buTIENow60gTWluaA!5e0!3m2!1svi!2s!4v1701341812042!5m2!1svi!2s"
					width="600" height="450" style="border: 0;" allowfullscreen=""
					loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>
			</div>
		</div>
	</section>

	<jsp:include page="Footer.jsp" />
</body>
</html>