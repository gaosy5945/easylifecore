package com.amarsoft.app.workflow.interdata;


import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.dict.als.manage.NameManager;
import com.amarsoft.app.base.config.impl.SystemDBConfig;
import com.amarsoft.app.base.config.impl.TransactionConfig;
import com.amarsoft.app.base.trans.TransactionHelper;

/**
 * 通过对象类型、对象编号获取对象基础信息
 * @author 赵晓建
 */

public class BatchBusinessData implements IData {

	
	@Override
	public List<BusinessObject> getFlowObjects(String objectType,BusinessObjectManager bomanager,Object... parameters) throws Exception{
		String sql = "select v.BB.*,v.O.*,v.FO.* from jbo.app.BAT_BUSINESS BB,O,jbo.flow.FLOW_OBJECT FO "+
					 " where O.SerialNo = FO.ObjectNo and FO.ObjectType = 'jbo.acct.ACCT_TRANSACTION_BB' "+
					 " and O.RelativeObjectType = 'jbo.app.BAT_BUSINESS' and O.RelativeObjectNo = BB.SerialNo "+
					 " and FO.FlowSerialNo in(:FlowSerialNo) ";
		return bomanager.loadBusinessObjects("jbo.acct.ACCT_TRANSACTION", sql, parameters);
	}
	
	
	@Override
	public List<BusinessObject> getObjects(String objectType,BusinessObjectManager bomanager,Object... parameters) throws Exception{
		String sql = "select v.BB.*,v.O.* from jbo.app.BAT_BUSINESS BB,O "+
					 " where BB.SerialNo = O.RelativeObjectNo and O.RelativeObjectType = 'jbo.app.BAT_BUSINESS' "+
					 " and O.SerialNo in(:SerialNo)"; 
		return bomanager.loadBusinessObjects("jbo.acct.ACCT_TRANSACTION", sql, parameters);
		
	}
	
	public void transfer(BusinessObject bo) throws Exception {
		if(bo ==  null) return;
		String transCode = bo.getString("TransCode");
		bo.setAttributeValue("TransStatusName",NameManager.getItemName("TransactionStatus", bo.getString("TransStatus")));
		bo.setAttributeValue("InputUserName", NameManager.getUserName(bo.getString("InputUserID")));
		bo.setAttributeValue("InputOrgName", SystemDBConfig.getOrg(bo.getString("InputOrgID")).getString("OrgName"));
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
