package com.amarsoft.app.workflow.action;

import java.util.Date;

import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.app.workflow.manager.FlowManager;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.DateX;

/**
 * 调用流程引擎恢复任务接口
 * @author 张万亮
 */
public class ResumeTask{
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
		
		//调用流程引擎挂起任务接口
		BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager(tx);
		FlowManager fm = FlowManager.getFlowManager(bomanager);
		return fm.resumeTask(taskSerialNo, DateHelper.getBusinessDate()+" "+DateX.format(new Date(),DateHelper.AMR_NOMAL_FULLTIME_FORMAT), userID, orgID);
	}
	
}
