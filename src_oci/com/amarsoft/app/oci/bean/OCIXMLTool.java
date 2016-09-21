package com.amarsoft.app.oci.bean;

import org.jdom.Attribute;
import org.jdom.DataConversionException;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.input.SAXBuilder;

import com.amarsoft.app.oci.Tools;

public class OCIXMLTool {
	public static String getValue(Element xData , String attributeName){
		return getValue(xData, attributeName , null);
	}
	
	public static String getValue(Element xData, String attributeName,String defaultValue) {
		Attribute attribute = xData.getAttribute(attributeName);
		if (attribute == null)
			return defaultValue;
		else
			return attribute.getValue();
	}

	public static String getValueWithException(Element xData,String attributeName, String exceptionMessage) throws Exception {
		Attribute attribute = xData.getAttribute(attributeName);
		if (attribute == null)
			throw new Exception(exceptionMessage);
		else
			return attribute.getValue();
	}

	public static int getIntVale(Element xData, String attributeName)throws DataConversionException {
		Attribute attribute = xData.getAttribute(attributeName);
		if (attribute == null)
			return 0;
		else
			return attribute.getIntValue();
	}

	public static boolean getBooleanValue(Element xData, String attributeName) {
		Attribute attribute = xData.getAttribute(attributeName);
		if (attribute != null
				&& "true".equalsIgnoreCase(attribute.getValue().trim()))
			return true;
		else
			return false;
	}
	
	public static Element getRootElement(String fileName , boolean needLowerParse) throws Exception{
		SAXBuilder b = new SAXBuilder();
		Document doc = b.build(fileName);
		Element xRoot = doc.getRootElement();
		if(needLowerParse) Tools.xmlTagToLower(xRoot);
		return xRoot;
	}
	
}
