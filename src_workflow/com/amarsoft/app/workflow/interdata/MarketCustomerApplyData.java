package com.amarsoft.app.workflow.interdata;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.dict.als.manage.NameManager;

/**
 * 通过对象类型、对象编号获取对象基础信息
 * @author ckxu
 */

public class MarketCustomerApplyData implements IData {

	@Override
	public List<BusinessObject> getFlowObjects(String objectType,BusinessObjectManager bomanager,Object... parameters) throws Exception{
		String sql = "select v.O.*,v.FO.* from O,jbo.flow.FLOW_OBJECT FO "+
					 " where FO.ObjectType ='jbo.customer.CUSTOMER_INFO' and FO.FlowSerialNo in (:FlowSerialNo) and "+"O.CUSTOMERID=FO.OBJECTNO";
		return bomanager.loadBusinessObjects("jbo.customer.CUSTOMER_INFO",sql,parameters);
	}
	
	
	@Override
	public List<BusinessObject> getObjects(String objectType,BusinessObjectManager bomanager,Object... parameters) throws Exception{
		String sql = "select v.O.* from O"+
					 " where O.CustomerID in (:CustomerID)"; 
		return bomanager.loadBusinessObjects("jbo.customer.CUSTOMER_INFO", sql, parameters);
		
	}
	
	public void transfer(BusinessObject bo) throws Exception {
		if(bo ==  null) return;
		bo.setAttributeValue("CertTypeName", NameManager.getItemName("CustomerCertType", bo.getString("CertType")));
		bo.setAttributeValue("TaskName", "零售商准入申请");
		//OperateOrgName,OccurDate
		String orgID = bo.getString("ORGID");
		if(orgID == null) 
			orgID="";
		String inputDate = bo.getString("INPUTDATE");
		if(inputDate == null) 
			inputDate="";
		bo.setAttributeValue("OperateOrgName", NameManager.getOrgName(orgID));
		bo.setAttributeValue("OccurDate", inputDate);
		
		BizObjectManager arm = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_INFO");
		BizObjectQuery arq = arm.createQuery("customerid= :customerid");
		arq.setParameter("customerid", bo.getString("customerid"));
		@SuppressWarnings("unchecked")
		List<BizObject> arList = arq.getResultList(false);
		if(arList != null && !arList.isEmpty())
		{
			bo.setAttributeValue("TaskName", "零售商准入申请");
			BusinessObject ba = BusinessObject.createBusinessObject("jbo.customer.CUSTOMER_INFO");
			ba.setAttributesValue(bo);
			//bo.setAttributeValue("ImageFlag", FlowHelper.getImageFlag(ba));
		}
	}
	
	public List<BusinessObject> group(List<BusinessObject> boList)
			throws Exception {
		return boList;
	}


	public void cancel(String key, BusinessObjectManager bomanager) throws Exception {
		
		bomanager.getBizObjectManager("jbo.customer.CUSTOMER_INFO")
		.createQuery("update O set status = '01' where customerid = :customerID")
		.setParameter("customerID", key)
		.executeUpdate();
		bomanager.getBizObjectManager("jbo.customer.CUSTOMER_LIST")
		.createQuery("update O set status = '4' where customerid = :customerID")
		.setParameter("customerID", key)
		.executeUpdate();
	}

	
	public void finish(String key, BusinessObjectManager bomanager) throws Exception {

		bomanager.getBizObjectManager("jbo.customer.CUSTOMER_LIST")
		.createQuery("update O set status = '2' where customerid = :customerID")
		.setParameter("customerID", key)
		.executeUpdate();
		bomanager.getBizObjectManager("jbo.customer.CUSTOMER_INFO")
		.createQuery("update O set status = '02' where customerid = :customerID")
		.setParameter("customerID", key)
		.executeUpdate();
	}
}
