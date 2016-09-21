package com.amarsoft.app.als.project;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

public class QueryMarginBalance {
	
	public String queryMarginBalance(String ProjectSerialNo, JBOTransaction tx) throws Exception{
		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.prj.PRJ_BASIC_INFO");
		tx.join(table);
		String MFCustomerID = "";
		BizObjectQuery q2 = table.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", ProjectSerialNo);
		BizObject pr2 = q2.getSingleResult(false);
		if(pr2 != null){
			String CustomerID = pr2.getAttribute("CustomerID").getString();
			BizObjectManager tableCI = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_INFO");
			tx.join(tableCI);
			
			BizObjectQuery qCI = tableCI.createQuery("CustomerID=:CustomerID").setParameter("CustomerID", CustomerID);
			BizObject prCI = qCI.getSingleResult(false);
			if(prCI != null){
				MFCustomerID = prCI.getAttribute("MFCUSTOMERID").getString();
			}
		}
		return MFCustomerID;
	}
}
