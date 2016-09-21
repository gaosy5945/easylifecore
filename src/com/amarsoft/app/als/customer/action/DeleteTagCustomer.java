package com.amarsoft.app.als.customer.action;

import java.sql.SQLException;

import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

public class DeleteTagCustomer {
	private JSONObject inputParameter;

	private BusinessObjectManager businessObjectManager;
	
	public void setInputParameter(JSONObject inputParameter) {
		this.inputParameter = inputParameter;
	}
	
	private JBOTransaction tx;

	public void setTx(JBOTransaction tx) {
		this.tx = tx;
	}
	
	private BusinessObjectManager getBusinessObjectManager() throws JBOException, SQLException{
		if(businessObjectManager==null)
			businessObjectManager = BusinessObjectManager.createBusinessObjectManager(tx);
		return businessObjectManager;
	}
	
	public void setBusinessObjectManager(BusinessObjectManager businessObjectManager) {
		this.businessObjectManager = businessObjectManager;
		this.tx = businessObjectManager.getTx();
	}
	public String deleteTagCustomer(JBOTransaction tx) throws Exception{
		this.tx = tx;
		String CustomerID = (String)inputParameter.getValue("CustomerID");
		String[] customerIDArray = CustomerID.split("@");
		for(int i = 0;i < customerIDArray.length;i++){
			deleteCustomer(customerIDArray[i]);
		}
		return "SUCCEED";
	}
	public void deleteCustomer(String CustomerID) throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.app.OBJECT_TAG_LIBRARY");
		tx.join(bm);
		bm.createQuery("Delete From O Where ObjectNo=:ObjectNo and ObjectType=:ObjectType")
		.setParameter("ObjectNo", CustomerID).setParameter("ObjectType", "jbo.customer.CUSTOMER_INFO")
		  .executeUpdate();
	}
}
