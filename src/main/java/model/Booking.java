package model;

import java.util.Date;
public class Booking {
    private int bookingId;
    private int userId;
    private int roomId;
    private Date checkIn;
    private Date checkOut;
    private String status;
    private Date createdAt;
    private int quantity;
    private int orderId;
    public Booking() {};
    public Booking(int bookingId, int userId, int roomId, Date checkIn, Date checkOut, String status) {
        this.bookingId = bookingId;
        this.userId = userId;
        this.roomId = roomId;
        this.checkIn = checkIn;
        this.checkOut = checkOut;
        this.status = status;
    }
    public Booking(int userId, int roomId, Date checkIn, Date checkOut) {
    	 this.userId = userId;
         this.roomId = roomId;
         this.checkIn = checkIn;
         this.checkOut = checkOut;
    }
    public int getBookingId() {
        return bookingId;
    }

    public void setBookingId(int bookingId) {
        this.bookingId = bookingId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getRoomId() {
        return roomId;
    }

    public void setRoomId(int roomId) {
        this.roomId = roomId;
    }

    public Date getCheckIn() {
        return checkIn;
    }

    public void setCheckIn(Date checkIn) {
        this.checkIn = checkIn;
    }

    public Date getCheckOut() {
        return checkOut;
    }

    public void setCheckOut(Date checkOut) {
        this.checkOut = checkOut;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }
	@Override
	public String toString() {
		return "Booking [bookingId=" + bookingId + ", userId=" + userId + ", roomId=" + roomId + ", checkIn=" + checkIn
				+ ", checkOut=" + checkOut + ", status=" + status + ", createdAt=" + createdAt + "]";
	}
    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }
}
