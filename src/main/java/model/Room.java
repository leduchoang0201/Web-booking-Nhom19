package model;

public class Room {
	private int id;
	private String name;
	private String type;
	private double price;
	private int capacity;
	private boolean available;
	private String image;
	private String location;
	public Room(int id, String name, String type, double price, int capacity, boolean available, String image, String location) {
		super();
		this.id = id;
		this.name = name;
		this.type = type;
		this.price = price;
		this.capacity = capacity;
		this.available = available;
		this.image = image;
		this.location = location;
	} 
	public Room(int id, String name, String type, double price, int capacity, String image, String location) {
		this.id = id;
		this.name = name;
		this.type = type;
		this.price = price;
		this.capacity = capacity;
		this.image = image;
		this.location = location;
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public double getPrice() {
		return price;
	}
	public void setPrice(double price) {
		this.price = price;
	}
	public int getCapacity() {
		return capacity;
	}
	public void setCapacity(int capacity) {
		this.capacity = capacity;
	}
	public boolean isAvailable() {
		return available;
	}
	public void setAvailable(boolean available) {
		this.available = available;
	}
	public String getImage() {
		return image;
	}
	public void setImage(String image) {
		this.image = image;
	}
	public String getLocation() {
		return location;
	}
	public void setLocation(String location) {
		this.location = location;
	}
	@Override
	public String toString() {
		return "Room [id=" + id + ", name=" + name + ", type=" + type + ", price=" + price + ", capacity=" + capacity
				+ ", available=" + available + ", image=" + image + ", location=" + location + "]";
	}
	
}
