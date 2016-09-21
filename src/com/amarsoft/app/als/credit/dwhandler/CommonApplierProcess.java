package com.amarsoft.app.als.credit.dwhandler;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.als.awe.ow.ALSBusinessProcess;
import com.amarsoft.app.als.awe.ow.processor.BusinessObjectOWUpdater;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.are.lang.StringX;

/**
 * @author
 * 共同还款人信息
 */
public class CommonApplierProcess extends ALSBusinessProcess
		implements BusinessObjectOWUpdater {
	
	@Override
	public List<BusinessObject> update(BusinessObject ca,
			ALSBusinessProcess businessProcess) throws Exception {
		String applicantSerialNo=ca.getKeyString();
		if(StringX.isEmpty(applicantSerialNo)){
			ca.generateKey();
		}
		this.bomanager.updateBusinessObject(ca);

		BusinessObject customer = ca.getBusinessObject("jbo.customer.CUSTOMER_INFO");
		String customerid=customer.getKeyString();
		if(StringX.isEmpty(customerid)){
			customer.generateKey();
			customerid=customer.getKeyString();
		}
		this.bomanager.updateBusinessObject(customer);
		
		BusinessObject ind = ca.getBusinessObject("jbo.customer.IND_INFO");
		ind.setKey(customerid);
		this.bomanager.updateBusinessObject(ind);
		
		List<BusinessObject> result = new ArrayList<BusinessObject>();
		result.add(ca);
		return result;
	}

	@Override
	public List<BusinessObject> update(List<BusinessObject> businessObjectList,
			ALSBusinessProcess businessProcess) throws Exception {
		for(BusinessObject businessObject:businessObjectList){
			this.update(businessObject, businessProcess);
		}
		return businessObjectList;
	}

}
