package com.amarsoft.app.als.customer.common.action;

import com.amarsoft.app.als.customer.model.CustomerAddress;
import com.amarsoft.app.als.customer.model.CustomerInfo;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.JBOTransaction;


/**
 * �ͻ�����ģ��-�ͻ���ϵ��ַ����
 * @author lyin 20140422
 *
 */
public class CustomerAddressAction{
	private String customerID;
	private String addType;
	private String status;
	private String serialNo;
	
	/**
	 * �������͵�ַ�Ƿ��Ѵ���
	 * @return
	 * @throws Exception 
	 */
	public String checkCustomerAddress(JBOTransaction tx) throws Exception{
		String result = "false";
		CustomerAddress ct = new CustomerAddress(tx,customerID,addType);
		BizObject bo = ct.getBizObject();
		if(bo!=null){
			result = "true";
		}
		return result;
	}
	
	/**
	 * �������͵�ַ�Ƿ��Ѵ���
	 * @return
	 * @throws Exception 
	 */
	public String checkIsAdd(JBOTransaction tx) throws Exception{
		String result = "false";
		CustomerAddress ct = new CustomerAddress(tx,customerID,"");
		BizObject bo = ct.getBizObject();
		if(bo!=null){
			result = "true";
		}
		return result;
	}
	
	/**
	 * ����ent_info��ind_info�����ϵ��ַ
	 * @return
	 * @throws Exception 
	 */
	public void updateEntOrIndInfo(JBOTransaction tx,String customerID,String addType) throws Exception{
		CustomerInfo ci = new CustomerInfo(tx,customerID);
        String customerType = ci.getAttribute("CustomerType").toString();//�ͻ�����
        //���ݿͻ����������ָ���ent_info��ind_info
	}
	
	/**
	 * ������ϵ��ַ�Ƿ�Ϊ����
	 * @return
	 * @throws Exception 
	 */
	public String setCustomerAddressIsNew(JBOTransaction tx) throws Exception{
		CustomerAddress ca = new CustomerAddress(tx,serialNo);
		ca.setAttribute("IsNew", status);
		ca.saveObject();
		//updateEntOrIndInfo(tx,customerID,addType);
	    return "true";
	}
	
	/**
	 * ������ϵ��ַ�Ƿ�ΪͨѶ��ַ
	 * @return
	 * @throws Exception 
	 */
	public String setCustomerAddressIsAdd(JBOTransaction tx) throws Exception{
		CustomerAddress ca = new CustomerAddress(tx,serialNo);
		ca.setAttribute("IsAdd", status);
		ca.saveObject();
	    return "true";
	}
	public String getCustomerID() {
		return customerID;
	}

	public void setCustomerID(String customerID) {
		this.customerID = customerID;
	}


	public String getAddType() {
		return addType;
	}


	public void setAddType(String addType) {
		this.addType = addType;
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