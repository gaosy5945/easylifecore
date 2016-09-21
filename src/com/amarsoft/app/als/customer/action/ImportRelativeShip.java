package com.amarsoft.app.als.customer.action;

import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

public class ImportRelativeShip {
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
		
		public String importRelationShip(JBOTransaction tx) throws Exception{
			this.tx = tx;
			String customerid = (String)inputParameter.getValue("CustomerID");
			String relativeCustomerid = (String)inputParameter.getValue("relativeCustomerid");
			String relationShip = (String)inputParameter.getValue("RelationShip");
			String inputOrgID = (String)inputParameter.getValue("InputOrgID");
			String inputUserID = (String)inputParameter.getValue("InputUserID");
			String inputDate = (String)inputParameter.getValue("InputDate");
			if("2001".equals(relationShip)){
				relationShip = "2003";
			}else if("2002".equals(relationShip)){
				relationShip = "2004";
			}else if("2003".equals(relationShip)){
				relationShip = "2001";
			}else if("2004".equals(relationShip)){
				relationShip = "2002";
			}else if("2015".equals(relationShip)){
				relationShip = "2025";
			}else if("2025".equals(relationShip)){
				relationShip = "2015";
			}
			String result = selectCustomerName(customerid,tx);
			String[] temp = result.split("@");
			String relativeCustomerName = temp[0];
			
			importCustomerRelative(customerid,relativeCustomerName,relativeCustomerid,relationShip,inputOrgID,inputUserID,inputDate,tx);

			return "SUCCEED";
		}
		
		public String selectCustomerName(String customerid,JBOTransaction tx) throws Exception{
			
			BizObjectManager table = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_INFO");
			tx.join(table);

			BizObjectQuery q = table.createQuery("CustomerID=:CustomerID").setParameter("CustomerID", customerid);
			BizObject pr = q.getSingleResult(false);
			String  relativeCustomerName = "";
			if(pr!=null)
			{
				relativeCustomerName = pr.getAttribute("CUSTOMERNAME").getString();
			}

			return relativeCustomerName;
		}
		
		
		public String importCustomerRelative(String customerid,String customername,String relativeCustomerid,String relationShip,String inputOrgID,String inputUserID,String inputDate,JBOTransaction tx) throws Exception{
			BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_RELATIVE");
			tx.join(bm);

			BizObject bo = bm.newObject();
			bo.setAttributeValue("CUSTOMERID", relativeCustomerid);
			bo.setAttributeValue("RELATIVECUSTOMERID", customerid);
			bo.setAttributeValue("RELATIVECUSTOMERNAME", customername);
			bo.setAttributeValue("RELATIONSHIP", relationShip);
			bo.setAttributeValue("INPUTORGID", inputOrgID);
			bo.setAttributeValue("INPUTUSERID", inputUserID);
			bo.setAttributeValue("INPUTDATE", inputDate);
			bm.saveObject(bo);
			
			return "SUCCEED";
		}
		
}
