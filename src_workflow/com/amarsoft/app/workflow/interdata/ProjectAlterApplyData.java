package com.amarsoft.app.workflow.interdata;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.config.impl.SystemDBConfig;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.dict.als.manage.NameManager;

public class ProjectAlterApplyData implements IData {


	@Override
	public List<BusinessObject> getFlowObjects(String objectType,BusinessObjectManager bomanager,Object... parameters) throws Exception{
		String sql = "select v.O.*,v.PBI.*,v.FO.* from O,jbo.prj.PRJ_BASIC_INFO PBI,jbo.flow.FLOW_OBJECT FO "+
					 " where O.ProjectSerialNo=PBI.SerialNo and O.SerialNo = FO.ObjectNo" +
					 " and FO.ObjectType ='jbo.prj.PRJ_ASSET_LOG' and FO.FlowSerialNo in (:FlowSerialNo) ";
		return bomanager.loadBusinessObjects("jbo.prj.PRJ_ASSET_LOG", sql,  parameters);
	}
	
	
	@Override
	public List<BusinessObject> getObjects(String objectType,BusinessObjectManager bomanager,Object... parameters) throws Exception{
		String sql = "select * from jbo.prj.PRJ_ASSET_LOG PAL,jbo.prj.PRJ_BASIC_INFO PBI,jbo.customer.CUSTOMER_PARTNER CP "+
					 " where PBI.CustomerID = CP.CustomerID and PAL.ProjectSerialNo=PBI.SerialNo "+
					 " and PAL.SerialNo in (:SerialNo)"; 
		return bomanager.loadBusinessObjects("jbo.prj.PRJ_ASSET_LOG", sql, parameters);
		
	}
	
	public void transfer(BusinessObject bo) throws Exception {
        if(bo ==  null) return;
		
		bo.setAttributeValue("AdjustTypeName", NameManager.getItemName("ProjectTransactionCode", bo.getString("AdjustType")));
		bo.setAttributeValue("ProjectTypeName", NameManager.getItemName("ProjectType", bo.getString("ProjectType")));
		bo.setAttributeValue("CustomerName", NameManager.getCustomerName(bo.getString("CustomerID")));
		bo.setAttributeValue("PartnerTypeName", NameManager.getItemName("PartnerType",bo.getString("PartnerType")));
		bo.setAttributeValue("INPUTUSERNAME", NameManager.getUserName(bo.getString("AdjustUserID")));
		bo.setAttributeValue("INPUTORGNAME", SystemDBConfig.getOrg(bo.getString("AdjustOrgID")).getString("OrgName"));
	}

	public List<BusinessObject> group(List<BusinessObject> boList)
			throws Exception {
		return boList;
	}

	public void cancel(String key, BusinessObjectManager bomanager) throws Exception {
		//注意：在删除主要信息以前需要先删除关联表信息
		BizObjectManager bo = bomanager.getBizObjectManager("jbo.prj.PRJ_ASSET_LOG");
		bo.createQuery("delete from O where SerialNo=:SerialNo")
		.setParameter("SerialNo", key)
		.executeUpdate();
	}
	
	public void finish(String key, BusinessObjectManager bomanager) throws Exception {
		
	}

}
