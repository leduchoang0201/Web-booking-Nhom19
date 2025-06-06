<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title id="pageTitle">Đăng Nhập</title>
<link rel="stylesheet" type="text/css"
	href="static/css/login.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<style>
.back-to-home {
    position: absolute; /* Positioning relative to the nearest positioned ancestor */
    top: 20px; /* Distance from the top */
    right: 20px; /* Distance from the right */
    z-index: 1000; /* Ensure it stays on top of other elements */
}

.back-to-home button {
    padding: 10px 15px; /* Button padding */
    background-color: #007bff; /* Button color */
    color: white; /* Text color */
    border: none; /* Remove border */
    border-radius: 5px; /* Rounded corners */
    cursor: pointer; /* Pointer cursor */
    transition: background-color 0.3s; /* Smooth transition */
    display: flex; /* Use flexbox for alignment */
    align-items: center; /* Center icon and text vertically */
}

.back-to-home button i {
    margin-right: 5px; /* Space between the icon and text */
}

.back-to-home button:hover {
    background-color: #0056b3; /* Darker shade on hover */
}
.left-section {
	flex: 2;
	background:
		url('static/images/setlogin.jpg')
		no-repeat center center;
	background-size: cover;
	color: white;
	display: flex;
	align-items: flex-end;
	padding: 40px;
}

.language-switcher {
	display: flex;
	justify-content: flex-end; /* Align buttons to the right */
	padding: 30px; /* Add some padding */
}

.language-switcher button {
	margin-left: 10px; /* Space between buttons */
	padding: 10px 15px; /* Button padding */
	background-color: #007bff; /* Button color */
	color: white; /* Text color */
	border: none; /* Remove border */
	border-radius: 5px; /* Rounded corners */
	cursor: pointer; /* Pointer cursor */
	transition: background-color 0.3s; /* Smooth transition */
}

.language-switcher button:hover {
	background-color: #0056b3; /* Darker shade on hover */
}
</style>
<body>

	<div class="container">
		<!-- Phần bên trái -->
		<div class="left-section">
			<div>
				<h1 id="header">Kết nối giá trị - Trải nghiệm tinh hoa cùng
					VinClub</h1>
			</div>
		</div>

		<!-- Phần bên phải -->
		<div class="back-to-home">
			<button
				onclick="window.location.href='home.jsp'">
				<i class="fas fa-arrow-left"></i> Quay lại trang chủ
			</button>
		</div>

		<div class="right-section">
			<div class="login-form">
				<div class="language-switcher">
					<button onclick="switchLanguage('en')">English</button>
					<button onclick="switchLanguage('vi')">Tiếng Việt</button>
				</div>
				<img src="static/images/logo.png"
					alt="Vinpearl" width="150">
				<h2 id="loginTitle">Đăng Nhập</h2>
				
				<form action="login" method="post" onsubmit="return validateForm()">
					<span id="emailError" style="color: red;"></span>
					<input type="text" name="email" id="emailInput" placeholder="Email*" required>
					
					<span id="passwordError" style="color: red;"></span>
					<input type="password" name="password" id="passwordInput" placeholder="Mật khẩu" required>
					<% if (request.getAttribute("errorMessage") != null) { %>
				    <div style="color: red;">
				        <%= request.getAttribute("errorMessage") %>
				    </div>
					<% } %>
					<div style="margin: 10px 0;">
						<input type="checkbox" id="rememberMe" value="Y" name="rememberMe"> <label
							for="rememberMe" id="rememberMeLabel">Ghi nhớ tài khoản</label> 
							<a href="#" style="float: right;" id="forgotPasswordLink">Quên mật khẩu</a>
					</div>
					<button type="submit" id="loginButton">ĐĂNG NHẬP</button>
				</form>
				<div class="footer">
					<span id="agreeText">Bằng việc đăng nhập, tôi đồng ý với
						Vinpearl về </span> <a href="#" id="termsLink">Điều kiện điều khoản</a>
					và <a href="#" id="privacyLink">Chính sách bảo mật</a>. <br> <span
						id="noAccountText">Chưa có tài khoản? </span><a
						href="register.jsp">Đăng ký ngay</a>
				</div>
			</div>
		</div>
	</div>



	<script>
        let translations = {};

        fetch('translations.json')
            .then(response => response.json())
            .then(data => {
                translations = data;
                switchLanguage('vi'); 
            });

        function switchLanguage(lang) {
            document.getElementById('pageTitle').innerText = translations[lang].title;
            document.getElementById('header').innerText = translations[lang].header;
            document.getElementById('emailInput').placeholder = translations[lang].emailPlaceholder;
            document.getElementById('passwordInput').placeholder = translations[lang].passwordPlaceholder;
            document.getElementById('rememberMeLabel').innerText = translations[lang].rememberMe;
            document.getElementById('forgotPasswordLink').innerText = translations[lang].forgotPassword;
            document.getElementById('loginButton').innerText = translations[lang].loginButton;
            document.getElementById('agreeText').innerText = translations[lang].agree;
            document.getElementById('termsLink').innerText = translations[lang].terms;
            document.getElementById('privacyLink').innerText = translations[lang].privacy;
            document.getElementById('noAccountText').innerText = translations[lang].noAccount;
        }
        function validateForm() {
            let email = document.getElementById("emailInput").value;
            let password = document.getElementById("passwordInput").value;
            let emailPattern = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/;

            document.getElementById("emailError").innerText = "";
            document.getElementById("passwordError").innerText = "";

            if (email === "") {
                document.getElementById("emailError").innerText = "Email không được để trống";
                return false;
            } else if (!emailPattern.test(email)) {
                document.getElementById("emailError").innerText = "Email không hợp lệ";
                return false;
            }

            if (password === "") {
                document.getElementById("passwordError").innerText = "Mật khẩu không được để trống";
                return false;
            }

            return true; 
        }
    </script>
</body>
</html>