package com.amarsoft.app.oci.ws.decision.prepare.util;

import javax.xml.namespace.QName;

import org.apache.axiom.om.OMElement;

public class Column {
	private String key = "";
	private String returnkey = "";
	public Column (OMElement element) {
		key = element.getAttributeValue(new QName("key"));
		returnkey = element.getAttributeValue(new QName("returnkey"));
	}
	public String getColumnKey(){
		return this.key;
	}
	public String getColumnReturnKey(){
		return this.returnkey;
	}
}
