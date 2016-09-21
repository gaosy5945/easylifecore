package com.amarsoft.app.als.project;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.StringFunction;

public class UpdateTransferProjectApproveFlag {
	private String serialNo;
	private String flowStatus;
	private String phaseNo;
	private String  taskSerialNo;
	private String flowSerialNo;
	
	public String getPhaseNo() {
		return phaseNo;
	}

	public void setPhaseNo(String phaseNo) {
		this.phaseNo = phaseNo;
	}

	public String getTaskSerialNo() {
		return taskSerialNo;
	}

	public void setTaskSerialNo(String taskSerialNo) {
		this.taskSerialNo = taskSerialNo;
	}

	public String getFlowSerialNo() {
		return flowSerialNo;
	}

	public void setFlowSerialNo(String flowSerialNo) {
		this.flowSerialNo = flowSerialNo;
	}

	public String getFlowStatus() {
		return flowStatus;
	}
	private String phaseType;
	
	public String getPhaseType() {
		return phaseType;
	}

	public void setPhaseType(String phaseType) {
		this.phaseType = phaseType;
	}

	public void setFlowStatus(String flowStatus) {
		this.flowStatus = flowStatus;
	}

	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}
	
	public String update(JBOTransaction tx) throws Exception{				
		BizObjectManager bom = JBOFactory.getBizObjectManager("jbo.prj.PRJ_ASSET_LOG");
		tx.join(bom);
		BizObjectQuery baq = bom.createQuery("SerialNo=:SerialNo");
		baq.setParameter("SerialNo", serialNo);
		BizObject ba = baq.getSingleResult(true);
		BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager();
		BusinessObject newProject = bomanager.loadBusinessObject("jbo.prj.PRJ_BASIC_INFO", "SerialNo",ba.getAttribute("ProjectSerialNo").getString());
		BusinessObject oldProject = bomanager.loadBusinessObject("jbo.prj.PRJ_BASIC_INFO", "SerialNo",ba.getAttribute("ObjectNo").getString());
		
		BusinessObject taskOPbject = bomanager.loadBusinessObject("jbo.flow.FLOW_TASK", "TaskSerialNo",taskSerialNo);
		String phaseActionType = taskOPbject.getString("PHASEACTIONTYPE");
		if(phaseActionType.equals("01")){
			newProject.setAttributeValue("Status", "13");
			oldProject.setAttributeValue("Status", "17");
		}else{
			newProject.setAttributeValue("Status", "14");
		}
		bomanager.updateBusinessObject(oldProject);
		bomanager.updateBusinessObject(newProject);
		bomanager.updateDB();
		bom.saveObject(ba);
		return ba.getAttribute("SerialNo").getString();
	}
}
