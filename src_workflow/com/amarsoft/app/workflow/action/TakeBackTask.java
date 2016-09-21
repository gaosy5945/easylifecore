package com.amarsoft.app.workflow.action;

import java.io.ByteArrayInputStream;
import java.io.InputStream;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.workflow.manager.FlowManager;
import com.amarsoft.app.workflow.util.FlowHelper;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.xml.Document;

/**
 * 删除指定对象主信息和其关联信息，并将其关联流程信息也删除
 * @author 赵晓建
 */
public class TakeBackTask{
	private String flowSerialNo;
	private String taskSerialNo;
	private String phaseNo;
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



	public String getPhaseNo() {
		return phaseNo;
	}



	public void setPhaseNo(String phaseNo) {
		this.phaseNo = phaseNo;
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
		
		return fm.whdrwlTask(taskSerialNo, userID, orgID);
		
	}
	
}
