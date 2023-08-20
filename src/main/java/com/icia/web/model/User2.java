package com.icia.web.model;

import java.io.Serializable;

public class User2 implements Serializable
{
	private static final long serialVersionUID = 1L;
	
	private String userId;
	private String userPwd;
	private String userName;
	private String userEmail;
	private String userHbd;
	private String userPhone;
	private String userAddress;
	private String status;
	private String regDate;
	
	public User2() 
	{
		userId = "";
		userPwd = "";
		userName = "";
		userEmail = "";
		userHbd = "";
		userPhone = "";
		userAddress = "";
		status = "";
		regDate = "";
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getUserPwd() {
		return userPwd;
	}

	public void setUserPwd(String userPwd) {
		this.userPwd = userPwd;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getUserEmail() {
		return userEmail;
	}

	public void setUserEmail(String userEmail) {
		this.userEmail = userEmail;
	}

	public String getUserHbd() {
		return userHbd;
	}

	public void setUserHbd(String userHbd) {
		this.userHbd = userHbd;
	}

	public String getUserPhone() {
		return userPhone;
	}

	public void setUserPhone(String userPhone) {
		this.userPhone = userPhone;
	}

	public String getUserAddress() {
		return userAddress;
	}

	public void setUserAddress(String userAddress) {
		this.userAddress = userAddress;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getRegDate() {
		return regDate;
	}

	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}
}
