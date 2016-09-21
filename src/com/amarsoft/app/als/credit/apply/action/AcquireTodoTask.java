package com.amarsoft.app.als.credit.apply.action;

import java.sql.SQLException;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

/**
 * @author t-zhangq2
 * 获取电话核查任务、录入抽检任务
 */
public class AcquireTodoTask {
	private JSONObject inputParameter;

	private BusinessObjectManager businessObjectManager;
	
	public void setInputParameter(JSONObject inputParameter) {
		this.inputParameter = inputParameter;
	}
	
	private JBOTransaction tx;

	public void setTx(JBOTransaction tx) {
		this.tx = tx;
	}
	
	public void setBusinessObjectManager(BusinessObjectManager businessObjectManager) {
		this.businessObjectManager = businessObjectManager;
		this.tx = businessObjectManager.getTx();
	}
	
	private BusinessObjectManager getBusinessObjectManager() throws JBOException, SQLException{
		if(businessObjectManager==null)
			businessObjectManager = BusinessObjectManager.createBusinessObjectManager(tx);
		return businessObjectManager;
	}

	/*
	 * 根据当前机构下的申请信息生成需电核的任务PUB_TODO_LIST
	 */
	public String getTask(JBOTransaction tx) throws Exception{
		this.tx=tx;
		String orgID = (String)inputParameter.getValue("OrgID");
		String userID = (String)inputParameter.getValue("UserID");
		String todoType = (String)inputParameter.getValue("TodoType");
		return this.getTask(orgID,userID,todoType);
	}
	
	public String getTask(String orgID,String userID,String todoType) throws Exception{
		BusinessObjectManager bom = this.getBusinessObjectManager();
		List<BusinessObject> baList = bom.loadBusinessObjects("jbo.app.BUSINESS_APPLY", "ApproveStatus in ('01','02') and OperateOrgID like :OrgID ", 
				"OrgID",orgID+"%");
		if(baList == null || baList.size() == 0) return "true";
		for(int i = 0;i< baList.size();i++){
			BusinessObject ba = baList.get(i);
			
			List<BusinessObject> boList = bom.loadBusinessObjects("jbo.app.PUB_TODO_LIST", "TraceObjectType='jbo.app.BUSINESS_APPLY' and "
					+ "TraceObjectNo=:ObjectNo and TodoType=:TodoType ", "ObjectNo",ba.getKeyString(),"TodoType",todoType);			
			if(boList == null || (boList!=null&&boList.isEmpty())){
				BusinessObject todo = BusinessObject.createBusinessObject("jbo.app.PUB_TODO_LIST");
				todo.setAttributeValue("TraceObjectType", "jbo.app.BUSINESS_APPLY");
				todo.setAttributeValue("TraceObjectNo", ba.getKeyString());
				todo.setAttributeValue("TodoType", todoType);
				todo.setAttributeValue("OperateOrgID", orgID);
				todo.setAttributeValue("OperateUserID", userID);
				todo.setAttributeValue("InputDate", DateHelper.getBusinessDate());
				todo.setAttributeValue("Status", "01");
				todo.generateKey();
				bom.updateBusinessObject(todo);
			}
		}
		
		bom.updateDB();
		return "true";
	}
	
	public String submitTask(JBOTransaction tx) throws Exception{
		this.tx=tx;
		String objectType = (String)inputParameter.getValue("ObjectType");
		String objectNo = (String)inputParameter.getValue("ObjectNo");
		String todoType = (String)inputParameter.getValue("TodoType");
		return this.submitTask(objectType,objectNo,todoType);
	}
	
	public String submitTask(String objectType,String objectNo,String todoType) throws Exception{
		BusinessObjectManager bom = this.getBusinessObjectManager();
		List<BusinessObject> boList = bom.loadBusinessObjects("jbo.app.PUB_TODO_LIST", "TraceObjectType='jbo.app.BUSINESS_APPLY' and "
				+ "TraceObjectNo=:ObjectNo and TodoType=:TodoType and Status='01' ", "ObjectNo",objectNo,"TodoType",todoType);
		if(boList == null || boList.size() == 0) throw new Exception("申请"+ objectNo +"的电话核查任务未建立！");
		BusinessObject todo = boList.get(0);
		todo.setAttributeValue("Status", "02");
		bom.updateBusinessObject(todo);
		bom.updateDB();
		return "true";
	}
	
}