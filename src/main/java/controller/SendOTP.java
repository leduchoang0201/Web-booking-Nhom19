package controller;

import java.util.Properties;
import jakarta.mail.*;

import jakarta.mail.internet.*;

public class SendOTP {
    public static void sendOtpToEmail(String toEmail, String otpCode) {
        String fromEmail = "leduchoang258@gmail.com";
        String password = "gvbs ebwo bsqa kphi";

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromEmail));
            message.setRecipients(
                    Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("OTP xác thực hủy khóa");
            message.setText("Mã OTP của bạn là: " + otpCode + "\n" +
                    "Mã này có hiệu lực trong vài phút. Vui lòng không chia sẻ với bất kỳ ai.");

            Transport.send(message);
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }
}
