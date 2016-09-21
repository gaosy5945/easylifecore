package com.amarsoft.app.als.prd.analysis;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.amarsoft.app.als.businesscomponent.analysis.BusinessComponentAnalysisFunctions;
import com.amarsoft.app.als.businesscomponent.analysis.checker.ComponentAnalysisor;
import com.amarsoft.app.als.businesscomponent.analysis.dataloader.ComponentDataLoader;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectHelper;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.config.impl.BusinessComponentConfig;
import com.amarsoft.app.als.prd.config.loader.ProductConfig;
import com.amarsoft.are.ARE;
import com.amarsoft.are.lang.StringX;

public class ProductAnalysisFunctions {
	public static double getComponentMaxValue(BusinessObject businessData,String componentID,String parameterID,String sceneType,String sceneNo) throws Exception{
		Object v= (Double)ProductAnalysisFunctions.getComponentParameterValue(businessData, componentID, parameterID, "MaximumValue", sceneType, sceneNo);
		if(v==null) return 0d;
		else return (Double)v;
	}
	
	public static double getComponentMinValue(BusinessObject businessData,String componentID,String parameterID,String sceneType,String sceneNo) throws Exception{
		Object v=ProductAnalysisFunctions.getComponentParameterValue(businessData, componentID, parameterID, "MinimumValue", sceneType, sceneNo);
		if(v==null) return 0d;
		else return (Double)v;
	}
	
	public static String getComponentMandatoryValue(BusinessObject businessData,String componentID,String parameterID,String sceneType,String sceneNo) throws Exception{
		return (String)ProductAnalysisFunctions.getComponentParameterValue(businessData, componentID, parameterID, "MANDATORYVALUE", sceneType, sceneNo);
	}
	
	public static String getComponentOptionalValue(BusinessObject businessData,String componentID,String parameterID,String sceneType,String sceneNo) throws Exception{
		return (String)ProductAnalysisFunctions.getComponentParameterValue(businessData, componentID, parameterID, "OPTIONALVALUE", sceneType, sceneNo);
	}
	
	public static String getComponentDefaultValue(BusinessObject businessData,String componentID,String parameterID,String sceneType,String sceneNo) throws Exception{
		return (String)ProductAnalysisFunctions.getComponentParameterValue(businessData, componentID, parameterID, "VALUE", sceneType, sceneNo);
	}
	
	public static String getProductDefaultValues(BusinessObject businessData,String parameterID,String sceneType,String sceneNo) throws Exception{
		return (String)ProductAnalysisFunctions.getProductParameterValue(businessData, parameterID, "VALUE", sceneType, sceneNo);
	}
	
	public static String getProductMandatoryValue(BusinessObject businessData,String parameterID,String sceneType,String sceneNo) throws Exception{
		return (String)ProductAnalysisFunctions.getProductParameterValue(businessData, parameterID, "MANDATORYVALUE", sceneType, sceneNo);
	}
	
	public static String getProductOptionalValue(BusinessObject businessData,String parameterID,String sceneType,String sceneNo) throws Exception{
		return (String)ProductAnalysisFunctions.getProductParameterValue(businessData, parameterID, "OPTIONALVALUE", sceneType, sceneNo);
	}
	
	public static Object getProductParameterValue(BusinessObject businessData,String parameterID,String valueField,String sceneType,String sceneNo) throws Exception{
		BusinessObject parameter = getProductParameter(businessData,parameterID,sceneType,sceneNo);
		if(parameter==null) return null;
		return parameter.getObject(valueField);
	}
	
	public static BusinessObject getProductParameter(BusinessObject businessData,String parameterID,String sceneType,String sceneNo) throws Exception{
		Map<String, BusinessObject> parameters = getProductParameters(businessData,sceneType,sceneNo);
		return parameters.get(parameterID);
	}
	
	public static Object getComponentParameterValue(BusinessObject businessData,String componentID,String parameterID,String valueField,String sceneType,String sceneNo) throws Exception{
		String businessType=businessData.getString("BusinessType");
		if(StringX.isEmpty(businessType)) return null;
		String productID=businessData.getString("ProductID");
		String specificID=businessData.getString("SpecificID");
		if(StringX.isEmpty(specificID))specificID=ProductConfig.DEFAULT_SPECIFICID;
		BusinessObject specific = ProductConfig.getSpecific(businessType, productID, specificID);
		BusinessObject component = specific.getBusinessObjectBySql(BusinessComponentConfig.BUSINESS_COMPONENT, "ID=:ID","ID",componentID);
		if(component==null){
			component=BusinessComponentConfig.getComponent(componentID);
		}
		if(component==null){
			String errorMessage="在该产品{"+productID+"}的版本{"+specificID+"}未找到组件{"+componentID+"}，请联系系统管理员完善产品参数配置！";
			ARE.getLog().warn(errorMessage);
			//throw new Exception(errorMessage);
			return null;
		}
		Object values= BusinessComponentAnalysisFunctions.getValidValue(businessData, component, parameterID, valueField, sceneType, sceneNo, BusinessObjectManager.createBusinessObjectManager());
		if(values==null||"".equals(values)){
			ARE.getLog().warn("在该业务所对应的组件{"+componentID+"}中未找到参数{"+parameterID+"}的有效值，请联系系统管理员完善产品参数配置！");
			return null;
		}
		return values;
	}
	
	public static Map<String,BusinessObject> getProductParameters(BusinessObject businessData,String sceneType,String sceneNo) throws Exception{
		Map<String,BusinessObject> result= new HashMap<String,BusinessObject>();
		String businessType = businessData.getString("BusinessType");
		String productID = businessData.getString("ProductID");
		String specificID = businessData.getString("SpecificID");
		BusinessObject specific = ProductConfig.getSpecific(businessType, productID, specificID);
		
		BusinessObjectManager bomanager=BusinessObjectManager.createBusinessObjectManager();
		List<BusinessObject> componentList =specific.getBusinessObjects(BusinessComponentConfig.BUSINESS_COMPONENT);
		for(BusinessObject component:componentList){
			Map<String, BusinessObject> componentParameters = BusinessComponentAnalysisFunctions.getValidParameterList(businessData, component, "", sceneType, sceneNo, bomanager);
			for(String parameterID:componentParameters.keySet()){
				BusinessObject parameter = componentParameters.get(parameterID);
				BusinessObject validParameter = result.get(parameterID);
				if(validParameter==null){
					validParameter=BusinessObject.createBusinessObject();
					validParameter.setAttributes(parameter);
					result.put(parameterID, validParameter);
				}
				BusinessComponentAnalysisFunctions.unionParameter(validParameter, parameter);
			}
		}
		return result;
	}
	
	public static List<String> checkProduct(BusinessObject businessObject) throws Exception{
		String businessType=businessObject.getString("BusinessType");
		String productID=businessObject.getString("ProductID");
		String specificID=businessObject.getString("SpecificID");
		if(StringX.isEmpty(specificID))specificID=ProductConfig.DEFAULT_SPECIFICID;
		BusinessObject specific = ProductConfig.getSpecific(businessType, productID, specificID);
		return checkProduct(businessObject,specific);
	}
	
	public static List<String> checkProduct(BusinessObject businessObject,BusinessObject specific) throws Exception{
		List<String> m = new ArrayList<String>();
		BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager();
		List<Object> componentTypeArray = BusinessObjectHelper.getDistinctValues(specific.getBusinessObjects(BusinessComponentConfig.BUSINESS_COMPONENT),"ComponentType");
		if(componentTypeArray.isEmpty()) return m;
		
		for(Object o:componentTypeArray){
			String componentType = (String)o;
			if(componentType.startsWith("PRD01")||componentType.startsWith("PRD02")){
				List<BusinessObject> componentList =specific.getBusinessObjectsBySql(BusinessComponentConfig.BUSINESS_COMPONENT, "ComponentType=:ComponentType","ComponentType",componentType);
				if(componentList==null||componentList.isEmpty()) continue;
				for(BusinessObject component:componentList){
					if(component.getString("ComponentID").equals("PRD02-03")) continue;
					ComponentAnalysisor checker = BusinessComponentAnalysisFunctions.getComponentAnalysisor(component);
					ComponentDataLoader loader = BusinessComponentAnalysisFunctions.getComponentDataLoader(component);
					List<BusinessObject> datalist = loader.getComponentDataList(businessObject, component, bomanager);
					
					try{
						boolean b = checker.check(datalist, component,"",bomanager);
						if(b) continue;//校验通过
						else m.addAll(checker.getErrorMessage());
					}
					catch(Exception e){
						e.printStackTrace();
						throw new Exception("解析组件{"+component.getString("ComponentID")+"}时出错！");
					}
				}
			}
		}
		return m;
	}
}
