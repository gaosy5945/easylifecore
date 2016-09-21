package com.amarsoft.app.als.credit.approve.action;

/**
 * author��������
 * ˵������Ȳ���������
 */

import java.sql.Connection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.json.JSONObject;

public class UpdateStatus {
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
	//���ʧЧ������CL_INFO��
	public String updateCLLose(JBOTransaction tx) throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.cl.CL_INFO");
		tx.join(bm);
		
		String CLSerialNo = (String)inputParameter.getValue("CLSerialNo");
		
		bm.createQuery("update O set Status=:Status Where SerialNo=:SerialNo")
		  .setParameter("Status","50").setParameter("SerialNo", CLSerialNo).executeUpdate();
		
		return "SUCCEED";
	}
	
	public String checkCL(JBOTransaction tx) throws Exception{
		
		businessObjectManager = BusinessObjectManager.createBusinessObjectManager(tx);
		String serialNo = (String)inputParameter.getValue("SerialNo");
		
		BusinessObject clInfo = businessObjectManager.keyLoadBusinessObject("jbo.cl.CL_INFO", serialNo);
		
		String selectSql = " RelativeObjectNo=:RelativeObjectNo and RelativeObjectNo=:RelativeObjectNo and TRANSSTATUS not in ('1','2') and transactioncode='015001' ";
		List<BusinessObject> transactionList = businessObjectManager.loadBusinessObjects("jbo.acct.ACCT_TRANSACTION", selectSql, "RelativeObjectType", clInfo.getString("ObjectType"),"RelativeObjectNo", clInfo.getString("ObjectNo"));
		
		if(transactionList!=null&&transactionList.size()>0){
			return "false";
		}
		
		return "true";
	}
	
	
	//��ͣ���룬�ύ���ſ��
	public String submitApply(JBOTransaction tx) throws Exception{
		this.tx = tx;
		businessObjectManager = BusinessObjectManager.createBusinessObjectManager(tx);
		
		String serialNo = (String)inputParameter.getValue("SerialNo");
		String status = (String)inputParameter.getValue("Status");
		BusinessObject clOperateInfo = businessObjectManager.keyLoadBusinessObject("jbo.cl.CL_OPERATE", serialNo);
		String phaseaction = clOperateInfo.getString("PhaseAction");
		if(!"2".equals(status)){
			if("1".equals(phaseaction)){
				status = "3";//ͬ��
			}else{
				status = "4";//���
			}
		}
		clOperateInfo.setAttributeValue("flowTodoStatus", status);
		businessObjectManager.updateBusinessObject(clOperateInfo);
		
		if("3".equals(status)){
			
			
			BusinessObject clInfo = businessObjectManager.keyLoadBusinessObject("jbo.cl.CL_INFO", clOperateInfo.getString("CLSerialNo"));
			BusinessObject businesscontract = businessObjectManager.keyLoadBusinessObject(clOperateInfo.getString("ObjectType"), clOperateInfo.getString("ObjectNo"));
			String businessType = businesscontract.getString("BusinessType");
			String clType = clInfo.getString("CLType");
			/*
			if("500".equals(businessType)||"502".equals(businessType)
					||"666".equals(businessType)){
				String operateType = clOperateInfo.getString("OPERATETYPE");
				if("1".equals(operateType)){
					
					OCITransaction transactionReq = this.runCoreInstance(clOperateInfo);
					
					String returnCode = transactionReq.getOMessage("SysBody").getFieldByTag("RspSvcHeader").getObjectMessage().getFieldValue("ReturnCode");
					String returnMsg = transactionReq.getOMessage("SysBody").getFieldByTag("RspSvcHeader").getObjectMessage().getFieldValue("ReturnMsg");
					
					
					if(OCIConfig.RETURN_CODE_NORMAL.equals(returnCode))
					{
						//���¶����Ϣ
						clInfo.setAttributeValue("Status", "30");
						businessObjectManager.updateBusinessObject(clInfo);
						
						
					}else{
						ARE.getLog().error("�����ͣʧ�ܣ�ʧ��ԭ��"+returnMsg);
						throw new Exception("�����ͣʧ�ܣ�ʧ��ԭ��"+returnMsg);
					}
					
					
				}else if("2".equals(operateType)){
					
					OCITransaction transactionReq = this.runCoreInstance(clOperateInfo);
					
					String returnCode = transactionReq.getOMessage("SysBody").getFieldByTag("RspSvcHeader").getObjectMessage().getFieldValue("ReturnCode");
					String returnMsg = transactionReq.getOMessage("SysBody").getFieldByTag("RspSvcHeader").getObjectMessage().getFieldValue("ReturnMsg");
					
					
					if(OCIConfig.RETURN_CODE_NORMAL.equals(returnCode))
					{
						//���¶����Ϣ
						clInfo.setAttributeValue("Status", "20");
						businessObjectManager.updateBusinessObject(clInfo);
						
						
					}else{
						ARE.getLog().error("��Ȼָ�ʧ�ܣ�ʧ��ԭ��"+returnMsg);
						throw new Exception("��Ȼָ�ʧ�ܣ�ʧ��ԭ��"+returnMsg);
					}
					
				}
			}else if("888".equals(businessType)||"0107".equals(clType)){
				String operateType = clOperateInfo.getString("OPERATETYPE");
				if("1".equals(operateType)){
					
					OCITransaction transactionReq = this.runZYCardCoreInstance(clOperateInfo);
					
					String returnCode = transactionReq.getOMessage("SysBody").getFieldByTag("RspSvcHeader").getObjectMessage().getFieldValue("ReturnCode");
					String returnMsg = transactionReq.getOMessage("SysBody").getFieldByTag("RspSvcHeader").getObjectMessage().getFieldValue("ReturnMsg");
					
					
					if(OCIConfig.RETURN_CODE_NORMAL.equals(returnCode))
					{
						//���¶����Ϣ
						clInfo.setAttributeValue("Status", "30");
						businessObjectManager.updateBusinessObject(clInfo);
						
						
					}else{
						ARE.getLog().error("�����ͣʧ�ܣ�ʧ��ԭ��"+returnMsg);
						throw new Exception("�����ͣʧ�ܣ�ʧ��ԭ��"+returnMsg);
					}
					
					
				}else if("2".equals(operateType)){
					
					OCITransaction transactionReq = this.runZYCardCoreInstance(clOperateInfo);
					
					String returnCode = transactionReq.getOMessage("SysBody").getFieldByTag("RspSvcHeader").getObjectMessage().getFieldValue("ReturnCode");
					String returnMsg = transactionReq.getOMessage("SysBody").getFieldByTag("RspSvcHeader").getObjectMessage().getFieldValue("ReturnMsg");
					
					
					if(OCIConfig.RETURN_CODE_NORMAL.equals(returnCode))
					{
						//���¶����Ϣ
						clInfo.setAttributeValue("Status", "20");
						businessObjectManager.updateBusinessObject(clInfo);
						
						
					}else{
						ARE.getLog().error("��Ȼָ�ʧ�ܣ�ʧ��ԭ��"+returnMsg);
						throw new Exception("��Ȼָ�ʧ�ܣ�ʧ��ԭ��"+returnMsg);
					}
					
				}
			}else{
				String operateType = clOperateInfo.getString("OPERATETYPE");
				if("1".equals(operateType)){
				
					//���¶����Ϣ
					clInfo.setAttributeValue("Status", "30");
					businessObjectManager.updateBusinessObject(clInfo);
					
				}else if("2".equals(operateType)){
				
					//���¶����Ϣ
					clInfo.setAttributeValue("Status", "20");
					businessObjectManager.updateBusinessObject(clInfo);
						
				}
			}
			
			*/
		}
		
		businessObjectManager.updateDB();
		
		return "SUCCEED";
	}
	
}
