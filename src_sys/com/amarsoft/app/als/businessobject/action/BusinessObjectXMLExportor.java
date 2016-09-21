package com.amarsoft.app.als.businessobject.action;

import org.jdom.Element;

import com.amarsoft.app.base.businessobject.BusinessObject;

public interface BusinessObjectXMLExportor{
	public Element exportElement(BusinessObject o) throws Exception;
}
