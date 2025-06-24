package model;

import java.util.Date;
public class CartItem {
    private Room room;
    private Date checkIn;
    private Date checkOut;
    private int quantity;

    public CartItem(Room room, Date checkIn, Date checkOut, int quantity) {
        this.room = room;
        this.checkIn = checkIn;
        this.checkOut = checkOut;
        this.quantity = quantity;
    }
    public Room getRoom() {
        return room;
    }

    public void setRoom(Room room) {
        this.room = room;
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

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
    public double getSubtotal() {
        long milliseconds = checkOut.getTime() - checkIn.getTime();
        int numberOfDays = (int) (milliseconds / (1000 * 60 * 60 * 24));
        if (numberOfDays == 0) numberOfDays = 1; // ít nhất 1 ngày
        return room.getPrice() * quantity * numberOfDays;
    }

    @Override
    public String toString() {
        return "CartItem{" +
                "room=" + room +
                ", checkIn=" + checkIn +
                ", checkOut=" + checkOut +
                ", quantity=" + quantity +
                '}';
    }
}
