package model;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class Cart {
    private List<CartItem> items;

    public Cart(List<CartItem> items) {
        this.items = items;
    }

    public void add (Room room, Date checkIn, Date checkOut, int quantity) {
        if (quantity <= room.getQuantity()) {
            items.add(new CartItem(room, checkIn, checkOut, quantity));
        } else {
            throw new IllegalArgumentException("Số lượng phòng yêu cầu vượt quá số lượng còn lại!");
        }

    }
    public void removeItem(int index) {
        if (index >= 0 && index < items.size()) {
            items.remove(index);
        }
    }
    public List<CartItem> getItems() {
        return items;
    }
    public double getTotal() {
        return items.stream().mapToDouble(CartItem::getSubtotal).sum();
    }

}
