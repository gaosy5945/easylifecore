package com.amarsoft.app.als.credit.guaranty.guarantycontract;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.als.awe.ow.ALSBusinessProcess;
import com.amarsoft.app.als.awe.ow.processor.BusinessObjectOWDeleter;
import com.amarsoft.app.als.awe.ow.processor.BusinessObjectOWUpdater;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.are.lang.StringX;

/**
 * @author
 * 申请阶段新增担保保证金
 */
public class GuarantyCLRProcess extends ALSBusinessProcess
		implements BusinessObjectOWDeleter,BusinessObjectOWUpdater {
	
	@Override
	public List<BusinessObject> update(BusinessObject clr,
			ALSBusinessProcess businessProcess) throws Exception {
		clr.generateKey();
		this.bomanager.updateBusinessObject(clr);

		BusinessObject account = clr.getBusinessObject("jbo.acct.ACCT_BUSINESS_ACCOUNT");
		account.setAttributeValue("ObjectType",clr.getBizClassName());
		account.setAttributeValue("ObjectNo",clr.getKeyString());
		account.generateKey();
		this.bomanager.updateBusinessObject(account);
		
		List<BusinessObject> result = new ArrayList<BusinessObject>();
		result.add(clr);
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

	@Override
	public int delete(BusinessObject clr,
			ALSBusinessProcess businessProcess) throws Exception {
		BusinessObject account = clr.getBusinessObject("jbo.acct.ACCT_BUSINESS_ACCOUNT");
		this.bomanager.deleteBusinessObject(clr);
		
		List<BusinessObject> result = new ArrayList<BusinessObject>();
		result.add(clr);
		if(account != null){
			this.bomanager.deleteBusinessObject(account);
			result.add(account);
		}
		return 1;
	}

	@Override
	public int delete(List<BusinessObject> businessObjectList,
			ALSBusinessProcess businessProcess) throws Exception {
		for(BusinessObject businessObject:businessObjectList){
			this.update(businessObject, businessProcess);
		}
		return 1;
	}
}
