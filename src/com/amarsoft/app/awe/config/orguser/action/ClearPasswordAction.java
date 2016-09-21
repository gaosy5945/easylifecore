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
		if(initPwd == null) initPwd = "000000als"; //Ĭ�ϵĳ�ʼ������
		return initPwd;
	}
	public void setInitPwd(String initPwd) {
		this.initPwd = initPwd;
	}
	public String initPWD(JBOTransaction tx) {
		try{
			//�Գ�ʼ���������MD5����
			String sPassword = MessageDigest.getDigestAsUpperHexString("MD5", initPwd);
			
			//��ָ���û����������Ϊ��ʼ����
			JBOFactory.getBizObjectManager("jbo.awe.USER_INFO",tx)
			.createQuery("update O  set Password = :Password where UserID = :UserID ")
			.setParameter("UserID", userID).setParameter("Password", sPassword)
			.executeUpdate();
			return "SUCCESS";
		} catch (Exception e) {
			ARE.getLog().debug("��ʼ����ʧ�ܣ�");
			return "FAILED";
		}
	}
}
