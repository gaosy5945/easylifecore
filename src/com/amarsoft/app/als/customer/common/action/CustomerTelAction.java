package com.amarsoft.app.als.customer.common.action;

import com.amarsoft.app.als.customer.model.CustomerInfo;
import com.amarsoft.app.als.customer.model.CustomerTel;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.JBOTransaction;


/**
 * 客户管理模块-客户联系电话处理
 * @author lyin 20140422
 *
 */
public class CustomerTelAction{
	private String customerID;
	private String telType;
	private String status;
	private String serialNo;
	
	/**
	 * 检查该类型电话是否已存在
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
	 * 更新ent_info或ind_info表的联系电话
	 * @return
	 * @throws Exception 
	 */
	public void updateEntOrIndInfo(JBOTransaction tx,String customerID,String telType) throws Exception{
		CustomerInfo ci = new CustomerInfo(tx,customerID);
        String customerType = ci.getAttribute("CustomerType").toString();//客户类型
        //根据客户类型来区分更新ent_info或ind_info
	}
	
	
	
	/**
	 * 设置证件状态失效
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