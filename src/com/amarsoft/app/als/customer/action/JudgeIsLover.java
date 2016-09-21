package com.amarsoft.app.als.customer.action;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

public class JudgeIsLover {
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
	public String judgeIsLover(JBOTransaction tx) throws Exception{
		
		String CustomerID = (String)inputParameter.getValue("CustomerID");
		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_RELATIVE");
		tx.join(table);
		
		BizObjectQuery q = table.createQuery("CustomerID=:CustomerID and RelationShip=:RelationShip")
				.setParameter("CustomerID", CustomerID).setParameter("RelationShip", "2007");
		List<BizObject> DataLast = q.getResultList(false);

		String flag = "1";
		if(DataLast!=null){
			for(BizObject bo:DataLast){
				flag = "2";
			}
		}
		return flag;
	}
}
