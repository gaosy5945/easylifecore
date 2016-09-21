package com.amarsoft.app.als.businesscomponent.analysis.checkmethod.impl;

import java.util.List;

import com.amarsoft.app.als.businesscomponent.analysis.checkmethod.ParameterChecker;
import com.amarsoft.app.base.businessobject.BusinessObject;

public abstract class StepParamterChecker extends ParameterChecker {
	
	public abstract Object getUpLevelValue(Object value,BusinessObject parameter) throws Exception;
	
	/**
	 *解析决策表的一个单元格
	 * @param dTable
	 * @param bizObject
	 * 
	 * 
	 * @return
	 * @throws Exception
	 */
	public BusinessObject run(BusinessObject businessData,BusinessObject parameter) throws Exception{
		String parameterID=parameter.getString("ParameterID");
		BusinessObject resultObject=BusinessObject.createBusinessObject();
		resultObject.setAttributeValue("CheckResult", "true");
		
		List<Object> values = (List<Object>)businessData.getObject(parameterID);
		if(values==null||values.isEmpty()){
			return resultObject;
		}
		for(Object value:values){
			Object lastValue=value;
			resultObject = super.checkParameterValue(value, parameter);
			String checkResult=resultObject.getString("CheckResult");
			int i=0;
			while(!"true".equalsIgnoreCase(checkResult)){
				i++;
				Object upLevelValue = this.getUpLevelValue(lastValue, parameter);
				if(lastValue.equals(upLevelValue)||upLevelValue==null||upLevelValue.equals("")||i>100) break;
				resultObject = super.checkParameterValue(upLevelValue, parameter);
				checkResult=resultObject.getString("CheckResult");
				lastValue=upLevelValue;
			}
			if(!"true".equalsIgnoreCase(checkResult)){
				break;
			}
		}
		return resultObject;
	}
}
