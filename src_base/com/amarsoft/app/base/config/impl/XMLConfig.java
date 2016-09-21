package com.amarsoft.app.base.config.impl;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.config.AbstractConfig;
import com.amarsoft.are.io.FileTool;
import com.amarsoft.are.util.xml.Document;
import com.amarsoft.are.util.xml.Element;

public abstract class XMLConfig extends AbstractConfig{
	public final static String PROPERTY_ELEMENT_NAME="Property";
	
	protected Document getDocument(String fileName) throws Exception {
		File file = FileTool.findFile(fileName);
		InputStream in = new FileInputStream(file);
		
		Document document = new Document(in);
		in.close();
		return document;
	}
	
	
	public List<BusinessObject> convertToBusinessObjectList(List<Element> elements) throws Exception {
		List<BusinessObject> list= new ArrayList<BusinessObject>();
		for(Element e:elements){
			BusinessObject o = BusinessObject.createBusinessObject(e);
			list.add(o);
		}
		return list;
	}
}
