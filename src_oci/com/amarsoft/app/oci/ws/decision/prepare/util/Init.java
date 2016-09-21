package com.amarsoft.app.oci.ws.decision.prepare.util;

import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import javax.xml.namespace.QName;

import org.apache.axiom.om.OMElement;

public class Init {
	private Map<String, Object> propertys = new HashMap<String, Object>();
	private List<Table> tables = new LinkedList(); 
	public Init(OMElement element) {
		getPropertiesMap(element);
		getTables(element);
	}
	
	private void getPropertiesMap(OMElement element) {
		Iterator it = element.getChildrenWithName(new QName("Properties"));
		OMElement properties = (OMElement) it.next();
		it = properties.getChildrenWithName(new QName("Property"));
		while (it.hasNext()) {
			OMElement om = (OMElement) it.next();
			String key = om.getAttributeValue(new QName("name"));
			String value = om.getAttributeValue(new QName("value"));
			propertys.put(key, value);
		}
	}
	
	//将table中的标签都放入集合中
	private void getTables(OMElement element) {
		Iterator it = element.getChildrenWithName(new QName("inits"));
		OMElement inits = (OMElement) it.next();
		it = inits.getChildrenWithName(new QName("init"));
		OMElement init = (OMElement) it.next();
		it = init.getChildrenWithName(new QName("table"));
		while (it.hasNext()) {
			OMElement om = (OMElement) it.next();
			Table table = new Table(om);
			tables.add(table);
		}
	}
	public Map<String, Object> getPropertiesMap(){
		return this.propertys;
	}
	public List<Table> getTables(){
		return this.tables;
	}
	
	
}
