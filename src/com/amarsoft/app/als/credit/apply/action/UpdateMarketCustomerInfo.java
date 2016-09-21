package com.amarsoft.app.als.credit.apply.action;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

public class UpdateMarketCustomerInfo {

	private String userID;
	private String orgID;
	private String customerID;
	private String flowStatus;
	
	public String getUserID() {
		return userID;
	}

	public String getCustomerID() {
		return customerID;
	}

	public void setCustomerID(String customerID) {
		this.customerID = customerID;
	}

	public void setUserID(String userID) {
		this.userID = userID;
	}

	public String getOrgID() {
		return orgID;
	}

	public void setOrgID(String orgID) {
		this.orgID = orgID;
	}

	public String getApplySerialNo() {
		return customerID;
	}

	public void setApplySerialNo(String applySerialNo) {
		this.customerID = applySerialNo;
	}

	public String getFlowStatus() {
		return flowStatus;
	}

	public void setFlowStatus(String flowStatus) {
		this.flowStatus = flowStatus;
	}

	/**
	 * 生成客户状态，返回客户的ID
	 * @param tx
	 * @throws Exception
	 */
	public String update(JBOTransaction tx) throws Exception{
		//查询申请基本信息
		BizObjectManager bam = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_INFO");
		BizObjectManager blm = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_LIST");
		BizObjectManager bpm = JBOFactory.getBizObjectManager("jbo.prj.PRJ_BASIC_INFO");
		tx.join(bam);
		tx.join(blm);
		tx.join(bpm);
		BizObjectQuery baq = bam.createQuery("customerID=:customerID");
		baq.setParameter("customerID", customerID);
		BizObjectQuery blq = blm.createQuery("customerID=:customerID");
		blq.setParameter("customerID", customerID);
		BizObject ba = baq.getSingleResult(true);
		BizObject bl = blq.getSingleResult(true);
		//设置BA审批状态
		if("2".equals(flowStatus))
		{
			bpm.createQuery("update O set status='12' where status='11' and customerid=:customerID")
				.setParameter("customerID",customerID)
				.executeUpdate();
		}
		else if("3".equals(flowStatus)){
			BizObjectManager bom = JBOFactory.getBizObjectManager("jbo.acct.ACCT_BUSINESS_ACCOUNT");
			tx.join(bom);
			bom.createQuery("update O set status='1' where status = '0' and objecttype='jbo.customer.CUSTOMER_LIST' and objectno=:customerID")
				.setParameter("customerID",customerID).executeUpdate();
			bl.setAttributeValue("Status", "2");
			ba.setAttributeValue("Status", "02");
			bam.saveObject(ba);
			blm.saveObject(bl);
			bpm.createQuery("update O set status='13' where status ='12' and customerid=:customerID")
				.setParameter("customerID",customerID)
				.executeUpdate();
		}
		if("0".equals(flowStatus))
		{
			bpm.createQuery("update O set status='14' where status='12' and customerid=:customerID")
				.setParameter("customerID",customerID)
				.executeUpdate();
		}
		return ba.getAttribute("customerID").getString();
	}
}
