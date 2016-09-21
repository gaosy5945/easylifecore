package com.amarsoft.app.awe.config.orguser.action;

import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.security.MessageDigest;

public class ClearPasswordAction {
	
	private String userID;
	private String initPwd;
	
    public String getUserID() {
		return userID;
	}
	public void setUserID(String userID) {
		this.userID = userID;
	}
	
	public String getInitPwd() {
		if(initPwd == null) initPwd = "000000als"; //默认的初始化密码
		return initPwd;
	}
	public void setInitPwd(String initPwd) {
		this.initPwd = initPwd;
	}
	public String initPWD(JBOTransaction tx) {
		try{
			//对初始化密码进行MD5加密
			String sPassword = MessageDigest.getDigestAsUpperHexString("MD5", initPwd);
			
			//将指定用户的密码更新为初始密码
			JBOFactory.getBizObjectManager("jbo.awe.USER_INFO",tx)
			.createQuery("update O  set Password = :Password where UserID = :UserID ")
			.setParameter("UserID", userID).setParameter("Password", sPassword)
			.executeUpdate();
			return "SUCCESS";
		} catch (Exception e) {
			ARE.getLog().debug("初始密码失败！");
			return "FAILED";
		}
	}
}
