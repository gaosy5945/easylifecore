package com.amarsoft.app.oci.ws.decision.prepare.util;

import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

import javax.xml.namespace.QName;

import org.apache.axiom.om.OMElement;

public class Sql {
	private String key = "";
	private String sql = ""; 
	private List<Column> cloumn = new LinkedList<Column>();
	public Sql (OMElement element) {
		key = element.getAttributeValue(new QName("key"));
		sql = element.getAttributeValue(new QName("sql"));
		getCloumnList(element);
	}
	private void getCloumnList(OMElement element) {
		Iterator it = element.getChildrenWithName(new QName("cloumn"));
		while (it.hasNext()) {
			OMElement om = (OMElement) it.next();
			Column column = new Column(om);
			cloumn.add(column);
		}
	}
	public String getSqlKey(){
		return this.key;
	}
	public String getSqlSql(){
		return this.sql;
	}
	public List<Column> getColumnList(){
		return this.cloumn;
	}
}
