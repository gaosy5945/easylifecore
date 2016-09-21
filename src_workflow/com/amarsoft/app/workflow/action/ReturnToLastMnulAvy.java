package com.amarsoft.app.workflow.action;

import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.workflow.manager.FlowManager;
import com.amarsoft.are.jbo.JBOTransaction;

/**
 * ��������������˵�������˹���ӿ�
 * @author ������
 */
public class ReturnToLastMnulAvy{
	private String flowSerialNo;
	private String taskSerialNo;
	private String userID;
	private String orgID;
	
	
	
	public String getFlowSerialNo() {
		return flowSerialNo;
	}



	public void setFlowSerialNo(String flowSerialNo) {
		this.flowSerialNo = flowSerialNo;
	}



	public String getTaskSerialNo() {
		return taskSerialNo;
	}



	public void setTaskSerialNo(String taskSerialNo) {
		this.taskSerialNo = taskSerialNo;
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
		BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager(tx);
		FlowManager fm = FlowManager.getFlowManager(bomanager);
		return fm.returnToLastAvy(taskSerialNo, flowSerialNo, userID, orgID);
	}
	
}
