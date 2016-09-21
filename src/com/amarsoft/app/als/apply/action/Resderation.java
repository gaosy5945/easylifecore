package com.amarsoft.app.als.apply.action;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.workflow.config.FlowConfig;
import com.amarsoft.app.workflow.manager.FlowManager;
import com.amarsoft.are.jbo.JBOTransaction;
/**
 * 
 * @author T-zhangwl
 *功能：复议时复制有关信息和启动申请流程
 */
public class Resderation{
	private String applySerialNo;
	private String oldApplySerialNo;
	private String userID;
	private String orgID;
	
	
	
	public String getApplySerialNo() {
		return applySerialNo;
	}



	public void setApplySerialNo(String applySerialNo) {
		this.applySerialNo = applySerialNo;
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



	public String getOldApplySerialNo() {
		return oldApplySerialNo;
	}



	public void setOldApplySerialNo(String oldApplySerialNo) {
		this.oldApplySerialNo = oldApplySerialNo;
	}



	public String run(JBOTransaction tx) throws Exception{	
		BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager(tx);
		String objectType = "jbo.app.BUSINESS_APPLY";
		BusinessObject ba = bomanager.keyLoadBusinessObject(objectType, applySerialNo);
		ba.setAttributeValue("ApproveStatus", "02");
		bomanager.updateBusinessObject(ba);
		
		List<BusinessObject> objects = new ArrayList<BusinessObject>();
		objects.add(ba);
		
		BusinessObject fo = bomanager.loadBusinessObjects("jbo.flow.FLOW_OBJECT", "ObjectType=:ObjectType and ObjectNo=:ObjectNo", "ObjectType",objectType,"ObjectNo",oldApplySerialNo).get(0);
		
		
		String flowNo = fo.getString("FlowNo");
		String flowVersion = FlowConfig.getFlowDefaultVersion(flowNo);
		
		FlowManager fm = FlowManager.getFlowManager(bomanager);
		BusinessObject fi = fm.queryInstance(fo.getString("FlowSerialNo"), flowNo, flowVersion);
		String result = fm.createInstance(objectType, objects, flowNo, userID, orgID, fi);
		
		String instanceID = result.split("@")[0];
		String phaseNo = result.split("@")[1];
		String taskSerialNo = result.split("@")[2];
		
		String functionID = FlowConfig.getFlowPhase(flowNo, flowVersion, phaseNo).getString("FunctionID");
		
		bomanager.updateDB();
		return "true@"+applySerialNo +"@"+functionID+"@"+instanceID+"@"+taskSerialNo+"@"+phaseNo+"@复议成功，请在待处理任务中修改相关信息并提交！";
	}

}
