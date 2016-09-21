package com.amarsoft.app.workflow.interdata;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.config.impl.SystemDBConfig;
import com.amarsoft.app.als.sys.tools.SYSNameManager;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.dict.als.manage.NameManager;

/**
 * 通过对象类型、对象编号获取对象基础信息
 * @author 赵晓建
 */

public class PutOutData implements IData {

	
	@Override
	public List<BusinessObject> getFlowObjects(String objectType,BusinessObjectManager bomanager,Object... parameters) throws Exception{
		String sql = "select * from jbo.customer.CUSTOMER_INFO CI,jbo.app.BUSINESS_PUTOUT O,jbo.flow.FLOW_OBJECT FO "+
					 " where O.CustomerID = CI.CustomerID and O.SerialNo = FO.ObjectNo and FO.ObjectType = 'jbo.app.BUSINESS_PUTOUT' "+
					 " and FO.FlowSerialNo in(:FlowSerialNo) ";
		return bomanager.loadBusinessObjects("jbo.flow.FLOW_OBJECT", sql, parameters);
	}
	
	
	@Override
	public List<BusinessObject> getObjects(String objectType,BusinessObjectManager bomanager,Object... parameters) throws Exception{
		String sql = "select * from jbo.customer.CUSTOMER_INFO CI,jbo.app.BUSINESS_PUTOUT O,jbo.flow.FLOW_OBJECT FO "+
					 " where O.CustomerID = CI.CustomerID and O.SerialNo = FO.ObjectNo and FO.ObjectType = 'jbo.app.BUSINESS_PUTOUT' "+
					 " and O.SerialNo in(:SerialNo)"; 
		return bomanager.loadBusinessObjects("jbo.app.BUSINESS_PUTOUT", sql, parameters);
		
	}
	

	public void transfer(BusinessObject bo) throws Exception {
		if(bo ==  null) return;
		
		bo.setAttributeValue("CertTypeName", NameManager.getItemName("CustomerCertType", bo.getString("CertType")));
		bo.setAttributeValue("OperateUserName", NameManager.getUserName(bo.getString("OperateUserID")));
		bo.setAttributeValue("OperateOrgName", SystemDBConfig.getOrg(bo.getString("OperateOrgID")).getString("OrgName"));
		bo.setAttributeValue("OrgLevel", SystemDBConfig.getOrg(bo.getString("OperateOrgID")).getString("OrgLevel"));
		bo.setAttributeValue("BusinessTypeName", NameManager.getBusinessName(bo.getString("BusinessType")));
		bo.setAttributeValue("ProductName", SYSNameManager.getProductName(bo.getString("ProductID")));
		bo.setAttributeValue("MarketChannelFlagName", NameManager.getItemName("MarketChannelFlag", bo.getString("MarketChannelFlag")));
		int month = bo.getInt("BusinessTerm");
		int day = bo.getInt("BusinessTermDay");
		bo.setAttributeValue("BusinessTerm", (month/12)+"年"+(month%12)+"月"+day+"天");
		bo.setAttributeValue("TaskName", "出账申请");
		
		bo.setAttributeValue("email_or_msg","0");
	}
	

	@Override
	public List<BusinessObject> group(List<BusinessObject> boList)
			throws Exception {
		return boList;
	}


	public void cancel(String key, BusinessObjectManager bomanager) throws Exception {
		
		BizObjectManager bo = bomanager.getBizObjectManager("jbo.app.BUSINESS_PUTOUT");
		bo.createQuery("delete from O where SerialNo=:SerialNo")
		.setParameter("SerialNo", key)
		.executeUpdate();
	}

	public void finish(String key, BusinessObjectManager bomanager) throws Exception {
		cancel(key,bomanager);
	}
}
