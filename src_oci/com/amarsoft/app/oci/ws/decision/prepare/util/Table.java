package com.amarsoft.app.oci.ws.decision.prepare.util;

import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

import javax.xml.namespace.QName;

import org.apache.axiom.om.OMElement;

public class Table {
	private String tablename = "aaaa";
	private String type = null;
	private List<Sql> sqls = new LinkedList<Sql>();
	public Table (OMElement element) {
		tablename = element.getAttributeValue(new QName("tablename"));
		type = element.getAttributeValue(new QName("type"));
		getSQL(element);
		
	}
	
	private void getSQL (OMElement element){
		Iterator it = element.getChildrenWithName(new QName("sqls"));
		OMElement sqlS = (OMElement) it.next();
		it = sqlS.getChildrenWithName(new QName("sql"));
		while (it.hasNext()) {
			OMElement om = (OMElement) it.next();
			Sql sql = new Sql(om);
			sqls.add(sql);
		}
	}
	public String getTablename(){
		return this.tablename;
	}
	public List<Sql> getSqlList(){
		return this.sqls;
	}
	public String getType(){
		return this.type;
	}
	
}
