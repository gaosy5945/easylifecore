package com.amarsoft.app.als.customer.action;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

public class CeilingGCAction{
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
	
	public String getBalance(JBOTransaction tx) throws Exception{
		BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager(tx);
		this.setBusinessObjectManager(bom);
		String serialNo = (String)inputParameter.getValue("SerialNo");
		return this.getBalance(serialNo);
	}
	
	public String getBalance(String serialNo) throws Exception{
		BusinessObject gc = this.businessObjectManager.keyLoadBusinessObject("jbo.guaranty.GUARANTY_CONTRACT", serialNo);
		if(gc == null) 
			throw new Exception("������ͬ"+serialNo+"�����ڣ�");
		double guarantyValue = gc.getDouble("GuarantyValue");
		double totalAmount = 0;
		List<BusinessObject> crList = this.businessObjectManager.loadBusinessObjects("jbo.app.CONTRACT_RELATIVE",
				"ObjectType='jbo.guaranty.GUARANTY_CONTRACT' and ObjectNo=:ObjectNo", "ObjectNo",serialNo);
		for(BusinessObject cr:crList){
			double amount = cr.getDouble("RelativeAmount");
			totalAmount += amount;
		}
		double balance = guarantyValue - totalAmount;
		if(balance < 0)
			throw new Exception("ռ�ý���������ͬ���");
		return Double.toString(balance);
	}
}