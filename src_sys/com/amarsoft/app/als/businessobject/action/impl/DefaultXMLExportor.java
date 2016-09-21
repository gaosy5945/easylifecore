package com.amarsoft.app.als.businessobject.action.impl;

import java.util.List;
import java.util.Map;

import org.jdom.Element;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.als.businessobject.action.BusinessObjectFactory;
import com.amarsoft.app.als.businessobject.action.BusinessObjectXMLExportor;
import com.amarsoft.are.lang.StringX;


public class DefaultXMLExportor implements BusinessObjectXMLExportor{
	@Override
	public Element exportElement(BusinessObject o) throws Exception{
		Element e =new Element("BusinessObject");
		e.setAttribute("objectType", o.getBizClassName());
		e.setAttribute("objectNo", o.getKeyString());
		String jboClassName = o.getBizClassName();
		if(!StringX.isEmpty(jboClassName)){
			e.setAttribute("jboClassName", jboClassName);
		}
		Element attributes =new Element("Attributes");
		Map<String, Object> valueMap = o.convertToMap();
		for(String attributeID:valueMap.keySet()){
			Element attribute =new Element("Attribute");
			String value = o.getString(attributeID);
			if(value!=null) {
				attribute.setAttribute("id", attributeID);
				attribute.setAttribute("value", value);
				attribute.setAttribute("type", Byte.toString(o.getAttribute(attributeID).getType()));
			}
			else continue;
			attributes.addContent(attribute);
		}

		String[] keys = o.getAttributeIDArray();
		for(String key:keys){
			Element attribute =new Element("Attribute");
			List<BusinessObject> listValue= o.getBusinessObjects(key);
			if(listValue!=null){
				attribute.setAttribute("id", key);
				for(BusinessObject arrayValue : listValue){
					attribute.addContent(BusinessObjectFactory.exportXMLBusinessObject(arrayValue));
				}
				attributes.addContent(attribute);
				attribute.setAttribute("type", "array");
			}
		}
		e.addContent(attributes);
		return e;
	}
}
