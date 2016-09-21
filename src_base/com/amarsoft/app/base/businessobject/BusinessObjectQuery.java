
package com.amarsoft.app.base.businessobject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.ql.DefaultParser;
import com.amarsoft.are.jbo.ql.Element;
import com.amarsoft.are.jbo.ql.JBOClass;
import com.amarsoft.are.lang.StringX;

public class BusinessObjectQuery{
	protected BizObjectQuery bizObjectQuery;
	protected Map<String,String[]> selectAttributeMap;
	protected Map<String,String> classMap;
	
	public BusinessObjectQuery(BizObjectQuery bizObjectQuery) {
		this.bizObjectQuery=bizObjectQuery;
	}
	
	public BizObjectQuery getBizObjectQuery(){
		return bizObjectQuery;
	}
	
	public void init(Map<String,String[]> selectAttributeMap,String whereString) throws JBOException{
		this.classMap=new HashMap<String,String>();
		this.selectAttributeMap=selectAttributeMap;
		
		DefaultParser parser = new DefaultParser();
		parser.parse(bizObjectQuery.getBizObjectClass(),whereString);
		Element[] elementArray = parser.getElementSequence();
		for(int i=0;i<elementArray.length;i++){
			Element element=elementArray[i];
			if(element instanceof JBOClass){
				classMap.put(((JBOClass) element).getAlias(), ((JBOClass) element).getName());
			}
		}
	}

	public List<BusinessObject> getResultList(boolean flag) throws JBOException {
		List<BizObject> bizObjectList = (List<BizObject>)bizObjectQuery.getResultList(flag);
		List<BusinessObject> businessObjectList = new ArrayList<BusinessObject>(bizObjectList.size());
		for(BizObject bizObject:bizObjectList){
			BusinessObject businessObject =convertToBusinessObject(bizObject);
			businessObjectList.add(businessObject);
		}
		return businessObjectList;
	}
	
	public BusinessObject convertToBusinessObject(BizObject bizObject)throws JBOException {
		BusinessObject businessObject = BusinessObject.createBusinessObject(bizObject.getBizObjectClass().getRoot().getAbsoluteName());
		for(String attributeName:selectAttributeMap.keySet()){
			Object value = bizObject.getAttribute(attributeName);
			if(value==null) continue;
			String[] queryAttribute=selectAttributeMap.get(attributeName);
			if(StringX.isEmpty(queryAttribute[0])||queryAttribute[0].equalsIgnoreCase("O")){//主对象和计算字段
				businessObject.setAttributeValue(attributeName, value);
			}
			else{//其他对象
				String subClassName = this.classMap.get(queryAttribute[0]);
				BusinessObject subObject = businessObject.getBusinessObject(queryAttribute[0]);
				if(subObject==null){
					subObject = BusinessObject.createBusinessObject(subClassName);
					//如果有值去到，则说明存在记录，则修改为同步状态
					subObject.changeState(bizObject.getState());
				}
				subObject.setAttributeValue(attributeName, value);
			}
		}
		businessObject.changeState(bizObject.getState());
		return businessObject;
	}
}
