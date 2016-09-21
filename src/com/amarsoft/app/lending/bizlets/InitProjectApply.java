package com.amarsoft.app.lending.bizlets;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.app.workflow.config.FlowConfig;
import com.amarsoft.app.workflow.manager.FlowManager;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

public class InitProjectApply{
	
	private String userID;
	private String orgID;
	private String serialNo;
	private String customerID;
	private String projectType;
	private String applyType;
	private String listType;
	private String projectName;
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

	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}

	public String getCustomerID() {
		return customerID;
	}

	public void setCustomerID(String customerID) {
		this.customerID = customerID;
	}

	public String getProjectType() {
		return projectType;
	}

	public void setProjectType(String projectType) {
		this.projectType = projectType;
	}

	public String getApplyType() {
		return applyType;
	}

	public void setApplyType(String applyType) {
		this.applyType = applyType;
	}
	public String getListType() {
		return listType;
	}

	public void setListType(String listType) {
		this.listType = listType;
	}
	
	public String getProjectName() {
		return projectName;
	}

	public void setProjectName(String projectName) {
		this.projectName = projectName;
	}

	public String initProjectApply(JBOTransaction tx) throws Exception {
		String objectType = "jbo.prj.PRJ_BASIC_INFO";
		BizObjectManager pbm = JBOFactory.getBizObjectManager(objectType);
		tx.join(pbm);	
		BusinessObject apply = BusinessObject.createBusinessObject();
		apply.setAttributeValue("UserID", userID) ;
		apply.setAttributeValue("OrgID", orgID) ;
		apply.setAttributeValue("SerialNo", serialNo) ;
		apply.setAttributeValue("CustomerID", customerID) ;
		apply.setAttributeValue("ProjectType", projectType) ;
		apply.setAttributeValue("ApplyType", applyType) ;
		apply.setAttributeValue("ListType", listType) ;
		apply.setAttributeValue("ProjectName", projectName) ;
		BizObject bo = null;
		if(serialNo == null || "".equals(serialNo.trim()))
		{
			bo = pbm.newObject();
			bo.setAttributeValue("InputDate", DateHelper.getBusinessDate());
			bo.setAttributeValue("CustomerID", customerID);
			bo.setAttributeValue("InputUserID", userID);
			bo.setAttributeValue("InputOrgID", orgID);					
			bo.setAttributeValue("ProjectType", projectType);
			bo.setAttributeValue("ProjectName", projectName) ;
			bo.setAttributeValue("Status", "11");
			pbm.saveObject(bo);
			serialNo = bo.getAttribute(0).getString();
			bo.setAttributeValue("AgreementNo", serialNo);
			pbm.saveObject(bo);
		}else{
			BizObjectQuery bcq = pbm.createQuery("SerialNo=:SerialNo");
			bcq.setParameter("SerialNo", serialNo);
			BizObject bo1 = bcq.getSingleResult(true);
			
			bo1.setAttributeValue("CustomerID", customerID);				
			bo1.setAttributeValue("ProjectType", projectType);
			bo1.setAttributeValue("ProjectName", projectName) ;
			pbm.saveObject(bo1);
		}
		
		List<BusinessObject> objects = new ArrayList<BusinessObject>();
		objects.add(BusinessObject.convertFromBizObject(bo));
		
		String flowNo = "ProjectFlow";
		String flowVersion = FlowConfig.getFlowDefaultVersion(flowNo);
		BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager(tx);
		FlowManager fm = FlowManager.getFlowManager(bomanager);
		String result = fm.createInstance(objectType, objects, flowNo, userID, orgID, apply);
		
		String instanceID = result.split("@")[0];
		String phaseNo = result.split("@")[1];
		String taskSerialNo = result.split("@")[2];
		String functionID = FlowConfig.getFlowPhase(flowNo, flowVersion, phaseNo).getString("FunctionID");
	
		return "true@"+serialNo +"@"+customerID+"@"+functionID+"@"+instanceID+"@"+taskSerialNo+"@"+phaseNo+"@新增成功！";
    } 
}
