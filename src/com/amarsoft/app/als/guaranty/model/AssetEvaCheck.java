package com.amarsoft.app.als.guaranty.model;

import java.sql.SQLException;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.json.JSONObject;
import com.amarsoft.dict.als.manage.NameManager;

public class AssetEvaCheck {
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

	//押品接口，估值信息完整性检查
	public String checkEvaInfo(JBOTransaction tx) throws Exception{
		this.tx=tx;
		getBusinessObjectManager();
		String cmisApplyNo = (String)inputParameter.getValue("CMISApplyNo");
		String EstDestType = (String)inputParameter.getValue("EstDestType");
		String EstMthType = (String)inputParameter.getValue("EstMthType");
		String PrdNo = (String)inputParameter.getValue("PrdNo");
		String InrExtEstType = (String)inputParameter.getValue("InrExtEstType");

		return this.checkEvaInfo(cmisApplyNo,EstDestType,EstMthType,PrdNo,InrExtEstType);
	}
	
	public String checkEvaInfo(String cmisApplyNo,String EstDestType,String EstMthType,String PrdNo,String InrExtEstType) throws Exception{
		//this.bomanager.getTx().getConnection(this.bomanager.getQueryBizObjectManager(assetEvaluate.getObjectType()))
		String AvlSbmtFlg = "";
		String returnCode = "";
		String returnMsg = "";
		try{
			/*OCITransaction oci = ClrInstance.EstFlowIntegQry(cmisApplyNo,PrdNo,EstDestType,InrExtEstType,EstMthType,this.businessObjectManager.getTx().getConnection(this.businessObjectManager.getBizObjectManager("jbo.app.ASSET_EVALUATE")));
			returnCode = oci.getOMessage("SysBody").getFieldByTag("RspSvcHeader").getObjectMessage().getFieldValue("ReturnCode");
			returnMsg = oci.getOMessage("SysBody").getFieldByTag("RspSvcHeader").getObjectMessage().getFieldValue("ReturnMsg");
			if(OCIConfig.RETURN_CODE_NORMAL.equals(returnCode)) {
				AvlSbmtFlg = oci.getOMessage("SysBody").getFieldByTag("SvcBody").getObjectMessage().getFieldValue("AvlSbmtFlg");
			}*/
		}catch(Exception ex)
		{
			ex.printStackTrace();
			throw ex;
		}
        if(AvlSbmtFlg == "0") throw new Exception("估值过程不完整，不可以提交下一阶段！");
        //if(!"021200000002".equals(returnCode) && !OCIConfig.RETURN_CODE_NORMAL.equals(returnCode)) throw new Exception(returnMsg);

        return AvlSbmtFlg+"@"+returnCode;
	}
	
	public String getEvaValue(JBOTransaction tx) throws Exception{
		this.tx=tx;
		getBusinessObjectManager();
		String cmisApplyNo = (String)inputParameter.getValue("CMISApplyNo");
		String FlowStatus = (String)inputParameter.getValue("FlowStatus");
		String InrExtEstType = (String)inputParameter.getValue("InrExtEstType");

		return this.getEvaValue(cmisApplyNo,FlowStatus,InrExtEstType);
	}
	
	public String getEvaValue(String cmisApplyNo,String FlowStatus,String InrExtEstType) throws Exception{
		//this.bomanager.getTx().getConnection(this.bomanager.getQueryBizObjectManager(assetEvaluate.getObjectType()))
		String IttEstVal = "";
		String ChkVal = "";
		try{
			/*
			OCITransaction oci = ClrInstance.BtchCltlEstRsltQry(cmisApplyNo,FlowStatus,this.businessObjectManager.getTx().getConnection(this.businessObjectManager.getBizObjectManager("jbo.app.ASSET_EVALUATE")));
			List<Message> imessage = oci.getOMessage("SysBody").getFieldByTag("SvcBody").getObjectMessage().getFieldByTag("BtchCltlValInfo").getFieldArrayValue();
			ChkVal = imessage.get(0).getFieldValue("ChkVal");*/
		}catch(Exception ex)
		{
			ex.printStackTrace();
			//暂时不抛出异常
			throw ex;
		}
       
        return ChkVal;
	}
	
	public String updateAssetEva(JBOTransaction tx) throws Exception{
		this.tx=tx;
		getBusinessObjectManager();
		String assetEvaNo = (String)inputParameter.getValue("AssetEvaNo");
		String assetSerialNo = (String)inputParameter.getValue("AssetSerialNo");
		String confirmValue = (String)inputParameter.getValue("ConfirmValue");
		String userId = (String)inputParameter.getValue("UserId");
		String orgId = (String)inputParameter.getValue("OrgId");
		if(StringX.isEmpty(confirmValue))
			throw new Exception("未取到估值结果");
		return this.updateAssetEva(assetEvaNo,assetSerialNo,confirmValue,userId,orgId);
	}
	
	public String updateAssetEva(String assetEvaNo,String assetSerialNo,String confirmValue,String userId,String orgId) throws Exception{
		String userName = NameManager.getUserName(userId);
		String orgName = NameManager.getOrgName(orgId);
		BusinessObject ae = this.businessObjectManager.keyLoadBusinessObject("jbo.app.ASSET_EVALUATE", assetEvaNo);
		ae.setAttributeValue("ConfirmValue", Double.valueOf(confirmValue));
		ae.setAttributeValue("ApproveUserId", userId);
		ae.setAttributeValue("ApproveUserName", userName);
		ae.setAttributeValue("ApproveOrgId", orgId);
		ae.setAttributeValue("ApproveOrgName", orgName);
		this.businessObjectManager.updateBusinessObject(ae);
		this.businessObjectManager.updateDB();
		
		updateAssetInfo(assetSerialNo,confirmValue);
		return "true";
	}
	
	
	public String updateAssetInfo(JBOTransaction tx) throws Exception{
		this.tx=tx;
		getBusinessObjectManager();
		String assetSerialNo = (String)inputParameter.getValue("AssetSerialNo");
		String confirmValue = (String)inputParameter.getValue("ConfirmValue");
		if(StringX.isEmpty(confirmValue))
			throw new Exception("未取到估值结果");
		return this.updateAssetInfo(assetSerialNo,confirmValue);
	}
	
	public String updateAssetInfo(String assetSerialNo,String confirmValue) throws Exception{
		BusinessObject ae1 = this.businessObjectManager.keyLoadBusinessObject("jbo.app.ASSET_INFO", assetSerialNo);
		ae1.setAttributeValue("ConfirmValue", Double.valueOf(confirmValue));
		this.businessObjectManager.updateBusinessObject(ae1);
		this.businessObjectManager.updateDB();
		
		List<BusinessObject> evaList1 = this.businessObjectManager.loadBusinessObjects("jbo.guaranty.GUARANTY_RELATIVE", 
				"AssetSerialNo=:AssetSerialNo",
				"AssetSerialNo",assetSerialNo);
		if(evaList1 == null || (evaList1 != null && evaList1.size() == 0)) return "false";
		for (int i = 0;i<evaList1.size();i++) {
			BusinessObject eva1 = evaList1.get(i);
			double guarantyAmount = eva1.getDouble("GUARANTYAMOUNT");
			
			eva1.setAttributeValue("GUARANTYPERCENT", (guarantyAmount/Double.valueOf(confirmValue))*100.0);
			this.businessObjectManager.updateBusinessObject(eva1);
			this.businessObjectManager.updateDB();
		}
		
		return "true";
	}
	
	public String updateInfoEva(JBOTransaction tx) throws Exception{
		this.tx=tx;
		String serialNo = (String)inputParameter.getValue("SerialNo");
		return this.updateInfoEva(serialNo);
	}
	
	public String updateInfoEva(String serialNo) throws Exception{
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		
		List<BusinessObject> evaList = bomanager.loadBusinessObjects("jbo.app.ASSET_EVALUATE", 
				"SerialNo=(select max(ae.SerialNo) from jbo.app.ASSET_EVALUATE ae where ae.AssetSerialNo=:AssetSerialNo"
				+ " and ae.evadate = (select max(ae1.evadate) from jbo.app.ASSET_EVALUATE ae1 where ae1.AssetSerialNo=:AssetSerialNo))",
				"AssetSerialNo",serialNo);
		if(evaList == null || (evaList != null && evaList.size() == 0)) return "false";
		BusinessObject eva = evaList.get(0);
		String confirmValue = eva.getString("ConfirmValue");
		
		if(StringX.isEmpty(confirmValue)) return "";
		
		updateAssetInfo(serialNo,confirmValue);
		
		return "true";
	}
}