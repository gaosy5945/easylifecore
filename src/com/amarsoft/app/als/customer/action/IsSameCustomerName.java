package com.amarsoft.app.als.customer.action;

import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

public class IsSameCustomerName {
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
	public String isSameCustomerName(JBOTransaction tx) throws Exception{
		String CustomerName = (String)inputParameter.getValue("CustomerName");
		String CertID = (String)inputParameter.getValue("CertID");
		String CertType = (String)inputParameter.getValue("CertType");
		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_INFO");
		tx.join(table);

		BizObjectQuery q = table.createQuery("CertID=:CertID and CertType=:CertType and CustomerName=:CustomerName")
				.setParameter("CertID", CertID).setParameter("CertType", CertType).setParameter("CustomerName", CustomerName);
		BizObject pr = q.getSingleResult(false);
		String  Flag = "No";
		if(pr!=null)
		{
			Flag = "Yes";
		}

		return Flag;
	}
}
