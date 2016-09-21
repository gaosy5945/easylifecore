package com.amarsoft.app.als.businesscomponent.config.processor;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.als.awe.ow.ALSBusinessProcess;
import com.amarsoft.app.als.awe.ow.processor.BusinessObjectOWCreator;
import com.amarsoft.app.als.awe.ow.processor.BusinessObjectOWDeleter;
import com.amarsoft.app.als.awe.ow.processor.BusinessObjectOWQuerier;
import com.amarsoft.app.als.awe.ow.processor.BusinessObjectOWUpdater;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.config.impl.BusinessComponentConfig;
import com.amarsoft.app.base.util.XMLHelper;
import com.amarsoft.are.lang.StringX;

public class BusinessComponentProcess extends ALSBusinessProcess implements BusinessObjectOWCreator,BusinessObjectOWQuerier,BusinessObjectOWDeleter,BusinessObjectOWUpdater {
	private List<BusinessObject> ruleList;

	/**
	 * 保存组件规则
	 * @param tx
	 * @return
	 * @throws Exception
	 */
	private String saveComponentRule(BusinessObject bo) throws Exception{
		String id = bo.getString("ID");
		String componentID = this.asPage.getParameter("ComponentID");
		
		String xmlFile = this.asPage.getAttribute("XMLFile");
		String xmlTags = this.asPage.getAttribute("XMLTags");
		String keys = this.asPage.getAttribute("Keys");
		
		List<BusinessObject> components = XMLHelper.getBusinessObjectList(xmlFile, xmlTags+"|| id='"+componentID+"'", keys);
		BusinessObject component = components.get(0);
		String componentFormat = component.getString("Format");
		if(componentFormat.equals(BusinessComponentConfig.BUSINESS_COMPONENT_FORMAT_PARAMETER_SET) || componentFormat.equals(BusinessComponentConfig.BUSINESS_COMPONENT_FORMAT_COMPLEX)){
			List<BusinessObject> componentParameters = XMLHelper.getBusinessObjectList(xmlFile, xmlTags+"|| id='"+componentID+"'//Parameters//Parameter", "PARAMETERID");
			
			for(BusinessObject componentParameter:componentParameters)
			{
				for(String attribute:bo.getAttributeIDArray()){
					if(attribute.endsWith("_"+componentParameter.getString("PARAMETERID").toUpperCase()))
					{
						componentParameter.setAttributeValue(attribute.substring(0, attribute.indexOf("_"+componentParameter.getString("PARAMETERID").toUpperCase())), 
								bo.getObject(attribute));
					}
				}
			}
			
			XMLHelper.saveBusinessObjectList(xmlFile, xmlTags+"|| id='"+componentID+"'//Parameters//Parameter", "PARAMETERID", componentParameters);
		}
		else if(componentFormat.equals(BusinessComponentConfig.BUSINESS_COMPONENT_FORMAT_DECISION_TABLE)){
			List<BusinessObject> ls = new ArrayList<BusinessObject>();
			
			
			for(String key:keys.split(","))
			{
				if(StringX.isEmpty(bo.getString("OLDVALUEBACKUP"+key)))
					bo.setAttributeValue("OLDVALUEBACKUP"+key, bo.getString(key));
			}
			
			
			BusinessObject bo1 = BusinessObject.createBusinessObject();
			String[] attributes = bo.getAttributeIDArray();
			for(String attribute:attributes)
			{
				boolean virtualFlag = false;
				for(String virtualFields :asDataObject.getVirtualFields())
				{
					if(virtualFields.equalsIgnoreCase(attribute))
						virtualFlag = true;
				}
				
				if(asDataObject.getColumn(attribute) != null && !virtualFlag)
					bo1.setAttributeValue(attribute, bo.getObject(attribute));
			}
			bo1.removeAttribute("SYS_SERIALNO");
			
			ls.add(bo1);
			
			XMLHelper.saveBusinessObjectList(xmlFile, xmlTags+"|| id='"+componentID+"'//DecisionTables//DecisionTable", "ID", ls);
		}
		else if(componentFormat.equals(BusinessComponentConfig.BUSINESS_COMPONENT_FORMAT_DECISION_TREE)){
			//待实现
		}
		
		return "true";
	}

	@Override
	public List<BusinessObject> update(BusinessObject businessObject,
			ALSBusinessProcess businessProcess) throws Exception {
		saveComponentRule(businessObject);
		return null;
	}

	@Override
	public List<BusinessObject> update(List<BusinessObject> businessObjectList,
			ALSBusinessProcess businessProcess) throws Exception {
		for(BusinessObject businessObject:businessObjectList){
			saveComponentRule(businessObject);
		}
		
		return businessObjectList;
	}

	@Override
	public BusinessObject[] getBusinessObjectList(int fromIndex,
			int toIndex) throws Exception {
		if(toIndex>this.ruleList.size())toIndex=ruleList.size();
		List<BusinessObject> list = this.ruleList.subList(fromIndex, toIndex);
		return list.toArray(new BusinessObject[list.size()]);
	}

	public int query(BusinessObject inputParameters,
			ALSBusinessProcess businessProcess) throws Exception {
		
		String componentID = this.asPage.getParameter("ComponentID");
		
		String xmlFile = this.asPage.getAttribute("XMLFile");
		String xmlTags = this.asPage.getAttribute("XMLTags");
		String keys = this.asPage.getAttribute("Keys");
		
		List<BusinessObject> components = XMLHelper.getBusinessObjectList(xmlFile, xmlTags+"|| id='"+componentID+"'", keys);
		BusinessObject component = components.get(0);
		String componentFormat = component.getString("Format");
		if(componentFormat.equals(BusinessComponentConfig.BUSINESS_COMPONENT_FORMAT_PARAMETER_SET) || componentFormat.equals(BusinessComponentConfig.BUSINESS_COMPONENT_FORMAT_COMPLEX)){
			List<BusinessObject> componentParameters = XMLHelper.getBusinessObjectList(xmlFile, xmlTags+"|| id='"+componentID+"'//Parameters//Parameter", "PARAMETERID");
			
			BusinessObject businessObject=BusinessObject.createBusinessObject();
			for(BusinessObject parameter:componentParameters){
				String parameterID = parameter.getString("ParameterID");
				
				String selectType = parameter.getString("SELECTTYPE");//设置选择方式
				if(selectType==null||selectType.length()==0){
					selectType=BusinessComponentConfig.getParameterDefinition(parameterID).getString("SELECTTYPE");
				}
				
				String valueFields = parameter.getString("OPERATOR");
				if(valueFields==null||valueFields.length()==0){
					valueFields=BusinessComponentConfig.getParameterDefinition(parameterID).getString("OPERATOR");
				}
				
				if(StringX.isEmpty(valueFields))continue;
				String[] valueFieldArray = valueFields.split(",");
				for(String valueField:valueFieldArray){
					businessObject.setAttributeValue((valueField+"_"+parameterID).toUpperCase(),parameter.getString(valueField));
					if(!StringX.isEmpty(selectType)&&(selectType.equals("01")||selectType.equals("02")||selectType.equals("03"))){
						businessObject.setAttributeValue((valueField+"NAME_"+parameterID).toUpperCase(),parameter.getString(valueField+"NAME"));
					}
				}
			}
			
			ruleList = new ArrayList<BusinessObject>();
			ruleList.add(businessObject);
		}
		else if(componentFormat.equals(BusinessComponentConfig.BUSINESS_COMPONENT_FORMAT_DECISION_TABLE)){
			ruleList = XMLHelper.getBusinessObjectList(xmlFile, xmlTags+"|| id='"+componentID+"'//DecisionTables//DecisionTable", "ID");
		}
		else if(componentFormat.equals(BusinessComponentConfig.BUSINESS_COMPONENT_FORMAT_DECISION_TREE)){
			//待实现
		}
		
		return 1;
	}

	@Override
	public int delete(BusinessObject businessObject,
			ALSBusinessProcess businessProcess) throws Exception {

		String componentID = this.asPage.getParameter("ComponentID");
		
		String xmlFile = this.asPage.getAttribute("XMLFile");
		String xmlTags = this.asPage.getAttribute("XMLTags");
		String keys = this.asPage.getAttribute("Keys");
		
		List<BusinessObject> components = XMLHelper.getBusinessObjectList(xmlFile, xmlTags+"|| id='"+componentID+"'", keys);
		BusinessObject component = components.get(0);
		String componentFormat = component.getString("Format");
		if(componentFormat.equals(BusinessComponentConfig.BUSINESS_COMPONENT_FORMAT_PARAMETER_SET) || componentFormat.equals(BusinessComponentConfig.BUSINESS_COMPONENT_FORMAT_COMPLEX)){
			
		}
		else if(componentFormat.equals(BusinessComponentConfig.BUSINESS_COMPONENT_FORMAT_DECISION_TABLE)){
			List<BusinessObject> ls = new ArrayList<BusinessObject>();
			ls.add(businessObject);
			XMLHelper.deleteBusinessObjectList(xmlFile, xmlTags+"|| id='"+componentID+"'//DecisionTables//DecisionTable", "ID",ls);
		}
		else if(componentFormat.equals(BusinessComponentConfig.BUSINESS_COMPONENT_FORMAT_DECISION_TREE)){
			//待实现
		}
		return 1;
	}

	@Override
	public int delete(List<BusinessObject> businessObjectList,
			ALSBusinessProcess businessProcess) throws Exception {
		for(BusinessObject businessObject:businessObjectList){
			this.delete(businessObject, businessProcess);
		}
		return 1;
	}

	@Override
	public int getTotalCount() throws Exception {
		return ruleList.size();
	}

	@Override
	public List<BusinessObject> newObject(BusinessObject inputParameter,
			ALSBusinessProcess businessProcess) throws Exception {
		List<BusinessObject> ls = new ArrayList<BusinessObject>();
		BusinessObject bo = BusinessObject.createBusinessObject();
		bo.setAttributeValue("ID", java.util.UUID.randomUUID().toString().replaceAll("-",""));
		ls.add(bo);
		return ls;
	}

}
