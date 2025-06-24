package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.mindrot.jbcrypt.BCrypt;

import model.User;

public class UserDAO implements InterfaceDao<User> {
	static Connection con;
	public static void creatCon() {
		con = new ConnectDB().getConnection();
	}
	@Override
	public int insert(User user) {
		try {
			creatCon();
			String sql="Insert into users(name, email, password) values (?,?,?)";
			PreparedStatement pr = con.prepareStatement(sql);
			// Mã hóa mật khẩu bằng BCrypt
			String hashedPassword = BCrypt.hashpw(user.getPassword(), BCrypt.gensalt()); 
			pr.setString(1, user.getName());
			pr.setString(2, user.getEmail());
			pr.setString(3, hashedPassword);
			int re = pr.executeUpdate();
			con.close();
			return re;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return 0;
	}

	@Override
	public List<User> getAll() {
		try {
			List<User> list = new ArrayList<User>();
			creatCon();
			String sql= "select * from users";
			PreparedStatement pr = con.prepareStatement(sql);
			ResultSet rs = pr.executeQuery();
			while (rs.next()) {
				list.add(new User(rs.getInt(1), rs.getString(2), rs.getString(3), rs.getString(4), rs.getDate(5)));
			}
			return list;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}
	public boolean checkMail(String email) {
	    boolean exists = false;
	    try {
	        creatCon();
	        String sql = "SELECT 1 FROM users WHERE email = ?";
	        PreparedStatement pr = con.prepareStatement(sql);
	        pr.setString(1, email);
	        ResultSet rs = pr.executeQuery();
	        exists = rs.next();
	    } catch (SQLException e) {
	        e.printStackTrace();
	    } finally {
	        try {
	            if (con != null) con.close();
	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	    }
	    return exists;
	}

	public User login(String email, String password) {
	    User user = null;
	    try {
	        creatCon();
	        String sql = "SELECT user_id, name, email, password, role FROM users WHERE email = ?";
	        PreparedStatement ps = con.prepareStatement(sql);
	        ps.setString(1, email);

	        ResultSet rs = ps.executeQuery();
	        if (rs.next()) {
	            String hashedPassword = rs.getString("password");
	            if (BCrypt.checkpw(password, hashedPassword)) { //Check mật khẩu
	                user = new User();
	                user.setId(rs.getInt("user_id"));
	                user.setName(rs.getString("name"));
	                user.setEmail(rs.getString("email"));
	                user.setPassword(hashedPassword);
	                user.setRole(rs.getInt("role") );
	            }
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    } finally {
	        try {
	            if (con != null) con.close();
	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	    }
	    return user;
	}

	@Override
	public int delete(int id) {
	    try {
	        creatCon();
	        String sql = "DELETE FROM users WHERE user_id = ?";
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
	public int update(User user) {
	    try {
	        creatCon(); 
	        String sql = "UPDATE users SET name = ?, email = ?, password = ? WHERE user_id = ?";
	        PreparedStatement pr = con.prepareStatement(sql);

	        String hashedPassword = BCrypt.hashpw(user.getPassword(), BCrypt.gensalt()); 
	        pr.setString(1, user.getName());
	        pr.setString(2, user.getEmail());
	        pr.setString(3, hashedPassword);
	        pr.setInt(4, user.getId());

	        int result = pr.executeUpdate(); 
	        con.close(); 
	        return result; 
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return 0; 
	}
	public int updateUserInfo(User user) {
		try {
			creatCon();
			String sql = "UPDATE users SET name = ?, email = ? WHERE user_id = ?";
			PreparedStatement pr = con.prepareStatement(sql);
			pr.setString(1, user.getName());
			pr.setString(2, user.getEmail());
			pr.setInt(3, user.getId());
			int result = pr.executeUpdate();
			con.close();
			return result;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return 0;
	}

	public User findById(int id) {
	    User user = null;
	    try {
	        creatCon();
	        String sql = "SELECT user_id, name, email, password, role FROM users WHERE user_id = ?";
	        PreparedStatement ps = con.prepareStatement(sql);
	        ps.setInt(1, id);

	        ResultSet rs = ps.executeQuery();
	        if (rs.next()) {
	            user = new User();
	            user.setId(rs.getInt("user_id"));
	            user.setName(rs.getString("name"));
	            user.setEmail(rs.getString("email"));
	            user.setPassword(rs.getString("password"));
	            user.setRole(rs.getInt("role"));
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    } finally {
	        try {
	            if (con != null) con.close();
	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	    }
	    return user;
	}
	public User getUserByEmail(String email) {
	    User user = null;
	    try {
	        creatCon();
	        String sql = "SELECT user_id, name, email, password, role FROM users WHERE email = ?";
	        PreparedStatement ps = con.prepareStatement(sql);
	        ps.setString(1, email);  

	        ResultSet rs = ps.executeQuery();
	        if (rs.next()) {
	            user = new User();
	            user.setId(rs.getInt("user_id"));
	            user.setName(rs.getString("name"));
	            user.setEmail(rs.getString("email"));
	            user.setPassword(rs.getString("password"));
	            user.setRole(rs.getInt("role"));
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    } finally {
	        try {
	            if (con != null) con.close();
	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	    }
	    return user;
	}
	public int insertPublicKey(int userId, String publicKey) {
		try {
			creatCon();
			String sql = "UPDATE users SET public_key = ? WHERE user_id = ?";
			PreparedStatement pr = con.prepareStatement(sql);
			pr.setString(1, publicKey);
			pr.setInt(2, userId);
			int result = pr.executeUpdate();
			con.close();
			return result;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return 0;
	}
	public String getPublicKey(int userId) {
		String publicKey = null;
		try {
			creatCon();
			String sql = "SELECT public_key FROM users WHERE user_id = ?";
			PreparedStatement ps = con.prepareStatement(sql);
			ps.setInt(1, userId);
			ResultSet rs = ps.executeQuery();
			if (rs.next()) {
				publicKey = rs.getString("public_key");
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			try {
				if (con != null) con.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return publicKey;
	}
	public int deletePublicKey(int userId) {
		try {
			creatCon();
			String sql = "UPDATE users SET public_key = NULL WHERE user_id = ?";
			PreparedStatement pr = con.prepareStatement(sql);
			pr.setInt(1, userId);
			int result = pr.executeUpdate();
			con.close();
			return result;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return 0;
	}


}
