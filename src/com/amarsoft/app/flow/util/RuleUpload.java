package com.amarsoft.app.flow.util;

import java.sql.SQLException;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;


import com.amarsoft.app.als.prd.config.loader.ProductConfig;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
/**
 * 
 * @author T-zhangwl
 * 功能：授权用户时插入数据到数据库
 */
public class RuleUpload {
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

	public String addUser(JBOTransaction tx) throws Exception{
		this.tx=tx;
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		BusinessObject ci = BusinessObject.createBusinessObject("jbo.flow.FLOW_AUTHORIZE_OBJECT");
		ci.setAttributeValue("AuthObjectType", "jbo.sys.USER_INFO");
		ci.setAttributeValue("Status", "1");
		ci.setAttributeValue("AuthObjectNo", (String)inputParameter.getValue("UserID"));
		ci.setAttributeValue("AuthSerialNo", (String)inputParameter.getValue("SerialNo"));
		ci.setAttributeValue("InputOrgID", (String)inputParameter.getValue("InputOrgID"));
		ci.setAttributeValue("InputUserID", (String)inputParameter.getValue("InputUserID"));
		ci.setAttributeValue("InputDate", DateHelper.getBusinessDate());
		ci.generateKey();
		bomanager.updateBusinessObject(ci);
		bomanager.updateDB();
		return "true";
	}
	public String addTeam(JBOTransaction tx) throws Exception{
		this.tx=tx;
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		BusinessObject ci = BusinessObject.createBusinessObject("jbo.flow.FLOW_AUTHORIZE_OBJECT");
		ci.setAttributeValue("AuthObjectType", "jbo.flow.TEAM_INFO");
		ci.setAttributeValue("Status", "1");
		ci.setAttributeValue("AuthObjectNo", (String)inputParameter.getValue("TeamID"));
		ci.setAttributeValue("AuthSerialNo", (String)inputParameter.getValue("SerialNo"));
		ci.setAttributeValue("InputOrgID", (String)inputParameter.getValue("InputOrgID"));
		ci.setAttributeValue("InputUserID", (String)inputParameter.getValue("InputUserID"));
		ci.setAttributeValue("InputDate", DateHelper.getBusinessDate());
		ci.generateKey();
		bomanager.updateBusinessObject(ci);
		bomanager.updateDB();
		return "true";
	}
	
}