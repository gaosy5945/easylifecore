package com.amarsoft.app.als.customer.dwhandler;

import com.amarsoft.app.als.customer.model.CustomerConst;
import com.amarsoft.app.als.customer.model.CustomerInfo;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;

public class CustomerTelHandler extends CommonHandler{

	@Override
	protected void initDisplayForAdd(BizObject bo) throws Exception {
		String customerId=this.asPage.getParameter("CustomerID");
		CustomerInfo customerInfo=new CustomerInfo(null,customerId);
		bo.setAttributesValue(customerInfo.getBizObject());
		bo.setAttributeValue("InputUserID",curUser.getUserID());
		bo.setAttributeValue("InputOrgID", curUser.getOrgID());
		bo.setAttributeValue("InputDate",DateHelper.getBusinessDate());
	}
	
	protected void afterUpdate(JBOTransaction tx, BizObject bo)
			throws Exception {
		bo.setAttributeValue("UpdateUserID",curUser.getUserID());
		bo.setAttributeValue("UpdateOrgID", curUser.getOrgID());
		bo.setAttributeValue("UpdateDate",DateHelper.getBusinessDate());
	}
	
	protected void beforeInsert(JBOTransaction tx, BizObject bo)
			throws Exception {
		String customerID = bo.getAttribute("CustomerID").toString();
		String telType = bo.getAttribute("TelType").toString();
		BizObjectManager m = JBOFactory.getFactory().getManager(CustomerConst.CUSTOMER_TEL);
	    tx.join(m);
		BizObjectQuery bq = m.createQuery("update O set IsNew=:isNew where CustomerID=:customerID and TelType=:telType");
		   bq.setParameter("customerID",customerID).setParameter("telType", telType).
		   setParameter("IsNew",CustomerConst.ISNEW_2).executeUpdate();			
	}

	@Override
	protected void beforeUpdate(JBOTransaction tx, BizObject bo)
			throws Exception {
		String isNew = bo.getAttribute("IsNew").toString();
		if(CustomerConst.ISNEW_1.equals(isNew)){
			String customerID = bo.getAttribute("CustomerID").toString();
			String telType = bo.getAttribute("TelType").toString();
			String serialNo = bo.getAttribute("SerialNo").getString();
			BizObjectManager m = JBOFactory.getFactory().getManager(CustomerConst.CUSTOMER_TEL);
		    tx.join(m);
			BizObjectQuery bq = m.createQuery("update O set IsNew=:isNew where CustomerID=:customerID and TelType=:telType and SerialNo<>:serialNo");
			   bq.setParameter("customerID",customerID).setParameter("telType", telType).setParameter("serialNo", serialNo).
			   setParameter("IsNew",CustomerConst.ISNEW_2).executeUpdate();
		}
	}
	
}
