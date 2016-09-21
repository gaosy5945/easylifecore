package com.amarsoft.app.als.customer.action;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

public class UpdateIncome {
	private JSONObject inputParameter;
	private Double Temp =0.00;
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
	public String updateIncome(JBOTransaction tx) throws Exception{
		String CustomerID = (String)inputParameter.getValue("CustomerID");
		String OccurDate = (String)inputParameter.getValue("OccurDate");
		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_FINANCE");
		tx.join(table);
		
		BizObjectQuery q = table.createQuery("CustomerID=:CustomerID and FinancialItem like '30%' and FinancialItem not in ('30','3050')")
				.setParameter("CustomerID", CustomerID);
		List<BizObject> DataLast = q.getResultList(false);

		if(DataLast!=null){
			for(BizObject bo:DataLast){
				Double amount = bo.getAttribute("AMOUNT").getDouble();
				Temp += amount;
			}
		}
		
		BizObjectQuery qCF = table.createQuery("CustomerID=:CustomerID and FinancialItem = '3050'")
				.setParameter("CustomerID", CustomerID);
		BizObject prCF = qCF.getSingleResult(false);
		
		if(prCF!=null){
			table.createQuery("update O set Amount=:Amount,OccurDate=:OccurDate Where CustomerID=:CustomerID and FinancialItem = '3050'")
			  .setParameter("Amount", Temp).setParameter("OccurDate", OccurDate).setParameter("CustomerID", CustomerID)
			  .executeUpdate();
		}
		return "1";
	}
}
