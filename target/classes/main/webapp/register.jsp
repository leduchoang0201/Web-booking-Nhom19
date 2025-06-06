<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title id="pageTitle">Đăng Ký</title>
<link rel="stylesheet" type="text/css"
	href="static/css/login.css">
	<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>

<style>
.back-to-home {
    position: absolute; 
    top: 20px;
    right: 20px;
    z-index: 1000;
}

.back-to-home button {
    padding: 10px 15px;
    background-color: #007bff;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    transition: background-color 0.3s;
    display: flex;
    align-items: center;
}

.back-to-home button i {
    margin-right: 5px;
}

.back-to-home button:hover {
    background-color: #0056b3;
}
 .left-section {
    flex: 2;
    background: url('static/images/setlogin.jpg') no-repeat center center;
    background-size: cover;
    color: white;
    display: flex;
    align-items: flex-end;
    padding: 40px;
}
.language-switcher {
	display: flex;
	justify-content: flex-end;
	padding: 30px;
}

.language-switcher button {
	margin-left: 10px;
	padding: 10px 15px;
	background-color: #007bff;
	color: white;
	border: none;
	border-radius: 5px;
	cursor: pointer;
	transition: background-color 0.3s;
}

.language-switcher button:hover {
	background-color: #0056b3;
}
</style>
<body>

	<div class="container">
		<div class="left-section">
			<div>
				<h1 id="header">Kết nối giá trị - Trải nghiệm tinh hoa cùng
					VinClub</h1>

			</div>
		</div>

		<div class="back-to-home">
			<button
				onclick="window.location.href='home.jsp'">
				<i class="fas fa-arrow-left"></i> Quay lại trang chủ
			</button>
		</div>
		
		<div class="right-section">
			<div class="register-form">
				<div class="language-switcher">
					<button onclick="switchLanguage('en')">English</button>
					<button onclick="switchLanguage('vi')">Tiếng Việt</button>
				</div>
				<img src="static/images/logo.png"
					alt="Vinpearl" width="150">
				<h2 id="registerTitle">Đăng Ký</h2>
				<% if (request.getAttribute("errorMessage") != null) { %>
				    <div style="color: red;">
				        <%= request.getAttribute("errorMessage") %>
				    </div>
					<% } %>
				<form id="registerForm" action="register" method="post" onsubmit="return validateForm()">
					<input type="text" name="fullname" id="fullnameInput"
						placeholder="Họ và tên*" required> 
					
					<input type="text" name="email" id="emailInput" placeholder="Email/Số điện thoại*" required> 
					
					<input type="password" name="password"
						id="passwordInput" placeholder="Mật khẩu*" required> 
					
					<input type="password" name="confirmPassword" id="confirmPasswordInput"
						placeholder="Nhập lại mật khẩu*" required>
					
					<button type="submit" id="registerButton">ĐĂNG KÝ</button>
				</form>
				<div class="footer">
					<span id="alreadyHaveAccountText">Bạn đã có tài khoản? </span> 
					<a href="login.jsp" id="loginLink">Đăng nhập</a>
				</div>
			</div>
		</div>
	</div>

	<script>
        let translations1 = {};

        fetch('translations1.json')
            .then(response => response.json())
            .then(data => {
                translations = data;
                switchLanguage('vi');
            });

        function switchLanguage(lang) {
            document.getElementById('pageTitle').innerText = translations[lang].title;
            document.getElementById('header').innerText = translations[lang].header;
            document.getElementById('fullnameInput').placeholder = translations[lang].fullnamePlaceholder;
            document.getElementById('emailInput').placeholder = translations[lang].emailPlaceholder;
            document.getElementById('passwordInput').placeholder = translations[lang].passwordPlaceholder;
            document.getElementById('confirmPasswordInput').placeholder = translations[lang].confirmPasswordPlaceholder;
            document.getElementById('registerButton').innerText = translations[lang].registerButton;
            document.getElementById('alreadyHaveAccountText').innerText = translations[lang].alreadyHaveAccount;
            document.getElementById('loginLink').innerText = translations[lang].loginLink;
        }

        function validateForm() {
            var name = document.getElementById('fullnameInput').value;
            var email = document.getElementById('emailInput').value;
            var password = document.getElementById('passwordInput').value;
            var confirmPassword = document.getElementById('confirmPasswordInput').value;

            if (name === "") {
                alert("Họ và tên không được để trống.");
                return false;
            }

            var emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
            if (!emailPattern.test(email)) {
                alert("Email không hợp lệ.");
                return false;
            }

            if (password === "") {
                alert("Mật khẩu không được để trống.");
                return false;
            }

            if (password !== confirmPassword) {
                alert("Mật khẩu và nhập lại mật khẩu không khớp.");
                return false;
            }

            return true;
        }
    </script>
</body>
</html>
