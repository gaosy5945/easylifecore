package com.amarsoft.acct.accounting.web;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.trans.TransactionHelper;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.app.workflow.config.FlowConfig;
import com.amarsoft.app.workflow.manager.FlowManager;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.StringX;

/**
 * 删除指定对象主信息和其关联信息，并将其关联流程信息也删除
 * @author 赵晓建
 */
public class AddBatchApply{
	private String userID;
	private String orgID;
	private String applyType;
	private String flowNo;
	private String transactionCode;
	private String batchType;
	
	
	public String getApplyType() {
		return applyType;
	}


	public void setApplyType(String applyType) {
		this.applyType = applyType;
	}


	public String getUserID() {
		return userID;
	}


	public void setUserID(String userID) {
		this.userID = userID;
	}



	public String getOrgID() {
		return orgID;
	}



	public void setOrgID(String orgID) {
		this.orgID = orgID;
	}



	public String getFlowNo() {
		return flowNo;
	}


	public void setFlowNo(String flowNo) {
		this.flowNo = flowNo;
	}

	

	public String getTransactionCode() {
		return transactionCode;
	}


	public void setTransactionCode(String transactionCode) {
		this.transactionCode = transactionCode;
	}


	public String getBatchType() {
		return batchType;
	}


	public void setBatchType(String batchType) {
		this.batchType = batchType;
	}


	public String add(JBOTransaction tx) throws Exception {
		
		
		BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager(tx);
		BusinessObject bb = BusinessObject.createBusinessObject("jbo.app.BAT_BUSINESS");
		bb.generateKey();
		bb.setAttributeValue("InputUserID", userID);
		bb.setAttributeValue("InputOrgID", orgID);
		bb.setAttributeValue("BatchType", batchType);
		bb.setAttributeValue("InputTime", DateHelper.getBusinessTime());
		bomanager.updateBusinessObject(bb);
		if(!StringX.isEmpty(flowNo))
		{
			BusinessObject transaction = TransactionHelper.createTransaction(transactionCode, null, bb, userID, orgID, DateHelper.getBusinessDate(), bomanager);
			
			List<BusinessObject> bos = new ArrayList<BusinessObject>();
			bos.add(transaction);
			transaction.setAttributeValue("TransStatus", "0");
			
			BusinessObject context = BusinessObject.createBusinessObject();
			context.setAttributeValue("ApplyType", applyType);
			
			String flowVersion = FlowConfig.getFlowDefaultVersion(flowNo);
			FlowManager fm = FlowManager.getFlowManager(bomanager);
			String result = fm.createInstance("jbo.acct.ACCT_TRANSACTION_BB", bos, flowNo, userID, orgID, context);
			
			//流程是否启动不影响整个数据处理
			String instanceID = result.split("@")[0];
			String phaseNo = result.split("@")[1];
			String taskSerialNo = result.split("@")[2];
			
			bomanager.updateDB();
			
			String functionID = FlowConfig.getFlowPhase(flowNo, flowVersion, phaseNo).getString("FunctionID");
			return "true@"+taskSerialNo+"@"+instanceID+"@"+phaseNo+"@"+functionID;
		}else
		{
			bomanager.updateDB();
			return "true@"+bb.getKeyString();
		}
	}
	
}
