package com.amarsoft.app.workflow.interdata;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.config.impl.SystemDBConfig;
import com.amarsoft.dict.als.manage.NameManager;

/**
 * 通过对象类型、对象编号获取对象基础信息
 * @author 张万亮
 */

public class RiskWaringBuildData implements IData {


	@Override
	public List<BusinessObject> getFlowObjects(String objectType,BusinessObjectManager bomanager,Object... parameters) throws Exception{
		String sql = "select O.SerialNo,O.SignalType,O.InputUserID,O.InputOrgID,O.InputDate,AL.ContractSerialNo,CI.CustomerName,CI.CustomerID,FO.FlowSerialNo,RWC.SignalName,RWC.SignalSubject,RWC.RiskIndexAttribute,RWC.SignalLevel "
				+ "from jbo.flow.FLOW_OBJECT FO,jbo.al.RISK_WARNING_OBJECT RWO,jbo.acct.ACCT_LOAN AL,jbo.customer.CUSTOMER_INFO CI,O "
				+ "left join jbo.al.RISK_WARNING_CONFIG RWC on O.SignalID = RWC.SignalID "
				+ "where O.SerialNo = FO.ObjectNo "
				+ "and FO.ObjectType='jbo.al.RISK_WARNING_SIGNAL' "
				+ "and FO.FlowSerialNo in (:FlowSerialNo) "
				+ "and RWO.SignalSerialNo=O.SerialNo "
				+ "and AL.SerialNo=RWO.ObjectNo and RWO.ObjectType='jbo.acct.ACCT_LOAN' "
				+ "and AL.CustomerID=CI.CustomerID ";
		return bomanager.loadBusinessObjects("jbo.al.RISK_WARNING_SIGNAL", sql, parameters);
	}
	
	
	@Override
	public List<BusinessObject> getObjects(String objectType,BusinessObjectManager bomanager,Object... parameters) throws Exception{
		String sql = "select * from jbo.acct.ACCT_LOAN AL,jbo.customer.CUSTOMER_INFO CI,jbo.al.RISK_WARNING_OBJECT RWO, O "+
					 " where RWO.SignalSerialNo=O.SerialNo and AL.SerialNo=RWO.ObjectNo and AL.CustomerID = CI.CustomerID and RWO.ObjectType = 'jbo.acct.ACCT_LOAN'"+
					 " and O.SerialNo in(:SerialNo)"; 
		return bomanager.loadBusinessObjects("jbo.al.RISK_WARNING_SIGNAL", sql, parameters);
		
	}
	
	public void transfer(BusinessObject bo) throws Exception {
		if(bo ==  null) return;
		bo.setAttributeValue("ObjectNo", bo.getString("SerialNo"));
		bo.setAttributeValue("CONTRACTSERIALNO", bo.getString("ContractSerialNo"));
		bo.setAttributeValue("SIGNALSUBJECT", NameManager.getItemName("RiskWarningSubject", bo.getString("SignalSubject")));
		bo.setAttributeValue("RISKINDEXATTRIBUTE", NameManager.getItemName("RiskIndexAttribute", bo.getString("RiskIndexAttribute")));
		bo.setAttributeValue("SIGNALLEVEL", NameManager.getItemName("RiskWarningLevel", bo.getString("SignalLevel")));
		bo.setAttributeValue("INPUTUSERID", NameManager.getUserName(bo.getString("InputUserID")));
		bo.setAttributeValue("INPUTORGNAME", NameManager.getOrgName(bo.getString("INPUTORGID")));
	}
	

	public List<BusinessObject> group(List<BusinessObject> boList) throws Exception {
		return boList;
	}


	public void cancel(String key, BusinessObjectManager bomanager) throws Exception {
		bomanager.getBizObjectManager("jbo.al.RISK_WARNING_SIGNAL")
		.createQuery("delete from O where SerialNo=:SerialNo")
		.setParameter("SerialNo", key)
		.executeUpdate();
		
		bomanager.getBizObjectManager("jbo.al.RISK_WARNING_OBJECT")
		.createQuery("delete from O where signalserialno=:SerialNo")
		.setParameter("SerialNo", key)
		.executeUpdate();
	}

	public void finish(String key, BusinessObjectManager bomanager) throws Exception {
		
	}
}
