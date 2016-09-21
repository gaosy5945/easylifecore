package com.amarsoft.app.oci.ws.decision.prepare.util;

import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

import javax.xml.namespace.QName;

import org.apache.axiom.om.OMElement;

public class Execute {
	private List<Unti> Untis = new LinkedList(); 
	public Execute(OMElement element) {
		getUntiList(element);
	}
	private void getUntiList(OMElement element) {
		Iterator it = element.getChildrenWithName(new QName("execute"));
		OMElement execute = (OMElement) it.next();
		it = execute.getChildrenWithName(new QName("unti"));
		while (it.hasNext()) {
			OMElement om = (OMElement) it.next();
			Unti unti = new Unti(om);
			Untis.add(unti);
		}
	}
	public List<Unti> getUntiList(){
		return this.Untis;
	}
}
