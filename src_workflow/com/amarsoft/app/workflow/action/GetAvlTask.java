package com.amarsoft.app.workflow.action;


import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.workflow.manager.FlowManager;
import com.amarsoft.are.jbo.JBOTransaction;

/**
 * 调用流程引擎获取任务接口
 * @author 赵晓建
 */
public class GetAvlTask{
	private String taskSerialNo;
	private String userID;
	private String orgID;
	
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
		return fm.getAvlTask(taskSerialNo, userID, orgID);
	}
}
