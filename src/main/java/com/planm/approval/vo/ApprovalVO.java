package com.planm.approval.vo;

public class ApprovalVO {

	private String docno;	
	private String doctype;
	private String cmpcd;
	private String usercd;
	private String requestymd;	
	private String docstatus;	
	private String signline;
	private String signymd;
	private String returncause;
	private int seq;
	private String signuser;
	
	public String getReturncause() {
		return returncause;
	}
	public void setReturncause(String returncause) {
		this.returncause = returncause;
	}
	public String getSignline() {
		return signline;
	}
	public void setSignline(String signline) {
		this.signline = signline;
	}
	public String getCmpcd() {
		return cmpcd;
	}
	public void setCmpcd(String cmpcd) {
		this.cmpcd = cmpcd;
	}
	public String getDocno() {
		return docno;
	}
	public void setDocno(String docno) {
		this.docno = docno;
	}
	public String getDoctype() {
		return doctype;
	}
	public void setDoctype(String doctype) {
		this.doctype = doctype;
	}
	public String getUsercd() {
		return usercd;
	}
	public void setUsercd(String usercd) {
		this.usercd = usercd;
	}
	public String getRequestymd() {
		return requestymd;
	}
	public void setRequestymd(String requestymd) {
		this.requestymd = requestymd;
	}	
	public String getDocstatus() {
		return docstatus;
	}
	public void setDocstatus(String docstatus) {
		this.docstatus = docstatus;
	}
	public String getSignymd() {
		return signymd;
	}
	public void setSignymd(String signymd) {
		this.signymd = signymd;
	}
	public int getSeq() {
		return seq;
	}
	public void setSeq(int seq) {
		this.seq = seq;
	}
	public String getSignuser() {
		return signuser;
	}
	public void setSignuser(String signuser) {
		this.signuser = signuser;
	}
	
}
