package com.amarsoft.app.lending.bizlets;

import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

public class UpdateApplyCustomerName {
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
	
	public String updateCustomerName(JBOTransaction tx) throws Exception{
		//更新ba表中的客户姓名，以防止用户选客户后又修改客户名称
		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_INFO");
		tx.join(table);
		String CustomerID = (String)inputParameter.getValue("CustomerID");
		String SerialNo = (String)inputParameter.getValue("SerialNo");
		BizObjectQuery q = table.createQuery("CustomerID=:CustomerID").setParameter("CustomerID", CustomerID);
		BizObject pr = q.getSingleResult(false);
		String  CICustomerName = "";
		if(pr!=null)
		{
			CICustomerName = pr.getAttribute("CustomerName").getString();
		}
		
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_APPLY");
		tx.join(bm);
		
		bm.createQuery("update O set CustomerName=:CustomerName Where SerialNo=:SerialNo")
		  .setParameter("CustomerName", CICustomerName).setParameter("SerialNo", SerialNo).executeUpdate();
		return "SUCCEED";
	}
}
