package com.amarsoft.app.awe.config.role.action;

import com.amarsoft.app.als.sys.tools.SystemConst;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;

/**
 * 主页修改用户信息Action
 * 
 * @author zqzeng
 * @since 2012-11-15
 */
public class ChangeUserInfoAction {
	
	private String userID;
	private String phoneNum;
	private String emailAddress;
	
	public String getUserID() {
		return userID;
	}

	public void setUserID(String userID) {
		this.userID = userID;
	}

	public String getPhoneNum() {
		return phoneNum;
	}

	public void setPhoneNum(String phoneNum) {
		this.phoneNum = phoneNum;
	}

	public String getEmailAddress() {
		return emailAddress;
	}

	public void setEmailAddress(String emailAddress) {
		this.emailAddress = emailAddress;
	}

	/**
	 * 更新用户信息
	 * 
	 * @throws JBOException
	 * 
	 * @return 
	 */
	public String changeUserInfo() throws JBOException {
		String rs = "F";
		BizObjectManager bom = JBOFactory.getBizObjectManager(SystemConst.JAVA_USER_INFO);
		BizObject bo = bom.createQuery("USERID=:USERID").setParameter("USERID", userID).getSingleResult(true);
		if(bo != null){
			bo.setAttributeValue("MOBILETEL",phoneNum);
			bo.setAttributeValue("EMAIL",emailAddress);
			bom.saveObject(bo);
			rs = "T";
		}
		return rs;
	}

}