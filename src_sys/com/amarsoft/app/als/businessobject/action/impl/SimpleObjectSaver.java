package com.amarsoft.app.als.businessobject.action.impl;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.als.businessobject.action.BusinessObjectSaver;

public class SimpleObjectSaver implements BusinessObjectSaver{

	@Override
	public int save(List<BusinessObject> businessObjectList,
			BusinessObject inputParameters, BusinessObjectManager bomanager)
			throws Exception {
		bomanager.updateBusinessObjects(businessObjectList);
		bomanager.updateDB();
		return 1;
	}
}
