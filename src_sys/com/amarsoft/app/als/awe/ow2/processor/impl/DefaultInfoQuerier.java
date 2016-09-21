package com.amarsoft.app.als.awe.ow2.processor.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.amarsoft.app.als.awe.ow2.processor.OWBusinessProcessor;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectQuery;
import com.amarsoft.app.base.util.JBOHelper;
import com.amarsoft.app.base.util.StringHelper;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.lang.StringX;

public class DefaultInfoQuerier extends AbstractQuerier {
	private BusinessObjectQuery mainquery;
	
	public int query(OWBusinessProcessor businessProcess) throws Exception {
		this.businessProcess=businessProcess;
		BusinessObject owconfig=businessProcess.getOWManager().getObjectWindowConfig();
		BusinessObject queryActionConfig = owconfig.getBusinessObjectByKey("action","query");
		
		List<BusinessObject> executeList = queryActionConfig.getBusinessObjects("execute");
		for(BusinessObject execute:executeList){
			mainquery=getBusinessObjectQuery(execute);
		}
		return 1;
	}
	
	private BusinessObjectQuery getBusinessObjectQuery(BusinessObject queryUnitConfig) throws Exception{
		BusinessObject owinputParameters=businessProcess.getInputParameters();
		String jboClassName=queryUnitConfig.getString("jboClassName");
		if(StringX.isEmpty(jboClassName)){
			throw new JBOException("模板{"+businessProcess.getASDataObject().getDONO()+"}查询操作的BizObject未指定classname，请指定对应的JBO类名！");
		}
		
		String whereString=queryUnitConfig.getString("method").trim();
		String parameterString=queryUnitConfig.getString("parameter");
		Map<String,String> selectAttributes=getSelectAttributeList();//生成查询字段
		//使用ow参数
		parameterString=StringHelper.replaceString(parameterString,"Input", owinputParameters);
		return JBOHelper.getQuery(jboClassName, selectAttributes,whereString, parameterString, businessProcess.getBusinessObjectManager().getTx());
	}
	
	public Map<String,String> getSelectAttributeList() throws Exception{
		BusinessObject owconfig=businessProcess.getOWManager().getObjectWindowConfig();
		List<BusinessObject> attributeList = owconfig.getBusinessObjects("attribute");
		Map<String,String> map = new HashMap<String,String>();
		for(BusinessObject attribute:attributeList){
			String type = attribute.getString("type");
			if("SUBOW".equals(type)||"SUBPAGE".equals(type)) continue;
			String functionValueString = attribute.getString("query.java.value");
			if(!StringX.isEmpty(functionValueString)) continue;
			String sqlValueString = attribute.getString("query.sql.value");
			if(StringX.isEmpty(sqlValueString)) sqlValueString=attribute.getString("name");
			map.put(attribute.getString("name"), sqlValueString);
		}
		return map;
	}

	public BusinessObject[] getData(int fromIndex,int toIndex) throws Exception{
		mainquery.getBizObjectQuery().setFirstResult(fromIndex);
		mainquery.getBizObjectQuery().setMaxResults(toIndex-fromIndex);
	    List<BusinessObject> businessObjectList = mainquery.getResultList(true);
		
		BusinessObject[] dataObjectArray = new BusinessObject[businessObjectList.size()];
		for(int i=0;i<businessObjectList.size();i++){
			BusinessObject businessObject = businessObjectList.get(i);
			dataObjectArray[i]=this.convertToDataObject(businessObject);
			dataObjectArray[i].setAttributeValue("ORIGNAL_BUSINESS_OBJECT", businessObject);
		}
		return dataObjectArray;
	}
	
	@Override
	public int getTotalCount() throws Exception {
		return mainquery.getBizObjectQuery().getTotalCount();
	}
}
