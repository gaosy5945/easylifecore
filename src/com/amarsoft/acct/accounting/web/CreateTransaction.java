package com.amarsoft.acct.accounting.web;


import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.config.impl.TransactionConfig;
import com.amarsoft.app.base.trans.TransactionHelper;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.app.workflow.config.FlowConfig;
import com.amarsoft.app.workflow.interdata.IData;
import com.amarsoft.app.workflow.manager.FlowManager;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.StringX;

/**
 * ����һ�ʽ��ף������ؽ��׵���ˮ��
 * */
public class CreateTransaction {
	private String applyType;//��������
	private String transactionCode;//���״���
	private String relativeObjectType;//��������
	private String relativeObjectNo;//������
	private String reverseSerialNo;//���彻����ˮ
	private String transactionDate;//��������
	private String userID;//�����û�
	private String orgID;//��������
	private String flowFlag;//�Ƿ񴴽����� 1 ������0 ������
	private String channel;//���� ��ʱ����
	

	public String getApplyType() {
		return applyType;
	}

	public void setApplyType(String applyType) {
		this.applyType = applyType;
	}

	public String getTransactionCode() {
		return transactionCode;
	}

	public void setTransactionCode(String transactionCode) {
		this.transactionCode = transactionCode;
	}

	public String getRelativeObjectType() {
		return relativeObjectType;
	}

	public void setRelativeObjectType(String relativeObjectType) {
		this.relativeObjectType = relativeObjectType;
	}

	public String getRelativeObjectNo() {
		return relativeObjectNo;
	}


	public void setRelativeObjectNo(String relativeObjectNo) {
		this.relativeObjectNo = relativeObjectNo;
	}

	public String getTransactionDate() {
		return transactionDate;
	}

	public void setTransactionDate(String transactionDate) {
		this.transactionDate = transactionDate;
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
	
	public String getFlowFlag() {
		return flowFlag;
	}

	public void setFlowFlag(String flowFlag) {
		this.flowFlag = flowFlag;
	}

	public String getChannel() {
		return channel;
	}

	public void setChannel(String channel) {
		this.channel = channel;
	}
	
	public String getReverseSerialNo() {
		return reverseSerialNo;
	}

	public void setReverseSerialNo(String reverseSerialNo) {
		this.reverseSerialNo = reverseSerialNo;
	}

	public String createTransaction(JBOTransaction tx) throws Exception {
		
		if(StringX.isEmpty(flowFlag)) flowFlag = "1";
		if(StringX.isEmpty(channel)) channel = "01";//���û�д���ֵĬ���Ŵ�ϵͳ
		if(StringX.isEmpty(transactionDate)) transactionDate = DateHelper.getBusinessDate();//��ָ���������ڣ���Ĭ��Ϊϵͳ����
		BusinessObjectManager bomanager =BusinessObjectManager.createBusinessObjectManager(tx);//�������������
		
		BusinessObject document = null;
		if(!StringX.isEmpty(reverseSerialNo))
		{
			document = bomanager.keyLoadBusinessObject(BUSINESSOBJECT_CONSTANTS.transaction, reverseSerialNo);
			relativeObjectType = document.getString("RelativeObjectType");
			relativeObjectNo = document.getString("RelativeObjectNo");
		}
		
		BusinessObject relativeObject = bomanager.loadBusinessObject(relativeObjectType,"SerialNo",relativeObjectNo);//��ȡacct_loan����
		
		BusinessObject transaction  = TransactionHelper.createTransaction(transactionCode, document, relativeObject, userID, orgID, transactionDate, bomanager);
		bomanager.updateDB();
		//��ʼ��������Ϣ
		BusinessObject transactionDef = TransactionConfig.getTransactionConfig(transactionCode);
		String flowNo = transactionDef.getString("FlowNo");
		if(flowNo==null||flowNo.length()==0||flowFlag.equals("2")){ 
			return "true@"+ transaction.getKeyString();
		}
		else{
			String flowObjectType = transactionDef.getString("FlowObjectType");
			if(StringX.isEmpty(flowObjectType)) flowObjectType = BUSINESSOBJECT_CONSTANTS.transaction;
			BusinessObject context = BusinessObject.createBusinessObject();
			context.setAttributeValue("ApplyType", applyType);
			
			String className = FlowConfig.getFlowObjectType(flowObjectType).getString("Script");//��ȡȡ���߼�
			Class<?> c = Class.forName(className);
			IData data = (IData)c.newInstance();
			List<BusinessObject> bos = data.getObjects(flowObjectType, bomanager, "SerialNo",transaction.getKeyString());
			FlowManager fm = FlowManager.getFlowManager(bomanager);
			String flowVersion = FlowConfig.getFlowDefaultVersion(flowNo);
			String result = fm.createInstance(flowObjectType, bos, flowNo, userID, orgID, context);
			
			bomanager.updateDB();
			String instanceID = result.split("@")[0];
			String phaseNo = result.split("@")[1];
			String taskSerialNo = result.split("@")[2];
			String functionID = FlowConfig.getFlowPhase(flowNo, flowVersion, phaseNo).getString("FunctionID");
			return "true@"+taskSerialNo+"@"+instanceID+"@"+phaseNo+"@"+functionID;
		}
	}
}
