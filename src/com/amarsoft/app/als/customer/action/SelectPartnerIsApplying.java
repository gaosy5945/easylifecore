package com.amarsoft.app.als.customer.action;

import java.sql.SQLException;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.json.JSONObject;

public class SelectPartnerIsApplying {
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

	
	public String selectProjecting(JBOTransaction tx) throws Exception{
		this.tx=tx;
		String customerID = (String)inputParameter.getValue("CustomerID");
		String UserID = (String)inputParameter.getValue("UserID");
		String OrgID = (String)inputParameter.getValue("OrgID");

		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		List<BusinessObject> listPrj = bomanager.loadBusinessObjects("jbo.prj.PRJ_BASIC_INFO", "CustomerID=:CustomerID and InputUserID=:InputUserID and InputOrgID=:InputOrgID", "CustomerID", customerID,"InputUserID", UserID,"InputOrgID", OrgID);
		if(listPrj == null || listPrj.isEmpty()){
			return "PrjEmpty";
		}else{
			return "PrjFull";
		}
	}
	public String selectApplying(JBOTransaction tx) throws Exception{
		this.tx=tx;
		String prjSerialNo = (String)inputParameter.getValue("prjSerialNo");
		String objectType = "jbo.prj.PRJ_BASIC_INFO";
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		List<BusinessObject> listAR = bomanager.loadBusinessObjects("jbo.app.APPLY_RELATIVE", "ObjectType=:ObjectType and ObjectNo=:ObjectNo", "ObjectType",objectType,"ObjectNo",prjSerialNo);
		
		if(listAR == null || listAR.isEmpty()){
			return "ArEmpty";
		}else{
			String applySerialNo = listAR.get(0).getString("APPLYSERIALNO");
			List<BusinessObject> listBA = bomanager.loadBusinessObjects("jbo.app.BUSINESS_APPLY", "SerialNo=:SerialNo", "SerialNo",applySerialNo);
			if(listBA == null || listBA.isEmpty()){
				return "BaEmpty";
			}else{
				return "BAFull";
			}
		}
	}
}
