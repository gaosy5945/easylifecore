package com.amarsoft.app.als.credit.apply.action;

import java.sql.SQLException;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

/**
 * @author t-zhangq2
 * 
 * 
 */
public class InitApplyObjects {
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

	public String initFineRate(JBOTransaction tx) throws Exception{
		this.tx=tx;
		String objectType = (String)inputParameter.getValue("ObjectType");
		String objectNo = (String)inputParameter.getValue("ObjectNo");
		String compID = (String)inputParameter.getValue("ComponentID");
		return this.initFineRate(objectType,objectNo,compID);
	}
	
	//´ýÍêÉÆ
	public String initFineRate(String objectType,String objectNo,String compID) throws Exception{
		BusinessObjectManager bom = this.getBusinessObjectManager();
		//ÅÐ¶ÏÊÇ·ñ´æÔÚ³åÍ»µÄ·£Ï¢
		/*List<BusinessObject> tempList = bom.loadBusinessObjects("jbo.acct.ACCT_RATE_SEGMENT", "ObjectType=:ObjectType "
				+ "and ObjectNo=:ObjectNo and RateTermID=:CompID and Status='1' ", "ObjectType",objectType,"ObjectNo",objectNo,"CompID",compID);*/
		
		BusinessObject rate = BusinessObject.createBusinessObject("jbo.acct.ACCT_RATE_SEGMENT");
		rate.setAttributeValue("RateTermID", compID);
		rate.setAttributeValue("ObjectType", objectType);
		rate.setAttributeValue("ObjectNo", objectNo);
		rate.setAttributeValue("Status", "1");
		rate.setAttributeValue("RateType", "03");
		rate.generateKey();
		
		bom.updateBusinessObject(rate);
		bom.updateDB();
		return "true";
	}
	
}