package com.example.domain;

public class CampVO {
	private int id;
	private String title;
	private String address;
	private String phone;
	
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	
	
	@Override
	public String toString() {
		return "CampVO [id=" + id + ", title=" + title + ", address=" + address + ", phone=" + phone + "]";
	}
	
	
}
