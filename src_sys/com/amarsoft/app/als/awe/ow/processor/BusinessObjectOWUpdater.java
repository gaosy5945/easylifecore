package com.amarsoft.app.als.awe.ow.processor;

import java.util.List;

import com.amarsoft.app.als.awe.ow.ALSBusinessProcess;
import com.amarsoft.app.base.businessobject.BusinessObject;

public interface BusinessObjectOWUpdater {
	public List<BusinessObject> update(BusinessObject businessObject,ALSBusinessProcess businessProcess) throws Exception;
	
	public List<BusinessObject> update(List<BusinessObject> businessObjectList,ALSBusinessProcess businessProcess) throws Exception;
}
