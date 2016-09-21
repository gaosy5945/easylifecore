package com.amarsoft.app.als.awe.script;

import java.sql.SQLException;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.util.ASUserObject;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.json.JSONObject;

public class WebBusinessProcessor {
	protected JSONObject inputParameter;
	private BusinessObjectManager businessObjectManager;
	private JBOTransaction tx;
	private String errors;
	
	/**
	 * @param inputParameter
	 */
	public void setInputParameter(JSONObject inputParameter) {
		this.inputParameter = inputParameter;
	}
	
	
	public void setInputParameter(String name,Object value){
		if(this.inputParameter == null)
			inputParameter = JSONObject.createObject();
		com.amarsoft.are.lang.Element a = new com.amarsoft.are.util.json.JSONElement(name);
		a.setValue(value);
		inputParameter.add(a);
	}
	
	/**
	 * @param tx
	 */
	public void setTx(JBOTransaction tx) {
		this.tx = tx;
	}
	
	/**
	 * @param businessObjectManager
	 */
	public void setBusinessObjectManager(BusinessObjectManager businessObjectManager) {
		this.businessObjectManager = businessObjectManager;
		this.tx = businessObjectManager.getTx();
	}
	
	/**
	 * @return
	 * @throws JBOException
	 * @throws SQLException
	 */
	public BusinessObjectManager getBusinessObjectManager() throws JBOException, SQLException{
		if(businessObjectManager==null)
			businessObjectManager = BusinessObjectManager.createBusinessObjectManager(tx);
		return businessObjectManager;
	}
	
	public String getStringValue(String inputParameterID) {
		String value=(String)inputParameter.getValue(inputParameterID);
		if(!StringX.isEmpty(value)) value = value.trim();
		return value;
	}
	
	public String getSystemParameter(String inputParameterID) throws Exception{
		BusinessObject inputParameters=this.getInputParameters();
		BusinessObject systemParameters=inputParameters.getBusinessObject("SystemParameters");
		String value=systemParameters.getString(inputParameterID);
		return value;
	}
	
	public ASUserObject getCurUser() throws Exception{
		String userID = this.getSystemParameter("CurUserID");
		ASUserObject curUser = ASUserObject.getUser(userID);
		return curUser;
	}
	
	/**
	 * @return
	 * @throws Exception
	 */
	public BusinessObject getInputParameters() throws Exception {
		return BusinessObject.createBusinessObject(this.inputParameter);
	}

	public String getErrors() {
		return errors;
	}

	public void setErrors(String errors) {
		this.errors = errors;
	}
}
