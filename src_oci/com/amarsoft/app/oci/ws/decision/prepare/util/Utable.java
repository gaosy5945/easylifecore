package com.amarsoft.app.oci.ws.decision.prepare.util;

import javax.xml.namespace.QName;

import org.apache.axiom.om.OMElement;

public class Utable {
	private String key = "";
	private String value = "";
	private String classname = "";
	private String defaultvalue = "";
	private String productType = "";
	
	public Utable (OMElement element){
		key = element.getAttributeValue(new QName("key"));
		value = element.getAttributeValue(new QName("value"));
		classname = element.getAttributeValue(new QName("classname"));
		defaultvalue = element.getAttributeValue(new QName("defaultvalue"));
		productType = element.getAttributeValue(new QName("productType"));
	}
	public String getUtableKey(){
		return this.key;
	}
	public String getUtableValue(){
		return this.value;
	}
	public String getUtableClassname(){
		return this.classname;
	}
	public String getUtableDefaultvalue(){
		return this.defaultvalue;
	}
	public String getUtableProductType(){
		return this.productType;
	}
}
