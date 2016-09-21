package com.amarsoft.app.als.awe.ow2.processor.impl;

import java.util.List;

import com.amarsoft.app.als.awe.ow2.processor.DataObjectQuerier;
import com.amarsoft.app.als.awe.ow2.processor.OWBusinessProcessor;
import com.amarsoft.app.base.businessobject.BusinessObject;

public abstract class AbstractQuerier implements DataObjectQuerier {
	protected OWBusinessProcessor businessProcess;

	protected BusinessObject convertToDataObject(BusinessObject businessObject) throws Exception{
		BusinessObject dataObject = BusinessObject.createBusinessObject(businessProcess.getDataObjectClass());
		BusinessObject owconfig=businessProcess.getOWManager().getObjectWindowConfig();
		List<BusinessObject> owattributes = owconfig.getBusinessObjects("attribute");
		for(BusinessObject attribute:owattributes){
			String attributeID=attribute.getString("name");
			Object value = null;
			String datasource=attribute.getString("query.value");
			if(datasource.isEmpty()){
				datasource=attributeID;
			}
			if(datasource.indexOf(".")<=0){
				value=businessObject.getObject(datasource);
			}
			else{
				String[] s=datasource.split(".");
				BusinessObject subbusinessObject = businessObject.getBusinessObject(s[0]);
				if(subbusinessObject==null) continue;
				value=subbusinessObject.getObject(s[1]);
			}
			dataObject.setAttributeValue(attributeID, value);
		}
		dataObject.changeState(businessObject.getState());
		return dataObject;
	}
}
