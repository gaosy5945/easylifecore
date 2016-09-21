package com.amarsoft.app.als.customer.dwhandler;

import com.amarsoft.app.als.customer.model.CustomerInfo;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;

public class CustomerChangeHandler extends CommonHandler{

	@Override
	protected void initDisplayForAdd(BizObject bo) throws Exception {
		super.initDisplayForAdd(bo);
		String customerId=this.asPage.getParameter("CustomerID");
		CustomerInfo customerInfo=new CustomerInfo(null,customerId);
		bo.setAttributesValue(customerInfo.getBizObject());
		bo.setAttributeValue("OLDCERTID", customerInfo.getAttribute("CertID"));
		bo.setAttributeValue("OLDCERTTYPE", customerInfo.getAttribute("CERTTYPE"));
		bo.setAttributeValue("OLDCUSTOMERNAME", customerInfo.getAttribute("CUSTOMERNAME"));
	}
	
	

}
