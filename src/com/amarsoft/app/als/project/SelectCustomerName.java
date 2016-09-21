package com.amarsoft.app.als.project;

import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

public class SelectCustomerName {
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
	public String selectCustomerName(JBOTransaction tx) throws Exception{
		String CustomerID = (String)inputParameter.getValue("CustomerID");
		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_LIST");
		tx.join(table);

		BizObjectQuery q = table.createQuery("CustomerID=:CustomerID").setParameter("CustomerID", CustomerID);
		BizObject pr = q.getSingleResult(false);
		String  CustomerName = "";
		if(pr!=null)
		{
			CustomerName = pr.getAttribute("CustomerName").getString();
		}

		return CustomerName;
	}
}
