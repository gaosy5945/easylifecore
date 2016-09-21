package com.amarsoft.app.oci.ws.decision.prepare.util;

import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

import javax.xml.namespace.QName;

import org.apache.axiom.om.OMElement;

public class Unti {
	private String number = "";
	private String name = "";
	private String describe = "";
	private String source = "";
	private String type = "";
	private String value = "";
	private List<Utable> utables = new LinkedList<Utable>();
	private List<Result> results = new LinkedList<Result>();
	private List<Utable> tablewithclass = new LinkedList<Utable>();
	private String className = "";
	private String objectType ="";
	
	public Unti(OMElement element){
		number = element.getAttributeValue(new QName("number"));
		name = element.getAttributeValue(new QName("name"));
		describe = element.getAttributeValue(new QName("describe"));
		source = element.getAttributeValue(new QName("source"));
		type = element.getAttributeValue(new QName("type"));
		value = element.getAttributeValue(new QName("value"));
		className = element.getAttributeValue(new QName("classname"));
		objectType = element.getAttributeValue(new QName("objecttype"));
		
		if(source.startsWith("table")){
			Iterator it = element.getChildrenWithName(new QName("table"));
			while (it.hasNext()) {
				OMElement om = (OMElement) it.next();
				Utable utable = new Utable(om);
				utables.add(utable);
			}
		}else if(source.equals("DcIcrqResult")) {
			Iterator it = element.getChildrenWithName(new QName("result"));
			while (it.hasNext()) {
				OMElement om = (OMElement) it.next();
				Result result = new Result(om);
				results.add(result);
			}
		}else if(source.equals("tablewithclass")) {
			Iterator it = element.getChildrenWithName(new QName("table"));
			while (it.hasNext()) {
				OMElement om = (OMElement) it.next();
				Utable utable = new Utable(om);
				tablewithclass.add(utable);
			}
		}
	}
	public String getUntiNumber(){
		return this.number;
	}
	public String getUntiName(){
		return this.name;
	}
	public String getUntiDescribe(){
		return this.describe;
	}
	public String getUntiSource(){
		return this.source;
	}
	public String getUntiType(){
		return this.type;
	}
	public String getUntiValue(){
		return this.value;
	}
	public String getObjectType(){
		return this.objectType;
	}
	public List<Utable> getUtablesList(){
		return this.utables;
	}
	public List<Result> getResultList(){
		return this.results;
	}
	public List<Utable> getTablewithclassList(){
		return this.tablewithclass;
	}
	public String getClassName(){
		return this.className;
	}
}
