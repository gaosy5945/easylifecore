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
 * 通过对象类型、对象编号获取对象基础信息——合作项目建立
 * @author xyxiong
 */
public class ProjectApplyData implements IData{
	@Override
	public List<BusinessObject> getFlowObjects(String objectType,BusinessObjectManager bomanager,Object... parameters) throws Exception{
		String sql = "select v.O.*,FO.FLowSerialNo,FO.ObjectNo from O ,jbo.flow.FLOW_OBJECT FO " +
				"where O.SerialNo = FO.ObjectNo " +
				"and FO.ObjectType ='jbo.prj.PRJ_BASIC_INFO' " +
				"and FO.FlowSerialNo in (:FlowSerialNo) ";
		return bomanager.loadBusinessObjects("jbo.prj.PRJ_BASIC_INFO", sql,parameters);
	}
	
	
	@Override
	public List<BusinessObject> getObjects(String objectType,BusinessObjectManager bomanager,Object... parameters) throws Exception{
		String sql = "select * from jbo.prj.PRJ_BASIC_INFO O where 1=1 "+
					 " and O.SerialNo in (:SerialNo)"; 
		return bomanager.loadBusinessObjects("jbo.prj.PRJ_BASIC_INFO", sql, parameters);
		
	}
	
	
	public void transfer(BusinessObject bo) throws Exception {
		if(bo ==  null) return;
		String prjSerialNo = bo.getString("SERIALNO");
		BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.prj.PRJ_RELATIVE");
		BizObjectQuery boq = bm.createQuery("PROJECTSERIALNO=:ProjectSerialNo and RelativeType like '03%' and RelativeType <> '03'"); 
		boq.setParameter("ProjectSerialNo", prjSerialNo);
		BizObject pr = boq.getSingleResult(false);
		if(pr!=null){
			String  RelativeType = pr.getAttribute("RelativeType").getString();
			bo.setAttributeValue("RelativeType", RelativeType);
			bo.setAttributeValue("RelativeTypeName", NameManager.getItemName("PrjRelativeType",RelativeType));
		}
		//向虚拟字段转换数据
		BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager();
		BusinessObject customer = bom.keyLoadBusinessObject("jbo.customer.CUSTOMER_INFO", bo.getString("CustomerID"));
		if(customer != null){
			bo.setAttributeValue("CustomerName", customer.getString("CustomerName"));
		}
		//LISTTYPE
		BusinessObject customerList = bom.loadBusinessObject("jbo.customer.CUSTOMER_LIST", "CustomerID",bo.getString("CustomerID"));
		if(customerList != null){
			String tempItemName = customerList.getString("ListType");
			String listName = "";
			if(tempItemName!=null) listName = NameManager.getItemName("CustomerListType", tempItemName);
			bo.setAttributeValue("ListType", listName);
		}
		bo.setAttributeValue("InputUserName", NameManager.getUserName(bo.getString("InputUserID")));
		bo.setAttributeValue("InputOrgName", NameManager.getOrgName(bo.getString("InputOrgID")));
	}


	public List<BusinessObject> group(List<BusinessObject> boList)
			throws Exception {
		return boList;
	}

	//delete
	public void cancel(String key, BusinessObjectManager bomanager) throws Exception {
			//注意：在删除主要信息以前需要先删除关联表信息
			BizObjectManager bo = bomanager.getBizObjectManager("jbo.prj.PRJ_BASIC_INFO");
			bo.createQuery("delete from O where SerialNo=:SerialNo")
			.setParameter("SeriaLNo", key)
			.executeUpdate();
	}
	
	public void finish(String key, BusinessObjectManager bomanager) throws Exception {
		cancel(key,bomanager);
	}
}
