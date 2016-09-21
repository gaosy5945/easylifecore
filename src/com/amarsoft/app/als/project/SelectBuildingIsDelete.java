package com.amarsoft.app.als.project;

import java.sql.SQLException;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

public class SelectBuildingIsDelete {
	private JSONObject inputParameter;
	private BusinessObjectManager businessObjectManager;
	
	public void setInputParameter(JSONObject inputParameter) {
		this.inputParameter = inputParameter;
	}
	
	private JBOTransaction tx;

	public void setTx(JBOTransaction tx) {
		this.tx = tx;
	}
	
	public void setBusinessObjectManager(BusinessObjectManager businessObjectManager) {
		this.businessObjectManager = businessObjectManager;
		this.tx = businessObjectManager.getTx();
	}
	
	private BusinessObjectManager getBusinessObjectManager() throws JBOException, SQLException{
		if(businessObjectManager==null)
			businessObjectManager = BusinessObjectManager.createBusinessObjectManager(tx);
		return businessObjectManager;
	}

	
	public String selectBuildingIsDelete(JBOTransaction tx) throws Exception{
		this.tx=tx;
		String serialNo = (String)inputParameter.getValue("BuildingSerialNo");

		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		List<BusinessObject> listPrj = bomanager.loadBusinessObjects("jbo.prj.PRJ_BUILDING", "BuildingSerialNo=:BuildingSerialNo", "BuildingSerialNo",serialNo);
		
		if(listPrj == null || listPrj.isEmpty()){
			return "PrjEmpty";
		}else{
			String projectSerialNo = listPrj.get(0).getString("PROJECTSERIALNO");
			if(projectSerialNo == null || projectSerialNo.length() == 0 || projectSerialNo == ""){
				return "ProjectSerialNoEmpty";
			}else{
				return "ProjectSerialNoFull";
			}

		}
	}

}
