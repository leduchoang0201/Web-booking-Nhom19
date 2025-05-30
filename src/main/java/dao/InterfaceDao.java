package dao;

import java.util.List;

import model.Room;

public interface InterfaceDao<T> {
	public int insert(T t);
	public int delete(int id);
	public int update(T t);
	public List<T> getAll();
}
