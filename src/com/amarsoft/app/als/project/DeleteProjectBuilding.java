package com.amarsoft.app.als.project;

import java.sql.SQLException;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.als.customer.model.CustomerConst;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

public class DeleteProjectBuilding {
	private JSONObject inputParameter;

	private BusinessObjectManager businessObjectManager;
	
	public void setInputParameter(JSONObject inputParameter) {
		this.inputParameter = inputParameter;
	}
	
	private JBOTransaction tx;

	public void setTx(JBOTransaction tx) {
		this.tx = tx;
	}
	
	private BusinessObjectManager getBusinessObjectManager() throws JBOException, SQLException{
		if(businessObjectManager==null)
			businessObjectManager = BusinessObjectManager.createBusinessObjectManager(tx);
		return businessObjectManager;
	}
	
	public void setBusinessObjectManager(BusinessObjectManager businessObjectManager) {
		this.businessObjectManager = businessObjectManager;
		this.tx = businessObjectManager.getTx();
	}
	
	
	public String deleteProjectBuilding(JBOTransaction tx) throws Exception{
		this.tx = tx;
		String BuildingSerialNo = (String)inputParameter.getValue("BuildingSerialNo");
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		BusinessObject bo = bomanager.keyLoadBusinessObject("jbo.app.BUILDING_INFO", BuildingSerialNo);
		bomanager.deleteBusinessObject(bo);

		bomanager.updateDB();
		return "SUCCEED";
	}
}
