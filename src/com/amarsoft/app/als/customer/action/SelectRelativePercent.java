package com.amarsoft.app.als.customer.action;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

public class SelectRelativePercent {
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
	
	public String selectRelativePercent(JBOTransaction tx) throws Exception{
	String CustomerID = (String)inputParameter.getValue("CustomerID");
	String RelativePercent = (String)inputParameter.getValue("RelativePercent");
	BizObjectManager table = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_RELATIVE");
	tx.join(table);
	
	BizObjectQuery q = table.createQuery("CustomerID=:CustomerID and RelationShip like '52%'").setParameter("CustomerID", CustomerID);
	List<BizObject> DataLast = q.getResultList(false);
	double Temp = 0.00;
		if(DataLast!=null){
			for(BizObject bo:DataLast){
				Double RelativePercentTemp = bo.getAttribute("RELATIVEPERCENT").getDouble();
				Temp += RelativePercentTemp;
			}
		}
		Double RelativePercentSingle = Double.valueOf(RelativePercent);
		if(Temp == 100.00){
			return "Full";
		}else if((RelativePercentSingle+Temp) > 100.00){
			return "Upper";
		}else{
			return "SUCCEED";
		}
	}
}
