package com.amarsoft.app.workflow.interdata;


import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.app.als.sys.tools.SYSNameManager;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.dict.als.manage.NameManager;
import com.amarsoft.app.base.config.impl.SystemDBConfig;
import com.amarsoft.app.base.config.impl.TransactionConfig;
import com.amarsoft.app.base.trans.TransactionHelper;

/**
 * 通过对象类型、对象编号获取对象基础信息
 * @author 赵晓建
 */

public class TransactionData implements IData {

	
	@Override
	public List<BusinessObject> getFlowObjects(String objectType,BusinessObjectManager bomanager,Object... parameters) throws Exception{
		String sql = "select v.CI.*,v.BC.*,v.AL.*,v.FO.*,v.O.* from jbo.app.BUSINESS_CONTRACT BC,jbo.acct.ACCT_LOAN AL, O,jbo.customer.CUSTOMER_INFO CI,jbo.flow.FLOW_OBJECT FO "+
					 " where BC.SerialNo=AL.ContractSerialNo and O.SerialNo = FO.ObjectNo and FO.ObjectType = 'jbo.acct.ACCT_TRANSACTION' and AL.CustomerID=CI.CustomerID "+
					 " and O.RelativeObjectType = 'jbo.acct.ACCT_LOAN' and O.RelativeObjectNo = AL.SerialNo "+
					 " and FO.FlowSerialNo in(:FlowSerialNo) ";
		return bomanager.loadBusinessObjects("jbo.acct.ACCT_TRANSACTION", sql, parameters);
	}
	
	
	@Override
	public List<BusinessObject> getObjects(String objectType,BusinessObjectManager bomanager,Object... parameters) throws Exception{
		String sql = "select v.CI.*,v.BC.*,v.AL.*,v.O.* from jbo.app.BUSINESS_CONTRACT BC,jbo.acct.ACCT_LOAN AL,O,jbo.customer.CUSTOMER_INFO CI "+
					 " where BC.SerialNo=AL.ContractSerialNo and AL.CustomerID = CI.CustomerID and AL.SerialNo = O.RelativeObjectNo and O.RelativeObjectType = 'jbo.acct.ACCT_LOAN' "+
					 " and O.SerialNo in(:SerialNo)"; 
		return bomanager.loadBusinessObjects("jbo.acct.ACCT_TRANSACTION", sql, parameters);
		
	}
	
	public void transfer(BusinessObject bo) throws Exception {
		if(bo ==  null) return;
		String relativeObjectNo = bo.getString("RelativeObjectNo");
		String transCode = bo.getString("TransCode");
		bo.setAttributeValue("TransStatusName",NameManager.getItemName("TransactionStatus", bo.getString("TransStatus")));
		bo.setAttributeValue("CertTypeName", NameManager.getItemName("CustomerCertType", bo.getString("CertType")));
		bo.setAttributeValue("OperateUserName", NameManager.getUserName(bo.getString("OperateUserID")));
		bo.setAttributeValue("OperateOrgName", SystemDBConfig.getOrg(bo.getString("OperateOrgID")).getString("OrgName"));
		bo.setAttributeValue("OrgLevel", SystemDBConfig.getOrg(bo.getString("OperateOrgID")).getString("OrgLevel"));
		bo.setAttributeValue("BusinessTypeName", SYSNameManager.getProductName(bo.getString("BusinessType")));
		bo.setAttributeValue("ProductName", SYSNameManager.getProductName(bo.getString("ProductID")));
		bo.setAttributeValue("MarketChannelFlagName", NameManager.getItemName("MarketChannelFlag", bo.getString("MarketChannelFlag")));
		
		int month = (int)Math.floor(DateHelper.getMonths(bo.getString("PutOutDate"), bo.getString("MaturityDate")));
		int day = DateHelper.getDays(DateHelper.getRelativeDate(bo.getString("PutOutDate"), DateHelper.TERM_UNIT_MONTH, month), bo.getString("MaturityDate"));
		bo.setAttributeValue("BusinessTerm", (month/12)+"年"+(month%12)+"月"+day+"天");
		bo.setAttributeValue("LoanSerialNo", relativeObjectNo);
		bo.setAttributeValue("ContractArtificialNo", bo.getString("ContractSerialNo"));
		bo.setAttributeValue("TaskName",  TransactionConfig.getTransactionConfig(transCode).getString("TransactionName"));

	}

	public List<BusinessObject> group(List<BusinessObject> boList)
			throws Exception {
		return boList;
	}
	
	public void cancel(String key, BusinessObjectManager bomanager) throws Exception {
		TransactionHelper.deleteTransaction(key, bomanager);
	}
	
	public void finish(String key, BusinessObjectManager bomanager) throws Exception {
		BizObjectManager bom = bomanager.getBizObjectManager("jbo.acct.ACCT_TRANSACTION");
		bom.createQuery("update O set TransStatus = '2' where SerialNo=:SerialNo").setParameter("SerialNo", key).executeUpdate();
	}

}
