package com.amarsoft.app.als.credit.putout.action;

import java.sql.SQLException;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.json.JSONObject;

public class DeletePutOut {
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

	public String deletePutOut(JBOTransaction tx) throws Exception{
		this.tx=tx;
		String serialNo = (String)inputParameter.getValue("SerialNo");
		return this.delete(serialNo);
	}
	
	public String delete(String serialNo) throws Exception{
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		String objectType = "jbo.app.BUSINESS_PUTOUT";
		BusinessObject putout = bomanager.keyLoadBusinessObject(objectType, serialNo);
		List<BusinessObject> accountList = bomanager.loadBusinessObjects("jbo.acct.ACCT_BUSINESS_ACCOUNT", "ObjectType=:ObjectType and ObjectNo=:ObjectNo","ObjectType", objectType,"ObjectNo", serialNo);
		List<BusinessObject> rptList = bomanager.loadBusinessObjects("jbo.acct.ACCT_RPT_SEGMENT", "ObjectType=:ObjectType and ObjectNo=:ObjectNo","ObjectType", objectType,"ObjectNo", serialNo);
		List<BusinessObject> rateList = bomanager.loadBusinessObjects("jbo.acct.ACCT_RATE_SEGMENT", "ObjectType=:ObjectType and ObjectNo=:ObjectNo","ObjectType", objectType,"ObjectNo", serialNo);
		List<BusinessObject> feeList = bomanager.loadBusinessObjects("jbo.acct.ACCT_FEE", "ObjectType=:ObjectType and ObjectNo=:ObjectNo","ObjectType", objectType,"ObjectNo", serialNo);
		
		bomanager.deleteBusinessObjects(accountList);
		bomanager.deleteBusinessObjects(rptList);
		bomanager.deleteBusinessObjects(rateList);
		bomanager.deleteBusinessObjects(feeList);
		
		bomanager.deleteBusinessObject(putout);
		bomanager.updateDB();
		return "true";
	}
	
}