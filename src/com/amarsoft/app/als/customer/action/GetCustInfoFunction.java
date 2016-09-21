package com.amarsoft.app.als.customer.action;
/**
 * 根据客户编号获取展现客户信息的functionID
 */

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.json.JSONObject;

public class GetCustInfoFunction{
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
	public String getFunction(JBOTransaction tx) throws Exception{
		BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager(tx);
		this.setBusinessObjectManager(bom);
		BusinessObject customer = bom.keyLoadBusinessObject("jbo.customer.CUSTOMER_INFO", (String)inputParameter.getValue("CustomerID"));
		if(customer == null) return "false";
		String customerType = customer.getString("CustomerType");
		if(customerType == null || "".equals(customerType)) return "false";
		if(customerType.startsWith("03"))
			return "true@IndCustomerInfo";
		else if(customerType.startsWith("02")||customerType.startsWith("01"))
			return "true@EntCustomerInfo";
		else
			return "false";
	}
	
	public static String getFunction1(String customerID) throws Exception{
		if(StringX.isEmpty(customerID)) return "";
		BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager();
		BusinessObject customer = bom.keyLoadBusinessObject("jbo.customer.CUSTOMER_INFO", customerID);
		if(customer == null) return "";
		String customerType = customer.getString("CustomerType");
		if(StringX.isEmpty(customerType)) return "";
		if(customerType.startsWith("03"))
			return "IndCustomerInfo";
		else if(customerType.startsWith("02")||customerType.startsWith("01"))
			return "EntCustomerInfo";
		else
			return "";
	}
	
}