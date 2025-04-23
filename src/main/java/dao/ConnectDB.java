package dao;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.SQLException;

import com.mysql.jdbc.Driver;

public class ConnectDB {
	

	public static Connection getConnection() {
		Connection c=null;

		try {
			DriverManager.registerDriver(new com.mysql.jdbc.Driver());
			String url = "jdbc:mysql://localhost:3306/booking?useUnicode=true&characterEncoding=UTF-8";
			String username = "root";
			String password = "";
			c = DriverManager.getConnection(url, username, password);
		} catch (SQLException e) {
			e.printStackTrace();
		}

		return c;
	}

	public static void closeConnection(Connection c) {
		try {
			if (c != null) {
				c.close();
				System.out.println("Kết nối đã đóng!");
			}
		} catch (SQLException e) {
			System.out.println("Lỗi khi đóng kết nối!");
			e.printStackTrace();
		}
	}

	public static void printInfo(Connection c) {
		try {
			if (c != null) {
				DatabaseMetaData metaData = c.getMetaData();
				System.out.println("Database Product Name: " + metaData.getDatabaseProductName());
				System.out.println("Database Version: " + metaData.getDatabaseProductVersion());
			} else {
				System.out.println("Connection is null, cannot retrieve metadata.");
			}
		} catch (SQLException e) {
			System.out.println("Error retrieving database metadata!");
			e.printStackTrace();
		}
	}

	public static void main(String[] args) {
		ConnectDB db = new ConnectDB();
		db.getConnection();
		db.printInfo(getConnection());
	}
}
