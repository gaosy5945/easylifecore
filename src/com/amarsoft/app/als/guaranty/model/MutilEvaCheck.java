package com.amarsoft.app.als.guaranty.model;

import java.sql.SQLException;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.json.JSONObject;

public class MutilEvaCheck {
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
		String AvlSbmtFlg = "";
		String returnCode = "";
		String returnMsg = "";
		try{
			/*OCITransaction oci = ClrInstance.EstFlowIntegQry1(cmisApplyNo,PrdNo,EstDestType,InrExtEstType,EstMthType,this.businessObjectManager.getTx().getConnection(this.businessObjectManager.getBizObjectManager("jbo.app.ASSET_EVALUATE")));
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

		return this.getEvaValue(cmisApplyNo,FlowStatus);
	}
	
	public String getEvaValue(String cmisApplyNo,String FlowStatus) throws Exception{
		//this.bomanager.getTx().getConnection(this.bomanager.getQueryBizObjectManager(assetEvaluate.getObjectType()))
		try{
			/*
			OCITransaction oci = ClrInstance.BtchCltlEstRsltQry(cmisApplyNo,FlowStatus,this.businessObjectManager.getTx().getConnection(this.businessObjectManager.getBizObjectManager("jbo.app.ASSET_EVALUATE")));
			List<Message> imessage = oci.getOMessage("SysBody").getFieldByTag("SvcBody").getObjectMessage().getFieldByTag("BtchCltlValInfo").getFieldArrayValue();
			int i = 0;
			if(imessage != null)
			{
				for(i = 0; i < imessage.size() ; i ++){
					Message message = imessage.get(i);
					BizObjectManager arm = JBOFactory.getBizObjectManager("jbo.app.ASSET_EVALUATE");
					tx.join(arm);
					BizObject crbo = arm.newObject();
					crbo.setAttributeValue("ASSETSERIALNO", message.getFieldValue("MrtgPlgCltlNo"));
					crbo.setAttributeValue("EVALUATECURRENCY", message.getFieldValue("Ccy"));
					crbo.setAttributeValue("EVALUATEVALUE", Double.valueOf(message.getFieldValue("IttEstVal")));
					crbo.setAttributeValue("CONFIRMVALUE", Double.valueOf(message.getFieldValue("ChkVal")));
					crbo.setAttributeValue("EVALUATESCENARIO", message.getFieldValue("EstDestType"));
					crbo.setAttributeValue("EVALUATEMODEL", message.getFieldValue("EstMthType"));
					crbo.setAttributeValue("EVAFINISHDATE", message.getFieldValue("ExtValExpDate"));
					crbo.setAttributeValue("EVALUATEMETHOD", message.getFieldValue("InrExtEstType"));
					crbo.setAttributeValue("CMISAPPLYNO", cmisApplyNo);
					crbo.setAttributeValue("INPUTDATE", DateHelper.getToday());
					arm.saveObject(crbo);
					
					updateAssetInfo(message.getFieldValue("MrtgPlgCltlNo"), message.getFieldValue("ChkVal"));
				}
			}*/
		}catch(Exception ex)
		{
			ex.printStackTrace();
			//暂时不抛出异常
			throw ex;
		}
       
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
		if(ae1 == null) throw new Exception("无对应押品！");
		ae1.setAttributeValue("ConfirmValue", Double.valueOf(confirmValue));
		this.businessObjectManager.updateBusinessObject(ae1);
		this.businessObjectManager.updateDB();
		
		return "true";
	}
	
	public String updateMutilEva(JBOTransaction tx) throws Exception{
		this.tx=tx;
		getBusinessObjectManager();
		String serialNo = (String)inputParameter.getValue("SerialNo");
		String applyStatus = (String)inputParameter.getValue("ApplyStatus");
		String approveStatus = (String)inputParameter.getValue("ApproveStatus");
		String opinionFlag = (String)inputParameter.getValue("OpinionFlag");
		return this.updateMutilEva(serialNo,applyStatus,approveStatus,opinionFlag);
	}
	
	public String updateMutilEva(String serialNo,String applyStatus,String approveStatus,String opinionFlag) throws Exception{
		String msg = "";
		BusinessObject ae1 = this.businessObjectManager.keyLoadBusinessObject("jbo.app.ASSET_EVALUATE_RELATIVE", serialNo);
		if("1".equals(applyStatus) && "1".equals(applyStatus)) {
			ae1.setAttributeValue("ApplyStatus", "2");
			this.businessObjectManager.updateBusinessObject(ae1);
			this.businessObjectManager.updateDB();
			
			msg = "提交至复核岗审核！";
		}
		if("2".equals(applyStatus) && "1".equals(approveStatus)) {
			ae1.setAttributeValue("ApproveStatus", "2");
			this.businessObjectManager.updateBusinessObject(ae1);
			this.businessObjectManager.updateDB();
			if("01".equals(opinionFlag)) {
				msg = "提交成功（任务已通过）！";
			} else {
				msg = "提交成功（任务已否决）！";
			}
		}
		
		return msg;
	}
	
	public String backMutilEva(JBOTransaction tx) throws Exception{
		this.tx=tx;
		getBusinessObjectManager();
		String serialNo = (String)inputParameter.getValue("SerialNo");
		String applyStatus = (String)inputParameter.getValue("ApplyStatus");
		String approveStatus = (String)inputParameter.getValue("ApproveStatus");
		return this.backMutilEva(serialNo,applyStatus,approveStatus);
	}
	
	public String backMutilEva(String serialNo,String applyStatus,String approveStatus) throws Exception{
		String msg = "";
		BusinessObject ae1 = this.businessObjectManager.keyLoadBusinessObject("jbo.app.ASSET_EVALUATE_RELATIVE", serialNo);
		if("1".equals(applyStatus) && "1".equals(applyStatus)) {
			this.businessObjectManager.deleteBusinessObject(ae1);
			this.businessObjectManager.updateDB();
			
			msg = "任务已取消！";
		}
		if("2".equals(applyStatus) && "1".equals(approveStatus)) {
			ae1.setAttributeValue("ApplyStatus", "1");
			this.businessObjectManager.updateBusinessObject(ae1);
			this.businessObjectManager.updateDB();
			
			msg = "退回成功！";
		}
		
		return msg;
	}
	
	public String getOpinion(JBOTransaction tx) throws Exception{
		this.tx=tx;
		getBusinessObjectManager();
		String serialNo = (String)inputParameter.getValue("SerialNo");
		return this.getOpinion(serialNo);
	}
	
	public String getOpinion(String serialNo) throws Exception{
		BusinessObject eva = this.businessObjectManager.keyLoadBusinessObject("jbo.app.ASSET_EVALUATE_RELATIVE", serialNo);
		String phaseactionType = eva.getString("PHASEACTIONTYPE");
		if(StringX.isEmpty(phaseactionType))
			return "true";
		
		return phaseactionType;
	}
}