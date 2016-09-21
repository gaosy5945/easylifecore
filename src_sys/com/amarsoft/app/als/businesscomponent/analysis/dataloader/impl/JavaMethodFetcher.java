package com.amarsoft.app.als.businesscomponent.analysis.dataloader.impl;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.als.businesscomponent.analysis.dataloader.ParameterDataLoader;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.config.impl.BusinessComponentConfig;
import com.amarsoft.app.base.util.JavaMethodHelper;

public class JavaMethodFetcher extends ParameterDataLoader{

	@Override
	public List<Object> getParameterData(BusinessObject parameter,BusinessObject businessObject, BusinessObjectManager bomanager)throws Exception {
		List<Object> valueList = new ArrayList<Object>();
		
		String parameterID = parameter.getString("ParameterID");
		String method = parameter.getString("MethodScript");
		if(method==null||method.length()==0){
			method = BusinessComponentConfig.getParameterDefinition(parameterID).getString("MethodScript");
		}
		if(method==null||method.length()==0) throw new Exception("����{"+parameterID+"}��ȡֵ�߼����岻��ȷ��");
		Object o=JavaMethodHelper.runMethod(method, businessObject);
		if(o!=null){
			valueList.add(o);
		}
		return valueList;
	}
	
	
}
