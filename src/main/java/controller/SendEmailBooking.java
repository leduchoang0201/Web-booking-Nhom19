package controller;

import java.sql.Date;
import java.util.Properties;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

public class SendEmailBooking {

    public static void sendBookingInfo(String toEmail, String name, String roomName, Date checkInDate, Date checkOutDate, String roomPrice) {
        String fromEmail = "phumaihoang45@gmail.com";  
        String password = "kfzy oljg mtob comd";  
        
        Properties properties = new Properties();
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.starttls.enable", "true");
        properties.put("mail.smtp.host", "smtp.gmail.com");
        properties.put("mail.smtp.port", "587");

        
        Session session = Session.getInstance(properties, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password);
            }
        });
        
        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromEmail)); 
            message.addRecipient(Message.RecipientType.TO, new InternetAddress(toEmail)); 
            message.setSubject("Hotel Booking Confirmation");  
            
            // Nội dung email với thông tin chi tiết về booking
            String emailContent = "Chào " + name + ",\n\n" +
                "Cảm ơn bạn đã đặt phòng tại khách sạn của chúng tôi. Dưới đây là thông tin đặt phòng của bạn:\n\n" +
                "Tên phòng: " + roomName + "\n" +
                "Ngày nhận phòng: " + checkInDate.toString() + "\n" +
                "Ngày trả phòng: " + checkOutDate.toString() + "\n" +
                "Giá tiền phòng:" + roomPrice +  "\n\n" +
                "Chúng tôi rất mong được đón tiếp bạn. Nếu bạn có bất kỳ câu hỏi nào, vui lòng liên hệ với chúng tôi.\n\n" +
                "Trân trọng,\nHotel Booking";

            message.setText(emailContent);  
            
            // Gửi email
            Transport.send(message);
            System.out.println("Email đã được gửi thành công tới " + toEmail);
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }
}
