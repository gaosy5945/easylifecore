package com.amarsoft.app.als.businessobject.action.impl;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.als.businessobject.action.BusinessObjectCreator;
import com.amarsoft.are.jbo.BizObjectClass;

public class SimpleObjectCreator implements BusinessObjectCreator{
	@Override
	public BusinessObject create(BizObjectClass bizObjectClass,BusinessObject inputParameters, BusinessObjectManager bomanager)
			throws Exception {
		BusinessObject businessObject=BusinessObject.createBusinessObject(bizObjectClass);
		businessObject.setAttributesValue(inputParameters.convertToMap());
		if("true".equals(inputParameters.getString("SYS_AUTO_KEY_FLAG"))){
			businessObject.generateKey();
		}
		
		return businessObject;
	}
}
