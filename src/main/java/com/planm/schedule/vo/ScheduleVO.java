package com.planm.schedule.vo;

public class ScheduleVO {
	private String schno;
	private String userid;
	private String title;
	private String schContent;
	private String schType;
	private String startdt;
	private String enddt;
	private String bgColor;
	private String txtColor;	
	private String allDay;
	
	public String getSchno() {
		return schno;
	}
	public void setSchno(String schno) {
		this.schno = schno;
	}
	public String getUserid() {
		return userid;
	}
	public void setUserid(String userid) {
		this.userid = userid;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getSchContent() {
		return schContent;
	}
	public void setSchContent(String schContent) {
		this.schContent = schContent;
	}
	public String getStartdt() {
		return startdt;
	}
	public void setStartdt(String startdt) {
		this.startdt = startdt;
	}
	public String getEnddt() {
		return enddt;
	}
	public void setEnddt(String enddt) {
		this.enddt = enddt;
	}
	public String getSchType() {
		return schType;
	}
	public void setSchType(String schType) {
		this.schType = schType;
	}
	public String getBgColor() {
		return bgColor;
	}
	public void setBgColor(String bgColor) {
		this.bgColor = bgColor;
	}
	public String getTxtColor() {
		return txtColor;
	}
	public void setTxtColor(String txtColor) {
		this.txtColor = txtColor;
	}
	public String getAllDay() {
		return allDay;
	}
	public void setAllDay(String allDay) {
		this.allDay = allDay;
	}

}
