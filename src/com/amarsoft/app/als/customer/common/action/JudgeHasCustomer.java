package com.amarsoft.app.als.customer.common.action;

import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

public class JudgeHasCustomer {
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
	public String judgeHasCustomer(JBOTransaction tx) throws Exception{
		this.tx=tx;
		String CustomerID = (String)inputParameter.getValue("customerID");
		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_INFO");
		tx.join(table);

		BizObjectQuery q = table.createQuery("CustomerID=:CustomerID").setParameter("CustomerID", CustomerID);
		BizObject pr = q.getSingleResult(false);
		String  Flag = "FALSE";
		if(pr!=null)
		{
			Flag = "SUCCEED";
		}

		return Flag;
	}
}
