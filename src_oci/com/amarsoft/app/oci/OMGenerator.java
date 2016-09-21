package com.amarsoft.app.oci;

import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;

import org.apache.axiom.om.OMAbstractFactory;
import org.apache.axiom.om.OMAttribute;
import org.apache.axiom.om.OMElement;
import org.apache.axiom.om.OMFactory;
import org.apache.axiom.om.OMNamespace;
import org.apache.axiom.om.OMXMLBuilderFactory;
import org.apache.axiom.om.OMXMLParserWrapper;

public class OMGenerator {
	private static OMFactory factory = OMAbstractFactory.getOMFactory();
	private static OMNamespace nullSpace = factory.createOMNamespace("", "");
	
	public static OMElement parseStringtoOM(String content ,String charCode) throws UnsupportedEncodingException{
		if(content == null) content = "";
		InputStream is = new ByteArrayInputStream(content.getBytes(charCode));
		OMXMLParserWrapper build= OMXMLBuilderFactory.createOMBuilder(is);
		return build.getDocumentElement();
	}
	
	public static OMElement parseIOtoOM(InputStream is ) throws UnsupportedEncodingException{
		OMXMLParserWrapper build= OMXMLBuilderFactory.createOMBuilder(is);
		return build.getDocumentElement();
	}
	
	public static OMElement createOMElement(String name){
		return factory.createOMElement(name, nullSpace);
	}
	
	public static OMElement createOMElement(String name , OMNamespace nameSpace){
		return factory.createOMElement(name, nameSpace);
	}
	
	public static OMNamespace createNameSpace(String urn , String prefix){
		if(urn == null || prefix == null||"".equals(urn)||"".equals(prefix))
			return nullSpace;
		return factory.createOMNamespace(urn, prefix);
	}
	
	public static OMNamespace createNameSpace(){
		return nullSpace;
	}
	
	public static OMAttribute createOMAttribute(String name , OMNamespace namepcace,String value){
		if(namepcace == null) namepcace = nullSpace;
		return factory.createOMAttribute(name, namepcace, value);
	}
}
