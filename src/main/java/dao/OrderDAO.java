package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Order;
import model.User;

public class OrderDAO implements InterfaceDao<Order> {
    static Connection con;

    public static void creatCon() {
        con = new ConnectDB().getConnection();
    }

    @Override
    public int insert(Order order) {
        try {
            creatCon();
            String sql = "INSERT INTO orders (user_id, customer_name, customer_email, customer_phone, public_key, signature, total_price, time_stamp, hash_data) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement pr = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            pr.setInt(1, order.getUserId());
            pr.setString(2, order.getCustomerName());
            pr.setString(3, order.getCustomerEmail());
            pr.setString(4, order.getCustomerPhone());
            pr.setString(5, order.getPublicKeyString());
            pr.setString(6, order.getSignature());
            pr.setDouble(7, order.getTotalPrice());
            pr.setLong(8, order.getTimeStamp());
            pr.setString(9, order.getHashData());

            int result = pr.executeUpdate();

            if (result > 0) {
                ResultSet rs = pr.getGeneratedKeys();
                if (rs.next()) {
                    int generatedOrderId = rs.getInt(1);
                    con.close();
                    return generatedOrderId;
                }
            }
            con.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Order> getAllByUser(User user) {
        List<Order> list = new ArrayList<>();
        try {
            creatCon();
            String sql = "SELECT * FROM orders WHERE user_id = ?";
            PreparedStatement pr = con.prepareStatement(sql);
            pr.setInt(1, user.getId());

            ResultSet rs = pr.executeQuery();
            while (rs.next()) {
                Order o = new Order();
                o.setOrderId(rs.getInt("order_id"));
                o.setUserId(rs.getInt("user_id"));
                o.setCustomerName(rs.getString("customer_name"));
                o.setCustomerEmail(rs.getString("customer_email"));
                o.setCustomerPhone(rs.getString("customer_phone"));
                o.setPublicKeyString(rs.getString("public_key"));
                o.setSignature(rs.getString("signature"));
                o.setTotalPrice(rs.getDouble("total_price"));
                o.setTimeStamp(rs.getLong("time_stamp"));
                o.setHashData(rs.getString("hash_data"));
                list.add(o);
            }
            con.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<Order> getAll() {
        List<Order> list = new ArrayList<>();
        try {
            creatCon();
            String sql = "SELECT * FROM orders";
            PreparedStatement pr = con.prepareStatement(sql);
            ResultSet rs = pr.executeQuery();
            while (rs.next()) {
                Order o = new Order();
                o.setOrderId(rs.getInt("order_id"));
                o.setUserId(rs.getInt("user_id"));
                o.setCustomerName(rs.getString("customer_name"));
                o.setCustomerEmail(rs.getString("customer_email"));
                o.setCustomerPhone(rs.getString("customer_phone"));
                o.setPublicKeyString(rs.getString("public_key"));
                o.setSignature(rs.getString("signature"));
                o.setTotalPrice(rs.getDouble("total_price"));
                o.setTimeStamp(rs.getLong("time_stamp"));
                o.setHashData(rs.getString("hash_data"));
                list.add(o);
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
            String sql = "DELETE FROM orders WHERE order_id = ?";
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
    public int update(Order order) {
        try {
            creatCon();
            String sql = "UPDATE orders SET customer_name = ?, customer_email = ?, customer_phone = ?, public_key = ?, signature = ?, time_stamp = ? WHERE order_id = ?";
            PreparedStatement pr = con.prepareStatement(sql);
            pr.setString(1, order.getCustomerName());
            pr.setString(2, order.getCustomerEmail());
            pr.setString(3, order.getCustomerPhone());
            pr.setString(4, order.getPublicKeyString());
            pr.setString(5, order.getSignature());
            pr.setLong(6, order.getTimeStamp());
            pr.setInt(7, order.getOrderId());

            int result = pr.executeUpdate();
            con.close();
            return result;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
