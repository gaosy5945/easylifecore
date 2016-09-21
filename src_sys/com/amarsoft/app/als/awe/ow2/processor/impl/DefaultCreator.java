package com.amarsoft.app.als.awe.ow2.processor.impl;

import com.amarsoft.app.als.awe.ow2.processor.DataObjectCreator;
import com.amarsoft.app.als.awe.ow2.processor.OWBusinessProcessor;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.are.jbo.BizObjectClass;

public class DefaultCreator implements DataObjectCreator {
	@Override
	public BusinessObject newObject(OWBusinessProcessor businessProcess)
			throws Exception {
		BizObjectClass bizObjectClass = businessProcess.getDataObjectClass();
		//���ȴ���һ���µĶ���
		BusinessObject businessObject = BusinessObject.createBusinessObject(bizObjectClass);
		businessProcess.setDefaultValue(businessObject);
		return businessObject;
	}
}
