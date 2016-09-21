package com.amarsoft.app.oci.bean;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.jdom.Element;

import com.amarsoft.are.ARE;

/**
 * @author ycliu
 *
 */
public class OCIConnection {
	private Map<String, String> properties = new HashMap<String, String>();// ʵʱ�ӿڶ����������Ϣ
	private Map<String, String> iMessages = new LinkedHashMap<String, String>(); // �ӿ���Ҫ������Message����
	private Map<String, String> oMessages = new LinkedHashMap<String, String>(); // �ӿ���Ҫ�����Message����
	private Map<String, String> namespaces = new HashMap<String, String>(); // XML�ж���������ռ�

	public static OCIConnection buildOCIConnection(Element xData) {
		OCIConnection connection =  new OCIConnection();
		connection.properties.put("id", xData.getAttributeValue("id"));
		connection.properties.put("name", xData.getAttributeValue("name"));
		connection.properties.put("type", xData.getAttributeValue("type"));
		if (xData.getChildren() != null) loadChildNode(xData ,connection);
		return connection;
	}
	
	/**
	 * ���� Connection �µ�������Ϣ
	 * @param xData
	 * @param connection
	 */
	private static void loadChildNode(Element xData, OCIConnection connection){
		@SuppressWarnings("unchecked")
		List<Element> list = xData.getChildren();
		for (Element temp : list) {
			if ("iMessages".equalsIgnoreCase(temp.getName())) 
				loadMessage(temp , connection.iMessages , "inmessage" , true);
			else if("oMessages".equalsIgnoreCase(temp.getName()))
				loadMessage(temp, connection.oMessages , "outmessage" , true);
			else if ("namespaces".equalsIgnoreCase(temp.getName())) 
				loadMessage(temp, connection.namespaces , "namespaces" , true);
			else
				loadMessage(temp, connection.properties, "property" , false);
		}
	}

	/**
	 * ����transaction�µ�Message
	 * @param xData
	 * @param map
	 * @param flag
	 * @param isChild
	 */
	@SuppressWarnings("unchecked")
	private static void loadMessage(Element xData, Map<String, String> map , String flag ,boolean isChild){
		List<Element> messages = new ArrayList<Element>();
		messages.add(xData);
		//�ж��Ǽ����ӽڵ㻹�Ǽ�������
		if(isChild) messages = xData.getChildren();
		if (messages == null) return;
		for (Element message : messages) {
			map.put(message.getAttributeValue("name"),message.getAttributeValue("value"));
			ARE.getLog().debug("[OCI] Connection[ " + flag + "[ "+ message.getAttributeValue("name")+ " = "+ message.getAttributeValue("value")+ " ] ]");
		} 
	}
	
		
	@Override
	public String toString() {
		return "OCIConnection [properties=" + properties + ", iMessages="
				+ iMessages + ", oMessages=" + oMessages + ", namespaces="
				+ namespaces + "]";
	}

	public Map<String, String> getProperties() {
		return properties;
	}

	public Map<String, String> getIMessages() {
		return iMessages;
	}

	public Map<String, String> getOMessages() {
		return oMessages;
	}

	public Map<String, String> getNamespaces() {
		return namespaces;
	}

	public String getProperty(String key) {
		return properties.get(key);
	}

	public void setProperty(String key, String value) {
		this.properties.put(key, value);
	}

	public String getIMessage(String key) {
		return this.iMessages.get(key);
	}

	public void setIMessage(String key, String value) {
		this.iMessages.put(key, value);
	}

	public String getOMessage(String key) {
		return this.oMessages.get(key);
	}

	public void setOMessage(String key, String value) {
		this.oMessages.put(key, value);
	}

	public String getNameSpace(String key) {
		return this.namespaces.get(key);
	}

	public void setNameSpace(String key, String value) {
		this.namespaces.put(key, value);
	}
}
