package com.amarsoft.app.als.customer.dwhandler;

import com.amarsoft.app.als.customer.model.CustomerConst;
import com.amarsoft.app.als.customer.model.CustomerInfo;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;
import com.amarsoft.awe.util.DBKeyHelp;

public class CustomerAddressHandler extends CommonHandler{

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
			throws Exception{
		String customerID=this.asPage.getParameter("CustomerID");
		bo.setAttributeValue("ObjectNo", customerID);
		String addressType = bo.getAttribute("AddressType").toString();
		BizObjectManager m = JBOFactory.getFactory().getManager(CustomerConst.PUB_ADDRESS_INFO);
	    tx.join(m);
		BizObjectQuery bq = m.createQuery("update O set IsNew=:isNew where ObjectNo=:objectNo and AddressType=:addressType");
		   bq.setParameter("ObjectNo",customerID).setParameter("AddressType", addressType).
		   setParameter("IsNew",CustomerConst.ISNEW_2).executeUpdate();	
		
	}
	
}
