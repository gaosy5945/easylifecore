package com.amarsoft.app.oci.ws.decision.prepare;

import java.util.HashMap;
import java.util.Map;

/**
 * �������ֿ� ������Ϣ����
 * @author t-liuyc
 * @param <V>
 *
 */
public class DcIcrqResult {
	private Map<String , Object> attributes = new HashMap<String, Object>();
	
	public void setAttribute(String key , Object value){
		attributes.put(key, value);
	}
	
	public String getStringAttribute(String key){
		Object o =  attributes.get(key);
		if(o == null) return "";
		return o.toString();
	}
	
	public boolean getBoolAttribute(String key){
		return false;
	}
	
	public int getIntAttribute(String key){
		return Integer.parseInt(this.getStringAttribute(key));
	}
	
	public Map<String , Object> getAttributes(){
		return attributes;
	}
}


