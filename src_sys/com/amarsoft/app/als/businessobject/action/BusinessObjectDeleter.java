package com.amarsoft.app.als.businessobject.action;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;

public interface BusinessObjectDeleter {
	public int delete(List<BusinessObject> businessObjectList,BusinessObject inputParameters,BusinessObjectManager bomanager) throws Exception;
}
