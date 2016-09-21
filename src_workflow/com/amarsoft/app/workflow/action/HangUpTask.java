package com.amarsoft.app.workflow.action;

import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.workflow.manager.FlowManager;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * ��������������𲢶�ʱ�ָ�����ӿ�
 * @author ������
 */
public class HangUpTask{
	private String taskSerialNo;
	private String hangUpTime;
	private String userID;
	private String orgID;
	
	
	public String getTaskSerialNo() {
		return taskSerialNo;
	}


	public void setTaskSerialNo(String taskSerialNo) {
		this.taskSerialNo = taskSerialNo;
	}


	public String getHangUpTime() {
		return hangUpTime;
	}


	public void setHangUpTime(String hangUpTime) {
		this.hangUpTime = hangUpTime;
	}


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


	public String run(JBOTransaction tx) throws Exception {
		
		//�������������������ӿ�
		BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager(tx);
		FlowManager fm = FlowManager.getFlowManager(bomanager);
		return fm.hangUpTask(taskSerialNo, hangUpTime, userID, orgID);
	}
	
}
