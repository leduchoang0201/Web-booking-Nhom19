package controller;

import java.util.List;
import java.util.Properties;
import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import model.Order;
import model.Booking;
import model.Room;
import dao.BookingDAO;
import dao.RoomDAO;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;

public class SendEmailOrder {

    public static void sendOrderInfo(Order order, BookingDAO bookingDAO, RoomDAO roomDAO) {
        String fromEmail = "leduchoang258@gmail.com";
        String password = "gvbs ebwo bsqa kphi";

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
            message.addRecipient(Message.RecipientType.TO, new InternetAddress(order.getCustomerEmail()));
            message.setSubject("Hotel Order Confirmation");

            DecimalFormat df = new DecimalFormat("#,###");
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
            StringBuilder emailContent = new StringBuilder();
            emailContent.append("Chào ").append(order.getCustomerName()).append(",\n\n");
            emailContent.append("Cảm ơn bạn đã đặt phòng tại khách sạn của chúng tôi. Dưới đây là thông tin đơn hàng của bạn:\n\n");
            emailContent.append("Tên: ").append(order.getCustomerName()).append("\n");
            emailContent.append("Email: ").append(order.getCustomerEmail()).append("\n");
            emailContent.append("Số điện thoại: ").append(order.getCustomerPhone()).append("\n");
            emailContent.append("Thời gian đặt: ").append(sdf.format(order.getTimeStamp())).append("\n\n");

            List<Booking> bookings = bookingDAO.getByOrderId(order.getOrderId());
            if (bookings == null || bookings.isEmpty()) {
                emailContent.append("Không có thông tin đặt phòng.\n\n");
            } else {
                int index = 1;
                for (Booking booking : bookings) {
                    Room room = roomDAO.getRoomById(booking.getRoomId());
                    if (room != null) {
                        emailContent.append("Phòng ").append(index++).append(":\n");
                        emailContent.append("- Tên phòng: ").append(room.getName()).append("\n");
                        emailContent.append("- Giá: ").append(df.format(room.getPrice())).append(" VNĐ/đêm\n");
                        emailContent.append("- Check-in: ").append(sdf.format(booking.getCheckIn())).append("\n");
                        emailContent.append("- Check-out: ").append(sdf.format(booking.getCheckOut())).append("\n");
                        emailContent.append("- Số lượng: ").append(booking.getQuantity()).append("\n");
                        emailContent.append("- Thành tiền: ").append(df.format(booking.getQuantity() * room.getPrice())).append(" VNĐ\n\n");
                    }
                }
            }

            emailContent.append("Tổng tiền: ").append(df.format(order.getTotalPrice())).append(" VNĐ\n\n");
            emailContent.append("Chúng tôi rất mong được đón tiếp bạn. Nếu bạn có bất kỳ câu hỏi nào, vui lòng liên hệ với chúng tôi.\n\n");
            emailContent.append("Trân trọng,\nHotel Booking");

            message.setText(emailContent.toString());

            Transport.send(message);
            System.out.println("Email đã được gửi thành công tới " + order.getCustomerEmail());
        } catch (MessagingException e) {
            System.out.println("Lỗi gửi email tới " + order.getCustomerEmail() + ": " + e.getMessage());
            e.printStackTrace();
        }
    }
}