package com.amarsoft.app.als.customer.action;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

public class JudgeIsRelative {
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
	public String judgeIsRelative(JBOTransaction tx) throws Exception{
		String flag = "1";
		String LovePeople = "1";
		
		String CustomerID = (String)inputParameter.getValue("CustomerID");
		String RelativeCustomerIDNew = (String)inputParameter.getValue("RelativeCustomerID");
		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_RELATIVE");
		tx.join(table);

		BizObjectQuery q = table.createQuery("CustomerID=:CustomerID").setParameter("CustomerID", CustomerID);
		List<BizObject> DataLast = q.getResultList(false);
		String relationShip = "";
		String relativeCustomerID = "";
		if(DataLast!=null){
			for(BizObject bo:DataLast){
				relationShip = bo.getAttribute("RELATIONSHIP").getString();
				relativeCustomerID = bo.getAttribute("RELATIVECUSTOMERID").getString();
				if(relativeCustomerID!=null){
					if(relativeCustomerID.equals(RelativeCustomerIDNew)){
						flag = "2";
					}
					if("2007".equals(relationShip)){
						LovePeople = "2";
					}
				}
			}
		}
		return flag+"@"+LovePeople;
	}
}
