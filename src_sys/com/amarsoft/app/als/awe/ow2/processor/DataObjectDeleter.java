package com.amarsoft.app.als.awe.ow2.processor;

import com.amarsoft.app.base.businessobject.BusinessObject;

public interface DataObjectDeleter {
	public int delete(BusinessObject businessObject,OWBusinessProcessor businessProcess) throws Exception;
}
