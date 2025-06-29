package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.mindrot.jbcrypt.BCrypt;

import model.Room;

public class RoomDAO implements InterfaceDao<Room> {
	static Connection con;

	public static void creatCon() {
		con = new ConnectDB().getConnection();
	}

	@Override
	public int insert(Room room) {
	    try {
	        creatCon();
	        String checkSql = "SELECT COUNT(*) FROM rooms WHERE room_id = ?";
	        PreparedStatement checkPr = con.prepareStatement(checkSql);
	        checkPr.setInt(1, room.getId());
	        ResultSet checkRs = checkPr.executeQuery();

	        if (checkRs.next() && checkRs.getInt(1) > 0) {
	            con.close();
	            return 0; 
	        }
	        String sql = "INSERT INTO rooms (room_id, room_name, room_type, price, capacity, status, image, location) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
	        PreparedStatement pr = con.prepareStatement(sql);
	        pr.setInt(1, room.getId());
	        pr.setString(2, room.getName());
	        pr.setString(3, room.getType());
	        pr.setDouble(4, room.getPrice());
	        pr.setInt(5, room.getCapacity());
	        pr.setBoolean(6, room.isAvailable());
	        pr.setString(7, room.getImage());
	        pr.setString(8, room.getLocation());

	        int result = pr.executeUpdate();

	        con.close();
	        return result;
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return 0;
	}



	@Override
    public int delete(int id) {
        try {
            creatCon();
            String sql = "DELETE FROM rooms WHERE room_id = ?";
            PreparedStatement pr = con.prepareStatement(sql);

            pr.setInt(1, id);

            int result = pr.executeUpdate();

            con.close();

            return result;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

	@Override
    public int update(Room room) {
        try {
            creatCon();
            String sql = "UPDATE rooms SET room_name = ?, room_type = ?, price = ?, capacity = ?, status = ?, image = ?, location = ? WHERE room_id = ?";
            PreparedStatement pr = con.prepareStatement(sql);

            pr.setString(1, room.getName());
            pr.setString(2, room.getType());
            pr.setDouble(3, room.getPrice());
            pr.setInt(4, room.getCapacity());
            pr.setBoolean(5, room.isAvailable());
            pr.setString(6, room.getImage());
            pr.setString(7, room.getLocation()); 
            pr.setInt(8, room.getId());

            int result = pr.executeUpdate();

            con.close();

            return result;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

	@Override
    public List<Room> getAll() {
        List<Room> rooms = new ArrayList<>();
        try {
            creatCon();
            String sql = "SELECT * FROM rooms";
            PreparedStatement pr = con.prepareStatement(sql);
            ResultSet rs = pr.executeQuery();

            while (rs.next()) {
                Room room = new Room(
                    rs.getInt("room_id"),
                    rs.getString("room_name"),
                    rs.getString("room_type"),
                    rs.getInt("price"),
                    rs.getInt("capacity"),
						rs.getInt("quantity"),
                    rs.getBoolean("status"),
                    rs.getString("image"),
                    rs.getString("location")
                );
                rooms.add(room);
            }
            con.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rooms;
    }
	public Room getRoomById(int id) {
	    Room room = null;
	    try {
	        creatCon();
	        String sql = "SELECT * FROM rooms WHERE room_id = ?";
	        PreparedStatement pr = con.prepareStatement(sql);
	        pr.setInt(1, id);
	        ResultSet rs = pr.executeQuery();

	        if (rs.next()) {
	            room = new Room(
	                rs.getInt("room_id"),
	                rs.getString("room_name"),
	                rs.getString("room_type"),
	                rs.getDouble("price"),
	                rs.getInt("capacity"),
						rs.getInt("quantity"),
	                rs.getBoolean("status"),
	                rs.getString("image"),
	                rs.getString("location")
	            );
	        }
	        con.close();
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return room;
	}
	public List<Room> getRoomsByLocation(String location) {
	    List<Room> rooms = new ArrayList<>();
	    try {
	        creatCon();
	        String sql = "SELECT * FROM rooms WHERE location = ?";
	        PreparedStatement pr = con.prepareStatement(sql);
	        pr.setString(1, location);
	        ResultSet rs = pr.executeQuery();

	        while (rs.next()) {
	            Room room = new Room(
	                rs.getInt("room_id"),
	                rs.getString("room_name"),
	                rs.getString("room_type"),
	                rs.getDouble("price"),
	                rs.getInt("capacity"),
						rs.getInt("quantity"),
	                rs.getBoolean("status"),
	                rs.getString("image"),
	                rs.getString("location")
	            );
	            rooms.add(room);
	        }
	        con.close();
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return rooms;
	}
	public void reduceRoomQuantity(int roomId, int quantity) throws SQLException {
		creatCon();
		String sql = "UPDATE rooms SET quantity = quantity - ? WHERE room_id = ? AND quantity >= ?";
		PreparedStatement ps = con.prepareStatement(sql);
		ps.setInt(1, quantity);
		ps.setInt(2, roomId);
		ps.setInt(3, quantity); // đảm bảo không trừ khi không đủ
		ps.executeUpdate();
		con.close();
	}
	public int getAvailableQuantity(int roomId) throws SQLException {
		creatCon();
		String sql = "SELECT quantity FROM rooms WHERE room_id = ?";
		PreparedStatement ps = con.prepareStatement(sql);
		ps.setInt(1, roomId);
		ResultSet rs = ps.executeQuery();
		if (rs.next()) {
			int qty = rs.getInt("quantity");
			con.close();
			return qty;
		}
		con.close();
		return 0;
	}
}
