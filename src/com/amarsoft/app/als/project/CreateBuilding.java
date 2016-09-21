package com.amarsoft.app.als.project;
/**
 * @柳显涛
 * 楼盘新增类,向building_info插入数据并生成流水号之后，再向PRJ_BUILDING,BUILDING_DEVELOPER,BUILDING_BLOCK中插入楼盘信息
 */
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

public class CreateBuilding {
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
	
	public String createBuilding(JBOTransaction tx) throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.app.BUILDING_INFO");
		tx.join(bm);
		
		String buildingName = (String)inputParameter.getValue("buildingName");
		String areaCode = (String)inputParameter.getValue("areaCode");
		String locationC1 = (String)inputParameter.getValue("locationC1");
		String inputOrgID = (String)inputParameter.getValue("inputOrgID");
		String inputUserID = (String)inputParameter.getValue("inputUserID");
		
		BizObject bo = bm.newObject();
		bo.setAttributeValue("BUILDINGNAME", buildingName);
		bo.setAttributeValue("AREACODE", areaCode);
		bo.setAttributeValue("LOCATIONC1", locationC1);
		bo.setAttributeValue("INPUTUSERID", inputUserID);
		bo.setAttributeValue("INPUTORGID", inputOrgID);
		bo.setAttributeValue("INPUTDATE", DateHelper.getBusinessDate());
		bm.saveObject(bo);
		String serialNo = bo.getAttribute("SerialNo").toString();
		//createPrjBuilding(serialNo,tx);
		//createBuildingDeveloper(serialNo,tx);
		
		return "true@"+serialNo;
	}
	public void createPrjBuilding(String SerialNo,JBOTransaction tx) throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.prj.PRJ_BUILDING");
		
		BizObject bo = bm.newObject();
		bo.setAttributeValue("BUILDINGSERIALNO", SerialNo);
		bm.saveObject(bo);
	}
	public void createBuildingDeveloper(String SerialNo,JBOTransaction tx) throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.app.BUILDING_DEVELOPER");
		
		BizObject bo = bm.newObject();
		bo.setAttributeValue("BUILDINGSERIALNO", SerialNo);
		bm.saveObject(bo);
	}
}
