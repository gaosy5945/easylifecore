package com.amarsoft.app.workflow.interdata;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.config.impl.SystemDBConfig;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.app.als.sys.tools.SYSNameManager;
import com.amarsoft.app.workflow.util.FlowHelper;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.dict.als.cache.NameCache;
import com.amarsoft.dict.als.manage.NameManager;

/**
 * 通过对象类型、对象编号获取对象基础信息
 * @author 赵晓建
 */

public class ApplyData implements IData {

	@Override
	public List<BusinessObject> getFlowObjects(String objectType,BusinessObjectManager bomanager,Object... parameters) throws Exception{
		String sql = "select v.O.*,v.CI.*,v.FO.* from O,jbo.customer.CUSTOMER_INFO CI,jbo.flow.FLOW_OBJECT FO "+
					 " where O.CustomerID = CI.CustomerID and O.SerialNo = FO.ObjectNo "+
					 " and FO.ObjectType ='jbo.app.BUSINESS_APPLY' and FO.FlowSerialNo in (:FlowSerialNo) ";
		return bomanager.loadBusinessObjects("jbo.app.BUSINESS_APPLY",sql,parameters);
	}
	
	
	@Override
	public List<BusinessObject> getObjects(String objectType,BusinessObjectManager bomanager,Object... parameters) throws Exception{
		String sql = "select v.O.*,v.CI.* from O,jbo.customer.CUSTOMER_INFO CI "+
					 " where O.CustomerID = CI.CustomerID "+
					 " and O.SerialNo in (:SerialNo)"; 
		return bomanager.loadBusinessObjects("jbo.app.BUSINESS_APPLY", sql, parameters);
		
	}
	
	public void transfer(BusinessObject bo) throws Exception {
		if(bo ==  null) return;
		
		bo.setAttributeValue("CertTypeName", NameManager.getItemName("CustomerCertType", bo.getString("CertType")));
		bo.setAttributeValue("OperateUserName", NameManager.getUserName(bo.getString("OperateUserID")));
		bo.setAttributeValue("OperateOrgName", SystemDBConfig.getOrg(bo.getString("OperateOrgID")).getString("OrgName"));
		bo.setAttributeValue("OrgLevel", SystemDBConfig.getOrg(bo.getString("OperateOrgID")).getString("OrgLevel"));
		bo.setAttributeValue("BusinessTypeName", NameCache.getName("PRD_PRODUCT_LIBRARY","PRODUCTNAME","PRODUCTID",bo.getString("BusinessType")));//com.amarsoft.dict.als.cache.NameCache.getName('PRD_PRODUCT_LIBRARY','PRODUCTNAME','PRODUCTID',BUSINESSTYPE)
		bo.setAttributeValue("ProductName", SYSNameManager.getProductName(bo.getString("ProductID")));
		bo.setAttributeValue("MarketChannelFlagName", NameManager.getItemName("MarketChannelFlag", bo.getString("MarketChannelFlag")));
		bo.setAttributeValue("LoanSerialNo", bo.getString("DuebillSerialNo"));
		bo.setAttributeValue("TaskName", "贷款申请");
		bo.setAttributeValue("ImageFlag","");
		
		BizObjectManager arm = JBOFactory.getBizObjectManager("jbo.app.APPLY_RELATIVE");
		BizObjectQuery arq = arm.createQuery("ApplySerialNo= :ApplySerialNo and RelativeType=:RelativeType");
		arq.setParameter("ApplySerialNo", bo.getString("ObjectNo"));
		arq.setParameter("RelativeType", "06");
		List<BizObject> arList = arq.getResultList(false);
		if(arList != null && !arList.isEmpty())
		{
			bo.setAttributeValue("TaskName", "贷款支用申请");
			BusinessObject ba = BusinessObject.createBusinessObject("jbo.app.BUSINESS_APPLY");
			ba.setAttributesValue(bo);
			bo.setAttributeValue("ImageFlag", FlowHelper.getImageFlag(ba));
		}
		
		//放款监督
		if("loancontrol".equalsIgnoreCase(bo.getString("PhaseNo")) || "loanexamine".equalsIgnoreCase(bo.getString("PhaseNo")))
		{
			String applySerialNo = bo.getString("ObjectNo");
			BizObjectManager bpm = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_PUTOUT");
			BizObjectQuery bpq = bpm.createQuery("ApplySerialNo= :ApplySerialNo ");
			bpq.setParameter("ApplySerialNo", applySerialNo);
			BizObject bp = bpq.getSingleResult(false);
			if(bp != null )
			{
				bo.setAttributeValue("BusinessSum", bp.getAttribute("BusinessSum").getDouble());
				bo.setAttributeValue("BusinessTerm", bp.getAttribute("BusinessTerm").getInt());
				bo.setAttributeValue("BusinessTermDay", bp.getAttribute("BusinessTermDay").getDouble());
			}
			else
			{
				BizObjectManager bcm = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_CONTRACT");
				BizObjectQuery bcq = bcm.createQuery("ApplySerialNo= :ApplySerialNo ");
				bcq.setParameter("ApplySerialNo", applySerialNo);
				BizObject bc = bcq.getSingleResult(false);
				if(bc != null)
				{
					bo.setAttributeValue("BusinessSum", bc.getAttribute("BusinessSum").getDouble());
					bo.setAttributeValue("BusinessTerm", bc.getAttribute("BusinessTerm").getInt());
					bo.setAttributeValue("BusinessTermDay", bc.getAttribute("BusinessTermDay").getDouble());
				}
			}
		}
		int month = bo.getInt("BusinessTerm");
		int day = bo.getInt("BusinessTermDay");
		String maturityDate = bo.getString("MaturityDate");
		if(month == 0 && day == 0 && maturityDate != null && !"".equals(maturityDate))
		{
			month = (int)Math.floor(DateHelper.getMonths(DateHelper.getBusinessDate(), maturityDate));
			day = DateHelper.getDays(DateHelper.getRelativeDate(DateHelper.getBusinessDate(), DateHelper.TERM_UNIT_MONTH, month), maturityDate);
		}
		
		bo.setAttributeValue("BusinessTerm", (month/12)+"年"+(month%12)+"月"+day+"天");
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
				/*
				BizObjectManager bmcl=JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_LIST");
				BizObjectQuery boqcl = bmcl.createQuery("SerialNo in(select AR.ObjectNo from jbo.app.APPLY_RELATIVE AR where AR.ApplySerialNo = :ApplySerialNo and AR.ObjectType = :ObjectType and AR.RelativeType = :RelativeType)");
				boqcl.setParameter("ObjectType", "jbo.customer.CUSTOMER_LIST");
				boqcl.setParameter("ApplySerialNo", tempBo.getString("ObjectNo"));
				boqcl.setParameter("RelativeType", "08");
				
				BizObject bocl = boqcl.getSingleResult(false);
				if(bocl!=null)
				{
					tempBo.setAttributeValue("CustomerName",bocl.getAttribute("CustomerName").getString());
				}*/
			}
		}
		
		return returnList;
	}


	public void cancel(String key, BusinessObjectManager bomanager) throws Exception {
		
		bomanager.getBizObjectManager("jbo.app.BUSINESS_APPLY")
		.createQuery("update O set ApproveStatus = '00' where SerialNo = :SerialNo")
		.setParameter("SerialNo", key)
		.executeUpdate();
		
		bomanager.getBizObjectManager("jbo.app.BUSINESS_CONTRACT")
		.createQuery("update O set ContractStatus = '05' where ApplySerialNo = :SerialNo")
		.setParameter("SerialNo", key)
		.executeUpdate();
		
		bomanager.getBizObjectManager("jbo.app.BUSINESS_PUTOUT")
		.createQuery("update O set PutOutStatus = '04' where ApplySerialNo = :SerialNo")
		.setParameter("SerialNo", key)
		.executeUpdate();
		
		bomanager.getBizObjectManager("jbo.cl.CL_INFO")
		.createQuery("update O set Status = '50' where ObjectType = 'jbo.app.BUSINESS_CONTRACT' and ObjectNo = (select BC.SerialNo from jbo.app.BUSINESS_CONTRACT BC where BC.ApplySerialNo = :ApplySerialNo) and Status = '10'")
		.setParameter("ApplySerialNo", key)
		.executeUpdate();
		
		List<BizObject> resultList = bomanager.getBizObjectManager("jbo.app.APPLY_RELATIVE")
		.createQuery("select ObjectNo from O where ApplySerialNo = :ApplySerialNo and ObjectType = 'jbo.app.BUSINESS_APPLY'")
		.setParameter("ApplySerialNo", key).getResultList(false);
		for(int i=0;i<resultList.size();i++){
			bomanager.getBizObjectManager("jbo.app.BUSINESS_APPLY")
			.createQuery("update O set ApproveStatus = '00' where SerialNo = :SerialNo")
			.setParameter("SerialNo", resultList.get(i).getAttribute("ObjectNo").toString())
			.executeUpdate();
			
			bomanager.getBizObjectManager("jbo.app.BUSINESS_CONTRACT")
			.createQuery("update O set ContractStatus = '05' where ApplySerialNo = :SerialNo")
			.setParameter("SerialNo", resultList.get(i).getAttribute("ObjectNo").toString())
			.executeUpdate();
			
			bomanager.getBizObjectManager("jbo.app.BUSINESS_PUTOUT")
			.createQuery("update O set PutOutStatus = '04' where ApplySerialNo = :SerialNo")
			.setParameter("SerialNo", resultList.get(i).getAttribute("ObjectNo").toString())
			.executeUpdate();
			
			bomanager.getBizObjectManager("jbo.cl.CL_INFO")
			.createQuery("update O set Status = '50' where ObjectType = 'jbo.app.BUSINESS_CONTRACT' and ObjectNo = (select BC.SerialNo from jbo.app.BUSINESS_CONTRACT BC where BC.ApplySerialNo = :ApplySerialNo) and Status = '10'")
			.setParameter("ApplySerialNo", resultList.get(i).getAttribute("ObjectNo").toString())
			.executeUpdate();
		}
		List<BizObject> resultList08 = bomanager.getBizObjectManager("jbo.app.APPLY_RELATIVE")
		.createQuery("select ObjectNo from O where ApplySerialNo = :ApplySerialNo and ObjectType = 'jbo.customer.CUSTOMER_LIST' and RelativeType = '08'")
		.setParameter("ApplySerialNo", key).getResultList(false);
		for(int i=0;i<resultList08.size();i++){
			List<BizObject> resultList088 = bomanager.getBizObjectManager("jbo.app.APPLY_RELATIVE")
			.createQuery("select ApplySerialNo from O where ObjectType = 'jbo.customer.CUSTOMER_LIST' and RelativeType = '08' and ObjectNo = :ObjectNo")
			.setParameter("ObjectNo", resultList08.get(i).getAttribute("ObjectNo").toString()).getResultList(false);
			for(int j=0;j<resultList088.size();j++){
				bomanager.getBizObjectManager("jbo.app.BUSINESS_APPLY")
				.createQuery("update O set ApproveStatus = '00' where SerialNo = :SerialNo")
				.setParameter("SerialNo", resultList088.get(i).getAttribute("ApplySerialNo").toString())
				.executeUpdate();
				
				bomanager.getBizObjectManager("jbo.app.BUSINESS_CONTRACT")
				.createQuery("update O set ContractStatus = '05' where ApplySerialNo = :SerialNo")
				.setParameter("SerialNo", resultList088.get(i).getAttribute("ApplySerialNo").toString())
				.executeUpdate();
				
				bomanager.getBizObjectManager("jbo.app.BUSINESS_PUTOUT")
				.createQuery("update O set PutOutStatus = '04' where ApplySerialNo = :SerialNo")
				.setParameter("SerialNo", resultList088.get(i).getAttribute("ApplySerialNo").toString())
				.executeUpdate();
				
				bomanager.getBizObjectManager("jbo.cl.CL_INFO")
				.createQuery("update O set Status = '50' where ObjectType = 'jbo.app.BUSINESS_CONTRACT' and ObjectNo = (select BC.SerialNo from jbo.app.BUSINESS_CONTRACT BC where BC.ApplySerialNo = :ApplySerialNo) and Status = '10'")
				.setParameter("ApplySerialNo", resultList088.get(i).getAttribute("ApplySerialNo").toString())
				.executeUpdate();
			}
				
		}
	}

	
	public void finish(String key, BusinessObjectManager bomanager) throws Exception {

		bomanager.getBizObjectManager("jbo.app.BUSINESS_APPLY")
		.createQuery("update O set ApproveStatus = '05' where SerialNo = :SerialNo")
		.setParameter("SerialNo", key)
		.executeUpdate();
		
		bomanager.getBizObjectManager("jbo.app.BUSINESS_CONTRACT")
		.createQuery("update O set ContractStatus = '05' where ApplySerialNo = :SerialNo")
		.setParameter("SerialNo", key)
		.executeUpdate();
		
		bomanager.getBizObjectManager("jbo.app.BUSINESS_PUTOUT")
		.createQuery("update O set PutOutStatus = '04' where ApplySerialNo = :SerialNo")
		.setParameter("SerialNo", key)
		.executeUpdate();
		
		bomanager.getBizObjectManager("jbo.cl.CL_INFO")
		.createQuery("update O set Status = '50' where ObjectType = 'jbo.app.BUSINESS_CONTRACT' and ObjectNo = (select BC.SerialNo from jbo.app.BUSINESS_CONTRACT BC where BC.ApplySerialNo = :ApplySerialNo) and Status = '10'")
		.setParameter("ApplySerialNo", key)
		.executeUpdate();
		
		List<BizObject> resultList = bomanager.getBizObjectManager("jbo.app.APPLY_RELATIVE")
		.createQuery("select ObjectNo from O where ApplySerialNo = :ApplySerialNo and ObjectType = 'jbo.app.BUSINESS_APPLY'")
		.setParameter("ApplySerialNo", key).getResultList(false);
		for(int i=0;i<resultList.size();i++){
			bomanager.getBizObjectManager("jbo.app.BUSINESS_APPLY")
			.createQuery("update O set ApproveStatus = '05' where SerialNo = :SerialNo")
			.setParameter("SerialNo", resultList.get(i).getAttribute("ObjectNo").toString())
			.executeUpdate();
			
			bomanager.getBizObjectManager("jbo.app.BUSINESS_CONTRACT")
			.createQuery("update O set ContractStatus = '05' where ApplySerialNo = :SerialNo")
			.setParameter("SerialNo", resultList.get(i).getAttribute("ObjectNo").toString())
			.executeUpdate();
			
			bomanager.getBizObjectManager("jbo.app.BUSINESS_PUTOUT")
			.createQuery("update O set PutOutStatus = '04' where ApplySerialNo = :SerialNo")
			.setParameter("SerialNo", resultList.get(i).getAttribute("ObjectNo").toString())
			.executeUpdate();
			
			bomanager.getBizObjectManager("jbo.cl.CL_INFO")
			.createQuery("update O set Status = '50' where ObjectType = 'jbo.app.BUSINESS_CONTRACT' and ObjectNo = (select BC.SerialNo from jbo.app.BUSINESS_CONTRACT BC where BC.ApplySerialNo = :ApplySerialNo) and Status = '10'")
			.setParameter("ApplySerialNo", resultList.get(i).getAttribute("ObjectNo").toString())
			.executeUpdate();
		}
		List<BizObject> resultList08 = bomanager.getBizObjectManager("jbo.app.APPLY_RELATIVE")
		.createQuery("select ObjectNo from O where ApplySerialNo = :ApplySerialNo and ObjectType = 'jbo.customer.CUSTOMER_LIST' and RelativeType = '08'")
		.setParameter("ApplySerialNo", key).getResultList(false);
		for(int i=0;i<resultList08.size();i++){
			List<BizObject> resultList088 = bomanager.getBizObjectManager("jbo.app.APPLY_RELATIVE")
			.createQuery("select ApplySerialNo from O where ObjectType = 'jbo.customer.CUSTOMER_LIST' and RelativeType = '08' and ObjectNo = :ObjectNo")
			.setParameter("ObjectNo", resultList08.get(i).getAttribute("ObjectNo").toString()).getResultList(false);
			for(int j=0;j<resultList088.size();j++){
				bomanager.getBizObjectManager("jbo.app.BUSINESS_APPLY")
				.createQuery("update O set ApproveStatus = '05' where SerialNo = :SerialNo")
				.setParameter("SerialNo", resultList088.get(i).getAttribute("ApplySerialNo").toString())
				.executeUpdate();
				
				bomanager.getBizObjectManager("jbo.app.BUSINESS_CONTRACT")
				.createQuery("update O set ContractStatus = '05' where ApplySerialNo = :SerialNo")
				.setParameter("SerialNo", resultList088.get(i).getAttribute("ApplySerialNo").toString())
				.executeUpdate();
				
				bomanager.getBizObjectManager("jbo.app.BUSINESS_PUTOUT")
				.createQuery("update O set PutOutStatus = '04' where ApplySerialNo = :SerialNo")
				.setParameter("SerialNo", resultList088.get(i).getAttribute("ApplySerialNo").toString())
				.executeUpdate();
				
				bomanager.getBizObjectManager("jbo.cl.CL_INFO")
				.createQuery("update O set Status = '50' where ObjectType = 'jbo.app.BUSINESS_CONTRACT' and ObjectNo = (select BC.SerialNo from jbo.app.BUSINESS_CONTRACT BC where BC.ApplySerialNo = :ApplySerialNo) and Status = '10'")
				.setParameter("ApplySerialNo", resultList088.get(i).getAttribute("ApplySerialNo").toString())
				.executeUpdate();
			}
		}
	}
}
