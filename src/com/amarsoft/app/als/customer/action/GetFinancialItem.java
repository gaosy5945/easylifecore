package com.amarsoft.app.als.customer.action;

import java.sql.SQLException;

import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

public class GetFinancialItem {
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
	
	public String getFinancialItem(JBOTransaction tx) throws Exception{
		this.tx=tx;
		String financialItem = (String)inputParameter.getValue("financialItem");
		
		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.sys.CODE_LIBRARY");
		tx.join(table);

		BizObjectQuery q = table.createQuery("CodeNo='FinancialItem' and ItemNo=:ItemNo").setParameter("ItemNo", financialItem);
		BizObject pr = q.getSingleResult(false);
		String  attribute3 = "";
		String DataTemp = "";
		String Data = "";
		if(pr!=null)
		{
			attribute3 = pr.getAttribute("Attribute3").getString();
			String[] Temp = attribute3.split(",");
			for(int i = 0;i < Temp.length;i++){
					BizObjectQuery qI = table.createQuery("CodeNo='ExpenseDocType' and  ItemNo=:ItemNo").setParameter("ItemNo", Temp[i]);
					BizObject prI = qI.getSingleResult(false);
					if(prI != null){
						DataTemp += prI.getAttribute("ItemName").toString()+","+Temp[i]+",";
					}
			}
		}
		Data = DataTemp.substring(0, DataTemp.length()-1);
		
		return Data;
	}
}
