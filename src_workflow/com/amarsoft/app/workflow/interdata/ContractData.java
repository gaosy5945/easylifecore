package com.amarsoft.app.workflow.interdata;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.config.impl.SystemDBConfig;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.app.als.sys.tools.SYSNameManager;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.dict.als.manage.NameManager;

/**
 * 通过对象类型、对象编号获取对象基础信息
 * @author 赵晓建
 */

public class ContractData implements IData {


	@Override
	public List<BusinessObject> getFlowObjects(String objectType,BusinessObjectManager bomanager,Object... parameters) throws Exception{
		String sql = "select * from jbo.app.BUSINESS_CONTRACT O,jbo.customer.CUSTOMER_INFO CI,jbo.flow.FLOW_OBJECT FO "+
				  	 " where O.CustomerID = CI.CustomerID and O.SerialNo = FO.ObjectNo "+
					 " and FO.ObjectType =:ObjectType and FO.FlowSerialNo in (:FlowSerialNo) ";
		return bomanager.loadBusinessObjects("jbo.flow.FLOW_OBJECT", sql,"ObjectType",objectType,  parameters);
	}
	
	
	@Override
	public List<BusinessObject> getObjects(String objectType,BusinessObjectManager bomanager,Object... parameters) throws Exception{
		String sql = "select * from jbo.app.BUSINESS_CONTRACT O,jbo.customer.CUSTOMER_INFO CI "+
					 " where O.CustomerID = CI.CustomerID "+
					 " and O.SerialNo in (:SerialNo)"; 
		return bomanager.loadBusinessObjects("jbo.app.BUSINESS_CONTRACT", sql, parameters);
		
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
		String maturityDate = bo.getString("MaturityDate");
		if(month == 0 && day == 0 && maturityDate != null && !"".equals(maturityDate))
		{
			month = (int)Math.floor(DateHelper.getMonths(DateHelper.getBusinessDate(), maturityDate));
			day = DateHelper.getDays(DateHelper.getRelativeDate(DateHelper.getBusinessDate(), DateHelper.TERM_UNIT_MONTH, month), maturityDate);
		}
		
		bo.setAttributeValue("BusinessTerm", (month/12)+"年"+(month%12)+"月"+day+"天");
		
		bo.setAttributeValue("email_or_msg","0");
	}
	
	public List<BusinessObject> group(List<BusinessObject> boList)
			throws Exception {
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
				//tempBo.setAttributeValue("ContractArtificialNo", tempBo.getString("ContractArtificialNo")+","+bo.getString("ContractArtificialNo"));
				//tempBo.setAttributeValue("CertID", tempBo.getString("CertID")+","+bo.getString("CertID"));
				BizObjectManager bmcl=JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_LIST");
				BizObjectQuery boqcl = bmcl.createQuery("SerialNo in(select AR.ObjectNo from jbo.app.APPLY_RELATIVE AR where AR.ApplySerialNo = :ApplySerialNo and AR.ObjectType = :ObjectType and AR.RelativeType = :RelativeType)");
				boqcl.setParameter("ObjectType", "jbo.customer.CUSTOMER_LIST");
				boqcl.setParameter("ApplySerialNo", tempBo.getString("ObjectNo"));
				boqcl.setParameter("RelativeType", "08");
				
				BizObject bocl = boqcl.getSingleResult(false);
				if(bocl!=null)
				{
					tempBo.setAttributeValue("CustomerName",bocl.getAttribute("CustomerName").getString());
				}
			}
		}
		
		return returnList;
	}


	public void cancel(String key, BusinessObjectManager bomanager) throws Exception {
		
	}

	
	public void finish(String key, BusinessObjectManager bomanager) throws Exception {
		
		
	}
	
}
