package com.amarsoft.app.als.activeCredit.customerBase;

import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

public class UpdateEffectDate {
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
	public void update(JBOTransaction tx) throws Exception{
		String CustomerBaseID = (String)inputParameter.getValue("CustomerBaseID");
		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_BASE");
		tx.join(table);
		table.createQuery("UPDATE O SET EFFECTDATE =:EFFECTDATE WHERE CustomerBaseID = :CustomerBaseID").setParameter("EFFECTDATE", DateHelper.getBusinessDate()).setParameter("CustomerBaseID", CustomerBaseID).executeUpdate();
	}
}
