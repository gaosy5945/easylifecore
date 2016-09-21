package com.amarsoft.app.als.customer.partner.action;

import java.sql.SQLException;

import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.als.customer.model.CustomerInfo;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

public class CoWinUnionProject {
	
	//²ÎÊý
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
		
		private BusinessObjectManager getBusinessObjectManager() throws JBOException, SQLException{
			if(businessObjectManager==null)
				businessObjectManager = BusinessObjectManager.createBusinessObjectManager(tx);
			return businessObjectManager;
		}
	
	public void dealCoWinUnionProject(JBOTransaction tx) throws JBOException{
		
		String serialNo = (String)inputParameter.getValue("SerialNo");
		String customerIDs = (String)inputParameter.getValue("CustomerID");
		String[] customerID = customerIDs.split("~");
		BizObjectManager bmPP = JBOFactory.getFactory().getManager("jbo.prj.PRJ_PARTICIPANT");
		for(int i=0;i<customerID.length;i++){
			BizObject boPP = bmPP.newObject();
			String sigleCustomerID = customerID[i];
			CustomerInfo ciInfo = new CustomerInfo(tx, sigleCustomerID);
			String customerName = ciInfo.getAttribute("CustomerName").getString();
			boPP.setAttributeValue("projectserialno", serialNo);
			boPP.setAttributeValue("customerid", sigleCustomerID);
			boPP.setAttributeValue("customername", customerName);
			bmPP.saveObject(boPP);
		}
	}
	
	public void deleteCoWinUnionMember(JBOTransaction tx) throws JBOException{
			
		String serialNo = (String)inputParameter.getValue("SerialNo");
		String customerIDs = (String)inputParameter.getValue("CustomerID");
		String[] customerID = customerIDs.split("@");
		
		BizObjectManager bmPP = JBOFactory.getFactory().getManager("jbo.prj.PRJ_PARTICIPANT");
		BizObjectQuery bqPP = bmPP.createQuery("delete from O where ProjectSerialno =:ProjectSerialno and CustomerID =:CustomerID");
		for(int i=0;i<customerID.length;i++){
			String sigleCustomerID = customerID[i];
			
			bqPP.setParameter("ProjectSerialno", serialNo).setParameter("CustomerID", sigleCustomerID);
			bqPP.executeUpdate();
		}
	}
}
