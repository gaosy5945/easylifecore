package com.amarsoft.app.als.awe.ow.processor;

import java.util.List;

import com.amarsoft.app.als.awe.ow.ALSBusinessProcess;
import com.amarsoft.app.base.businessobject.BusinessObject;

public interface BusinessObjectOWDeleter {
	public int delete(BusinessObject businessObject,
			ALSBusinessProcess businessProcess) throws Exception;
	
	public int delete(List<BusinessObject> businessObjectList,
			ALSBusinessProcess businessProcess) throws Exception;
}
