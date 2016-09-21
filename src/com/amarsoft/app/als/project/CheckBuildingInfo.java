package com.amarsoft.app.als.project;

import java.sql.SQLException;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

public class CheckBuildingInfo {
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
	
	public String checkBuildingInfo(JBOTransaction tx) throws Exception{

		String buildingName = (String)inputParameter.getValue("buildingName");
		String areaCode = (String)inputParameter.getValue("areaCode");
		String locationC1 = (String)inputParameter.getValue("locationC1");
		
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		//检查是否有完全一致的楼盘信息
		List<BusinessObject> list = bomanager.loadBusinessObjects("jbo.app.BUILDING_INFO", " BUILDINGNAME=:BUILDINGNAME and AREACODE=:AREACODE and LOCATIONC1=:LOCATIONC1", "BUILDINGNAME",buildingName,"AREACODE",areaCode,"LOCATIONC1",locationC1);

		if(list==null || list.size() == 0){
			//模糊查询街道地址
			List<BusinessObject> listResult = bomanager.loadBusinessObjects("jbo.app.BUILDING_INFO", " areaCode=:areaCode and locationC1 like :locationC1", "areaCode",areaCode,"locationC1","%"+locationC1+"%");
			if(listResult == null || listResult.size() == 0){
				return "listResultNull@"+buildingName+"@"+areaCode+"@"+locationC1;
			}else{
				String sReturn = "true@";
				for(BusinessObject o:listResult){
					sReturn += o.getString("SERIALNO")+"@";
				}
				return sReturn+buildingName+"@"+areaCode+"@"+locationC1;
			}
		}
		return "false@"+"";
	}
}
