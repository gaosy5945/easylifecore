package com.amarsoft.app.als.customer.action;

import java.sql.SQLException;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.als.customer.model.CustomerConst;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

public class DeleteCustomerBelong {
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
	
	public String deleteCustomerBelong(JBOTransaction tx) throws Exception{
		this.tx = tx;
		String CustomerID = (String)inputParameter.getValue("CustomerID");
		String InputUserID = (String)inputParameter.getValue("InputUserID");
		String InputOrgID = (String)inputParameter.getValue("InputOrgID");
		String[] customerIDArray = CustomerID.split("@");
		for(int i = 0;i < customerIDArray.length;i++){
			deleteCustomer(customerIDArray[i],InputUserID,InputOrgID);
		}
		return "SUCCEED";
	}
	public void deleteCustomer(String CustomerID,String InputUserID,String InputOrgID) throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_BELONG");
		tx.join(bm);
		bm.createQuery("Delete From O Where CustomerID=:CustomerID and OrgID=:OrgID and UserID=:UserID")
		  .setParameter("CustomerID", CustomerID).setParameter("OrgID", InputOrgID).setParameter("UserID", InputUserID)
		  .executeUpdate();
	}
	
	public String deletePartner(JBOTransaction tx) throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_BELONG");
		tx.join(bm);
		String CustomerID = (String)inputParameter.getValue("CustomerID");
		String InputUserID = (String)inputParameter.getValue("InputUserID");
		String InputOrgID = (String)inputParameter.getValue("InputOrgID");
		bm.createQuery("Delete From O Where CustomerID=:CustomerID and OrgID=:OrgID and UserID=:UserID")
		  .setParameter("CustomerID", CustomerID).setParameter("OrgID", InputOrgID).setParameter("UserID", InputUserID)
		  .executeUpdate();
		
		return "SUCCEED";
	}

}
