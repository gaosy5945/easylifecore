package com.amarsoft.app.workflow.processdata;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.BizObject;

public class GetAccountNo implements IProcess {

	@Override
	public String process(List<BusinessObject> bos,BusinessObjectManager bomanager,
			String paraName, String dataType, BusinessObject otherPara)
			throws Exception {
		BizObject bo = bos.get(0);
		String customerId = "";	
		customerId = bo.getAttribute("customerId").toString();
		BusinessObject customer = bomanager.keyLoadBusinessObject("jbo.customer.CUSTOMER_INFO", customerId);
		return customer.getString("mfCustomerId");
	}

}
