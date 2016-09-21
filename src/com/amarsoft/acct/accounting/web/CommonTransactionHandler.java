package com.amarsoft.acct.accounting.web;


import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.als.awe.ow.ALSBusinessProcess;
import com.amarsoft.app.als.awe.ow.processor.BusinessObjectOWUpdater;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.lang.DataElement;

public class CommonTransactionHandler extends ALSBusinessProcess implements BusinessObjectOWUpdater {

	public List<BusinessObject> update(BusinessObject businessObject,
			ALSBusinessProcess businessProcess) throws Exception {
		BusinessObject transaction = businessObject.getBusinessObject(BUSINESSOBJECT_CONSTANTS.transaction);
		if(transaction != null)
		{
			String transDate  ="";
			DataElement e = transaction.getAttribute("TransDate");
			if(e == null)  transDate = DateHelper.getBusinessDate();
			else transDate = e.getString();
			transaction.setAttributeValue("TransStatus", "0");
			transaction.setAttributeValue("TransDate", transDate);
			bomanager.updateBusinessObject(transaction);
		}
		else
		{
			String transDate  ="";
			DataElement e = businessObject.getAttribute("TransDate");
			if(e == null)  transDate = DateHelper.getBusinessDate();
			else transDate = e.getString();
			businessObject.setAttributeValue("TransStatus", "0");
			businessObject.setAttributeValue("TransDate", transDate);
		}
		bomanager.updateBusinessObject(businessObject);
		this.bomanager.updateDB();
		List<BusinessObject> result = new ArrayList<BusinessObject>();
		result.add(businessObject);
		return result;
	}
	
	public List<BusinessObject> update(List<BusinessObject> businessObjectList,
			ALSBusinessProcess businessProcess) throws Exception {
		for (BusinessObject businessObject : businessObjectList)
			this.update(businessObject, businessProcess);
		return businessObjectList;
	}
}
