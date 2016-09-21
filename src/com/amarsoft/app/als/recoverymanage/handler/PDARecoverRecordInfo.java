package com.amarsoft.app.als.recoverymanage.handler;

import java.sql.SQLException;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

public class PDARecoverRecordInfo {
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
	private String serialNo;
	public String getSerialNo() {
		return serialNo;
	}
	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}
	/**
	 * 更新业务种类
	 * 
	 * @param bo
	 * @throws Exception
	 */
	public void updateBusinessStatus(JBOTransaction tx) throws Exception {
		this.tx=tx;
		String serialNo = (String)inputParameter.getValue("serialNo");
		
		BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager(tx);
		BusinessObject bo = bom.keyLoadBusinessObject("jbo.app.BUSINESS_DUEBILL", serialNo);
		bo.setAttributeValue("BUSINESSSTATUS", "L51");
		bom.updateBusinessObject(bo);
		bom.updateDB();		
	}
}
