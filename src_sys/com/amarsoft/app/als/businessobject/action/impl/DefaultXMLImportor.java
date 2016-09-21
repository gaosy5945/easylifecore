package com.amarsoft.app.als.businessobject.action.impl;

import java.util.ArrayList;
import java.util.List;

import org.jdom.Element;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.als.businessobject.action.BusinessObjectFactory;
import com.amarsoft.app.als.businessobject.action.BusinessObjectXMLImportor;
import com.amarsoft.are.lang.DataElement;
import com.amarsoft.are.lang.StringX;

public class DefaultXMLImportor implements BusinessObjectXMLImportor{
	@Override
	public BusinessObject getBusinessObject(Element e) throws Exception{
		String objectType = e.getAttributeValue("objectType");
		String objectNo = e.getAttributeValue("objectNo");
		String jboClassName = e.getAttributeValue("jboClassName");
		if(StringX.isEmpty(jboClassName)) jboClassName = objectType;
		
		BusinessObject businessObject = BusinessObject.createBusinessObject(jboClassName);
		
		@SuppressWarnings("unchecked")
		List<Element> attributeList = e.getChildren("Attribute");
		for(Element attribute:attributeList){
			String attributeID = attribute.getAttributeValue("id");
			businessObject.setAttributeValue(attributeID, getAttributeValue(attribute));
		}
		businessObject.setKey(objectNo);
		return businessObject;
	}

	private Object getAttributeValue(Element element) throws Exception{
		if("array".equals(element.getAttributeValue("type"))){
			@SuppressWarnings("unchecked")
			List<Element> arrayList = element.getChildren("BusinessObject");
			List<BusinessObject> list = new ArrayList<BusinessObject>();
			for(Element e:arrayList){
				BusinessObject o=BusinessObjectFactory.importXMLBusinessObject(e);
				list.add(o);
			}
			return list;
		}
		else{
			int dataType = Integer.parseInt(element.getAttributeValue("type"));
			if(dataType==DataElement.LONG) return Long.parseLong(element.getAttributeValue("value"));
			else if(dataType==DataElement.INT) return Integer.parseInt(element.getAttributeValue("value"));
			else if(dataType==DataElement.DOUBLE) return Double.parseDouble(element.getAttributeValue("value"));
			else if(dataType==DataElement.BOOLEAN) return Boolean.parseBoolean(element.getAttributeValue("value"));
			else return element.getAttributeValue("value");
		}
	}

	@Override
	public int importToDB(List<BusinessObject> businessObjectList,
			BusinessObjectManager bomanager) throws Exception {
		BusinessObjectFactory.save(businessObjectList, bomanager);
		return 1;
	}
}
