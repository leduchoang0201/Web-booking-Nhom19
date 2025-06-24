package servlet;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.RSAModel;
import model.User;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;


@WebServlet("/InfoServlet")
@MultipartConfig
public class InfoServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("User");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        UserDAO userDAO = new UserDAO();

        switch (action) {
            case "updateUser": {
                String fullName = request.getParameter("fullName");
                String email = request.getParameter("email");

                user.setName(fullName);
                user.setEmail(email);
                userDAO.updateUserInfo(user);

                session.setAttribute("User", user);
                session.setAttribute("message", "Cập nhật thông tin người dùng thành công.");
                break;
            }

            case "uploadKey": {
                Part filePart = request.getPart("publicKeyFile");
                InputStream fileContent = filePart.getInputStream();
                String publicKeyContent = readBase64FromInputStream(fileContent);

                try {
                    RSAModel rsa = new RSAModel();
                    rsa.loadPublicKeyFromBase64(publicKeyContent);  // kiểm tra tính hợp lệ
                    userDAO.insertPublicKey(user.getId(), publicKeyContent);
                    session.setAttribute("message", "Tải lên khóa công khai thành công.");
                } catch (Exception e) {
                    session.setAttribute("message", "Khóa công khai không hợp lệ hoặc sai định dạng.");
                }
                break;
            }

            case "deleteKey": {
                userDAO.deletePublicKey(user.getId());
                session.setAttribute("message", "Khóa công khai đã được xóa.");
                break;
            }
            case "verifyOtpAndDelete": {
                String inputOtp = request.getParameter("otp");
                String sessionOtp = (String) session.getAttribute("otp");
                String sessionEmail = (String) session.getAttribute("otpEmail");

                if (sessionOtp != null && inputOtp != null && inputOtp.equals(sessionOtp) && sessionEmail.equals(user.getEmail())) {
                    userDAO.deletePublicKey(user.getId());
                    session.setAttribute("message", "Đã xoá khoá thành công.");
                } else {
                    session.setAttribute("message", "Mã OTP không đúng.");
                }

                // Clear OTP session
                session.removeAttribute("otp");
                session.removeAttribute("otpEmail");

                break;
            }

            default:
                session.setAttribute("message", "Hành động không hợp lệ.");
                break;
        }

        // Sau mọi hành động đều quay lại user_info.jsp
        response.sendRedirect("user_info.jsp");
    }

    // Đọc public key dạng Base64 từ file .pem/.txt bỏ phần BEGIN/END
    private String readBase64FromInputStream(InputStream is) throws IOException {
        StringBuilder builder = new StringBuilder();
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8))) {
            String line;
            while ((line = reader.readLine()) != null) {
                line = line.trim();
                if (line.startsWith("-----BEGIN") || line.startsWith("-----END") || line.isEmpty()) {
                    continue;
                }
                builder.append(line);
            }
        }
        return builder.toString();
    }
}
