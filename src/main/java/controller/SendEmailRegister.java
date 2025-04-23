package controller;

import java.util.Properties;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import jakarta.mail.*;
import jakarta.mail.internet.*;

public class SendEmailRegister {
	    public static void sendRegistrationConfirmation(String toEmail) {
	        String fromEmail = "phumaihoang45@gmail.com";  // Địa chỉ email người gửi
	        String password = "kfzy oljg mtob comd";  // Mật khẩu email 
	        
	        // Cấu hình thông tin kết nối với máy chủ SMTP
	        Properties properties = new Properties();
	        properties.put("mail.smtp.auth", "true");
	        properties.put("mail.smtp.starttls.enable", "true");
	        properties.put("mail.smtp.host", "smtp.gmail.com");
	        properties.put("mail.smtp.port", "587");
	        
	        // Tạo phiên làm việc với máy chủ
	        Session session = Session.getInstance(properties, new Authenticator() {
	            @Override
	            protected PasswordAuthentication getPasswordAuthentication() {
	                return new PasswordAuthentication(fromEmail, password);
	            }
	        });
	        try {
	            // Tạo một đối tượng MimeMessage để gửi email
	            MimeMessage message = new MimeMessage(session);
	            message.setFrom(new InternetAddress(fromEmail));  // Địa chỉ người gửi
	            message.addRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));  // Địa chỉ người nhận
	            message.setSubject("Hotel Booking");  // Tiêu đề email
	            message.setText("Bạn đã đăng ký thành công! Cảm ơn bạn đã tham gia.");  // Nội dung email
	            
	            // Gửi email
	            Transport.send(message);
	            System.out.println("Email đã được gửi thành công tới " + toEmail);
	        } catch (MessagingException e) {
	            e.printStackTrace();
	        }
	    }
	}

