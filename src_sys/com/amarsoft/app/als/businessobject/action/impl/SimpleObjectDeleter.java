package com.amarsoft.app.als.businessobject.action.impl;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.als.businessobject.action.BusinessObjectDeleter;
import com.amarsoft.are.jbo.BizObjectKey;

public class SimpleObjectDeleter implements BusinessObjectDeleter{

	@Override
	public int delete(List<BusinessObject> businessObjectList,
			BusinessObject inputParameters, BusinessObjectManager bomanager)
			throws Exception {
		for(BusinessObject bo:businessObjectList){
			BizObjectKey key = bo.getKey();
			bomanager.getBizObjectManager(key.getBizObjectClass().getRoot().getAbsoluteName()).deleteObject(key);
		}
		return 1;
	}

}
