package com.amarsoft.app.als.businessobject.action;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.BizObjectClass;


public interface BusinessObjectCreator {
	public BusinessObject create(BizObjectClass bizObjectClass,BusinessObject inputParameters,BusinessObjectManager bomanager) throws Exception;
}
