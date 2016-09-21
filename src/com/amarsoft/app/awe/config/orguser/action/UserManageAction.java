package com.amarsoft.app.awe.config.orguser.action;

import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

/**
 * ������Ա����
 * @author xhgao
 */
public class UserManageAction {

	private String userID; //�û����
	private String orgID; //�����������
	
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
	 * ������Ա����,�������û������������û�״̬
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
	 * �ӵ�ǰ������ͣ�ø���Ա
	 * @param tx
	 * @return
	 * @throws Exception
	 */
	public String disableUser(JBOTransaction tx) throws Exception{
		//�߼�ɾ���û��������û�״̬��Ϊͣ��
		JBOFactory.getBizObjectManager("jbo.awe.USER_INFO",tx)
		.createQuery("update O set Status = '2' WHERE UserID = :UserID").setParameter("UserID", userID)
		.executeUpdate();
		return "SUCCESS";
	}
	
	/**
	 * �ӵ�ǰ���������ø���Ա
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
