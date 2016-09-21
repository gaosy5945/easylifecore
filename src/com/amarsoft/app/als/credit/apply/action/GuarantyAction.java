package com.amarsoft.app.als.credit.apply.action;

import java.sql.SQLException;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.als.guaranty.model.GuarantyFunctions;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

/**
 * @author t-zhangq2
 * 新增担保信息插入APPLY_RELATIVE
 * 删除担保信息及relative
 */
public class GuarantyAction {
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

	public String addApplyRelative(JBOTransaction tx) throws Exception{
		this.tx=tx;
		String applySerialNo = (String)inputParameter.getValue("ApplySerialNo");
		String objectType = (String)inputParameter.getValue("ObjectType");
		String objectNo = (String)inputParameter.getValue("ObjectNo");
		double amount = Double.valueOf((String)inputParameter.getValue("RelativeAmount"));
		String currency = (String)inputParameter.getValue("Currency");
		return this.addApplyRelative(applySerialNo,objectType,objectNo,amount,currency);
	}
	
	public String addApplyRelative(String applySerialNo,String objectType,String objectNo,double amount,String currency) throws Exception{
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		BusinessObject applyRelativeObj = BusinessObject.createBusinessObject("jbo.app.APPLY_RELATIVE");
		applyRelativeObj.setAttributeValue("ApplySerialNo", applySerialNo);
		applyRelativeObj.setAttributeValue("ObjectType", objectType);
		applyRelativeObj.setAttributeValue("ObjectNo", objectNo);
		applyRelativeObj.setAttributeValue("RelativeType", "05");//CodeNo=ApplyRelativeType
		applyRelativeObj.setAttributeValue("RelativeAmount", amount);
		applyRelativeObj.setAttributeValue("Currency", currency);
		applyRelativeObj.generateKey();
		bomanager.updateBusinessObject(applyRelativeObj);
		bomanager.updateDB();
		return "true";
	}
	
	public String deleteGuarantyContract(JBOTransaction tx) throws Exception{
		this.tx = tx;
		String serialNo = (String)inputParameter.getValue("SerialNo");
		String objectType = (String)inputParameter.getValue("ObjectType");
		String objectNo = (String)inputParameter.getValue("ObjectNo");
		return this.deleteGuarantyContract(serialNo, objectType, objectNo);
	}
	
	public String deleteGuarantyContract(String serialNo,String objectType,String objectNo) throws Exception{
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		BusinessObject gc = bomanager.loadBusinessObject("jbo.guaranty.GUARANTY_CONTRACT", serialNo);
		bomanager.deleteBusinessObject(gc);
		
		String[] relativeTables=GuarantyFunctions.getRelativeTable(objectType);
		BusinessObject relativeObj = bomanager.loadBusinessObjects(relativeTables[0], relativeTables[1]+"=:"+relativeTables[1]+" and ObjectType='jbo.guaranty.GUARANTY_CONTRACT' "
				+ "and ObjectNo=:ObjectNo and RelativeType='05' ", relativeTables[1],objectNo,"ObjectNo",serialNo).get(0);
		bomanager.deleteBusinessObject(relativeObj);
		bomanager.updateDB();
		return "true";
	}
	
	public String updateAmount(JBOTransaction tx) throws Exception{
		this.tx = tx;
		String serialNo = (String)inputParameter.getValue("SerialNo");
		String objectType = (String)inputParameter.getValue("ObjectType");
		String objectNo = (String)inputParameter.getValue("ObjectNo");
		double relativeAmount = Double.valueOf((String)inputParameter.getValue("RelativeAmount"));
		return this.updateAmount(serialNo, objectType, objectNo, relativeAmount);
	}
	
	public String updateAmount(String serialNo,String objectType,String objectNo,double amount) throws Exception{
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		String[] relativeTables=GuarantyFunctions.getRelativeTable(objectType);
		BusinessObject bo = bomanager.loadBusinessObjects(relativeTables[0], relativeTables[1]+"=:"+relativeTables[1]+" and ObjectType='jbo.guaranty.GUARANTY_CONTRACT' and "
				+ "ObjectNo=:ObjectNo", relativeTables[1],objectNo,"ObjectNo",serialNo).get(0);
		bo.setAttributeValue("RelativeAmount", amount);
		bomanager.updateBusinessObject(bo);
		bomanager.updateDB();
		return "true";
	}
}