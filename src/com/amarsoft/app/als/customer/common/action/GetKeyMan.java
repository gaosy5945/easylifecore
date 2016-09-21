/**
 * 
 */
package com.amarsoft.app.als.customer.common.action;

import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

/**
 * @author yzheng 2013/05/29
 * 
 */
public class GetKeyMan {
	private String customerID;
	
	public String getCustomerID() {
		return customerID;
	}

	public void setCustomerID(String customerID) {
		this.customerID = customerID;
	}

	/**
	 * 
	 */
	public GetKeyMan() {
		// TODO Auto-generated constructor stub
	}

	/**
	 * @return hasKeyMan	是否已经存在一名法人代表（高管）
	 */
	public String hasKeyMan(JBOTransaction tx) throws Exception{
		boolean hasKeyMan = false;
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_RELATIVE");
		tx.join(bm);
		BizObjectQuery query = bm.createQuery("select count(*) as v.keyManNum from O where CustomerId = :CustomerId  and RelationShip = '0100'").setParameter("CustomerId", customerID);
		@SuppressWarnings("unchecked")
		List<BizObject> bos = query.getResultList(false);
		if(bos!=null){
			BizObject bo = bos.get(0);
			if(Integer.parseInt(bo.getAttribute("keyManNum").getString()) > 0){  //存在一名法人代表(高管)
				hasKeyMan = true;
			}
		}
		return (hasKeyMan == true) ? "true": "false";
	}
}
