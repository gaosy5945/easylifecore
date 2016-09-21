package com.amarsoft.app.als.awe.ow.processor;

import java.util.List;

import com.amarsoft.app.als.awe.ow.ALSBusinessProcess;
import com.amarsoft.app.base.businessobject.BusinessObject;

public interface BusinessObjectOWProcessor {
	public List<BusinessObject> run(String action,BusinessObject inputParameter,ALSBusinessProcess businessProcess) throws Exception;
}
