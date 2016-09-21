package com.amarsoft.app.workflow.action;


import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.workflow.manager.FlowManager;
import com.amarsoft.are.jbo.JBOTransaction;
/**
 * 
 * @author T-zhangwl
 *功能：复议时复制有关信息和启动申请流程
 */
public class QueryFlowContext{
	private String objectType;
	private String objectNo;
	private String userID;
	private String orgID;
	
	
	public String getObjectType() {
		return objectType;
	}

	public void setObjectType(String objectType) {
		this.objectType = objectType;
	}

	public String getObjectNo() {
		return objectNo;
	}

	public void setObjectNo(String objectNo) {
		this.objectNo = objectNo;
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

	public String run(JBOTransaction tx) throws Exception{	
		BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager(tx);
		FlowManager fm = FlowManager.getFlowManager(bomanager);
		BusinessObject fo = bomanager.loadBusinessObjects("jbo.flow.FLOW_OBJECT", "ObjectType=:ObjectType and ObjectNo=:ObjectNo", "ObjectType",objectType,"ObjectNo",objectNo).get(0);
		
		BusinessObject fi = fm.queryInstance(fo.getString("FlowSerialNo"), userID, orgID);

		
		return "true@"+fi.getString("ApplyType")+"@"+fo.getString("FlowNo")+"@"+fo.getString("FlowSerialNo");
	}

}
