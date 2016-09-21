package com.amarsoft.acct.accounting.web;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.StringX;

public class GetAllowApplyFlag {
	private String transactionCode;
	private String relativeObjectType;
	private String relativeObjectNo;
	private String reverseSerialNo;//反冲交易流水

	public String getTransactionCode() {
		return transactionCode;
	}
	public void setTransactionCode(String transactionCode) {
		this.transactionCode = transactionCode;
	}
	public String getRelativeObjectType() {
		return relativeObjectType;
	}
	public void setRelativeObjectType(String relativeObjectType) {
		this.relativeObjectType = relativeObjectType;
	}
	public String getRelativeObjectNo() {
		return relativeObjectNo;
	}
	public void setRelativeObjectNo(String relativeObjectNo) {
		this.relativeObjectNo = relativeObjectNo;
	}
	public String getReverseSerialNo() {
		return reverseSerialNo;
	}

	public void setReverseSerialNo(String reverseSerialNo) {
		this.reverseSerialNo = reverseSerialNo;
	}
	//获取当前这笔交易是否存在
	public String getAllowApplyFlag(JBOTransaction tx) throws Exception{
		
		BusinessObjectManager bomanager =BusinessObjectManager.createBusinessObjectManager(tx);//创建对象管理器
		if(!StringX.isEmpty(reverseSerialNo))
		{
			BusinessObject document = bomanager.keyLoadBusinessObject(BUSINESSOBJECT_CONSTANTS.transaction, reverseSerialNo);
			relativeObjectType = document.getString("RelativeObjectType");
			relativeObjectNo = document.getString("RelativeObjectNo");
		}
		BizObjectQuery query = JBOFactory.getBizObjectManager("jbo.acct.ACCT_TRANSACTION",tx)
				.createQuery("RelativeObjectType =:ObjectType and " + 
				"RelativeObjectNo =:ObjectNo " +
				"and (TransStatus in('3','0') or TransStatus is null or TransStatus ='') " +
				"and :TransCode in('2001','2002','3001','3002','3003','3004','4001','4002','4003')")
				.setParameter("ObjectNo", relativeObjectNo)
				.setParameter("ObjectType", relativeObjectType)
				.setParameter("TransCode", transactionCode);
				 
		@SuppressWarnings("unchecked")
		List<BizObject> bos = query.getResultList(false);
 		if(bos==null || bos.size()<=0) return "true";
		return "false";
	}
}
