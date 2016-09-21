package com.amarsoft.app.awe.config.orguser.action;

import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

/**
 * 引入人员操作
 * @author xhgao
 */
public class UserManageAction {

	private String userID; //用户编号
	private String orgID; //归属机构编号
	
	public String getUserID() {
		return userID;
	}
	public void setUserID(String userID) {
		this.userID = userID;
	}
	public String getOrgID() {
		return orgID;
	}
	public void setOrgID(String orgID) {
		this.orgID = orgID;
	}
	
	/**
	 * 引入人员操作,将更新用户归属机构、用户状态
	 * @return SUCCESS
	 * @throws Exception
	 */
	public String addUser(JBOTransaction tx) throws Exception{
		JBOFactory.getBizObjectManager("jbo.awe.USER_INFO",tx)
		.createQuery("update O set BelongOrg = :BelongOrg ,Status ='1' WHERE UserID = :UserID")
		.setParameter("BelongOrg", orgID).setParameter("UserID", userID)
		.executeUpdate();
		return "SUCCESS";
	}
	
	/**
	 * 从当前机构中停用该人员
	 * @param tx
	 * @return
	 * @throws Exception
	 */
	public String disableUser(JBOTransaction tx) throws Exception{
		//逻辑删除用户，即将用户状态置为停用
		JBOFactory.getBizObjectManager("jbo.awe.USER_INFO",tx)
		.createQuery("update O set Status = '2' WHERE UserID = :UserID").setParameter("UserID", userID)
		.executeUpdate();
		return "SUCCESS";
	}
	
	/**
	 * 从当前机构中启用该人员
	 * @param tx
	 * @return
	 * @throws Exception
	 */
	public String enableUser(JBOTransaction tx) throws Exception {
		JBOFactory.getBizObjectManager("jbo.awe.USER_INFO",tx)
		.createQuery("update O set  Status = '1' WHERE UserID = :UserID").setParameter("UserID", userID)
		.executeUpdate();

		return "SUCCESS";
	}
}
