package com.amarsoft.app.als.customer.common.action;

import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;

/**
 * 客户在途业务检查
 * @author wmZhu
 *
 */
public class CustomerBusinessCheck {
	
	private String customerID;
	
	/**
	 * 检查客户是否存在未结清的在途业务申请
	 * @return
	 * @throws Exception 
	 */
	public String checkBusinessApply() throws Exception{
		String result = "false";
		//如果有业务申请未归档，则认为是未结清
		BizObjectManager bom = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_APPLY");
		int iResult = bom.createQuery("CustomerID=:customerID and PigeonholeDate is null")
						.setParameter("customerID", customerID).getTotalCount();
		if(iResult > 0) result = "true";
		return result;
	}
	
	/**
	 * 检查客户是否存未审批完成的批复
	 * @return
	 * @throws Exception 
	 */
	public String checkBusinessApprove() throws Exception{
		String result = "false";
		//如果有业务申请未归档，则认为是未结清
		BizObjectManager bom = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_APPROVE");
		int iResult = bom.createQuery("CustomerID=:customerID and PigeonholeDate is null")
						.setParameter("customerID", customerID).getTotalCount();
		if(iResult > 0) result = "true";
		return result;
	}
	
	/**
	 * 检查客户是否存在未“登记完成”的合同
	 * @return
	 * @throws Exception 
	 */
	public String checkBusinessContract() throws Exception{
		String result = "false";
		//如果有业务申请未归档，则认为是未结清
		BizObjectManager bom = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_CONTRACT");
		int iResult = bom.createQuery("CustomerID=:customerID and FinishDate is null")
						.setParameter("customerID", customerID).getTotalCount();
		if(iResult > 0) result = "true";
		return result;
	}

	public String getCustomerID() {
		return customerID;
	}

	public void setCustomerID(String customerID) {
		this.customerID = customerID;
	}
	
}
