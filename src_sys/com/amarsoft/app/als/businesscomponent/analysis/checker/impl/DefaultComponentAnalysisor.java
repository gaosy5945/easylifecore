package com.amarsoft.app.als.businesscomponent.analysis.checker.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeSet;

import com.amarsoft.app.als.businesscomponent.analysis.BusinessComponentAnalysisFunctions;
import com.amarsoft.app.als.businesscomponent.analysis.checker.ComponentAnalysisor;
import com.amarsoft.app.als.businesscomponent.analysis.checkmethod.ParameterChecker;
import com.amarsoft.app.als.businesscomponent.analysis.dataloader.ComponentDataLoader;
import com.amarsoft.app.als.businesscomponent.analysis.dataloader.ParameterDataLoader;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.config.impl.BusinessComponentConfig;
import com.amarsoft.app.base.script.operater.impl.Contains;
import com.amarsoft.app.base.util.StringHelper;
import com.amarsoft.are.lang.StringX;

/**
 * 组件校验类
 * @author amarsoft
 *
 */
public class DefaultComponentAnalysisor implements ComponentAnalysisor,ComponentDataLoader {
	private List<String> validRuleList = new ArrayList<String>();
	private List<String> invalidRuleList = new ArrayList<String>();
	private BusinessObject component=null;
	private Map<String,List<String>> errorMessages = new HashMap<String,List<String>>();
	
	private Map<String,String[]> getKeyParameters(BusinessObject businessObject,BusinessObject component) throws Exception{
		Map<String,String[]> componentKeyAttributes=new HashMap<String,String[]>();
		List<BusinessObject> parameters=component.getBusinessObjects(BusinessComponentConfig.BUSINESS_COMPONENT_PARAMETER);
		for(BusinessObject parameter:parameters){
			String parameterID=parameter.getString("ParameterID");
			String operator=parameter.getString("Operator");
			if(StringX.isEmpty(operator)){
				operator = BusinessComponentConfig.getParameterDefinition(parameterID).getString("Operator");
			}
			
			if(operator.equals("VALUE")){//只有默认值的情况下，认为是有效范围的过滤
				Map<String, String> map = BusinessComponentAnalysisFunctions.getParameterValueObjectType(parameterID);
				for(String objectType:map.keySet()){
					if(objectType.equals(businessObject.getKeyString())||!businessObject.getBusinessObjects(objectType).isEmpty()){
						String[] s={objectType,map.get(objectType)};
						componentKeyAttributes.put(parameterID, s);
					}
				}
			}
		}
		return componentKeyAttributes;
	}
	
	private String getComponentDataObjectType(BusinessObject businessObject, BusinessObject component) throws Exception{
		TreeSet<String> result = new TreeSet<String>();
		
		List<BusinessObject> parameters=component.getBusinessObjects(BusinessComponentConfig.BUSINESS_COMPONENT_PARAMETER);
		for(BusinessObject parameter:parameters){
			String parameterID = parameter.getString("ParameterID");
			
			Map<String, String> map = BusinessComponentAnalysisFunctions.getParameterValueObjectType(parameterID);
			if(map.containsKey(businessObject.getBizClassName())) break;
			for(String objectType:map.keySet()){
				if(objectType.equals(businessObject.getBizClassName())) continue;
				if(!businessObject.getBusinessObjects(objectType).isEmpty()){
					result.add(objectType);
				}
			}
		}
		if(result.isEmpty()) return businessObject.getBizClassName();
		else if(result.size()>1){
			throw new Exception("不支持的组件定义！");
		}
		else return result.first();
	}
	
	public List<BusinessObject> getComponentDataList(BusinessObject businessObject,BusinessObject component,BusinessObjectManager bomanager) throws Exception{
		Map<String, String[]> keyParameters = this.getKeyParameters(businessObject,component);
		List<BusinessObject> parameters=component.getBusinessObjects(BusinessComponentConfig.BUSINESS_COMPONENT_PARAMETER);
		
		List<BusinessObject> result = new ArrayList<BusinessObject>();
		String dataObjectType=this.getComponentDataObjectType(businessObject, component);
		if(dataObjectType.equals(businessObject.getBizClassName())){
			BusinessObject componentData = BusinessObject.createBusinessObject();
			for(BusinessObject parameter:parameters){
				ParameterDataLoader ploader =ParameterDataLoader.getParameterDataLoader(parameter);
				if(ploader==null) continue;
				List<Object> pvalue = ploader.getParameterData(parameter, businessObject, bomanager);
				
				componentData.setAttributeValue(parameter.getString("ParameterID"), pvalue);
				
			}
			result.add(componentData);
		}
		else{
			List<BusinessObject> subObjectList = businessObject.getBusinessObjects(dataObjectType);
			for(BusinessObject subObject:subObjectList){
				boolean pass=true;
				for(String parameterID:keyParameters.keySet()){
					String[] s = keyParameters.get(parameterID);
					if(s[0].equals(subObject.getBizClassName())){
						Object o=subObject.getObject(s[1]);//值和组件中定义的值比较
						BusinessObject p=component.getBusinessObjectBySql(BusinessComponentConfig.BUSINESS_COMPONENT_PARAMETER," ParameterID=:ParameterID","ParameterID",parameterID);
						Object pvalue=p.getObject("VALUE");
						if(pvalue!=null&&!"".equals(pvalue)){
							Contains c=new Contains();
							if(!c.compare(pvalue, o)){
								pass=false;
								break;
							}
						}
					}
				}
				if(!pass) continue;
				BusinessObject subObjectNew = BusinessObject.createBusinessObject();
				for(BusinessObject parameter:parameters){
					Map<String, String> objectTypeMap = BusinessComponentAnalysisFunctions.getParameterValueObjectType(parameter.getString("ParameterID"));
					ParameterDataLoader ploader =ParameterDataLoader.getParameterDataLoader(parameter);
					if(ploader==null)continue;
					List<Object> pvalue = null;
					if(StringX.isEmpty(objectTypeMap.get(subObject.getBizClassName()))){
						pvalue = ploader.getParameterData(parameter, businessObject, bomanager);
					}
					else{
						pvalue = ploader.getParameterData(parameter, subObject, bomanager);
					}
					
					subObjectNew.setAttributeValue(parameter.getString("ParameterID"), pvalue);
					
				}
				result.add(subObjectNew);
			}
		}
		return result;
	}

	@Override
	public boolean check(List<BusinessObject> list,BusinessObject component,String outputParameter,BusinessObjectManager bomanager) throws Exception {
		boolean result=true;
		this.component=component;
		List<BusinessObject> rules = component.getBusinessObjects(BusinessComponentConfig.BUSINESS_COMPONENT_DECISIONTABLE);
		if(rules==null||rules.isEmpty()) return true;
		
		for(BusinessObject componentData:list){
			for(BusinessObject rule:rules){
				String id = rule.getString("ID");
				if(StringX.isEmpty(id)) continue;
				boolean b = this.parseRule(componentData,id,outputParameter);
				if(b){
					validRuleList.add(id);
				}
				else invalidRuleList.add(id);
			}
			if(getValidRuleList().isEmpty())result= false;
		}
		return result;
	}
	
	/**
	 * 解析决策表的一行
	 * @param s
	 * @param para
	 * @param bizObject
	 * @return
	 * @throws Exception
	 */
	public boolean parseRule(BusinessObject componentData,String ruleID,String outputParameterID) throws Exception{
		boolean b = true;
		
		List<String> ruleErrorMessageList=new ArrayList<String>();
		List<BusinessObject> parameters=component.getBusinessObjects(BusinessComponentConfig.BUSINESS_COMPONENT_PARAMETER);
		for(BusinessObject parameter:parameters){
			String parameterID=parameter.getString("ParameterID");
			if(!StringX.isEmpty(outputParameterID)&&StringHelper.contains(outputParameterID, parameterID)){
				continue;
			}
			ParameterChecker checker =ParameterChecker.getParameterChecker(parameterID);
			BusinessObject rule = this.component.getBusinessObjectBySql(BusinessComponentConfig.BUSINESS_COMPONENT_DECISIONTABLE
					, "ID=:ID ", "ID", ruleID);
			
			BusinessObject parameterValue = BusinessObject.createBusinessObject(parameter);
			parameterValue.setAttributes(parameter);
			for(String attributeID:rule.getAttributeIDArray())
			{
				if(attributeID != null && (attributeID.endsWith("_"+parameterID) || attributeID.endsWith("_"+parameterID.toUpperCase())))
				{
					parameterValue.setAttributeValue(attributeID.substring(0, attributeID.length()-parameterID.length()-1), rule.getObject(attributeID));
				}
			}
			if(!componentData.containsAttribute(parameterID))continue;//如果不包含这个参数，则直接返回
			BusinessObject resultObject = checker.run(componentData,parameterValue);
			if(!"true".equals(resultObject.getString("CheckResult"))){
				b=false;
				ruleErrorMessageList.add(resultObject.getString("Message"));
			}
		}
		if(!b){
			errorMessages.put(ruleID, ruleErrorMessageList);
		}
		return b;
	}

	@Override
	public List<String> getValidRuleList() throws Exception {
		return validRuleList;
	}
	
	public List<String> getInvalidRuleList() throws Exception{
		return invalidRuleList;
	}

	@Override
	public List<String> getErrorMessage() throws Exception {
		List<String> errorMessageList = new ArrayList<String>();
		String errorRuleSerialno=null;
		for(String ruleSerialNo:errorMessages.keySet()){
			List<String> ruleErrorMessages=errorMessages.get(ruleSerialNo);
			if(ruleErrorMessages.isEmpty()) continue;
			if(StringX.isEmpty(errorRuleSerialno)){
				errorRuleSerialno=ruleSerialNo;
			}
			else{
				if(errorMessages.get(ruleSerialNo).size()<errorMessages.get(errorRuleSerialno).size()){
					errorRuleSerialno=ruleSerialNo;
				}
			}
		}
		if(!StringX.isEmpty(errorRuleSerialno)){
			errorMessageList.addAll(errorMessages.get(errorRuleSerialno));
		}
		return errorMessageList;
	}
}
