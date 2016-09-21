package com.amarsoft.app.als.customer.common.action;

import com.amarsoft.app.als.customer.model.CustomerInfo;
import com.amarsoft.app.als.customer.model.CustomerTel;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.JBOTransaction;


/**
 * �ͻ�����ģ��-�ͻ���ϵ�绰����
 * @author lyin 20140422
 *
 */
public class CustomerTelAction{
	private String customerID;
	private String telType;
	private String status;
	private String serialNo;
	
	/**
	 * �������͵绰�Ƿ��Ѵ���
	 * @return
	 * @throws Exception 
	 */
	public String checkCustomerTel(JBOTransaction tx) throws Exception{
		String result = "false";
		CustomerTel ct = new CustomerTel(tx,customerID,telType);
		BizObject bo = ct.getBizObject();
		if(bo!=null){
			result = "true";
		}
		return result;
	}
	
	/**
	 * ����ent_info��ind_info�����ϵ�绰
	 * @return
	 * @throws Exception 
	 */
	public void updateEntOrIndInfo(JBOTransaction tx,String customerID,String telType) throws Exception{
		CustomerInfo ci = new CustomerInfo(tx,customerID);
        String customerType = ci.getAttribute("CustomerType").toString();//�ͻ�����
        //���ݿͻ����������ָ���ent_info��ind_info
	}
	
	
	
	/**
	 * ����֤��״̬ʧЧ
	 * @return
	 * @throws Exception 
	 */
	public String setCustomerTelIsNew(JBOTransaction tx) throws Exception{
		CustomerTel ct = new CustomerTel(tx,serialNo);
		ct.setAttribute("IsNew", status);
		ct.saveObject();
		//updateEntOrIndInfo(tx,customerID,telType);
	    return "true";
	}
	
	public String getCustomerID() {
		return customerID;
	}

	public void setCustomerID(String customerID) {
		this.customerID = customerID;
	}


	public String getTelType() {
		return telType;
	}


	public void setTelType(String telType) {
		this.telType = telType;
	}


	public String getStatus() {
		return status;
	}


	public void setStatus(String status) {
		this.status = status;
	}


	public String getSerialNo() {
		return serialNo;
	}


	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}


	
	
	
}