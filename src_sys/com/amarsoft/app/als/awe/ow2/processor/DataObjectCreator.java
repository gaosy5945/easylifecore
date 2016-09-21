package com.amarsoft.app.als.awe.ow2.processor;

import com.amarsoft.app.base.businessobject.BusinessObject;

public interface DataObjectCreator {
	public BusinessObject newObject(OWBusinessProcessor businessProcess) throws Exception;
}
