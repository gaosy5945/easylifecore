package com.amarsoft.app.als.businessobject.web;

import java.sql.SQLException;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.als.businessobject.action.BusinessObjectFactory;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.Element;
import com.amarsoft.are.util.json.JSONElement;
import com.amarsoft.are.util.json.JSONEncoder;
import com.amarsoft.are.util.json.JSONObject;

/**
 * 产品规格页面发布新版本按钮处理逻辑
 * @author Administrator
 *
 */
public class BusinessObjectWebMethod{
	private JBOTransaction tx;
	
	private JSONObject inputParameter;
	
	private BusinessObjectManager businessObjectManager;
	
	private BusinessObjectManager getBusinessObjectManager() throws JBOException, SQLException{
		if(businessObjectManager==null)
			businessObjectManager = BusinessObjectManager.createBusinessObjectManager(tx);
		return businessObjectManager;
	}
	
	public void setInputParameter(JSONObject inputParameter) {
		this.inputParameter = inputParameter;
	}
	
	public void setTx(JBOTransaction tx) {
		this.tx = tx;
	}
	
	public String simpleCopyBusinessObject(JBOTransaction tx) throws Exception{
		String objectType = (String)this.inputParameter.getValue("ObjectType");
		String objectNo = (String)this.inputParameter.getValue("ObjectNo");
		getBusinessObjectManager().updateBusinessObjects(BusinessObjectFactory.copy(objectType, objectNo, getBusinessObjectManager()));
		this.getBusinessObjectManager().updateDB();
		return "true";
	}

	public String getAttributes(JBOTransaction tx) throws Exception{
		String objectType = (String)this.inputParameter.getValue("ObjectType");
		String objectNo = (String)this.inputParameter.getValue("ObjectNo");
		String attributes = (String)this.inputParameter.getValue("Attributes");
		BusinessObject businessObject = this.getBusinessObjectManager().keyLoadBusinessObject(objectType, objectNo);
		String[] attributeArray = attributes.split("@");
		JSONObject result = JSONObject.createObject();
		for(String attributeID:attributeArray){
			result.appendElement(JSONElement.valueOf(attributeID,businessObject.getObject(attributeID)));
		}
		return JSONEncoder.encode(result);
	}
	
	public String updateAttributes(JBOTransaction tx) throws Exception{
		this.tx=tx;
		String objectType = (String)this.inputParameter.getValue("ObjectType");
		String objectNo = (String)this.inputParameter.getValue("ObjectNo");
		JSONObject attributes = (JSONObject)this.inputParameter.getValue("Attributes");
		
		BusinessObject businessObject = this.getBusinessObjectManager().keyLoadBusinessObject(objectType, objectNo);
		
		for(int i=0;i<attributes.size();i++){
			Element e = attributes.get(i);
			businessObject.setAttributeValue(e.getName(),e.getName());
		}
		this.getBusinessObjectManager().updateBusinessObject(businessObject);
		this.getBusinessObjectManager().updateDB();
		return "1";
	}
}
