package com.amarsoft.app.als.businesscomponent.analysis.dataloader.impl;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.amarscript.Any;
import com.amarsoft.amarscript.Expression;
import com.amarsoft.app.als.businesscomponent.analysis.dataloader.ParameterDataLoader;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.config.impl.BusinessComponentConfig;
import com.amarsoft.app.base.util.StringHelper;
import com.amarsoft.awe.util.Transaction;

public class AmarScriptDataFetcher extends ParameterDataLoader{

	@Override
	public List<Object> getParameterData(BusinessObject parameter,BusinessObject businessObject, BusinessObjectManager bomanager)throws Exception {
		List<Object> valueList = new ArrayList<Object>();
		
		String parameterID = parameter.getString("ParameterID");
		String method = parameter.getString("MethodScript");
		if(method==null||method.length()==0){
			method = BusinessComponentConfig.getParameterDefinition(parameterID).getString("MethodScript");
		}
		if(method==null||method.length()==0) 
			throw new Exception("参数{"+parameterID+"}的取值逻辑定义不正确！");
		method = StringHelper.replaceStringFullName(method,businessObject);
		Transaction sqlca =Transaction.createTransaction(bomanager.getTx());
		Any a=Expression.getExpressionValue(method, sqlca);
		if("Number".equalsIgnoreCase(a.getType()))
			valueList.add(a.doubleValue());
		else
			valueList.add(a.stringValue());
		return valueList;
	}
	
}
