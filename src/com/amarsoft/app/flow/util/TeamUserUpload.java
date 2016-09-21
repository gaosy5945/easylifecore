package com.amarsoft.app.flow.util;

import java.sql.SQLException;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;
/**
 * 功能：添加团队成员
 * @author T-zhangwl
 *
 */

public class TeamUserUpload {
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

		BusinessObject ci = BusinessObject.createBusinessObject("jbo.flow.TEAM_USER");
		ci.setAttributeValue("TeamID", (String)inputParameter.getValue("TeamID"));
		ci.setAttributeValue("UserID", (String)inputParameter.getValue("UserID"));
		ci.setAttributeValue("InputOrgID", (String)inputParameter.getValue("InputOrgID"));
		ci.setAttributeValue("InputUserID", (String)inputParameter.getValue("InputUserID"));
		ci.setAttributeValue("InputTime", com.amarsoft.app.base.util.DateHelper.getBusinessDate());
		ci.generateKey();
		String userID = ci.getKeyString();
		bomanager.updateBusinessObject(ci);
		bomanager.updateDB();
		
		return "true@"+userID;
	}
}