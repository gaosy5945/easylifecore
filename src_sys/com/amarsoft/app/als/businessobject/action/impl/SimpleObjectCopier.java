package com.amarsoft.app.als.businessobject.action.impl;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.als.businessobject.action.BusinessObjectCopier;

public class SimpleObjectCopier implements BusinessObjectCopier{

	@Override
	public List<BusinessObject> copy(List<BusinessObject> businessObjectList,
			BusinessObject inputParameters, BusinessObjectManager bomanager)
			throws Exception {
		List<BusinessObject> l = new ArrayList<BusinessObject>();
		for(BusinessObject o:businessObjectList){
			BusinessObject newo = BusinessObject.createBusinessObject(o);
			newo.generateKey(true);//重新生成流水号
			l.add(newo);
		}
		return l;
	}
}
