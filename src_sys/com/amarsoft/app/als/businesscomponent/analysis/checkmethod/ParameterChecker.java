package com.amarsoft.app.als.businesscomponent.analysis.checkmethod;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.config.impl.BusinessComponentConfig;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.dict.als.manage.CodeManager;
import com.amarsoft.dict.als.object.Item;

public abstract class ParameterChecker {
	public abstract BusinessObject run(BusinessObject businessData,BusinessObject parameter) throws Exception;
	
	public BusinessObject checkParameterValue(Object value,BusinessObject parameter) throws Exception{
		BusinessObject resultObject=BusinessObject.createBusinessObject();
		resultObject.setAttributeValue("CheckResult", "true");
		
		String parameterID = parameter.getString("ParameterID");
		String parameterName = parameter.getString("DisplayName");
		if(StringX.isEmpty(parameterName)){
			parameterName=parameter.getString("ParameterName");
		}
		if(StringX.isEmpty(parameterName)){
			parameterName=BusinessComponentConfig.getParameterDefinition(parameterID).getString("ParameterName");
		}
		
		BusinessObject parameterDefination = BusinessComponentConfig.getParameterDefinition(parameterID);
		
		/**
		 * add by bhxiao
		 * 判断产品参数的选项定义来源，
		 * 如果是代码库，则对代码校验翻译为中文
		 * */
		//begin
		String codesource = parameterDefination.getString("CODESOURCE");
		if(codesource==null||codesource.length()==0)codesource="";
		String code = parameterDefination.getString("CODESCRIPT");
		if(code==null||code.length()==0)code="";
		//end
		String operatorString = parameter.getString("OPERATOR");
		if(StringX.isEmpty(operatorString)){
			operatorString=parameterDefination.getString("OPERATOR");
		}
		if(StringX.isEmpty(operatorString)) return resultObject;
		
		String methodType = parameter.getString("MethodType");
		if(methodType==null||methodType.length()==0){
			methodType=parameterDefination.getString("MethodType");
		}
		if(StringX.isEmpty(methodType)||methodType.equals(BusinessComponentConfig.PARAMETER_METHOD_TYPE_NONE)){
			return resultObject;
		}
		boolean pass=true;
		String message="";
		String[] operatorArray = operatorString.split(",");
		for(String operator:operatorArray){
			Item operatorDefinition=CodeManager.getItem("ComponentParameterOperator", operator);
			String operatorClassName=operatorDefinition.getItemDescribe();
			if(StringX.isEmpty(operatorClassName)) continue;
			com.amarsoft.app.base.script.operater.CompareOperator compareOperator=(com.amarsoft.app.base.script.operater.CompareOperator)Class.forName(operatorClassName).newInstance();
			Object parameterValue=parameter.getObject(operator);
			if(parameterValue==null)continue;//产品参数未配置的，直接返回不校验
			boolean result=compareOperator.compare(value,parameterValue);
			if(!result){
				/**
				 * add by bhxiao
				 * 判断产品参数的选项定义来源，
				 * 如果是代码库，则对代码校验翻译为中文
				 * */
				//begin
				String valueName = "";
				String parameterValueName = "";
				if("Code".equalsIgnoreCase(codesource)){
					valueName = CodeManager.getItemName(code, value.toString());
					if((parameterValue.toString()).indexOf(",")>=0){
						String [] valueTemp = parameterValue.toString().split(",");
						for(int i=0;i<valueTemp.length;i++){
							String ValueNameTemp = CodeManager.getItemName(code, valueTemp[i]);
							if(ValueNameTemp!=null&&ValueNameTemp.length()>0){
								parameterValueName += ValueNameTemp+",";
							}
						}
						if(parameterValueName.length()>0&&parameterValueName.endsWith(","))
							parameterValueName=parameterValueName.substring(0, parameterValueName.lastIndexOf(","));
					}else{
						parameterValueName = CodeManager.getItemName(code, parameterValue.toString());
					}
					
				}
				//end
				message+=""+parameterName+"不正确！录入值["+("020".equals(codesource)? valueName: value)+"]，规则定义"+operatorDefinition.getItemName()+"为["+("020".equals(codesource)? parameterValueName: parameterValue)+"]";
				pass=false;
			}
		}

		if(pass==true)resultObject.setAttributeValue("CheckResult", "true");
		else resultObject.setAttributeValue("CheckResult", "false");
		resultObject.setAttributeValue("Message", message);
		return resultObject;
	}
	
	public static ParameterChecker getParameterChecker(String parameterID) throws Exception{
		String checkScript=BusinessComponentConfig.getParameterDefinition(parameterID).getString("CHECKSCRIPT");
		if(StringX.isEmpty(checkScript)){
			String codeSource=BusinessComponentConfig.getParameterDefinition(parameterID).getString("CodeSource");
			if(!StringX.isEmpty(codeSource)&&codeSource.equals("Code")){
				checkScript="com.amarsoft.app.als.businesscomponent.analysis.checkmethod.impl.CodeParameterChecker";
			}
			else {
				checkScript="com.amarsoft.app.als.businesscomponent.analysis.checkmethod.impl.DefaultParameterChecker";
			}
		}
		
		Class<?> c = Class.forName(checkScript);
		ParameterChecker checker = (ParameterChecker)c.newInstance();
		return checker;
	}
	
}
