package com.amarsoft.app.als.customer.common.action;

import java.sql.SQLException;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.json.JSONObject;

public class SelectCustomer {
	
	private JSONObject inputParameter;
	private String customerType="";
	private String endDate="";
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
	
	public String selectCustomerType(JBOTransaction tx) throws Exception{
		this.tx=tx;
		String customerID = (String)inputParameter.getValue("CustomerID");
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		List<BusinessObject> list = bomanager.loadBusinessObjects("jbo.customer.CUSTOMER_INFO", "CustomerID=:CustomerID", "CustomerID",customerID);
		if(list == null || list.isEmpty()){
			return "FAILED";
		}else{
			customerType = list.get(0).getString("CUSTOMERTYPE");
			return customerType;
		}
	}
	
	public String selectResumeEndDate(JBOTransaction tx) throws Exception{
		this.tx=tx;
		String customerID = (String)inputParameter.getValue("CustomerID");
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		List<BusinessObject> list = bomanager.loadBusinessObjects("jbo.customer.IND_RESUME", "CustomerID=:CustomerID", "CustomerID",customerID);
		if(list == null || list.isEmpty()){
			return "ListNull";
		}else{
			endDate = list.get(0).getString("ENDDATE");
			if(endDate == null || endDate.isEmpty()){
				endDate = "Empty";
				return endDate;
			}else{
				return endDate;
			}
		}
	}
}
