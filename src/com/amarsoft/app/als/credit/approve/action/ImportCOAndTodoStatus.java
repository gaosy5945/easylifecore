package com.amarsoft.app.als.credit.approve.action;

import java.sql.SQLException;

import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

public class ImportCOAndTodoStatus {
	private JSONObject inputParameter;

	private BusinessObjectManager businessObjectManager;
	
	public void setInputParameter(JSONObject inputParameter) {
		this.inputParameter = inputParameter;
	}
	
	public void setInputParameter(String key,Object value) {
		if(this.inputParameter == null)
			inputParameter = JSONObject.createObject();
		com.amarsoft.are.lang.Element a = new com.amarsoft.are.util.json.JSONElement(key);
		a.setValue(value);
		inputParameter.add(a);
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
	public String importCOAndTodoStatus(JBOTransaction tx) throws Exception{
		this.tx = tx;
		String CLSerialNo = (String)inputParameter.getValue("CLSerialNo");
		String TodoType = (String)inputParameter.getValue("TodoType");
		String OperateType = (String)inputParameter.getValue("OperateType");
		String Reason = (String)inputParameter.getValue("Reason");
		String PreStatus = (String)inputParameter.getValue("PreStatus");
		String OperateOrgID = (String)inputParameter.getValue("OperateOrgID");
		String OperateUserID = (String)inputParameter.getValue("OperateUserID");
		String InputOrgID = (String)inputParameter.getValue("InputOrgID");
		String InputUserID = (String)inputParameter.getValue("InputUserID");
		String InputDate = (String)inputParameter.getValue("InputDate");
		
		String result = importCOStatus(CLSerialNo,OperateType,Reason,PreStatus,InputOrgID,InputUserID,InputDate);
		String COSerialNo = result.split("@")[1];
		importTodoStatus(COSerialNo,TodoType,OperateOrgID,OperateUserID,InputOrgID,InputUserID,InputDate);
		
		return "SUCCEED";
	}
	
	public String importCOStatus(String CLSerialNo,String OperateType,String Reason,String PreStatus,String InputOrgID,String InputUserID,String InputDate) throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.cl.CL_OPERATE");
		tx.join(bm);
		
		BizObject bo = bm.newObject();
		bo.setAttributeValue("CLSERIALNO", CLSerialNo);
		bo.setAttributeValue("OPERATETYPE", OperateType);
		bo.setAttributeValue("REASON", Reason);
		bo.setAttributeValue("STATUS", PreStatus);
		bo.setAttributeValue("OPERATEORGID", InputOrgID);
		bo.setAttributeValue("OPERATEUSERID", InputUserID);
		bo.setAttributeValue("OPERATDATE", InputDate);
		
		bm.saveObject(bo);
		
		String COSerialNo = bo.getAttribute("SerialNo").toString();
		return "SUCCEED@"+COSerialNo;
	}
	
	public String importTodoStatus(String COSerialNo,String TodoType,String OperateOrgID,String OperateUserID,String InputOrgID,String InputUserID,String InputDate) throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.app.PUB_TODO_LIST");
		tx.join(bm);
		
		BizObject bo = bm.newObject();
		bo.setAttributeValue("TRACEOBJECTTYPE", "jbo.cl.CL_OPERATE");
		bo.setAttributeValue("TRACEOBJECTNO", COSerialNo);
		bo.setAttributeValue("TODOTYPE", TodoType);
		bo.setAttributeValue("STATUS", "01");
		bo.setAttributeValue("OPERATEORGID", OperateOrgID);
		bo.setAttributeValue("OPERATEUSERID", OperateUserID);
		bo.setAttributeValue("INPUTDATE", InputDate);
		bo.setAttributeValue("INPUTORGID", InputOrgID);
		bo.setAttributeValue("INPUTUSERID", InputUserID);
		
		bm.saveObject(bo);
		return "SUCCEED";
	}
}
