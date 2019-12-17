package com.example.domain;

public class WeatherVO {
	private String date;
	private String region;
	private String icon;
	private String hightemp;
	private String lowtemp;
	private String wcondition;
	private String Mhumid; //오전 강수확률
	private String Ahumid; //오후 강수확률
	
	public String getDate() {
		return date;
	}
	public void setDate(String date) {
		this.date = date;
	}
	public String getRegion() {
		return region;
	}
	public void setRegion(String region) {
		this.region = region;
	}
	public String getIcon() {
		return icon;
	}
	public void setIcon(String icon) {
		this.icon = icon;
	}
	

	public String getHightemp() {
		return hightemp;
	}
	public void setHightemp(String hightemp) {
		this.hightemp = hightemp;
	}
	public String getLowtemp() {
		return lowtemp;
	}
	public void setLowtemp(String lowtemp) {
		this.lowtemp = lowtemp;
	}
	public String getWcondition() {
		return wcondition;
	}
	public void setWcondition(String wcondition) {
		this.wcondition = wcondition;
	}
	public String getMhumid() {
		return Mhumid;
	}
	public void setMhumid(String mhumid) {
		Mhumid = mhumid;
	}
	public String getAhumid() {
		return Ahumid;
	}
	public void setAhumid(String ahumid) {
		Ahumid = ahumid;
	}
	@Override
	public String toString() {
		return "WeatherVO [date=" + date + ", region=" + region + ", icon=" + icon + ", hightemp=" + hightemp
				+ ", lowtemp=" + lowtemp + ", wcondition=" + wcondition + ", Mhumid=" + Mhumid + ", Ahumid=" + Ahumid
				+ "]";
	}
	
	
	
	
	
}
