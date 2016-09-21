package com.amarsoft.app.als.businessobject.action.impl;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.als.businessobject.action.BusinessObjectLoader;

public class SimpleObjectLoader implements BusinessObjectLoader{

	@Override
	public List<BusinessObject> load(List<BusinessObject> businessObjectList,BusinessObject inputParameters, BusinessObjectManager bomanager)
			throws Exception {
		List<BusinessObject> bolist = new ArrayList<BusinessObject>();
		for(int i=0;i<businessObjectList.size();i++){
			BusinessObject bo = businessObjectList.get(i);
			bolist.add(bomanager.keyLoadBusinessObject(bo.getBizClassName(), bo.getKeyString()));
		}
		return bolist;
	}

}
