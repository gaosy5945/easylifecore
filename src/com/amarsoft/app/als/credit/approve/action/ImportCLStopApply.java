package com.amarsoft.app.als.credit.approve.action;

import java.sql.SQLException;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

public class ImportCLStopApply {
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
	
	public String importCOStatus(JBOTransaction tx) throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.cl.CL_OPERATE");
		tx.join(bm);
		
		String CLSerialNo = (String)inputParameter.getValue("CLSerialNo");
		String PreStatus = (String)inputParameter.getValue("PreStatus");
		String InputOrgID = (String)inputParameter.getValue("InputOrgID");
		String InputUserID = (String)inputParameter.getValue("InputUserID");
		String InputDate = (String)inputParameter.getValue("InputDate");
		
		businessObjectManager = this.getBusinessObjectManager();
		BusinessObject clInfo = businessObjectManager.keyLoadBusinessObject("jbo.cl.CL_INFO", CLSerialNo);
		
		BizObject bo = bm.newObject();
		bo.setAttributeValue("CLSERIALNO", CLSerialNo);
		bo.setAttributeValue("OBJECTTYPE", clInfo.getString("ObjectType"));
		bo.setAttributeValue("OBJECTNO", clInfo.getString("ObjectNo"));
		bo.setAttributeValue("OPERATETYPE", "20".equals(PreStatus)?"1":"2");
		bo.setAttributeValue("STATUS", PreStatus);
		bo.setAttributeValue("OPERATEORGID", InputOrgID);
		bo.setAttributeValue("OPERATEUSERID", InputUserID);
		bo.setAttributeValue("OPERATDATE", InputDate);
		bo.setAttributeValue("FLOWTODOSTATUS", "1");
		
		bm.saveObject(bo);
		
		String COSerialNo = bo.getAttribute("SerialNo").toString();
		return "SUCCEED";
	}
}
