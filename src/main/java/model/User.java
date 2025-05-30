package model;

import java.util.Date;

import org.mindrot.jbcrypt.BCrypt;

public class User {
	private int id;
	private String name;
	private String email;
	private String password;
	private Date createdAt;
	private int role;

	public User(int id, String name, String email, String password, Date createdAt) {
		this.id = id;
		this.name = name;
		this.email = email;
		this.password = password;
		this.createdAt = createdAt;
	}
	public User() {};
	public User(String name, String email, String passwordHash, int role) {
		super();
		this.name = name;
		this.email = email;
		this.password = passwordHash;
		this.role = role;
	}
	public User(String name, String email, String passwordHash) {
		super();
		this.name = name;
		this.email = email;
		this.password = passwordHash;
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

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
	    this.password = BCrypt.hashpw(password, BCrypt.gensalt());
	}
	public Date getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(Date createdAt) {
		this.createdAt = createdAt;
	}
	public int getRole() {
	    return this.role; 
	}

    public void setRole(int role) {
        this.role = role;
    }
	@Override
	public String toString() {
		return id + "\t" + name + "\t" + email + "\t" + password + "\t" + createdAt + "\t" + role ;
	}

}
