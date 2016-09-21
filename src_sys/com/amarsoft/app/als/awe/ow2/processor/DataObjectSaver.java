package com.amarsoft.app.als.awe.ow2.processor;

import com.amarsoft.app.base.businessobject.BusinessObject;

public interface DataObjectSaver {
	public BusinessObject save(BusinessObject businessObject,OWBusinessProcessor businessProcess) throws Exception;
}
