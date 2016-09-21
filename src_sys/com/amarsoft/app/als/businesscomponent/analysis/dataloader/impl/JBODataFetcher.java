package com.amarsoft.app.als.businesscomponent.analysis.dataloader.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.amarsoft.app.als.businesscomponent.analysis.BusinessComponentAnalysisFunctions;
import com.amarsoft.app.als.businesscomponent.analysis.dataloader.ParameterDataLoader;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;

public class JBODataFetcher extends ParameterDataLoader{

	@Override
	public List<Object> getParameterData(BusinessObject parameter,BusinessObject businessObject, BusinessObjectManager bomanager)throws Exception {
		List<Object> valueList = new ArrayList<Object>();
		String parameterID = parameter.getString("ParameterID");
		Map<String, String> objectTypeMap = BusinessComponentAnalysisFunctions.getParameterValueObjectType(parameterID);
		if(objectTypeMap.isEmpty()) return valueList;
		for(String objectType:objectTypeMap.keySet()){
			String attributeID = BusinessComponentAnalysisFunctions.getJBOAttributeID(parameterID, objectType);
			if(objectType.equals(businessObject.getBizClassName())){
				Object o=businessObject.getObject(attributeID);
				if(o==null||"".equals(o)) continue;
				valueList.add(o);
			}
			else{
				List<BusinessObject> list = businessObject.getBusinessObjects(objectType);
				if(list!=null&&!list.isEmpty()){
					for(BusinessObject o :list){
						Object value_T = o.getObject(attributeID);
						if(value_T==null||value_T.equals("")) continue;
						valueList.add(BusinessComponentAnalysisFunctions.convertParameterValue(value_T,parameter));
					}
				}
			}
		}
		return valueList;
	}
}
