package com.amarsoft.app.oci.ws.decision.prepare.util;

import javax.xml.namespace.QName;

import org.apache.axiom.om.OMElement;

public class Result {

	private String outputkey = "";
	private String inputresult = "";
	private String classname = "";
	public Result (OMElement element){
		outputkey = element.getAttributeValue(new QName("outputkey"));
		inputresult = element.getAttributeValue(new QName("inputresult"));
		classname = element.getAttributeValue(new QName("classname"));
	}
	public String getOutputKey(){
		return this.outputkey;
	}
	public String getInputResult(){
		return this.inputresult;
	}
	public String getResultClassname(){
		return this.classname;
	}
}
