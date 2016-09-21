package com.amarsoft.app.als.project;

import java.sql.SQLException;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

public class SelectPaymentMoney {
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
	public String selectPaymentMoney(JBOTransaction tx) throws Exception{
		this.tx=tx;
		String MarginSerialNo = (String)inputParameter.getValue("MarginSerialNo");
		double sum= 0.00;
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		List<BusinessObject> listCMW = bomanager.loadBusinessObjects("jbo.guaranty.CLR_MARGIN_WASTEBOOK", "MarginSerialNo=:MarginSerialNo and TransactionCode='0010'", "MarginSerialNo",MarginSerialNo);
		for(BusinessObject list:listCMW){
			double amountTemp = list.getDouble("AMOUNT");
			sum = sum + amountTemp;
		}
		String sumTemp = String.valueOf(sum);
		return sumTemp;
	}
}
