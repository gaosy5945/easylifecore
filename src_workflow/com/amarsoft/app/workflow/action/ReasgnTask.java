package com.amarsoft.app.workflow.action;


import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.workflow.manager.FlowManager;
import com.amarsoft.are.jbo.JBOTransaction;


/**
 * 调用流程引擎改派任务接口
 * @author 张万亮
 */
public class ReasgnTask{
	private String taskSerialNo;
	private String reasgnUserID;
	private String reasgnOrgID;
	private String reason;
	private String userID;
	private String orgID;
	
	
	
	public String getTaskSerialNo() {
		return taskSerialNo;
	}



	public void setTaskSerialNo(String taskSerialNo) {
		this.taskSerialNo = taskSerialNo;
	}



	public String getReasgnUserID() {
		return reasgnUserID;
	}



	public void setReasgnUserID(String reasgnUserID) {
		this.reasgnUserID = reasgnUserID;
	}



	public String getReasgnOrgID() {
		return reasgnOrgID;
	}



	public void setReasgnOrgID(String reasgnOrgID) {
		this.reasgnOrgID = reasgnOrgID;
	}



	public String getReason() {
		return reason;
	}



	public void setReason(String reason) {
		this.reason = reason;
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
		return fm.reasgnTask(taskSerialNo, reasgnUserID, reasgnOrgID, reason, userID, orgID);
	}
	
}
