package com.amarsoft.app.workflow.interdata;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.config.impl.SystemDBConfig;
import com.amarsoft.app.als.sys.tools.SYSNameManager;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.dict.als.manage.NameManager;

/**
 * 通过对象类型、对象编号获取对象基础信息
 * @author 张万亮
 */

public class RiskClassifyData implements IData {

	@Override
	public List<BusinessObject> getFlowObjects(String objectType,BusinessObjectManager bomanager,Object... parameters) throws Exception{
		String sql = "select BD.CLASSIFYMETHOD AS BDCLASSIFYMETHOD,BC.*,BD.*,FO.*,CI.*,O.* from jbo.app.BUSINESS_CONTRACT BC,jbo.app.BUSINESS_DUEBILL BD,jbo.flow.FLOW_OBJECT FO,jbo.customer.CUSTOMER_INFO CI,jbo.al.CLASSIFY_RECORD O "+
					 " where O.ObjectType = 'jbo.app.BUSINESS_DUEBILL' and O.ObjectNo = BD.SerialNo and BD.CustomerID = CI.CustomerID and BC.SERIALNO=BD.CONTRACTSERIALNO and FO.ObjectNo = O.SerialNo and FO.ObjectType = 'jbo.al.CLASSIFY_RECORD' "+
					 " and FO.FlowSerialNo in(:FlowSerialNo) ";
		return bomanager.loadBusinessObjects("jbo.flow.FLOW_OBJECT", sql, parameters);
	}
	
	
	@Override
	public List<BusinessObject> getObjects(String objectType,BusinessObjectManager bomanager,Object... parameters) throws Exception{
		String sql = "select * from jbo.app.BUSINESS_DUEBILL BD,jbo.customer.CUSTOMER_INFO CI,jbo.al.CLASSIFY_RECORD O "+
					 " where O.ObjectNo = BD.SerialNo and BD.CustomerID = CI.CustomerID and O.ObjectType = 'jbo.app.BUSINESS_DUEBILL'"+
					 " and O.SerialNo in(:SerialNo)"; 
		return bomanager.loadBusinessObjects("jbo.al.CLASSIFY_RECORD", sql, parameters);
		
	}
	

	public void transfer(BusinessObject bo) throws Exception {
		if(bo ==  null) return;
		
		bo.setAttributeValue("CertTypeName", NameManager.getItemName("CustomerCertType", bo.getString("CertType")));
		bo.setAttributeValue("OperateUserName", NameManager.getUserName(bo.getString("OperateUserID")));
		bo.setAttributeValue("OperateOrgName", SystemDBConfig.getOrg(bo.getString("OperateOrgID")).getString("OrgName"));
		bo.setAttributeValue("OrgLevel", SystemDBConfig.getOrg(bo.getString("OperateOrgID")).getString("OrgLevel"));
		bo.setAttributeValue("BusinessTypeName", NameManager.getBusinessName(bo.getString("BusinessType")));
		bo.setAttributeValue("ProductName", SYSNameManager.getProductName(bo.getString("ProductID")));
		bo.setAttributeValue("DUEBILLSERIALNO", bo.getString("ObjectNo"));

		
		bo.setAttributeValue("CLASSIFYMODELNAME", NameManager.getItemName("ClassifyModel", bo.getString("CLASSIFYMODEL")));
		bo.setAttributeValue("BDCLASSIFYMETHODNAME", NameManager.getItemName("ClassifyMethod", bo.getString("BDCLASSIFYMETHOD")));
		bo.setAttributeValue("ADJUSTEDGRADENAME", NameManager.getItemName("ClassifyGrade5", bo.getString("ADJUSTEDGRADE")));
		bo.setAttributeValue("REFERENCEGRADENAME", NameManager.getItemName("ClassifyGrade5", bo.getString("REFERENCEGRADE")));
		bo.setAttributeValue("CLASSIFYRESULTNAME", NameManager.getItemName("ClassifyGrade5", bo.getString("FINALGRADE")));
		bo.setAttributeValue("CLASSIFYMETHODNAME", NameManager.getItemName("ClassifyMethod", bo.getString("CLASSIFYMETHOD")));		
		bo.setAttributeValue("MarketChannelFlagName", NameManager.getItemName("MarketChannelFlag", bo.getString("MarketChannelFlag")));
	}
	

	public List<BusinessObject> group(List<BusinessObject> boList) throws Exception {
		if(boList == null) return boList;
		List<BusinessObject> returnList = new ArrayList<BusinessObject>();
		HashMap<String,BusinessObject> map = new HashMap<String,BusinessObject>();
		for(BusinessObject bo:boList)
		{
			String groupID = bo.getString("TaskSerialNo");
			if(groupID == null || "".equals(groupID)) groupID = bo.getString("FlowSerialNo");
			BusinessObject tempBo = map.get(groupID);
			if(tempBo == null){
				map.put(groupID, bo);
				returnList.add(bo);
			}
			else
			{
				//tempBo.setAttributeValue("ObjectNo", tempBo.getString("ObjectNo")+","+bo.getString("ObjectNo"));
				//tempBo.setAttributeValue("CertID", tempBo.getString("CertID")+","+bo.getString("CertID"));
				if(tempBo.getString("CustomerName") != null && tempBo.getString("CustomerName").length() > 15 && tempBo.getString("CustomerName").indexOf(",……") ==	 -1)
				{
					tempBo.setAttributeValue("CustomerName", tempBo.getString("CustomerName")+",……");
				}
				else if(tempBo.getString("CustomerName") != null && tempBo.getString("CustomerName").indexOf(",……") ==	 -1)
					tempBo.setAttributeValue("CustomerName", tempBo.getString("CustomerName")+","+bo.getString("CustomerName"));
			}
		}
		
		return returnList;
	}


	public void cancel(String key, BusinessObjectManager bomanager) throws Exception {
		BizObjectManager bo = bomanager.getBizObjectManager("jbo.al.CLASSIFY_RECORD");
		bo.createQuery("delete from O where SerialNo=:SerialNo")
		.setParameter("SerialNo", key)
		.executeUpdate();
	}

	public void finish(String key, BusinessObjectManager bomanager) throws Exception {
		cancel(key,bomanager);
	}
}
