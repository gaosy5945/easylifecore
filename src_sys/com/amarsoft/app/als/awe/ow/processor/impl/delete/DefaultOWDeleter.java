package com.amarsoft.app.als.awe.ow.processor.impl.delete;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.als.awe.ow.ALSBusinessProcess;
import com.amarsoft.app.als.awe.ow.processor.BusinessObjectOWDeleter;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.als.businessobject.action.BusinessObjectFactory;

public class DefaultOWDeleter implements BusinessObjectOWDeleter {

	@Override
	public int delete(BusinessObject businessObject,
			ALSBusinessProcess businessProcess) throws Exception {
		//businessProcess.getBusinessObjectManager().deleteBusinessObject(businessObject);
		BusinessObjectFactory.delete(businessObject, businessProcess.getBusinessObjectManager());
		List<BusinessObject> result = new ArrayList<BusinessObject>();
		result.add(businessObject);
		return 1;
	}

	@Override
	public int delete(List<BusinessObject> businessObjectList,
			ALSBusinessProcess businessProcess) throws Exception {
		for(BusinessObject businessObject:businessObjectList){
			this.delete(businessObject, businessProcess);
		}
		return 1;
	}
}
