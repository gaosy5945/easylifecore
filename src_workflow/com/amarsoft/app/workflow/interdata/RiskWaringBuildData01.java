package com.amarsoft.app.workflow.interdata;

import java.util.List;

import com.amarsoft.app.als.afterloan.action.RiskWarningBackSetValue;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.config.impl.SystemDBConfig;
import com.amarsoft.dict.als.manage.NameManager;

/**
 * 通过对象类型、对象编号获取对象基础信息
 * @author 张万亮
 */

public class RiskWaringBuildData01 implements IData {


	
	@Override
	public List<BusinessObject> getFlowObjects(String objectType,BusinessObjectManager bomanager,Object... parameters) throws Exception{
		String sql = "select * from jbo.al.RISK_WARNING_CONFIG C,jbo.flow.FLOW_OBJECT FO,jbo.al.RISK_WARNING_SIGNAL O "+
				 	 " where FO.ObjectType = 'jbo.al.RISK_WARNING_SIGNAL01' and FO.ObjectNo = O.SerialNo and C.SIGNALID = O.SIGNALID"+
					 " and FO.FlowSerialNo in(:FlowSerialNo) ";
		return bomanager.loadBusinessObjects("jbo.flow.FLOW_OBJECT", sql, parameters);
	}
	
	
	@Override
	public List<BusinessObject> getObjects(String objectType,BusinessObjectManager bomanager,Object... parameters) throws Exception{
		String sql = "select * from jbo.al.RISK_WARNING_CONFIG C,jbo.al.RISK_WARNING_SIGNAL O where C.SIGNALID = O.SIGNALID"+
					 " and O.SerialNo in(:SerialNo)"; 
		return bomanager.loadBusinessObjects("jbo.al.RISK_WARNING_SIGNAL", sql, parameters);
		
	}
	
	public void transfer(BusinessObject bo) throws Exception {
		if(bo ==  null) return;
		
		bo.setAttributeValue("CertTypeName", NameManager.getItemName("CustomerCertType", bo.getString("CertType")));
		bo.setAttributeValue("OperateUserName", NameManager.getUserName(bo.getString("Inputuserid")));
		bo.setAttributeValue("OperateOrgName", SystemDBConfig.getOrg(bo.getString("Inputorgid")).getString("OrgName"));
		bo.setAttributeValue("OrgLevel", SystemDBConfig.getOrg(bo.getString("Inputorgid")).getString("OrgLevel"));
		//bo.setAttributeValue("SIGNALSUBJECT", NameManager.getItemName("RiskWarningPoint", bo.getString("SIGNALSUBJECT")));
		bo.setAttributeValue("RISKINDEXATTRIBUTE", NameManager.getItemName("RiskIndexAttribute", bo.getString("RISKINDEXATTRIBUTE")));
		bo.setAttributeValue("SIGNALLEVEL", NameManager.getItemName("RiskWarningLevel", bo.getString("SIGNALLEVEL")));
		bo.setAttributeValue("GIVEOUT", RiskWarningBackSetValue.getIsOrNotGiveOut(bo.getString("SerialNo")));
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
	
	public void finish(String key, BusinessObjectManager bomanager) throws Exception
	{
		cancel(key,bomanager);
	}

}
