package com.amarsoft.app.als.customer.action;

/**
 * 更具证件类型的不同，更新相应表的证件号码
 * @author 柳显涛
 *
 */

import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

public class UpdateCertID {
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
	
	public String UpdateLicenseNo(JBOTransaction tx) throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.customer.ENT_INFO");
		tx.join(bm);
		String customerID = (String)inputParameter.getValue("customerID");
		String certID = (String)inputParameter.getValue("certID");
		
		bm.createQuery("update O set LICENSENO=:licenseNo,UPDATEDATE=:updateDate Where customerID=:customerID")
		  .setParameter("licenseNo", certID).setParameter("updateDate", DateHelper.getBusinessDate()).setParameter("customerID", customerID)
		  .executeUpdate();

		return "SUCCEED";
	}
	
	public String UpdateAccountNo(JBOTransaction tx) throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.customer.IND_SI");
		tx.join(bm);
		String customerID = (String)inputParameter.getValue("customerID");
		String accountNo = (String)inputParameter.getValue("accountNo");
		
		bm.createQuery("update O set ACCOUNTNO=:accountNo,UPDATEDATE=:updateDate Where customerID=:customerID")
		  .setParameter("accountNo", accountNo).setParameter("updateDate", DateHelper.getBusinessDate()).setParameter("customerID", customerID)
		  .executeUpdate();

		return "SUCCEED";
	}
	
	public String UpdateTagID(JBOTransaction tx) throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.app.OBJECT_TAG_CATALOG");
		tx.join(bm);
		String serialNo = (String)inputParameter.getValue("serialNo");
		
		bm.createQuery("update O set TAGID=:tagID Where serialNo=:serialNo")
		  .setParameter("tagID", serialNo).setParameter("serialNo", serialNo)
		  .executeUpdate();

		return "SUCCEED";
	}
	
	public String updateCustomerName(JBOTransaction tx) throws Exception{
			String CustomerID = (String)inputParameter.getValue("CustomerID");
			BizObjectManager table = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_INFO");
			tx.join(table);

			BizObjectQuery q = table.createQuery("CustomerID=:CustomerID").setParameter("CustomerID", CustomerID);
			BizObject pr = q.getSingleResult(false);
			String  CustomerName = "";
			if(pr!=null)
			{
				CustomerName = pr.getAttribute("CustomerName").getString();
				BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_LIST");
				tx.join(bm);
				bm.createQuery("update O set CustomerName=:CustomerName Where CustomerID=:CustomerID")
				  .setParameter("CustomerName", CustomerName).setParameter("CustomerID", CustomerID)
				  .executeUpdate();
			}

			return "SUCCEED";
	}
}
