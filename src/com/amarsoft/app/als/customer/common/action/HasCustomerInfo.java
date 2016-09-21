package com.amarsoft.app.als.customer.common.action;

import com.amarsoft.app.als.customer.model.CustomerInfo;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOTransaction;

/**
 * 特殊客户名单处理类
 * @author gfTang 
 * ALS743升级 20140416
 *
 */
public class HasCustomerInfo {
	String customerID;
	
	public String getCustomerID() {
		return customerID;
	}

	public void setCustomerID(String customerID) {
		this.customerID = customerID;
	}

	/**
	 * 根据customerID判断该客户在customer_Info中是否存在
	 * @param customerID
	 * @return
	 */
	public String hasCustOrNot(JBOTransaction tx){
		BizObjectManager bm;
		try {
			CustomerInfo ci=new CustomerInfo(tx,customerID);
			BizObject  bo=ci.getBizObject();
			if(bo!=null){
				return "SUCCEED";
			}
		} catch (JBOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return "FAILED";
	}

}
