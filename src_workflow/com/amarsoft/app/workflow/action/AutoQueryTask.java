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
public class AutoQueryTask{
	private String flowType;
	private String phaseType;
	private String queryType;
	private String userID;
	private String orgID;
	
	
	
	public String getFlowType() {
		return flowType;
	}



	public void setFlowType(String flowType) {
		this.flowType = flowType;
	}



	public String getPhaseType() {
		return phaseType;
	}



	public void setPhaseType(String phaseType) {
		this.phaseType = phaseType;
	}



	public String getQueryType() {
		return queryType;
	}



	public void setQueryType(String queryType) {
		this.queryType = queryType;
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
		
		
		InputStream in = new ByteArrayInputStream(FlowHelper.getFlowFilter(flowType.replaceAll("@", ","),queryType, phaseType.replaceAll("@", ",")).getBytes());
		Document document = new Document(in);
		in.close();
		
		BusinessObject taskContext = BusinessObject.createBusinessObject(document.getRootElement());
		
		
		in = new ByteArrayInputStream(FlowHelper.getBusinessFilter(flowType.replaceAll("@", ","), queryType, null).getBytes());
		document = new Document(in);
		in.close();
		
		BusinessObject businessContext = BusinessObject.createBusinessObject(document.getRootElement());
		
		BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager(tx);
		FlowManager fm = FlowManager.getFlowManager(bomanager);
		
		return fm.autoGetAvlTask(taskContext, businessContext, false, userID, orgID);
		
	}
	
}
