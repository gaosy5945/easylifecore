package com.amarsoft.app.als.guaranty.model;

import java.sql.SQLException;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

public class CollateralEva {
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

	public String checkEva(JBOTransaction tx) throws Exception{
		this.tx=tx;
		String assetSerialNo = (String)inputParameter.getValue("AssetSerialNo");
		return this.checkEva(assetSerialNo);
	}
	
	public String checkEva(String assetSerialNo) throws Exception{
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		List<BusinessObject> evaList = bomanager.loadBusinessObjects("jbo.app.ASSET_EVALUATE", "AssetSerialNo=:AssetSerialNo","AssetSerialNo",assetSerialNo);
		if(evaList == null || (evaList != null && evaList.size() == 0)) return "1";
		for(BusinessObject o:evaList){
			String confirmValue = o.getString("ConfirmValue");
			if(confirmValue == null || "".equals(confirmValue)){
				return "0";//存在在途的估值任务
			}
		}
		
		return "1";
	}
	
	public String getEva(JBOTransaction tx) throws Exception{
		this.tx=tx;
		String assetSerialNo = (String)inputParameter.getValue("AssetSerialNo");
		return this.getEva(assetSerialNo);
	}
	
	public String getEva(String assetSerialNo) throws Exception{
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		List<BusinessObject> evaList = bomanager.loadBusinessObjects("jbo.app.ASSET_EVALUATE", 
				"AssetSerialNo=:AssetSerialNo and ConfirmValue is null or (ConfirmValue is not null and ConfirmValue='' )",
				"AssetSerialNo",assetSerialNo);
		if(evaList == null || (evaList != null && evaList.size() != 1)) return "false";
		BusinessObject eva = evaList.get(0);
		String serialNo = eva.getKeyString();
		String cmisApplyNo = eva.getString("CMISApplyNo");
		String userID = eva.getString("EvaluateUserID");
		String orgID = eva.getString("EvaluateOrgID");
		
		List<BusinessObject> evaList1 = bomanager.loadBusinessObjects("jbo.app.ASSET_INFO", 
				"SerialNo=:SerialNo","SerialNo",assetSerialNo);
		if(evaList1 == null || (evaList1 != null && evaList1.size() != 1)) return "false";
		BusinessObject eva1 = evaList1.get(0);
		String clrSerialNo = eva1.getString("CLRSerialNo");
		
		return "true@"+serialNo+"@"+cmisApplyNo+"@"+userID+"@"+orgID+"@"+clrSerialNo;
	}
	
	public String getEvaInfo(JBOTransaction tx) throws Exception{
		this.tx=tx;
		String assetSerialNo = (String)inputParameter.getValue("AssetSerialNo");
		return this.getEvaInfo(assetSerialNo);
	}
	
	public String getEvaInfo(String assetSerialNo) throws Exception{
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		List<BusinessObject> evaList = bomanager.loadBusinessObjects("jbo.app.ASSET_EVALUATE", 
				"AssetSerialNo=:AssetSerialNo and ConfirmValue is null or (ConfirmValue is not null and ConfirmValue='' )",
				"AssetSerialNo",assetSerialNo);
		if(evaList == null || (evaList != null && evaList.size() != 1)) return "false";
		BusinessObject eva = evaList.get(0);
		String cmisApplyNo = eva.getString("CMISApplyNo");
		String evaluateScenario = eva.getString("EvaluateScenario");
		String evaluateModel = eva.getString("EvaluateModel");
		String evaluateMethod = eva.getString("EvaluateMethod");
		
		return "true@"+cmisApplyNo+"@"+evaluateScenario+"@"+evaluateModel+"@"+evaluateMethod;
	}
	
	public String getEva1(JBOTransaction tx) throws Exception{
		this.tx=tx;
		String assetSerialNo = (String)inputParameter.getValue("AssetSerialNo");
		return this.getEva1(assetSerialNo);
	}
	
	public String getEva1(String assetSerialNo) throws Exception{
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		List<BusinessObject> evaList = bomanager.loadBusinessObjects("jbo.app.ASSET_EVALUATE", 
				"AssetSerialNo=:AssetSerialNo and ConfirmValue is null or (ConfirmValue is not null and ConfirmValue='' )",
				"AssetSerialNo",assetSerialNo);
		if(evaList == null || (evaList != null && evaList.size() == 0)) return "true";
		
		return "false";
	}
	
	public String getEvaFlow(JBOTransaction tx) throws Exception{
		this.tx=tx;
		String serialNo = (String)inputParameter.getValue("SerialNo");
		return this.getEvaflow(serialNo);
	}
	
	public String getEvaflow(String serialNo) throws Exception{
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		
		List<BusinessObject> evaList = bomanager.loadBusinessObjects("jbo.app.ASSET_EVALUATE", 
				"SerialNo=(select max(ae.SerialNo) from jbo.app.ASSET_EVALUATE ae where ae.AssetSerialNo=:AssetSerialNo"
				+ " and ae.evadate = (select max(ae1.evadate) from jbo.app.ASSET_EVALUATE ae1 where ae1.AssetSerialNo=:AssetSerialNo))",
				"AssetSerialNo",serialNo);
		BusinessObject eva = evaList.get(0);
		String evaSerialNo = eva.getString("SerialNo");
		
		
		List<BusinessObject> evaList1 = bomanager.loadBusinessObjects("jbo.flow.FLOW_OBJECT", 
				"ObjectNo=:SerialNo and ObjectType = 'jbo.app.ASSET_EVALUATE'",
				"SerialNo",evaSerialNo);
		if(evaList1 == null || (evaList1 != null && evaList1.size() == 0)) return "false";
		BusinessObject eva1 = evaList1.get(0);
		String flowserialno = eva1.getString("FLOWSERIALNO");
		
		return flowserialno;
	}
	
	public String delEva(JBOTransaction tx) throws Exception{
		this.tx=tx;
		getBusinessObjectManager();
		String serialNo = (String)inputParameter.getValue("SerialNo");
		return this.delEva(serialNo);
	}
	
	public String delEva(String serialNo) throws Exception{
		String msg = "";
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		List<BusinessObject> evaList = bomanager.loadBusinessObjects("jbo.app.ASSET_EVALUATE", 
				"AssetSerialNo=:AssetSerialNo and ConfirmValue is null or (ConfirmValue is not null and ConfirmValue='' )",
				"AssetSerialNo",serialNo);
		BusinessObject eva = evaList.get(0);
		String evaSerialNo = eva.getString("SerialNo");
		
		BusinessObject ae1 = this.businessObjectManager.keyLoadBusinessObject("jbo.app.ASSET_EVALUATE", evaSerialNo);
			this.businessObjectManager.deleteBusinessObject(ae1);
			this.businessObjectManager.updateDB();
			
			msg = "任务已取消！";
		
		return msg;
	}
	
	public String viewEva(JBOTransaction tx) throws Exception{
		this.tx=tx;
		String assetSerialNo = (String)inputParameter.getValue("AssetSerialNo");
		return this.viewEva(assetSerialNo);
	}
	
	public String viewEva(String assetSerialNo) throws Exception{
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		List<BusinessObject> evaList = bomanager.loadBusinessObjects("jbo.app.ASSET_EVALUATE", 
				"SerialNo=(select max(ae.SerialNo) from jbo.app.ASSET_EVALUATE ae where ae.AssetSerialNo=:AssetSerialNo"
				+ " and ae.evadate = (select max(ae1.evadate) from jbo.app.ASSET_EVALUATE ae1 where ae1.AssetSerialNo=:AssetSerialNo))",
				"AssetSerialNo",assetSerialNo);
		if(evaList == null || (evaList != null && evaList.size() != 1)) return "false";
		BusinessObject eva = evaList.get(0);
		String serialNo = eva.getKeyString();
		String cmisApplyNo = eva.getString("CMISApplyNo");
		String userID = eva.getString("EvaluateUserID");
		String orgID = eva.getString("EvaluateOrgID");
		String evaluateMethod = eva.getString("EVALUATEMETHOD");
		
		List<BusinessObject> evaList1 = bomanager.loadBusinessObjects("jbo.app.ASSET_INFO", 
				"SerialNo=:SerialNo","SerialNo",assetSerialNo);
		if(evaList1 == null || (evaList1 != null && evaList1.size() != 1)) return "false";
		BusinessObject eva1 = evaList1.get(0);
		String clrSerialNo = eva1.getString("CLRSerialNo");
		
		return "true@"+serialNo+"@"+cmisApplyNo+"@"+userID+"@"+orgID+"@"+clrSerialNo+"@"+evaluateMethod;
	}
	
	public String viewEvaMethod(JBOTransaction tx) throws Exception{
		this.tx=tx;
		String serialNo = (String)inputParameter.getValue("SerialNo");
		return this.viewEvaMethod(serialNo);
	}
	
	public String viewEvaMethod(String serialNo) throws Exception{
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		List<BusinessObject> evaList = bomanager.loadBusinessObjects("jbo.app.ASSET_EVALUATE", 
				"SerialNo=:SerialNo",
				"SerialNo",serialNo);
		if(evaList == null || (evaList != null && evaList.size() != 1)) return "false";
		BusinessObject eva = evaList.get(0);
		String evaluateMethod = eva.getString("EVALUATEMETHOD");
		
		return evaluateMethod;
	}
}