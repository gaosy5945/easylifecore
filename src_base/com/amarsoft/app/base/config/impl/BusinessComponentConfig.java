package com.amarsoft.app.base.config.impl;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectCache;
import com.amarsoft.app.base.exception.ALSException;
import com.amarsoft.are.ARE;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.xml.Document;
import com.amarsoft.are.util.xml.Element;

public class BusinessComponentConfig extends XMLConfig{
	public static final String BUSINESS_PARAMETER = "Parameter";
	public static final String BUSINESS_COMPONENT_RULE = "Rule";
	public static final String BUSINESS_COMPONENT = "Component";
	public static final String BUSINESS_COMPONENT_PARAMETER = "Parameter";
	public static final String BUSINESS_COMPONENT_DECISIONTABLE = "DecisionTable";
	public static final String BUSINESS_COMPONENT_DECISIONTREE = "DecisionTree";
	public static final String BUSINESS_COMPONENT_CHILDRENCOMPONENT = "ChildrenComponent";

	public static final String BUSINESS_COMPONENT_FORMAT_PARAMETER_SET = "1";
	public static final String BUSINESS_COMPONENT_FORMAT_DECISION_TABLE = "2";
	public static final String BUSINESS_COMPONENT_FORMAT_COMPLEX = "3";
	public static final String BUSINESS_COMPONENT_FORMAT_DECISION_TREE = "4";
	
	public static final String PARAMETER_METHOD_TYPE_NONE = "Nothing"; 
	public static final String PARAMETER_METHOD_TYPE_JBO = "JBO"; 
	public static final String PARAMETER_METHOD_TYPE_AMARSCIPT = "AmarScript";
	public static final String PARAMETER_METHOD_TYPE_JAVA = "Java";
	public static final String PARAMETER_METHOD_TYPE_SQL = "SQL";
	
	public static final String PARAMETER_RIGHT_TYPE_ALL = "All";
	public static final String PARAMETER_RIGHT_TYPE_READONLY = "ReadOnly";
	public static final String PARAMETER_RIGHT_TYPE_HIDE = "Hide";
	public static final String PARAMETER_RIGHT_TYPE_REQUIRED = "Required";
	public static final String PARAMETER_RIGHT_TYPE_NONE = "None";
	
	public static final String PARAMETER_ID_COMPONENTDATALOADER = "ComponentDataLoader";
	public static final String PARAMETER_ID_COMPONENTCHECKER = "ComponentChecker";
	
	private static BusinessObjectCache parameterCache=new BusinessObjectCache(1000);
	private static BusinessObjectCache componentCache=new BusinessObjectCache(1000);
	
	//单例模式
	private static BusinessComponentConfig bcc = null;
	
	public BusinessComponentConfig(){
		
	}
	
	public static BusinessComponentConfig getInstance(){
		if(bcc == null)
			bcc = new BusinessComponentConfig();
		return bcc;
	}
	
	public synchronized void init(String file,int size)  throws Exception {
		file = ARE.replaceARETags(file);
		Document document = getDocument(file.split(",")[0]);
		Element root = document.getRootElement();
		
		BusinessObjectCache parameterCache=new BusinessObjectCache(size);
		BusinessObjectCache componentCache=new BusinessObjectCache(size);
		
		@SuppressWarnings("unchecked")
		List<BusinessObject> parameterList = this.convertToBusinessObjectList(root.getChildren("Parameter"));
		if (parameterList!=null) {
			for (BusinessObject parameter : parameterList) {
				parameterCache.setCache(parameter.getString("ParameterID"), parameter);
			}
		}
		
		document = getDocument(file.split(",")[1]);
		root = document.getRootElement();
		
		List<BusinessObject> componentList = this.convertToBusinessObjectList(root.getChildren("Component"));
		if (componentList!=null) {
			for (BusinessObject component : componentList) {
				componentCache.setCache(component.getString("id"), component);
			}
		}
		
		BusinessComponentConfig.parameterCache = parameterCache;
		BusinessComponentConfig.componentCache = componentCache;
	}
	
	/**
	 * 根据参数ID，获取业务参数定义
	 * @param parameterID
	 * @return
	 * @throws Exception
	 */
	public static BusinessObject getParameterDefinition(String parameterID) throws Exception {
		BusinessObject parameter = (BusinessObject)parameterCache.getCacheObject(parameterID);
		if(parameter==null){
			String desc ="未找到业务参数{" + parameterID + "}！错误的参数编号，或者未初始化环境变量!";
			throw new Exception(desc);
		}
    	return parameter;
	}
    
    /**
   	 * 根据组件ID，从缓存中获取组件信息
   	 * @param termID
   	 * @param sqlca
   	 * @return
   	 * @throws Exception
   	 */
	public static BusinessObject getComponent(String componentID) throws Exception{
		BusinessObject component = (BusinessObject)componentCache.getCacheObject(componentID);
		if(component==null){
			String desc ="未找到组件{" + componentID + "}！错误的组件编号，或者未初始化环境变量!";
			throw new Exception(desc);
		}
		
       return component;
	}
	
	/**
	 * 通过指定的条件获取组件
	 * @param matchSql
	 * @return
	 * @throws Exception
	 */
	public static List<BusinessObject> getComponents(String matchSql) throws Exception{
		List<BusinessObject> ls = new ArrayList<BusinessObject>();
		String[] keys = componentCache.getCacheObjects().keySet().toArray(new String[0]);
		for(String key:keys)
		{
			BusinessObject component = (BusinessObject)componentCache.getCacheObject(key);
			if(component.matchSql(matchSql, null))
			{
				ls.add(component);
			}
		}
		return ls;
	}
	
	/**
	 * 获取组件属性
	 * @param componentID
	 * @param attributeID
	 * @return
	 * @throws Exception
	 */
	public static String getComponentAttribute(String componentID,String attributeID) throws Exception{
		BusinessObject component = getComponent(componentID);
		return component.getString(attributeID);
	}
	
	public static List<BusinessObject> getComponentRules(String componentID) throws Exception{
		BusinessObject component=getComponent(componentID);
		return component.getBusinessObjects(BUSINESS_COMPONENT_RULE);
	}
	
	public static BusinessObject getComponentRule(String componentID,String ruleID) throws Exception{
		BusinessObject component=getComponent(componentID);
		return getComponentRule(component,ruleID);
	}
	
	public static List<BusinessObject> getComponentRules(BusinessObject component,BusinessObject parameter) throws Exception{
		List<BusinessObject> componentRules = component.getBusinessObjects(BUSINESS_COMPONENT_RULE);
		List<BusinessObject> results = new ArrayList<BusinessObject>();
		for(BusinessObject componentRule:componentRules)
		{
			if(parameter.matchSql(componentRule.getString("Filter"), null))
				results.add(componentRule);
		}
		
		return results;
	}
	
	public static BusinessObject getComponentRule(BusinessObject component,String ruleID) throws Exception{
		BusinessObject rule = component.getBusinessObjectByAttributes(BUSINESS_COMPONENT_RULE,"id",ruleID);
		if(rule==null) throw new Exception("未找到组件规则！ComponentID="+component.getKeyString()+",RuleID="+ruleID);
		return rule;
	}
	
	public static String getComponentValue(BusinessObject businessObject,BusinessObject segment,BusinessObject parameter, String parameterID,String attributeID) throws Exception {
		String termID = segment.getString("TermID");
		String segTermID = segment.getString("SegTermID");
		
		BusinessObject component=BusinessComponentConfig.getComponent(termID);
		
		if(!StringX.isEmpty(segTermID))
			return BusinessComponentConfig.getComponentParameter(component.getBusinessObjectBySql("ChildrenComponent", "ID=:ID", "ID",segTermID), parameterID, parameter).getString(attributeID);
		else
			return BusinessComponentConfig.getComponentParameter(component, parameterID, parameter).getString(attributeID);
	}
	
	public static BusinessObject getComponentParameter(BusinessObject component,String parameterID,BusinessObject parameter) throws Exception{
		List<BusinessObject> rules = getComponentRules(component,parameter);
		if(rules == null || rules.isEmpty()) throw new ALSException("EC5012",component.getString("id"));
		if(rules.size() > 1) throw new ALSException("EC5013",component.getString("id"));
		
		return getComponentParameter(component,rules.get(0),parameterID);
	}
	
	public static BusinessObject getComponentParameter(BusinessObject component,BusinessObject rule,String parameterID) throws Exception{
		BusinessObject parameter = rule.getBusinessObjectByAttributes(BUSINESS_PARAMETER,"id", parameterID);
		if(parameter==null) throw new Exception("未找到组件参数！ComponentID="+component.getKeyString()+",RuleID="+rule.getString("id")+",ParameterID="+parameterID);
		return parameter;
	}
}