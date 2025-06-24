package dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.Booking;
import model.User;

public class BookingDAO implements InterfaceDao<Booking>{
	static Connection con;

	public static void creatCon() {
		con = new ConnectDB().getConnection();
	}

	@Override
    public int insert(Booking booking) {
        try {
            creatCon();
			String sql = "INSERT INTO bookings (user_id, room_id, check_in, check_out, quantity) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement pr = con.prepareStatement(sql);
            pr.setInt(1, booking.getUserId());
            pr.setInt(2, booking.getRoomId());
            pr.setDate(3, new Date(booking.getCheckIn().getTime()));
            pr.setDate(4, new Date(booking.getCheckOut().getTime()));
			pr.setInt(5, booking.getQuantity());
            int result = pr.executeUpdate();
            con.close();
            return result;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
	public List<Booking> getAllByUser(User user) {
	    List<Booking> list = new ArrayList<>();
	    try {
	        creatCon();
	        String sql = "SELECT * FROM bookings WHERE user_id = ?";
	        PreparedStatement pr = con.prepareStatement(sql);
	        pr.setInt(1, user.getId());

	        ResultSet rs = pr.executeQuery();
	        while (rs.next()) {
	            Booking b = new Booking();
	            b.setBookingId(rs.getInt("booking_id")); 
	            b.setUserId(rs.getInt("user_id"));       
	            b.setRoomId(rs.getInt("room_id"));
				b.setQuantity(rs.getInt("quantity"));
				b.setCheckIn(rs.getDate("check_in"));
	            b.setCheckOut(rs.getDate("check_out"));  
	            b.setStatus(rs.getString("status"));     
	            b.setCreatedAt(rs.getTimestamp("created_at")); 
	            list.add(b);
	        }
	        con.close();
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return list;
	}

	@Override
	public List<Booking> getAll() {
		List<Booking> list = new ArrayList<>();
	    try {
	    	creatCon();
	        String sql = "SELECT * FROM bookings ";
	        PreparedStatement pr = con.prepareStatement(sql);
	        ResultSet rs = pr.executeQuery();
	        while (rs.next()) {
	            Booking b = new Booking();
	            b.setBookingId(rs.getInt("booking_id")); 
	            b.setUserId(rs.getInt("user_id"));       
	            b.setRoomId(rs.getInt("room_id"));
				b.setQuantity(rs.getInt("quantity"));
	            b.setCheckIn(rs.getDate("check_in"));    
	            b.setCheckOut(rs.getDate("check_out"));  
	            b.setStatus(rs.getString("status"));     
	            b.setCreatedAt(rs.getTimestamp("created_at")); 
	            list.add(b);
	        }
	        con.close();
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return list;
	}

	@Override
	public int delete(int id) {
	    try {
	        creatCon(); 
	        String sql = "DELETE FROM bookings WHERE booking_id = ?";
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
	public int update(Booking booking) {
	    try {
	        creatCon(); 
	        String sql = "UPDATE bookings SET user_id = ?, room_id = ?, check_in = ?, check_out = ?, status = ? WHERE booking_id = ?";
	        PreparedStatement pr = con.prepareStatement(sql);
	        pr.setInt(1, booking.getUserId());
	        pr.setInt(2, booking.getRoomId());
	        pr.setDate(3, new Date(booking.getCheckIn().getTime()));
	        pr.setDate(4, new Date(booking.getCheckOut().getTime()));
	        pr.setString(5, booking.getStatus());
	        pr.setInt(6, booking.getBookingId());

	        int result = pr.executeUpdate(); 
	        con.close(); 
	        return result; 
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return 0;
	}
	public int updateOrderId(int bookingId, int orderId) {
		try {
			creatCon();
			String sql = "UPDATE bookings SET order_id = ? WHERE booking_id = ?";
			PreparedStatement pr = con.prepareStatement(sql);
			pr.setInt(1, orderId);
			pr.setInt(2, bookingId);
			int result = pr.executeUpdate();
			con.close();
			return result;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return 0;
	}
	public List<Booking> getByOrderId(int orderId) {
		List<Booking> list = new ArrayList<>();
		try {
			creatCon();
			String sql = "SELECT * FROM bookings WHERE order_id = ?";
			PreparedStatement pr = con.prepareStatement(sql);
			pr.setInt(1, orderId);
			ResultSet rs = pr.executeQuery();
			while (rs.next()) {
				Booking b = new Booking();
				b.setBookingId(rs.getInt("booking_id"));
				b.setUserId(rs.getInt("user_id"));
				b.setRoomId(rs.getInt("room_id"));
				b.setQuantity(rs.getInt("quantity"));
				b.setCheckIn(rs.getDate("check_in"));
				b.setCheckOut(rs.getDate("check_out"));
				b.setStatus(rs.getString("status"));
				b.setCreatedAt(rs.getTimestamp("created_at"));
				list.add(b);
			}
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}
	public int insertAndReturnId(Booking booking) {
		int generatedId = -1;
		try {
			creatCon();
			String sql = "INSERT INTO bookings (user_id, room_id, check_in, check_out, quantity) VALUES (?, ?, ?, ?, ?)";
			PreparedStatement pr = con.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
			pr.setInt(1, booking.getUserId());
			pr.setInt(2, booking.getRoomId());
			pr.setDate(3, new java.sql.Date(booking.getCheckIn().getTime()));
			pr.setDate(4, new java.sql.Date(booking.getCheckOut().getTime()));
			pr.setInt(5, booking.getQuantity());
			pr.executeUpdate();

			ResultSet rs = pr.getGeneratedKeys();
			if (rs.next()) {
				generatedId = rs.getInt(1);
			}
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return generatedId;
	}

}
