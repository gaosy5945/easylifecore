package com.amarsoft.app.als.businessobject.action;

import java.util.List;

import org.jdom.Element;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;



public interface BusinessObjectXMLImportor {
	public BusinessObject getBusinessObject(Element e)  throws Exception;
	
	public int importToDB(List<BusinessObject> businessObject,BusinessObjectManager bomanager)  throws Exception;
}
