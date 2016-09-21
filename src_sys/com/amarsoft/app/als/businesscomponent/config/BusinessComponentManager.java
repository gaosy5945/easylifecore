package com.amarsoft.app.als.businesscomponent.config;


import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.als.awe.script.WebBusinessProcessor;
import com.amarsoft.app.base.util.XMLHelper;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.app.base.businessobject.BusinessObject;

public class BusinessComponentManager extends WebBusinessProcessor{
	
	/**
	 * 进行组件复制
	 * @param tx
	 * @return
	 * @throws Exception
	 */
	public String copyComponent(JBOTransaction tx) throws Exception{
		this.setTx(tx);
		
		String xmlFile = (String)this.inputParameter.getValue("XMLFile");
		String xmlTags = (String)this.inputParameter.getValue("XMLTags");
		String componentID = (String)this.inputParameter.getValue("ComponentID");
		String newComponentID = (String)this.inputParameter.getValue("NewComponentID");
		String newComponentName = (String)this.inputParameter.getValue("NewComponentName");
		
		xmlTags += "|| id='"+componentID+"' ";
		
		List<BusinessObject> ls = new ArrayList<BusinessObject>();
		BusinessObject bo = BusinessObject.createBusinessObject();
		bo.setAttributeValue("ID", newComponentID);
		bo.setAttributeValue("Name", newComponentName);
		ls.add(bo);
		
		return XMLHelper.copyTags(xmlFile, xmlTags, ls);
	}

	
}
