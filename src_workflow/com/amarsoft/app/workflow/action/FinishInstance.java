package com.amarsoft.app.workflow.action;

import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.workflow.manager.FlowManager;
import com.amarsoft.are.jbo.JBOTransaction;

/**
 * ��������������ֹ����ӿ�
 * @author ������
 */
public class FinishInstance{
	private String userID;
	private String orgID;
	private String flowSerialNo;
	
	
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



	public String getFlowSerialNo() {
		return flowSerialNo;
	}



	public void setFlowSerialNo(String flowSerialNo) {
		this.flowSerialNo = flowSerialNo;
	}



	public String run(JBOTransaction tx) throws Exception {
		BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager(tx);
		FlowManager fm = FlowManager.getFlowManager(bomanager);
		return fm.finishInstance(flowSerialNo, userID, orgID);
	}
	
}
