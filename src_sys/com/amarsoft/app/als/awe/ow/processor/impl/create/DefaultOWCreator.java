package com.amarsoft.app.als.awe.ow.processor.impl.create;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.als.awe.ow.ALSBusinessProcess;
import com.amarsoft.app.als.awe.ow.processor.BusinessObjectOWCreator;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.util.ObjectWindowHelper;
import com.amarsoft.app.base.util.SystemHelper;
import com.amarsoft.app.als.businessobject.action.BusinessObjectFactory;
import com.amarsoft.are.jbo.BizObjectClass;

public class DefaultOWCreator implements BusinessObjectOWCreator {

	@Override
	public List<BusinessObject> newObject(BusinessObject inputParameter,ALSBusinessProcess businessProcess) throws Exception {
		BizObjectClass bizObjectClass = ObjectWindowHelper.getBizObjectClass(businessProcess.getASDataObject());
		BusinessObject systemParameters= SystemHelper.getSystemParameters(businessProcess.getCurUser(), businessProcess.getCurUser().getBelongOrg());
		inputParameter.setAttributeValue("SystemParameters", systemParameters);
		BusinessObject businessObject = BusinessObjectFactory.createBusinessObject(bizObjectClass, inputParameter,true, businessProcess.getBusinessObjectManager());
		businessProcess.setDefaultValue(businessObject);
		businessProcess.convertBusinessObject(businessObject);
		
		List<BusinessObject> result = new ArrayList<BusinessObject>();
		result.add(businessObject);
		return result;
	}
}
