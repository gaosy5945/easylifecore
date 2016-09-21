package com.amarsoft.app.als.businesscomponent.analysis;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.amarsoft.app.als.businesscomponent.analysis.checker.ComponentAnalysisor;
import com.amarsoft.app.als.businesscomponent.analysis.dataloader.ComponentDataLoader;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.config.impl.BusinessComponentConfig;
import com.amarsoft.app.base.util.StringHelper;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.dict.als.manage.CodeManager;
import com.amarsoft.dict.als.object.Item;

public class BusinessComponentAnalysisFunctions {
	
	public static String getOptionalValue(BusinessObject businessData,BusinessObject component,String parameterID,String sceneType,String sceneNo,BusinessObjectManager bomanager) throws Exception{
		return (String)BusinessComponentAnalysisFunctions.getValidValue(businessData, component, parameterID, "OPTIONALVALUE", sceneType, sceneNo, bomanager);
	}
	
	public static String getMandatoryValue(BusinessObject businessData,BusinessObject component,String parameterID,String sceneType,String sceneNo,BusinessObjectManager bomanager) throws Exception{
		return (String)BusinessComponentAnalysisFunctions.getValidValue(businessData, component, parameterID, "MANDATORYVALUE", sceneType, sceneNo, bomanager);
	}
	
	public static String getDefaultValue(BusinessObject businessData,BusinessObject component,String parameterID,String sceneType,String sceneNo,BusinessObjectManager bomanager) throws Exception{
		return (String)BusinessComponentAnalysisFunctions.getValidValue(businessData, component, parameterID, "VALUE", sceneType, sceneNo, bomanager);
	}
	
	public static double getMaxValue(BusinessObject businessData,BusinessObject component,String parameterID,String sceneType,String sceneNo,BusinessObjectManager bomanager) throws Exception{
		return (Double)BusinessComponentAnalysisFunctions.getValidValue(businessData, component, parameterID, "MAXIMUMVALUE", sceneType, sceneNo, bomanager);
	}
	
	public static double getMinValue(BusinessObject businessData,BusinessObject component,String parameterID,String sceneType,String sceneNo,BusinessObjectManager bomanager) throws Exception{
		return (Double)BusinessComponentAnalysisFunctions.getValidValue(businessData, component, parameterID, "MINIMUMVALUE", sceneType, sceneNo, bomanager);
	}
	
	public static Object getValidValue(BusinessObject businessData,BusinessObject component,String parameterID,String valueField,String sceneType,String sceneNo,BusinessObjectManager bomanager) throws Exception{
		BusinessObject validParameter = BusinessComponentAnalysisFunctions.getValidParameter(businessData, component, parameterID, sceneType, sceneNo, bomanager);
		if(validParameter==null) return null;
		return validParameter.getObject(valueField);
	}
	
	public static BusinessObject getValidParameter(BusinessObject businessData,BusinessObject component,String parameterID,String sceneType,String sceneNo,BusinessObjectManager bomanager) throws Exception{
		Map<String,BusinessObject> result = getValidParameterList(businessData,component,parameterID,sceneType,sceneNo,bomanager);
		return result.get(parameterID);
	}
	
	public static Map<String,BusinessObject> getValidParameterList(BusinessObject businessObject,BusinessObject component,String parameterIDString,String sceneType,String sceneNo,BusinessObjectManager bomanager) throws Exception{
		Map<String,BusinessObject> result= new HashMap<String,BusinessObject>();
		if(sceneNo.equals("02")){
			List<BusinessObject> l=component.getBusinessObjects(BusinessComponentConfig.BUSINESS_COMPONENT_PARAMETER);
			for(BusinessObject p:l){
				if(StringX.isEmpty(parameterIDString)||StringHelper.contains(parameterIDString, p.getString("ParameterID"))){
					result.put(p.getString("ParameterID"),p);
				}
			}
		}
		else{
			ComponentDataLoader loader = getComponentDataLoader(component);
			List<BusinessObject> componentDatas=loader.getComponentDataList(businessObject,component,bomanager);
			return getValidParameterList(componentDatas,component,parameterIDString,sceneType,sceneNo,bomanager);
		}
		return result;
	}
	
	public static BusinessObject getValidParameter(BusinessObject component,String outputParameterID,String inputParameterString,BusinessObjectManager bomanager) throws Exception{
		BusinessObject businessData=BusinessObject.createBusinessObject();
		String[] inputParameters=inputParameterString.split(";");
		for(String inputParameter:inputParameters){
			String[] parameter=inputParameter.split("=");
			String[] parameterValues=parameter[1].trim().split(",");
			ArrayList<Object> values = new ArrayList<Object>();
			for(String parameterValue:parameterValues){
				Object valueObject=BusinessComponentAnalysisFunctions.convertParameterValue(parameterValue, parameter[0]);
				values.add(valueObject);
			}
			businessData.setAttributeValue(parameter[0], values);
		}
		List<BusinessObject> componentDatas=new ArrayList<BusinessObject>();
		componentDatas.add(businessData);
		
		Map<String, BusinessObject> m = 
				BusinessComponentAnalysisFunctions.getValidParameterList(componentDatas, component, outputParameterID, "", "", bomanager);
		return m.get(outputParameterID);
	}
	
	public static Map<String,BusinessObject> getValidParameterList(List<BusinessObject> componentDatas,BusinessObject component,String parameterIDString,String sceneType,String sceneNo,BusinessObjectManager bomanager) throws Exception{
		Map<String,BusinessObject> result= new HashMap<String,BusinessObject>();
		
		ComponentAnalysisor checker = getComponentAnalysisor(component);
		boolean b = checker.check(componentDatas, component,parameterIDString,bomanager);
		
		if(b){
			List<String> l = checker.getValidRuleList();
			for(String id:l){
				BusinessObject rule=component.getBusinessObjectBySql(BusinessComponentConfig.BUSINESS_COMPONENT_DECISIONTABLE, "ID=:ID","ID",id);
				
				List<BusinessObject> parameterList = component.getBusinessObjects(BusinessComponentConfig.BUSINESS_COMPONENT_PARAMETER);
				for(BusinessObject parameter:parameterList){
					String parameterID = parameter.getString("ParameterID");
					
					BusinessObject parameterValue = BusinessObject.createBusinessObject();
					parameterValue.setAttributes(parameter);
					for(String attributeID:rule.getAttributeIDArray())
					{
						if(attributeID != null && (attributeID.endsWith("_"+parameterID) || attributeID.endsWith("_"+parameterID.toUpperCase())))
						{
							parameterValue.setAttributeValue(attributeID.substring(0, attributeID.length()-parameterID.length()-1), rule.getObject(attributeID));
						}
					}
					
					if(StringHelper.contains(parameterIDString, parameterValue.getString("ParameterID"))||StringX.isEmpty(parameterIDString)){
						BusinessObject validParameter=result.get(parameterValue.getString("ParameterID"));
						if(validParameter==null){
							validParameter=BusinessObject.createBusinessObject();
							validParameter.setAttributeValue("ParameterID", parameterValue.getString("ParameterID"));
							result.put(parameterValue.getString("ParameterID"), validParameter);
						}
						unionParameter(validParameter,parameterValue);
					}
				}
			}
		}
		return result;
	}
	
	public static void unionParameter(BusinessObject paramter,BusinessObject source) throws Exception{
		Item[] operators=CodeManager.getItems("ComponentParameterOperator");
		for(Item operator:operators){
			String valueField=operator.getItemNo();
			Object validValue = paramter.getObject(valueField);
			Object value = source.getObject(valueField);
			if(value==null||"".equals(value)) continue;
			
			if(value instanceof String){
				String validValueString=(String)validValue;
				if(validValueString==null) validValueString="";
				String[] s=((String) value).split(",");
				for(String s1:s){
					if(!StringHelper.contains(validValueString, s1)){
						validValueString+=","+s1;
					}
				}
				if(validValueString.startsWith(","))validValueString=validValueString.substring(1);
				validValue=validValueString;
			}
			else if(value instanceof Number){
				if(validValue==null) validValue=value;
				if(valueField.equalsIgnoreCase("MaximumValue")&&((Double)validValue<(Double)value)){
					validValue=value;
				}
				else if(valueField.equalsIgnoreCase("MinimumValue")&&((Double)validValue>(Double)value)){
					validValue=value;
				}
			}
			
			paramter.setAttributeValue(valueField, validValue);
		}
	}
	
	/**
   	 * 根据参数ID，获取对应的jbo属性名称
   	 * @param parameterID
   	 * @param objectType
   	 * @return
   	 * @throws Exception
   	 */
   	public static String getJBOAttributeID(String parameterID,String objectType) throws Exception{
   		Map<String, String> map = getParameterValueObjectType(parameterID);
   		return map.get(objectType);
   	}
   	
	/**
	 * 根据指定参数ID，获取有JBO ClassName，以数组形式范围
	 * @param parameterID
	 * @return
	 * @throws Exception
	 */
	public static Map<String,String> getParameterValueObjectType(String parameterID) throws Exception{
		Map<String,String> result = new HashMap<String,String>();
		BusinessObject parameter = BusinessComponentConfig.getParameterDefinition(parameterID);
   		String methodType = parameter.getString("MethodType");
   		String methodScript = parameter.getString("MethodScript");
   		if(StringX.isEmpty(methodScript)){
   			return result;
   		}
   		if(BusinessComponentConfig.PARAMETER_METHOD_TYPE_JBO.equals(methodType)){
   			String[] s= methodScript.split(";");
	   		for(String s1:s){
	   			if(s1.indexOf(".")>0){
	   				String objectType=s1.substring(0,s1.lastIndexOf("."));
	   				String attributeID=s1.substring(s1.lastIndexOf(".")+1);
	   				result.put(objectType, attributeID);
	   			}
	   		}
   		}else if(BusinessComponentConfig.PARAMETER_METHOD_TYPE_JAVA.equals(methodType)){
   			return result;
   		}
   		else{
	   		String hostObjectType=parameter.getString("HostObjectType");
   			if(!StringX.isEmpty(hostObjectType)){
   				String[] s=hostObjectType.split(";");
   				for(String s1:s){
   					result.put(s1,null);
   				}
   			}
   		}
   		return result;
   	}
	
	public static ComponentAnalysisor getComponentAnalysisor(BusinessObject component)
			throws Exception {
		String className = null;
		BusinessObject parameter_CheckerClass=component.getBusinessObjectBySql(BusinessComponentConfig.BUSINESS_COMPONENT_PARAMETER, "ParameterID=:ParameterID", "ParameterID", BusinessComponentConfig.PARAMETER_ID_COMPONENTCHECKER);
		if(parameter_CheckerClass!=null) className = parameter_CheckerClass.getString("Value");
		if(StringX.isEmpty(className)){
			className = "com.amarsoft.app.als.businesscomponent.analysis.checker.impl.DefaultComponentAnalysisor";
		}
		Class<?> loaderClass = Class.forName(className);
		ComponentAnalysisor checker = (ComponentAnalysisor)loaderClass.newInstance();
		return checker;
	}
	
	public static ComponentDataLoader getComponentDataLoader(BusinessObject component)
			throws Exception {
		String className = null;
		BusinessObject parameter_CheckerClass=component.getBusinessObjectBySql(BusinessComponentConfig.BUSINESS_COMPONENT_PARAMETER, "ParameterID=:ParameterID", "ParameterID", BusinessComponentConfig.PARAMETER_ID_COMPONENTDATALOADER);
		if(parameter_CheckerClass!=null) className = parameter_CheckerClass.getString("Value");
		if(StringX.isEmpty(className)){
			className = "com.amarsoft.app.als.businesscomponent.analysis.checker.impl.DefaultComponentAnalysisor";
		}
		Class<?> loaderClass = Class.forName(className);
		ComponentDataLoader checker = (ComponentDataLoader)loaderClass.newInstance();
		return checker;
	}
	
	public static Object convertParameterValue(Object value,String parameterID) throws Exception{
		String dataType = BusinessComponentConfig.getParameterDefinition(parameterID).getString("DataType");
		if("2".equals(dataType)||"5".equals(dataType)||"6".equals(dataType)){
			if(value instanceof Number) return value;
			String valueString=(String)value;
			valueString=StringHelper.replaceAllIgnoreCase(valueString, ",", "");
			return Double.parseDouble(valueString);
		}
		else return value;
	}
	
	public static Object convertParameterValue(Object value,BusinessObject parameter) throws Exception{
		return convertParameterValue(value,parameter.getString("ParameterID"));
	}
}
