package com.amarsoft.app.als.awe.ow.processor;

import java.util.List;

import com.amarsoft.app.als.awe.ow.ALSBusinessProcess;
import com.amarsoft.app.base.businessobject.BusinessObject;

public interface BusinessObjectOWCreator {
	public List<BusinessObject> newObject(BusinessObject inputParameter,ALSBusinessProcess businessProcess) throws Exception;
}
