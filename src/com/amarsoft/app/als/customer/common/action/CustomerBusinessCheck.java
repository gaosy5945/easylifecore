package com.amarsoft.app.als.customer.common.action;

import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;

/**
 * �ͻ���;ҵ����
 * @author wmZhu
 *
 */
public class CustomerBusinessCheck {
	
	private String customerID;
	
	/**
	 * ���ͻ��Ƿ����δ�������;ҵ������
	 * @return
	 * @throws Exception 
	 */
	public String checkBusinessApply() throws Exception{
		String result = "false";
		//�����ҵ������δ�鵵������Ϊ��δ����
		BizObjectManager bom = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_APPLY");
		int iResult = bom.createQuery("CustomerID=:customerID and PigeonholeDate is null")
						.setParameter("customerID", customerID).getTotalCount();
		if(iResult > 0) result = "true";
		return result;
	}
	
	/**
	 * ���ͻ��Ƿ��δ������ɵ�����
	 * @return
	 * @throws Exception 
	 */
	public String checkBusinessApprove() throws Exception{
		String result = "false";
		//�����ҵ������δ�鵵������Ϊ��δ����
		BizObjectManager bom = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_APPROVE");
		int iResult = bom.createQuery("CustomerID=:customerID and PigeonholeDate is null")
						.setParameter("customerID", customerID).getTotalCount();
		if(iResult > 0) result = "true";
		return result;
	}
	
	/**
	 * ���ͻ��Ƿ����δ���Ǽ���ɡ��ĺ�ͬ
	 * @return
	 * @throws Exception 
	 */
	public String checkBusinessContract() throws Exception{
		String result = "false";
		//�����ҵ������δ�鵵������Ϊ��δ����
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
